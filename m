Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61824744116
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 19:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbjF3RVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 13:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbjF3RVq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 13:21:46 -0400
Received: from out-1.mta1.migadu.com (out-1.mta1.migadu.com [IPv6:2001:41d0:203:375::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3BD1996
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 10:21:43 -0700 (PDT)
Date:   Fri, 30 Jun 2023 17:21:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688145701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A0mPPdxkOT9iMRRMTKH6KrkJnOAUidY1ftIlS1g9iTY=;
        b=SlwHZyv/ZqndEvudSAcLtIsPQxxs+m0GBXLCrP9yRlVBLHUjGzSkzBVXBfINUt0LSY7V2p
        Yh9SVcqPP8nLiZ27BlX0nYGByyJC9Z/Hb0oYEoSr5PbM558LgPBfeRU2WmsQCFa4oTu+Oh
        PTXex1FpSDiPHi6uDwv8sjfj67r+wws=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/tsc: Update guest tsc_offset again before vcpu
 first runs
Message-ID: <ZJ8PIbHfhc0oYB8/@linux.dev>
References: <20230629164838.66847-1-likexu@tencent.com>
 <ZJ29KhiVLyAq/7Sh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJ29KhiVLyAq/7Sh@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023 at 10:19:38AM -0700, Sean Christopherson wrote:
> +Oliver

It has been a while since I've looked at any x86 code, so forgive any
ignorance :)

> On Fri, Jun 30, 2023, Like Xu wrote:
> > From: Like Xu <likexu@tencent.com>
> > 
> > When a new vcpu is created and subsequently restored by vcpu snapshot,
> > apply kvm_vcpu_write_tsc_offset() before vcpu runs for the first time.
> > 
> > Before a vcpu runs for the first time, the user space (VMM) sets the guest
> > tsc as it wants, which may triggers the time synchronization mechanism with
> > other vcpus (if any). In a scenario where a vcpu snapshot is used to
> > restore, like the bugzilla report [*], the newly target guest tsc (e.g.
> > at the time of vcpu restoration) is synchronized with its the most
> > primitive guest timestamp initialized at the time of vcpu creation.
> > 
> > Furthermore, the VMM can actually update the target guest tsc multiple
> > times before the vcpu actually gets running, which requires the tsc_offset
> > to be updated every time it is set. In this scenario, it can be considered
> > as unstable tsc (even this vcpu has not yet even started ticking to follow
> > the intended logic of KVM timer emulation).
> > 
> > It is only necessary to delay this step until kvm_arch_vcpu_load() to
> > catch up with guest expectation with the help of kvm_vcpu_has_run(),
> > and the change is expected to not break any of the cumbersome existing
> > virt timer features.

The bug description is a bit difficult to grok, IMO. My understanding is
something like the following:

 1) Create VM_0 and save state within 1 second of creation

 2) Create VM_1 and restore state from VM_0

 3) Guest TSCs synchronize with the TSC value resulting from the vCPU
 creation in VM_1 instead of the expected value in the snapshot.

Generalizing -- restoring a vCPU that was saved within a second of its
creation leads to KVM ignoring the user-written TSC value.

Or am I entirely lost?

> > Reported-by: Yong He <alexyonghe@tencent.com>
> > Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217423 [*] 
> > Tested-by: Jinrong Liang <cloudliang@tencent.com>
> > Signed-off-by: Like Xu <likexu@tencent.com>
> > ---
> >  arch/x86/kvm/x86.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 439312e04384..616940fc3791 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4818,7 +4818,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  		if (tsc_delta < 0)
> >  			mark_tsc_unstable("KVM discovered backwards TSC");
> >  
> > -		if (kvm_check_tsc_unstable()) {
> > +		if (kvm_check_tsc_unstable() || !kvm_vcpu_has_run(vcpu)) {
> >  			u64 offset = kvm_compute_l1_tsc_offset(vcpu,
> >  						vcpu->arch.last_guest_tsc);
> >  			kvm_vcpu_write_tsc_offset(vcpu, offset);
> 
> Doing this on every vCPU load feels all kinds of wrong, e.g. it will override the
> value set by userspace via KVM_VCPU_TSC_OFFSET.  One could argue the KVM is "helping"
> userspace by providing a more up-to-date offset for the guest, but "helping"
> userspace by silently overriding userspace rarely ends well.
> 
> Can't we instead just fix the heuristic that tries to detect synchronization?
> 
> ---
>  arch/x86/kvm/x86.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c30364152fe6..43d40f058a41 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2721,14 +2721,14 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>  			 * kvm_clock stable after CPU hotplug
>  			 */
>  			synchronizing = true;
> -		} else {
> +		} else if (kvm_vcpu_has_run(vcpu)) {
>  			u64 tsc_exp = kvm->arch.last_tsc_write +
>  						nsec_to_cycles(vcpu, elapsed);
>  			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
>  			/*
>  			 * Special case: TSC write with a small delta (1 second)
> -			 * of virtual cycle time against real time is
> -			 * interpreted as an attempt to synchronize the CPU.
> +			 * of virtual cycle time against real time on a running
> +			 * vCPU is interpreted as an attempt to synchronize.
>  			 */
>  			synchronizing = data < tsc_exp + tsc_hz &&
>  					data + tsc_hz > tsc_exp;

This would break existing save/restore patterns for the TSC. QEMU relies
on KVM synchronizing the TSCs when restoring a VM, since it cannot
snapshot the TSC values of all the vCPUs in a single instant. It instead
tries to save the TSCs at roughly the same time [*], which KVM detects
on the target and gets everything back in sync. Can't wait to see when
this heuristic actually breaks :)

It's gonna be a hack no matter how we go about fixing this, but the root
of the problem is that KVM-initiated TSC changes are synchronizing with
userpsace-initiated TSC changes. Why not force a new TSC sync generation
(i.e. set @synchronizing to false) for the first user-initiated write to
the TSC MSR?

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 808c292ad3f4..8bb27ad0af53 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1321,6 +1321,7 @@ struct kvm_arch {
 	u64 cur_tsc_offset;
 	u64 cur_tsc_generation;
 	int nr_vcpus_matched_tsc;
+	bool user_changed_tsc;
 
 	u32 default_tsc_khz;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7713420abab0..1fe24bbc28f4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2668,7 +2668,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	kvm_track_tsc_matching(vcpu);
 }
 
-static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
+static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data, bool user_initiated)
 {
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
@@ -2689,20 +2689,29 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 			 * kvm_clock stable after CPU hotplug
 			 */
 			synchronizing = true;
-		} else {
+		} else if (kvm->arch.user_changed_tsc) {
 			u64 tsc_exp = kvm->arch.last_tsc_write +
 						nsec_to_cycles(vcpu, elapsed);
 			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
 			/*
-			 * Special case: TSC write with a small delta (1 second)
-			 * of virtual cycle time against real time is
-			 * interpreted as an attempt to synchronize the CPU.
+			 * Here lies UAPI baggage: user-initiated TSC write with
+			 * a small delta (1 second) of virtual cycle time
+			 * against real time is interpreted as an attempt to
+			 * synchronize the CPU.
+			 *
+			 * Don't synchronize user changes to the TSC with the
+			 * KVM-initiated change in kvm_arch_vcpu_postcreate()
+			 * by conditioning this mess on userspace having
+			 * written the TSC at least once already.
 			 */
 			synchronizing = data < tsc_exp + tsc_hz &&
 					data + tsc_hz > tsc_exp;
 		}
 	}
 
+	if (user_initiated)
+		kvm->arch.user_changed_tsc = true;
+
 	/*
 	 * For a reliable TSC, we can match TSC offsets, and for an unstable
 	 * TSC, we add elapsed time in this computation.  We could let the
@@ -3695,7 +3704,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_TSC:
 		if (msr_info->host_initiated) {
-			kvm_synchronize_tsc(vcpu, data);
+			kvm_synchronize_tsc(vcpu, data, true);
 		} else {
 			u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
 			adjust_tsc_offset_guest(vcpu, adj);
@@ -11832,7 +11841,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	if (mutex_lock_killable(&vcpu->mutex))
 		return;
 	vcpu_load(vcpu);
-	kvm_synchronize_tsc(vcpu, 0);
+	kvm_synchronize_tsc(vcpu, 0, false);
 	vcpu_put(vcpu);
 
 	/* poll control enabled by default */

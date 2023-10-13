Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFEBA7C8CC9
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 20:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjJMSHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 14:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjJMSHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 14:07:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC605BB
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 11:07:46 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9a3e5f1742so3441762276.0
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 11:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697220466; x=1697825266; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PvKDPaw+QIOESW8HQR3wI94B1SCpRWY2eOMQFgHhpck=;
        b=nmhyQiCqVql4HRLeehIy6wJ7VM1jYk+Bry3frLK/qUnfQgKwzXeAXeRtUrbKh89Iyj
         kNy8Iw8uiR3KSxkHRB+5HnuntAZNV/0CQ9msf6/VbUGM1TNtYh4ma1LENo2HJq7ON/aV
         w0ifyAJUAie2AZN2PnhJPKuhiOfk52uWsmEOOQe9Q+l8f0YdeFaXi0oWEucTFnh+67rE
         tICqjBek64YO/ALZn+zTB4OcN32BR4pv0LZ+yKP1+7N+AiI8DMCVHfeKq02hx6WT7Wuz
         kUVOopZJH21ysM+j/KniLUqIG1v6jASWtpzyF0rjmNXKMiGLaDgO1IPwbs2khwIZ7qXT
         MFQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697220466; x=1697825266;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PvKDPaw+QIOESW8HQR3wI94B1SCpRWY2eOMQFgHhpck=;
        b=QwW5xVWbNZI1s4M6cFEgILK0aBiejveYHfO3PUbkBKLhayU6RRPPvTP0prVvS9DeRX
         oxLh/GZP9BcNOF7ae55DNz3bWuEKjGL8IK4xt3FQMp0avH+aSAA/AEGmxrG+Hlrw1OIA
         RmPe1ff+nuI7LE7VHfqADt79+jJkurtauvarTdRfzVWYiYSEOW4PwAx3f1svl3/wKgMQ
         Si33p2zxyiwcauRNVk3kFZtxe/Zi6SxX+FU+36F0mvayNpfi8SxaGsekSN2gdGziqDzx
         qmBfQSH8OTuS1eKl208oN2WJGf+nylagJPIewN7TLmeAl0Y6AMv03VzYBhr/f4xuZX+p
         IZUg==
X-Gm-Message-State: AOJu0YwYYc80Gjkj2dmcBU3t9uBnSKJVGS+IIula3T+TYBRWW4mQFHVO
        oPVk5HlwHWM8VnXmCNmXH6QrfKFqH5w=
X-Google-Smtp-Source: AGHT+IGCiJa78jVmD9wzZk02a+k13vciXuotJPmPePzI1vR3bESQmSJ6CySHioa8DCCeFY/ISgbeFFQj2ZM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab24:0:b0:d9a:da96:f9ca with SMTP id
 u33-20020a25ab24000000b00d9ada96f9camr114009ybi.6.1697220465987; Fri, 13 Oct
 2023 11:07:45 -0700 (PDT)
Date:   Fri, 13 Oct 2023 11:07:44 -0700
In-Reply-To: <8f3493ca4c0e726d5c3876bb7dd2cfc432d9deaa.camel@infradead.org>
Mime-Version: 1.0
References: <ZRrxtagy7vJO5tgU@google.com> <52a3cea2084482fc67e35a0bf37453f84dcd6297.camel@infradead.org>
 <ZRtl94_rIif3GRpu@google.com> <9975969725a64c2ba2b398244dba3437bff5154e.camel@infradead.org>
 <ZRysGAgk6W1bpXdl@google.com> <d6dc1242ff731cf0f2826760816081674ade9ff9.camel@infradead.org>
 <ZR2pwdZtO3WLCwjj@google.com> <34057852-f6c0-d6d5-261f-bbb5fa056425@oracle.com>
 <ZSXqZOgLYkwLRWLO@google.com> <8f3493ca4c0e726d5c3876bb7dd2cfc432d9deaa.camel@infradead.org>
Message-ID: <ZSmHcECyt5PdZyIZ@google.com>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock periodically
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023, David Woodhouse wrote:
> On Tue, 2023-10-10 at 17:20 -0700, Sean Christopherson wrote:
> > On Wed, Oct 04, 2023, Dongli Zhang wrote:
> > > > -static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
> > > > -{
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct kvm *kvm =3D v->k=
vm;
> > > > -
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_make_request(KVM_REQ=
_CLOCK_UPDATE, v);
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0schedule_delayed_work(&k=
vm->arch.kvmclock_update_work,
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0KVMCLOCK_UPDATE_DELAY);
> > > > -}
> > > > -
> > > > =C2=A0#define KVMCLOCK_SYNC_PERIOD (300 * HZ)
> > >=20
> > > While David mentioned "maximum delta", how about to turn above into a=
 module
> > > param with the default 300HZ.
> > >=20
> > > BTW, 300HZ should be enough for vCPU hotplug case, unless people pref=
er 1-hour
> > > or 1-day.
> >=20
> > Hmm, I think I agree with David that it would be better if KVM can take=
 care of
> > the gory details and promise a certain level of accuracy.=C2=A0 I'm usu=
ally a fan of
> > punting complexity to userspace, but requiring every userspace to figur=
e out the
> > ideal sync frequency on every platform is more than a bit unfriendly.=
=C2=A0 And it
> > might not even be realistic unless userspace makes assumptions about ho=
w the kernel
> > computes CLOCK_MONOTONIC_RAW from TSC cycles.
> >=20
>=20
> I think perhaps I would rather save up my persuasiveness on the topic
> of "let's not make things too awful for userspace to cope with" for the
> live update/migration mess. I think I need to dust off that attempt at
> fixing our 'how to migrate with clocks intact' documentation from
> https://lore.kernel.org/kvm/13f256ad95de186e3b6bcfcc1f88da5d0ad0cb71.came=
l@infradead.org/
> The changes we're discussing here obviously have an effect on migration
> too.
>=20
> Where the host TSC is actually reliable, I would really prefer for the
> kvmclock to just be a fixed function of the guest TSC and *not* to be
> arbitrarily yanked back[1] to the host's CLOCK_MONOTONIC periodically.

CLOCK_MONOTONIC_RAW!  Just wanted to clarify because if kvmclock were tied =
to the
non-raw clock, then we'd have to somehow reconcile host NTP updates.

I generally support the idea, but I think it needs to an opt-in from usersp=
ace.
Essentially a "I pinky swear to give all vCPUs the same TSC frequency, to n=
ot
suspend the host, and to not run software/firmware that writes IA32_TSC_ADJ=
UST".
AFAICT, there are too many edge cases and assumptions about userspace for K=
VM to
safely couple kvmclock to guest TSC by default.

> [1] Yes, I believe "back" does happen. I have test failures in my queue
> to look at, where guests see the "Xen" clock going backwards.

Yeah, I assume "back" can happen based purely on the wierdness of the pvclo=
ck math.o

What if we add a module param to disable KVM's TSC synchronization crazines=
s
entirely?  If we first clean up the peroidic sync mess, then it seems like =
it'd
be relatively straightforward to let kill off all of the synchronization, i=
ncluding
the synchronization of kvmclock to the host's TSC-based CLOCK_MONOTONIC_RAW=
.

Not intended to be a functional patch...

---
 arch/x86/kvm/x86.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5b2104bdd99f..75fc6cbaef0d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -157,6 +157,9 @@ module_param(min_timer_period_us, uint, S_IRUGO | S_IWU=
SR);
 static bool __read_mostly kvmclock_periodic_sync =3D true;
 module_param(kvmclock_periodic_sync, bool, S_IRUGO);
=20
+static bool __read_mostly enable_tsc_sync =3D true;
+module_param_named(tsc_synchronization, enable_tsc_sync, bool, 0444);
+
 /* tsc tolerance in parts per million - default to 1/2 of the NTP threshol=
d */
 static u32 __read_mostly tsc_tolerance_ppm =3D 250;
 module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
@@ -2722,6 +2725,12 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcp=
u, u64 data)
 	bool matched =3D false;
 	bool synchronizing =3D false;
=20
+	if (!enable_tsc_sync) {
+		offset =3D kvm_compute_l1_tsc_offset(vcpu, data);
+		kvm_vcpu_write_tsc_offset(vcpu, offset);
+		return;
+	}
+
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
 	offset =3D kvm_compute_l1_tsc_offset(vcpu, data);
 	ns =3D get_kvmclock_base_ns();
@@ -2967,9 +2976,12 @@ static void pvclock_update_vm_gtod_copy(struct kvm *=
kvm)
 					&ka->master_kernel_ns,
 					&ka->master_cycle_now);
=20
-	ka->use_master_clock =3D host_tsc_clocksource && vcpus_matched
-				&& !ka->backwards_tsc_observed
-				&& !ka->boot_vcpu_runs_old_kvmclock;
+	WARN_ON_ONCE(!host_tsc_clocksource && !enable_tsc_sync);
+
+	ka->use_master_clock =3D host_tsc_clocksource &&
+			       (vcpus_matched || !enable_tsc_sync) &&
+			       !ka->backwards_tsc_observed &&
+			       !ka->boot_vcpu_runs_old_kvmclock;
=20
 	if (ka->use_master_clock)
 		atomic_set(&kvm_guest_has_master_clock, 1);
@@ -3278,6 +3290,9 @@ static void kvmclock_sync_fn(struct work_struct *work=
)
=20
 void kvm_adjust_pv_clock_users(struct kvm *kvm, bool add_user)
 {
+	if (!enable_tsc_sync)
+		return;
+
 	/*
 	 * Doesn't need to be a spinlock, but can't be kvm->lock as this is
 	 * call while holding a vCPU's mutext.
@@ -5528,6 +5543,11 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vc=
pu,
 		if (get_user(offset, uaddr))
 			break;
=20
+		if (!enable_tsc_sync) {
+			kvm_vcpu_write_tsc_offset(vcpu, offset);
+			break;
+		}
+
 		raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
=20
 		matched =3D (vcpu->arch.virtual_tsc_khz &&
@@ -12188,6 +12208,9 @@ int kvm_arch_hardware_enable(void)
 	if (ret !=3D 0)
 		return ret;
=20
+	if (!enable_tsc_sync)
+		return 0;
+
 	local_tsc =3D rdtsc();
 	stable =3D !kvm_check_tsc_unstable();
 	list_for_each_entry(kvm, &vm_list, vm_list) {
@@ -13670,6 +13693,12 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_proto=
col_exit);
=20
 static int __init kvm_x86_init(void)
 {
+	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+		enable_tsc_sync =3D true;
+
+	if (!enable_tsc_sync)
+		kvmclock_periodic_sync =3D false;
+
 	kvm_mmu_x86_module_init();
 	mitigate_smt_rsb &=3D boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possib=
le();
 	return 0;

base-commit: 7d2edad0beb2a6f07f6e6c2d477d5874f5417d6c
--=20


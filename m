Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5BA779AE7
	for <lists+kvm@lfdr.de>; Sat, 12 Aug 2023 01:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237151AbjHKXAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 19:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236908AbjHKW7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 18:59:36 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBA535BF
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 15:59:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-589c772be14so16958387b3.0
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 15:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691794757; x=1692399557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hE3Fbi6Qz7un5fcCb1gqCeNe6wXYIWaD6XtOPkGbF3s=;
        b=1pwjhAGKUVXDF5xUCtAEbhfagSY5z+Dz+Lqv2T1Js2tJEUh9WIIUQeChJ6IQ1TjT7M
         7b5yMe1ZXRAdWC4Q7Uaq9syafI1azuzC38n7Xk+kEQiV3HN1SNM95kDIXms6uKIo/v5q
         nwhaf73WAvoD1Fh+Lj1MT/LnpRQbOkEySDbsbeGULG+c34L8s8mVK6MfZ2J68fsBKy1p
         wOgw+SR9ilPPJ7JwOwugIa6o8QovjZHmMMuy/UNdCftFgFd9x2Q20PvXtOmfrd5NwVNn
         fRC7d3pvQXqveu5icFJZgqCCA/op7f3f9sWPusjlQFOth8JIzsQB9QSVNVcLOboNBTjm
         pzSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691794757; x=1692399557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hE3Fbi6Qz7un5fcCb1gqCeNe6wXYIWaD6XtOPkGbF3s=;
        b=X378sp3PJJD8Qzua1frB7D82zrBRgKURNJP0wJqfJ0MRhP+O/X5kE+PUD9sWUqAtG1
         LndSjzajSKdP5jC9jhwNwGrfC8OeARbjizBX8ng8HSc8pkZaWq52dg/sezncV/Pe3IYj
         eb1ef5LVZHK28/XxuIp13OFUtkWPJ3PjNDmzpDUJfdfLVZs9DhpA0CxWTddhVRUFjL/Z
         F2ZVXS7jmth0IyEArrWsu8BYsBfFZxQPNNqmfIJ+X03fJp1dC7b9MFBFWwIzcoyN+c+t
         MDxd5xOEzn3Eo1PXUEs2WeMIDR+4boC31zG3X4Cd5hMQayTon4FVLdU9Ov2fvaC8jyqB
         2yAg==
X-Gm-Message-State: AOJu0Ywt3gWNc/mMB3L6/ovUerQRq1S4DESGP7FJmbwqHZXsvlMQwIEn
        cTECm8S4doonx8fX7ahphNCJWVEv3f8=
X-Google-Smtp-Source: AGHT+IHAvpG2KH7v411LzHblORSnnZ2W4PyKERBHPSCTVNyqZnhAJBBkciubaL0RHctjirHxt/DJM4rMXyc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af0f:0:b0:586:e2b5:f364 with SMTP id
 n15-20020a81af0f000000b00586e2b5f364mr72315ywh.4.1691794757356; Fri, 11 Aug
 2023 15:59:17 -0700 (PDT)
Date:   Fri, 11 Aug 2023 15:59:15 -0700
In-Reply-To: <20230801034524.64007-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230801034524.64007-1-likexu@tencent.com>
Message-ID: <ZNa9QyRmuAjNAonC@google.com>
Subject: Re: [PATCH v4] KVM: x86/tsc: Don't sync user changes to TSC with
 KVM-initiated change
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023, Like Xu wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 278dbd37dab2..eeaf4ad9174d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2713,7 +2713,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
>  	kvm_track_tsc_matching(vcpu);
>  }
>  
> -static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
> +static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data, bool user_initiated)

Rather than pass two somewhat magic values for the KVM-internal call, what about
making @data a pointer and passing NULL?

>  {
>  	struct kvm *kvm = vcpu->kvm;
>  	u64 offset, ns, elapsed;
> @@ -2734,20 +2734,29 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>  			 * kvm_clock stable after CPU hotplug
>  			 */
>  			synchronizing = true;
> -		} else {
> +		} else if (kvm->arch.user_changed_tsc) {
>  			u64 tsc_exp = kvm->arch.last_tsc_write +
>  						nsec_to_cycles(vcpu, elapsed);
>  			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
>  			/*
> -			 * Special case: TSC write with a small delta (1 second)
> -			 * of virtual cycle time against real time is
> -			 * interpreted as an attempt to synchronize the CPU.
> +			 * Here lies UAPI baggage: user-initiated TSC write with
> +			 * a small delta (1 second) of virtual cycle time
> +			 * against real time is interpreted as an attempt to
> +			 * synchronize the CPU.
> +			 *
> +			 * Don't synchronize user changes to the TSC with the
> +			 * KVM-initiated change in kvm_arch_vcpu_postcreate()
> +			 * by conditioning this mess on userspace having
> +			 * written the TSC at least once already.

Ok, this confused me for a good long while.  As in, super duper wtf is going on
confused.  Calling out kvm_arch_vcpu_postcreate() is a gigantic red-herring,
because this path is *never* reached by the kvm_synchronize_tsc() call from
kvm_arch_vcpu_postcreate().  @data is 0, and so the internal KVM call goes straight
to synchronizing.

And the fact that KVM does synchronization from kvm_arch_vcpu_postcreate() isn't
interesting, as that's just an internal detail.  What's important is that
synchronization needs to be forced when creating or hotplugging a vCPU (data == 0),
but when NOT hotplugging should be skipped for the first write from userspace.

And IMO, this blurb from the changelog is flat out wrong:

 : Unfortunately the TSC sync code makes no distinction
 : between kernel and user-initiated writes, which leads to the target VM
 : synchronizing on the TSC offset from creation instead of the
 : user-intended value.

The problem isn't that the sync code doesn't differentiate between kernel and
user-initiated writes, because parts of the code *do* differentiate.  I think it's
more accurate to say that the problem is that the sync code doesn't differentiate
between userspace initializing the TSC and userspace attempting to synchronize the
TSC.

And the "user_changed_tsc" only adds to the confusion, because in the hotplug
              ^^^^^^^
case, AFAICT there is no guarantee that the TSC will be changed, i.e. userspace
may set the exact same value.

With a massaged changelog, I think we want this (untested):

---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 25 ++++++++++++++++---------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4c2d659a1269..bf566262ebd8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1331,6 +1331,7 @@ struct kvm_arch {
 	int nr_vcpus_matched_tsc;
 
 	u32 default_tsc_khz;
+	bool user_set_tsc;
 
 	seqcount_raw_spinlock_t pvclock_sc;
 	bool use_master_clock;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 34945c7dba38..d01991aadf19 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2698,8 +2698,9 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	kvm_track_tsc_matching(vcpu);
 }
 
-static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
+static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
 {
+	u64 data = user_value ? *user_value : 0;
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
 	unsigned long flags;
@@ -2712,14 +2713,17 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 
 	if (vcpu->arch.virtual_tsc_khz) {
+		/*
+		 * Force synchronization when creating or hotplugging a vCPU,
+		 * i.e. when the TSC value is '0', to help keep clocks stable.
+		 * If this is NOT a hotplug/creation case, skip synchronization
+		 * on the first write from userspace so as not to misconstrue
+		 * state restoration after live migration as an attempt from
+		 * userspace to synchronize.
+		 */
 		if (data == 0) {
-			/*
-			 * detection of vcpu initialization -- need to sync
-			 * with other vCPUs. This particularly helps to keep
-			 * kvm_clock stable after CPU hotplug
-			 */
 			synchronizing = true;
-		} else {
+		} else if (kvm->arch.user_set_tsc) {
 			u64 tsc_exp = kvm->arch.last_tsc_write +
 						nsec_to_cycles(vcpu, elapsed);
 			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
@@ -2733,6 +2737,9 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 		}
 	}
 
+	if (user_value)
+		kvm->arch.user_set_tsc = true;
+
 	/*
 	 * For a reliable TSC, we can match TSC offsets, and for an unstable
 	 * TSC, we add elapsed time in this computation.  We could let the
@@ -3761,7 +3768,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_TSC:
 		if (msr_info->host_initiated) {
-			kvm_synchronize_tsc(vcpu, data);
+			kvm_synchronize_tsc(vcpu, &data);
 		} else {
 			u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
 			adjust_tsc_offset_guest(vcpu, adj);
@@ -11934,7 +11941,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	if (mutex_lock_killable(&vcpu->mutex))
 		return;
 	vcpu_load(vcpu);
-	kvm_synchronize_tsc(vcpu, 0);
+	kvm_synchronize_tsc(vcpu, NULL);
 	vcpu_put(vcpu);
 
 	/* poll control enabled by default */

base-commit: ba44e03ef5e5d3ece316d1384e43e3d7761c89d4
-- 


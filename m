Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF367AE0BA
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 23:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbjIYV07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 17:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbjIYV05 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 17:26:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64C1139
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 14:26:49 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d814634fe4bso11151485276.1
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 14:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695677209; x=1696282009; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qvsXqiQFIe/a85DD042d1DNAIm4IIDnTXiAAPwKIpaA=;
        b=0esYoHz3Dj30jpJ4i0eEKi/M1cmCBz/5aZPTJWEUXHYj+Cf9i/256RDxMjlk/n8nyY
         /D5U36B8sVeFSjfAxXqY2aWMyNSjH2mQ/t7hgib3GOi77xiYmUVpuyY6BZgDTXr0slsZ
         zelVzuSiqsb72UUUmP3Fx+GrKXuJeUhzdrQ5a0hSweuk+j7kIdkswc78lD1GoKINETt2
         YGdg259f9bvqRNlNPQoOk41qQ2vhHTlq3Ogq5StAJNMs1RK41cxiqc+CE/ub7Jh5qHPR
         GmSimHQlOJYvxv8lDpAvsPLKQ5v5SFrw+dVYGAApn2p3t04QbhQKctH2rLIq9L2B2AgS
         Bt+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695677209; x=1696282009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qvsXqiQFIe/a85DD042d1DNAIm4IIDnTXiAAPwKIpaA=;
        b=KEmH9mV7snWrCIHFj9PnUtPfdxedWfK4x2gncz6tMAbu3UhFDtREcdmzoZ/oiXrNA6
         KGSVCxYWrzfXfxMu9/dq85zFwoL64MDicqq5YOGuGy3H8bbNml8cZI7Zoed9DHHZe7H4
         TXwkl3+CKvdjvYDAcuFyTfFvsmDMytopRAPOyUZP7KJ2bezmt2quXK9KYJAHZDwwtgln
         xb6lxuZZA7XSs/CpaoydjyBlPCrZahJPiv8sfa+R9RGu/jI//sHAk1/yOH084NPAsvsD
         2J0Z7xuzilPPvPxkepeiLIN4TJ9uqiHBe5RuxiOEuRNz7QTnnlWI3af5sdJszEqg2A7Y
         m4uw==
X-Gm-Message-State: AOJu0YxImwbbulzh80VqQUtKr+MuYzIj77ZajV32fEk3f0pjKMg45jdt
        UY3G0XDgNxJRJ/CaE5EBrWX/WLhRZjI=
X-Google-Smtp-Source: AGHT+IHWwvq1HCr3SqILsY0xhj0ymft2ScjoO0HOU7YkzuiGqakNIoHzYbgvfTQaz8EFLBBwslb2FvSew+s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2f52:0:b0:d80:eb4:9ca with SMTP id
 v79-20020a252f52000000b00d800eb409camr82991ybv.0.1695677208936; Mon, 25 Sep
 2023 14:26:48 -0700 (PDT)
Date:   Mon, 25 Sep 2023 14:26:47 -0700
In-Reply-To: <ZQRNmsWcOM1xbNsZ@luigi.stachecki.net>
Mime-Version: 1.0
References: <20230914010003.358162-1-tstachecki@bloomberg.net>
 <ZQKzKkDEsY1n9dB1@redhat.com> <ZQLOVjLtFnGESG0S@luigi.stachecki.net>
 <93592292-ab7e-71ac-dd72-74cc76e97c74@oracle.com> <ZQOsQjsa4bEfB28H@luigi.stachecki.net>
 <ZQQKoIEgFki0KzxB@redhat.com> <ZQRNmsWcOM1xbNsZ@luigi.stachecki.net>
Message-ID: <ZRH7F3SlHZEBf1I2@google.com>
Subject: Re: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
From:   Sean Christopherson <seanjc@google.com>
To:     Tyler Stachecki <stachecki.tyler@gmail.com>
Cc:     Leonardo Bras <leobras@redhat.com>,
        Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, dgilbert@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, bp@alien8.de,
        Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
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

On Fri, Sep 15, 2023, Tyler Stachecki wrote:
> On Fri, Sep 15, 2023 at 04:41:20AM -0300, Leonardo Bras wrote:
> > Other than that, all I can think of is removing the features from guest:
> > 
> > As you commented, there may be some features that would not be a problem 
> > to be removed, and also there may be features which are not used by the 
> > workload, and could be removed. But this would depend on the feature, and 
> > the workload, beind a custom solution for every case.
> 
> Yes, the "fixup back" should be refined to pointed and verified cases.
>  
> > For this (removing guest features), from kernel side, I would suggest using 
> > SystemTap (and eBPF, IIRC). The procedures should be something like:
> > - Try to migrate VM from host with older kernel: fail
> > - Look at qemu error, which features are missing?
> > - Are those features safely removable from guest ? 
> >   - If so, get an SystemTap / eBPF script masking out the undesired bits.
> >   - Try the migration again, it should succeed.
> > 
> > IIRC, this could also be done in qemu side, with a custom qemu:
> > - Try to migrate VM from host with older kernel: fail
> > - Look at qemu error, which features are missing?
> > - Are those features safely removable from guest ?
> >   - If so, get a custom qemu which mask-out the desired flags before the VM 
> >     starts
> >   - Live migrate (can be inside the source host) to the custom qemu
> >   - Live migrate from custom qemu to target host.
> > - The custom qemu could be on a auxiliary host, and used only for this
> > 
> > Yes, it's hard, takes time, and may not solve every case, but it gets a 
> > higher chance of the VM surviving in the long run.
> 
> Thank you for taking the time to throughly consider the issue and suggest some
> ways out - I really appreciate it.
> 
> > But keep in mind this is a hack.
> > Taking features from a live guest is not supported in any way, and has a 
> > high chance of crashing the VM.
>
> OK - if there's no interest in the below, I will not push for including this
> patch in the kernel tree any longer. I do think the specific case below is what
> a vast majority of KVM users will struggle with in the near future, though:
>
> I have a test environment with Broadwell-based (have only AVX-256) guests
> running under Skylake (PKRU, AVX512, ...) hypervisors.

I definitely don't want to take the proposed patch.  As Leo pointed out, silently
dropping features that userspace explicitly requests is a recipe for disaster.

However, I do agree with Tyler that is an egregious kernel/KVM bug, as essentially
requiring KVM_SET_XSAVE to be a subset of guest supported XCR0, i.e. guest CPUID,
is a clearcut breakage of userspace.  KVM_SET_XSAVE worked on kernel X and failed
on kernel X+1, there's really no wiggle room there.

Luckily, I'm pretty sure there's no need to take features away from the guest in
order to fix the bug Tyler is experiencing.  Prior to commit ad856280ddea, KVM's
ABI was that KVM_SET_SAVE just needs a subset of the *host* features, i.e. this
chunk from the changelog simply needs to be undone:

    As a bonus, it will also fail if userspace tries to set fpu features
    (with the KVM_SET_XSAVE ioctl) that are not compatible to the guest
    configuration.  Such features will never be returned by KVM_GET_XSAVE
    or KVM_GET_XSAVE2.

That can be done by applying guest_supported_xcr0 to *only* the KVM_GET_XSAVE{2}
path.  It's not ideal since it means that KVM_GET_XSAVE{2} won't be consistent
with the guest model if userspace does KVM_GET_XSAVE{2} before KVM_SET_CPUID, but
practically speaking I don't think there's a real world userspace VMM that does
that.

Compile tested only, and it needs a changelog, but I think this will do the trick:

---
 arch/x86/include/asm/fpu/api.h |  3 ++-
 arch/x86/kernel/fpu/core.c     |  5 +++--
 arch/x86/kernel/fpu/xstate.c   |  7 +++++--
 arch/x86/kernel/fpu/xstate.h   |  3 ++-
 arch/x86/kvm/cpuid.c           |  8 --------
 arch/x86/kvm/x86.c             | 37 ++++++++++++++++++++++------------
 6 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 31089b851c4f..a2be3aefff9f 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -157,7 +157,8 @@ static inline void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd) {
 static inline void fpu_sync_guest_vmexit_xfd_state(void) { }
 #endif
 
-extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf, unsigned int size, u32 pkru);
+extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
+					   unsigned int size, u64 xfeatures, u32 pkru);
 extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf, u64 xcr0, u32 *vpkru);
 
 static inline void fpstate_set_confidential(struct fpu_guest *gfpu)
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index a86d37052a64..a21a4d0ecc34 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -369,14 +369,15 @@ int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
 EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpstate);
 
 void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
-				    unsigned int size, u32 pkru)
+				    unsigned int size, u64 xfeatures, u32 pkru)
 {
 	struct fpstate *kstate = gfpu->fpstate;
 	union fpregs_state *ustate = buf;
 	struct membuf mb = { .p = buf, .left = size };
 
 	if (cpu_feature_enabled(X86_FEATURE_XSAVE)) {
-		__copy_xstate_to_uabi_buf(mb, kstate, pkru, XSTATE_COPY_XSAVE);
+		__copy_xstate_to_uabi_buf(mb, kstate, xfeatures, pkru,
+					  XSTATE_COPY_XSAVE);
 	} else {
 		memcpy(&ustate->fxsave, &kstate->regs.fxsave,
 		       sizeof(ustate->fxsave));
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index cadf68737e6b..7d31033d176e 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1049,6 +1049,7 @@ static void copy_feature(bool from_xstate, struct membuf *to, void *xstate,
  * __copy_xstate_to_uabi_buf - Copy kernel saved xstate to a UABI buffer
  * @to:		membuf descriptor
  * @fpstate:	The fpstate buffer from which to copy
+ * @xfeatures:	Constraint which of user xfeatures to save (XSAVE only)
  * @pkru_val:	The PKRU value to store in the PKRU component
  * @copy_mode:	The requested copy mode
  *
@@ -1059,7 +1060,8 @@ static void copy_feature(bool from_xstate, struct membuf *to, void *xstate,
  * It supports partial copy but @to.pos always starts from zero.
  */
 void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
-			       u32 pkru_val, enum xstate_copy_mode copy_mode)
+			       u64 xfeatures, u32 pkru_val,
+			       enum xstate_copy_mode copy_mode)
 {
 	const unsigned int off_mxcsr = offsetof(struct fxregs_state, mxcsr);
 	struct xregs_state *xinit = &init_fpstate.regs.xsave;
@@ -1083,7 +1085,7 @@ void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
 		break;
 
 	case XSTATE_COPY_XSAVE:
-		header.xfeatures &= fpstate->user_xfeatures;
+		header.xfeatures &= fpstate->user_xfeatures & xfeatures;
 		break;
 	}
 
@@ -1185,6 +1187,7 @@ void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
 			     enum xstate_copy_mode copy_mode)
 {
 	__copy_xstate_to_uabi_buf(to, tsk->thread.fpu.fpstate,
+				  tsk->thread.fpu.fpstate->user_xfeatures,
 				  tsk->thread.pkru, copy_mode);
 }
 
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index a4ecb04d8d64..3518fb26d06b 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -43,7 +43,8 @@ enum xstate_copy_mode {
 
 struct membuf;
 extern void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
-				      u32 pkru_val, enum xstate_copy_mode copy_mode);
+				      u64 xfeatures, u32 pkru_val,
+				      enum xstate_copy_mode copy_mode);
 extern void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
 				    enum xstate_copy_mode mode);
 extern int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf, u32 *pkru);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0544e30b4946..773132c3bf5a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -360,14 +360,6 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.guest_supported_xcr0 =
 		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
 
-	/*
-	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
-	 * XSAVE/XCRO are not exposed to the guest, and even if XSAVE isn't
-	 * supported by the host.
-	 */
-	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0 |
-						       XFEATURE_MASK_FPSSE;
-
 	kvm_update_pv_runtime(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f18b06bbda6..734e2d69329b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5382,26 +5382,37 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
-					 struct kvm_xsave *guest_xsave)
-{
-	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
-		return;
-
-	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu,
-				       guest_xsave->region,
-				       sizeof(guest_xsave->region),
-				       vcpu->arch.pkru);
-}
 
 static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
 					  u8 *state, unsigned int size)
 {
+	/*
+	 * Only copy state for features that are enabled for the guest.  The
+	 * state itself isn't problematic, but setting bits in the header for
+	 * features that are supported in *this* host but not exposed to the
+	 * guest can result in KVM_SET_XSAVE failing when live migrating to a
+	 * compatible host, i.e. a host without the features that are NOT
+	 * exposed to the guest.
+	 *
+	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
+	 * XSAVE/XCRO are not exposed to the guest, and even if XSAVE isn't
+	 * supported by the host.
+	 */
+	u64 supported_xcr0 = vcpu->arch.guest_supported_xcr0 |
+			     XFEATURE_MASK_FPSSE;
+
 	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
 		return;
 
-	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu,
-				       state, size, vcpu->arch.pkru);
+	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu, state, size,
+				       supported_xcr0, vcpu->arch.pkru);
+}
+
+static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
+					 struct kvm_xsave *guest_xsave)
+{
+	return kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
+					     sizeof(guest_xsave->region));
 }
 
 static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,

base-commit: 5804c19b80bf625c6a9925317f845e497434d6d3
-- 


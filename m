Return-Path: <kvm+bounces-27459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6C5D98636E
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:26:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 706982854F3
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 15:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B769D184544;
	Wed, 25 Sep 2024 15:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sI0FfFu3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283BB15C12F
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 15:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727276928; cv=none; b=mq22gpuDIz7o/ViPb3zzxrcTkc9nlyQ+dq613licaqgH5VD+KI8CL6af6r5tW5+6jGuLYZGFw11IYqZuwjue0wJNvjmCxUtfbbXTMUYJwlNaHcAHGCxc8Jtle+aU58ZC91tr+69051Krmr+VFv0VCEqJHj5+ifbOZfGqUjTw0NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727276928; c=relaxed/simple;
	bh=B8GjkZ9KSpAFYR+WSzBhrhjfRNsNrfu9PdiIxSYd2dw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d+bJ8ue+EluuqgxfStbJdtBi101LZzJAV5v2jTq6wa/lxHy4tw/qPDhYDV854FzPBYwAxsyncdflD+dhvv1Xjl3JThuV7CXKM05U4P5uuHXn59AyQKg2mPpci9fdTQ9lsGM/YUZR2NcocT00nDQ2bNvaWplJ34+kF3wEiugRzZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sI0FfFu3; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7d4f9974c64so4471964a12.1
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 08:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727276925; x=1727881725; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CJjlCVLEZdWj934sR01kDIPq+l9ewDRt7kkVfBRkT5A=;
        b=sI0FfFu3rMHxQ92kip65G0cH48eQKAHZfCu4DJvJ6wegxCGJr5DQGiqK3cGszfdhrS
         p3j3ztE1pSfRO8MpJ/a7ZkwdF9F8m3khwmuZL1LGd1Jd4DXNYHMBQ4TZY/yekvfXIYfv
         wp5i8cZYgq13jWqBUP0bGNDgW32NOzSJ/bgNpFoHdLIAG93BV7kOD9UzpogtCaFp26+I
         EEcUEYm2k6DoFMs+ir1PMkDYY2R4lyt4eZtmxtCkA7GkbcLM1xDt+0T3Hhv9v8jm0NIq
         /ZhR5SfT1PFnTuBdQ21WfUVP+xr9SRNusA15kn2LRW3rzfky8CdoYCu6uWFHDGKHUPZ2
         dBiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727276925; x=1727881725;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CJjlCVLEZdWj934sR01kDIPq+l9ewDRt7kkVfBRkT5A=;
        b=CE+UmruHKANTijIjXFjzi1WBobQ5Dhou0P8isFoddBWq+lHPPFTpQlzt7Lxy7BGsUE
         2PR6clsjVtcVOCHVnrHlroblLDraMM2Pjvjk+MKZQ9K5/1mCzxwOJiERdcRa6JGSDN3+
         xSJCnO8jaiONuJ3YBI4MPlgqJZ95YpZ+U76OtOMm43HhWQ4+q6DVPxHHnjkLsDZRcKH/
         3hq6Citp2hCb/k5SyjB0qji5dqhst0+VDzrzjh3SoxIfOaOQd3hLdT3Epw2SjX55x5xa
         /zX4nBxewAaXoOpqoznhuDXKsb0NxoKKufvHjYhR5BYX4C3YfeI3KvrKqKmHs0bagHk+
         fOAg==
X-Forwarded-Encrypted: i=1; AJvYcCXRIM1MkQWN3FgRamDlbMkJN3mAfgyRGluM/JpTwjBhTc+49tJJ6oAJFur03Q6F5xXgvwA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3JUFKvSAE0mzfMj78s94FGqgqOBkfy/QkH8KhAlNwSKZqfcjS
	H6rtt+xliUhWvN9KIWTZUamy/NDqDltvAYs3IQO2fYk5zo0ZMhWRUga/Kez+scwyNE/2PiV0OZh
	2fg==
X-Google-Smtp-Source: AGHT+IHrIyskI5zYC0DBa9u5TteP6HKJCX5qffLdumB5VXa+/HHcwX6qSSRiKGLGGvId15g5lZFKwsrMIKs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d503:b0:201:f9c7:632d with SMTP id
 d9443c01a7336-20afc2cfd1cmr341265ad.0.1727276925273; Wed, 25 Sep 2024
 08:08:45 -0700 (PDT)
Date: Wed, 25 Sep 2024 08:08:43 -0700
In-Reply-To: <65fe418f079a1f9f59caa170ec0ae5d828486714.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240725175232.337266-1-mlevitsk@redhat.com> <20240725175232.337266-3-mlevitsk@redhat.com>
 <ZrF55uIvX2rcHtSW@chao-email> <ZrY1adEnEW2N-ijd@google.com>
 <61e7e64c615aba6297006dbf32e48986d33c12ab.camel@redhat.com> <65fe418f079a1f9f59caa170ec0ae5d828486714.camel@redhat.com>
Message-ID: <ZvQne77ycOKQ1nvU@google.com>
Subject: Re: [PATCH v3 2/2] VMX: reset the segment cache after segment
 initialization in vmx_vcpu_reset
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 09, 2024, Maxim Levitsky wrote:
> On Mon, 2024-09-09 at 15:11 -0400, Maxim Levitsky wrote:
> > On Fri, 2024-08-09 at 08:27 -0700, Sean Christopherson wrote:
> > > > > @@ -4899,6 +4896,9 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > > > > 	vmcs_writel(GUEST_IDTR_BASE, 0);
> > > > > 	vmcs_write32(GUEST_IDTR_LIMIT, 0xffff);
> > > > > 
> > > > > +	vmx_segment_cache_clear(vmx);
> > > > > +	kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);
> > > > 
> > > > vmx_segment_cache_clear() is called in a few other sites. I think at least the
> > > > call in __vmx_set_segment() should be fixed, because QEMU may read SS.AR right
> > > > after a write to it. if the write was preempted after the cache was cleared but
> > > > before the new value being written into VMCS, QEMU would find that SS.AR held a
> > > > stale value.
> > > 
> > > Ya, I thought the plan was to go for a more complete fix[*]?  This change isn't
> > > wrong, but it's obviously incomplete, and will be unnecessary if the preemption
> > > issue is resolved.
> > 
> > Hi,
> > 
> > I was thinking to keep it simple, since the issue is mostly theoretical
> > after this fix, but I'll give this another try.
>
> This is what I am thinking, after going over this issue again:
> 
> Pre-populating the cache and/or adding 'exited_in_kernel' will waste vmreads
> on *each* vmexit,

FWIW, KVM would only need to do the VMREAD on non-fastpath exits.

> I worry that this is just not worth the mostly theoretical issue that we
> have.

Yeah.  And cost aside, it's weird and hard to document and use properly because
it's such an edge case.  E.g. only applies preemptible kernels, and use of
exited_in_kernel would likely need to be restricted to the sched_out() preempt
logic, because anything really needs to check the "current" CPL.

> Since the segment and the register cache only optimize the case of reading a
> same field twice or more, I suspect that reading these fields always is worse
> performance wise than removing the segment cache altogether and reading these
> fields again and again.

For modern setups, yeah, the segment cache likely isn't helping much, though I
suspect it still gets a decent number of "hits" on CS.AR_BYTES via is_64_bit_mode().

But for older CPUs where KVM needs to emulate large chunks of code, I'm betting
the segment cache is an absolute must have.

> Finally all 3 places that read the segment cache, only access one piece of
> data (SS.AR or RIP), thus it doesn't really matter if they see an old or a
> new value. 
> 
> I mean in theory if userspace changes the SS's AR bytes out of the blue, and
> then we get a preemption event, in theory as you say the old value is correct
> but it really doesn't matter.
> 
> So IMHO, just ensuring that we invalidate the segment cache right after we do
> any changes is the simplest solution.

But it's not a very maintainable solution.  It fixes the immediate problem, but
doesn't do anything to help ensure that all future code invalidates the cache
after writing, nor does it guarantee that all future usage of SS.AR can tolerate
consuming stale values.

> I can in addition to that add a warning to kvm_register_is_available and
> vmx_segment_cache_test_set, that will test that only SS.AR and RIP are read
> from the interrupt context, so that if in the future someone attempts to read
> more fields, this issue can be re-evaluated.

There's no need to add anything to vmx_segment_cache_test_set(), because it uses
kvm_register_is_available().  I.e. adding logic in kvm_register_is_available()
will suffice.

If we explicitly allow VMCS accesses from PMI callbacks, which by we *know* can
tolerate stale data _and_ never run while KVM is updating segments, then we can
fix the preemption case by forcing a VMREAD and bypassing the cache.
 
And looking to the future, if vcpu->arch.guest_state_protected is moved/exposed
to common code in some way, then the common PMI code can skip trying to read guest
state, and the ugliness of open coding that check in the preemption path largely
goes away.

If you're ok with the idea, I'll write changelogs and post the below (probably over
two patches).  I don't love adding another kvm_x86_ops callback, but I couldn't
come up with anything less ugly.

---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/kvm_cache_regs.h      | 17 +++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  1 +
 arch/x86/kvm/vmx/main.c            |  1 +
 arch/x86/kvm/vmx/vmx.c             | 23 ++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.h             |  1 +
 arch/x86/kvm/x86.c                 | 13 ++++++++++++-
 8 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 861d080ed4c6..5aff7222e40f 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -34,6 +34,7 @@ KVM_X86_OP(set_msr)
 KVM_X86_OP(get_segment_base)
 KVM_X86_OP(get_segment)
 KVM_X86_OP(get_cpl)
+KVM_X86_OP(get_cpl_no_cache)
 KVM_X86_OP(set_segment)
 KVM_X86_OP(get_cs_db_l_bits)
 KVM_X86_OP(is_valid_cr0)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6d9f763a7bb9..3ae90df0a177 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1656,6 +1656,7 @@ struct kvm_x86_ops {
 	void (*get_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
 	int (*get_cpl)(struct kvm_vcpu *vcpu);
+	int (*get_cpl_no_cache)(struct kvm_vcpu *vcpu);
 	void (*set_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index b1eb46e26b2e..0370483003f6 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -43,6 +43,18 @@ BUILD_KVM_GPR_ACCESSORS(r14, R14)
 BUILD_KVM_GPR_ACCESSORS(r15, R15)
 #endif
 
+/*
+ * Using the register cache from interrupt context is generally not allowed, as
+ * caching a register and marking it available/dirty can't be done atomically,
+ * i.e. accesses from interrupt context may clobber state or read stale data if
+ * the vCPU task is in the process of updating the cache.  The exception is if
+ * KVM is handling an IRQ/NMI from guest mode, as that bounded sequence doesn't
+ * touch the cache, it runs after the cache is reset (post VM-Exit), and PMIs
+ * need to several registers that are cacheable.
+ */
+#define kvm_assert_register_caching_allowed(vcpu)		\
+	lockdep_assert_once(in_task() ||			\
+			    READ_ONCE(vcpu->arch.handling_intr_from_guest))
 /*
  * avail  dirty
  * 0	  0	  register in VMCS/VMCB
@@ -53,24 +65,28 @@ BUILD_KVM_GPR_ACCESSORS(r15, R15)
 static inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
 					     enum kvm_reg reg)
 {
+	kvm_assert_register_caching_allowed(vcpu);
 	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 }
 
 static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
 					 enum kvm_reg reg)
 {
+	kvm_assert_register_caching_allowed(vcpu);
 	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
 }
 
 static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
 					       enum kvm_reg reg)
 {
+	kvm_assert_register_caching_allowed(vcpu);
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 }
 
 static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
 					   enum kvm_reg reg)
 {
+	kvm_assert_register_caching_allowed(vcpu);
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
 }
@@ -84,6 +100,7 @@ static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
 static __always_inline bool kvm_register_test_and_mark_available(struct kvm_vcpu *vcpu,
 								 enum kvm_reg reg)
 {
+	kvm_assert_register_caching_allowed(vcpu);
 	return arch___test_and_set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9df3e1e5ae81..50f6b0e03d04 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5031,6 +5031,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_segment = svm_get_segment,
 	.set_segment = svm_set_segment,
 	.get_cpl = svm_get_cpl,
+	.get_cpl_no_cache = svm_get_cpl,
 	.get_cs_db_l_bits = svm_get_cs_db_l_bits,
 	.is_valid_cr0 = svm_is_valid_cr0,
 	.set_cr0 = svm_set_cr0,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7668e2fb8043..92d35cc6cd15 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -50,6 +50,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
 	.get_cpl = vmx_get_cpl,
+	.get_cpl_no_cache = vmx_get_cpl_no_cache,
 	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
 	.is_valid_cr0 = vmx_is_valid_cr0,
 	.set_cr0 = vmx_set_cr0,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c67e448c6ebd..e2483678eca1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3568,16 +3568,29 @@ u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
 	return vmx_read_guest_seg_base(to_vmx(vcpu), seg);
 }
 
-int vmx_get_cpl(struct kvm_vcpu *vcpu)
+static int __vmx_get_cpl(struct kvm_vcpu *vcpu, bool no_cache)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int ar;
 
 	if (unlikely(vmx->rmode.vm86_active))
 		return 0;
-	else {
-		int ar = vmx_read_guest_seg_ar(vmx, VCPU_SREG_SS);
-		return VMX_AR_DPL(ar);
-	}
+
+	if (no_cache)
+		ar = vmcs_read32(GUEST_SS_AR_BYTES);
+	else
+		ar = vmx_read_guest_seg_ar(vmx, VCPU_SREG_SS);
+	return VMX_AR_DPL(ar);
+}
+
+int vmx_get_cpl(struct kvm_vcpu *vcpu)
+{
+	return __vmx_get_cpl(vcpu, false);
+}
+
+int vmx_get_cpl_no_cache(struct kvm_vcpu *vcpu)
+{
+	return __vmx_get_cpl(vcpu, true);
 }
 
 static u32 vmx_segment_access_rights(struct kvm_segment *var)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 2325f773a20b..bcf40c7f3a38 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -385,6 +385,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 			unsigned long fs_base, unsigned long gs_base);
 int vmx_get_cpl(struct kvm_vcpu *vcpu);
+int vmx_get_cpl_no_cache(struct kvm_vcpu *vcpu);
 bool vmx_emulation_required(struct kvm_vcpu *vcpu);
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu);
 void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83fe0a78146f..941245082647 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5094,7 +5094,13 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	int idx;
 
 	if (vcpu->preempted) {
-		vcpu->arch.preempted_in_kernel = kvm_arch_vcpu_in_kernel(vcpu);
+		/*
+		 * Assume protected guests are in-kernel.  Inefficient yielding
+		 * due to false positives is preferable to never yielding due
+		 * to false negatives.
+		 */
+		vcpu->arch.preempted_in_kernel = vcpu->arch.guest_state_protected ||
+						 !kvm_x86_call(get_cpl_no_cache)(vcpu);
 
 		/*
 		 * Take the srcu lock as memslots will be accessed to check the gfn
@@ -13207,6 +13213,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
+	/* TODO: Elide the call in the kvm_guest_get_ip() perf callback. */
 	if (vcpu->arch.guest_state_protected)
 		return true;
 
@@ -13215,6 +13222,10 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 
 unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
 {
+	/* TODO: Elide the call in the kvm_guest_get_ip() perf callback. */
+	if (vcpu->arch.guest_state_protected)
+		return 0;
+
 	return kvm_rip_read(vcpu);
 }
 

base-commit: 3f8df6285271d9d8f17d733433e5213a63b83a0b
-- 



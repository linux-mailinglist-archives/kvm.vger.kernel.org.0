Return-Path: <kvm+bounces-58237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFB2AB8B7C6
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:35:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7523E5A400A
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A32F2E1F06;
	Fri, 19 Sep 2025 22:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W8KwqFIB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761D42D3ED5
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321201; cv=none; b=KUG+74fVKUZoxwvpTsYb7UYF7SwHIo+LFY761/lDVApok2MehGLhPTUrzfMLNvWr0gNaGmzWbinxLGGMR+G/BCY4o7GMheYdHGz4VXNguN5ufXXeh97QAtKcUn4W7tUTPUxmDctjSjVaUlLAspsYYXXot5C9EyGkVwBkxDOd4AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321201; c=relaxed/simple;
	bh=dsXd95z/9v7mTGgBcA326k/uaIBVLIcxb8LwmBCbCgg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mi3zkh3eXJbbvw8Pf+jx6YgUWAoPYYpod6pbKZ9rsI0oZIhsY94MqBFzA+dY94G7mSZ/wSh2VzE8Gn3NUu4PB0sRtYIM4HyrTlFT99/TWfiPBvXtJxZsNsflg45WOHq6RM3Xg2ciOejjnfsWq2Up3swSzYFoO+dlZIxFcsv1/4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W8KwqFIB; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b54a2ab0f2aso1819679a12.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321199; x=1758925999; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nbntpQIHa7UZ+mNPJJjW08mJCTxjhm13+odndGQs4Cc=;
        b=W8KwqFIBk4Qw7t5putrWwyYafmUTVb8JGcZbwpLU5RscO3luvSw3W/sWgvoFkCIae3
         6kE1fl2GZSEpai+Sjb3FRy/lPr2oxAFhh5SqiEGhG7dmfJyXyO9/f9Uif87YkzWy2Eo/
         wxNkh683Ki0HhjuxlXzlDXr88PfGAWwRKlu/y8Gwdgk3KI8+GsSNRh1Mz/3X7FkyY4ii
         ocMtwXjnmMjg7eqqbYaAVOwxx43jJTUsRMpZPlKYmEi+FIJ2dinDHaJJRtfbWaYWnloF
         O6a1M36Zp2VHZPY65B5sjm0k1MQnWuGZz26dUxZy+9HsshnJwszMmzerZ/uRt9JyCESZ
         Gigw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321199; x=1758925999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nbntpQIHa7UZ+mNPJJjW08mJCTxjhm13+odndGQs4Cc=;
        b=M+sCNKXnCU29XqgWyJD+0nfwj46mflouuA4kLNerbGM2VE2mm9gPREzn5tPV6UClYC
         XgFvy10rcAW2Lcb0KUHNyWc3dzjFr876Je2qojgt64E88eAGanllGcyEDweI4PRqgEex
         gcGdMSJAxA8acxfi8Pm1YK3ex1M6GneTP9h/BcmhhEK1o1zvBzIFtAGfT4EB+MDAL+LL
         aUgd0/poFCDlUT9wI8pXVV6WCeLyMV6La7SvKlN6ZhHSbSm2/mzDNvF5p/dSDNkclbHD
         Z3BTnXb2rlY7mfujW+vIbmqZSr3r3RjTrJfk8/gLMGu4G2z3poOIqFLVn0kZcIGqlOMM
         bWqw==
X-Gm-Message-State: AOJu0Yy/pdYEhUNKCSDgCgbXhXLaz6hkrvqnEYQuQ4sKWC8rD6uXft1+
	sVjtVwLrygtjMeE7hG8y/l0Lty0HufKzaDu2KvYiPneHq7Jw1Key4cVr+iy6708yIF5aU3/xeGC
	JoGZgKg==
X-Google-Smtp-Source: AGHT+IGZKAcZjmQQ81azdKmgHL6yny+FqvmHyUKFjbF1RbLhxL4zTo9wzFiM0mAHk98cSEXMh3Wjtovcb8A=
X-Received: from pgac17.prod.google.com ([2002:a05:6a02:2951:b0:b54:faf1:19e5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7346:b0:243:fe1e:2f95
 with SMTP id adf61e73a8af0-2844b5c6ae4mr13624113637.6.1758321198654; Fri, 19
 Sep 2025 15:33:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:16 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-10-seanjc@google.com>
Subject: [PATCH v16 09/51] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Load the guest's FPU state if userspace is accessing MSRs whose values
are managed by XSAVES. Introduce two helpers, kvm_{get,set}_xstate_msr(),
to facilitate access to such kind of MSRs.

If MSRs supported in kvm_caps.supported_xss are passed through to guest,
the guest MSRs are swapped with host's before vCPU exits to userspace and
after it reenters kernel before next VM-entry.

Because the modified code is also used for the KVM_GET_MSRS device ioctl(),
explicitly check @vcpu is non-null before attempting to load guest state.
The XSAVE-managed MSRs cannot be retrieved via the device ioctl() without
loading guest FPU state (which doesn't exist).

Note that guest_cpuid_has() is not queried as host userspace is allowed to
access MSRs that have not been exposed to the guest, e.g. it might do
KVM_SET_MSRS prior to KVM_SET_CPUID2.

The two helpers are put here in order to manifest accessing xsave-managed
MSRs requires special check and handling to guarantee the correctness of
read/write to the MSRs.

Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
[sean: drop S_CET, add big comment, move accessors to x86.c]
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 87 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 86 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3e66d8c5000a..ae402463f991 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -136,6 +136,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 
 static DEFINE_MUTEX(vendor_module_lock);
+static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
+static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
+
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 
 #define KVM_X86_OP(func)					     \
@@ -3801,6 +3804,67 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
 
+/*
+ * Returns true if the MSR in question is managed via XSTATE, i.e. is context
+ * switched with the rest of guest FPU state.  Note!  S_CET is _not_ context
+ * switched via XSTATE even though it _is_ saved/restored via XSAVES/XRSTORS.
+ * Because S_CET is loaded on VM-Enter and VM-Exit via dedicated VMCS fields,
+ * the value saved/restored via XSTATE is always the host's value.  That detail
+ * is _extremely_ important, as the guest's S_CET must _never_ be resident in
+ * hardware while executing in the host.  Loading guest values for U_CET and
+ * PL[0-3]_SSP while executing in the kernel is safe, as U_CET is specific to
+ * userspace, and PL[0-3]_SSP are only consumed when transitioning to lower
+ * privilegel levels, i.e. are effectively only consumed by userspace as well.
+ */
+static bool is_xstate_managed_msr(struct kvm_vcpu *vcpu, u32 msr)
+{
+	if (!vcpu)
+		return false;
+
+	switch (msr) {
+	case MSR_IA32_U_CET:
+		return guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) ||
+		       guest_cpu_cap_has(vcpu, X86_FEATURE_IBT);
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		return guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+	default:
+		return false;
+	}
+}
+
+/*
+ * Lock (and if necessary, re-load) the guest FPU, i.e. XSTATE, and access an
+ * MSR that is managed via XSTATE.  Note, the caller is responsible for doing
+ * the initial FPU load, this helper only ensures that guest state is resident
+ * in hardware (the kernel can load its FPU state in IRQ context).
+ */
+static __always_inline void kvm_access_xstate_msr(struct kvm_vcpu *vcpu,
+						  struct msr_data *msr_info,
+						  int access)
+{
+	BUILD_BUG_ON(access != MSR_TYPE_R && access != MSR_TYPE_W);
+
+	KVM_BUG_ON(!is_xstate_managed_msr(vcpu, msr_info->index), vcpu->kvm);
+	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
+
+	kvm_fpu_get();
+	if (access == MSR_TYPE_R)
+		rdmsrq(msr_info->index, msr_info->data);
+	else
+		wrmsrq(msr_info->index, msr_info->data);
+	kvm_fpu_put();
+}
+
+static __maybe_unused void kvm_set_xstate_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	kvm_access_xstate_msr(vcpu, msr_info, MSR_TYPE_W);
+}
+
+static __maybe_unused void kvm_get_xstate_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	kvm_access_xstate_msr(vcpu, msr_info, MSR_TYPE_R);
+}
+
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	u32 msr = msr_info->index;
@@ -4551,11 +4615,25 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
 		    int (*do_msr)(struct kvm_vcpu *vcpu,
 				  unsigned index, u64 *data))
 {
+	bool fpu_loaded = false;
 	int i;
 
-	for (i = 0; i < msrs->nmsrs; ++i)
+	for (i = 0; i < msrs->nmsrs; ++i) {
+		/*
+		 * If userspace is accessing one or more XSTATE-managed MSRs,
+		 * temporarily load the guest's FPU state so that the guest's
+		 * MSR value(s) is resident in hardware and thus can be accessed
+		 * via RDMSR/WRMSR.
+		 */
+		if (!fpu_loaded && is_xstate_managed_msr(vcpu, entries[i].index)) {
+			kvm_load_guest_fpu(vcpu);
+			fpu_loaded = true;
+		}
 		if (do_msr(vcpu, entries[i].index, &entries[i].data))
 			break;
+	}
+	if (fpu_loaded)
+		kvm_put_guest_fpu(vcpu);
 
 	return i;
 }
@@ -5965,6 +6043,7 @@ static int kvm_get_set_one_reg(struct kvm_vcpu *vcpu, unsigned int ioctl,
 	struct kvm_one_reg one_reg;
 	struct kvm_x86_reg_id *reg;
 	u64 __user *user_val;
+	bool load_fpu;
 	int r;
 
 	if (copy_from_user(&one_reg, argp, sizeof(one_reg)))
@@ -5991,12 +6070,18 @@ static int kvm_get_set_one_reg(struct kvm_vcpu *vcpu, unsigned int ioctl,
 
 	guard(srcu)(&vcpu->kvm->srcu);
 
+	load_fpu = is_xstate_managed_msr(vcpu, reg->index);
+	if (load_fpu)
+		kvm_load_guest_fpu(vcpu);
+
 	user_val = u64_to_user_ptr(one_reg.addr);
 	if (ioctl == KVM_GET_ONE_REG)
 		r = kvm_get_one_msr(vcpu, reg->index, user_val);
 	else
 		r = kvm_set_one_msr(vcpu, reg->index, user_val);
 
+	if (load_fpu)
+		kvm_put_guest_fpu(vcpu);
 	return r;
 }
 
-- 
2.51.0.470.ga7dc726c21-goog



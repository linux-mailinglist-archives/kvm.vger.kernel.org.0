Return-Path: <kvm+bounces-32601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 643E19DAE7C
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:20:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24DA7281945
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 068A0204097;
	Wed, 27 Nov 2024 20:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="10HVUhg0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969A1204090
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738817; cv=none; b=kC24Ytk7pLuNd+Pc6uDrs8Iqj6dvAOR364dAHtCJVBAf6l/Xvejif9WwmKzhy8yMIk0jReexEdjoEMJuEmDo/vbi5Xdc1Gh8YlpjIqwHP2voJ6p9pq7E5Yj/0ckuy1B7j/0lmz0FqoevIB+WFqT5+Nugg9ScCKJCGfBhDaKo/20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738817; c=relaxed/simple;
	bh=EetIMtp7JVxm98o/xw+kAm0xx+HlD81H3VpbqeZkXvM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pbcc04KOZLCGeE7gQHCrbxjfFXXbxoLKlmTrF8il2KMgpWOIq595SBYstJjMTg4PEQV43RcGxVUlBKpFZ0T6t/tnqI9+DFPL6xQooZWL/+LXGNEbyf6E1nk5Gay1DMzSYqrkdiirLxbNEx1CaZKGEqzn7oX30/MZpib0oZ/igWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=10HVUhg0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea5bf5354fso130465a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738815; x=1733343615; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qdy0ysM+G41B1MvY5WPlXEIQxuhHoZWa9tmGrp301XM=;
        b=10HVUhg0AdqNDgjPvu0pmcNtEcZG2eQ/+5wMKoUBF2YN1snWtHoOtY/hIIj1Dzh+cn
         XsVD4HhVZYqxjW5UjdMnETV+0BwbXBxrfbQQZhDal5x4RsWR7324Jv5EBFXxH3/4/LTy
         oUsh6fcfWdV41iXzoBewbf28b229+fr3dCIE1lTVjiVMjrEbAQ01nUVrSRmJyPmTerzU
         z4rWTQ4jtHNTMk1NtkHM/cClyxyzG67ho8WlzW8kv99v+bnSiPkf7zNsmysEDLMciCg5
         2PRQ0k028JXA2V8J+1lCum8gKwp3oJXNTt+GnrS3Upc8ETUTLRDRTPsNsrYs6VfKyohp
         myvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738815; x=1733343615;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qdy0ysM+G41B1MvY5WPlXEIQxuhHoZWa9tmGrp301XM=;
        b=nGmPnRRbAOwYJZjsvtSdbGyKnuf4zBDKkPpeZpPzFRHuyY5EynTEhO6xhhg/eacrf3
         ORfoXjYHBk0jE9eM2ESa1af/VONtDmNUjPm9FrS20DEtQ47/ZgtcPVPlmzc8Fkgq8VLb
         wgqRBdcLOS+63aMF3RgcWK2nXD++DaDeLDc0TQTAlaJic/eNAhUvWqe2nfKSYsS6OYSt
         VqJtjgKmmU298BnWXOtDG1EaStIMGgSuN3Z16Lr6XlYQVdz45Y8OslEl8SJiVpambbkp
         Pnrm9avQZKjw69str/GzZpCIvgP9Ug2a2VJ1yz7OFE3hrOFYOtTUqEfzFWiFcxRZW8rp
         vkqQ==
X-Gm-Message-State: AOJu0Yzd2s7VEk+/45l6fMQfc4sG5+BE8RknxwcbWu2OMwJ7PK2OGRFr
	0VokQZs/ttrOVIQhBTFsPGt1C7SWGDc8ocUMbNljBE4AjkDZjfdHMbKwP42tmsdjgWc+sjuxMm0
	c3q/wG6S4ZxlkRq3CaDBKDlqJg1OHSqOvLEg7gCknfByC8G2EHFCvEUcoT1fWFbRAlosxz7Ym02
	mc2yBCGaaLwIRe69bXFwSZpI+lDa+mzUlwAqBpf+SbiS3hMzzE5Q==
X-Google-Smtp-Source: AGHT+IG2iZY/BcwNZC03IsukKXPoEKXnQvS9OO6OSMWHcJ0IevkNrl5bKQilvfbiN2ouZaBfMbmtj1ColXDs9RWE
X-Received: from pjbpw2.prod.google.com ([2002:a17:90b:2782:b0:2e0:915d:d594])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4d0d:b0:2ea:853b:2761 with SMTP id 98e67ed59e1d1-2ee097e3d26mr5726025a91.37.1732738814645;
 Wed, 27 Nov 2024 12:20:14 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:29 +0000
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-16-aaronlewis@google.com>
Subject: [PATCH 15/15] KVM: x86: Hoist VMX MSR intercepts to common x86 code
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Complete the transition of unifying the MSR intercepts for x86 by
hoisting the VMX implementation to common x86 code.

The only new addition to the common implementation over what SVM
already contributed is the check for is_valid_passthrough_msr() which
VMX uses to disallow MSRs from being used as possible passthrough
MSRs.  To distinguish between MSRs that are not valid from MSRs that
are missing from the list kvm_passthrough_msr_slot() returns -EINVAL
for MSRs that are not allowed to be in the list and -ENOENT for MSRs
that it is expecting to be in the list, but aren't.  For the latter
case KVM warns.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/svm/svm.c             |  6 ++
 arch/x86/kvm/vmx/main.c            |  2 +
 arch/x86/kvm/vmx/vmx.c             | 91 +++++++++---------------------
 arch/x86/kvm/vmx/vmx.h             |  4 ++
 arch/x86/kvm/x86.c                 |  4 ++
 7 files changed, 45 insertions(+), 64 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 3f10ce4957f74..db1e0fc002805 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -134,6 +134,7 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
 KVM_X86_OP_OPTIONAL(msr_filter_changed)
 KVM_X86_OP_OPTIONAL(get_msr_bitmap_entries)
 KVM_X86_OP(disable_intercept_for_msr)
+KVM_X86_OP(is_valid_passthrough_msr)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 763fc054a2c56..22ae4dfa94f2c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1834,6 +1834,7 @@ struct kvm_x86_ops {
 				       unsigned long **read_map, u8 *read_bit,
 				       unsigned long **write_map, u8 *write_bit);
 	void (*disable_intercept_for_msr)(struct kvm_vcpu *vcpu, u32 msr, int type);
+	bool (*is_valid_passthrough_msr)(u32 msr);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index aaf244e233b90..2e746abeda215 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -799,6 +799,11 @@ static void svm_get_msr_bitmap_entries(struct kvm_vcpu *vcpu, u32 msr,
 	*write_map = &svm->msrpm[offset];
 }
 
+static bool svm_is_valid_passthrough_msr(u32 msr)
+{
+	return true;
+}
+
 void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	kvm_disable_intercept_for_msr(vcpu, msr, type);
@@ -5065,6 +5070,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.nr_possible_passthrough_msrs = ARRAY_SIZE(direct_access_msrs),
 	.get_msr_bitmap_entries = svm_get_msr_bitmap_entries,
 	.disable_intercept_for_msr = svm_disable_intercept_for_msr,
+	.is_valid_passthrough_msr = svm_is_valid_passthrough_msr,
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 5279c82648fe6..e89c472179dd5 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -179,7 +179,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.possible_passthrough_msrs = vmx_possible_passthrough_msrs,
 	.nr_possible_passthrough_msrs = ARRAY_SIZE(vmx_possible_passthrough_msrs),
+	.get_msr_bitmap_entries = vmx_get_msr_bitmap_entries,
 	.disable_intercept_for_msr = vmx_disable_intercept_for_msr,
+	.is_valid_passthrough_msr = vmx_is_valid_passthrough_msr,
 	.msr_filter_changed = vmx_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4cb3e9a8df2c0..5493a24febd50 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -642,14 +642,12 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
 	return flexpriority_enabled && lapic_in_kernel(vcpu);
 }
 
-static int vmx_get_passthrough_msr_slot(u32 msr)
+bool vmx_is_valid_passthrough_msr(u32 msr)
 {
-	int r;
-
 	switch (msr) {
 	case 0x800 ... 0x8ff:
 		/* x2APIC MSRs. These are handled in vmx_update_msr_bitmap_x2apic() */
-		return -ENOENT;
+		return false;
 	case MSR_IA32_RTIT_STATUS:
 	case MSR_IA32_RTIT_OUTPUT_BASE:
 	case MSR_IA32_RTIT_OUTPUT_MASK:
@@ -664,13 +662,10 @@ static int vmx_get_passthrough_msr_slot(u32 msr)
 	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
-		return -ENOENT;
+		return false;
 	}
 
-	r = kvm_passthrough_msr_slot(msr);
-
-	WARN(!r, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
-	return r;
+	return true;
 }
 
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
@@ -3969,76 +3964,44 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 	vmx->nested.force_msr_bitmap_recalc = true;
 }
 
-void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
+void vmx_get_msr_bitmap_entries(struct kvm_vcpu *vcpu, u32 msr,
+				unsigned long **read_map, u8 *read_bit,
+				unsigned long **write_map, u8 *write_bit)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
-	int idx;
-
-	if (!cpu_has_vmx_msr_bitmap())
-		return;
+	unsigned long *bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
+	u32 offset;
 
-	vmx_msr_bitmap_l01_changed(vmx);
+	*read_bit = *write_bit = msr & 0x1fff;
 
-	/*
-	 * Mark the desired intercept state in shadow bitmap, this is needed
-	 * for resync when the MSR filters change.
-	 */
-	idx = vmx_get_passthrough_msr_slot(msr);
-	if (idx >= 0) {
-		if (type & MSR_TYPE_R)
-			__clear_bit(idx, vcpu->arch.shadow_msr_intercept.read);
-		if (type & MSR_TYPE_W)
-			__clear_bit(idx, vcpu->arch.shadow_msr_intercept.write);
-	}
+	if (msr <= 0x1fff)
+		offset = 0;
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		offset = 0x400;
+	else
+		BUG();
 
-	if ((type & MSR_TYPE_R) &&
-	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ)) {
-		vmx_set_msr_bitmap_read(msr_bitmap, msr);
-		type &= ~MSR_TYPE_R;
-	}
+	*read_map = bitmap + (0 + offset) / sizeof(unsigned long);
+	*write_map = bitmap + (0x800 + offset) / sizeof(unsigned long);
+}
 
-	if ((type & MSR_TYPE_W) &&
-	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE)) {
-		vmx_set_msr_bitmap_write(msr_bitmap, msr);
-		type &= ~MSR_TYPE_W;
-	}
+void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
+{
+	if (!cpu_has_vmx_msr_bitmap())
+		return;
 
-	if (type & MSR_TYPE_R)
-		vmx_clear_msr_bitmap_read(msr_bitmap, msr);
+	kvm_disable_intercept_for_msr(vcpu, msr, type);
 
-	if (type & MSR_TYPE_W)
-		vmx_clear_msr_bitmap_write(msr_bitmap, msr);
+	vmx_msr_bitmap_l01_changed(to_vmx(vcpu));
 }
 
 void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
-	int idx;
-
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
-	vmx_msr_bitmap_l01_changed(vmx);
-
-	/*
-	 * Mark the desired intercept state in shadow bitmap, this is needed
-	 * for resync when the MSR filter changes.
-	 */
-	idx = vmx_get_passthrough_msr_slot(msr);
-	if (idx >= 0) {
-		if (type & MSR_TYPE_R)
-			__set_bit(idx, vcpu->arch.shadow_msr_intercept.read);
-		if (type & MSR_TYPE_W)
-			__set_bit(idx, vcpu->arch.shadow_msr_intercept.write);
-	}
-
-	if (type & MSR_TYPE_R)
-		vmx_set_msr_bitmap_read(msr_bitmap, msr);
+	kvm_enable_intercept_for_msr(vcpu, msr, type);
 
-	if (type & MSR_TYPE_W)
-		vmx_set_msr_bitmap_write(msr_bitmap, msr);
+	vmx_msr_bitmap_l01_changed(to_vmx(vcpu));
 }
 
 static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c40e7c880764f..6b87dcab46e48 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -409,8 +409,12 @@ bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs,
 int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 
+void vmx_get_msr_bitmap_entries(struct kvm_vcpu *vcpu, u32 msr,
+				unsigned long **read_map, u8 *read_bit,
+				unsigned long **write_map, u8 *write_bit);
 void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
 void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
+bool vmx_is_valid_passthrough_msr(u32 msr);
 
 u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
 u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1e607a0eb58a0..3c4a580d51517 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1810,6 +1810,10 @@ int kvm_passthrough_msr_slot(u32 msr)
 {
 	u32 i;
 
+	if (!static_call(kvm_x86_is_valid_passthrough_msr)(msr)) {
+		return -EINVAL;
+	}
+
 	for (i = 0; i < kvm_x86_ops.nr_possible_passthrough_msrs; i++) {
 		if (kvm_x86_ops.possible_passthrough_msrs[i] == msr)
 			return i;
-- 
2.47.0.338.g60cca15819-goog



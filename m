Return-Path: <kvm+bounces-32600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71EC39DAE7B
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:20:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13F15167038
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 902D220408F;
	Wed, 27 Nov 2024 20:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IZ2wn/cz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B44202F84
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738814; cv=none; b=YJlXk+gYpRzjofETjOp9QzzPIkR9hZOhZaQieD9sKmqXarSPTIJ6viTtiF4klilASSoNXS3DEkd5gKtmmyfCOOHIWLWy0qiWSdWxL/wqcDUWwT2XCWS7MK54MZdd+Fe7BwlA6m7BXe5KFa+F7svfLuIFpxpGquVsojzpShcUNh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738814; c=relaxed/simple;
	bh=Elri52haCKBwzOvoskc2RjZrEOm+JNXfS6Tq4FZlWxc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pXl+p6YW9nfkI79yfSLf0ar5dy/Nb7zdlFHWZEZAeISKm+ax1Knr0tOC5IGpYFLDOxo7xlIxsTrEax9nUpYXPZ6gnr2b4vcqAYj/I6cokHfy/j7Eb9U7FQS/XyNkx7Z8VBVgLiDuSNlsxjk9+5aOtwZZfKM3lvs9NOrGnfUkyIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IZ2wn/cz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea3c9178f6so137820a91.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738813; x=1733343613; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q0Rmp1Y4NI9uBs3wof7PI3i1xrNqpza7YTs8RbErkz0=;
        b=IZ2wn/czprZVBOdOyr7LaI5hYPlqLalMy2CjpT4jB1st8DZClbLpnurubwrFu4AA89
         QiF2zns/XUmwGzqxlQ9fpQUc7NikmPvT8/mPEtYJFJ7Lkwquksudj3PDSGDl1L5Zmmtm
         TjSEWwUn5jIjDW3ATeveR0iwulICoFcIidiSbh9kTmJveKPsiWwiVHBM9MJj/K7qX2H7
         3M1Zo/cM3INM/v2iv+dlTL72ccJGgokEzWpOxKxd494VjWsnRK3J/WEN+GwARrTdu0oN
         l4nbyAkSTsL6WbskaO8GFguvlR8RI806Dr7NctFlIT2XAjdUg+x+g6zY1ckgdTmj0HjJ
         iaIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738813; x=1733343613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q0Rmp1Y4NI9uBs3wof7PI3i1xrNqpza7YTs8RbErkz0=;
        b=e/Ys6lzRMMZjt6tkuVy4mcPUJrQfopKXu/XcvDCazQujj2yHOAo6j88+du+mtJ+Guj
         yvYTXrB83+2hvASpcD8fPwDVrPLzuW3G5mtutf684KrY6PdV15GxUG0oKOKhpLx5rrl6
         hgYcvX1UMHBt8FfcTMGj6yyWS4KnueP+5jPZ2XbjAGgyK9Wlc+nL/9RAAsRnueJHMBWn
         r5AkqtrMV7Qbb0pV96B2sVdEFvvTIuEYfiu/s/bAFVMvqnwnGfglKjBYrvTUVEryM5CX
         S3mWRzHjfLpmnduptN+P8uHapwrhr4xhRM91lCo9mnV0gKlIHswQSUwiFG2p1G5C37rp
         AMoA==
X-Gm-Message-State: AOJu0Yx8EPGIZ9QANsPzp67J/1kisMRkNlbfIcLwbF5VLpe6kqLb6Q6b
	E47VN6cvyrgK0zGnZgkub2FHtNqbigwlBYBdjOuRydKM2RvBCwLNOjhd7EJSUOn7Lc6CgWS+Cm8
	cNQGeLIJHsNfkChehuXs2B5ri0aPZ3+L4lO5WphHEfy2fcBzQKpw5CVoMNDvZJeGTTb9mLmig95
	t1H5UROPDRXgBdZppZ0t4wOsTkauoA78Rcx6wO0pG8fcH+FJFyBA==
X-Google-Smtp-Source: AGHT+IFD466s37NISGlOum2vfdsfJlHr5s9SgGYKnvdAXKJwLoZH0gLGfmEa0d0T6mwMngQmUvBLZIeAAozRmVkC
X-Received: from pjbrr16.prod.google.com ([2002:a17:90b:2b50:b0:2ea:5824:7f25])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3e88:b0:2ea:9309:75a7 with SMTP id 98e67ed59e1d1-2ee08e982b3mr5244665a91.2.1732738812644;
 Wed, 27 Nov 2024 12:20:12 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:28 +0000
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-15-aaronlewis@google.com>
Subject: [PATCH 14/15] KVM: x86: Hoist SVM MSR intercepts to common x86 code
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that the SVM and VMX implementations for MSR intercepts are the
same hoist the SVM implementation to common x86 code.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  3 ++
 arch/x86/kvm/svm/svm.c             | 73 ++---------------------------
 arch/x86/kvm/x86.c                 | 75 ++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h                 |  2 +
 5 files changed, 86 insertions(+), 68 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 124c2e1e42026..3f10ce4957f74 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -132,6 +132,7 @@ KVM_X86_OP(apic_init_signal_blocked)
 KVM_X86_OP_OPTIONAL(enable_l2_tlb_flush)
 KVM_X86_OP_OPTIONAL(migrate_timers)
 KVM_X86_OP_OPTIONAL(msr_filter_changed)
+KVM_X86_OP_OPTIONAL(get_msr_bitmap_entries)
 KVM_X86_OP(disable_intercept_for_msr)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 808b5365e4bd2..763fc054a2c56 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1830,6 +1830,9 @@ struct kvm_x86_ops {
 
 	const u32 * const possible_passthrough_msrs;
 	const u32 nr_possible_passthrough_msrs;
+	void (*get_msr_bitmap_entries)(struct kvm_vcpu *vcpu, u32 msr,
+				       unsigned long **read_map, u8 *read_bit,
+				       unsigned long **write_map, u8 *write_bit);
 	void (*disable_intercept_for_msr)(struct kvm_vcpu *vcpu, u32 msr, int type);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 31ed6c68e8194..aaf244e233b90 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -799,84 +799,20 @@ static void svm_get_msr_bitmap_entries(struct kvm_vcpu *vcpu, u32 msr,
 	*write_map = &svm->msrpm[offset];
 }
 
-#define BUILD_SVM_MSR_BITMAP_HELPER(fn, bitop, access)			     \
-static inline void fn(struct kvm_vcpu *vcpu, u32 msr)			     \
-{									     \
-	unsigned long *read_map, *write_map;				     \
-	u8 read_bit, write_bit;						     \
-									     \
-	svm_get_msr_bitmap_entries(vcpu, msr, &read_map, &read_bit,	     \
-				   &write_map, &write_bit);		     \
-	bitop(access##_bit, access##_map);				     \
-}
-
-BUILD_SVM_MSR_BITMAP_HELPER(svm_set_msr_bitmap_read, __set_bit, read)
-BUILD_SVM_MSR_BITMAP_HELPER(svm_set_msr_bitmap_write, __set_bit, write)
-BUILD_SVM_MSR_BITMAP_HELPER(svm_clear_msr_bitmap_read, __clear_bit, read)
-BUILD_SVM_MSR_BITMAP_HELPER(svm_clear_msr_bitmap_write, __clear_bit, write)
-
 void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-	int slot;
-
-	slot = kvm_passthrough_msr_slot(msr);
-	WARN_ON(slot == -ENOENT);
-	if (slot >= 0) {
-		/* Set the shadow bitmaps to the desired intercept states */
-		if (type & MSR_TYPE_R)
-			__clear_bit(slot, vcpu->arch.shadow_msr_intercept.read);
-		if (type & MSR_TYPE_W)
-			__clear_bit(slot, vcpu->arch.shadow_msr_intercept.write);
-	}
-
-	/*
-	 * Don't disabled interception for the MSR if userspace wants to
-	 * handle it.
-	 */
-	if ((type & MSR_TYPE_R) && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ)) {
-		svm_set_msr_bitmap_read(vcpu, msr);
-		type &= ~MSR_TYPE_R;
-	}
-
-	if ((type & MSR_TYPE_W) && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE)) {
-		svm_set_msr_bitmap_write(vcpu, msr);
-		type &= ~MSR_TYPE_W;
-	}
-
-	if (type & MSR_TYPE_R)
-		svm_clear_msr_bitmap_read(vcpu, msr);
-
-	if (type & MSR_TYPE_W)
-		svm_clear_msr_bitmap_write(vcpu, msr);
+	kvm_disable_intercept_for_msr(vcpu, msr, type);
 
 	svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
-	svm->nested.force_msr_bitmap_recalc = true;
+	to_svm(vcpu)->nested.force_msr_bitmap_recalc = true;
 }
 
 void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-	int slot;
-
-	slot = kvm_passthrough_msr_slot(msr);
-	WARN_ON(slot == -ENOENT);
-	if (slot >= 0) {
-		/* Set the shadow bitmaps to the desired intercept states */
-		if (type & MSR_TYPE_R)
-			__set_bit(slot, vcpu->arch.shadow_msr_intercept.read);
-		if (type & MSR_TYPE_W)
-			__set_bit(slot, vcpu->arch.shadow_msr_intercept.write);
-	}
-
-	if (type & MSR_TYPE_R)
-		svm_set_msr_bitmap_read(vcpu, msr);
-
-	if (type & MSR_TYPE_W)
-		svm_set_msr_bitmap_write(vcpu, msr);
+	kvm_enable_intercept_for_msr(vcpu, msr, type);
 
 	svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
-	svm->nested.force_msr_bitmap_recalc = true;
+	to_svm(vcpu)->nested.force_msr_bitmap_recalc = true;
 }
 
 unsigned long *svm_vcpu_alloc_msrpm(void)
@@ -5127,6 +5063,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.possible_passthrough_msrs = direct_access_msrs,
 	.nr_possible_passthrough_msrs = ARRAY_SIZE(direct_access_msrs),
+	.get_msr_bitmap_entries = svm_get_msr_bitmap_entries,
 	.disable_intercept_for_msr = svm_disable_intercept_for_msr,
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2082ae8dc5db1..1e607a0eb58a0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1819,6 +1819,81 @@ int kvm_passthrough_msr_slot(u32 msr)
 }
 EXPORT_SYMBOL_GPL(kvm_passthrough_msr_slot);
 
+#define BUILD_KVM_MSR_BITMAP_HELPER(fn, bitop, access)			     \
+static inline void fn(struct kvm_vcpu *vcpu, u32 msr)			     \
+{									     \
+	unsigned long *read_map, *write_map;				     \
+	u8 read_bit, write_bit;						     \
+									     \
+	static_call(kvm_x86_get_msr_bitmap_entries)(vcpu, msr,		     \
+						    &read_map, &read_bit,    \
+				   		    &write_map, &write_bit); \
+	bitop(access##_bit, access##_map);				     \
+}
+
+BUILD_KVM_MSR_BITMAP_HELPER(kvm_set_msr_bitmap_read, __set_bit, read)
+BUILD_KVM_MSR_BITMAP_HELPER(kvm_set_msr_bitmap_write, __set_bit, write)
+BUILD_KVM_MSR_BITMAP_HELPER(kvm_clear_msr_bitmap_read, __clear_bit, read)
+BUILD_KVM_MSR_BITMAP_HELPER(kvm_clear_msr_bitmap_write, __clear_bit, write)
+
+void kvm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
+{
+	int slot;
+
+	slot = kvm_passthrough_msr_slot(msr);
+	WARN_ON(slot == -ENOENT);
+	if (slot >= 0) {
+		/* Set the shadow bitmaps to the desired intercept states */
+		if (type & MSR_TYPE_R)
+			__clear_bit(slot, vcpu->arch.shadow_msr_intercept.read);
+		if (type & MSR_TYPE_W)
+			__clear_bit(slot, vcpu->arch.shadow_msr_intercept.write);
+	}
+
+	/*
+	 * Don't disabled interception for the MSR if userspace wants to
+	 * handle it.
+	 */
+	if ((type & MSR_TYPE_R) && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ)) {
+		kvm_set_msr_bitmap_read(vcpu, msr);
+		type &= ~MSR_TYPE_R;
+	}
+
+	if ((type & MSR_TYPE_W) && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE)) {
+		kvm_set_msr_bitmap_write(vcpu, msr);
+		type &= ~MSR_TYPE_W;
+	}
+
+	if (type & MSR_TYPE_R)
+		kvm_clear_msr_bitmap_read(vcpu, msr);
+
+	if (type & MSR_TYPE_W)
+		kvm_clear_msr_bitmap_write(vcpu, msr);
+}
+EXPORT_SYMBOL_GPL(kvm_disable_intercept_for_msr);
+
+void kvm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
+{
+	int slot;
+
+	slot = kvm_passthrough_msr_slot(msr);
+	WARN_ON(slot == -ENOENT);
+	if (slot >= 0) {
+		/* Set the shadow bitmaps to the desired intercept states */
+		if (type & MSR_TYPE_R)
+			__set_bit(slot, vcpu->arch.shadow_msr_intercept.read);
+		if (type & MSR_TYPE_W)
+			__set_bit(slot, vcpu->arch.shadow_msr_intercept.write);
+	}
+
+	if (type & MSR_TYPE_R)
+		kvm_set_msr_bitmap_read(vcpu, msr);
+
+	if (type & MSR_TYPE_W)
+		kvm_set_msr_bitmap_write(vcpu, msr);
+}
+EXPORT_SYMBOL_GPL(kvm_enable_intercept_for_msr);
+
 static void kvm_msr_filter_changed(struct kvm_vcpu *vcpu)
 {
 	u32 msr, i;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 208f0698c64e2..239cc4de49c58 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -556,6 +556,8 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva);
 bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 int kvm_passthrough_msr_slot(u32 msr);
+void kvm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
+void kvm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
 
 enum kvm_msr_access {
 	MSR_TYPE_R	= BIT(0),
-- 
2.47.0.338.g60cca15819-goog



Return-Path: <kvm+bounces-29921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 081759B40EF
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 04:16:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C64E1F23272
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 03:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA7582022C6;
	Tue, 29 Oct 2024 03:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RQfXhetx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BE71FCF73
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 03:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730171658; cv=none; b=uwdISf6GSbHm4JvNl1gGCwkwFawJdKLOpgH6ku0s0ACH5OY0rZofN2oTwVWQXqL3wFTOTciKnxIxRggjYNcirq/qhUt4JOdp2xgV8JDUSSPqOebuCHz9dPH7+m5k281Gk2cvjF/mJMjylT+zkRueoA7QrAmtGcaofMWAcjE9EiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730171658; c=relaxed/simple;
	bh=BluNThS9r+K/CgjMy4ZogSIbHQOXp2EC8HKk6XGRa3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlNslxdkwCMhPRaf5XUD+JOTw2Y1MzQYmgN2Sem2Rom2pueERE5BRiI8ZsSSggxvuEDb/ongf5SXzfrYMdRUZOqzVfaWdWDe27QTSrEPY5V3OVZaijsJschhJpW/onzsYAizA3UBAmf7DnR/rj0dk6dzUWFGwzCfdbGGYsH9cr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RQfXhetx; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20cb47387ceso44762465ad.1
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 20:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730171655; x=1730776455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rQ7IkF8ldMF5vJTFcSqC1bgJ/63e0IOrqwrvyfvip0g=;
        b=RQfXhetxrtWSh3eNe5LWhy60a2Q1BLj527YughAhNctjBjj7wLP0gl+skhcwMFt8ny
         UL64ucg55bU+IWyGnFKFBqKkd1V4hwgEv9HFifA1a7q3qnwyOOZmBjoHI5gwNEmTGaU7
         xezzHmoKf+V6GCrIgOC9J47yrim7iezxhZSV/Ey/2xSkaFdvr9QCIEBCgvDlHP7aWzPh
         ZMDEo69hOBd8VtWlubzZGX28OzdIhMmD7Y1P8DfBdSTZsiVC53SJeWbK4Cg/9t+CQEbd
         ZxIy2K/0GCtROrJ0FRSXdahPXxUDxb9ULvd36fatQf8WlLItuOPDzoX4OgFGj7qUEMJR
         WapA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730171655; x=1730776455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rQ7IkF8ldMF5vJTFcSqC1bgJ/63e0IOrqwrvyfvip0g=;
        b=IFWMHaEkPmSWGEqtHoQKarSMJ6r/NPkJC+EhrYzfZsAbNzdRyBJmKf0dAC41VgudpP
         r2i5z+4aAam5VacurVaaNVA0ynAdvRsdATpE3cBIFRBiaiw45hqHmoPUCZ376KfSFHKq
         cV3j++gzEh/ccCoeiyjtP4o2fP+rjxxXBEdnB5U5I2nlC3abnOLdnVXfja+dIM8y8ETC
         vjn9jGe6osrmBJeBRO4W24tk9kwrFj9CrBkwPZxXOBhgeCgoVlv6kRCPz+3bigcuqBJ7
         F5Tc9PjAjzrJr4fp+bDYW1T5tPeSRxeqPm4X+YOL9+t03LzmLVBCFzXxoCj/sOo4hXje
         9F1w==
X-Forwarded-Encrypted: i=1; AJvYcCVvsHYo85R70RnLy1qiSHeFQj3ZYz0N0kxCC3m82fOOrn8MvTpvhrCrTu9eydbplobfyeI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTKEpUgwpWXQTqNsW35aX19rmLlyvJ9v2O81//KQUpTIvXBbUz
	jAIAiO7TCuw2Jt6eCv+w64GRfitlEDObV/TfJTnqAmwbd+krQPVV
X-Google-Smtp-Source: AGHT+IEImm5WxZi1qqQHEuoSrB1CkyaP1OLsLXNba5yq1aSYGuGxBa3h7IkKFnpsoXA0l8xRTKS+OA==
X-Received: by 2002:a17:902:ecc5:b0:20c:7181:51cb with SMTP id d9443c01a7336-210c6892b62mr146562315ad.18.1730171654725;
        Mon, 28 Oct 2024 20:14:14 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bbf43476sm57300795ad.24.2024.10.28.20.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 20:14:14 -0700 (PDT)
From: Yong He <zhuangel570@gmail.com>
X-Google-Original-From: Yong He <alexyonghe@tencent.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: wanpengli@tencent.com,
	alexyonghe@tencent.com,
	junaids@google.com
Subject: [PATCH 2/2] KVM: x86: introduce cache configurations for previous CR3s
Date: Tue, 29 Oct 2024 11:14:00 +0800
Message-ID: <20241029031400.622854-3-alexyonghe@tencent.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241029031400.622854-1-alexyonghe@tencent.com>
References: <20241029031400.622854-1-alexyonghe@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yong He <alexyonghe@tencent.com>

Introduce prev_roots_num param, so that we use more cache of
previous CR3/root_hpa pairs, which help us to reduce shadow
page table evict and rebuild overhead.

Signed-off-by: Yong He <alexyonghe@tencent.com>
---
 arch/x86/kvm/mmu.h        |  1 +
 arch/x86/kvm/mmu/mmu.c    | 40 +++++++++++++++++++++++++++------------
 arch/x86/kvm/vmx/nested.c |  4 ++--
 arch/x86/kvm/x86.c        |  2 +-
 4 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 4341e0e28..e5615433a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -7,6 +7,7 @@
 #include "cpuid.h"
 
 extern bool __read_mostly enable_mmio_caching;
+extern uint __read_mostly prev_roots_num;
 
 #define PT_WRITABLE_SHIFT 1
 #define PT_USER_SHIFT 2
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7813d28b0..2acc24dd2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -96,6 +96,22 @@ __MODULE_PARM_TYPE(nx_huge_pages_recovery_period_ms, "uint");
 static bool __read_mostly force_flush_and_sync_on_reuse;
 module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
 
+static int prev_roots_num_param(const char *val, const struct kernel_param *kp)
+{
+	return param_set_uint_minmax(val, kp, KVM_MMU_NUM_PREV_ROOTS, KVM_MMU_NUM_PREV_ROOTS_MAX);
+}
+
+static const struct kernel_param_ops prev_roots_num_ops = {
+	.set = prev_roots_num_param,
+	.get = param_get_uint,
+};
+
+uint __read_mostly prev_roots_num = KVM_MMU_NUM_PREV_ROOTS;
+EXPORT_SYMBOL_GPL(prev_roots_num);
+module_param_cb(prev_roots_num, &prev_roots_num_ops,
+		&prev_roots_num, 0644);
+__MODULE_PARM_TYPE(prev_roots_num, "uint");
+
 /*
  * When setting this variable to true it enables Two-Dimensional-Paging
  * where the hardware walks 2 page tables:
@@ -3594,12 +3610,12 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 		&& VALID_PAGE(mmu->root.hpa);
 
 	if (!free_active_root) {
-		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+		for (i = 0; i < prev_roots_num; i++)
 			if ((roots_to_free & KVM_MMU_ROOT_PREVIOUS(i)) &&
 			    VALID_PAGE(mmu->prev_roots[i].hpa))
 				break;
 
-		if (i == KVM_MMU_NUM_PREV_ROOTS)
+		if (i == prev_roots_num)
 			return;
 	}
 
@@ -3608,7 +3624,7 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 	else
 		write_lock(&kvm->mmu_lock);
 
-	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+	for (i = 0; i < prev_roots_num; i++)
 		if (roots_to_free & KVM_MMU_ROOT_PREVIOUS(i))
 			mmu_free_root_page(kvm, &mmu->prev_roots[i].hpa,
 					   &invalid_list);
@@ -3655,7 +3671,7 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 	 */
 	WARN_ON_ONCE(mmu->root_role.guest_mode);
 
-	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+	for (i = 0; i < prev_roots_num; i++) {
 		root_hpa = mmu->prev_roots[i].hpa;
 		if (!VALID_PAGE(root_hpa))
 			continue;
@@ -4066,7 +4082,7 @@ void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu)
 	unsigned long roots_to_free = 0;
 	int i;
 
-	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+	for (i = 0; i < prev_roots_num; i++)
 		if (is_unsync_root(vcpu->arch.mmu->prev_roots[i].hpa))
 			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
 
@@ -4814,7 +4830,7 @@ static bool cached_root_find_and_keep_current(struct kvm *kvm, struct kvm_mmu *m
 	if (is_root_usable(&mmu->root, new_pgd, new_role))
 		return true;
 
-	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+	for (i = 0; i < prev_roots_num; i++) {
 		/*
 		 * The swaps end up rotating the cache like this:
 		 *   C   0 1 2 3   (on entry to the function)
@@ -4845,7 +4861,7 @@ static bool cached_root_find_without_current(struct kvm *kvm, struct kvm_mmu *mm
 {
 	uint i;
 
-	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+	for (i = 0; i < prev_roots_num; i++)
 		if (is_root_usable(&mmu->prev_roots[i], new_pgd, new_role))
 			goto hit;
 
@@ -4854,7 +4870,7 @@ static bool cached_root_find_without_current(struct kvm *kvm, struct kvm_mmu *mm
 hit:
 	swap(mmu->root, mmu->prev_roots[i]);
 	/* Bubble up the remaining roots.  */
-	for (; i < KVM_MMU_NUM_PREV_ROOTS - 1; i++)
+	for (; i < prev_roots_num - 1; i++)
 		mmu->prev_roots[i] = mmu->prev_roots[i + 1];
 	mmu->prev_roots[i].hpa = INVALID_PAGE;
 	return true;
@@ -5795,7 +5811,7 @@ static void __kvm_mmu_free_obsolete_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 	if (is_obsolete_root(kvm, mmu->root.hpa))
 		roots_to_free |= KVM_MMU_ROOT_CURRENT;
 
-	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+	for (i = 0; i < prev_roots_num; i++) {
 		if (is_obsolete_root(kvm, mmu->prev_roots[i].hpa))
 			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
 	}
@@ -6125,7 +6141,7 @@ void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	if (roots & KVM_MMU_ROOT_CURRENT)
 		__kvm_mmu_invalidate_addr(vcpu, mmu, addr, mmu->root.hpa);
 
-	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+	for (i = 0; i < prev_roots_num; i++) {
 		if (roots & KVM_MMU_ROOT_PREVIOUS(i))
 			__kvm_mmu_invalidate_addr(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
 	}
@@ -6159,7 +6175,7 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 	if (pcid == kvm_get_active_pcid(vcpu))
 		roots |= KVM_MMU_ROOT_CURRENT;
 
-	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+	for (i = 0; i < prev_roots_num; i++) {
 		if (VALID_PAGE(mmu->prev_roots[i].hpa) &&
 		    pcid == kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd))
 			roots |= KVM_MMU_ROOT_PREVIOUS(i);
@@ -6271,7 +6287,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 
 	mmu->root.hpa = INVALID_PAGE;
 	mmu->root.pgd = 0;
-	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+	for (i = 0; i < prev_roots_num; i++)
 		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 
 	/* vcpu->arch.guest_mmu isn't used when !tdp_enabled. */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2392a7ef2..d7e375c34 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -394,7 +394,7 @@ static void nested_ept_invalidate_addr(struct kvm_vcpu *vcpu, gpa_t eptp,
 
 	WARN_ON_ONCE(!mmu_is_nested(vcpu));
 
-	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+	for (i = 0; i < prev_roots_num; i++) {
 		cached_root = &vcpu->arch.mmu->prev_roots[i];
 
 		if (nested_ept_root_matches(cached_root->hpa, cached_root->pgd,
@@ -5820,7 +5820,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 					    operand.eptp))
 			roots_to_free |= KVM_MMU_ROOT_CURRENT;
 
-		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+		for (i = 0; i < prev_roots_num; i++) {
 			if (nested_ept_root_matches(mmu->prev_roots[i].hpa,
 						    mmu->prev_roots[i].pgd,
 						    operand.eptp))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c983c8e43..047cf66da 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1235,7 +1235,7 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
 	if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE))
 		return;
 
-	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+	for (i = 0; i < prev_roots_num; i++)
 		if (kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd) == pcid)
 			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
 
-- 
2.43.5



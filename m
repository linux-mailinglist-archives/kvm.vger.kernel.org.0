Return-Path: <kvm+bounces-21383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0860A92DCED
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 01:45:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0353E1C22A9B
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C715A16A940;
	Wed, 10 Jul 2024 23:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tTPY3qEG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f201.google.com (mail-vk1-f201.google.com [209.85.221.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F14015F409
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 23:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654970; cv=none; b=I6S79aGE4GN/ESAS28SBBCTOlfe/LtcLQRGG9wKkM1ig63M3PofdIL0EdEmfILrhBvN9f21y6As7QPLSv0VsHo/KN1o/91DiHsbY2r54zpMx09dDoS5Xt76yeFXvYlNyOEsus5EdO2UEGaefjxxS6D6OMbuJBHw77gqhb/U/sNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654970; c=relaxed/simple;
	bh=E7C1PVOtD+i0CMt4EuXJKTOZhuRKpDD4D1ufbjsXsgA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f0MuvOw9a8bsPmDTO/eQDvwsj9CN79aHWq0JrlkylAg+6KIHxbCO6GBEs4kR1UI3kexu0bgFBbDWJv8RWccEjPiKxIctAOf07IbpzYzQFwEDKlHG28CxxTC0HAqGKQHH5lC77fJEvZXHfa4Key8CA2hEm4c/EJ6YQcii1DpU8c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tTPY3qEG; arc=none smtp.client-ip=209.85.221.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f201.google.com with SMTP id 71dfb90a1353d-4f2fbc2cca9so113047e0c.0
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 16:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654966; x=1721259766; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vMX//RNaH4NkIl2m+HJXagx9p57k7/J+D9F5NIPrc7U=;
        b=tTPY3qEGpyKrDknDQYOzinf0Eg8wEp7DbObXjd72K+D7hWCBHVE6NvexE+GVdB9Nh8
         ST8gTDtT6oEcbBrru5DUi3pbq1qWV5/j3EqUPl8XMcasT6UOGro4nkQSMItXf3BGvqGv
         Q4wDsJbd17Uut42SdcTb8HFQVaNObFdl+AbkwwRWE6gU2kRCTbWTyVhlclkZUOl7hWvV
         USy+dZcA26D4P1ERqttWZYog3ZEyrNA/HhRZRF5PlFjGg/M/Lf0V/BfhOoAkd9dTsUkR
         oXNPovlMhLIPpow/EEh8jFX/7QIFt//ILkqpcPv5pWdyB2Kxw7vE/EAej2VihOX7Xake
         6UWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654966; x=1721259766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vMX//RNaH4NkIl2m+HJXagx9p57k7/J+D9F5NIPrc7U=;
        b=Sd04BINWJ5sRKPimk4FwK7J8jgZgcf2/v5+mXf+WADO3Mv6/6DBM7wBWsmh2xinhNA
         fpgeYEkiuajTt834W5U7YU1iq7NYGxEgoQEejFzGqDOP0CRtEJL8NXjXkZlsSmhGmoKC
         Xyd6tEJg2W+Mwv00rkp/IfBcWfGfagPZrgp4yTRYYJlHteUXeRljWkH3ymZ94EWcIkVx
         NpOYxYxkH6D4et9Q61rCkKhlPWv6drzBDQCb5qLmZ0qx/xv7sksSqIswXBuS4KPA/5Ch
         hxcrPjA3c33ZGx1JlMkHd4+wL6jlAWn1BIGiiKXSvMvW2w+jALcnUIRZXmHy46poMfZt
         eamA==
X-Forwarded-Encrypted: i=1; AJvYcCXpNQn/vLRlPA7PYriS5eB5wDyaaiVQE8gkdDXHG+ZoKe6EZtIP4GE9GK4uDELzb5sQo2JkYuANFYZR670B2vZBOxC3
X-Gm-Message-State: AOJu0YxL9IE5SoV3t6JEiu2llWjbyzPCzNR1amMeWz151aL1MQlt0EtG
	cBec0pEjKkGm2uGLJfpTgmgl398Oz3KMOBbiZpomn6NKUcayKP6eGurzckQXndyIxR9Y9dDk0HT
	/8FZ7zjkAcQNn2JOpdA==
X-Google-Smtp-Source: AGHT+IEugpK0Yfh/FPCI48ugZ9OJOyQKqaQUSbGH7U/GzTR99sI48hv2h3UP5y+olkBHP+PFInBjfeGEoeNdcaay
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6122:a03:b0:4ef:5477:6a49 with SMTP
 id 71dfb90a1353d-4f33f2e712bmr190008e0c.2.1720654965985; Wed, 10 Jul 2024
 16:42:45 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:12 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-9-jthoughton@google.com>
Subject: [RFC PATCH 08/18] KVM: x86: Add KVM Userfault support
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

The first prong for enabling KVM Userfault support for x86 is to be able
to inform userspace of userfaults. We know when userfaults occurs when
fault->pfn comes back as KVM_PFN_ERR_FAULT, so in
kvm_mmu_prepare_memory_fault_exit(), simply check if fault->pfn is
indeed KVM_PFN_ERR_FAULT. This means always setting fault->pfn to a
known value (I have chosen KVM_PFN_ERR_FAULT) before calling
kvm_mmu_prepare_memory_fault_exit().

The next prong is to unmap pages that are newly userfault-enabled. Do
this in kvm_arch_pre_set_memory_attributes().

The final prong is to only allow PAGE_SIZE mappings when KVM Userfault
is enabled. This prevents us from mapping a userfault-enabled gfn with a
fault on a non-userfault-enabled gfn.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/mmu/mmu.c          | 60 ++++++++++++++++++++++++++-------
 arch/x86/kvm/mmu/mmu_internal.h |  3 +-
 include/linux/kvm_host.h        |  5 ++-
 4 files changed, 55 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 80e5afde69f4..ebd1ec6600bc 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -45,6 +45,7 @@ config KVM
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_WERROR if WERROR
+	select KVM_USERFAULT
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1432deb75cbb..6b6a053758ec 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3110,6 +3110,13 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 	struct kvm_lpage_info *linfo;
 	int host_level;
 
+	/*
+	 * KVM Userfault requires new mappings to be 4K, as userfault check was
+	 * done only for the particular page was faulted on.
+	 */
+	if (kvm_userfault_enabled(kvm))
+		return PG_LEVEL_4K;
+
 	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
 		linfo = lpage_info_slot(gfn, slot, max_level);
@@ -3265,6 +3272,9 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		return RET_PF_RETRY;
 	}
 
+	if (fault->pfn == KVM_PFN_ERR_USERFAULT)
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+
 	return -EFAULT;
 }
 
@@ -4316,6 +4326,9 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
 {
 	u8 req_max_level;
 
+	if (kvm_userfault_enabled(kvm))
+		return PG_LEVEL_4K;
+
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
@@ -4335,6 +4348,12 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 {
 	int max_order, r;
 
+	/*
+	 * Make sure a pfn is set so that kvm_mmu_prepare_memory_fault_exit
+	 * doesn't read uninitialized memory.
+	 */
+	fault->pfn = KVM_PFN_ERR_FAULT;
+
 	if (!kvm_slot_can_be_private(fault->slot)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
@@ -7390,21 +7409,37 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range)
 {
+	unsigned long attrs = range->arg.attributes;
+
 	/*
-	 * Zap SPTEs even if the slot can't be mapped PRIVATE.  KVM x86 only
-	 * supports KVM_MEMORY_ATTRIBUTE_PRIVATE, and so it *seems* like KVM
-	 * can simply ignore such slots.  But if userspace is making memory
-	 * PRIVATE, then KVM must prevent the guest from accessing the memory
-	 * as shared.  And if userspace is making memory SHARED and this point
-	 * is reached, then at least one page within the range was previously
-	 * PRIVATE, i.e. the slot's possible hugepage ranges are changing.
-	 * Zapping SPTEs in this case ensures KVM will reassess whether or not
-	 * a hugepage can be used for affected ranges.
+	 * For KVM_MEMORY_ATTRIBUTE_PRIVATE:
+	 *  Zap SPTEs even if the slot can't be mapped PRIVATE.  It *seems* like
+	 *  KVM can simply ignore such slots.  But if userspace is making memory
+	 *  PRIVATE, then KVM must prevent the guest from accessing the memory
+	 *  as shared.  And if userspace is making memory SHARED and this point
+	 *  is reached, then at least one page within the range was previously
+	 *  PRIVATE, i.e. the slot's possible hugepage ranges are changing.
+	 *  Zapping SPTEs in this case ensures KVM will reassess whether or not
+	 *  a hugepage can be used for affected ranges.
+	 *
+	 * For KVM_MEMORY_ATTRIBUTE_USERFAULT:
+	 *  When enabling, we want to zap the mappings that land in @range,
+	 *  otherwise we will not be able to trap vCPU accesses.
+	 *  When disabling, we don't need to zap anything.
 	 */
-	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
+	if (WARN_ON_ONCE(!kvm_userfault_enabled(kvm) &&
+			 !kvm_arch_has_private_mem(kvm)))
 		return false;
 
-	return kvm_unmap_gfn_range(kvm, range);
+	if (kvm_arch_has_private_mem(kvm) ||
+			(attrs & KVM_MEMORY_ATTRIBUTE_USERFAULT))
+		return kvm_unmap_gfn_range(kvm, range);
+
+	/*
+	 * We are disabling USERFAULT. No unmap necessary. An unmap to get
+	 * huge mappings again will come later.
+	 */
+	return false;
 }
 
 static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
@@ -7458,7 +7493,8 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 	 * a range that has PRIVATE GFNs, and conversely converting a range to
 	 * SHARED may now allow hugepages.
 	 */
-	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
+	if (WARN_ON_ONCE(!kvm_userfault_enabled(kvm) &&
+			 !kvm_arch_has_private_mem(kvm)))
 		return false;
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ce2fcd19ba6b..9d8c8c3e00a1 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -284,7 +284,8 @@ static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 {
 	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
 				      PAGE_SIZE, fault->write, fault->exec,
-				      fault->is_private);
+				      fault->is_private,
+				      fault->pfn == KVM_PFN_ERR_USERFAULT);
 }
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2005906c78c8..dc12d0a5498b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2400,7 +2400,8 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 						 gpa_t gpa, gpa_t size,
 						 bool is_write, bool is_exec,
-						 bool is_private)
+						 bool is_private,
+						 bool is_userfault)
 {
 	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
 	vcpu->run->memory_fault.gpa = gpa;
@@ -2410,6 +2411,8 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 	vcpu->run->memory_fault.flags = 0;
 	if (is_private)
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
+	if (is_userfault)
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_USERFAULT;
 }
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-- 
2.45.2.993.g49e7a77208-goog



Return-Path: <kvm+bounces-29649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA0069AE8E9
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 16:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89CFF293F66
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 14:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95411E378A;
	Thu, 24 Oct 2024 14:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BHYSR9pB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78031EBFE4;
	Thu, 24 Oct 2024 14:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729780212; cv=none; b=Nxr08wO9w9kwjCNSG095RRp4ctHC2zsekR+hoBLsgyF93gsSgDBQLtexmnNpUX0qzAhLp1DZlJlQW2NOMxRIxsE6uGHHuhmShTe7Neq54+mGJAnuo+Wym7mJKxiP1jofEau2sXLhaV8z6NqPDmjARmiSzcOuS2wmZEEOSpvkTKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729780212; c=relaxed/simple;
	bh=T05ZMOyThtGE5f2OTn9E4J0GkLKprBESCNSczcrAbsY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MxLnFOuhGUGmczLN8EzC3p9qVM43VzlvduJT55T4UHXx8FdsWlXglAYrYOOIkWJxzgim2CKYfCPijNHs4+sRXUyBTLuI9b8zihg1hJIL5HRenWKkkG5p58wq+aaGLcfhzW7RLH5rcryhlMBpAHzIHR+fcR8VJq/oUR5JjN0A/og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BHYSR9pB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE545C4CEC7;
	Thu, 24 Oct 2024 14:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729780211;
	bh=T05ZMOyThtGE5f2OTn9E4J0GkLKprBESCNSczcrAbsY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=BHYSR9pBBsMpJ48PvzQ5vi3PlbCKBU45gWbS74GOT0vpYG2MTTRaDF6Tia3IqGmp0
	 +2fPS3k8r83CNicL2JOnWfdVm9RfuA1hzv5ktQ32EHShPoM0xuJ5cM7fEDdy+mxncX
	 Z1fkRLweZlFH4yr/1vMYxXM4lsL+cLq9/okHPEwg9zvNNNjfZo4Buax3vub5FPyGWP
	 jNBHc3E3AWzmkhmhs2VPpomE1+8qKIvZfzNIsCCNADBHZ+tDcsyA77u45Ps/ihMrKA
	 eWNRFa5e2ppY6WNwT+bz7A/Dqdad4bYmHVSWTzzwx3FDjQ85K9jGPo453XYh1cmNoa
	 Asu+ux01o/3ZQ==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v5 21/43] arm64: RME: Runtime faulting of memory
In-Reply-To: <20241004152804.72508-22-steven.price@arm.com>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-22-steven.price@arm.com>
Date: Thu, 24 Oct 2024 20:00:00 +0530
Message-ID: <yq5a5xphmv4n.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> +static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
> +			 kvm_pfn_t pfn, unsigned long map_size,
> +			 enum kvm_pgtable_prot prot,
> +			 struct kvm_mmu_memory_cache *memcache)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	struct page *page = pfn_to_page(pfn);
> +
> +	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
> +		return -EFAULT;
> +
> +	if (!realm_is_addr_protected(realm, ipa))
> +		return realm_map_non_secure(realm, ipa, page, map_size,
> +					    memcache);
> +
> +	return realm_map_protected(realm, ipa, page, map_size, memcache);
> +}
> +


Some of these pfn_to_page(pfn) conversions can be avoided because the
callers are essentially expecting a pfn value (converting page_to_phys())
It also helps to clarify whether we are operating on a compound page or
not.

Something like below?

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index cd42c19ca21d..bf5702c8dbee 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -110,13 +110,13 @@ void kvm_realm_unmap_range(struct kvm *kvm,
 			   bool unmap_private);
 int realm_map_protected(struct realm *realm,
 			unsigned long base_ipa,
-			struct page *dst_page,
-			unsigned long map_size,
+			kvm_pfn_t pfn,
+			unsigned long size,
 			struct kvm_mmu_memory_cache *memcache);
 int realm_map_non_secure(struct realm *realm,
 			 unsigned long ipa,
-			 struct page *page,
-			 unsigned long map_size,
+			 kvm_pfn_t pfn,
+			 unsigned long size,
 			 struct kvm_mmu_memory_cache *memcache);
 int realm_set_ipa_state(struct kvm_vcpu *vcpu,
 			unsigned long addr, unsigned long end,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 569f63695bef..254e90c014cf 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1452,16 +1452,15 @@ static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
 			 struct kvm_mmu_memory_cache *memcache)
 {
 	struct realm *realm = &kvm->arch.realm;
-	struct page *page = pfn_to_page(pfn);
 
 	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
 		return -EFAULT;
 
 	if (!realm_is_addr_protected(realm, ipa))
-		return realm_map_non_secure(realm, ipa, page, map_size,
+		return realm_map_non_secure(realm, ipa, pfn, map_size,
 					    memcache);
 
-	return realm_map_protected(realm, ipa, page, map_size, memcache);
+	return realm_map_protected(realm, ipa, pfn, map_size, memcache);
 }
 
 static int private_memslot_fault(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 4064a2ce5c64..953d5cdf7ead 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -676,15 +676,15 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long ipa, u64 size,
 
 static int realm_create_protected_data_page(struct realm *realm,
 					    unsigned long ipa,
-					    struct page *dst_page,
-					    struct page *src_page,
+					    kvm_pfn_t dst_pfn,
+					    kvm_pfn_t src_pfn,
 					    unsigned long flags)
 {
 	phys_addr_t dst_phys, src_phys;
 	int ret;
 
-	dst_phys = page_to_phys(dst_page);
-	src_phys = page_to_phys(src_page);
+	dst_phys = __pfn_to_phys(dst_pfn);
+	src_phys = __pfn_to_phys(src_pfn);
 
 	if (rmi_granule_delegate(dst_phys))
 		return -ENXIO;
@@ -711,7 +711,7 @@ static int realm_create_protected_data_page(struct realm *realm,
 err:
 	if (WARN_ON(rmi_granule_undelegate(dst_phys))) {
 		/* Page can't be returned to NS world so is lost */
-		get_page(dst_page);
+		get_page(pfn_to_page(dst_pfn));
 	}
 	return -ENXIO;
 }
@@ -741,15 +741,14 @@ static phys_addr_t rtt_get_phys(struct realm *realm, struct rtt_entry *rtt)
 }
 
 int realm_map_protected(struct realm *realm,
-			unsigned long base_ipa,
-			struct page *dst_page,
+			unsigned long ipa,
+			kvm_pfn_t pfn,
 			unsigned long map_size,
 			struct kvm_mmu_memory_cache *memcache)
 {
-	phys_addr_t dst_phys = page_to_phys(dst_page);
+	phys_addr_t phys = __pfn_to_phys(pfn);
 	phys_addr_t rd = virt_to_phys(realm->rd);
-	unsigned long phys = dst_phys;
-	unsigned long ipa = base_ipa;
+	unsigned long base_ipa = ipa;
 	unsigned long size;
 	int map_level;
 	int ret = 0;
@@ -860,14 +859,14 @@ int realm_map_protected(struct realm *realm,
 
 int realm_map_non_secure(struct realm *realm,
 			 unsigned long ipa,
-			 struct page *page,
+			 kvm_pfn_t pfn,
 			 unsigned long map_size,
 			 struct kvm_mmu_memory_cache *memcache)
 {
 	phys_addr_t rd = virt_to_phys(realm->rd);
 	int map_level;
 	int ret = 0;
-	unsigned long desc = page_to_phys(page) |
+	unsigned long desc = __pfn_to_phys(pfn) |
 			     PTE_S2_MEMATTR(MT_S2_FWB_NORMAL) |
 			     /* FIXME: Read+Write permissions for now */
 			     (3 << 6);
@@ -951,7 +950,6 @@ static int populate_par_region(struct kvm *kvm,
 		unsigned int vma_shift;
 		unsigned long offset;
 		unsigned long hva;
-		struct page *page;
 		kvm_pfn_t pfn;
 		int level;
 
@@ -1000,10 +998,8 @@ static int populate_par_region(struct kvm *kvm,
 						RME_RTT_MAX_LEVEL, NULL);
 		}
 
-		page = pfn_to_page(pfn);
-
 		for (offset = 0; offset < map_size && !ret;
-		     offset += PAGE_SIZE, page++) {
+		     offset += PAGE_SIZE, pfn++) {
 			phys_addr_t page_ipa = ipa + offset;
 			kvm_pfn_t priv_pfn;
 			int order;
@@ -1015,8 +1011,8 @@ static int populate_par_region(struct kvm *kvm,
 				break;
 
 			ret = realm_create_protected_data_page(realm, page_ipa,
-							       pfn_to_page(priv_pfn),
-							       page, data_flags);
+							       priv_pfn,
+							       pfn, data_flags);
 		}
 
 		kvm_release_pfn_clean(pfn);


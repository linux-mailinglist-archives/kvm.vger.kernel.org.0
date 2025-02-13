Return-Path: <kvm+bounces-38061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D4666A349BE
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 17:28:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A0551891A80
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 16:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A45269888;
	Thu, 13 Feb 2025 16:17:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35779203710;
	Thu, 13 Feb 2025 16:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739463421; cv=none; b=WnNLhfZ4mqvTRPCNYfjAsIJJC3LHUVn4rNu/LCZ7bRzPrI/jf3/LsXZqklIOa8TurYWrafmamuFZjy7joMgAqBc9kCKC1J5A8Aur4YliUgwHzeytkL5EEYQBwDKxInq0q6KCxIWoWee52gBcI1AxtomgxumLN0RR55Fy6h5oi0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739463421; c=relaxed/simple;
	bh=W5xyyc7QWSEpPTV/TLCPdnQQ+9mFk0mKUtGzmvDOWVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etaJJYNvg0LsVvn7VOXMfuPscLY28zs0CJn5gGSgrRMvgPnZhUp+4whWFh9SHnAr6ZU0nJbaZzHmbM+i5wVdUWQOglXvfW87yypqAV8FMR91LjiG7XgaZh8EpCoaNhPZoKabe2Q7NNWaZ22/16FqeuXGm2bkhXQHe53HogC5K04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3918E1756;
	Thu, 13 Feb 2025 08:17:20 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.32.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C0493F6A8;
	Thu, 13 Feb 2025 08:16:54 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH v7 30/45] arm64: RME: Always use 4k pages for realms
Date: Thu, 13 Feb 2025 16:14:10 +0000
Message-ID: <20250213161426.102987-31-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250213161426.102987-1-steven.price@arm.com>
References: <20250213161426.102987-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Always split up huge pages to avoid problems managing huge pages. There
are two issues currently:

1. The uABI for the VMM allows populating memory on 4k boundaries even
   if the underlying allocator (e.g. hugetlbfs) is using a larger page
   size. Using a memfd for private allocations will push this issue onto
   the VMM as it will need to respect the granularity of the allocator.

2. The guest is able to request arbitrary ranges to be remapped as
   shared. Again with a memfd approach it will be up to the VMM to deal
   with the complexity and either overmap (need the huge mapping and add
   an additional 'overlapping' shared mapping) or reject the request as
   invalid due to the use of a huge page allocator.

For now just break everything down to 4k pages in the RMM controlled
stage 2.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 994e71cfb358..8c656a0ef4e9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1641,6 +1641,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (logging_active || is_protected_kvm_enabled()) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
+	} else if (vcpu_is_rec(vcpu)) {
+		// Force PTE level mappings for realms
+		force_pte = true;
+		vma_shift = PAGE_SHIFT;
 	} else {
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
-- 
2.43.0



Return-Path: <kvm+bounces-33618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF9059EEF3A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 17:13:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47C6516E825
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 16:08:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE95922488E;
	Thu, 12 Dec 2024 15:58:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05ACE223E9A;
	Thu, 12 Dec 2024 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019110; cv=none; b=DwLOLnzLgTq+TYIoBEHCOAC5nmDnrkJAOv2cx9CGbdbyfVF9EYyWEfDNGeOXPrrj1ww12sSqh37JwUP7EYbC/yZbFIxQmwPmSB1T+6DQqLZWx52FJPD+AcTYexmDQa4D0jE49DNOARUv0sC+85T7BB1emBLjSRzLlTT+6FTxWKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019110; c=relaxed/simple;
	bh=nQ80KpzFnWk47ViZgNIoBnsb88LMSsJmdbs91kc1R0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAP5gcVw0b4+xCKQZRkpNCEUKeH6KFN4srA4X/k5+EN/T3beU85wIVg19jQu6RAOlHQ7lQJg16A+2uUZ1C9v8evkFvWeWKBvW5BIBJMgT73ALQNL5t6vSC0ri8ZaAv+LN0Hcqxmjqb3oY/H5BVE9DZ+iz7C0r4aZpMF0FqEFsqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B40F91762;
	Thu, 12 Dec 2024 07:58:56 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.39.50])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD11A3F720;
	Thu, 12 Dec 2024 07:58:24 -0800 (PST)
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
Subject: [PATCH v6 29/43] arm64: RME: Always use 4k pages for realms
Date: Thu, 12 Dec 2024 15:55:54 +0000
Message-ID: <20241212155610.76522-30-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241212155610.76522-1-steven.price@arm.com>
References: <20241212155610.76522-1-steven.price@arm.com>
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
index e88714903ce5..9ede143ccef1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1603,6 +1603,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
+	} else if (kvm_is_realm(kvm)) {
+		// Force PTE level mappings for realms
+		force_pte = true;
+		vma_shift = PAGE_SHIFT;
 	} else {
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
-- 
2.43.0



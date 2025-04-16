Return-Path: <kvm+bounces-43454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0657A90526
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 15:59:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A169D8A6DE1
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 13:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9261F21ADA2;
	Wed, 16 Apr 2025 13:45:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65D11B6D06;
	Wed, 16 Apr 2025 13:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744811148; cv=none; b=HaKUkpVO96AEthhlQZMOsQcHbozm9Cb5L8DFDIft6lWJJF/0GqYwpSKjE3G1vg7bMTVNilFJiwmY/f2sYsUC5WgT71aNKwFwpmjCkKDixERKnvEO4mlipJiL/Q+4Hs9LaDletorUPn4aHLb/v2wjckTp1G1be1AXyq31GhLGzQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744811148; c=relaxed/simple;
	bh=Xc1sIUIaQGPhy2VxNvrp0IR5BRya28/oRCQU9Jpw3oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPlPNlSFn/yvl1w3P1/k8HoYXmBJGurh5GMZoB2V+ukNsDSkQlfHdK0VRc4SxqZ+aKlqG82Pa2zOi/rgc3ZGsZoG8ckvGRGQZkBgG4DGXOnZTvuRSJxgsbiI+9YN1qwuZ6uXy4ZPrQcGoDRgdaGDgF0nZa7VXcZgZrSCXBSNMlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B6631E8D;
	Wed, 16 Apr 2025 06:45:44 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.90.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D9ED3F59E;
	Wed, 16 Apr 2025 06:45:41 -0700 (PDT)
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
Subject: [PATCH v8 29/43] arm64: RME: Always use 4k pages for realms
Date: Wed, 16 Apr 2025 14:41:51 +0100
Message-ID: <20250416134208.383984-30-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250416134208.383984-1-steven.price@arm.com>
References: <20250416134208.383984-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Guest_memfd doesn't yet natively support huge pages, and there are
currently difficulties for a VMM to manage huge pages efficiently so for
now always split up mappings to PTE (4k).

The two issues that need progressing before supporting huge pages for
realms are:

 1. guest_memfd needs to be able to allocate from an appropriate
    allocator which can provide huge pages.

 2. The VMM needs to be able to repurpose private memory for a shared
    mapping when the guest VM requests memory is transitioned. Because
    this can happen at a 4k granularity it isn't possible to
    free/reallocate while huge pages are in use. Allowing the VMM to
    mmap() the shared portion of a huge page would allow the huge page
    to be recreated when the memory is unshared and made protected again.

These two issues are not specific to realms and don't affect the realm
API, so for now just break everything down to 4k pages in the RMM
controlled stage 2. Future work can add huge page support without
changing the uAPI.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v7:
 * Rewritten commit message
---
 arch/arm64/kvm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 02b66ee35426..29bab7a46033 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1653,6 +1653,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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



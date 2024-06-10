Return-Path: <kvm+bounces-19199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 630269022EC
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 15:46:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 005C728608A
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 13:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0348F149C65;
	Mon, 10 Jun 2024 13:43:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2522A147C6E;
	Mon, 10 Jun 2024 13:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718026981; cv=none; b=NGm6xO5/EwbEOdMsvSBrYmXGmtrzgneeUklaurfhOr7XGQrteCv5CehtAtZLWJHIY4ZjWhnv7gx0d7H3sTfzDgrq3dV5XABNHtWlF/+ZtMKMXy8V+vPeKNEb06JaB7n9MdCAd6Gm/k0i9sp449fRlVKrTHXYH5uc5/9oaZ4FQWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718026981; c=relaxed/simple;
	bh=DIxNh9RLAx6GBL/bkIFqPK7BjBh9R5CNPUM/GF7UT0A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=otnTFqBjaUsamPjeqdCIuPaTiu+tIY2KN+Z6N8A6U23X6fjC7v8cyw1j9i2pAjflCTkDXXMduWWLzTEW08h/NABcfpiqHlWc1IAFZbriETW6MDixhKfNmZY4G6PEGyEM6kclZaS547kj84DW33QiWwFW1vsez4uryUITID+JuLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19EFF106F;
	Mon, 10 Jun 2024 06:43:24 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 694863F58B;
	Mon, 10 Jun 2024 06:42:57 -0700 (PDT)
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 12/43] arm64: RME: Keep a spare page delegated to the RMM
Date: Mon, 10 Jun 2024 14:41:31 +0100
Message-Id: <20240610134202.54893-13-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240610134202.54893-1-steven.price@arm.com>
References: <20240610134202.54893-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pages can only be populated/destroyed on the RMM at the 4KB granule,
this requires creating the full depth of RTTs. However if the pages are
going to be combined into a 2MB huge page the last RTT is only
temporarily needed. Similarly when freeing memory the huge page must be
temporarily split requiring temporary usage of the full depth oF RTTs.

To avoid needing to perform a temporary allocation and delegation of a
page for this purpose we keep a spare delegated page around. In
particular this avoids the need for memory allocation while destroying
the realm guest.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_rme.h | 5 +++++
 arch/arm64/kvm/rme.c             | 8 ++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index 209cd99f03dd..bd306bd7b64b 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -50,6 +50,9 @@ enum realm_state {
  * @state: The lifetime state machine for the realm
  * @rd: Kernel mapping of the Realm Descriptor (RD)
  * @params: Parameters for the RMI_REALM_CREATE command
+ * @spare_page: A physical page that has been delegated to the Realm world but
+ *              is otherwise free. Used to avoid temporary allocation during
+ *              RTT operations.
  * @num_aux: The number of auxiliary pages required by the RMM
  * @vmid: VMID to be used by the RMM for the realm
  * @ia_bits: Number of valid Input Address bits in the IPA
@@ -60,6 +63,8 @@ struct realm {
 	void *rd;
 	struct realm_params *params;
 
+	phys_addr_t spare_page;
+
 	unsigned long num_aux;
 	unsigned int vmid;
 	unsigned int ia_bits;
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 4d21ec5f2910..f6430d460519 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -104,6 +104,7 @@ static int realm_create_rd(struct kvm *kvm)
 	}
 
 	realm->rd = rd;
+	realm->spare_page = PHYS_ADDR_MAX;
 
 	if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
 		WARN_ON(rmi_realm_destroy(rd_phys));
@@ -286,6 +287,13 @@ void kvm_destroy_realm(struct kvm *kvm)
 
 	rme_vmid_release(realm->vmid);
 
+	if (realm->spare_page != PHYS_ADDR_MAX) {
+		/* Leak the page if the undelegate fails */
+		if (!WARN_ON(rmi_granule_undelegate(realm->spare_page)))
+			free_page((unsigned long)phys_to_virt(realm->spare_page));
+		realm->spare_page = PHYS_ADDR_MAX;
+	}
+
 	for (i = 0; i < pgt->pgd_pages; i++) {
 		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
 
-- 
2.34.1



Return-Path: <kvm+bounces-24508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DBF7B956BD5
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 15:25:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 686AFB21F1F
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 13:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 994E116CD15;
	Mon, 19 Aug 2024 13:20:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D02D016CD13;
	Mon, 19 Aug 2024 13:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724073634; cv=none; b=hY3CwGJXUf5+qhjBqiYPW89d7q7X+ePYt0NCXI2hfBHnRJ27UfMQCYe/d0E79yY91y9H2fmLR+bvYF+mUDTUAoUMPQsQeiiunaawKWfDOdiEPKRLH5t69Flb1pU2Sw6+KkaOt9ii/QlMzjOw/St5Bc/unl/Qvv4M2WfFMXfMomA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724073634; c=relaxed/simple;
	bh=bp8rqBj6LCd3mK/jCglM2RuDmO8yLEV86BM/0PH4GOk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YvUlFZ/2aBSy/HDsK6YTEDwTPb05sGbPf1ygmJvELkUCdblAIeZ3wxaQQqyPP/MvkH5ul5aiJhvPNbAyYX586CX+nW9ZD9K7XO+p5B1uDJq6QHsWVTaBgw5svgvtD+r6ZkWESm2tfeKYQFW6+k9SlU7osxp/RJogxz4h7MwyaWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A8E8339;
	Mon, 19 Aug 2024 06:20:58 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.85.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7BCBD3F73B;
	Mon, 19 Aug 2024 06:20:28 -0700 (PDT)
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
	Alper Gun <alpergun@google.com>
Subject: [PATCH v5 12/19] efi: arm64: Map Device with Prot Shared
Date: Mon, 19 Aug 2024 14:19:17 +0100
Message-Id: <20240819131924.372366-13-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240819131924.372366-1-steven.price@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Device mappings need to be emualted by the VMM so must be mapped shared
with the host.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v4:
 * Reworked to use arm64_is_iomem_private() to decide whether the memory
   needs to be decrypted or not.
---
 arch/arm64/kernel/efi.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 712718aed5dd..95f8e8bf07f8 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -34,8 +34,16 @@ static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
 	u64 attr = md->attribute;
 	u32 type = md->type;
 
-	if (type == EFI_MEMORY_MAPPED_IO)
-		return PROT_DEVICE_nGnRE;
+	if (type == EFI_MEMORY_MAPPED_IO) {
+		pgprot_t prot = __pgprot(PROT_DEVICE_nGnRE);
+
+		if (arm64_is_iomem_private(md->phys_addr,
+					   md->num_pages << EFI_PAGE_SHIFT))
+			prot = pgprot_encrypted(prot);
+		else
+			prot = pgprot_decrypted(prot);
+		return pgprot_val(prot);
+	}
 
 	if (region_is_misaligned(md)) {
 		static bool __initdata code_is_misaligned;
-- 
2.34.1



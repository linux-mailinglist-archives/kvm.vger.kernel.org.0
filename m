Return-Path: <kvm+bounces-29069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 268EA9A2355
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 15:16:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF78528958B
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 13:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BFF81DED48;
	Thu, 17 Oct 2024 13:15:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ADBE1DE898;
	Thu, 17 Oct 2024 13:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729170914; cv=none; b=H9esJy/OnF9wkGIqU81D5xvkjZNqHUMB8Nb7Skg9R6SjAlUdLV50bY2cmFPhfJKbv+WkwVflI3npZxKG2kvINdEMTp9VsrxZpod0FIp3SpeI8W3kUJ4LWvsAZ5vUYDfkvjCAQ2jM6ZDx28lkykd/hx7vZHgObLVwmkEKh25IOiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729170914; c=relaxed/simple;
	bh=t5I3iUHobSE1SI4nN11vGqGPdsKJnhAaIhIVN96Ss/0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b9GZ/sx6G3DFZe3BFaMqGaAOzifPeVeElE72ZEnwRj6IJocuNcq9LmGQRGj6EJNp4qR4A3tBiOEcp6/fRUUyKlWW+5cKtEKXjJrU4urAPR1VI8QuNwZr1Ec2EUwzgVljUD4NiC4rm5bZAjHGRaMxWy/DezLDMU2q/yrwr8kyCMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9145FFEC;
	Thu, 17 Oct 2024 06:15:41 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 163C93F71E;
	Thu, 17 Oct 2024 06:15:07 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v7 06/11] efi: arm64: Map Device with Prot Shared
Date: Thu, 17 Oct 2024 14:14:29 +0100
Message-Id: <20241017131434.40935-7-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241017131434.40935-1-steven.price@arm.com>
References: <20241017131434.40935-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Device mappings need to be emulated by the VMM so must be mapped shared
with the host.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
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
index 712718aed5dd..1d25d8899dbf 100644
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
+		if (arm64_is_protected_mmio(md->phys_addr,
+					    md->num_pages << EFI_PAGE_SHIFT))
+			prot = pgprot_encrypted(prot);
+		else
+			prot = pgprot_decrypted(prot);
+		return pgprot_val(prot);
+	}
 
 	if (region_is_misaligned(md)) {
 		static bool __initdata code_is_misaligned;
-- 
2.34.1



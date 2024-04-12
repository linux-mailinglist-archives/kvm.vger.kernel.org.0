Return-Path: <kvm+bounces-14422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB9918A2993
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC0A11C22F27
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E8C54273;
	Fri, 12 Apr 2024 08:42:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FFEC5491E;
	Fri, 12 Apr 2024 08:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911357; cv=none; b=a/6RRxOSk44jEp8IG2rg6vSNoujFHpi+hVvwPC4ZTY5rY0Qlfo5/nZUbgnPRwAoF/92qn0YBRPO8eym4rxxgQ5hKrlVteyeAFSp408MW+IInNWpIDWkyo0yVLF6tGlNPH1BwAedUyKuJDlvNQYeL86afE6e7dcHfkPR5KZVzy2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911357; c=relaxed/simple;
	bh=NzTq93Hq8EFgm3RsLWJO2q7JPk/z+1u4hBvkebGpVoQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y9uw63Dn1nTICHIVbsOCQ8WaeyrnhHJs4H0zf43JI0OzC9y+T4I5z2OACFXbLYB4OwRC7hiHxbe152SXT+iHlCx3Kc9M+p2lS7hqQMEMqyVCpHOTbA+OdajtOAecgLq106kAknyI7M7h+klf6rLCzL7mg/A9CT8Jy8x8ueylhU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21CD414BF;
	Fri, 12 Apr 2024 01:43:05 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCBE73F6C4;
	Fri, 12 Apr 2024 01:42:33 -0700 (PDT)
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
	Steven Price <steven.price@arm.com>
Subject: [PATCH v2 06/14] arm64: Override set_fixmap_io
Date: Fri, 12 Apr 2024 09:42:05 +0100
Message-Id: <20240412084213.1733764-7-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084213.1733764-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084213.1733764-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Override the set_fixmap_io to set shared permission for the host
in case of a CC guest. For now we mark it shared unconditionally.
Future changes could filter the physical address and make the
decision accordingly.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/fixmap.h |  4 +++-
 arch/arm64/mm/mmu.c             | 13 +++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 87e307804b99..f765943b088c 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -107,7 +107,9 @@ void __init early_fixmap_init(void);
 #define __late_set_fixmap __set_fixmap
 #define __late_clear_fixmap(idx) __set_fixmap((idx), 0, FIXMAP_PAGE_CLEAR)
 
-extern void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);
+#define set_fixmap_io set_fixmap_io
+void set_fixmap_io(enum fixed_addresses idx, phys_addr_t phys);
+void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);
 
 #include <asm-generic/fixmap.h>
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 495b732d5af3..79d84db9ffcb 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1179,6 +1179,19 @@ void vmemmap_free(unsigned long start, unsigned long end,
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
+void set_fixmap_io(enum fixed_addresses idx, phys_addr_t phys)
+{
+	pgprot_t prot = FIXMAP_PAGE_IO;
+
+	/*
+	 * For now we consider all I/O as non-secure. For future
+	 * filter the I/O base for setting appropriate permissions.
+	 */
+	prot = __pgprot(pgprot_val(prot) | PROT_NS_SHARED);
+
+	return __set_fixmap(idx, phys, prot);
+}
+
 int pud_set_huge(pud_t *pudp, phys_addr_t phys, pgprot_t prot)
 {
 	pud_t new_pud = pfn_pud(__phys_to_pfn(phys), mk_pud_sect_prot(prot));
-- 
2.34.1



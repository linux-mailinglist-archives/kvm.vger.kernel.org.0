Return-Path: <kvm+bounces-20775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3706A91DBCF
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 11:57:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45448283C9C
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 774F314A605;
	Mon,  1 Jul 2024 09:55:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BEC614A09D;
	Mon,  1 Jul 2024 09:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719827737; cv=none; b=p2P95J4EvKE+egiLJ0eE3Cvn+MZZFtlg/BaXbdmwAz6Dbl3nOK1dUEf/ikU1xeOyNuV4Cr3IUqda9TTmnYyZeYDr84UHm4E9uYaPrgSg5yXnBmgMR4xfmZzMVXB5veMMcFUraxa9lIeD6Dzd5sCbiWZdkyQDNroEvpNFGwNSL+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719827737; c=relaxed/simple;
	bh=kUKXTAeQbkxgHtXF2NzhvFWMftSlRuwr+7oklYke8rU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AuEQo62GJ9TgIUc8MltTUbGhURZyaP2VercU0VXx5eKHiS032nlrqshK51yCcn9VNu5PlK7VmmuO3KXy9i8nQ3XW8AU2NVaNu5ApzLQu7K7yt/9DJj52Z1+zHPIOuKup4xYp5WV8D+gXxYrG3+5YIFFzjwklQhlANDtMhwEQMpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33A1115A1;
	Mon,  1 Jul 2024 02:56:00 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.44.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 381333F762;
	Mon,  1 Jul 2024 02:55:32 -0700 (PDT)
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
Subject: [PATCH v4 05/15] arm64: Mark all I/O as non-secure shared
Date: Mon,  1 Jul 2024 10:54:55 +0100
Message-Id: <20240701095505.165383-6-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240701095505.165383-1-steven.price@arm.com>
References: <20240701095505.165383-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All I/O is by default considered non-secure for realms. As such
mark them as shared with the host.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v3:
 * Add PROT_NS_SHARED to FIXMAP_PAGE_IO rather than overriding
   set_fixmap_io() with a custom function.
 * Modify ioreamp_cache() to specify PROT_NS_SHARED too.
---
 arch/arm64/include/asm/fixmap.h | 2 +-
 arch/arm64/include/asm/io.h     | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 87e307804b99..f2c5e653562e 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -98,7 +98,7 @@ enum fixed_addresses {
 #define FIXADDR_TOT_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_TOT_START	(FIXADDR_TOP - FIXADDR_TOT_SIZE)
 
-#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE)
+#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE | PROT_NS_SHARED)
 
 void __init early_fixmap_init(void);
 
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 4ff0ae3f6d66..07fc1801c6ad 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -277,12 +277,12 @@ static inline void __const_iowrite64_copy(void __iomem *to, const void *from,
 
 #define ioremap_prot ioremap_prot
 
-#define _PAGE_IOREMAP PROT_DEVICE_nGnRE
+#define _PAGE_IOREMAP (PROT_DEVICE_nGnRE | PROT_NS_SHARED)
 
 #define ioremap_wc(addr, size)	\
-	ioremap_prot((addr), (size), PROT_NORMAL_NC)
+	ioremap_prot((addr), (size), (PROT_NORMAL_NC | PROT_NS_SHARED))
 #define ioremap_np(addr, size)	\
-	ioremap_prot((addr), (size), PROT_DEVICE_nGnRnE)
+	ioremap_prot((addr), (size), (PROT_DEVICE_nGnRnE | PROT_NS_SHARED))
 
 /*
  * io{read,write}{16,32,64}be() macros
@@ -303,7 +303,7 @@ static inline void __iomem *ioremap_cache(phys_addr_t addr, size_t size)
 	if (pfn_is_map_memory(__phys_to_pfn(addr)))
 		return (void __iomem *)__phys_to_virt(addr);
 
-	return ioremap_prot(addr, size, PROT_NORMAL);
+	return ioremap_prot(addr, size, PROT_NORMAL | PROT_NS_SHARED);
 }
 
 /*
-- 
2.34.1



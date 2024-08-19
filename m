Return-Path: <kvm+bounces-24505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F3A6956BC1
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 15:23:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82BAD1C23146
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 13:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 395FA171E43;
	Mon, 19 Aug 2024 13:20:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6572E16C865;
	Mon, 19 Aug 2024 13:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724073621; cv=none; b=daP1iVlGOA2WM3WLD5naXPOAb4ODXnmsV1q0+OcKW3Io7SI01XDn/5aw3iynApCyvNfMhnp9mzJo8HljDOLEg3JTxxu4DAqpQI2W1XMhVjRrgXOJfPkdEF3DW8BV1CPDVta7k7DY74pU8pdNjZA2vux81INv7LJRgjN0/FgmJ4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724073621; c=relaxed/simple;
	bh=suH1Ez+pQ/HxRlZPjt7BZpKltP0lINstJ4+k9YpV2XU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yxx/Rt9Sy98Cp426N7FzZLamJcyzYNH2QjC8IlsJ9Lr5aV/895dOg0Ys7SlO8X2ccDiVkXB8+udyF6DrzfxhIFRP639dY3rsrwluhG75IW6r3csNZtIqbPrZlVgX2ZCS3tu7PB+kYyO28bkzKocQJEPKLRfm1oYOx0J1hTAJ2iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14792113E;
	Mon, 19 Aug 2024 06:20:46 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.85.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 361163F73B;
	Mon, 19 Aug 2024 06:20:16 -0700 (PDT)
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
Subject: [PATCH v5 09/19] fixmap: Pass down the full phys address for set_fixmap_io
Date: Mon, 19 Aug 2024 14:19:14 +0100
Message-Id: <20240819131924.372366-10-steven.price@arm.com>
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

For early I/O mapping using fixmap, we mask the address by PAGE_MASK
base and then map it to the FIXMAP slot. However, with confidential
computing, the granularity at which "protections" (encrypted vs
decrypted) are applied may be finer than the PAGE_SIZE. e.g., for Arm
CCA it is 4K while an arm64 kernel could be using 64K pagesize. However
we need to know the exact address being mapped in.

Thus in-order to calculate the accurate protection, pass down the exact
phys address to the helpers. This would be later used by arm64 to detect
if the MMIO address is shared vs protected. The users of such drivers
already cope with running the same code with "4K" page size, thus
mapping a PAGE_SIZE covering the address range is considered acceptable.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
New patch for v5
---
 drivers/tty/serial/earlycon.c | 2 +-
 include/asm-generic/fixmap.h  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/earlycon.c b/drivers/tty/serial/earlycon.c
index a5fbb6ed38ae..c8414b648d47 100644
--- a/drivers/tty/serial/earlycon.c
+++ b/drivers/tty/serial/earlycon.c
@@ -40,7 +40,7 @@ static void __iomem * __init earlycon_map(resource_size_t paddr, size_t size)
 {
 	void __iomem *base;
 #ifdef CONFIG_FIX_EARLYCON_MEM
-	set_fixmap_io(FIX_EARLYCON_MEM_BASE, paddr & PAGE_MASK);
+	set_fixmap_io(FIX_EARLYCON_MEM_BASE, paddr);
 	base = (void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
 	base += paddr & ~PAGE_MASK;
 #else
diff --git a/include/asm-generic/fixmap.h b/include/asm-generic/fixmap.h
index 9b75fe2bd8fd..8d2222035ed2 100644
--- a/include/asm-generic/fixmap.h
+++ b/include/asm-generic/fixmap.h
@@ -96,7 +96,7 @@ static inline unsigned long virt_to_fix(const unsigned long vaddr)
  */
 #ifndef set_fixmap_io
 #define set_fixmap_io(idx, phys) \
-	__set_fixmap(idx, phys, FIXMAP_PAGE_IO)
+	__set_fixmap(idx, phys & PAGE_MASK, FIXMAP_PAGE_IO)
 #endif
 
 #endif /* __ASSEMBLY__ */
-- 
2.34.1



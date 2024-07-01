Return-Path: <kvm+bounces-20780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 339EA91DBDA
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 11:58:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3F5DB24227
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4417B1509BC;
	Mon,  1 Jul 2024 09:55:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74558133987;
	Mon,  1 Jul 2024 09:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719827756; cv=none; b=IOpWR1Xd+i+ci1b/jAy8cLDKNFpxvtD8FE6RWRAtfwWhHeN33VlJ3grF3qsZ1B8dgClShKM7tDcBb/gJ5a4iMFfSeeFKJ7l9I1xwwb9XHv+YtaNLEh/BB08z8kFWATrmQNk0HBtp2Xxe2jXVXjioUVvp+uFVnMuvKeid8C+TYys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719827756; c=relaxed/simple;
	bh=1PuzX4qeYmXHtvAczJ4OnC2J81B51Io/rR1tL2ki2ds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vB4hf1QKIcNpWR5y3OuBMDMZZzQIpJ+nkyIUCUr5Lxdw5mjaZkfGR33HKSMfHQV2eqWp81dzJUA60hcAVOOMFVHwhaf/7ZdsSPntCH6fMXN1CfvFFDejbQbi0UAE/S7PCWDr3fGyDzRq9uXjykSymk9FkII35ADO48Uzb3RhUZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21797339;
	Mon,  1 Jul 2024 02:56:19 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.44.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 842433F762;
	Mon,  1 Jul 2024 02:55:49 -0700 (PDT)
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
Subject: [PATCH v4 10/15] arm64: Force device mappings to be non-secure shared
Date: Mon,  1 Jul 2024 10:55:00 +0100
Message-Id: <20240701095505.165383-11-steven.price@arm.com>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Device mappings (currently) need to be emulated by the VMM so must be
mapped shared with the host.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes from v3:
 * Make use of pgprot_decrypted() in the definition of pgprot_device()
---
 arch/arm64/include/asm/pgtable.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index f5d5f416d47d..a625738ed855 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -648,8 +648,9 @@ static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRnE) | PTE_PXN | PTE_UXN)
 #define pgprot_writecombine(prot) \
 	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC) | PTE_PXN | PTE_UXN)
-#define pgprot_device(prot) \
+#define __pgprot_device(prot) \
 	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN)
+#define pgprot_device(prot) __pgprot_device(pgprot_decrypted(prot))
 #define pgprot_tagged(prot) \
 	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_TAGGED))
 #define pgprot_mhp	pgprot_tagged
-- 
2.34.1



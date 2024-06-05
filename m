Return-Path: <kvm+bounces-18869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 83FA88FC7EA
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 11:35:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 225351F228BA
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 09:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2369E194A74;
	Wed,  5 Jun 2024 09:31:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 606D0194A79;
	Wed,  5 Jun 2024 09:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717579860; cv=none; b=t/PCuKhNg7jWUmR9NVx797ZNDVMRi/XT4HXkR/y7WsDoB3xX3nJlCm5Un3RO4dbbcqXPx5hy5ZvdaqVpjRPIWgdixwxOJ7yfFl2iG9fGcpypdohRd8cp1vFh7ast+/+sfnMQYYCj9GYUJejI+YaqkOI0Qs9r7Gf7j0+f7ELdsSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717579860; c=relaxed/simple;
	bh=Q2499N6OdZJ/cJEaYbIq4tcinJZWFqeeGizcFcsU/zY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M1FI4t5WGCE/k7RSDjvXn2pWnlbFWcUIOtYt/8WZxssrsOUvl1ye7SF1KXKw6DrZrGa65Li/BLrQqcVuX+z20/r6/VNiHz9VZRk7iOidAIhWOu+CdV67WN4Cv4WS+yU1mFItagsX5UuCmKZeFOKHCJ6rK8U4bqVUt+CGbsqf+4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CFF2DA7;
	Wed,  5 Jun 2024 02:31:23 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.39.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C60533F792;
	Wed,  5 Jun 2024 02:30:55 -0700 (PDT)
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
Subject: [PATCH v3 10/14] arm64: Force device mappings to be non-secure shared
Date: Wed,  5 Jun 2024 10:30:02 +0100
Message-Id: <20240605093006.145492-11-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240605093006.145492-1-steven.price@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
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
 arch/arm64/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 11d614d83317..c986fde262c0 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -644,7 +644,7 @@ static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 #define pgprot_writecombine(prot) \
 	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC) | PTE_PXN | PTE_UXN)
 #define pgprot_device(prot) \
-	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN)
+	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN | PROT_NS_SHARED)
 #define pgprot_tagged(prot) \
 	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_TAGGED))
 #define pgprot_mhp	pgprot_tagged
-- 
2.34.1



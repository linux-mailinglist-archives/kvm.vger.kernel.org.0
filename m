Return-Path: <kvm+bounces-14420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 995108A298E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:43:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3110AB25998
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B2153E0C;
	Fri, 12 Apr 2024 08:42:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A6BF535D2;
	Fri, 12 Apr 2024 08:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911353; cv=none; b=MzeST1aS/YfuKlepNZ4ScZZ1QCwWfYVl9YH4Zta3yFIbWtPRmm/nLDNwZWdjda5DftB2LNqdLc4sy9DCwYWyLmyzYlcALxn5qtaO2B2rZzD3vaX3P1Y2vA4kFFAjli2ZnON5YxGJj3O8FxDeCOiGHJFKmNQrjfE4bCsD9QQNl0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911353; c=relaxed/simple;
	bh=/HhiS5Z0Bbiaa1Q0ARnRQ8/wUTv3n+FJDn/8TSK0IGQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SOppLcrvdDIVMJOrB3gsyvS5pf/KJyMK2R/FC37UXvurCMiuwqpw+9KXb/moERUrjkPBrDddpfhcAaVHeFEX3teT6Tob3hbcQU8K1icpB8SrmHjNCU3DkugaYLrornMhewCJpP0pZlgZD9ZpT52Fyr5c+48RI0C2pZ77/KUlyUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6FCB6113E;
	Fri, 12 Apr 2024 01:43:00 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 186863F6C4;
	Fri, 12 Apr 2024 01:42:28 -0700 (PDT)
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
Subject: [PATCH v2 04/14] arm64: Mark all I/O as non-secure shared
Date: Fri, 12 Apr 2024 09:42:03 +0100
Message-Id: <20240412084213.1733764-5-steven.price@arm.com>
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

All I/O is by default considered non-secure for realms. As such
mark them as shared with the host.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/io.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 8d825522c55c..f283c764ea20 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -145,12 +145,12 @@ extern void __memset_io(volatile void __iomem *, int, size_t);
 
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
-- 
2.34.1



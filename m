Return-Path: <kvm+bounces-29071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95FBF9A235D
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 15:17:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B674289B65
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 13:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CD231DEFCC;
	Thu, 17 Oct 2024 13:15:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ED081DED74;
	Thu, 17 Oct 2024 13:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729170924; cv=none; b=QFkPvCXRi2lhJ0PZlPdn2OqdWL8O8AKey9l4wu7bPmwqaOqhbUy5NiSfUuatMpRYlcHMOU1ceDhLDb4Prr/NfNZFmrLxVvy8vA84/KuUPDCQIaVzozmnS6iIOK68OeLdWrEUMzt1ah93iTsuKPxT0LJXaFkc1x32OEf9YH79K+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729170924; c=relaxed/simple;
	bh=BAwPOAmOIzEQJ4SLugo9T4c57oNNMmBoAWU3VeT+tA0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cNMvmmOygVgXrXn8R3ub5bLrWbX7snUy+giY1wSiTUGpOLszDfYK4BUR1+0W6AoZYqAlglbA9IhSilvPD06auOAkaWEG+R0jPUgjgtnqgJzr8+yps/5+tbnSOKeRPrFobWdNGHm35K+wYA1MJSwezB31TT0UwDFln/k5GPS7KME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8814D1570;
	Thu, 17 Oct 2024 06:15:49 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44C813F71E;
	Thu, 17 Oct 2024 06:15:16 -0700 (PDT)
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
Subject: [PATCH v7 08/11] arm64: mm: Avoid TLBI when marking pages as valid
Date: Thu, 17 Oct 2024 14:14:31 +0100
Message-Id: <20241017131434.40935-9-steven.price@arm.com>
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

When __change_memory_common() is purely setting the valid bit on a PTE
(e.g. via the set_memory_valid() call) there is no need for a TLBI as
either the entry isn't changing (the valid bit was already set) or the
entry was invalid and so should not have been cached in the TLB.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
v4: New patch
---
 arch/arm64/mm/pageattr.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 0e270a1c51e6..547a9e0b46c2 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -60,7 +60,13 @@ static int __change_memory_common(unsigned long start, unsigned long size,
 	ret = apply_to_page_range(&init_mm, start, size, change_page_range,
 					&data);
 
-	flush_tlb_kernel_range(start, start + size);
+	/*
+	 * If the memory is being made valid without changing any other bits
+	 * then a TLBI isn't required as a non-valid entry cannot be cached in
+	 * the TLB.
+	 */
+	if (pgprot_val(set_mask) != PTE_VALID || pgprot_val(clear_mask))
+		flush_tlb_kernel_range(start, start + size);
 	return ret;
 }
 
-- 
2.34.1



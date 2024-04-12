Return-Path: <kvm+bounces-14427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAB658A299E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2CB8DB2383F
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB3CD50279;
	Fri, 12 Apr 2024 08:42:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7CFE56B7F;
	Fri, 12 Apr 2024 08:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911369; cv=none; b=M2Hps8gTwiILnNUeAoeSlCWqpQo/KFkzkjjHLGqU6C2YD4sTUHk49eKP5wZglcOcoTvmFGiqiUJLOzcstWZKVXhKhzvODUIEmFyQ0pr18VjDBZXiV0TdCReeXtrwilKZX9u4JbLf9+hk+wupilXisweSLbt89zq7rMwqvmbNrUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911369; c=relaxed/simple;
	bh=GQhBxJGntjJO/xCH8wTLpSUjcxPJpRPlPG7Yf0I+kCk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d0T0zancWucCsLA8t0UFkiyC3CxT0jl4Dwk71y2tr4VEiNsum/0vNFC3UZjRuFo2eqGNrMqfuk1Gd3ha0Tj+5/aVI5lMYA7ts22SIN722OPD7biKRtWbAXyYZQvAgwdaZ+WSXufU4m69KxtRPFfiaxjJ4cHpBXugb+o6/vwJUwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C9D38339;
	Fri, 12 Apr 2024 01:43:16 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 726153F6C4;
	Fri, 12 Apr 2024 01:42:45 -0700 (PDT)
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
Subject: [PATCH v2 11/14] efi: arm64: Map Device with Prot Shared
Date: Fri, 12 Apr 2024 09:42:10 +0100
Message-Id: <20240412084213.1733764-12-steven.price@arm.com>
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

Device mappings need to be emualted by the VMM so must be mapped shared
with the host.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kernel/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 9afcc690fe73..bb8b39f16092 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -33,7 +33,7 @@ static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
 	u32 type = md->type;
 
 	if (type == EFI_MEMORY_MAPPED_IO)
-		return PROT_DEVICE_nGnRE;
+		return PROT_NS_SHARED | PROT_DEVICE_nGnRE;
 
 	if (region_is_misaligned(md)) {
 		static bool __initdata code_is_misaligned;
-- 
2.34.1



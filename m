Return-Path: <kvm+bounces-18870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F9168FC7EC
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 11:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05AC71F22CC5
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 09:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33CF5195FF1;
	Wed,  5 Jun 2024 09:31:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E5A3194A79;
	Wed,  5 Jun 2024 09:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717579863; cv=none; b=fFrKZntCDgGSQlrtUAHb1uKBN+9T4KtTL4oA2QLBWtN3ypPdScYyn8JkGOtgootn7SLN6gtWSk4jioAl2gWs5jM/1EGUoWwrvXBmFIf3bZb/ZiqhnHHgyFnUpQ6Jyn8m/l44H0qIVmqQQbEWPs3P8+bvEg9XVyA6fftrpIoQY0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717579863; c=relaxed/simple;
	bh=szWOUfh6Wnhb99hxcGdoM94GZ2H3nOJmLRprWEn9pKw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UYANVcoHm0vFp1ZITwzhFBzzHQq5bA6JZzNVx6NrG7HzVjh1LEQnwbJ939hwss4wlOtYqzMJ+Df1Q4J5z3iLjdk/0vSJHgY0Dzy+5AI4QkFMblTzG47Djc8R4BJ/YyUqG/XUPVfQTYLgMHiN1WO2wikdfKjs+T+c4rhvjbBvdE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 905961063;
	Wed,  5 Jun 2024 02:31:26 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.39.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D38C3F792;
	Wed,  5 Jun 2024 02:30:59 -0700 (PDT)
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
Subject: [PATCH v3 11/14] efi: arm64: Map Device with Prot Shared
Date: Wed,  5 Jun 2024 10:30:03 +0100
Message-Id: <20240605093006.145492-12-steven.price@arm.com>
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

Device mappings need to be emualted by the VMM so must be mapped shared
with the host.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kernel/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 4a92096db34e..ae1ccc8852a4 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -34,7 +34,7 @@ static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
 	u32 type = md->type;
 
 	if (type == EFI_MEMORY_MAPPED_IO)
-		return PROT_DEVICE_nGnRE;
+		return PROT_NS_SHARED | PROT_DEVICE_nGnRE;
 
 	if (region_is_misaligned(md)) {
 		static bool __initdata code_is_misaligned;
-- 
2.34.1



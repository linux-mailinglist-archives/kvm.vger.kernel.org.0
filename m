Return-Path: <kvm+bounces-20781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 65B9091DBDC
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 11:58:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0311D1F24654
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:58:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7204E15252F;
	Mon,  1 Jul 2024 09:56:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA1613C9A4;
	Mon,  1 Jul 2024 09:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719827760; cv=none; b=H7InZmCgwitwOkvbhkaf0mbAz9F1kx42Wp0J1T6Vu6qkfZO/Ny0Z7b+KTF/w93MTGZm7EwKWF4oGcVzY7OPHXskLzZztx6BtjL50Vt8MrqR5V4xA3bSRBQdzp8uQoa1+EzAR8EbaYcetg9VTAdVwEbBu9ZJ8PVIBSoq2Fzq1hso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719827760; c=relaxed/simple;
	bh=szWOUfh6Wnhb99hxcGdoM94GZ2H3nOJmLRprWEn9pKw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZNo6PHQGKlhNkEn4YhQb/KOw+cfSmspcN1ehkKr/iilBpgNZSx8hEwj7OhqPYfpU6mioQ9Ow8sJZR0oFQYrGytRicFxXR+PY/3eI/9/L3drdORzBB4tOdqtiq+MT7LVuj2eZYbvG1RAThpMXatk4QQysbrWQg+gabUEFO0QvAEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 377D0339;
	Mon,  1 Jul 2024 02:56:24 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.44.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97F4C3F762;
	Mon,  1 Jul 2024 02:55:54 -0700 (PDT)
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
Subject: [PATCH v4 11/15] efi: arm64: Map Device with Prot Shared
Date: Mon,  1 Jul 2024 10:55:01 +0100
Message-Id: <20240701095505.165383-12-steven.price@arm.com>
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



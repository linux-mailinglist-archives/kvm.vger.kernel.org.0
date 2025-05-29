Return-Path: <kvm+bounces-47974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3350AC7F54
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 15:56:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3C9C9E14BE
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 13:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B15AD22A4F3;
	Thu, 29 May 2025 13:56:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6B1224B0C
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 13:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748526995; cv=none; b=orTifauygFEKWejfcEmuMez9b1NCnXxpi8Ax6G5Wd5m9paQCOdzAA/21oYdS0gKPH1T01q1T4B5mI1gvqVvXC1JmfLr0UzE8J13ePi9ISSwQk1uBmrsViZH/FA3kreegq2HF3PWaRxkVGoU+AYDkpWrL9YkkkE0274aqffrySTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748526995; c=relaxed/simple;
	bh=sNxzusFFAe4XWZQbM6iY34QI7mAB0PnHbSwSILoEG9E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MF54fuEXeO8F6t+5L57i5SUk9XRZextmg8ICtTD7dn7YE0JteDv5JhMfyJOr0eZXIY6Vbg3ydD64oo9aKMl/QVcTBemhHzFPGfeeCuckjZwf9t7gxa+FzykZNumRm+jutScf7MEYmQk9WJ7PF4qhGifzWv0Q2Uc1MtQBDCLzjOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9651322E6;
	Thu, 29 May 2025 06:56:16 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1FB33F673;
	Thu, 29 May 2025 06:56:31 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v2 2/9] arm64: efi: initialise SCTLR_ELx fully
Date: Thu, 29 May 2025 14:55:50 +0100
Message-Id: <20250529135557.2439500-3-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250529135557.2439500-1-joey.gouly@arm.com>
References: <20250529135557.2439500-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't rely on the value of SCTLR_ELx when booting via EFI.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm/setup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 67b5db07..0a22dbab 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -349,6 +349,11 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
 
+
+	// EFI exits boot services with SCTLR_ELx.M=1, so keep
+	// the MMU enabled.
+	write_sysreg(INIT_SCTLR_EL1_MMU_OFF | SCTLR_EL1_M, sctlr_el1);
+
 	exceptions_init();
 
 	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
-- 
2.25.1



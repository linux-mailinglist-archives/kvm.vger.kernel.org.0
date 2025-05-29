Return-Path: <kvm+bounces-47975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4A41AC7F55
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 15:56:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F4341775A7
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 13:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39BBA22A813;
	Thu, 29 May 2025 13:56:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54A4C22A4E1
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 13:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748526996; cv=none; b=EMifJF2TEFx6NtZ6mvQPuRhykI4lNT7r2EjkIG6bRYxW5wFGGCcvdVcWBi9cO+tS0Vwn4Af2v7yYoJCi/5DPFabn2BSCjZhV/Mmq9TU3RqkIO5s/nPQ/g9LKW1Iydra9u0AbnZ44Rv8YCD7LaCnJ/NY9OS8tFlGBgj5L0VHyEdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748526996; c=relaxed/simple;
	bh=moIMP+WW4xOut04v506xlQP7prm+awmGgYk6GfOKqAM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u9zYeKP9Qq2Tlmw0TzZNEV4/LXhgCGydXr3aoNuNw4XXtr7pbbyXSV9JdzPDhyoS+6n5vKxOmeS8q43SJCCnjUGKXfd8KmMd0TBEnrQCNM5KDaTGLVw+VJgLtRAW+aFQ0goIkJ+sGyqh/APi4fuu93JuAeuV6R9nCZtdLqt4ePI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A78522EA;
	Thu, 29 May 2025 06:56:18 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 65BAE3F673;
	Thu, 29 May 2025 06:56:33 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v2 3/9] arm64: efi: initialise the EL
Date: Thu, 29 May 2025 14:55:51 +0100
Message-Id: <20250529135557.2439500-4-joey.gouly@arm.com>
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

Initialise the exception level, which may include dropping to EL1 from EL2, if
VHE is not supported.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/efi/crt0-efi-aarch64.S | 5 +++++
 lib/arm/asm/setup.h        | 1 +
 lib/arm/setup.c            | 1 +
 3 files changed, 7 insertions(+)

diff --git a/arm/efi/crt0-efi-aarch64.S b/arm/efi/crt0-efi-aarch64.S
index 71ce2794..5632fee0 100644
--- a/arm/efi/crt0-efi-aarch64.S
+++ b/arm/efi/crt0-efi-aarch64.S
@@ -147,6 +147,11 @@ _start:
 0:	ldp		x29, x30, [sp], #32
 	ret
 
+.globl do_init_el
+do_init_el:
+	init_el x16
+	ret
+
 	.section	.data
 
 .balign 65536
diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
index 9f8ef82e..6a409b38 100644
--- a/lib/arm/asm/setup.h
+++ b/lib/arm/asm/setup.h
@@ -28,6 +28,7 @@ void setup(const void *fdt, phys_addr_t freemem_start);
 
 #include <efi.h>
 
+void do_init_el(void);
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
 
 #endif
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 0a22dbab..f49fa8ca 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -349,6 +349,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
 
+	do_init_el();
 
 	// EFI exits boot services with SCTLR_ELx.M=1, so keep
 	// the MMU enabled.
-- 
2.25.1



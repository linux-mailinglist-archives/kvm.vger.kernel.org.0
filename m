Return-Path: <kvm+bounces-58769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC363B9FFD5
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 16:28:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E81421B21FC8
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 14:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC4C2C326A;
	Thu, 25 Sep 2025 14:25:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5E3A2C21E7
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 14:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758810314; cv=none; b=iHIKFbf+1JXGZpQPkfxsvtu7XG16rCIw0XUpjEfehoDU/ZCVtCDvlymYQYf+tgEuFh+AI1vu/tjyu3cdKKQjY+hduVu/ZaX+hcY05Idu4Qb6EzQetkWST0yb7BTFUjyT++SQP5O03FnWjG07wP2N+KbhKhn7425smvnnpbM+WE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758810314; c=relaxed/simple;
	bh=jE5qFd8aCzPzhFiibLwZtoM2vlDCXw6n+ke0/1pLRLg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GX30pJOIY3U6vIsmVLaQEVZzWVg7vNF0bBaX7G2YJflIbhkaZ+VGdO3QWp6nrtfwXJndLR/U7WzFz0N+0+sLgcny/SJegChfS4ISCrN+IQqJVK5/gif73ovJLbMLkTuUpT0GKSr+l10xgv46m/Su4getX9mhQ+1LYHTNDDf7+Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E766F1692;
	Thu, 25 Sep 2025 07:25:03 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA6513F694;
	Thu, 25 Sep 2025 07:25:10 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v3 03/10] arm64: efi: initialise the EL
Date: Thu, 25 Sep 2025 15:19:51 +0100
Message-Id: <20250925141958.468311-4-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250925141958.468311-1-joey.gouly@arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
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
 lib/arm/asm/setup.h        | 2 ++
 lib/arm/setup.c            | 1 +
 3 files changed, 8 insertions(+)

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
index 4e60d552..bf05ffbb 100644
--- a/lib/arm/asm/setup.h
+++ b/lib/arm/asm/setup.h
@@ -29,8 +29,10 @@ void setup(const void *fdt, phys_addr_t freemem_start);
 #include <efi.h>
 
 #ifdef __aarch64__
+void do_init_el(void);
 void setup_efi_sctlr(void);
 #else
+static inline void do_init_el(void) {}
 static inline void setup_efi_sctlr(void) {}
 #endif
 
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 0aaa1d3a..5ff40b54 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -349,6 +349,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
 
+	do_init_el();
 
 	setup_efi_sctlr();
 
-- 
2.25.1



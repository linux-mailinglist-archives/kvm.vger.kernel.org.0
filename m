Return-Path: <kvm+bounces-65283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BC15ACA4015
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 15:27:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4774130EB5F1
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 14:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F9D033ADAB;
	Thu,  4 Dec 2025 14:23:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB074340A67
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 14:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764858234; cv=none; b=Jn5JxchUtqB6HN0Mw8U8bcgAaK8JLlITlvtYN00Pc+xrmUHAS1O6XJ8Tz0AED77Nl2APypZ9RloBvX/UfO9Yv4OStthxEk3zdTFZUOzHURU7Kv6M12R9H+1ti3mJIjctuuUuKjaLo+9YVNt/PWtTdREoIp2ef7ue9KF4byJmJt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764858234; c=relaxed/simple;
	bh=qMT4SOjpBVl5muZrm1yCxr4j1oujyqsjailAc+wXJlQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=geK/gxH8TSivzCfb729LhVewG+gB7GLOBRTWro5flUYBsHZOeL9TkffW/l1VQGKHAl6zBHqd4FXbNPkGlOSM6ANyRCdhXwmYgD6icSmittfxpEbDbSWlRU4273MlHCejZv4JVNZedcmRjOMxmpw1R1DzqriTAlDCo440FA9nwVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5666F176A;
	Thu,  4 Dec 2025 06:23:45 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 405273F73B;
	Thu,  4 Dec 2025 06:23:51 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v4 04/11] arm64: efi: initialise the EL
Date: Thu,  4 Dec 2025 14:23:31 +0000
Message-Id: <20251204142338.132483-5-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251204142338.132483-1-joey.gouly@arm.com>
References: <20251204142338.132483-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Initialise the exception level, which may include dropping to EL1 from EL2,
if VHE is not supported.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/efi/crt0-efi-aarch64.S | 5 +++++
 lib/arm/asm/setup.h        | 2 ++
 lib/arm/setup.c            | 2 ++
 3 files changed, 9 insertions(+)

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
index 49f5e0f6..5ff40b54 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -349,6 +349,8 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
 
+	do_init_el();
+
 	setup_efi_sctlr();
 
 	exceptions_init();
-- 
2.25.1



Return-Path: <kvm+bounces-38710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD6CA3DC48
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 15:16:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E828700312
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B557A1FA84F;
	Thu, 20 Feb 2025 14:14:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B32AD1F5849
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 14:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740060854; cv=none; b=CB+IlSxpmMlsEhaVJbwLP8FPengTDUbdkgcdFD0qkrc7v9IBF5v5oTUICnB2qWQ9FzJXVjM28V2/DZLgxetwLSNswNx/OC3buhHtBMd22FglucmGx6xE1/ewshR0ZM600xUNaWF49aocNYd3+ZvTce5M/cAyQGnu2ukN2pmXvc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740060854; c=relaxed/simple;
	bh=/zLVvhHOLuwDjXwobGA7Kf3oSpD/5rKZ5dO/zbvitDE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E/Rmw+unCzMEleZ34gSxA4gw7uTQrhJf/8McY3e1IixxXIVzrIRuigcOe+4C0RdgpuXjTMmp2j1J+N6/YaciypGGN8+2m0xeXejseCqYc7/tfEfFefTknDiLclas0E+8H3ITNc4ZDJXTKvRTx0QCbfQLN0Fe55t2n5rKO5DHAxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 350E31BB0;
	Thu, 20 Feb 2025 06:14:29 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C14F33F59E;
	Thu, 20 Feb 2025 06:14:09 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	drjones@redhat.com,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v1 1/7] arm64: drop to EL1 if booted at EL2
Date: Thu, 20 Feb 2025 14:13:48 +0000
Message-Id: <20250220141354.2565567-2-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250220141354.2565567-1-joey.gouly@arm.com>
References: <20250220141354.2565567-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EL2 is not currently supported, drop to EL1 to conitnue booting.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/cstart64.S | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index b480a552..3a305ad0 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -57,14 +57,25 @@ start:
 	add     x6, x6, :lo12:reloc_end
 1:
 	cmp	x5, x6
-	b.hs	1f
+	b.hs	reloc_done
 	ldr	x7, [x5]			// r_offset
 	ldr	x8, [x5, #16]			// r_addend
 	add	x8, x8, x4			// val = base + r_addend
 	str	x8, [x4, x7]			// base[r_offset] = val
 	add	x5, x5, #24
 	b	1b
-
+reloc_done:
+	mrs	x4, CurrentEL
+	cmp	x4, CurrentEL_EL2
+	b.ne	1f
+drop_to_el1:
+	mov	x4, 4
+	msr	spsr_el2, x4
+	adrp	x4, 1f
+	add	x4, x4, :lo12:1f
+	msr	elr_el2, x4
+	isb
+	eret
 1:
 	/* zero BSS */
 	adrp	x4, bss
@@ -186,6 +197,18 @@ get_mmu_off:
 
 .globl secondary_entry
 secondary_entry:
+	mrs	x0, CurrentEL
+	cmp	x0, CurrentEL_EL2
+	b.ne	1f
+drop_to_el1_secondary:
+	mov	x0, 4
+	msr	spsr_el2, x0
+	adrp	x0, 1f
+	add	x0, x0, :lo12:1f
+	msr	elr_el2, x0
+	isb
+	eret
+1:
 	/* enable FP/ASIMD and SVE */
 	mov	x0, #(3 << 20)
 	orr	x0, x0, #(3 << 16)
-- 
2.25.1



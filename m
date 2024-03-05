Return-Path: <kvm+bounces-11038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D788724BA
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:48:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8C9428A1A0
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A132171AD;
	Tue,  5 Mar 2024 16:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gwZz+/GL"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C2718042
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657245; cv=none; b=CSEfXAPHMmH3+mS/DZVNol19XtIXU9ApT5MUw6E1jqopKhIhzwSKUrU7umVs6Xnevhqx3xehyVfdh7x0TvdItE7rd5VGS0X1FF5YANzHRiv/ohcGraN1GpVGgZi7N9gpMmYxTESH0extXcjZErB7DI8RDlW1BUWTIEkMPUBWsgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657245; c=relaxed/simple;
	bh=UiYLWy5gXfXcrCJwBk9W9L/rn/d/gXXaeO43wVMX9EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=TudKYnqq9j7fcSojBTQYEtyKxKI0rBlT7NV/HN0qoei9fGx7SHKCuZjhVdz/7aCsjeabDcNhU0niYk5emwRSzIQfVVmpDuniD9dxTgERnem+Gi5szlncKODQ0Gb7LWzE/3Ol9+aPsM/+dP1Z3/F+JOdQAgbWP8JwDFJSjBR+LO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gwZz+/GL; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H6sZCXOViSyeJFa4S/XErJyBLA/lVA6LoZVSPOhZj6k=;
	b=gwZz+/GLC1HW6Fvr2Fj4tKaypoutqWHKUouBDgSdODE8+4GrA5u71fYW9wq8C8EkVr2F2e
	8SGoFdrrdRzyxz2bkmA/1pXM4lpNHwodsROXtqpAtNgbxcoitamHAv0nqSIs2ZUWRgOtgD
	9YFiUAn7XS375KFScHSNgBo22UsMNQo=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 17/18] arm64: efi: Switch to our own stack
Date: Tue,  5 Mar 2024 17:46:41 +0100
Message-ID: <20240305164623.379149-37-andrew.jones@linux.dev>
In-Reply-To: <20240305164623.379149-20-andrew.jones@linux.dev>
References: <20240305164623.379149-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We don't want to map EFI_BOOT_SERVICES_DATA regions, so move the
stack from its EFI_BOOT_SERVICES_DATA region to EFI_LOADER_CODE,
which we always map. We'll still map the stack as R/W instead of
R/X because we split EFI_LOADER_CODE regions on the _etext boundary
and map addresses before _etext as R/X and the rest as R/W.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/crt0-efi-aarch64.S | 22 +++++++++++++++++-----
 lib/arm/setup.c            |  4 ----
 lib/memregions.c           |  6 ------
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arm/efi/crt0-efi-aarch64.S b/arm/efi/crt0-efi-aarch64.S
index 5fd3dc94dae8..71ce2794f059 100644
--- a/arm/efi/crt0-efi-aarch64.S
+++ b/arm/efi/crt0-efi-aarch64.S
@@ -125,12 +125,18 @@ _start:
 
 	ldp		x0, x1, [sp, #16]
 
-	/* Align sp; this is necessary due to way we store cpu0's thread_info */
+	/*
+	 * Switch to our own stack and align sp; this is necessary due
+	 * to way we store cpu0's thread_info
+	 */
+	adrp		x2, stacktop
+	add		x2, x2, :lo12:stacktop
+	and		x2, x2, #THREAD_MASK
+	mov		x3, sp
+	mov		sp, x2
+	stp		xzr, xzr, [sp, #-16]!
 	mov		x29, sp
-	mov		x30, sp
-	and		x30, x30, #THREAD_MASK
-	mov		sp, x30
-	str		x29, [sp, #-16]!
+	str		x3, [sp, #-16]!
 
 	bl		efi_main
 
@@ -140,3 +146,9 @@ _start:
 
 0:	ldp		x29, x30, [sp], #32
 	ret
+
+	.section	.data
+
+.balign 65536
+.space 65536
+stacktop:
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 50a3bb65d865..2f649aff5551 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -340,10 +340,6 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
 
-	struct thread_info *ti = current_thread_info();
-
-	memset(ti, 0, sizeof(*ti));
-
 	exceptions_init();
 
 	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
diff --git a/lib/memregions.c b/lib/memregions.c
index 3c6f751eb4f2..53fc0c7cfc58 100644
--- a/lib/memregions.c
+++ b/lib/memregions.c
@@ -114,12 +114,6 @@ void memregions_efi_init(struct efi_boot_memmap *mem_map,
 			break;
 		case EFI_LOADER_DATA:
 			break;
-		case EFI_BOOT_SERVICES_DATA:
-			/*
-			 * FIXME: This would ideally be MR_F_RESERVED, but the
-			 * primary stack is in a region of this EFI type.
-			 */
-			break;
 		case EFI_PERSISTENT_MEMORY:
 			r.flags = MR_F_PERSISTENT;
 			break;
-- 
2.44.0



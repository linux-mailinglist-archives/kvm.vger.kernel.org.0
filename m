Return-Path: <kvm+bounces-10131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0737686A033
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:29:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 37601B3258A
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F9F914C58E;
	Tue, 27 Feb 2024 19:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nubMGlgn"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A1714C58D
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 19:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061744; cv=none; b=TO4eR1wWCZlVdIFwN6Gve34iuBnAJBshq2gSIZ7oSXFrgefetkg/msuG2oboOdgfhEBdsqlecNasZE6Tzx55cRfZZukkcsaGkQrLDhiK84VQ/oWAVE2GI3a40WnI/Dx1yU8+VaHz6wTvXPLfZhjTF/jFcLjDrOPgGofqXXsYsos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061744; c=relaxed/simple;
	bh=2cNigJsJ6R/+g4e4oKY8+adSabfgLoQTTCYyuT80lCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=n0GT/Sx0UbHQpm09RWcQ0KsrIhWzerawPcrecesBvwX9c0wIZ4G+xEQt4EL9gTu823XQFdws6Cldk4ubqTBQqar59TvWo8rGPukXWO+LodBqhqB8k1qCZND/ExntHC25qwtPJZwx2f4xTy8wKIUnd+k/YPTonoSbYn4EEiF7has=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nubMGlgn; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tEkS9mcwK16aQNtVBNfAwl68dPDUtPcmYv6jp7A4TCg=;
	b=nubMGlgn+cuQiNM9PeSOiPR4E8ES9Fam8oLmlsIampWvzF++CiaXruwyYifxrG2KhMAG3y
	/CFOegMw0imt2FPy89a8Bt4hrL7u0mEaS6B7t8w0yEBxtlyiZWIgPQB5/O77lFEQ04gPDG
	TDduzzFb5I1uMqNB/RM6RNDqRY0FBHc=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 16/18] arm64: efi: Fix _start returns from failed _relocate
Date: Tue, 27 Feb 2024 20:21:26 +0100
Message-ID: <20240227192109.487402-36-andrew.jones@linux.dev>
In-Reply-To: <20240227192109.487402-20-andrew.jones@linux.dev>
References: <20240227192109.487402-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If _relocate fails we need to restore the frame pointer and the link
register and return from _start. But we've pushed x0 and x1 on below
the fp and lr, so, as the code was, we'd restore the wrong values.
Revert parts of the code back to the way they are in gnu-efi and move
the stack alignment below the loading of x0 and x1, after we've
confirmed _relocate didn't fail.

Fixes: d231b539a41f ("arm64: Use code from the gnu-efi when booting with EFI")
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/crt0-efi-aarch64.S | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arm/efi/crt0-efi-aarch64.S b/arm/efi/crt0-efi-aarch64.S
index 5d0dc04af54a..5fd3dc94dae8 100644
--- a/arm/efi/crt0-efi-aarch64.S
+++ b/arm/efi/crt0-efi-aarch64.S
@@ -111,17 +111,10 @@ section_table:
 
 	.align		12
 _start:
-	stp		x29, x30, [sp, #-16]!
-
-	/* Align sp; this is necessary due to way we store cpu0's thread_info */
+	stp		x29, x30, [sp, #-32]!
 	mov		x29, sp
-	mov		x30, sp
-	and		x30, x30, #THREAD_MASK
-	mov		sp, x30
-	str		x29, [sp, #-16]!
-
-	stp		x0, x1, [sp, #-16]!
 
+	stp		x0, x1, [sp, #16]
 	mov		x2, x0
 	mov		x3, x1
 	adr		x0, ImageBase
@@ -130,12 +123,20 @@ _start:
 	bl		_relocate
 	cbnz		x0, 0f
 
-	ldp		x0, x1, [sp], #16
+	ldp		x0, x1, [sp, #16]
+
+	/* Align sp; this is necessary due to way we store cpu0's thread_info */
+	mov		x29, sp
+	mov		x30, sp
+	and		x30, x30, #THREAD_MASK
+	mov		sp, x30
+	str		x29, [sp, #-16]!
+
 	bl		efi_main
 
 	/* Restore sp */
 	ldr		x30, [sp], #16
-	mov             sp, x30
+	mov		sp, x30
 
-0:	ldp		x29, x30, [sp], #16
+0:	ldp		x29, x30, [sp], #32
 	ret
-- 
2.43.0



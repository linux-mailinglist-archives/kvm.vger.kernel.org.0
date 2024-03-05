Return-Path: <kvm+bounces-11037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E98CB8724B9
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:48:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B6AE1F21F2A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7561817BD6;
	Tue,  5 Mar 2024 16:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OAmT32Y0"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B486817BC9
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657240; cv=none; b=esk8vr2pbr/ct4tnB4eVWAI2rGCA40veU0QFfjLD3K2ihShSaOEg+r7E2LyGBSWfPcvxniLyAvt6w+huXqs05xnGr07gCvVqS36BT2RYtXB6UmpiUeOCMUWQ/slCBV9IzlZigtmGLj/AWR9lbEEVuC/QY//Mr3jGFAxNjyvirgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657240; c=relaxed/simple;
	bh=kfbksDLU0oleM1n33Ubs0/lI7k/baHZ41Yowlo/h3P4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=plDX0pwyvVa9UrspSp+h8Faa5mIeW+mZECOwP/HeyqgeprVVKyziuVTN2tRZN6pZ5RkTFZYJ1zGo1Oyppb0unjFuy7zcbLaF4Z7zySdjwLJ3n3dxQrYlsCp8MGmy4+HRsyX/fPsRLluiiCF1LQtzuIFlutqD4VuPzEt/3lJ3nK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OAmT32Y0; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HQ4JA+Ier4tRHU77UaIWMK8ZDxNHJNGYciw82FNflFs=;
	b=OAmT32Y0Wh/VQvoBgz8tkirmX3Ztr3HYnqKP17a3jHEy8r+HvG2Z4DgRVTPePsEvAbOiLN
	UPygaXS9m06KcVA9NVktu8PjEnSFGzh3+S1Cf8B2WSZSj/Gre2xbQCR2AhEj/twXq/jazI
	hzYhwSOcCJQjsVKFwkldU5P8sniyodk=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 16/18] arm64: efi: Fix _start returns from failed _relocate
Date: Tue,  5 Mar 2024 17:46:40 +0100
Message-ID: <20240305164623.379149-36-andrew.jones@linux.dev>
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

If _relocate fails we need to restore the frame pointer and the link
register and return from _start. But we've pushed x0 and x1 on below
the fp and lr, so, as the code was, we'd restore the wrong values.
Revert parts of the code back to the way they are in gnu-efi and move
the stack alignment below the loading of x0 and x1, after we've
confirmed _relocate didn't fail.

Fixes: d231b539a41f ("arm64: Use code from the gnu-efi when booting with EFI")
Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
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
2.44.0



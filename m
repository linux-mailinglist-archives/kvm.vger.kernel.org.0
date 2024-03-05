Return-Path: <kvm+bounces-11028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDE5B8724AE
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:47:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3AB41F23349
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C95617582;
	Tue,  5 Mar 2024 16:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D39zMGUp"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90161DDB3
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657213; cv=none; b=jw/hdilQe2gMkUYmCsgYCUmXrCkLXASRn24gTU0V8xmRhp1wXH2gN9hKVfocIDxWyhe4ziY1VSV9Ngh2tyussCBV5uagq45LlJXSXMgIBGLLooX3IEbGP4mnlJXf8dkFoQHAS9RpxNZ6jzj7aE3/G0zJOizgUbIz6QlcPJD4iY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657213; c=relaxed/simple;
	bh=EPFyW7c6EsiO/vnTF2sd6CY1291yH7snUNrDM0XWKbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=F/GZfRhzGrG0dU4Wj9AfO6kM2UVCeNI+8Fn+KuOIK8mQJZ6qo6GV0xX7AXFqHy9vX2ngKdmPh/uemSXI4GUa335p/sb9bJirEqFXbF9MDNx98k8Ck+FpfU8ANXHs/SwYOGyCuQzIXuwnsZfxCIn0odMNqyLjkXt7UGFz2b8Hots=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D39zMGUp; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jP0leUSpwFZInD+7iqpmb8nTOrwcW8p9rgtcU0feSoQ=;
	b=D39zMGUpcduVXrUX0ckZb9ZlnTlBzUPFHKy+DVuJRWzMrjZXf8M8+e1+4C9Q3oei1cXIaF
	xdIyz7JrLedMjMWl0XvkQwG3N5OuMBzF//Wxgq1pp+TuGB5G548XBviFQUxykfSeh2ctxS
	FeJPM09cNTYNATQLivKX6kFeOAdWjUo=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 07/18] arm64: efi: Remove EFI_USE_DTB
Date: Tue,  5 Mar 2024 17:46:31 +0100
Message-ID: <20240305164623.379149-27-andrew.jones@linux.dev>
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

We don't need two variables for one boolean property. Just use
!EFI_USE_ACPI to infer efi-use-dtb.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/run | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index 494ba9e7efe7..b7a8418a07f8 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -27,8 +27,6 @@ fi
 : "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
 : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
 
-[ "$EFI_USE_ACPI" = "y" ] || EFI_USE_DTB=y
-
 if [ ! -f "$EFI_UEFI" ]; then
 	echo "UEFI firmware not found."
 	echo "Please specify the path with the env variable EFI_UEFI"
@@ -68,7 +66,7 @@ uefi_shell_run()
 	mkdir -p "$EFI_CASE_DIR"
 	cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
 	echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
-	if [ "$EFI_USE_DTB" = "y" ]; then
+	if [ "$EFI_USE_ACPI" != "y" ]; then
 		qemu_args+=(-machine acpi=off)
 		FDT_BASENAME="dtb"
 		UEFI_SHELL_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}"
-- 
2.44.0



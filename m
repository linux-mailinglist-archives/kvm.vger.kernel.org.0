Return-Path: <kvm+bounces-10120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE6B86A012
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:22:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA9F11C28F75
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D31B91487E2;
	Tue, 27 Feb 2024 19:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cLy3zRtg"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3C61487DC
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 19:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061696; cv=none; b=eIvvges4mLbececQLGDPoOv8UfdeyWSf/b/ylinxc+S26GUT5wbIGum5RLQhOhLEXEfC2egFFZGblVGumTfRkY5cyiijV8XGlt+kttOFsuHQEHD8opPmoPTO/AkVwZsqWeMTuauUr25FeO60ui4ms7BykW9+JeCz7Sjrr8D7dms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061696; c=relaxed/simple;
	bh=BoBz/S/wtgNn0b2w3x5Xyyoegeq7eW2pC44M0/GD4LM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=LF3an2dC2sFZfH5HUoO+roFBXd3BnOliam5DFoDYm0ejkhsFkFFE2pvyIgGRg2etsBW6FMkzI7eGyVbKmishY0jzz3H7NB7DO/7PwpniwMd/uIOZ8sAdC7Frsb0Xxv1Ac9TMHuvh2Z3FgB7zeb8b9P24T5ZxGEZX0/WGh4HkOIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cLy3zRtg; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ulzjyiK3ZcBO8GfguKNO7JW+HXX1i+VA6rmcrThM2TI=;
	b=cLy3zRtgI3njJbUroUMxK6mb79iKZZXETKp9d4+r99Fo4WlcgJndPwNiIMiiY0eo6FdsPi
	KFvOLD9zPVIDP36kcQQyThwSUSu2FL0aAY6EGRoUJnW3ftyeNGNHsxugvr6a2gkKT1Oyac
	zPC+YgYDJxzwoUndA2ND3iaz07zV3Ac=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 05/18] arm64: efi: Remove redundant dtb generation
Date: Tue, 27 Feb 2024 20:21:15 +0100
Message-ID: <20240227192109.487402-25-andrew.jones@linux.dev>
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

When a line in bash is written as

 $(some-line)

Then 'some-line' will be evaluated and then whatever some-line outputs
will be evaluated. The dtb is getting generated twice since the line
that should generate it is within $() and the output of that is the
command itself (since arm/run outputs its command), so the command
gets executed again. Remove the $() to just execute dtb generation
once.

While mucking with arm/efi/run tidy it a bit by by removing the unused
sourcing of common.bash and the unnecessary 'set -e' (we check for and
propagate errors ourselves). Finally, make one reorganization change
and some whitespace fixes.

Fixes: 2607d2d6946a ("arm64: Add an efi/run script")
Fixes: 2e080dafec2a ("arm64: Use the provided fdt when booting through EFI")
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/run | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index 8b6512520026..e45cecfa3265 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -1,7 +1,5 @@
 #!/bin/bash
 
-set -e
-
 if [ $# -eq 0 ]; then
 	echo "Usage $0 TEST_CASE [QEMU_ARGS]"
 	exit 2
@@ -13,7 +11,6 @@ if [ ! -f config.mak ]; then
 fi
 source config.mak
 source scripts/arch-run.bash
-source scripts/common.bash
 
 if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
 	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
@@ -27,6 +24,7 @@ fi
 : "${EFI_CASE:=$(basename $1 .efi)}"
 : "${EFI_TESTNAME:=$TESTNAME}"
 : "${EFI_TESTNAME:=$EFI_CASE}"
+: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
 : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
 
 [ "$EFI_USE_ACPI" = "y" ] || EFI_USE_DTB=y
@@ -65,20 +63,18 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
 	exit
 fi
 
-: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
 mkdir -p "$EFI_CASE_DIR"
-
 cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
 echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
 if [ "$EFI_USE_DTB" = "y" ]; then
 	qemu_args+=(-machine acpi=off)
 	FDT_BASENAME="dtb"
-	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}")
+	EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}"
 	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
 fi
 echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_CASE_DIR/startup.nsh"
 
 EFI_RUN=y $TEST_DIR/run \
-       -bios "$EFI_UEFI" \
-       -drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
-       "${qemu_args[@]}"
+	-bios "$EFI_UEFI" \
+	-drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
+	"${qemu_args[@]}"
-- 
2.43.0



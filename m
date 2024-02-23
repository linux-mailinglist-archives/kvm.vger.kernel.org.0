Return-Path: <kvm+bounces-9537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AEEB861656
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 16:52:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EAC2F1F25FAA
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 15:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B724882D84;
	Fri, 23 Feb 2024 15:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XpIEBOdb"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508F682D6D
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 15:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708703535; cv=none; b=PmrZr1BD3BpYcq6wXSkeWLBlUsloA1O/X0MiUgjlo6bhN2MQm5aefupvl406A/FQsRG4F0XMVkokD5BMT+kLHI4OmKclYyE+wKoAsMaf54JPe0vS0Rpvz6w+b/J0FDBRQQnshu0Zgi+h5kqjlVwuRWo+qCnP9SqIpGkbftxa1ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708703535; c=relaxed/simple;
	bh=pbhRCFWKrwLmCtktpDAGcl7va/xUmhq1PnDLXV/IAw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=QgmX7Nnd2FGUbnUu1uFKwbTAegBvOgA+kRTwDq0OY7FvbkntXZhdfG+UTUL3cVkAxosSuLTp7vgO6zf+3HO5XYQ0gAVOe3iFw25Zc79TPyj2G0ZxS9hdy3Yszr825/AbTreKyXIl10UMT1Gv06fRgz3Nb0TU13GQqo5Hm8CfZRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XpIEBOdb; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708703531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RhisSx5x/V7b9Y0kHLu8YVQTirjJ97CAwr4agFIIB1Y=;
	b=XpIEBOdbXXUZz9GBnf+YnwPnuelMz0R6AIyG3MoHt6rcR3vOruHZCgq7ZXWFwRyXA6J31l
	6WfVy31xHZfbN/A02bnGHDwTJw9KPGGX+BA8IIy0eM3m5RBq15e0+8KC2EIYSJGrdOl9WW
	1MOO9/gx9NfcHxTjJezk2bi8tnPaQ+0=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 07/14] arm64: efi: Remove EFI_USE_DTB
Date: Fri, 23 Feb 2024 16:51:33 +0100
Message-ID: <20240223155125.368512-23-andrew.jones@linux.dev>
In-Reply-To: <20240223155125.368512-16-andrew.jones@linux.dev>
References: <20240223155125.368512-16-andrew.jones@linux.dev>
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
2.43.0



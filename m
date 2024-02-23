Return-Path: <kvm+bounces-9533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECAD8861651
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 16:52:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70ECFB22A3D
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 15:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D311682D81;
	Fri, 23 Feb 2024 15:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T+xQGVyr"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B06382C94
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 15:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708703510; cv=none; b=Vrrr4WxbnlcwjnW7NYrlMyel0mYnnc26W0d42KCKa67aQFFjOmxb0iITvAoQQWnOJxFabiAkFqRCviR4K6U2lF7aEdo52MycdcLS+OGNeGYTVc2T7UCc0lSABY5mcgUndux87ZoPiTxA0DHHtQn/ext2/5RFEeSgyVt39gvH240=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708703510; c=relaxed/simple;
	bh=iAcqRhpWnmxPRht06kZJBZfd6TfGtdgpBsS5jPtRCzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=f6BaUAbTlXkHtex7rjUqF8XLaTqWR97DAu3HpPn4qEYLCYQstg4Z0hShzOXq6tCL15KnLUnhWNh/iUFbAkdzI/0cAMLOkkHvuPKh9nHbI30xyP2OGKaVNzdiWunlCMzE9S9xjmTtjN4/IWORhVQezuAGBMFUH0lRVVxkoFaCszc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T+xQGVyr; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708703506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZtRLPtvNLuRe5mE7VJYVBFfuNR+bm5yOU8r9yvFXgU=;
	b=T+xQGVyrSfPDJVz6hAUVaaupPU0DDvzNwldSsjrNMFNIjPpbltm8Z9255w2IUN+S4zr0m6
	R02KfqnHaCP9gsGZpYJAqzpc9Nz6dRA3qBgNlbe7t3pzUBmKw2Ht7ICUclycV+wIrbj1Rk
	ZEFW5QzU0Ql2YS1s5lSm6CQCRbUFgV0=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 03/14] arm64: efi: Don't create dummy test
Date: Fri, 23 Feb 2024 16:51:29 +0100
Message-ID: <20240223155125.368512-19-andrew.jones@linux.dev>
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

The purpose of the _NO_FILE_4Uhere_ kernel is to check that all the
QEMU command line options that have been pulled together by the
scripts will work. Since booting with UEFI and the -kernel command
line is supported by QEMU, then we don't need to create a dummy
test for _NO_FILE_4Uhere_ and go all the way into UEFI's shell and
execute it to prove the command line is OK, since we would have
failed much before all that if it wasn't. Just run QEMU "normally",
i.e. no EFI_RUN=y, but add the UEFI -bios and its file system command
line options, in order to check the full command line.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/run | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arm/efi/run b/arm/efi/run
index 6872c337c945..e629abde5273 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -53,7 +53,14 @@ while (( "$#" )); do
 done
 
 if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
-	EFI_CASE=dummy
+	EFI_CASE_DIR="$EFI_TEST/dummy"
+	mkdir -p "$EFI_CASE_DIR"
+	$TEST_DIR/run \
+		$EFI_CASE \
+		-bios "$EFI_UEFI" \
+		-drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
+		"${qemu_args[@]}"
+	exit
 fi
 
 : "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
-- 
2.43.0



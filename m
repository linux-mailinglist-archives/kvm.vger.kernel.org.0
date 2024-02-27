Return-Path: <kvm+bounces-10118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 111A186A010
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:21:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CD241C28E39
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5ACC145356;
	Tue, 27 Feb 2024 19:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O2GFx3c7"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8EE1482F3
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 19:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061690; cv=none; b=BnFdIC1K7m/97LhIV+i61UqazNBhx4K2hy0alnuEyi3mgE0c4tiJ7A0n+D1MI0s5f8IDGorhAlpK9lH/XA7cl426DD2b8l2l0px+S9tcVC8oEaBW7fkiUzgKYyQ4t7FSUc8i/R+QqoYsyY8uRWYOTJjMTHLcgfie13IorTxts7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061690; c=relaxed/simple;
	bh=iAcqRhpWnmxPRht06kZJBZfd6TfGtdgpBsS5jPtRCzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Q+MtxQsoavfcsNBaRGeVd74PHE10PO1Lb44Krua7nRC8v7ws5Vxv1xvK11mDLepV+Xg6YqDuBHRr9M5oxm/6qBbiUJDv3dYpTpHthnA+ev2cmCxw4nwd8oRLy5ij0vHY4lM1UaOMJNezP4ebbIQRVBiOtcerMBBA6ixJPdYnGDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O2GFx3c7; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZtRLPtvNLuRe5mE7VJYVBFfuNR+bm5yOU8r9yvFXgU=;
	b=O2GFx3c7kcmr/eaqY1fksuWD6IMxO60Bl/5edxWe4nyGmsKXqdwfDRpAPqIDhZwjOgMuEI
	Pj8ZxqiMS0hRHpteiLuxJpGPVOvqvlmbhfUiZdo/SfCOMI/s+aGWkE4WJgL/HPyBZUOBjQ
	IjrHVbOM+UmVi9IS1RMoZ6fNLJFbaW8=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 03/18] arm64: efi: Don't create dummy test
Date: Tue, 27 Feb 2024 20:21:13 +0100
Message-ID: <20240227192109.487402-23-andrew.jones@linux.dev>
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



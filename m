Return-Path: <kvm+bounces-10119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51A9B86A011
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:21:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 815C31C28E91
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AC621487D1;
	Tue, 27 Feb 2024 19:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wukcpKLX"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD2E14830C
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 19:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061692; cv=none; b=Y7AH99l9RINGR1JhfIeNx/TU9SF/PUMGIb4XUasOGhALD2fj7vexmIBGScr8hyf1nNC2sv0ynOcH4popUtFDKdLiLaJHNIBLT0wo3arL+C//CYrBWlrkgySQ7Ar/u61z43aOP75DdZ3jtc5aYMZ7ajTgAs8IRM1Acsb7v9xF5lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061692; c=relaxed/simple;
	bh=GPrAyHLVf2wc88m9XK+4/DbNDHYGrAjShKzfIawstR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Ip31L48PLZrxmF4gSL5bw/phbw2BORAFCq1JpRHvHuvNoFnjqg3WJtr3WAnV9tmdVh8H5eHOqWNqvS30suft/21pLB/+A11d6oJm5TQxpHbkEzRZ4aj7sRUcbU+oAYK/DVmG8vslvzpBvQPOIEriQKck0Si0uVq/mpB3E8aOzis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wukcpKLX; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m99aX8Q0esPhIRcjJL5DRMkAA/e1dGPeO2kzwVCYgCo=;
	b=wukcpKLXSxnoLOS4e73eKdtNh/3/80ElcHJk2EwI2mnXwKpLjI9EW1KJDHqlY6vmSaqwwm
	j0xbpNdCT1eespkdPW2nf8nsEzuJ5S+94SIIYsvuy8B+3BU9Lx7DRLGOuI34Ng1yO+Kg60
	hyb9S2a3KQNFaRqyda+Z9jBJRyKdHPU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 04/18] arm64: efi: Make running tests on EFI can be parallel
Date: Tue, 27 Feb 2024 20:21:14 +0100
Message-ID: <20240227192109.487402-24-andrew.jones@linux.dev>
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

From: Shaoqin Huang <shahuang@redhat.com>

Currently running tests on EFI in parallel can cause part of tests to
fail, this is because arm/efi/run script use the EFI_CASE to create the
subdir under the efi-tests, and the EFI_CASE is the filename of the
test, when running tests in parallel, the multiple tests exist in the
same filename will execute at the same time, which will use the same
directory and write the test specific things into it, this cause
chaotic and make some tests fail.

For example, if we running the pmu-sw-incr and pmu-chained-counters
and other pmu tests on EFI at the same time, the EFI_CASE will be pmu.
So they will write their $cmd_args to the $EFI/TEST/pmu/startup.nsh
at the same time, which will corrupt the startup.nsh file.

And we can get the log which outputs:

* pmu-sw-incr.log:
  - ABORT: pmu: Unknown sub-test 'pmu-mem-acce'
* pmu-chained-counters.log
  - ABORT: pmu: Unknown sub-test 'pmu-mem-access-reliab'

And the efi-tests/pmu/startup.nsh:

@echo -off
setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
pmu.efi pmu-mem-access-reliability
setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
pmu.efi pmu-chained-sw-incr

As you can see, when multiple tests write to the same startup.nsh file,
it causes the issue.

To Fix this issue, use the testname instead of the filename to create
the subdir under the efi-tests. We use the EFI_TESTNAME to replace the
EFI_CASE in script. Since every testname is specific, now the tests
can be run parallel. It also considers when user directly use the
arm/efi/run to run test, in this case, still use the filename.

Besides, replace multiple $EFI_TEST/$EFI_CASE to the $EFI_CASE_DIR, this
makes the script looks more clean and we don'e need to replace many
EFI_CASE to EFI_TESTNAME.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/run | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index e629abde5273..8b6512520026 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -25,6 +25,8 @@ fi
 : "${EFI_UEFI:=$DEFAULT_UEFI}"
 : "${EFI_TEST:=efi-tests}"
 : "${EFI_CASE:=$(basename $1 .efi)}"
+: "${EFI_TESTNAME:=$TESTNAME}"
+: "${EFI_TESTNAME:=$EFI_CASE}"
 : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
 
 [ "$EFI_USE_ACPI" = "y" ] || EFI_USE_DTB=y
@@ -63,20 +65,20 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
 	exit
 fi
 
-: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
+: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
 mkdir -p "$EFI_CASE_DIR"
 
-cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
-echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
+cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
+echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
 if [ "$EFI_USE_DTB" = "y" ]; then
 	qemu_args+=(-machine acpi=off)
 	FDT_BASENAME="dtb"
-	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_TEST/$EFI_CASE/$FDT_BASENAME" "${qemu_args[@]}")
-	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_TEST/$EFI_CASE/startup.nsh"
+	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}")
+	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
 fi
-echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"
+echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_CASE_DIR/startup.nsh"
 
 EFI_RUN=y $TEST_DIR/run \
        -bios "$EFI_UEFI" \
-       -drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
+       -drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
        "${qemu_args[@]}"
-- 
2.43.0



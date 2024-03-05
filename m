Return-Path: <kvm+bounces-11025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C2BA48724AA
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:47:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4391B24A2F
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC11B15E85;
	Tue,  5 Mar 2024 16:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EuQHOExU"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893E113FE0
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657201; cv=none; b=KuuM7zJnjr2xownfDJzMFutw1k7lXYkNlQrnE55Oyyfoa4dE+S5skJjlPUQbzpiLBqNmOMcAY9Ytw2tq3CJOXNdm2KTUKTDq1Jlz6Y2eV4ti2KE2sG0+rCaCTnhklMZohz1cR37fuSU4vLlWlnZgvQb7/UHQJOXf+WSZ9qN6o58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657201; c=relaxed/simple;
	bh=tFhbxtYyeFR7DQV04WEp9S1dqAxKC1qIlGAM3c/wg2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=FBsHHNsDlKzxLNMlnKWn3jXiTDuy6c8suUByaq0pOpjXacafNV/dqbXCn914N1qZBW1sO2v+FP96qUS6Avrbj/vyb4KBn3GV6Fg5af1DsT01e2paXaazICnbpNJgZ2Sbso5QeEpblyiAaOPjtMDv8vsmBzSTEsEaezMN3j+l/TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EuQHOExU; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6v4dgcC88/jGlNFEQij8AjD/BQIJSZRkdeHFYEeHLqk=;
	b=EuQHOExUQwv3OO5cmBLsY05p5V4kGzmMW1pHsT6c5erNvYa4WKotzZA4zQIigq/xXshhMY
	sbfFtG3vUzZO86eQLRf8/0BGiAC1k2WT6FyHC6jyBGP7up9gzPTQ39lcrHXA/xqSkiPobZ
	JNUyvzOOAUwv6KBMGXWCmMW2QJYs1fE=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 04/18] arm64: efi: Make running tests on EFI can be parallel
Date: Tue,  5 Mar 2024 17:46:28 +0100
Message-ID: <20240305164623.379149-24-andrew.jones@linux.dev>
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
Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
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
2.44.0



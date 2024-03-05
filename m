Return-Path: <kvm+bounces-11023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5101E8724A5
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:47:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C2232851FA
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D88E414A8E;
	Tue,  5 Mar 2024 16:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IfPQbcFv"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78125D528
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657199; cv=none; b=q0MP2CBYnOjzcTNBwPM87M2y7ZFgat65xjLWRQ05pyRIy+ziY6DUGQpQk4kVVBneX/BF8397SoWKdCzBGJ82/AU5Qww4bygbBG1eO7ICFUgTmEB9qKVqtkzNNKpS6b45V1K04PIJPk/jQ854DIl4XDncyHJFlMyf/b6xeA/+vrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657199; c=relaxed/simple;
	bh=tloykq4FipHwzmG+LtYESH6X6ycS0Nf4/O5QnjtLbyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=TDjaKEmAwzt4RZyMRfehtew+2xvXnGsCbHVH/L3fyP3+OCVFrsNHu2VuLs6I7GYV4kl+gNMH0NlxsC/pf8RsWE/zKgl4SCYw5NsRcCJBEiLBkAAAZY4RRpceq48bfrOmG+mCgjG0bq9AawR1UN7ElBCcY1j3TY/PtyV9uwon/B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IfPQbcFv; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fpQfrotHy+/SWb8R20YZRRn8M8ivZ5IKPumNkXdds/M=;
	b=IfPQbcFvR12atPYoxuk/D5YyZnpxN0QHT6CP7AgR7NRl23jMoERaSyl2nMwgVf0RRBdtvM
	K8QtYY6WBzUwROTSES/mhdH7AxPjhsooXOuXtaKMacg8/Xp6R0M2z1VAVXYPLxV119r5wG
	FUzwD5VRVkvqT/jRSQBz0MFVq+poi6Y=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 03/18] arm64: efi: Don't create dummy test
Date: Tue,  5 Mar 2024 17:46:27 +0100
Message-ID: <20240305164623.379149-23-andrew.jones@linux.dev>
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

The purpose of the _NO_FILE_4Uhere_ kernel is to check that all the
QEMU command line options that have been pulled together by the
scripts will work. Since booting with UEFI and the -kernel command
line is supported by QEMU, then we don't need to create a dummy
test for _NO_FILE_4Uhere_ and go all the way into UEFI's shell and
execute it to prove the command line is OK, since we would have
failed much before all that if it wasn't. Just run QEMU "normally",
i.e. no EFI_RUN=y, but add the UEFI -bios and its file system command
line options, in order to check the full command line.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
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
2.44.0



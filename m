Return-Path: <kvm+bounces-2715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24E0F7FCD5F
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 04:21:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2D7B28340F
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 03:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA2715684;
	Wed, 29 Nov 2023 03:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y2VNnSTM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0E31AD
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 19:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701228093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RTiiyUHS57U2PuUpOdG+qJDn6kSzgqaQX16o84c5trw=;
	b=Y2VNnSTM1YLgOpfa3evMYDjRW7BWj6GY6TJQLAyacHUsUdjCipC4pg8K6Khi5DyMHQBmu7
	ccDwmhQMQup0+TER/a24y0zEs2LGGwTAfLhzYAN2mTPzOaJ3fm4hZ0C8d65pOESRnTKFMi
	1zF6zpusanYtqxdZ3IEOH9rbzFrG3No=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-177-PmsQUhqJODOBadyt85gnCA-1; Tue,
 28 Nov 2023 22:21:31 -0500
X-MC-Unique: PmsQUhqJODOBadyt85gnCA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DC7438062B2;
	Wed, 29 Nov 2023 03:21:31 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F32A0492BFE;
	Wed, 29 Nov 2023 03:21:30 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Ricardo Koller <ricarkol@google.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 3/3] arm64: efi: Make running tests on EFI can be parallel
Date: Tue, 28 Nov 2023 22:21:23 -0500
Message-Id: <20231129032123.2658343-4-shahuang@redhat.com>
In-Reply-To: <20231129032123.2658343-1-shahuang@redhat.com>
References: <20231129032123.2658343-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Currently running tests on EFI in parallel can cause part of tests to
fail, this is because arm/efi/run script use the EFI_CASE to create the
subdir under the efi-tests, and the EFI_CASE is the filename of the
test, when running tests in parallel, the multiple tests exist in the
same filename will execute at the same time, which will use the same
directory and write the test specific things into it, this cause
chaotic and make some tests fail.

To Fix this things, use the testname instead of the filename to create
the subdir under the efi-tests. We use the EFI_TESTNAME to replace the
EFI_CASE in script. Since every testname is specific, now the tests
can be run parallel. It also considers when user directly use the
arm/efi/run to run test, in this case, still use the filename.

Besides, replace multiple $EFI_TEST/$EFI_CASE to the $EFI_CASE_DIR, this
makes the script looks more clean and we don'e need to replace many
EFI_CASE to EFI_TESTNAME.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 arm/efi/run | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index 6872c337..03bfbef4 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -24,6 +24,8 @@ fi
 : "${EFI_SRC:=$TEST_DIR}"
 : "${EFI_UEFI:=$DEFAULT_UEFI}"
 : "${EFI_TEST:=efi-tests}"
+: "${EFI_TESTNAME:=$TESTNAME}"
+: "${EFI_TESTNAME:=$(basename $1 .efi)}"
 : "${EFI_CASE:=$(basename $1 .efi)}"
 : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
 
@@ -56,20 +58,20 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
 	EFI_CASE=dummy
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
2.40.1



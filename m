Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EF5726950
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 20:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbjFGS7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 14:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjFGS7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 14:59:11 -0400
Received: from out-7.mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B801C1BF1
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 11:59:10 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686164348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R2mcgVGU7qYfFK9K8YC8zHT3+BWJ0PSMo7hBgDcImhE=;
        b=Ik8znPXcXHK6uVj4HvcnKJrCGaEylCpGijJYBnYQpYry7Gz/ZH/uRVSK/Vfi/jQBcS/lNv
        smKTkTmPIBQ4/Dlm5ULPlPKW4g2DhyTfrZJrui2dgakzp/5bEpXjHrqntDQfDhEZUMjqvu
        4uco64pHnw7lOmmEbjalcp+rT3slaNE=
From:   Andrew Jones <andrew.jones@linux.dev>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH 2/3] arm/efi/run: Add Fedora's path to QEMU_EFI
Date:   Wed,  7 Jun 2023 20:59:04 +0200
Message-Id: <20230607185905.32810-3-andrew.jones@linux.dev>
In-Reply-To: <20230607185905.32810-1-andrew.jones@linux.dev>
References: <20230607185905.32810-1-andrew.jones@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Try Fedora's default path too.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/run | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index c61da31183a7..f75ef157acf3 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -15,8 +15,14 @@ source config.mak
 source scripts/arch-run.bash
 source scripts/common.bash
 
+if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
+	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
+elif [ -f /usr/share/edk2/aarch64/QEMU_EFI.silent.fd ]; then
+	DEFAULT_UEFI=/usr/share/edk2/aarch64/QEMU_EFI.silent.fd
+fi
+
 : "${EFI_SRC:=$(realpath "$(dirname "$0")/../")}"
-: "${EFI_UEFI:=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd}"
+: "${EFI_UEFI:=$DEFAULT_UEFI}"
 : "${EFI_TEST:=efi-tests}"
 : "${EFI_CASE:=$(basename $1 .efi)}"
 : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
@@ -24,9 +30,8 @@ source scripts/common.bash
 [ "$EFI_USE_ACPI" = "y" ] || EFI_USE_DTB=y
 
 if [ ! -f "$EFI_UEFI" ]; then
-	echo "UEFI firmware not found: $EFI_UEFI"
-	echo "Please install the UEFI firmware to this path"
-	echo "Or specify the correct path with the env variable EFI_UEFI"
+	echo "UEFI firmware not found."
+	echo "Please specify the path with the env variable EFI_UEFI"
 	exit 2
 fi
 
-- 
2.40.1


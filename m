Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA88453B1E
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 21:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhKPUoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 15:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhKPUoE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 15:44:04 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B34CC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:41:07 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v23so414730pjr.5
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eT2uK5iWzmGTlr1p6wJHz1YbA/c4PXLTlOcjdQGarGM=;
        b=ERsUxkOJItxISuNgJpljb5OyMJcVfeJNmO1ku13/OEjhV9RHcZvg0EtE40+YsA2FSJ
         vMLCdLWnKS2k1Fg25Sm1U/A3aD3+ux+bATGl9Kf/STLT2p18Ii4RHTtGJKTYEhmFi/jA
         KX8Ivt/yLBja04Ho603Yh0MZYi9TeEJscy2yaXcuWJePL0T3F3Z0Ihwd5UgS1Vlk6aGS
         B7ELPntiU+b1mRw2RCt6XgtiFr6HLrfwvKjprrxx//mOmsaqCYMjo61E23k1PCDkz5zY
         fRHwUSsgot3D9W51zjCUJKMy2hO7kAWDZ8XgUJaEu7WMSqBieTI/mM28Bd1gEIBYtC2D
         e9Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eT2uK5iWzmGTlr1p6wJHz1YbA/c4PXLTlOcjdQGarGM=;
        b=EAw0xrUzFZXpDs+STCL+8tb7th42w/uZp4lDgBPuY0riRdqr2VBfUAHKU0si0pd1fD
         jJ4Oitt4s382kxITt8924Pk+jOKMKzH1axS/+edzjCqP1yz2RvKoNpQxtTsSLJ1Xfyp+
         W0ShYhQxRf0w/IEZWlu3i8oZwlwsCYnm7aG+mJD0mQq0CvSjPhc2+R/HSp/uWtAI6iAS
         Y7MiXe+pZoBI7K9Jvy1JrPDVsI26wUtU0vt5Fo84ylL7IZM62Jcs44H5nQoKCB1k+aTD
         n0NtDhgNT1XiVBbu3ZV8u2EO65dwtEBs7dTQmLLv/dmjsWsUa0p4yDCYMQF+k1FgoG/L
         Sk+g==
X-Gm-Message-State: AOAM532KkiLfLBoFodFtMaBEsAQsFkULqk4mqHPFyyEsykr/ZCSi3JjA
        UpG73PmMFxq/v2ePj3xigZCx2A1QJYoA1A==
X-Google-Smtp-Source: ABdhPJxVc2vhvI5h0FO/JeDgCmWg4vTZznYegG1YHfJHRgl8ND5qhMbHsLzo3nSQKZ8yBbqGa2/Vjg==
X-Received: by 2002:a17:90a:d684:: with SMTP id x4mr2581720pju.244.1637095266325;
        Tue, 16 Nov 2021 12:41:06 -0800 (PST)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id lp12sm3652359pjb.24.2021.11.16.12.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 12:41:05 -0800 (PST)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v2 09/10] x86 UEFI: Improve Boot Speed
Date:   Tue, 16 Nov 2021 12:40:52 -0800
Message-Id: <20211116204053.220523-10-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116204053.220523-1-zxwang42@gmail.com>
References: <20211116204053.220523-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zxwang42@gmail.com>

The previous runner script uses `startup.nsh` to specify the EFI
binaries. When a UEFI firmware sees this script, it waits 5 seconds for
user input before executing the script.

To remove this 5-second waiting, this commit drops the `startup.nsh`
script, and renames test case binaries as UEFI's default binary filename
`EFI/BOOT/BOOTX64.EFI`. This does not trigger the 5-second waiting.

This commit only fix the boot speed for x86/efi/run script. The
run-tests.sh will be fixed by the follow-up patch.

Signed-off-by: Zixuan Wang <zxwang42@gmail.com>
---
 x86/efi/run | 30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/x86/efi/run b/x86/efi/run
index e6486ed..a888979 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -30,32 +30,16 @@ fi
 shift 1
 
 # Prepare EFI boot file system
-#   - Copy .efi file to host dir $EFI_TEST/$EFI_CASE/
+#   - Copy .efi file to host dir $EFI_TEST/$EFI_CASE/EFI/BOOT/BOOTX64.EFI
 #     This host dir will be loaded by QEMU as a FAT32 image
-#   - Make UEFI startup script that runs the .efi on boot
-mkdir -p "$EFI_TEST/$EFI_CASE/"
-if [ $EFI_CASE != "_NO_FILE_4Uhere_" ]; then
-  cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
-else
-  touch "$EFI_TEST/$EFI_CASE/$EFI_CASE.efi"
-fi
+#   - UEFI firmware by default loads the file EFI/BOOT/BOOTX64.EFI
+: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE/EFI/BOOT"}"
+: "${EFI_CASE_BINARY:="$EFI_CASE_DIR/BOOTX64.EFI"}"
 
-pushd "$EFI_TEST/$EFI_CASE" || exit 2
-# 'startup.nsh' is the default script executed by UEFI on boot
-# Use this script to run the test binary automatically
-if [ $EFI_CASE != "_NO_FILE_4Uhere_" ]; then
-  cat << EOF >startup.nsh
-@echo -off
-fs0:
-"$EFI_CASE.efi"
-EOF
-else
-  cat << EOF >startup.nsh
-@echo -off
-reset -s
-EOF
+mkdir -p "$EFI_CASE_DIR"
+if [ "$EFI_CASE" != "_NO_FILE_4Uhere_" ]; then
+	cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
 fi
-popd || exit 2
 
 # Run test case with 256MiB QEMU memory. QEMU default memory size is 128MiB.
 # After UEFI boot up and we call `LibMemoryMap()`, the largest consecutive
-- 
2.33.0


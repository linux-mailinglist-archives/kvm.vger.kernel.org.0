Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464DD453B1D
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 21:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhKPUoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 15:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhKPUoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 15:44:03 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B37C061746
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:41:06 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id np3so417031pjb.4
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CZSv2V270ivGkUHWP211rK4YqDvBcOoVBaR6NUvkFKw=;
        b=KAXZ5frOmF6X9a2i4U6lAVxmeG6YCqG/g/9QOqiHjAP0aZiv0jwBdEzeya6NB2YLKU
         KOegrHDW06FCaRbFnWzrEGS+qHqFfr++tONXapwNwn3IWtaWGbI/KpjOCTMXMzfw+Fgq
         FTWU2Hi3YxwmGcW97hasS+fn1PVYyVFv6vIDqxQDgGvaIdoCCOZ0XdVWXM+XL1FtNJDY
         eaF4iPSWjG/0mU5nnSNliAoSyvE5b745TJETuKys3e1Ljou3NfcEJrh81NLsQ9wwjkRe
         AvyNQZZlYd9c3CTpqIkiG60HF8+r5tohD8H4FcxX2GCOzhYJnXM4p7XQN4a0LmyON8kP
         u9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CZSv2V270ivGkUHWP211rK4YqDvBcOoVBaR6NUvkFKw=;
        b=W8PQPZO682oW6Kk2KnQB5De1L/pDlfrPBiV6/XlzOGGKhxoY25HKWlJJwx7rFfUxn2
         gkSuLHKvFNSF9EQ9X70UYx3V1sXvFtOkmMWRmnAzWh3QdwuIok8k1xD9dEvkNlppoVbn
         lp3p4rPsPUnNhDsjf81B17szHqwUwIiwwWGz1CrCuHZRnwO30kBRxpHbfu6EmU6QPjnA
         PSxwPnoYl/AuYTslMzHtE5KV+bpMr5NSbmQlC5gSwqnm2I0/uZSDT83DipSkQCFqPQPt
         sGCmuYLy9iJrLA9oDzVnQ7CeTP2PuJN1cSw2eY3AL4A4nDOzdlwtDy+fJLprblXBeeGq
         EOBw==
X-Gm-Message-State: AOAM531+JG/j0IkxkgAjRG+2H7KQ0wqruWOC/ABKxiweNQHcfgPpUiDm
        OaRgfqH2TTT3t2bjorNUMcuKlGC8jOt6MQ==
X-Google-Smtp-Source: ABdhPJwy+j2ItvqeIxNm+I0DHkuIP700MO2sumnTv7tnxWFmQlRTMC72mfYhJ6fAukGCDocxUi6Rdw==
X-Received: by 2002:a17:90b:1d09:: with SMTP id on9mr2277126pjb.191.1637095265172;
        Tue, 16 Nov 2021 12:41:05 -0800 (PST)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id lp12sm3652359pjb.24.2021.11.16.12.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 12:41:04 -0800 (PST)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v2 08/10] x86 UEFI: Make run_tests.sh (mostly) work under UEFI
Date:   Tue, 16 Nov 2021 12:40:51 -0800
Message-Id: <20211116204053.220523-9-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116204053.220523-1-zxwang42@gmail.com>
References: <20211116204053.220523-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Orr <marcorr@google.com>

Make several fixes so that run_tests.sh can run the test cases when
the repo is configured to run under UEFI. Specifically:
1. The scripts are enlighted to run the .efi test cases rather than the
.flat test cases.
2. The scripts are enlighted to run an empty file, _NO_FILE_4Uhere_,
which is used to sanity check QEMU and QEMU flags.
3. The scripts are updated to always run with `-smp 1`, since SMP is not
yet supported under UEFI.

Notably, QEMU's `-append` flag still does not work. This will need to be
fixed in future commits. For now, test cases that use `-append` are
marked `SKIP`.

Signed-off-by: Marc Orr <marcorr@google.com>
---
 scripts/runtime.bash | 14 ++++++++++++--
 x86/efi/run          | 24 ++++++++++++++++++++----
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 132389c..228a207 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -82,6 +82,10 @@ function run()
     local accel="$8"
     local timeout="${9:-$TIMEOUT}" # unittests.cfg overrides the default
 
+    if [ "${TARGET_EFI}" == "y" ]; then
+        kernel=$(basename $kernel .flat)
+    fi
+
     if [ -z "$testname" ]; then
         return
     fi
@@ -127,8 +131,14 @@ function run()
     fi
 
     last_line=$(premature_failure > >(tail -1)) && {
-        print_result "SKIP" $testname "" "$last_line"
-        return 77
+        skip=true
+        if [ "${TARGET_EFI}" == "y" ] && [[ "${last_line}" =~ "Reset" ]]; then
+            skip=false
+        fi
+        if [ ${skip} == true ]; then
+            print_result "SKIP" $testname "" "$last_line"
+            return 77
+        fi
     }
 
     cmdline=$(get_cmdline $kernel)
diff --git a/x86/efi/run b/x86/efi/run
index aacc691..e6486ed 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -34,16 +34,27 @@ shift 1
 #     This host dir will be loaded by QEMU as a FAT32 image
 #   - Make UEFI startup script that runs the .efi on boot
 mkdir -p "$EFI_TEST/$EFI_CASE/"
-cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
+if [ $EFI_CASE != "_NO_FILE_4Uhere_" ]; then
+  cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
+else
+  touch "$EFI_TEST/$EFI_CASE/$EFI_CASE.efi"
+fi
 
 pushd "$EFI_TEST/$EFI_CASE" || exit 2
 # 'startup.nsh' is the default script executed by UEFI on boot
 # Use this script to run the test binary automatically
-cat << EOF >startup.nsh
+if [ $EFI_CASE != "_NO_FILE_4Uhere_" ]; then
+  cat << EOF >startup.nsh
 @echo -off
 fs0:
 "$EFI_CASE.efi"
 EOF
+else
+  cat << EOF >startup.nsh
+@echo -off
+reset -s
+EOF
+fi
 popd || exit 2
 
 # Run test case with 256MiB QEMU memory. QEMU default memory size is 128MiB.
@@ -52,11 +63,16 @@ popd || exit 2
 # run in UEFI, some test cases, e.g. `x86/pmu.c`, require more free memory. A
 # simple fix is to increase the QEMU default memory size to 256MiB so that
 # UEFI's largest allocatable memory region is large enough.
+#
+# Also, pass in an EFI-specific smp count (i.e., `-smp 1`) as the last argument
+# to x86/run. This `smp` flag overrides any previous `smp` flags (e.g.,
+# `-smp 4`). This is necessary because KVM-Unit-Tests do not currently support
+# SMP under UEFI. This last flag should be removed when this issue is resolved.
 "$TEST_DIR/run" \
 	-drive file="$EFI_UEFI",format=raw,if=pflash,readonly=on \
 	-drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
 	-net none \
 	-nographic \
-	-smp "$EFI_SMP" \
 	-m 256 \
-	"$@"
+	"$@" \
+	-smp "$EFI_SMP"
-- 
2.33.0


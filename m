Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC53D440D4D
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 06:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhJaF7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 01:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhJaF7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Oct 2021 01:59:19 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FCFC061766
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 22:56:48 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id lx5-20020a17090b4b0500b001a262880e99so10228173pjb.5
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 22:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Sq10DMKJ5WN+LTaoM/Zmnq+qjjXucA5gBS0UWruO3o=;
        b=Rmxz/XXDLVdgVSnWj2tOR8C+5VMDhvXcRt4a2j4Wr+nUkj0ilBNUje1Ryote+6Yw4j
         R7BOMyvy7i21bnYRKnbfvimoY/rITiKe9f9pGhrYyAOqyR+gr5W3ocTqucmx885tHI7j
         Gu2NLBfUr0K7XmudJtawsvxPnFJ4tEHWVL7RMD9Jtycq7+yUGM7ZnLoLQtqX9Vrr6ir2
         +LXdPvkY7WjUY64vfwxFcc8PxsEAy2tKNeKIokhos/2+sDHMHov3eeeaPl4CmKH8lhTa
         iyDLsOO8768rOTf8uOhIn/dcFxedAs5SNvs9avZNX4wZxtiVbyaEnEXObdUxYVbOs9/h
         45XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Sq10DMKJ5WN+LTaoM/Zmnq+qjjXucA5gBS0UWruO3o=;
        b=1PWplWxAHdx5mrZSItxIKO1ApKSXB3QR14oJPoeM9ZqZ71s2rbC283guo07PWzQ+bq
         pojSi7BWcsmlkOnNKBk6ahsosSybC/rTQvbKFuNaYF0GMFy8p2WtbEL58ef50A0SjamJ
         PiZfSN5GqB8vm/hu7skKJgv0vsOgwTHxPmb+l3p+xrM8Svf6jOEZVu+Rk0GUMvAjgINc
         K/KJMSjuzZd5Z2+o2mCsiNTlLOR92ms4efrZXjfHl4OIscf7eV67lLAEYYPDY7sq0rKX
         CkETakLqrWCZm8bFZYCNgJJlnQtsxZhER39zNH1fD3IbRVyaNDnKI5OEeeClU84UTcAk
         HlUw==
X-Gm-Message-State: AOAM532TzQonFwxzXiSNHNcBphQ0qfk+4LrrwdOM+tbp2g7lXFqwl2bQ
        4QCCNNYKETtopBEhsjYZDX/UADmveUnEHQ==
X-Google-Smtp-Source: ABdhPJxZJF0i6bKHNRyqpQEFxhyzm9joPXcheHSYeVf2xiyTSWN07QvP414UGfXH89ulgQxGv/4IqQ==
X-Received: by 2002:a17:902:758b:b0:13e:8b1:e49f with SMTP id j11-20020a170902758b00b0013e08b1e49fmr18463874pll.6.1635659807249;
        Sat, 30 Oct 2021 22:56:47 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id j19sm11403179pfj.127.2021.10.30.22.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 22:56:46 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v1 7/7] x86 UEFI: Make run_tests.sh (mostly) work under UEFI
Date:   Sat, 30 Oct 2021 22:56:34 -0700
Message-Id: <20211031055634.894263-8-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211031055634.894263-1-zxwang42@gmail.com>
References: <20211031055634.894263-1-zxwang42@gmail.com>
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
 scripts/common.bash  |  4 ++--
 scripts/runtime.bash | 15 +++++++++++++--
 x86/efi/run          | 24 ++++++++++++++++++++----
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index 6f45843..c42df95 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -26,7 +26,7 @@ function for_each_unittest()
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
 			rematch=${BASH_REMATCH[1]}
 			if [ -n "${testname}" ]; then
-				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout" "$(running_under_efi)"
 			fi
 			testname=$rematch
 			smp=1
@@ -56,7 +56,7 @@ function for_each_unittest()
 		fi
 	done
 	if [ -n "${testname}" ]; then
-		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout" "$(running_under_efi)"
 	fi
 	exec {fd}<&-
 }
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 132389c..9c89a74 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -81,6 +81,11 @@ function run()
     local check="${CHECK:-$7}"
     local accel="$8"
     local timeout="${9:-$TIMEOUT}" # unittests.cfg overrides the default
+    local running_under_efi="${10}"
+
+    if [ "$running_under_efi" ]; then
+        kernel=$(basename $kernel .flat)
+    fi
 
     if [ -z "$testname" ]; then
         return
@@ -127,8 +132,14 @@ function run()
     fi
 
     last_line=$(premature_failure > >(tail -1)) && {
-        print_result "SKIP" $testname "" "$last_line"
-        return 77
+        skip=true
+        if [ "${running_under_efi}" ] && [[ "${last_line}" =~ "Reset" ]]; then
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


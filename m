Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77DC418D20B
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 15:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgCTO5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 10:57:13 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:51186 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727133AbgCTO5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 10:57:13 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 98562412E8;
        Fri, 20 Mar 2020 14:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1584716228; x=1586530629; bh=2LqXF6cWF1GqPJAELyZUl1CN72DnSQewD/3
        mfY9rMNI=; b=CwKNXBfyTI3XRY/ITExz8QN0xs5614wsaJ0fCKtwHU3OIOqJJfp
        vjODA2Qyh9BAfjVzHGKH+WThoWSOWe5LF2t76v9ZOIj11q4mVjNhS0cgEl10l1Hp
        HA7Mm8EM4/JTQ7FKAPIYGe86F6WL/otQJZpm9g5HazzFU1A5kRHgj4Nc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id e8-io4Vuobvp; Fri, 20 Mar 2020 17:57:08 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 22B42412EB;
        Fri, 20 Mar 2020 17:57:08 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 20
 Mar 2020 17:57:08 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [kvm-unit-tests PATCH 2/2] README: Document steps to run the tests on macOS
Date:   Fri, 20 Mar 2020 17:55:41 +0300
Message-ID: <20200320145541.38578-3-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320145541.38578-1-r.bolshakov@yadro.com>
References: <20200320145541.38578-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While at it, mention that hvf is a valid accel parameter.

Cc: Cameron Esfahani <dirty@apple.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 README.macOS.md | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 README.md       |  6 ++++--
 2 files changed, 51 insertions(+), 2 deletions(-)
 create mode 100644 README.macOS.md

diff --git a/README.macOS.md b/README.macOS.md
new file mode 100644
index 0000000..de46d5f
--- /dev/null
+++ b/README.macOS.md
@@ -0,0 +1,47 @@
+# kvm-unit-tests on macOS
+
+Cross-compiler with ELF support is required for build of kvm-unit-tests on
+macOS.
+
+## Building cross-compiler from source
+
+A cross-compiler toolchain can be built from source using crosstool-ng. The
+latest released version of
+[crosstool-ng](https://github.com/crosstool-ng/crosstool-ng) can be installed
+using [homebrew](https://brew.sh)
+```
+$ brew install crosstool-ng
+```
+
+A case-sensitive APFS/HFS+ volume has to be created using Disk Utility as a
+build and installation directory for the cross-compiler. Please [see Apple
+documentation](https://support.apple.com/guide/disk-utility/dsku19ed921c/mac)
+for details.
+
+Assuming the case-sensitive volume is named /Volumes/BuildTools, the
+cross-compiler can be built and installed there:
+```
+$ X_BUILD_DIR=/Volumes/BuildTools/ct-ng-build
+$ X_INSTALL_DIR=/Volumes/BuildTools/x-tools
+$ mkdir $X_BUILD_DIR
+$ ct-ng -C $X_BUILD_DIR x86_64-unknown-linux-gnu
+$ ct-ng -C $X_BUILD_DIR build CT_PREFIX=$X_INSTALL_DIR
+```
+
+Once compiled, the cross-compiler can be used to build the tests:
+```
+$ ./configure --cross-prefix=$X_INSTALL_DIR/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-
+$ make
+```
+
+## Pre-built cross-compiler
+
+x86_64-elf-gcc package in Homebrew provides pre-built cross-compiler but it
+fails to compile kvm-unit-tests.
+
+## Running the tests
+
+GNU coreutils should be installed prior to running the tests: 
+```
+$ brew install coreutils
+```
diff --git a/README.md b/README.md
index 396fbf8..48be206 100644
--- a/README.md
+++ b/README.md
@@ -15,6 +15,8 @@ To create the test images do:
 
 in this directory.  Test images are created in ./ARCH/\*.flat
 
+NOTE: GCC cross-compiler is required for [build on macOS](README.macOS.md).
+
 ## Standalone tests
 
 The tests can be built as standalone.  To create and use standalone tests do:
@@ -47,7 +49,7 @@ environment variable:
 
     QEMU=/tmp/qemu/x86_64-softmmu/qemu-system-x86_64 ./x86-run ./x86/msr.flat
 
-To select an accelerator, for example "kvm" or "tcg", specify the
+To select an accelerator, for example "kvm", "hvf" or "tcg", specify the
 ACCEL=name environment variable:
 
     ACCEL=kvm ./x86-run ./x86/msr.flat
@@ -78,7 +80,7 @@ which can then be accessed in the usual ways, e.g. VAL = getenv("KEY").
 Any key=val strings can be passed, but some have reserved meanings in
 the framework.  The list of reserved environment variables is below
 
-    QEMU_ACCEL                   either kvm or tcg
+    QEMU_ACCEL                   either kvm, hvf or tcg
     QEMU_VERSION_STRING          string of the form `qemu -h | head -1`
     KERNEL_VERSION_STRING        string of the form `uname -r`
 
-- 
2.24.1


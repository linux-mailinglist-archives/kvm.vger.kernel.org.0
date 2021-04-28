Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD7436DFB5
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 21:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240086AbhD1TjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 15:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241726AbhD1Ti4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 15:38:56 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08F8C0613ED
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 12:38:04 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id k11-20020a62840b0000b029024135614a60so23914087pfd.18
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 12:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3EmL6xt5jVjqc/fFRGG9Bp/HY5j+2f9o1zD7J8DnnPw=;
        b=qojwyUnMOEKFrRAcoKNQv8n9HI0z+aYcwAplArllOvARz6euC5nXNvMP3+XTjqrcuq
         27iyRNgjq7qlyk8BgfqzP+q/bPr4jr7bPbIFOboYm2DK2DViCz9IgZO02YQcBAjmgel7
         LfkZytiSEZgfQZE2lG/0d3YqOKenqkidls0+i+KeEhqqrAkiHzY1FGQib/wb6bMGhpLC
         ggG0+bb0D3uy/d/sAGEhmuM6kW/F/n5phGtR6VG9kFmXv+RTV8Z/lXrev6QZXNEaeuuF
         FSyn+4mmB/ug/UJXVXOt2t+AUXRjC8OQmqDiBEC30XkjkcsO+gdvbaD1+CHgH+8vqOGS
         vn2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3EmL6xt5jVjqc/fFRGG9Bp/HY5j+2f9o1zD7J8DnnPw=;
        b=UnEB2WoJIRGSVaGlKFk37j1R3ZlJ6BP3GrlCOPtd0xjtG+I1GrqZRZhiiNwkEX2vVP
         pa9S0yXueMbj4h4hq8Kuf60ywjJNIErzXoU9bbLS9bIBHGOn1y4F9qwPWV4MGw0wNkn3
         oIzyAuR5IfKt0FK9ACYbaTXk7kj3BtUj4Rt7NkqNjmPIEnscCpauKAQWerdfI3zetB5Z
         HiR5nhvnn57IIzYWVELzUFaSV1pIVEy3dTQC6mhKHtnJNEL0QJtcEwRY0+R8lM68n/JF
         zWk/WSNlOy37maeIfHXN0NVuikFaKv1oo/WomEgVoWpyX55lTNSAtHv2li7OZUrYBcNw
         yMXQ==
X-Gm-Message-State: AOAM533/YYCYMZqy56Ee4BNd8am/jCNXJSdPbxyYEqxFWRjpe2HcPCY1
        7zXT7J/osSYnp7iowMZYcUpapd/idVZpaw==
X-Google-Smtp-Source: ABdhPJwxcktVdD/XvgMx0K4EkvWN9+2vn0sfN6x1/yc8vpWGv23+caxbU3DuBq9wNvwPZ95Khs2Y0ysoEKh68w==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:8d8b:b029:ed:64bb:db81 with SMTP
 id v11-20020a1709028d8bb02900ed64bbdb81mr8252681plo.53.1619638684396; Wed, 28
 Apr 2021 12:38:04 -0700 (PDT)
Date:   Wed, 28 Apr 2021 12:37:51 -0700
In-Reply-To: <20210428193756.2110517-1-ricarkol@google.com>
Message-Id: <20210428193756.2110517-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20210428193756.2110517-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 1/6] KVM: selftests: Add kernel headers sync check
From:   Ricardo Koller <ricarkol@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a script that checks if header files under /tools match their
original version in the kernel. Perform the check at the end of the
make, so warnings are shown after all tests are built.  Note that
the build is _not_ aborted if any diff check fails.

The list of header files to check was obtained from the union of the
output of these (at tools/testing/selftests/kvm):

  CFLAGS="-H" make ARCH=x86_64 2>&1 | grep '.h$' | grep 'tools'
  CFLAGS="-H" make ARCH=arm64 CC=aarch64-linux-gnu-gcc-10 2>&1 | grep '.h$' | grep 'tools'

and then by manually removing the header files that were updated on the
tools/ side but not on the kernel side. There is no point in checking
for these as their changes will not be synced back to the kernel. Here
are the removed headers and the first commit that made them drift apart
from their original copies:

  tools/include/linux/kernel.h
  d0761e37fe3 perf tools: Uninline scnprintf() and vscnprint()

  tools/include/linux/list.h
  5602ea09c19 tools include: Add compiler.h to list.h

  tools/include/linux/poison.h
  6ae8eefc6c8 tools include: Do not use poison with C++

  tools/include/linux/types.h
  70ba6b8f975 tools include: add __aligned_u64 to types.h

  tools/include/asm-generic/bitsperlong.h
  2a00f026a15 tools: Fix up BITS_PER_LONG setting

Based on tools/perf/check-headers.sh.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/Makefile         |  2 +
 tools/testing/selftests/kvm/check-headers.sh | 55 ++++++++++++++++++++
 2 files changed, 57 insertions(+)
 create mode 100755 tools/testing/selftests/kvm/check-headers.sh

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ea5c42841307..69dc4f5e9ee3 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -147,6 +147,8 @@ $(OUTPUT)/libkvm.a: $(LIBKVM_OBJS)
 
 x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
 all: $(STATIC_LIBS)
+	@./check-headers.sh
+
 $(TEST_GEN_PROGS): $(STATIC_LIBS)
 
 cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
diff --git a/tools/testing/selftests/kvm/check-headers.sh b/tools/testing/selftests/kvm/check-headers.sh
new file mode 100755
index 000000000000..c21a69b52bcd
--- /dev/null
+++ b/tools/testing/selftests/kvm/check-headers.sh
@@ -0,0 +1,55 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# Adapted from tools/perf/check-headers.sh
+
+FILES='
+arch/x86/include/asm/msr-index.h
+include/linux/bits.h
+include/linux/const.h
+include/uapi/asm-generic/bitsperlong.h
+include/uapi/linux/const.h
+include/vdso/bits.h
+include/vdso/const.h
+'
+
+check_2 () {
+  file1=$1
+  file2=$2
+
+  shift
+  shift
+
+  cmd="diff $* $file1 $file2 > /dev/null"
+
+  test -f $file2 && {
+    eval $cmd || {
+      echo "Warning: Kernel header at '$file1' differs from latest version at '$file2'" >&2
+      echo diff -u $file1 $file2
+    }
+  }
+}
+
+check () {
+  file=$1
+
+  shift
+
+  check_2 tools/$file $file $*
+}
+
+# Check if we are at the right place (we have the kernel headers)
+# (tools/testing/selftests/kvm/../../../../include)
+test -d ../../../../include || exit 0
+
+cd ../../../..
+
+# simple diff check
+for i in $FILES; do
+  check $i -B
+done
+
+# diff with extra ignore lines
+check include/linux/build_bug.h       '-I "^#\(ifndef\|endif\)\( \/\/\)* static_assert$"'
+
+cd tools/testing/selftests/kvm
-- 
2.31.1.498.g6c1eba8ee3d-goog


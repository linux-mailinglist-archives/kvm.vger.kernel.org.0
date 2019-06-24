Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13BBA50E47
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 16:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbfFXOeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 10:34:02 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:46212 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729894AbfFXOdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 10:33:55 -0400
Received: by mail-qk1-f202.google.com with SMTP id 18so16365135qkl.13
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2019 07:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=N5aQVQiWWtXi9gCv0ztW+dfvhd60giz7b6IoZ6u0OIQ=;
        b=qjhPznbYLqEoUuOd+SbruTmLg2XmfpstnWtNL0BmQkS/9+yQT+WCgWslxOFvIMH1pv
         mALN6TNaetS33pt/RVz6EBDIEWN2quqA6jv67UFd7koLos1e133OMWu359ZPg0J6bPcr
         0XWlGuBxH86U+t+14QRd+rvD4clAF7jsa1nnvo0JS1ZiAdQXZxeWkV8d/rYp0KzGCh88
         IiYVBvmMbwt07ocU9yE6vY4JutitBKtGPSxtSdK50DrOSaBmfZV7Ob9XJeo2Bom5V336
         MrXYPuP6NQaYbAzK3Of68rTmuGoOGsh3GrYLnYHFg0fALTXz/unOR+Jpt7LYdYsFe3Zd
         cEhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=N5aQVQiWWtXi9gCv0ztW+dfvhd60giz7b6IoZ6u0OIQ=;
        b=fVeKZgVYRqihhuH+r2UzzoXld46JEANRzDaEnD3VnpYDF1nHjyRFWLtN13U5PQY6Jq
         a8HBlDyQRxGvGK4gSuD2nctxt5lM9nTlmJO6r5HyaWh7CUlDxUIoCiSLKCFWxBei94TF
         76Au9e0QYozyTHMUvyXrRX/Re0Vq2ojLQ6Vh6Mq6BArxni9mnBabd5LOtmaJIMVeFbD6
         1fxmMmPl4vMCaWLl/9UqkeO2BmIq67JLciqcFYVtusTrJUvIMeFN2OoRIA+TL7HTK4ZP
         lTTat2C8sVunJ2ZqxIzdusnrIERbUlI8WGYIxv3B4LSlgyp9Y3PKuAxR+ZuCOk8C8wrK
         +VaA==
X-Gm-Message-State: APjAAAVllWzScM0BC4mCvAKZXIdwNFy9u2M80O1m4F42hvpir1CCz4Jf
        PbYAkwEACQsfhKudR+HCxC420AUT1ACGkW3q
X-Google-Smtp-Source: APXvYqyNi91IprVlCjHeOaEl/XhVal8I6zy0NHm57SSOUiamYjJ/eflME47kK7EATSbEXYL1nBd99divk4S0n0PC
X-Received: by 2002:ae9:e8ce:: with SMTP id a197mr16822243qkg.484.1561386833898;
 Mon, 24 Jun 2019 07:33:53 -0700 (PDT)
Date:   Mon, 24 Jun 2019 16:33:00 +0200
In-Reply-To: <cover.1561386715.git.andreyknvl@google.com>
Message-Id: <0999c80cd639b78ae27c0674069d552833227564.1561386715.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1561386715.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v18 15/15] selftests, arm64: add a selftest for passing tagged
 pointers to kernel
From:   Andrey Konovalov <andreyknvl@google.com>
To:     linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-media@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Christian Koenig <Christian.Koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Khalid Aziz <khalid.aziz@oracle.com>, enh <enh@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christoph Hellwig <hch@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch is a part of a series that extends kernel ABI to allow to pass
tagged user pointers (with the top byte set to something else other than
0x00) as syscall arguments.

This patch adds a simple test, that calls the uname syscall with a
tagged user pointer as an argument. Without the kernel accepting tagged
user pointers the test fails with EFAULT.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 tools/testing/selftests/arm64/.gitignore      |  1 +
 tools/testing/selftests/arm64/Makefile        | 11 +++++++
 .../testing/selftests/arm64/run_tags_test.sh  | 12 ++++++++
 tools/testing/selftests/arm64/tags_test.c     | 29 +++++++++++++++++++
 4 files changed, 53 insertions(+)
 create mode 100644 tools/testing/selftests/arm64/.gitignore
 create mode 100644 tools/testing/selftests/arm64/Makefile
 create mode 100755 tools/testing/selftests/arm64/run_tags_test.sh
 create mode 100644 tools/testing/selftests/arm64/tags_test.c

diff --git a/tools/testing/selftests/arm64/.gitignore b/tools/testing/selftests/arm64/.gitignore
new file mode 100644
index 000000000000..e8fae8d61ed6
--- /dev/null
+++ b/tools/testing/selftests/arm64/.gitignore
@@ -0,0 +1 @@
+tags_test
diff --git a/tools/testing/selftests/arm64/Makefile b/tools/testing/selftests/arm64/Makefile
new file mode 100644
index 000000000000..a61b2e743e99
--- /dev/null
+++ b/tools/testing/selftests/arm64/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# ARCH can be overridden by the user for cross compiling
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+
+ifneq (,$(filter $(ARCH),aarch64 arm64))
+TEST_GEN_PROGS := tags_test
+TEST_PROGS := run_tags_test.sh
+endif
+
+include ../lib.mk
diff --git a/tools/testing/selftests/arm64/run_tags_test.sh b/tools/testing/selftests/arm64/run_tags_test.sh
new file mode 100755
index 000000000000..745f11379930
--- /dev/null
+++ b/tools/testing/selftests/arm64/run_tags_test.sh
@@ -0,0 +1,12 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+echo "--------------------"
+echo "running tags test"
+echo "--------------------"
+./tags_test
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+else
+	echo "[PASS]"
+fi
diff --git a/tools/testing/selftests/arm64/tags_test.c b/tools/testing/selftests/arm64/tags_test.c
new file mode 100644
index 000000000000..22a1b266e373
--- /dev/null
+++ b/tools/testing/selftests/arm64/tags_test.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <sys/prctl.h>
+#include <sys/utsname.h>
+
+#define SHIFT_TAG(tag)		((uint64_t)(tag) << 56)
+#define SET_TAG(ptr, tag)	(((uint64_t)(ptr) & ~SHIFT_TAG(0xff)) | \
+					SHIFT_TAG(tag))
+
+int main(void)
+{
+	static int tbi_enabled = 0;
+	struct utsname *ptr, *tagged_ptr;
+	int err;
+
+	if (prctl(PR_SET_TAGGED_ADDR_CTRL, PR_TAGGED_ADDR_ENABLE, 0, 0, 0) == 0)
+		tbi_enabled = 1;
+	ptr = (struct utsname *)malloc(sizeof(*ptr));
+	if (tbi_enabled)
+		tagged_ptr = (struct utsname *)SET_TAG(ptr, 0x42);
+	err = uname(tagged_ptr);
+	free(ptr);
+
+	return err;
+}
-- 
2.22.0.410.gd8fdbe21b5-goog


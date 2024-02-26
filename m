Return-Path: <kvm+bounces-9787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF620866FCD
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:03:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D243D1C25DC2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56795EE91;
	Mon, 26 Feb 2024 09:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J/7XguAy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38EF5EE8D;
	Mon, 26 Feb 2024 09:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708940374; cv=none; b=izFTKr9GPY7nCVjphtmZE2S9YY9Sspg3Cv5epSIUvh83LAV9RNnQDW2yrkFBsQTCrL5F6XVfqv3g4/oTZtHvwCqOQMC6OInvZ0XX0N2Kc2Yj8NhHt9RhqN3b7xAqrRyBIFUv7pgcgpIB3+F5sXooDn26GeiDKj/CoXOPLvcobUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708940374; c=relaxed/simple;
	bh=6xXLshEGv1+dS4Oj7TAl6ErQq+s8Er+4C8JK210EwGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TI9/wWrqMFJ27wQcW1Lx/bWVL0r1miwz9LCnJE0rn4bmKOzRbyRBWoGF76ZUXagB+MfUCikJjsaYvb8pqgdnxJuaA62poYLE0UKQ5A3L/r7Lk8R2rAg9/JDjHXLEc98s3VvV3P6bODf1mZqA9NOfLRffXuoXxFRrjTDW4UGcCiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J/7XguAy; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-29a430c3057so1251399a91.1;
        Mon, 26 Feb 2024 01:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708940372; x=1709545172; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4C3sdt0JsWbryl8xk4OG1WbSXlpSqNkR+NKIJMu9X/I=;
        b=J/7XguAycQkkAx7Q+ZResC0A7e/Wkwe51PvjpEXbPK/YuTIXrGDOUlkEYjjsmz3jce
         tChYhoN0RCphjGL/rKGwY2dWf7gjsrJuvzwIVnEgiw2gWrDo10Lscm8UkGddnkPJUYuz
         DbcxFlzbu3cbwAVmZ/SrztffYKqdpr9v4jaEbRcLLMkRBzAO7mNz1PzE729i0fKVLoh2
         RboLii5YVy9rG3+z4kjh7yyFaWXnSgz2mQezWO9wMq9MfkF5zhtyIsTFUGRWj3MLHOcV
         I/o1guiEr+ZfMGIXAfuZqT+sF6BZaXkrI/e6lqqntBKtUb97SeYgaQzl9emgClXIxw3m
         A84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708940372; x=1709545172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4C3sdt0JsWbryl8xk4OG1WbSXlpSqNkR+NKIJMu9X/I=;
        b=cz0R3TwIFxaLfu3+ik2ZlK52vA++TpTbw4c9+USc+bj38kuwmGbA9vUM42ol5iUiLp
         1KI6dlJszj1fRsE5FaUbixW2w5WVm4uE9pCLaVzN2eWCsiHop9ogNttkhlUqgVZBfC0T
         6ulnCEPxR8GOA6yfQCd+MiLhEkSRNn5y92/QqyWzJhOuFpoGRbRgQp6qNKWFvLNo3g7G
         sHbvMyiWcy9KtwtGogSSGtpJVjlELRzR1K7d040btEXkYfm4y0z8dCrHXRajnTKQ3Fdq
         HU9CYEleFBfhpV7LHFoYvfgoCLGLXPef06KBkp7dylS0BiRkbpLa+wgXc/CkM4yYBYsa
         r7hQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQJklkgp8jqoIRVkTZgVIB34Coxo/sNISyN5GPkzGRa2I7B5O0u/ubd1rzJ0RJBcekAVZGM7WwUD3WzYAbMaT/StYHySMTOvTqrVXYMW4fNsSMuedgJdcgFRK/+VfvLw==
X-Gm-Message-State: AOJu0YyMgDX9xFD6R0ZYHPMdaPk3XAuV6hz4V4Kbjpqo118Lk2vIUQc8
	93d3MDhxhE7U85fyKWmgB7287XBHOGheLDXiyYCR5vwEbt/WPy9CQIbl90CG
X-Google-Smtp-Source: AGHT+IFXLyYXdyP2UAckhzh+BDfRTP5s86iCzOS+vBsDRJEkc8Q8vEMkpMw7UMDXxznIh8HlHNlNaA==
X-Received: by 2002:a17:90a:db03:b0:29a:59a7:951d with SMTP id g3-20020a17090adb0300b0029a59a7951dmr3903944pjv.5.1708940372072;
        Mon, 26 Feb 2024 01:39:32 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id pa3-20020a17090b264300b0029929ec25fesm6036782pjb.27.2024.02.26.01.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 01:39:31 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 7/7] common: add memory dirtying vs migration test
Date: Mon, 26 Feb 2024 19:38:32 +1000
Message-ID: <20240226093832.1468383-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226093832.1468383-1-npiggin@gmail.com>
References: <20240226093832.1468383-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This test stores to a bunch of pages and verifies previous stores,
while being continually migrated. This can fail due to a QEMU TCG
physical memory dirty bitmap bug.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 common/memory-verify.c  | 48 +++++++++++++++++++++++++++++++++++++++++
 powerpc/Makefile.common |  1 +
 powerpc/memory-verify.c |  1 +
 powerpc/unittests.cfg   |  7 ++++++
 s390x/Makefile          |  1 +
 s390x/memory-verify.c   |  1 +
 s390x/unittests.cfg     |  6 ++++++
 7 files changed, 65 insertions(+)
 create mode 100644 common/memory-verify.c
 create mode 120000 powerpc/memory-verify.c
 create mode 120000 s390x/memory-verify.c

diff --git a/common/memory-verify.c b/common/memory-verify.c
new file mode 100644
index 000000000..7c4ec087b
--- /dev/null
+++ b/common/memory-verify.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Simple memory verification test, used to exercise dirty memory migration.
+ *
+ */
+#include <libcflat.h>
+#include <migrate.h>
+#include <alloc.h>
+#include <asm/page.h>
+#include <asm/time.h>
+
+#define NR_PAGES 32
+
+int main(int argc, char **argv)
+{
+	void *mem = malloc(NR_PAGES*PAGE_SIZE);
+	bool success = true;
+	uint64_t ms;
+	long i;
+
+	report_prefix_push("memory");
+
+	memset(mem, 0, NR_PAGES*PAGE_SIZE);
+
+	migrate_begin_continuous();
+	ms = get_clock_ms();
+	i = 0;
+	do {
+		int j;
+
+		for (j = 0; j < NR_PAGES*PAGE_SIZE; j += PAGE_SIZE) {
+			if (*(volatile long *)(mem + j) != i) {
+				success = false;
+				goto out;
+			}
+			*(volatile long *)(mem + j) = i + 1;
+		}
+		i++;
+	} while (get_clock_ms() - ms < 5000);
+out:
+	migrate_end_continuous();
+
+	report(success, "memory verification stress test");
+
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index da4a7bbb8..1e181da69 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -7,6 +7,7 @@
 tests-common = \
 	$(TEST_DIR)/selftest.elf \
 	$(TEST_DIR)/selftest-migration.elf \
+	$(TEST_DIR)/memory-verify.elf \
 	$(TEST_DIR)/spapr_hcall.elf \
 	$(TEST_DIR)/rtas.elf \
 	$(TEST_DIR)/emulator.elf \
diff --git a/powerpc/memory-verify.c b/powerpc/memory-verify.c
new file mode 120000
index 000000000..5985c730f
--- /dev/null
+++ b/powerpc/memory-verify.c
@@ -0,0 +1 @@
+../common/memory-verify.c
\ No newline at end of file
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 89abf2095..fadd8dde6 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -46,6 +46,13 @@ machine = pseries
 groups = selftest migration
 extra_params = -append "skip"
 
+# This fails due to a QEMU TCG bug so KVM-only until QEMU is fixed upstream
+[migration-memory]
+file = memory-verify.elf
+accel = kvm
+machine = pseries
+groups = migration
+
 [spapr_hcall]
 file = spapr_hcall.elf
 
diff --git a/s390x/Makefile b/s390x/Makefile
index 344d46d68..ddc0969f3 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -1,5 +1,6 @@
 tests = $(TEST_DIR)/selftest.elf
 tests += $(TEST_DIR)/selftest-migration.elf
+tests += $(TEST_DIR)/memory-verify.elf
 tests += $(TEST_DIR)/intercept.elf
 tests += $(TEST_DIR)/emulator.elf
 tests += $(TEST_DIR)/sieve.elf
diff --git a/s390x/memory-verify.c b/s390x/memory-verify.c
new file mode 120000
index 000000000..5985c730f
--- /dev/null
+++ b/s390x/memory-verify.c
@@ -0,0 +1 @@
+../common/memory-verify.c
\ No newline at end of file
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index f613602d3..a88fe9e79 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -33,6 +33,12 @@ file = selftest-migration.elf
 groups = selftest migration
 extra_params = -append "skip"
 
+# This fails due to a QEMU TCG bug so KVM-only until QEMU is fixed upstream
+[migration-memory]
+file = memory-verify.elf
+accel = kvm
+groups = migration
+
 [intercept]
 file = intercept.elf
 
-- 
2.42.0



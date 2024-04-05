Return-Path: <kvm+bounces-13647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE5A48997F4
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAFD81C21101
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC73115FCFD;
	Fri,  5 Apr 2024 08:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UJxDZUVN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6C415F30B
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306179; cv=none; b=j29kXF+jYD2ZWuzM5zYUsB9z8GhT/MSj4NH3sX5lV8nzytz3OfOyKCl9gzKVOE/3J9C5dJi7bkZbpJIkLTQgEpU87CrTEz5G/nzBNKPYZizq2/MCqCvHPjMuPFyUdCxc+Wv4HN66gYgGfHmv4jSW/rRRYn7T2Ch7Ph8m3MnkQCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306179; c=relaxed/simple;
	bh=Iy/mQPyENXMn2Qx+lwaTLxlqKH+lXRe7NtqOdx7WoOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKwYJHUP/ZYbRQg2G0XRaUPJ4+sPtrtNnc7NwIMl7gJgGyxyuZRAWv+Kz/z/WBfLnwGXVdrBnxzZN63erj93o8kFW6MG3slK8HZLw4K07MW4AV+Sr7bjSS3dMwN8+HtAKd/zJrG0W+bqL8x9dt/nFPODgs6uQow48krSSvKeBto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UJxDZUVN; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-36a0aed8accso2973955ab.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306176; x=1712910976; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a4a+yvoU4Zuk7XnICvMuX6mvFgH0s9YTUf1wOlK2UPA=;
        b=UJxDZUVN5/RZ8p6gnKIdZlNU6EjI8YD+2HSZSdEuNyYtSOvb9iuicAN5gDAErrVQJw
         LFI46hKoU+eH9WCoAZ1h7BYEWqZYu4sSmOeP8b6YT1tulJ4bfQL+P5R6d/2ge1/kI1oQ
         eAeCEK00PXd2Pz+ei8ONrEhzv5LYN7maGH3GSgzgtVb1bAKO55TOgGYnaKDDQ7MgmCji
         kwozgmw3CKFGHTZmHB0ZTUGbjB5LnZ/Ndj48lsuDEjmAgzsnFXRu19BSKlGrs7KWRPSM
         BhKgWJkZ4fjG94bOv8OKEi/q4ihx+hPuvSCvbCAZhjAbjCfIi8OOGHE0sqAUgZ0yDAL6
         AjrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306176; x=1712910976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a4a+yvoU4Zuk7XnICvMuX6mvFgH0s9YTUf1wOlK2UPA=;
        b=aTktP6uMqkkFD266MK2FrZ/ugsMoLo7wK0kAcS0RkDkHE7g8EqF18auBM5JxamVLfT
         Xg5eD+nKRvxa0hvR8/PP+3HB5YoRXWFVN3oca0HBm+LAYpp/4poV2Qb0Etf6sS8RZrXB
         XKWp56XFjhKpKxDANmjTdaB6DUtuwhMlmxDMQBqYr8LOB1TTxULtX3AUOJIuLFbxjAik
         HprwIOBZMoYwPtRh4ofi4BetAjYaw5kcgxOcXzJvTzfwVEonbITIGookxTSESF1SoyAb
         rahE7noDOhHF0mXUQ4W39prJto77H+HpNVGSznmDZzx6HW97TbsMiPZAXJYczD5hNVnn
         hb+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVoPo3aN6TjsbFXf8mNOXadUtBJ6wU6shlL0O+qy0BW+FwnZGyrg15Q+PDn5WkAsYhMlksqcu9sdMvrldD5DDGXZgKn
X-Gm-Message-State: AOJu0Yz5ZnOlTmeLgjDDbkj/L1TUW9As98u+oMrn7xJQjARz/iF+YSe7
	MY5kSTBjESlRWNvKvj83+0KhMjCAn6O0oTsevqEbHrVS44axvOAq
X-Google-Smtp-Source: AGHT+IEz5LeA7ioiT1AWxwaXdvckz2ey8biz8/mbdvqQ15V+h2gAHH7T4UpG9LC+O5IOKUvjAXvvXg==
X-Received: by 2002:a05:6e02:1c87:b0:368:a5be:673 with SMTP id w7-20020a056e021c8700b00368a5be0673mr827466ill.18.1712306176706;
        Fri, 05 Apr 2024 01:36:16 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:36:16 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 07/35] common: add memory dirtying vs migration test
Date: Fri,  5 Apr 2024 18:35:08 +1000
Message-ID: <20240405083539.374995-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This test stores to a bunch of pages and verifies previous stores,
while being continually migrated. Default runtime is 5 seconds.

Add this test to ppc64 and s390x builds. This can fail due to a QEMU
TCG physical memory dirty bitmap bug, so it is not enabled in unittests
for TCG yet.

The selftest-migration test time is reduced significantly because
this test

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 common/memory-verify.c      | 68 +++++++++++++++++++++++++++++++++++++
 common/selftest-migration.c |  8 ++---
 powerpc/Makefile.common     |  1 +
 powerpc/memory-verify.c     |  1 +
 powerpc/unittests.cfg       |  7 ++++
 s390x/Makefile              |  1 +
 s390x/memory-verify.c       |  1 +
 s390x/unittests.cfg         |  6 ++++
 8 files changed, 89 insertions(+), 4 deletions(-)
 create mode 100644 common/memory-verify.c
 create mode 120000 powerpc/memory-verify.c
 create mode 120000 s390x/memory-verify.c

diff --git a/common/memory-verify.c b/common/memory-verify.c
new file mode 100644
index 000000000..1cefe95dc
--- /dev/null
+++ b/common/memory-verify.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Simple memory verification test, used to exercise dirty memory migration.
+ */
+#include <libcflat.h>
+#include <migrate.h>
+#include <alloc.h>
+#include <asm/page.h>
+#include <asm/time.h>
+
+#define NR_PAGES 32
+#define SIZE (NR_PAGES * PAGE_SIZE)
+
+static unsigned time_sec = 5;
+
+static void do_getopts(int argc, char **argv)
+{
+	int i;
+
+	for (i = 0; i < argc; ++i) {
+		if (strcmp(argv[i], "-t") == 0) {
+			i++;
+			if (i == argc)
+				break;
+			time_sec = atol(argv[i]);
+		}
+	}
+
+	printf("running for %d secs\n", time_sec);
+}
+
+int main(int argc, char **argv)
+{
+	void *mem = memalign(PAGE_SIZE, SIZE);
+	bool success = true;
+	uint64_t ms;
+	long i;
+
+	do_getopts(argc, argv);
+
+	report_prefix_push("memory");
+
+	memset(mem, 0, SIZE);
+
+	migrate_begin_continuous();
+	ms = get_clock_ms();
+	i = 0;
+	do {
+		int j;
+
+		for (j = 0; j < SIZE; j += PAGE_SIZE) {
+			if (*(volatile long *)(mem + j) != i) {
+				success = false;
+				goto out;
+			}
+			*(volatile long *)(mem + j) = i + 1;
+		}
+		i++;
+	} while (get_clock_ms() - ms < time_sec * 1000);
+out:
+	migrate_end_continuous();
+
+	report(success, "memory verification stress test");
+
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/common/selftest-migration.c b/common/selftest-migration.c
index 9a9b61835..3693148aa 100644
--- a/common/selftest-migration.c
+++ b/common/selftest-migration.c
@@ -11,7 +11,7 @@
 #include <migrate.h>
 #include <asm/time.h>
 
-#define NR_MIGRATIONS 15
+#define NR_MIGRATIONS 5
 
 int main(int argc, char **argv)
 {
@@ -28,11 +28,11 @@ int main(int argc, char **argv)
 		report(true, "cooperative migration");
 
 		migrate_begin_continuous();
-		mdelay(2000);
-		migrate_end_continuous();
 		mdelay(1000);
+		migrate_end_continuous();
+		mdelay(500);
 		migrate_begin_continuous();
-		mdelay(2000);
+		mdelay(1000);
 		migrate_end_continuous();
 		report(true, "continuous migration");
 	}
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
index cae4949e8..e65217c18 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -49,6 +49,13 @@ machine = pseries
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
index faa0ce0eb..d7bdcfa91 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -44,6 +44,12 @@ file = selftest-migration.elf
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
2.43.0



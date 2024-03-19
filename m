Return-Path: <kvm+bounces-12083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E8687F8A4
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42C291F21A45
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22E2D54670;
	Tue, 19 Mar 2024 08:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IHum/wfl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD456537E5
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835203; cv=none; b=cRMMoLHFSV500lg1fthjFgGE6ZGAppdfe+VE9+I4jYYFJljZL/iHgYbaAOZP7PFsBWKRX1LihLe+MhJeOionqrHWn1CPLxZdqw1s12oxHFyU0E1Q6Vy0sWAHQZVEXtgJp3ivFPF1xG6kZHudh9BBuz+6XZOuqwX0FdG2OKXck+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835203; c=relaxed/simple;
	bh=UtWLDDYVYPHKOBruijpVxeKE5JWhKmvc8cgSjQJk+tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppxwIrrgoFpl1g2daaQ1ICZeHUwY7cUPNuGqIjHQ7f5BzT2tUVMIiv0AVPWdiYqLjBnWtfJsYJuBQTp5tAgNsIhaYFDq7XMQmzbMhoKjjBPEILeUMe8kVaua2+fu4VJgs6ZCqLBMj7J5Zl9o6jd7B4393VgR5p3Tkl7qPuqyN4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IHum/wfl; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3c1e992f060so2981250b6e.0
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835201; x=1711440001; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yeFiA3EfY+1JD1RuYQnw5HbvsQt45vIrT0LQVWviu8g=;
        b=IHum/wflfzQA6TESzbpQlbCSSJ78lIshTIIqugIP7CqBoPvyu4XyWlmmEc9VsNBIGz
         N4KunubkWHwuE5tSjX/z4c+8lSnOgq/jYqV+ajfQnXvrx6CosfkWg/MAskVrDr3LaTqb
         athYqG9PGtRbNgpdFBJJnBkI1FOdzGkcevMtoKzonmvyFwFr+P0TkOaBqCZ/9qEfsHm6
         hU7xcxhsO/e0P/Ty2YWzRsgUT8sFigmq40sqGFJMFKv8CJixOoGNED7c20X+87/XljHG
         tDju+koZ2LFRppd6WwpRG5fvbrzNjcsa7VzAtGg/nCqc01Nn5G4eYoFDh4ErQYKwYlyz
         1fnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835201; x=1711440001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yeFiA3EfY+1JD1RuYQnw5HbvsQt45vIrT0LQVWviu8g=;
        b=JOnB99MnN6Yi5ffH11xM2P4clczeTBhyYmK4wkySOXzijmtdynoxRYW8giY9bdzSfH
         Ro/1UcFuHdB+AWnXWTBtzhmrJh2R/bhDw6/XSBjn2M/D3iB+CQgLx/vdmRDzIqLs9qQx
         9BrHubx8B+jZyJ7VoTnz0zfxAj9qt6NKFmSynd+SvZldOzpo0zhk8ypYHcbdWceQ4aaq
         lbcj2TouAcApqVQZ+ai3E1u5o9JbaGsuuUjquOhpkEU4bAeo3n4HHXTGiDj0zR4ptMnx
         +4xtbEzSWF8SOp6woN8o4PmjWd531NyZvxjtcl4L2hR7KVNVh0q2fPC4RKx0ET6+XLRj
         Ol8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWJJSSweUEfNSKveU87qK+VwgcdZ9gyBgMpjVHoKcUc0zXh8tFJblZOM8PJmUzhQQ14Iou6bW87I0RWPpHYall+jwk3
X-Gm-Message-State: AOJu0Yw4xUi3NhmhY6cCWv3nv/e4/lugpt5zCbIdGZ3SRib+XKmO79WP
	hPCxa7K0vYJ7VIwjxqsqYlxz8wJlg2NCcmEec1RsQ6OIaKcsnGai
X-Google-Smtp-Source: AGHT+IEKjVgOynnGlounTLvOmvJWwFgatUFePuOrHk3/ueXtGI7nUei9T7Qa+BG/xrhoE5qSdYaWUg==
X-Received: by 2002:a05:6808:1b24:b0:3c3:8540:8641 with SMTP id bx36-20020a0568081b2400b003c385408641mr6963268oib.9.1710835200772;
        Tue, 19 Mar 2024 01:00:00 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.00.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:00:00 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 07/35] common: add memory dirtying vs migration test
Date: Tue, 19 Mar 2024 17:58:58 +1000
Message-ID: <20240319075926.2422707-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
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

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 common/memory-verify.c      | 67 +++++++++++++++++++++++++++++++++++++
 common/selftest-migration.c |  8 ++---
 powerpc/Makefile.common     |  1 +
 powerpc/memory-verify.c     |  1 +
 powerpc/unittests.cfg       |  7 ++++
 s390x/Makefile              |  1 +
 s390x/memory-verify.c       |  1 +
 s390x/unittests.cfg         |  6 ++++
 8 files changed, 88 insertions(+), 4 deletions(-)
 create mode 100644 common/memory-verify.c
 create mode 120000 powerpc/memory-verify.c
 create mode 120000 s390x/memory-verify.c

diff --git a/common/memory-verify.c b/common/memory-verify.c
new file mode 100644
index 000000000..e78fb4338
--- /dev/null
+++ b/common/memory-verify.c
@@ -0,0 +1,67 @@
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
+	void *mem = malloc(NR_PAGES*PAGE_SIZE);
+	bool success = true;
+	uint64_t ms;
+	long i;
+
+	do_getopts(argc, argv);
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
index b79b99416..550eff787 100644
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
2.42.0



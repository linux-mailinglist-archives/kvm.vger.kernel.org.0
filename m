Return-Path: <kvm+bounces-8399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1732784F091
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 08:03:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C01F1C21B58
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 07:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0B20657BD;
	Fri,  9 Feb 2024 07:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a8izTpHC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707D056B7B;
	Fri,  9 Feb 2024 07:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707462184; cv=none; b=jvtP7hkHcx8ZONSssYZNEZIjRuK19XAtMcTSj/w1G/Q0YhujKYwwK54u3klFRfielSx4dRuxhqfaJTWIvHQMtisi+9zjyIhvuZx7DM4aWI8YuEpqi8KJuT1C64nQSEZ+6Fuz8h/8sgxb68OOep7XiVHJAx+REXPgLsWqYDEAKGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707462184; c=relaxed/simple;
	bh=0RH/PiOeHXzMf2Ch1cJmwhhhXF+PGIoUjEBesR0lss4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTzHxpgep4R7lUiIhZyAVkmAsKGndNZj8Sj5XeDIijvR7j4sYY3erIiWplNJDvQ6z+QA1STb0L9/o1ImHJOuJ/f+c6XmQQGOsZ7pZR16MleHwsqnPBwolk03GwpLi00k00II04I1fNNwaEDah9uoGMt5IaZTKLze/MTQCvexyQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a8izTpHC; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e053b272b0so406506b3a.1;
        Thu, 08 Feb 2024 23:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707462183; x=1708066983; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nLcEDOFfXRm4asPXfN/h/emKx6nM9DLWqis1Tw2BV0c=;
        b=a8izTpHCLGfdQevzbcnhDSDQ39krTIw/CI2EMvviQkt5AKtcN++MQirpCajwG9XNLq
         8t63Drp+/FYeWMItWXiGj6Ykect8gaGIgq2H0G8jKyiQsGRYNedhYbdJerr4BUlyL5gX
         WfktNV6yzC369ln02+xXCotsFNn1SRSN2mIfc5aMqzmvVjlfHZrxWX5HwlPflI3Tdme/
         QEw58FfUjk9zJhDQ4Krw45Ljz2FGqzs/V7ZcQSznqRf5SF7M3gLe+NHcJdtTn8vufOGE
         5HNaH1z5JWX1Qp+yMF8l+PE7wp1lc6KAgnS6ANvv4uovyZ4wUKJx3ixTkoMtBYIivT6H
         v65Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707462183; x=1708066983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nLcEDOFfXRm4asPXfN/h/emKx6nM9DLWqis1Tw2BV0c=;
        b=vJhJukJIbwdaQZn8Ftw2XDzBAFTEM7tg4ItE2naczrSuVxRpEuRxYa7lSQLW3LK/GD
         aizAUhm/AM9yBVejaKRrpgzK44n/zPY8dUeOlmB+1RquZGCSSRVoo18msVXfvB8/IGZz
         s7XT7g7xSgqy2oPDvLUWzlMsAGT0H+QQrmIRe+0z8W/ADiDKrTtFoD7vNxoKk+F0SExf
         COYoG1+W9lWXfRKznj3IKHgw8mWBgP33Tsd1uxCPpcs5GWZkCOGqVhkqSpUgYovNMamY
         kgCKsEZmAFMgebiL8wn09S4iL3pi020JYaYIR3XIcLAnmQskbMim4+xD9QLFxpYDgn7N
         rpkg==
X-Forwarded-Encrypted: i=1; AJvYcCUcSnyNr0xhRXTPwfvwX3kwF3+W+lj4OxCugJcGIXZ2txpQ0QKrtRfXYZ0ils5DPirhtBVBRfdbZDUzoMsQv5nJwXgC7PUiCQXNl5HlmUS5DpgV2SAW8U7vrtgODGwQhg==
X-Gm-Message-State: AOJu0YyuWQohY4UmW/QjiW/TVvbaeYQzQ7W7B+PKBElkyBgvEmyh0oz1
	yaNISg58a/7upxhfYxXaMqAf19QPmY3ET51prjqw6Z3O64WoXa9S
X-Google-Smtp-Source: AGHT+IHCDQmhvrErtDNERE9RrkYau41AxB4oBcYKBUMctdPXanPruVPXCMJmeFh2pOIguDwPif262w==
X-Received: by 2002:a05:6a20:94ce:b0:19e:99fd:3f5c with SMTP id ht14-20020a056a2094ce00b0019e99fd3f5cmr1013600pzb.25.1707462182771;
        Thu, 08 Feb 2024 23:03:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUXjVIucCvEhqf7rvEFHTsNvZRp6jchNyZ+VPMsRdJDMsygxun8hUVxG2Y9mmn+X1wF20AwZkwuxOqKvnmXHpi9Ya7qdy/vQC1E8gcH8PMc7eRyxEQ8mxGRUcypUXdhMh5JNVzlCEUQn8zSJY5XWu7q9rUVLSdJRbAApVO3gxxx1wTOt9T5wuHIddoEFJ/CkUbe+ZaSr2EMUqb7uSZ9BG5yLWDyPSq0hBIjYZBEECml7FVaVkrV/Zuv+Mh+iVhI9fyn6tIai8lu4zaiajlWuaOLax7bDifk3TcJ0450njTgSSaMih51NGiRSQTbt5GfxXki6u5W+6T1MlF5lfjdZBtkNKW30gvRDaC0z0USNqRdKSFUhhngff5ouSHO68CgNwA1BOK4njt4vZ8qETP2fDsDhU2vgvMMeZdOGNcjIJtVNrDga/XQyaVyKUnraQN1U7rTY3mqC6Q8dAu5li30gvg7lhS31t1VyOq2ib3S6QOqL3A6gvEgf+d9zZjbG/M1dacZipocfeTU0ghXUdrosLA70IEtXqxgRi2+jQQjc25jY6VBoqWsSQQp
Received: from wheely.local0.net ([1.146.102.26])
        by smtp.gmail.com with ESMTPSA id r10-20020a170903410a00b001d7284b9461sm839285pld.128.2024.02.08.23.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 23:03:02 -0800 (PST)
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
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v3 8/8] migration: add a migration selftest
Date: Fri,  9 Feb 2024 17:01:41 +1000
Message-ID: <20240209070141.421569-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209070141.421569-1-npiggin@gmail.com>
References: <20240209070141.421569-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a selftest for migration support in  guest library and test harness
code. It performs migrations a tight loop to irritate races and bugs in
the test harness code.

Include the test in arm, s390, powerpc.

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com> (s390x)
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
This has flushed out several bugs in developing the multi migration test
harness code already.

Thanks,
Nick

 arm/Makefile.common          |  1 +
 arm/selftest-migration.c     |  1 +
 arm/unittests.cfg            |  6 ++++++
 common/selftest-migration.c  | 34 ++++++++++++++++++++++++++++++++++
 powerpc/Makefile.common      |  1 +
 powerpc/selftest-migration.c |  1 +
 powerpc/unittests.cfg        |  4 ++++
 s390x/Makefile               |  1 +
 s390x/selftest-migration.c   |  1 +
 s390x/unittests.cfg          |  4 ++++
 10 files changed, 54 insertions(+)
 create mode 120000 arm/selftest-migration.c
 create mode 100644 common/selftest-migration.c
 create mode 120000 powerpc/selftest-migration.c
 create mode 120000 s390x/selftest-migration.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index f828dbe0..f107c478 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -5,6 +5,7 @@
 #
 
 tests-common  = $(TEST_DIR)/selftest.$(exe)
+tests-common += $(TEST_DIR)/selftest-migration.$(exe)
 tests-common += $(TEST_DIR)/spinlock-test.$(exe)
 tests-common += $(TEST_DIR)/pci-test.$(exe)
 tests-common += $(TEST_DIR)/pmu.$(exe)
diff --git a/arm/selftest-migration.c b/arm/selftest-migration.c
new file mode 120000
index 00000000..bd1eb266
--- /dev/null
+++ b/arm/selftest-migration.c
@@ -0,0 +1 @@
+../common/selftest-migration.c
\ No newline at end of file
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index fe601cbb..1ffd9a82 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -55,6 +55,12 @@ smp = $MAX_SMP
 extra_params = -append 'smp'
 groups = selftest
 
+# Test migration
+[selftest-migration]
+file = selftest-migration.flat
+groups = selftest migration
+
+arch = arm64
 # Test PCI emulation
 [pci-test]
 file = pci-test.flat
diff --git a/common/selftest-migration.c b/common/selftest-migration.c
new file mode 100644
index 00000000..f70c505f
--- /dev/null
+++ b/common/selftest-migration.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Machine independent migration tests
+ *
+ * This is just a very simple test that is intended to stress the migration
+ * support in the test harness. This could be expanded to test more guest
+ * library code, but architecture-specific tests should be used to test
+ * migration of tricky machine state.
+ */
+#include <libcflat.h>
+#include <migrate.h>
+
+#if defined(__arm__) || defined(__aarch64__)
+/* arm can only call getchar 15 times */
+#define NR_MIGRATIONS 15
+#else
+#define NR_MIGRATIONS 100
+#endif
+
+int main(int argc, char **argv)
+{
+	int i = 0;
+
+	report_prefix_push("migration");
+
+	for (i = 0; i < NR_MIGRATIONS; i++)
+		migrate_quiet();
+
+	report(true, "simple harness stress test");
+
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index eb88398d..da4a7bbb 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -6,6 +6,7 @@
 
 tests-common = \
 	$(TEST_DIR)/selftest.elf \
+	$(TEST_DIR)/selftest-migration.elf \
 	$(TEST_DIR)/spapr_hcall.elf \
 	$(TEST_DIR)/rtas.elf \
 	$(TEST_DIR)/emulator.elf \
diff --git a/powerpc/selftest-migration.c b/powerpc/selftest-migration.c
new file mode 120000
index 00000000..bd1eb266
--- /dev/null
+++ b/powerpc/selftest-migration.c
@@ -0,0 +1 @@
+../common/selftest-migration.c
\ No newline at end of file
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index e71140aa..7ce57de0 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -36,6 +36,10 @@ smp = 2
 extra_params = -m 256 -append 'setup smp=2 mem=256'
 groups = selftest
 
+[selftest-migration]
+file = selftest-migration.elf
+groups = selftest migration
+
 [spapr_hcall]
 file = spapr_hcall.elf
 
diff --git a/s390x/Makefile b/s390x/Makefile
index b72f7578..344d46d6 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -1,4 +1,5 @@
 tests = $(TEST_DIR)/selftest.elf
+tests += $(TEST_DIR)/selftest-migration.elf
 tests += $(TEST_DIR)/intercept.elf
 tests += $(TEST_DIR)/emulator.elf
 tests += $(TEST_DIR)/sieve.elf
diff --git a/s390x/selftest-migration.c b/s390x/selftest-migration.c
new file mode 120000
index 00000000..bd1eb266
--- /dev/null
+++ b/s390x/selftest-migration.c
@@ -0,0 +1 @@
+../common/selftest-migration.c
\ No newline at end of file
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index f5024b6e..a7ad522c 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -24,6 +24,10 @@ groups = selftest
 # please keep the kernel cmdline in sync with $(TEST_DIR)/selftest.parmfile
 extra_params = -append 'test 123'
 
+[selftest-migration]
+file = selftest-migration.elf
+groups = selftest migration
+
 [intercept]
 file = intercept.elf
 
-- 
2.42.0



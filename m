Return-Path: <kvm+bounces-8422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A3B484F211
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 10:13:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C881B29C54
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D081664DD;
	Fri,  9 Feb 2024 09:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G0p1pUH/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D551F664CD;
	Fri,  9 Feb 2024 09:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707469966; cv=none; b=Xk+uESTz2LpHMiIbd5CK0oCko/5k6ZNTxALbNs2U0kYnZwNgrMl+m609LfMhMjO+kUZh4C6LeeYxX0GrVjk2wNxiq2vcXBYJQxMQ4wi7QZd2CB59UHTACZ8p09BrWPVBoQxBFCOYaPlke5Z6M0put0VMg5xNJ5i2cpm8q6sY+R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707469966; c=relaxed/simple;
	bh=YDiPhKCwA8NLGHrJJZAVTr3FIYsWlbq0GjshdSQahwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQS50ZFMjqpuDjAOp7oUKtoNeh2Ua1oR4NK9YeruAeMhnfgTWnqRAfAfDwVbhB9MRPraqXQbAu4A+Mv+Z+HLDcnUc9EKjxQHy8vR1K92Z1SnUjpEuFBLu8+4xjHMpJCSk32RixuSxz6Lh2Zj1VRxUr0lFP28PPpAigM+bRl8BKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G0p1pUH/; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e06725a08dso511818b3a.3;
        Fri, 09 Feb 2024 01:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707469964; x=1708074764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xUi8tWoV7y43d8/rADxcJNoz7Om9vKHwuVyyk4R4P/0=;
        b=G0p1pUH/B71XJ6sqw5XHv9bqcEWjp95IIGBSaUx6pS5VI6+eBTvyeCIg2YF36brfJH
         0lyGUxJDkFAxBQiNH7KsjLXCG2Q5dd84E3fG8ZtP4Y5GDmnXACZh7p6+utlcFLNiy1sL
         C7o4Nb6xbVfizEFbMJRXySKb31CpeI7gGTfATIqGmNNSDBLbwSj5zfzFMg1u48arCYsf
         fdZM3kw6up7UT6UqR1FVwG1pVWNeix2lELwB9bm465GOjJGGPM/RxGi9lI/CTCKz7K9K
         SKGgBE5VltrkeMbFm86jX6quTeDvxcg8CAVK1koyGG6KYBlXudEC8qDkWd2wwDyprCnE
         AZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707469964; x=1708074764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xUi8tWoV7y43d8/rADxcJNoz7Om9vKHwuVyyk4R4P/0=;
        b=o9JF84yCwAcEdgyVuHrI7As1nLvTsWVYmZsJYKnMFyrump56S6WrDS/nTNbVRDBEm0
         gHty1+P2ae4HaaHLygg8DkjI85azY6A9+oQBE1Ps3pmO0Ow0qhkQW4ypkBsQl5/Mct7M
         2oLGM18BPigk7p3qUNdrO48fAIWz/YOEC+sROJUpzPTnaVsxlmRiMpUU1Px/oGtBwbte
         xx0mGr+9aqhasiBgZG4Nu6FrwpbzbaOfMR/h3MJLcFJd03HyeigEXX1vtrI154htnKlY
         QzaGVxRcqj714kLuwSy4H+dBckgF6qsg+arkCIcC8M9YSwRqkYAx3v7vVLTR5hdZDjrw
         J9uA==
X-Gm-Message-State: AOJu0YyX2yaO6K7UykltVYBPMPKbcLNW1HWSUZsQhynrBaiLlI3Cmt1n
	ykBOcFfNud6OY7ZEyjwI0GOLGkuAhtHKieBPfoQPTak8eP3TGNg4
X-Google-Smtp-Source: AGHT+IEU4SjDeB439gZ1v+vHOsu9gIns1aZMUMmovHkP67opmUKwsDY5/bROOCbrnRZ9ZxCiwcuKiA==
X-Received: by 2002:a05:6a00:80e0:b0:6dd:db87:6356 with SMTP id ei32-20020a056a0080e000b006dddb876356mr897226pfb.7.1707469964083;
        Fri, 09 Feb 2024 01:12:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXrwZjktcf61HetSLBq6YFmOCC03GE86GQEfIt7eieexAYX156hMSSPKOXp7y3e12XVLDSW4UuAQGUhgwTKyp0ERxQ+7FDd0Rvk9hb7ibp1h+V4KNfsR7GMwMXcPYGUsH//ZAt/n7cxghZKwqfsahSlqC1uLBO1NNvZMNa/9LUNtk98M/3JSP4eg6VwJL325/HPcjWWfm8UwurysoUGcBNBOGnpdqlwPXk6p3YuDXbKNk0mI3Ea400fweEVt0bzLpG+dsqWnZ2yjR3Er3jtBi14nN6pC6rZP/dJ7l5sxSAtbkq+ya/AxRx1Ntrl5UjE9TdUB5qL27ZAMTaEiMb2Wiohr42TS9qrRI0j6M5X1TVVoxnBEwVOGBabsSIGDjYgLb3VA2aXN27xfXXDByohtjQtJ4qHk+KMPAS1B/Y23na7l0wbcRJnJJBXyqdmmhESa3FrkiW5DXrRneZjTbBAGkXfeFi5LQ1B2kvdOSqzLTaC0oZkKQPJDWhGjTZPXMliWp1tirt027OA3K5bSh2Tkk24RrjmC21CBtlObJ/PL1sw+jY+ky4qfTwb
Received: from wheely.local0.net ([118.208.150.76])
        by smtp.gmail.com with ESMTPSA id cb1-20020a056a02070100b005c1ce3c960bsm1101742pgb.50.2024.02.09.01.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 01:12:43 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v4 8/8] migration: add a migration selftest
Date: Fri,  9 Feb 2024 19:11:34 +1000
Message-ID: <20240209091134.600228-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209091134.600228-1-npiggin@gmail.com>
References: <20240209091134.600228-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a selftest for migration support in  guest library and test harness
code. It performs migrations in a tight loop to irritate races and bugs
in the test harness code.

Include the test in arm, s390, powerpc.

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com> (s390x)
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
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
index fe601cbb..db0e4c9b 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -55,6 +55,12 @@ smp = $MAX_SMP
 extra_params = -append 'smp'
 groups = selftest
 
+# Test migration
+[selftest-migration]
+file = selftest-migration.flat
+groups = selftest migration
+arch = arm64
+
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



Return-Path: <kvm+bounces-7823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 184C68468E5
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 08:03:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C402928DBC2
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 07:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E132A18658;
	Fri,  2 Feb 2024 06:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LJ52ZUqr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63FC1863E;
	Fri,  2 Feb 2024 06:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857161; cv=none; b=boU0ZNobDA653VygXmjApmjbeXPpmCYP9C6VjICvs0w9ubiVcwKENPeZMInYYt8ouBa+fZIIsR7MR0qa3jcvejc7Yg+Mz4dXQumOZX+dh5VaLZTvXxLoLIX/bpY9frjGdhOklYs8EoXjeYiJRXIS2w7zfpBWzxfSMM3275lHqa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857161; c=relaxed/simple;
	bh=RzVPdOIfzAxNtVdgDbvFjWjEIWTRZqcwvTXSWOWEVGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/7tgXRb9W+rKQdBPUQ5iqDxG3Dr7zS882CduWdJeuNoKSsDsOToIu8AkaMPPkdWvDrIU0AfvuqkjbvWz24MCLvsmTf6Jzu6gtX0tzJpKRDpuwaXAsylDnvHSQBrVfZb75XuWl8tByLD9mwOEAL83WtFEmN4p8Gqua6BSc0ThjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LJ52ZUqr; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1d8e7df6abcso16665925ad.1;
        Thu, 01 Feb 2024 22:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857159; x=1707461959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mjGoSmks1AnXMChnPHaCCI0+kK+ugRn2W8NsPjJCZUU=;
        b=LJ52ZUqrzCUBbZNyGG/IHjv47MQMdcV8O3MIeBS4uOl1J1Y9NbXC0YrfgWPUFSkYax
         XsuXyNzEXe99K4xmjwvz0dBjwA0Ct0cQosrm45epMOoGQw3BNi0H66Wd5E6MjmX38+S4
         dYm6RdFBHAhNhTUBNXL4WgfJ7dGGZMpAX85aPA48kPQbFgrCYTkwSIF4y9QoQ3OGOJE2
         XOk1U9LnMXEY1vH4vGr5LdXUlRgsS/8ihE7GD3bfuy38KZgmJy+hEFSa6ncCGR/n6ISx
         U/aWqa4LIymm0wqZGJxTt1tqeJ9pmjh9tY51A8I6yVop7jpEpg10NZvW6axV4IJYPbSJ
         Dc7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857159; x=1707461959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mjGoSmks1AnXMChnPHaCCI0+kK+ugRn2W8NsPjJCZUU=;
        b=CGddM0+BnMUWR/2aq7FY5tB/aeEx6EOp1yx+OtpzjirpdDq/nF+/n8a43itARuOC2c
         IcOLEpEtLtxy1G34ab5m8b+RaKOwEZko9VvM0wu9viPK+8XicKrqtKsbp2cRAbhnyZJp
         nblrxiF1rV7ivWdN0MQAnhl1dyyqfihXhDHJ1EuPLUN7QOvCRTmDPBYU80oWfJ6QmRfu
         pRNvtpKCg0uprTU46LnvZHvJmMjECUl8Q8CGbf+xv64/JpoiwqAr6Fq7UAKNbOSweubC
         9Of43yvDfi3Mne2MnbdkXiF8x8CvogqAyzlD1KsKqCZWRsl40prIrsEAJY0ItYuRInbi
         YAMQ==
X-Gm-Message-State: AOJu0YwAY0VIc6E8mc9Zq88Jq7EaLcZR+c4CDFM/7S1zUykTq+rb+K2R
	jUlT7SkrfTviloT15LICt5VdQWj5Geyj2FHC05haPrW6JZLSA4cG
X-Google-Smtp-Source: AGHT+IGNcwlMvoqjjMx7S0tilyD6LP0972eDlmeEGxt1rTpDEdMA+PGwhHdjfkb9sruwSSLgt7sSAQ==
X-Received: by 2002:a17:902:7847:b0:1d9:d:5730 with SMTP id e7-20020a170902784700b001d9000d5730mr1104086pln.3.1706857159061;
        Thu, 01 Feb 2024 22:59:19 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXMFpmzv+sw/9fGzfBrXMtUzkOqt4yxTX4S9LpgchJ6GlcxuaqKoM5whKP+fJRmXM2QTFsy5mwrFyimGhnVxwjB/BgfCxbfpoHa44jAc1Pu6xlt4NK0D0oLh8AUgQqek5byqjl409Tdco3PHCd0eRC0Sz7mc/EcR+p7yuPWqyv8mElN/Wq6FDWVuSMPyhyF5vdo/Mu2OIWXvwnAY9AlYnSW02WUPnkVlZN+XZzks5G1peQOyAlX49ftWwZI6VDWG14w/pbGyMi72CTfs15ZvezIdTtqLJtIWEiQpeX6XOPN88RNtPdMifLkZk7mFmK8vC17sPUKR2QJv5MQ9VJdj8rGOM9cUYxzqUOYDf2ChlOLYuw4nEksUOFdp5gL7N0RrknPqLjUHSjl2/YLSFg9zaCJfsizkIhiYi/G8Wj8bMNm7Bw/OR/mSi/6Us6VWoBYeSKbf+cspqYPDKM1GMuFirWAmoRKG2lTlWzcQgIzPfZGeo7fT5BtLaQeXnzLU/xVq3xu38fp+WC/YpE=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:59:18 -0800 (PST)
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
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v2 9/9] migration: add a migration selftest
Date: Fri,  2 Feb 2024 16:57:40 +1000
Message-ID: <20240202065740.68643-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240202065740.68643-1-npiggin@gmail.com>
References: <20240202065740.68643-1-npiggin@gmail.com>
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

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com> (s390x)
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

This has flushed out several bugs in developing the multi migration test
harness code already.
---
 arm/Makefile.common         |  1 +
 arm/unittests.cfg           |  6 ++++++
 common/selftest-migration.c | 34 ++++++++++++++++++++++++++++++++++
 powerpc/Makefile.common     |  1 +
 powerpc/unittests.cfg       |  4 ++++
 s390x/Makefile              |  1 +
 s390x/unittests.cfg         |  4 ++++
 7 files changed, 51 insertions(+)
 create mode 100644 common/selftest-migration.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index c2ee568c..371a2c6a 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -5,6 +5,7 @@
 #
 
 tests-common  = $(TEST_DIR)/selftest.$(exe)
+tests-common += $(TEST_DIR)/selftest-migration.$(exe)
 tests-common += $(TEST_DIR)/spinlock-test.$(exe)
 tests-common += $(TEST_DIR)/pci-test.$(exe)
 tests-common += $(TEST_DIR)/pmu.$(exe)
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



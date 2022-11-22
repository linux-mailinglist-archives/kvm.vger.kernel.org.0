Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3F0634130
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbiKVQPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbiKVQOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:14:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB5BBF9
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Jm8RLdpkzcmeCFjb0mSwCuqevaDduEVFcyskhZpg+I=;
        b=cxMR4XW1c0sOMyYDVh24ZuvvtuZoyn05dQWod3xZLp1n0OnQDKPGtwQ/IVXwiKhO1lJVOG
        TwmwHFbaIBTNFAp9TS9G3CSdCFF5LqRkBQqGpy6Mh3qGci6RjTeITnVOTr4ETLnCgSfl/n
        OrABbWeSkp59t/Gv2VzJRROmyYDRdJI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158--VTLsWe3N1KK0AtUwBJWDw-1; Tue, 22 Nov 2022 11:12:22 -0500
X-MC-Unique: -VTLsWe3N1KK0AtUwBJWDw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED3A2802532;
        Tue, 22 Nov 2022 16:12:20 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1C3C112132D;
        Tue, 22 Nov 2022 16:12:18 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v3 11/27] lib: Add random number generator
Date:   Tue, 22 Nov 2022 18:11:36 +0200
Message-Id: <20221122161152.293072-12-mlevitsk@redhat.com>
In-Reply-To: <20221122161152.293072-1-mlevitsk@redhat.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a simple pseudo random number generator which can be used
in the tests to add randomeness in a controlled manner.

For x86 add a wrapper which initializes the PRNG with RDRAND,
unless RANDOM_SEED env variable is set, in which case it is used
instead.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 Makefile              |  3 ++-
 README.md             |  1 +
 lib/prng.c            | 41 +++++++++++++++++++++++++++++++++++++++++
 lib/prng.h            | 23 +++++++++++++++++++++++
 lib/x86/random.c      | 33 +++++++++++++++++++++++++++++++++
 lib/x86/random.h      | 17 +++++++++++++++++
 scripts/arch-run.bash |  2 +-
 x86/Makefile.common   |  1 +
 8 files changed, 119 insertions(+), 2 deletions(-)
 create mode 100644 lib/prng.c
 create mode 100644 lib/prng.h
 create mode 100644 lib/x86/random.c
 create mode 100644 lib/x86/random.h

diff --git a/Makefile b/Makefile
index 6ed5deac..384b5acf 100644
--- a/Makefile
+++ b/Makefile
@@ -29,7 +29,8 @@ cflatobjs := \
 	lib/string.o \
 	lib/abort.o \
 	lib/report.o \
-	lib/stack.o
+	lib/stack.o \
+	lib/prng.o
 
 # libfdt paths
 LIBFDT_objdir = lib/libfdt
diff --git a/README.md b/README.md
index 6e82dc22..5a677a03 100644
--- a/README.md
+++ b/README.md
@@ -91,6 +91,7 @@ the framework.  The list of reserved environment variables is below
     QEMU_ACCEL                   either kvm, hvf or tcg
     QEMU_VERSION_STRING          string of the form `qemu -h | head -1`
     KERNEL_VERSION_STRING        string of the form `uname -r`
+    TEST_SEED                    integer to force a fixed seed for the prng
 
 Additionally these self-explanatory variables are reserved
 
diff --git a/lib/prng.c b/lib/prng.c
new file mode 100644
index 00000000..d9342eb3
--- /dev/null
+++ b/lib/prng.c
@@ -0,0 +1,41 @@
+
+/*
+ * Random number generator that is usable from guest code. This is the
+ * Park-Miller LCG using standard constants.
+ */
+
+#include "libcflat.h"
+#include "prng.h"
+
+struct random_state new_random_state(uint32_t seed)
+{
+	struct random_state s = {.seed = seed};
+	return s;
+}
+
+uint32_t random_u32(struct random_state *state)
+{
+	state->seed = (uint64_t)state->seed * 48271 % ((uint32_t)(1 << 31) - 1);
+	return state->seed;
+}
+
+
+uint32_t random_range(struct random_state *state, uint32_t min, uint32_t max)
+{
+	uint32_t val = random_u32(state);
+
+	return val % (max - min + 1) + min;
+}
+
+/*
+ * Returns true randomly in 'percent_true' cases (e.g if percent_true = 70.0,
+ * it will return true in 70.0% of cases)
+ */
+bool random_decision(struct random_state *state, float percent_true)
+{
+	if (percent_true == 0)
+		return 0;
+	if (percent_true == 100)
+		return 1;
+	return random_range(state, 1, 10000) < (uint32_t)(percent_true * 100);
+}
diff --git a/lib/prng.h b/lib/prng.h
new file mode 100644
index 00000000..61d3a48b
--- /dev/null
+++ b/lib/prng.h
@@ -0,0 +1,23 @@
+
+#ifndef SRC_LIB_PRNG_H_
+#define SRC_LIB_PRNG_H_
+
+struct random_state {
+	uint32_t seed;
+};
+
+struct random_state new_random_state(uint32_t seed);
+uint32_t random_u32(struct random_state *state);
+
+/*
+ * return a random number from min to max (included)
+ */
+uint32_t random_range(struct random_state *state, uint32_t min, uint32_t max);
+
+/*
+ * Returns true randomly in 'percent_true' cases (e.g if percent_true = 70.0,
+ * it will return true in 70.0% of cases)
+ */
+bool random_decision(struct random_state *state, float percent_true);
+
+#endif /* SRC_LIB_PRNG_H_ */
diff --git a/lib/x86/random.c b/lib/x86/random.c
new file mode 100644
index 00000000..fcdd5fe8
--- /dev/null
+++ b/lib/x86/random.c
@@ -0,0 +1,33 @@
+
+#include "libcflat.h"
+#include "processor.h"
+#include "prng.h"
+#include "smp.h"
+#include "asm/spinlock.h"
+#include "random.h"
+
+static u32 test_seed;
+static bool initialized;
+
+void init_prng(void)
+{
+	char *test_seed_str = getenv("TEST_SEED");
+
+	if (test_seed_str && strlen(test_seed_str))
+		test_seed = atol(test_seed_str);
+	else
+#ifdef __x86_64__
+		test_seed =  (u32)rdrand();
+#else
+		test_seed = (u32)(rdtsc() << 4);
+#endif
+	initialized = true;
+
+	printf("Test seed: %u\n", (unsigned int)test_seed);
+}
+
+struct random_state get_prng(void)
+{
+	assert(initialized);
+	return new_random_state(test_seed + this_cpu_read_smp_id());
+}
diff --git a/lib/x86/random.h b/lib/x86/random.h
new file mode 100644
index 00000000..795b450b
--- /dev/null
+++ b/lib/x86/random.h
@@ -0,0 +1,17 @@
+/*
+ * prng.h
+ *
+ *  Created on: Nov 9, 2022
+ *      Author: mlevitsk
+ */
+
+#ifndef SRC_LIB_X86_RANDOM_H_
+#define SRC_LIB_X86_RANDOM_H_
+
+#include "libcflat.h"
+#include "prng.h"
+
+void init_prng(void);
+struct random_state get_prng(void);
+
+#endif /* SRC_LIB_X86_RANDOM_H_ */
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 51e4b97b..238d19f8 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -298,7 +298,7 @@ env_params ()
 	KERNEL_EXTRAVERSION=${KERNEL_EXTRAVERSION%%[!0-9]*}
 	! [[ $KERNEL_SUBLEVEL =~ ^[0-9]+$ ]] && unset $KERNEL_SUBLEVEL
 	! [[ $KERNEL_EXTRAVERSION =~ ^[0-9]+$ ]] && unset $KERNEL_EXTRAVERSION
-	env_add_params KERNEL_VERSION_STRING KERNEL_VERSION KERNEL_PATCHLEVEL KERNEL_SUBLEVEL KERNEL_EXTRAVERSION
+	env_add_params KERNEL_VERSION_STRING KERNEL_VERSION KERNEL_PATCHLEVEL KERNEL_SUBLEVEL KERNEL_EXTRAVERSION TEST_SEED
 }
 
 env_file ()
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 698a48ab..fa0a50e6 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -23,6 +23,7 @@ cflatobjs += lib/x86/stack.o
 cflatobjs += lib/x86/fault_test.o
 cflatobjs += lib/x86/delay.o
 cflatobjs += lib/x86/pmu.o
+cflatobjs += lib/x86/random.o
 ifeq ($(CONFIG_EFI),y)
 cflatobjs += lib/x86/amd_sev.o
 cflatobjs += lib/efi.o
-- 
2.34.3


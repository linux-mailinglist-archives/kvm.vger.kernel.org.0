Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385457679E8
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbjG2Ak4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236820AbjG2AkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:40:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CA1448E
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:39 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d1c693a29a0so2498059276.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591068; x=1691195868;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bzV5y3d2J271tDO3cv/gnkFEQwstYKr0nwihmUAyJSY=;
        b=h7SJQurCGhPYwpD+wg62IUbUGUp23yiWPobApYYIliwELpF6vUz5D+1rfx4nBCxARL
         9LidGzocsgFix1ZGwF2ESLX12gpqeaPDdxrluSS6fMo6+iKzvBo/5ROsKszEkdNvVSki
         QDOhjDNkdpX5098Y03SYR5eTEg852lDKAfNQ/RoohCOuAM0rmQNXFBDYifJbonefSgaB
         cNKE3joCx4yRHRszjmjOzjUY4mio4xxqzQ1ogVd3YykOSi7DjBgX7i63pC5pluDDlqjc
         fRfg5UW4L7f0QIB8qDvakgKmrbf1tyiZ8zzp8idVqh1EJlJT97saQJBPAFeRW3dG8SJs
         AWYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591068; x=1691195868;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bzV5y3d2J271tDO3cv/gnkFEQwstYKr0nwihmUAyJSY=;
        b=e1TNxzkpbTxg+oq/9VTkh7ygGu+2CY6XG1XmR1dQOwdSNE3PJF9M9q8MqzJqlFbnMo
         nWfCmZCCSpJimixQIlG4f1NV1dFb+KyLY17oZmusO/yW3p+Oo5XRKdlJJ9GZRRfKsUUF
         QcU5pA5MtEDP+2seXpyS2xERLA9wx2bomwr+g8VdmiajlVVjoOEFsWmWxYTHHTQZ0vHR
         TEwsamjcSOrJdXI5AO/Eod6f3I52kZduMVnL1WT0OHtp3eSEOjvX7Fuqu8E/Bz7zadDN
         L5d1wMgzCz59v0cCzwlN7qk2ZE8xWnN5uHWucBltcF5zMfQNQHu/3jrBhYQlqgVLXFmR
         9aAA==
X-Gm-Message-State: ABy/qLY8bMXMfchUI+DJYGgrxVu5vFml//0UEXh5kBMfKPwZHKwOATRO
        gMUa4KNdGHnjGwrW9vvV5x4hjlMPGcs=
X-Google-Smtp-Source: APBJJlG6p9K+yey88/DBR1TFZ25eXVJ87JNFkIYYyKMjji15nsLzqRVtB0lYm7TGzJ7EKp4i9m456kSpb4c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d08:0:b0:d0d:c74a:a6c0 with SMTP id
 8-20020a250d08000000b00d0dc74aa6c0mr16400ybn.2.1690591067903; Fri, 28 Jul
 2023 17:37:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:41 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-33-seanjc@google.com>
Subject: [PATCH v4 32/34] KVM: selftests: Rip out old, param-based guest
 assert macros
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the param-based guest assert macros and enable the printf versions
for all selftests.  Note!  This change can affect tests even if they
don't use directly use guest asserts!  E.g. via library code, or due to
the compiler making different optimization decisions.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        |  2 -
 .../selftests/kvm/aarch64/debug-exceptions.c  |  2 -
 .../selftests/kvm/aarch64/hypercalls.c        |  2 -
 .../selftests/kvm/aarch64/page_fault_test.c   |  2 -
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  2 -
 .../testing/selftests/kvm/guest_print_test.c  |  2 -
 .../selftests/kvm/include/ucall_common.h      | 71 -------------------
 .../testing/selftests/kvm/memslot_perf_test.c |  2 -
 tools/testing/selftests/kvm/s390x/memop.c     |  2 -
 tools/testing/selftests/kvm/s390x/tprot.c     |  2 -
 .../selftests/kvm/set_memory_region_test.c    |  2 -
 tools/testing/selftests/kvm/steal_time.c      |  2 -
 .../testing/selftests/kvm/x86_64/cpuid_test.c |  2 -
 .../kvm/x86_64/hyperv_extended_hypercalls.c   |  2 -
 .../selftests/kvm/x86_64/hyperv_features.c    |  2 -
 .../selftests/kvm/x86_64/kvm_pv_test.c        |  2 -
 .../selftests/kvm/x86_64/monitor_mwait_test.c |  2 -
 .../kvm/x86_64/nested_exceptions_test.c       |  2 -
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |  2 -
 .../kvm/x86_64/svm_nested_soft_inject_test.c  |  2 -
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |  2 -
 .../selftests/kvm/x86_64/userspace_io_test.c  |  2 -
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |  2 -
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    |  2 -
 24 files changed, 117 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index b53bcf126e6a..274b8465b42a 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -19,8 +19,6 @@
  *
  * Copyright (c) 2021, Google LLC.
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #define _GNU_SOURCE
 
 #include <stdlib.h>
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index fdd5b05e1b0e..f5b6cb3a0019 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -1,6 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include <test_util.h>
 #include <kvm_util.h>
 #include <processor.h>
diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index 94555a7d3c7e..31f66ba97228 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -8,8 +8,6 @@
  * hypercalls are properly masked or unmasked to the guest when disabled or
  * enabled from the KVM userspace, respectively.
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include <errno.h>
 #include <linux/arm-smccc.h>
 #include <asm/kvm.h>
diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 0b0dd90feae5..47bb914ab2fa 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -7,8 +7,6 @@
  * hugetlbfs with a hole). It checks that the expected handling method is
  * called (e.g., uffd faults with the right address and write/read flag).
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #define _GNU_SOURCE
 #include <linux/bitmap.h>
 #include <fcntl.h>
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 67da33aa6d17..2e64b4856e38 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -7,8 +7,6 @@
  * host to inject a specific intid via a GUEST_SYNC call, and then checks that
  * it received it.
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include <asm/kvm.h>
 #include <asm/kvm_para.h>
 #include <sys/eventfd.h>
diff --git a/tools/testing/selftests/kvm/guest_print_test.c b/tools/testing/selftests/kvm/guest_print_test.c
index 777838d42427..3a9a5db9794e 100644
--- a/tools/testing/selftests/kvm/guest_print_test.c
+++ b/tools/testing/selftests/kvm/guest_print_test.c
@@ -4,8 +4,6 @@
  *
  * Copyright 2022, Google, Inc. and/or its affiliates.
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 4ce11c15285a..b7e964b3182e 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -65,7 +65,6 @@ enum guest_assert_builtin_args {
 	GUEST_ASSERT_BUILTIN_NARGS
 };
 
-#ifdef USE_GUEST_ASSERT_PRINTF
 #define ____GUEST_ASSERT(_condition, _exp, _fmt, _args...)				\
 do {											\
 	if (!(_condition))								\
@@ -107,74 +106,4 @@ do {										\
 #define GUEST_ASSERT_1(_condition, arg1) \
 	__GUEST_ASSERT(_condition, "arg1 = 0x%lx", arg1)
 
-#else
-
-#define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...)		\
-do {									\
-	if (!(_condition))						\
-		ucall(UCALL_ABORT, GUEST_ASSERT_BUILTIN_NARGS + _nargs,	\
-		      "Failed guest assert: " _condstr,			\
-		      __FILE__, __LINE__, ##_args);			\
-} while (0)
-
-#define GUEST_ASSERT(_condition) \
-	__GUEST_ASSERT(_condition, #_condition, 0, 0)
-
-#define GUEST_ASSERT_1(_condition, arg1) \
-	__GUEST_ASSERT(_condition, #_condition, 1, (arg1))
-
-#define GUEST_ASSERT_2(_condition, arg1, arg2) \
-	__GUEST_ASSERT(_condition, #_condition, 2, (arg1), (arg2))
-
-#define GUEST_ASSERT_3(_condition, arg1, arg2, arg3) \
-	__GUEST_ASSERT(_condition, #_condition, 3, (arg1), (arg2), (arg3))
-
-#define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
-	__GUEST_ASSERT(_condition, #_condition, 4, (arg1), (arg2), (arg3), (arg4))
-
-#define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
-
-#define __REPORT_GUEST_ASSERT(_ucall, fmt, _args...)			\
-	TEST_FAIL("%s at %s:%ld\n" fmt,					\
-		  (const char *)(_ucall).args[GUEST_ERROR_STRING],	\
-		  (const char *)(_ucall).args[GUEST_FILE],		\
-		  (_ucall).args[GUEST_LINE],				\
-		  ##_args)
-
-#define GUEST_ASSERT_ARG(ucall, i) ((ucall).args[GUEST_ASSERT_BUILTIN_NARGS + i])
-
-#define REPORT_GUEST_ASSERT(ucall)		\
-	__REPORT_GUEST_ASSERT((ucall), "")
-
-#define REPORT_GUEST_ASSERT_1(ucall, fmt)			\
-	__REPORT_GUEST_ASSERT((ucall),				\
-			      fmt,				\
-			      GUEST_ASSERT_ARG((ucall), 0))
-
-#define REPORT_GUEST_ASSERT_2(ucall, fmt)			\
-	__REPORT_GUEST_ASSERT((ucall),				\
-			      fmt,				\
-			      GUEST_ASSERT_ARG((ucall), 0),	\
-			      GUEST_ASSERT_ARG((ucall), 1))
-
-#define REPORT_GUEST_ASSERT_3(ucall, fmt)			\
-	__REPORT_GUEST_ASSERT((ucall),				\
-			      fmt,				\
-			      GUEST_ASSERT_ARG((ucall), 0),	\
-			      GUEST_ASSERT_ARG((ucall), 1),	\
-			      GUEST_ASSERT_ARG((ucall), 2))
-
-#define REPORT_GUEST_ASSERT_4(ucall, fmt)			\
-	__REPORT_GUEST_ASSERT((ucall),				\
-			      fmt,				\
-			      GUEST_ASSERT_ARG((ucall), 0),	\
-			      GUEST_ASSERT_ARG((ucall), 1),	\
-			      GUEST_ASSERT_ARG((ucall), 2),	\
-			      GUEST_ASSERT_ARG((ucall), 3))
-
-#define REPORT_GUEST_ASSERT_N(ucall, fmt, args...)	\
-	__REPORT_GUEST_ASSERT((ucall), fmt, ##args)
-
-#endif /* USE_GUEST_ASSERT_PRINTF */
-
 #endif /* SELFTEST_KVM_UCALL_COMMON_H */
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 55f1bc70e571..20eb2e730800 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -6,8 +6,6 @@
  *
  * Basic guest setup / host vCPU thread code lifted from set_memory_region_test.
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include <pthread.h>
 #include <sched.h>
 #include <semaphore.h>
diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index a49173907cec..bb3ca9a5d731 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -4,8 +4,6 @@
  *
  * Copyright (C) 2019, Red Hat, Inc.
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/tools/testing/selftests/kvm/s390x/tprot.c b/tools/testing/selftests/kvm/s390x/tprot.c
index c12c6824d963..c73f948c9b63 100644
--- a/tools/testing/selftests/kvm/s390x/tprot.c
+++ b/tools/testing/selftests/kvm/s390x/tprot.c
@@ -4,8 +4,6 @@
  *
  * Copyright IBM Corp. 2021
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include <sys/mman.h>
 #include "test_util.h"
 #include "kvm_util.h"
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index dd8f4bac9df8..b32960189f5f 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -1,6 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <fcntl.h>
 #include <pthread.h>
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 8649c8545882..171adfb2a6cb 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -4,8 +4,6 @@
  *
  * Copyright (C) 2020, Red Hat, Inc.
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <time.h>
diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index eb1b65ffc0d5..3b34d8156d1c 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -4,8 +4,6 @@
  *
  * Generic tests for KVM CPUID set/get ioctls
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include <asm/kvm_para.h>
 #include <linux/kvm_para.h>
 #include <stdint.h>
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
index 0107d54a1a08..e036db1f32b9 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
@@ -8,8 +8,6 @@
  * Copyright 2022 Google LLC
  * Author: Vipin Sharma <vipinsh@google.com>
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include "kvm_util.h"
 #include "processor.h"
 #include "hyperv.h"
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 41a6beff78c4..9f28aa276c4e 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -4,8 +4,6 @@
  *
  * Tests for Hyper-V features enablement
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include <asm/kvm_para.h>
 #include <linux/kvm_para.h>
 #include <stdint.h>
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 1c28b77ff3cd..9e2879af7c20 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -4,8 +4,6 @@
  *
  * Tests for KVM paravirtual feature disablement
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include <asm/kvm_para.h>
 #include <linux/kvm_para.h>
 #include <stdint.h>
diff --git a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
index 960fecab3742..80aa3d8b18f8 100644
--- a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
+++ b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
@@ -1,6 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c b/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
index 4a29f59a76be..3670331adf21 100644
--- a/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
@@ -1,6 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0-only
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #define _GNU_SOURCE /* for program_invocation_short_name */
 
 #include "test_util.h"
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index abb3f26d3ce0..366cf18600bc 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -4,8 +4,6 @@
  *
  * Copyright (C) 2020, Red Hat, Inc.
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #define _GNU_SOURCE /* for program_invocation_name */
 #include <fcntl.h>
 #include <stdio.h>
diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
index c908412c5754..7ee44496cf97 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
@@ -8,8 +8,6 @@
  *   Copyright (C) 2021, Red Hat, Inc.
  *
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include <stdatomic.h>
 #include <stdio.h>
 #include <unistd.h>
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
index cf9114f70e1c..12b0964f4f13 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
@@ -4,8 +4,6 @@
  *
  * Copyright (C) 2020, Red Hat, Inc.
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include <stdio.h>
 #include <string.h>
 #include "kvm_util.h"
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
index 2c5d2a18d184..255c50b0dc32 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
@@ -1,6 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index ba09d5a01c39..ebbcb0a3f743 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -10,8 +10,6 @@
  * and check it can be retrieved with KVM_GET_MSR, also test
  * the invalid LBR formats are rejected.
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <sys/ioctl.h>
 
diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
index 5e8290797720..77d04a7bdadd 100644
--- a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
@@ -4,8 +4,6 @@
  *
  * Copyright (C) 2022, Google LLC.
  */
-#define USE_GUEST_ASSERT_PRINTF 1
-
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
-- 
2.41.0.487.g6d72f3e995-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192D876A1E3
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 22:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjGaUar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 16:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjGaUai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 16:30:38 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF4E1BC1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 13:30:36 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-583da2ac09fso59663477b3.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 13:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690835435; x=1691440235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cl1BnUfPmVzl1tOFjFD2R2afts0tDe1uk4lLZPQquBw=;
        b=lKj9qHCfwbG9BK+ATtd2u8yVjuuqKFMyGX/gQ5SC9h5Z7P9XMgFbLmM4p1XiWI5aDJ
         5WXWsuRGg28QTyf05QBHna/+bAiTjv1B7NSZrOX1eXas4fKB8WWeJxK3j5Lme96h3E+L
         rdFG3TtqehHZB8huZSU/eK3IfD3y2gUjyqSVaLqlUh7fY/5Xs3u3f2Sz1L7dzDEx2YAx
         VlyB7yVsjN043F3/1ky2EjAnzkiujSGJHnejU6+Afb1K0ADXkDSF4RMpB+X7NqvV9ZW8
         hQH8CgRN/Zeo3zJKDLVzdd/VTWTedlCBPMm9F/0s4uPak8CVoPENE8i6Iv22CrXQKrtN
         AGZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690835435; x=1691440235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cl1BnUfPmVzl1tOFjFD2R2afts0tDe1uk4lLZPQquBw=;
        b=U/gHTaJaC7urrljj0G15fJvUuq5cuyf+Iiu32yVvSYQTKsmEw1+j+gxbO80u7lEWz3
         eXGBNkT+3XQFtQlAeE096o2Gbypvt8QvuDRgTgPmLf5RsyOnSfVDTob9Buq5H3zZYRnp
         3OijzghkJKwJnZgnMjYKd0D91RINvrEHxEVzxaxhtNju8XakzpikYMg2w8SevGHRbuNK
         9IacxDiDNpo9LN/RE3cH2x1GLqxcrKJJjupCm0anD7qBgcALJqmFJFWNvNtpVODV3Tec
         JQeuJVOoqaty2+AwZm9o7EGgCQAxheiI/eFOYShromrLTOabi+nm0jykvIjN54+tl2cR
         MyFg==
X-Gm-Message-State: ABy/qLa6tO7cgWskkaRo6aC/n2l1oKlJN6p7OQawlKgr45XpPKxb/2e9
        DGlzSBHRz8/7ddFb0oS7TLgGbtI7nd8=
X-Google-Smtp-Source: APBJJlFZ60XZgMm9Bsfl4dWvQtDujZbM7ddrj6WAQOImQuMyuOjnCtlM/DEpxrUvr9OhY6TMj49TH+Z5RZ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:eb14:0:b0:583:abae:56ab with SMTP id
 n20-20020a81eb14000000b00583abae56abmr83225ywm.7.1690835435651; Mon, 31 Jul
 2023 13:30:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 31 Jul 2023 13:30:26 -0700
In-Reply-To: <20230731203026.1192091-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230731203026.1192091-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230731203026.1192091-4-seanjc@google.com>
Subject: [PATCH v4.1 3/3] KVM: selftests: Add a selftest for guest prints and
 formatted asserts
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Aaron Lewis <aaronlewis@google.com>

Add a test to exercise the various features in KVM selftest's local
snprintf() and compare them to LIBC's snprintf() to ensure they behave
the same.

This is not an exhaustive test.  KVM's local snprintf() does not
implement all the features LIBC does, e.g. KVM's local snprintf() does
not support floats or doubles, so testing for those features were
excluded.

Testing was added for the features that are expected to work to
support a minimal version of printf() in the guest.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
[sean: use UCALL_EXIT_REASON, enable for all architectures]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   4 +
 .../testing/selftests/kvm/guest_print_test.c  | 221 ++++++++++++++++++
 2 files changed, 225 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/guest_print_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index f65889f5a083..77026907968f 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -123,6 +123,7 @@ TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
+TEST_GEN_PROGS_x86_64 += guest_print_test
 TEST_GEN_PROGS_x86_64 += hardware_disable_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += kvm_page_table_test
@@ -153,6 +154,7 @@ TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
+TEST_GEN_PROGS_aarch64 += guest_print_test
 TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_aarch64 += kvm_page_table_test
 TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
@@ -169,6 +171,7 @@ TEST_GEN_PROGS_s390x += s390x/tprot
 TEST_GEN_PROGS_s390x += s390x/cmma_test
 TEST_GEN_PROGS_s390x += demand_paging_test
 TEST_GEN_PROGS_s390x += dirty_log_test
+TEST_GEN_PROGS_s390x += guest_print_test
 TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
 TEST_GEN_PROGS_s390x += kvm_page_table_test
 TEST_GEN_PROGS_s390x += rseq_test
@@ -177,6 +180,7 @@ TEST_GEN_PROGS_s390x += kvm_binary_stats_test
 
 TEST_GEN_PROGS_riscv += demand_paging_test
 TEST_GEN_PROGS_riscv += dirty_log_test
+TEST_GEN_PROGS_riscv += guest_print_test
 TEST_GEN_PROGS_riscv += kvm_create_max_vcpus
 TEST_GEN_PROGS_riscv += kvm_page_table_test
 TEST_GEN_PROGS_riscv += set_memory_region_test
diff --git a/tools/testing/selftests/kvm/guest_print_test.c b/tools/testing/selftests/kvm/guest_print_test.c
new file mode 100644
index 000000000000..267e01d057fb
--- /dev/null
+++ b/tools/testing/selftests/kvm/guest_print_test.c
@@ -0,0 +1,221 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A test for GUEST_PRINTF
+ *
+ * Copyright 2022, Google, Inc. and/or its affiliates.
+ */
+#define USE_GUEST_ASSERT_PRINTF 1
+
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+struct guest_vals {
+	uint64_t a;
+	uint64_t b;
+	uint64_t type;
+};
+
+static struct guest_vals vals;
+
+/* GUEST_PRINTF()/GUEST_ASSERT_FMT() does not support float or double. */
+#define TYPE_LIST					\
+TYPE(test_type_i64,  I64,  "%ld",   int64_t)		\
+TYPE(test_type_u64,  U64u, "%lu",   uint64_t)		\
+TYPE(test_type_x64,  U64x, "0x%lx", uint64_t)		\
+TYPE(test_type_X64,  U64X, "0x%lX", uint64_t)		\
+TYPE(test_type_u32,  U32u, "%u",    uint32_t)		\
+TYPE(test_type_x32,  U32x, "0x%x",  uint32_t)		\
+TYPE(test_type_X32,  U32X, "0x%X",  uint32_t)		\
+TYPE(test_type_int,  INT,  "%d",    int)		\
+TYPE(test_type_char, CHAR, "%c",    char)		\
+TYPE(test_type_str,  STR,  "'%s'",  const char *)	\
+TYPE(test_type_ptr,  PTR,  "%p",    uintptr_t)
+
+enum args_type {
+#define TYPE(fn, ext, fmt_t, T) TYPE_##ext,
+	TYPE_LIST
+#undef TYPE
+};
+
+static void run_test(struct kvm_vcpu *vcpu, const char *expected_printf,
+		     const char *expected_assert);
+
+#define BUILD_TYPE_STRINGS_AND_HELPER(fn, ext, fmt_t, T)		     \
+const char *PRINTF_FMT_##ext = "Got params a = " fmt_t " and b = " fmt_t;    \
+const char *ASSERT_FMT_##ext = "Expected " fmt_t ", got " fmt_t " instead";  \
+static void fn(struct kvm_vcpu *vcpu, T a, T b)				     \
+{									     \
+	char expected_printf[UCALL_BUFFER_LEN];				     \
+	char expected_assert[UCALL_BUFFER_LEN];				     \
+									     \
+	snprintf(expected_printf, UCALL_BUFFER_LEN, PRINTF_FMT_##ext, a, b); \
+	snprintf(expected_assert, UCALL_BUFFER_LEN, ASSERT_FMT_##ext, a, b); \
+	vals = (struct guest_vals){ (uint64_t)a, (uint64_t)b, TYPE_##ext };  \
+	sync_global_to_guest(vcpu->vm, vals);				     \
+	run_test(vcpu, expected_printf, expected_assert);		     \
+}
+
+#define TYPE(fn, ext, fmt_t, T) \
+		BUILD_TYPE_STRINGS_AND_HELPER(fn, ext, fmt_t, T)
+	TYPE_LIST
+#undef TYPE
+
+static void guest_code(void)
+{
+	while (1) {
+		switch (vals.type) {
+#define TYPE(fn, ext, fmt_t, T)							\
+		case TYPE_##ext:						\
+			GUEST_PRINTF(PRINTF_FMT_##ext, vals.a, vals.b);		\
+			__GUEST_ASSERT(vals.a == vals.b,			\
+				       ASSERT_FMT_##ext, vals.a, vals.b);	\
+			break;
+		TYPE_LIST
+#undef TYPE
+		default:
+			GUEST_SYNC(vals.type);
+		}
+
+		GUEST_DONE();
+	}
+}
+
+/*
+ * Unfortunately this gets a little messy because 'assert_msg' doesn't
+ * just contains the matching string, it also contains additional assert
+ * info.  Fortunately the part that matches should be at the very end of
+ * 'assert_msg'.
+ */
+static void ucall_abort(const char *assert_msg, const char *expected_assert_msg)
+{
+	int len_str = strlen(assert_msg);
+	int len_substr = strlen(expected_assert_msg);
+	int offset = len_str - len_substr;
+
+	TEST_ASSERT(len_substr <= len_str,
+		    "Expected '%s' to be a substring of '%s'\n",
+		    assert_msg, expected_assert_msg);
+
+	TEST_ASSERT(strcmp(&assert_msg[offset], expected_assert_msg) == 0,
+		    "Unexpected mismatch. Expected: '%s', got: '%s'",
+		    expected_assert_msg, &assert_msg[offset]);
+}
+
+static void run_test(struct kvm_vcpu *vcpu, const char *expected_printf,
+		     const char *expected_assert)
+{
+	struct kvm_run *run = vcpu->run;
+	struct ucall uc;
+
+	while (1) {
+		vcpu_run(vcpu);
+
+		TEST_ASSERT(run->exit_reason == UCALL_EXIT_REASON,
+			    "Unexpected exit reason: %u (%s),\n",
+			    run->exit_reason, exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			TEST_FAIL("Unknown 'args_type' = %lu", uc.args[1]);
+			break;
+		case UCALL_PRINTF:
+			TEST_ASSERT(strcmp(uc.buffer, expected_printf) == 0,
+				    "Unexpected mismatch. Expected: '%s', got: '%s'",
+				    expected_printf, uc.buffer);
+			break;
+		case UCALL_ABORT:
+			ucall_abort(uc.buffer, expected_assert);
+			break;
+		case UCALL_DONE:
+			return;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+}
+
+static void guest_code_limits(void)
+{
+	char test_str[UCALL_BUFFER_LEN + 10];
+
+	memset(test_str, 'a', sizeof(test_str));
+	test_str[sizeof(test_str) - 1] = 0;
+
+	GUEST_PRINTF("%s", test_str);
+}
+
+static void test_limits(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_limits);
+	run = vcpu->run;
+	vcpu_run(vcpu);
+
+	TEST_ASSERT(run->exit_reason == UCALL_EXIT_REASON,
+		    "Unexpected exit reason: %u (%s),\n",
+		    run->exit_reason, exit_reason_str(run->exit_reason));
+
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_ABORT,
+		    "Unexpected ucall command: %lu,  Expected: %u (UCALL_ABORT)\n",
+		    uc.cmd, UCALL_ABORT);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	test_type_i64(vcpu, -1, -1);
+	test_type_i64(vcpu, -1,  1);
+	test_type_i64(vcpu, 0x1234567890abcdef, 0x1234567890abcdef);
+	test_type_i64(vcpu, 0x1234567890abcdef, 0x1234567890abcdee);
+
+	test_type_u64(vcpu, 0x1234567890abcdef, 0x1234567890abcdef);
+	test_type_u64(vcpu, 0x1234567890abcdef, 0x1234567890abcdee);
+	test_type_x64(vcpu, 0x1234567890abcdef, 0x1234567890abcdef);
+	test_type_x64(vcpu, 0x1234567890abcdef, 0x1234567890abcdee);
+	test_type_X64(vcpu, 0x1234567890abcdef, 0x1234567890abcdef);
+	test_type_X64(vcpu, 0x1234567890abcdef, 0x1234567890abcdee);
+
+	test_type_u32(vcpu, 0x90abcdef, 0x90abcdef);
+	test_type_u32(vcpu, 0x90abcdef, 0x90abcdee);
+	test_type_x32(vcpu, 0x90abcdef, 0x90abcdef);
+	test_type_x32(vcpu, 0x90abcdef, 0x90abcdee);
+	test_type_X32(vcpu, 0x90abcdef, 0x90abcdef);
+	test_type_X32(vcpu, 0x90abcdef, 0x90abcdee);
+
+	test_type_int(vcpu, -1, -1);
+	test_type_int(vcpu, -1,  1);
+	test_type_int(vcpu,  1,  1);
+
+	test_type_char(vcpu, 'a', 'a');
+	test_type_char(vcpu, 'a', 'A');
+	test_type_char(vcpu, 'a', 'b');
+
+	test_type_str(vcpu, "foo", "foo");
+	test_type_str(vcpu, "foo", "bar");
+
+	test_type_ptr(vcpu, 0x1234567890abcdef, 0x1234567890abcdef);
+	test_type_ptr(vcpu, 0x1234567890abcdef, 0x1234567890abcdee);
+
+	kvm_vm_free(vm);
+
+	test_limits();
+
+	return 0;
+}
-- 
2.41.0.585.gd2178a4bd4-goog


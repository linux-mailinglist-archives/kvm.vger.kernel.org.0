Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E4E3DFD6D
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236857AbhHDI67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236849AbhHDI66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:58:58 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B03CC061798
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:58:46 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f3-20020a25cf030000b029055a2303fc2dso2245445ybg.11
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=r41+4YYQSiRGA4d6k0mbGoII8JeQ9p3vNbErRM95pUY=;
        b=i1JP0767Kq2eMPERgaGvHbggJeZJvodxcSvZQy51OakaKa1Cbqy9xm+/eZdOHxqRmC
         fFh58lUBru2qfvCl38Gfb2VU/pDLhL4ITdf3Chejofn87Q6F7gqmswLQe0W3Vt2hSMrW
         StDqS5nb+AnvztxtI4rLhPA74xkiiidKtOVGH0ktlG8aZR1A1D+6MTGzGX7hQBqntekf
         kjPuEi+qTGrrP1iuuWD1IiSGwXiXiasHuZm5SuWHvrSnWVvB3PXsT5RFMcSUlvOuDllF
         U80KyR1DLEKtQ+pIyHVzZx/Fo3vjH8n1ZPMl4hKmqntonTmhWFeKx1hW1HoxYaHAQ3Fx
         4n8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=r41+4YYQSiRGA4d6k0mbGoII8JeQ9p3vNbErRM95pUY=;
        b=LDTJhf4bi30G5IIDv4+oMZjLI5meJWG5HrrpHXODOTnnjLDsmm9XMSRgtGh7nDGcKh
         kwhuLgHEcg8cs0VPQrf0MNapgXOUjZUzpjvlkfhLKhh1lXYutvgFRVdSGb3lKjnclAeq
         344leI+k/ZsFxoeeA1tpZ6QMt1qOfhbRF4mLjZ7UJItLCtsONg44ho8L5mtmPJY6hSsY
         OnFbSXRUpWMHCCI1dbmyEaWw4G7j+wgFA7RRNgcaTEDWEWiyEtS4u5UhVtFYXCqV/n1Z
         u3X8nZ9RrHPk0BtzuqgahM9Fz3oSdOmaVxTPVM8rH3OVUKR2m5Edh+htz4q5OtYGCu+e
         AqzA==
X-Gm-Message-State: AOAM5311FBGAlf56zPYOIBVETqGWUnfhE62RfuYI4MsYMO58y2fJ3RLi
        9tBTf450G7ooYF/25RPLy6f6N4mTpkYJSBAfVgWW6lFqdeugAWdOTPzdBW1OiJGtBqlOEmGAhHu
        nrTGmKwKfBF9OflJAPsmyKW4GLZNv62+pUY2b0IiEQHZs5CXwbpALglLX7Q==
X-Google-Smtp-Source: ABdhPJwYShJd9P6lwbF9fYm94Q4Zq6gEEsSqgevPCyNL1eua0sBPsWceQGemLO1QF+7+t0wmw+wsImgjHFE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:114c:: with SMTP id
 p12mr35133135ybu.282.1628067525755; Wed, 04 Aug 2021 01:58:45 -0700 (PDT)
Date:   Wed,  4 Aug 2021 08:58:08 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-11-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 10/21] selftests: KVM: Introduce system counter offset test
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a KVM selftest to verify that userspace manipulation of the
TSC (via the new vCPU attribute) results in the correct behavior within
the guest.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/system_counter_offset_test.c          | 132 ++++++++++++++++++
 3 files changed, 134 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/system_counter_offset_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 958a809c8de4..3d2585f0bffc 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -52,3 +52,4 @@
 /set_memory_region_test
 /steal_time
 /kvm_binary_stats_test
+/system_counter_offset_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0f94b18b33ce..9f7060c02668 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -85,6 +85,7 @@ TEST_GEN_PROGS_x86_64 += memslot_perf_test
 TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
+TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
new file mode 100644
index 000000000000..b337bbbfa41f
--- /dev/null
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -0,0 +1,132 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021, Google LLC.
+ *
+ * Tests for adjusting the system counter from userspace
+ */
+#include <asm/kvm_para.h>
+#include <stdint.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <time.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#define VCPU_ID 0
+
+#ifdef __x86_64__
+
+struct test_case {
+	uint64_t tsc_offset;
+};
+
+static struct test_case test_cases[] = {
+	{ 0 },
+	{ 180 * NSEC_PER_SEC },
+	{ -180 * NSEC_PER_SEC },
+};
+
+static void check_preconditions(struct kvm_vm *vm)
+{
+	if (!_vcpu_has_device_attr(vm, VCPU_ID, KVM_VCPU_TSC_CTRL, KVM_VCPU_TSC_OFFSET))
+		return;
+
+	print_skip("KVM_VCPU_TSC_OFFSET not supported; skipping test");
+	exit(KSFT_SKIP);
+}
+
+static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
+{
+	vcpu_access_device_attr(vm, VCPU_ID, KVM_VCPU_TSC_CTRL,
+				KVM_VCPU_TSC_OFFSET, &test->tsc_offset, true);
+}
+
+static uint64_t guest_read_system_counter(struct test_case *test)
+{
+	return rdtsc();
+}
+
+static uint64_t host_read_guest_system_counter(struct test_case *test)
+{
+	return rdtsc() + test->tsc_offset;
+}
+
+#else /* __x86_64__ */
+
+#error test not implemented for this architecture!
+
+#endif
+
+#define GUEST_SYNC_CLOCK(__stage, __val)			\
+		GUEST_SYNC_ARGS(__stage, __val, 0, 0, 0)
+
+static void guest_main(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		struct test_case *test = &test_cases[i];
+
+		GUEST_SYNC_CLOCK(i, guest_read_system_counter(test));
+	}
+}
+
+static void handle_sync(struct ucall *uc, uint64_t start, uint64_t end)
+{
+	uint64_t obs = uc->args[2];
+
+	TEST_ASSERT(start <= obs && obs <= end,
+		    "unexpected system counter value: %"PRIu64" expected range: [%"PRIu64", %"PRIu64"]",
+		    obs, start, end);
+
+	pr_info("system counter value: %"PRIu64" expected range [%"PRIu64", %"PRIu64"]\n",
+		obs, start, end);
+}
+
+static void handle_abort(struct ucall *uc)
+{
+	TEST_FAIL("%s at %s:%ld", (const char *)uc->args[0],
+		  __FILE__, uc->args[1]);
+}
+
+static void enter_guest(struct kvm_vm *vm)
+{
+	uint64_t start, end;
+	struct ucall uc;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		struct test_case *test = &test_cases[i];
+
+		setup_system_counter(vm, test);
+		start = host_read_guest_system_counter(test);
+		vcpu_run(vm, VCPU_ID);
+		end = host_read_guest_system_counter(test);
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_SYNC:
+			handle_sync(&uc, start, end);
+			break;
+		case UCALL_ABORT:
+			handle_abort(&uc);
+			return;
+		default:
+			TEST_ASSERT(0, "unhandled ucall %ld\n",
+				    get_ucall(vm, VCPU_ID, &uc));
+		}
+	}
+}
+
+int main(void)
+{
+	struct kvm_vm *vm;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_main);
+	check_preconditions(vm);
+	ucall_init(vm, NULL);
+
+	enter_guest(vm);
+	kvm_vm_free(vm);
+}
-- 
2.32.0.605.g8dce9f2422-goog


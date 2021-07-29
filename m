Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBB93D99F2
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 02:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbhG2AKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 20:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232982AbhG2AKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 20:10:32 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E10C061757
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 17:10:30 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id l4-20020a9270040000b02901bb78581beaso2341525ilc.12
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 17:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dQ72a2aFqXjeEXN3RbonOindW65HTj9dwtGUo7LrPlc=;
        b=aDfekHgt46QB4ZlLoX/l4ziVZALUsJyZO3jgNR+CFcmNxTUez4500rCv1nMEO6/J1N
         v2ctCJpM2YTPOFGxmZotDuQkqjwQCrGdI3dg+NRlJVNSM8rFHGNiwDF29XUh4nQibCZQ
         WyIVtl0tL0GpIiSDzkHrI/ukOl6rYk0KNlv+TibT1dEONtec8I+1ZgAdGkyMGh6slZ6M
         +/xXHd09UP/pKcLJl1YRXNrGqW0ag7O5fvyC8WFwH6+/ds0U+stqqvhZi50b3dbqF0bf
         i6P8uci7Hj9CMQbFm9SXYUjvSj4tkuGs4fdeIQCm1txnWA0LRBOwSRHTpNFBVB/MIvJm
         ZsQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dQ72a2aFqXjeEXN3RbonOindW65HTj9dwtGUo7LrPlc=;
        b=bM5KMU6u0e3lKfMEB93OKGKVidXDLTCImgnS5UqZHoMQ3cUpjTz7owjY77tYKIhSrv
         TBFCF5+8EL2VCesp6KcwfkO3oSwBPmxI2dow9B1LwImj99bI5ix3zY5Eh3vbugEAFRPO
         oDEq4R38OkJBpgNvWgnfyLjxhBI+LTnQeMpvgeLXjtcgZCnldmk9pnqKw0/9YbcFQWRp
         yq/mZsAJv+1RY0F6LEZ2DO6G/9HAr+z5qrCoUO31eReON/gZPkohhuyUq8jWjZFhYQGk
         Zsarn8aT8u7ydS78F78zQIvEGhEf+iHykG1hlMWW8KApo7ufVZL7WES/hi85980DCPpy
         sjjw==
X-Gm-Message-State: AOAM532LF2KnK88CaqX7Ex1gBmQQXG0mIGbzT1ThlEYPgeqKR34qpnvl
        csp8b0lXVEcITOXiAzj8nnz58uCwqLV5mzGNpVBwDXhwaopk31ADVm6CdlkbRC+9r88Sm2jvBp0
        asVMh6z1Tnp4o2hIwq+5Z5BJTQq2I4428zrOQwIsLpo4Q4TnMpO5xQq6sMQ==
X-Google-Smtp-Source: ABdhPJwqOz1R+I066VXIF2GZnOdk8xeC3upWFmBEp1JVCk0sPvmc+ckUlzbulD3lzOur7Edyodxp1NdamhA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:2911:: with SMTP id l17mr1619080ilg.263.1627517429872;
 Wed, 28 Jul 2021 17:10:29 -0700 (PDT)
Date:   Thu, 29 Jul 2021 00:10:07 +0000
In-Reply-To: <20210729001012.70394-1-oupton@google.com>
Message-Id: <20210729001012.70394-9-oupton@google.com>
Mime-Version: 1.0
References: <20210729001012.70394-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v4 08/13] selftests: KVM: Introduce system counter offset test
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
2.32.0.432.gabb21c7263-goog


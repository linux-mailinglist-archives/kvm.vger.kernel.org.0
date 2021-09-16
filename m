Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06EB40EA79
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345479AbhIPS6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343837AbhIPS5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:33 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5C1C04A15F
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:16:04 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id z16-20020ac86b90000000b0029eec160182so63105612qts.9
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LZMBqJKsEx/YX0wZzWqi+x5266Mf4oiHknVDcrFbaVA=;
        b=EP5u5/NqCtuILilzkwPpJW8jLm8gC0bOBftBq0pMfJmDY/ECI84dN8+GhVVjcBTtQ0
         wnGsn5j6MntLqxFtVJnjoB381HbJH2fWgqfC0eJtMr4DanDu9kQjmhkqFJP7rsEUQz04
         DeypPbnf5QYhurGWE/HJ6CqOa9ECwrDuywbOiSgE3UZJWVEtDuLFtnKSvRskMZkq6zoN
         CQZPIWn+QJimZTA2frbOylXQQsMY00yLHK/YA09VXQ3tPlMX/gatQme6vKQxU7m3eIPz
         uunz2V/OhtgivY72EKa43eh6uTyFLTjN/mp5matdFjuPfnlW7iIFdYylh/VPw9CEGIAu
         64Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LZMBqJKsEx/YX0wZzWqi+x5266Mf4oiHknVDcrFbaVA=;
        b=bssbX7O4D5TC5j0ArU2gNadr/P2Uko1I9iVFp1nXuqdbdvGQrP7i05UOHEfiC8dlwf
         eTIE7B7+Us7B6m83zrRMVxol+pixynXgr88RXfNkqdNARfPBhL9cZuuJ3AnyURXniNdT
         v4b2NMyw0IDmvzrI4wGwadH8Zwl2sgW8lDe9TlRu43R0LzWOo0sblqN0D/x4w/GTPir1
         hOH2/hdk67CYA1rEMX+bDRUEbzdzf6qFXOqVIcwL36Sm6EOX4GSVO8anhyPSh/PFW370
         EdBSgRbrl3ub09smA/v6z0WEMkCewEax44h40O0jx1DJ3Z1mU7hf3JgJMuTicpR5zLSj
         h93w==
X-Gm-Message-State: AOAM5331e1fhJcUsxjZDqMPCgzuXzgGRX94c6xulyRo62mqCf6m7pEEt
        HSqK/xNsWj8uLdqc6J9m3cU+aki/lbX3edYWcqn9ULH61keqRLfZM7N1IL0LbSzxhzkJIXtkbQt
        3ehwzfKzn416numnEWcm9yAxkaxSH/5vc6kYsWtdfIUDTUcppjw+6sm7RrA==
X-Google-Smtp-Source: ABdhPJzFgltNIhTy85T8hZ9qhzlDzuAUAapgEsrLSWd3FPaJyL7kW0G9dhGsxpQZsmGGyyjgWGHGg17947o=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:1394:: with SMTP id
 g20mr6689024qvz.21.1631816163501; Thu, 16 Sep 2021 11:16:03 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:51 +0000
In-Reply-To: <20210916181555.973085-1-oupton@google.com>
Message-Id: <20210916181555.973085-6-oupton@google.com>
Mime-Version: 1.0
References: <20210916181555.973085-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 5/9] selftests: KVM: Introduce system counter offset test
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
index 86a063d1cd3e..aa5a5197716e 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -52,3 +52,4 @@
 /set_memory_region_test
 /steal_time
 /kvm_binary_stats_test
+/system_counter_offset_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 1f969b0192f6..225803ac95bb 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -84,6 +84,7 @@ TEST_GEN_PROGS_x86_64 += memslot_perf_test
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
2.33.0.464.g1972c5931b-goog


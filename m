Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5467461A7A3
	for <lists+kvm@lfdr.de>; Sat,  5 Nov 2022 05:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiKEE5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Nov 2022 00:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiKEE5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Nov 2022 00:57:30 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DC73FBA4
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 21:57:20 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o2-20020a5b0502000000b006cade5e7c07so6741934ybp.10
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 21:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X3X2UKpD6zQllEjbrRaWm6/Z/akGwGuBaRDivMqgr8Q=;
        b=VIDKnr7oA7dLSPu4w5AAFufkeugCkvAQRahHYHsXU5b9ZNq9wL+25O2wkVs8e4PuC/
         TIJU6QavnK5/6WXiX/z9atzSeOYxxN2Nahv0m5k7qcjby/QI2LB0B60VwSJuUofBe8em
         QZwLj+BchqaqON0RTYkdrbnmiWpM1oP2EzCivxaSYZCgA87PmcETZGVQ3ccF2fMpcAHr
         cWZeisWkQyc0Bk7fNgQz6qQKy2M19Ta0hRC7betzNIFuIaGk36E2vtSNpwnC3DqcfDDu
         Dwzt+dxRSAdJmPdzr4nc0zgX4yVx5+c9+sFuFsL6dSSHjP6Azofe0euBAVXD71zZyScL
         XXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X3X2UKpD6zQllEjbrRaWm6/Z/akGwGuBaRDivMqgr8Q=;
        b=efZFXT4Fb4EfvVyZ8E4gXbiPPxI803mtdBD6YJSVrpqdrIBWIu8ydPA8ktnMShxF2I
         BLAKtq3Q6SGPQX+XCyTHWCbOKoWX1uyJup4+/K6uk2H4KelELkkt5uKM4J2b/342yB5w
         lEYU53jUoE+bExajotsBCmR8IKMWgVgjjMdWCcgIaz5RMFsalY84lmThKPlqOZ4Yrrmn
         V8iJlX8bz+yHJ+RU/a7uCqeNgFWFLcQuZF6BJpBBTB6nF/lkUDxb5Ar67hYVk7MbY+J2
         dgQ0qqmWkZvGIc59bFve9ZKbGXahazdF0KJLAJCfDmxP1komKS93OobQY4JFAWFFWOA5
         vDvA==
X-Gm-Message-State: ACrzQf0rXGZdX7aWpeTP50UCKxo9kglHqtzYCRxuJJepLw2Cq4hidyIT
        hzPaXq7YQRVEIOWeMh9v+65ia4/YX5iH
X-Google-Smtp-Source: AMsMyM7Flg5aR1zClpNW2xshNq/VsxhK9frK2C/zEKLM3NFx5tw9w95ZDnLjFUdUdwDsyTvZZzdGAIe0MWDb
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a25:af12:0:b0:6cb:b5d7:d64d with SMTP id
 a18-20020a25af12000000b006cbb5d7d64dmr38476719ybh.510.1667624240120; Fri, 04
 Nov 2022 21:57:20 -0700 (PDT)
Date:   Fri,  4 Nov 2022 21:57:04 -0700
In-Reply-To: <20221105045704.2315186-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221105045704.2315186-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221105045704.2315186-7-vipinsh@google.com>
Subject: [PATCH 6/6] KVM: selftests: Test Hyper-V extended hypercall exit to userspace
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V extended hypercalls by default exit to userspace. Verify
userspace gets the call, update the result and then guest verifies
result it received.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../kvm/x86_64/hyperv_extended_hcalls.c       | 90 +++++++++++++++++++
 3 files changed, 92 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_extended_hcalls.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 2f0d705db9db..ffe06dd1cc6e 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -24,6 +24,7 @@
 /x86_64/kvm_pv_test
 /x86_64/hyperv_clock
 /x86_64/hyperv_cpuid
+/x86_64/hyperv_extended_hcalls
 /x86_64/hyperv_features
 /x86_64/hyperv_svm_test
 /x86_64/max_vcpuid_cap_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0172eb6cb6ee..366345099363 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -85,6 +85,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/emulator_error_test
 TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_extended_hcalls
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hcalls.c b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hcalls.c
new file mode 100644
index 000000000000..d378877235d4
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hcalls.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test Hyper-V extended hypercalls
+ *
+ * Copyright 2020 Google LLC
+ * Author: Vipin Sharma <vipinsh@google.com>
+ */
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "hyperv.h"
+
+/* Any value is fine */
+#define EXT_CAPABILITIES 0xbull
+
+static void guest_code(vm_vaddr_t pgs_gpa, vm_vaddr_t output_pg_gva)
+{
+	uint64_t res, vector;
+	uint64_t *output_gva;
+
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
+	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
+
+	output_gva = (uint64_t *)output_pg_gva;
+
+	vector = hypercall(HV_EXT_CALL_QUERY_CAPABILITIES, pgs_gpa,
+			   pgs_gpa + 4096, &res);
+
+	GUEST_ASSERT_1(!vector, vector);
+	GUEST_ASSERT_2(res == HV_STATUS_SUCCESS, res, HV_STATUS_SUCCESS);
+
+	/* TLFS states output will be a uint64_t value */
+	GUEST_ASSERT_2(*output_gva == EXT_CAPABILITIES, *output_gva,
+		       EXT_CAPABILITIES);
+
+	GUEST_DONE();
+}
+
+static void guest_extended_hcall_test(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	vm_vaddr_t hcall_page;
+	uint64_t *outval;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
+	vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
+	vcpu_set_hv_cpuid(vcpu);
+
+	/* Hypercall input/output */
+	hcall_page = vm_vaddr_alloc_pages(vm, 2);
+	memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
+	vcpu_args_set(vcpu, 2, addr_gva2gpa(vm, hcall_page), hcall_page + 4096);
+
+	vcpu_run(vcpu);
+
+	TEST_ASSERT((run->exit_reason == KVM_EXIT_HYPERV),
+		    "unexpected exit reason: %u (%s)", run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+
+	outval = addr_gpa2hva(vm, run->hyperv.u.hcall.params[1]);
+	*outval = EXT_CAPABILITIES;
+	run->hyperv.u.hcall.result = HV_STATUS_SUCCESS;
+
+	vcpu_run(vcpu);
+
+	TEST_ASSERT((run->exit_reason == KVM_EXIT_IO),
+		    "unexpected exit reason: %u (%s)", run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT_2(uc, "arg1 = %ld, arg2 = %ld");
+		break;
+	case UCALL_DONE:
+		break;
+	default:
+		TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
+	}
+
+	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	guest_extended_hcall_test();
+}
-- 
2.38.1.273.g43a17bfeac-goog


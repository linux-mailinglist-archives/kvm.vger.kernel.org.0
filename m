Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF44A64A749
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbiLLSil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbiLLShz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:37:55 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7568526C4
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:45 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id j21-20020a63fc15000000b00476d6932baeso8145562pgi.23
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O/LYLNFy5FszLpRL5Okhp+FaOOk91R8mIJyJFofIsHk=;
        b=E3NeDdsnxgDS9Tr8G0wja3pwLAuMK31lYDUVs+6PL67gzr26rZG5eVQfdwVKqQjet3
         HcCqwoyOrjihaMQNVZC9r8ZJCF8i7tbGFVZQF6K+O383Du5qfqVl2e+4xt9Mx5dZTA5E
         GpGaDkoli4CEL8YdAZx1KQ6IxFrakHwYuz0nekVACS7POgZQfKu91dV2/93I8ytlbu0P
         uPOX6dTYBDmI0cjktI4kcYwaMaIAGuRB7qmkeYlT8xmVJTz3mLe/4zSpgFpvarrH7lFk
         0/95pp0zm/jOnt7hkWhJbdJ5MtzWch1VxIj/MOL8HX2nbJE7VuJtDfEuyJW8WgmpbAyi
         L8Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O/LYLNFy5FszLpRL5Okhp+FaOOk91R8mIJyJFofIsHk=;
        b=Hk4H0Ui9mlwqcrOwxuHgAabWHh9bH8nHPQ6pqD+UE+Wns0IN0GIB2woEooZPGf2idO
         I+FYrgWtHQAtsPFtdsePNBHLMcU/X/+LAvN/ZfhGXBuGQq04zN5A5ylj0O5WDWlsMJg4
         sq6lZFKh56rXfq39ZE/b+VI9ThbC46plIUvx6QSnphCA4BaAZlMiik0zzx+J0IBkY8ML
         vxAsrG2FX69bPMN/JDY5Dp+rTuQEbwThX+EeOF81eAgd+7MaWxvmtkwUkDtLOSSaO0jj
         Z7Zllmav5zRhZONwTumbI9hwCzxyEJloZD6JR6Cmf+sLF5nqqwZhGIHA9DtYz6bwbnUI
         U7cw==
X-Gm-Message-State: ANoB5pn2K39X4seIj3J4llJB3b5C/CRKHlfl2s/0iACcUqQJGyx3gQJb
        f9mc6UhC9midEdbhPkH8ry3YRybmbtiP
X-Google-Smtp-Source: AA0mqf7r38IGR9ujEgNBAsDqKfYpF9xhG8QHWK9CZCimkb2dcVFcppG3T3aGEVcS5K4SFHsTvc5yuspRQZ/3
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:c283:b0:189:89e2:540d with SMTP id
 i3-20020a170902c28300b0018989e2540dmr53606648pld.73.1670870264976; Mon, 12
 Dec 2022 10:37:44 -0800 (PST)
Date:   Mon, 12 Dec 2022 10:37:20 -0800
In-Reply-To: <20221212183720.4062037-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221212183720.4062037-14-vipinsh@google.com>
Subject: [Patch v4 13/13] KVM: selftests: Test Hyper-V extended hypercall exit
 to userspace
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V extended hypercalls by default exit to userspace. Verify
userspace gets the call, update the result and then verify in guest
correct result is received.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../kvm/x86_64/hyperv_extended_hypercalls.c   | 93 +++++++++++++++++++
 3 files changed, 95 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 082855d94c72..b17874697d74 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -24,6 +24,7 @@
 /x86_64/hyperv_clock
 /x86_64/hyperv_cpuid
 /x86_64/hyperv_evmcs
+/x86_64/hyperv_extended_hypercalls
 /x86_64/hyperv_features
 /x86_64/hyperv_ipi
 /x86_64/hyperv_svm_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 2275ba861e0e..a0e12f5d9835 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -87,6 +87,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_evmcs
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_extended_hypercalls
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_ipi
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
new file mode 100644
index 000000000000..43b53a406b52
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test Hyper-V extended hypercall, HV_EXT_CALL_QUERY_CAPABILITIES (0x8001),
+ * exit to userspace and receive result in guest.
+ *
+ * Negative tests are present in hyperv_features.c
+ *
+ * Copyright 2022 Google LLC
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
+static void guest_code(vm_paddr_t in_pg_gpa, vm_paddr_t out_pg_gpa,
+		       vm_vaddr_t out_pg_gva)
+{
+	uint64_t *output_gva;
+
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
+	wrmsr(HV_X64_MSR_HYPERCALL, in_pg_gpa);
+
+	output_gva = (uint64_t *)out_pg_gva;
+
+	hyperv_hypercall(HV_EXT_CALL_QUERY_CAPABILITIES, in_pg_gpa, out_pg_gpa);
+
+	/* TLFS states output will be a uint64_t value */
+	GUEST_ASSERT_EQ(*output_gva, EXT_CAPABILITIES);
+
+	GUEST_DONE();
+}
+
+int main(void)
+{
+	vm_vaddr_t hcall_out_page;
+	vm_vaddr_t hcall_in_page;
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	uint64_t *outval;
+	struct ucall uc;
+
+	/* Verify if extended hypercalls are supported */
+	if (!kvm_cpuid_has(kvm_get_supported_hv_cpuid(),
+			   HV_ENABLE_EXTENDED_HYPERCALLS)) {
+		print_skip("Extended calls not supported by the kernel");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
+	vcpu_set_hv_cpuid(vcpu);
+
+	/* Hypercall input */
+	hcall_in_page = vm_vaddr_alloc_pages(vm, 1);
+	memset(addr_gva2hva(vm, hcall_in_page), 0x0, vm->page_size);
+
+	/* Hypercall output */
+	hcall_out_page = vm_vaddr_alloc_pages(vm, 1);
+	memset(addr_gva2hva(vm, hcall_out_page), 0x0, vm->page_size);
+
+	vcpu_args_set(vcpu, 3, addr_gva2gpa(vm, hcall_in_page),
+		      addr_gva2gpa(vm, hcall_out_page), hcall_out_page);
+
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_HYPERV);
+
+	outval = addr_gpa2hva(vm, run->hyperv.u.hcall.params[1]);
+	*outval = EXT_CAPABILITIES;
+	run->hyperv.u.hcall.result = HV_STATUS_SUCCESS;
+
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
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
+	return 0;
+}
-- 
2.39.0.rc1.256.g54fd8350bd-goog


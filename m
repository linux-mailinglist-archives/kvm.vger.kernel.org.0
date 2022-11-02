Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6466616D1A
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiKBSre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbiKBSrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:47:19 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F122FFF0
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:47:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3697bd55974so166607767b3.15
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nQsYYcvMuiXeimF3iWphBO1Sb/hb6+CelzMx1eKIPSU=;
        b=pw9ymKA5S+Jx9QOYGRBTqhoQ3BHm/jqVqpUFdB6f3MXDLBe+NWv48150aokyYA/QY5
         d9woU8yJZ2UvMNiVZdK8bSGccAhD9cpn/NKf6H9aBHC6ICTybIW8pLbMZ2j5Wz9AsqMg
         m6xZGYnwV5zX2AkwYawsNt+RTJ7ujLPNaFDCM2Amt0PVsjznpFYlc1c+s8QKUm1FWJEo
         r1QkLIR17F0t1ZnVuHMh4LW1oU4+yrXnZIgKlBs3NDw9Mw6mbQlWaiDTygj6FGZzAsXi
         zmV41q7J3DlwhzU8Quc5yNBxYBvV0MP5wYNHJFM98RGoYzY20ZJqdqn3EmdQ8c+LoT17
         XrTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nQsYYcvMuiXeimF3iWphBO1Sb/hb6+CelzMx1eKIPSU=;
        b=wYBiSQfrCkP8d/7HwuBA6jiQdAGs3J0NwgHq0RNEFamFRmU6rwEFNCpB/FZnnmTxrp
         EO6AQz33qbDjILjUiMrJ2jETVi5cPJdOK/NBXXy4nf5E6L/EddfajyT4bXRCjfGBosv4
         UhSQjRxEuSIaEwIzsFroKST/Q4MOwcIX69ECntG3UVZRQHLGPQGwRTdh9YdvkbKZkkkC
         uczHHa1JaRp6TqdbYAYnz4FpCGYXNb0orYFO3b9d6PF+1VJjc76cJYSKVvNtm7NwPBGS
         e0OEBWBTOYOU6UGNJqJBcXTlDRc4NJPrPFPAtnVrxaBE8NuXMK1ICOQ2XxCpKa3j5vE+
         Dqjg==
X-Gm-Message-State: ACrzQf3YHKEA0vCvQLNjXS1QbGL9/e2rU47lbVsRjKGgcysrdDdgxvde
        GcVTQBN577LPGyCfwyOInQfwqqmnNWJ5GA==
X-Google-Smtp-Source: AMsMyM43IUGOPge1t3uHBUGFvgiuKeHmYSedOK6angXrFPIk+JUSfWbqcPJ+DZGNAH4FoO9M8EeZkCunUFxbrA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:c5c4:0:b0:34a:7ab0:7b29 with SMTP id
 h187-20020a0dc5c4000000b0034a7ab07b29mr25379869ywd.294.1667414833843; Wed, 02
 Nov 2022 11:47:13 -0700 (PDT)
Date:   Wed,  2 Nov 2022 11:46:54 -0700
In-Reply-To: <20221102184654.282799-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221102184654.282799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102184654.282799-11-dmatlack@google.com>
Subject: [PATCH v4 10/10] KVM: selftests: Add a test for KVM_CAP_EXIT_ON_EMULATION_FAILURE
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
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

Add a selftest to exercise the KVM_CAP_EXIT_ON_EMULATION_FAILURE
capability.

This capability is also exercised through
smaller_maxphyaddr_emulation_test, but that test requires
allow_smaller_maxphyaddr=Y, which is off by default on Intel when ept=Y
and unconditionally disabled on AMD when npt=Y. This new test ensures
that KVM_CAP_EXIT_ON_EMULATION_FAILURE is exercised independent of
allow_smaller_maxphyaddr.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../x86_64/exit_on_emulation_failure_test.c   | 45 +++++++++++++++++++
 3 files changed, 47 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 053e5d34cd03..bef984e4c39d 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -17,6 +17,7 @@
 /x86_64/cr4_cpuid_sync_test
 /x86_64/debug_regs
 /x86_64/evmcs_test
+/x86_64/exit_on_emulation_failure_test
 /x86_64/fix_hypercall_test
 /x86_64/get_msr_index_features
 /x86_64/kvm_clock_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ab133b731a2d..11a6104e6547 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -81,6 +81,7 @@ TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
+TEST_GEN_PROGS_x86_64 += x86_64/exit_on_emulation_failure_test
 TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
diff --git a/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c b/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
new file mode 100644
index 000000000000..37c61f712fd5
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022, Google LLC.
+ *
+ * Test for KVM_CAP_EXIT_ON_EMULATION_FAILURE.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+
+#include "flds_emulation.h"
+
+#include "test_util.h"
+
+#define MMIO_GPA	0x700000000
+#define MMIO_GVA	MMIO_GPA
+
+static void guest_code(void)
+{
+	/* Execute flds with an MMIO address to force KVM to emulate it. */
+	flds(MMIO_GVA);
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_EXIT_ON_EMULATION_FAILURE));
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vm_enable_cap(vm, KVM_CAP_EXIT_ON_EMULATION_FAILURE, 1);
+	virt_map(vm, MMIO_GVA, MMIO_GPA, 1);
+
+	vcpu_run(vcpu);
+	handle_flds_emulation_failure_exit(vcpu);
+	vcpu_run(vcpu);
+	ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.38.1.273.g43a17bfeac-goog


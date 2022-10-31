Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2993613CCC
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiJaSBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiJaSBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:01:12 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A7B13DE9
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:01:08 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id bw25-20020a056a00409900b0056bdd4f8818so6051527pfb.15
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9T+DYSzhKuAW5tnRCXGXrMAstKaJApTg9bZvi/cvnBo=;
        b=qsaIxiFDsOglF9Hk0ta90m/QM33zJVwn00XeSRyjkYXfoK4BiFr1wNS2W71+i9zNyX
         K69xwONicSjSgYLVFHgK3rbEBZ9FFFp+VzQaTiG1pRH83Vm+qMRxVRWyzvdFGlD8WNMN
         iZyUVbqH/MOT102y9s+3qF5L8lqTLI+Y1NFeUlGACP7rDR3hC0RnvEuRkO79XwWkL5lZ
         73K8sXnc1Dvra6CBtl0l7wFbN/J97R/x3adb+a9dWeILklhCPUDAaSmVQUnbf7qoxNmC
         sf63iLUkvvyug6UfdOvoZ0t8mHIX/axK4nO3IEKZARHyZzxcXd5cDBV4MBI0/11BhfOj
         dghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9T+DYSzhKuAW5tnRCXGXrMAstKaJApTg9bZvi/cvnBo=;
        b=Uc5bSgVmBzGyEVyj8rMILPUibRZ5NLL0zcZpAkWaU4ozVIR3/ZLWtvc24J/GL1dsE5
         MCF1P7y8JInzNuxGDgk5iJYg6AWSF0mfqZRiDDKsVehoVzGAe2nc5MYKfjBL9FIPZtwq
         u/vmDTHMRs7G/0hyksmgGyCHCFImJ8WCqOhnro9UgZifE4eMJoTbp43cy7VeiOTDbU7u
         BwBvTf9vVDepAdJxi9o2OHa6I6p7Ya7nmzahavi9oYI/a3WG7VhREJK+xMnw6mFDmtyx
         x3uN5OivJcKADblWdnaqh4OD5IiJdOGDtxXVVKxvDT5HjBvMC3x2NgEd9P6c7ftoJRsq
         U7XQ==
X-Gm-Message-State: ACrzQf3UxCTdGTW/ic6R8+AETjmA3Wwo0yrh54QvW2DvC+XQv+dGAmmz
        cBsXTsRZjmWNr5p8IXirrS7Iw42MKuUBpg==
X-Google-Smtp-Source: AMsMyM4UJcYmvu9wjnwgT6xsXHzm5az60L7+I+nacdJ2K9l02XSJW7+dcdSOvbcJ/p9rm9luneI2x61SDD0W9A==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:1081:b0:20a:fee1:8f69 with SMTP
 id gj1-20020a17090b108100b0020afee18f69mr682052pjb.0.1667239267351; Mon, 31
 Oct 2022 11:01:07 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:00:45 -0700
In-Reply-To: <20221031180045.3581757-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221031180045.3581757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221031180045.3581757-11-dmatlack@google.com>
Subject: [PATCH v3 10/10] KVM: selftests: Add a test for KVM_CAP_EXIT_ON_EMULATION_FAILURE
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
and unconditionally disabled on AMD when npt=Y. This new test ensures we
exercise KVM_CAP_EXIT_ON_EMULATION_FAILURE independent of
allow_smaller_maxphyaddr.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../x86_64/exit_on_emulation_failure_test.c   | 42 +++++++++++++++++++
 3 files changed, 44 insertions(+)
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
index 000000000000..8e98ad3259de
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
@@ -0,0 +1,42 @@
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
+	assert_exit_for_flds_emulation_failure(vcpu);
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.38.1.273.g43a17bfeac-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F23603523
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 23:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiJRVqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 17:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiJRVqe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 17:46:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878E5B56D6
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p5-20020a25bd45000000b006beafa0d110so14478642ybm.1
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o61Vq7W2J17Qc1HsTAbg5OmkjjMYQQCu/HIoTtKI/Ec=;
        b=iwBa7eC1TZGR7jM9XhzwjMtcQntC10Y6wR9bAcO6cy2fzs/s1VgZzRp8psDY2pr/zR
         LL9SCkdtg8dAZPIu0SVWr9iaP8qaPmMZr0Y6DIaR2xf2DQPN9vVRmoEJKUfffWVesazc
         ojGFBr66X3pZ6Beg3decYu6AaQuu39X8kxt8z9u/iAsQ/akSjf48lImCV1H2zmENU9F2
         VKM+vB/1HAwzT4mg+Xy8lQ/xfdHWoTxCW5Txs5BHHPxRYjkki879IVCVIbArdkRQh3b0
         Zcis7qta8gAZxnX6W65rkUHDqKoyc/RkjZg0oHPG6p/zvuTs/YjE+iW+AlIsBytROBWh
         adRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o61Vq7W2J17Qc1HsTAbg5OmkjjMYQQCu/HIoTtKI/Ec=;
        b=DzwZxz0RVHvGjNXsswNgk6kI+QiwlPatLIMWX/9LACaW9g45DEw89/0LXrXGJ55fNw
         x6+gJ5MH/+5w+VsyGkrBp4KurPCE+5B02H7x+KAJrm2lPKYIQn7+yWU9gWSu8YYHbU9E
         S2rHSeK8r92O04sKhhtclAD3sh85K8qwb1EQFcjT5qjnQsyUiHJA15asHuT6MY4Fp/iZ
         3EoVPl2dwak4fvL6Fw7ClQkj8dP+a3uQP3fbKvOFBx4rfs/Qgx3UdXw3LIqWQhiTwMC0
         qGpRH6n1Om4zeMBwPhWXfE/YhZef0zfKdQT5QELUsd83/u1B0yalUVxxNH3kOR3YW2Wh
         oxjg==
X-Gm-Message-State: ACrzQf19Cy9Xn/BKNABB7hG9lRHN+LcDa6Np+MqmmySjhzMNUL2PV1P8
        y2C7YISuVbTwMiIvyDBMbmfJvk00dkmMuw==
X-Google-Smtp-Source: AMsMyM7XcenLIzI1LLn5FVzDM2wY5B7t3Jd36swoAjDoHs6z6NR23yJVi50BLBPnpAWft8r9h+lKhRx5j6eJrg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:2509:0:b0:6c1:86e1:b8a1 with SMTP id
 l9-20020a252509000000b006c186e1b8a1mr4539453ybl.350.1666129589184; Tue, 18
 Oct 2022 14:46:29 -0700 (PDT)
Date:   Tue, 18 Oct 2022 14:46:12 -0700
In-Reply-To: <20221018214612.3445074-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221018214612.3445074-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221018214612.3445074-9-dmatlack@google.com>
Subject: [PATCH v2 8/8] KVM: selftest: Add a test for KVM_CAP_EXIT_ON_EMULATION_FAILURE
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
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
exercise KVM_CAP_EXIT_ON_EMULATION_FAILURE independet of
allow_smaller_maxphyaddr.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../x86_64/exit_on_emulation_failure_test.c   | 42 +++++++++++++++++++
 3 files changed, 44 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index c484ff164000..22807badd510 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -16,6 +16,7 @@
 /x86_64/cr4_cpuid_sync_test
 /x86_64/debug_regs
 /x86_64/evmcs_test
+/x86_64/exit_on_emulation_failure_test
 /x86_64/fix_hypercall_test
 /x86_64/get_msr_index_features
 /x86_64/kvm_clock_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 90c19e1753f7..55b6f4efa57c 100644
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
2.38.0.413.g74048e4d9e-goog


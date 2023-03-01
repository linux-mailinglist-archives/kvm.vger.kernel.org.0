Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B096A6761
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 06:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjCAFfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 00:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCAFey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 00:34:54 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FA12E822
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:53 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id z1-20020a170902d54100b00198bc9ba4edso6511164plf.21
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677648893;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2BA7krnb0GctuZbm12Ga4THqgKqyBD2b5EGP8+Q0Tr4=;
        b=taih21hgGZ/uf1ZudAl5STMwJpEMdxlNpHTeGjWwTK8/lGLdIAKlNDwu3byFxiz9+w
         NBC2Br9ouCkbBsNJ3jT6H0A9ejeE0lgC+NGPEkolW+4IC7TPVhDHETELELSUk79tfq+3
         Yha5BHQzp/DTrVn6xL89Lld0BkfFNOegn/myY+xA2FLVk6uN8iajN/PQOBQwbXQJeWwv
         F+XpU7zia7xrcOGCmzELpKp0IFdLlNXhGcWWTLW5Hg9CXDPQdzrLtANR3JhewuXftxiA
         ASuuF/E2BAAehcC/nyp5Hv8PU+C4kX9d/9P5FieXOKl+HvdsdLLzRxHo/mSIaiVjXYRj
         HcHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677648893;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2BA7krnb0GctuZbm12Ga4THqgKqyBD2b5EGP8+Q0Tr4=;
        b=TK6f6cjfehwm3iFMJozLMAalgFMYcVIc6PGqWWExijyHhJ7ZsOS5S2uaZlHIP/ULbx
         x6vHp8QwWTaFZ9aPQqOuyXC/Evl2n3lkfEuCVXUjJ4wW38Lxxzmj57mga+nbbr4lLzGy
         piZRJd/HlSdk94gV+s83gd9n9FBfg9+ytKQFEpRpa0WuPRF22tRL23YQnwkt/zpL9kdL
         gsiVeMrntigdFLtIUsRwJTilo6T7UXGJmSHh1f6/QoRSeJjKpP34IzEJslLqXBsJXVqH
         U9rqKamPUr94ohmeqhSfnpj+qSRMegGxsSdYrp5jhKD5GbukjedckRFjdCkmI8oIcmN5
         08FQ==
X-Gm-Message-State: AO0yUKUiCixpugZba0vagrsYIULVMizI4nJoYWwn5tyjoDYxCOZ33Sf0
        LwskuGsEVvJjPcM/haPcNeEFHb2BR9M9hkzii7yyILoRi3kgowWCVlpmTKTDJE7UpRGxjwItWmt
        vAzsNzoQEYhTaejzQ7YTduD2ODqaWQLp0eYbRkA7TCNKIWpl/jtacFfep0eLgULaC0YTx
X-Google-Smtp-Source: AK7set95KB7b7QbhaG6kLjJ3yhw2tNPowlMql/nr3FlWWnRpPUk+mpul36XQEWkyrmQVlacsrPm6TVBHcr2xl2hV
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:374c:b0:230:b842:143e with SMTP
 id ne12-20020a17090b374c00b00230b842143emr2165241pjb.6.1677648892665; Tue, 28
 Feb 2023 21:34:52 -0800 (PST)
Date:   Wed,  1 Mar 2023 05:34:25 +0000
In-Reply-To: <20230301053425.3880773-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230301053425.3880773-9-aaronlewis@google.com>
Subject: [PATCH 8/8] KVM: selftests: Add a selftest for guest prints and
 formatted asserts
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

Add a selftest to demonstrate the use of prints and formatted asserts
in the guest through the ucall framework.

This test isn't intended to be accepted upstream and intentionally
asserts at the end to demonstrate GUEST_ASSERT_FMT().

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/guest_print_test.c   | 100 ++++++++++++++++++
 2 files changed, 101 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/guest_print_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ce577b564616..8f7238da6b84 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -63,6 +63,7 @@ TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
 TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
+TEST_GEN_PROGS_x86_64 += x86_64/guest_print_test
 TEST_GEN_PROGS_x86_64 += x86_64/exit_on_emulation_failure_test
 TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
diff --git a/tools/testing/selftests/kvm/x86_64/guest_print_test.c b/tools/testing/selftests/kvm/x86_64/guest_print_test.c
new file mode 100644
index 000000000000..2ee16a9b3ebf
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/guest_print_test.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A test for GUEST_PRINTF
+ *
+ * Copyright 2022, Google, Inc. and/or its affiliates.
+ */
+
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+#include "processor.h"
+
+static void guest_code(void)
+{
+	const char *s = "from the guest!";
+	uint64_t xcr0;
+
+	set_cr4(get_cr4() | X86_CR4_OSXSAVE);
+	xcr0 = xgetbv(0);
+
+	GUEST_PRINTF("XCR0 = 0x%lx\n", xcr0);
+
+	/*
+	 * Assert that XCR0 is at RESET, and that AVX-512 is not enabled.
+	 * LIBC loves to use AVX-512 instructions when doing string
+	 * formatting, which would be a pain to require of the guest as
+	 * a prerequisite of using print formatting functions.
+	 */
+	GUEST_ASSERT_FMT(xcr0 == XFEATURE_MASK_FP,
+			 "Expected an XCR0 value of 0x%lx, got 0x%lx instead.",
+			 XFEATURE_MASK_FP, xcr0);
+
+	/*
+	 * When %s is used in the string format the guest's version of printf
+	 * uses strnlen(), which will use AVX-512 instructions if routed
+	 * through the LIBC version.  To prevent that from happening strnlen()
+	 * has been added to the string_override functions.
+	 */
+	GUEST_PRINTF("Hello %s\n", s);
+
+	GUEST_SYNC(0);
+
+	/* Demonstrate GUEST_ASSERT_FMT by invoking it. */
+	xsetbv(0, xcr0 | XFEATURE_MASK_SSE);
+	xcr0 = xgetbv(0);
+	GUEST_ASSERT_FMT(xcr0 == XFEATURE_MASK_FP,
+			 "Expected an XCR0 value of 0x%lx, got 0x%lx instead.",
+			 XFEATURE_MASK_FP, xcr0);
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
+
+	while (1) {
+		vcpu_run(vcpu);
+
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Unexpected exit reason: %u (%s),\n",
+			    run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			printf("Hello from the host!\n");
+			break;
+		case UCALL_PRINTF:
+			printf("%s", uc.buffer);
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT_FMT(uc);
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.40.0.rc0.216.gc4246ad0f0-goog


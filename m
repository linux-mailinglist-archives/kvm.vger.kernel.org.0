Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA0D6330CD
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 00:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiKUXlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 18:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiKUXkz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 18:40:55 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2637FD907E
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 15:40:40 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id cj8-20020a056a00298800b0056cee8a0cf8so8192957pfb.9
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 15:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GAeRFu+8abl63zRshHZY/osN79y92OB7KXuZi61y3XQ=;
        b=MLLv1idCPh9KyvRsqZPzhtPOss6do+1xiHmS52+acVjQPMZEPQ0ei9P3p46cgu7lfh
         wEcUYPZLXdqBiuj9VreHa26cWIdt7LmMmHqrdXdOb/KNhCLF/h5cL2ptNfW/qXZXIpRK
         nHZpwbMK3nWaQQQeQ71VD+fTEXvUeXsDjykMCIUT0+Sp5h2Sa/1FW3ftbIN23RHlS+sa
         jH65fakZ6oActmvY/RwB+fly5zz61tIH8DsGYnBDTZSusLUPr6sFDDfDZ8BHEaPtqaUz
         b4UH7gxEStuasTy9MTmDpIUXjXje0Rfp2ajm2jhaSFO+l/WYSm7EFyrtnAjBO962sg8J
         /3IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GAeRFu+8abl63zRshHZY/osN79y92OB7KXuZi61y3XQ=;
        b=h+lPHtuXaci+j+q944PC5rmjjtsCdwHpbBarI6TFCHp6x8e/w7SG/W8loJU/h/xK16
         97/5vXkpngX/37/K1L7DN9XI1a6Qkw4fnm7vOx/Gwfay00hZ53fH0QP0xXhJrEEGrqpu
         sjpfTi0v2FC2tt8kRcClOFgVJqwuoXQLZdkDPowlQRPvu4CItlHFQTEvVa/NbPB/5g5Y
         Kij/C+TVKU9TdbIPNrcelBwkrJmMzY1vke2u2k9e+nQUsUMNpp6uH4Ks+hvMRyoNNx1V
         3CPe4xcZfsWvUAkubVy9WqWaYe+wJMx20auxLDq5jLk5Fabd6ASmSXJjr5POi3mBCmaL
         P/IA==
X-Gm-Message-State: ANoB5pm7V0fF7RcOgzemu9+GSRxfYzDPfnMGToF5WIwwsU+AFgwhLkqi
        4gomTJQRxF153g7lqSO0sIcYCwteClJi
X-Google-Smtp-Source: AA0mqf6p0wPxvV2MjXukDs/xfE0bd5v+GCJUQ+8uoISaecgSAJoVQ6Cm7nsdMxPGt8jbBZZl/I4qddffHuwN
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a62:1812:0:b0:56c:afe:e8bf with SMTP id
 18-20020a621812000000b0056c0afee8bfmr1171889pfy.51.1669074039695; Mon, 21 Nov
 2022 15:40:39 -0800 (PST)
Date:   Mon, 21 Nov 2022 15:40:26 -0800
In-Reply-To: <20221121234026.3037083-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221121234026.3037083-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221121234026.3037083-7-vipinsh@google.com>
Subject: [PATCH v2 6/6] KVM: selftests: Test Hyper-V extended hypercall exit
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
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/include/x86_64/processor.h  |  3 +
 .../kvm/x86_64/hyperv_extended_hypercalls.c   | 94 +++++++++++++++++++
 4 files changed, 99 insertions(+)
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
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 5d310abe6c3f..f167396b887b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -168,6 +168,9 @@ struct kvm_x86_cpu_feature {
 #define X86_FEATURE_KVM_HC_MAP_GPA_RANGE	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 16)
 #define X86_FEATURE_KVM_MIGRATION_CONTROL	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 17)
 
+/* Hyper-V defined paravirt features */
+#define X86_FEATURE_HYPERV_EXTENDED_HYPERCALLS	KVM_X86_CPU_FEATURE(0x40000003, 0, EBX, 20)
+
 /*
  * Same idea as X86_FEATURE_XXX, but X86_PROPERTY_XXX retrieves a multi-bit
  * value/property as opposed to a single-bit feature.  Again, pack the info
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
new file mode 100644
index 000000000000..13c1b03294a4
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
@@ -0,0 +1,94 @@
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
+static void guest_code(vm_vaddr_t in_pg_gpa, vm_vaddr_t out_pg_gpa,
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
+			   X86_FEATURE_HYPERV_EXTENDED_HYPERCALLS)) {
+		print_skip("Extended calls not supported by the kernel");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
+	vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
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
+	ASSERT_EXIT_REASON(vcpu, KVM_EXIT_HYPERV);
+
+	outval = addr_gpa2hva(vm, run->hyperv.u.hcall.params[1]);
+	*outval = EXT_CAPABILITIES;
+	run->hyperv.u.hcall.result = HV_STATUS_SUCCESS;
+
+	vcpu_run(vcpu);
+
+	ASSERT_EXIT_REASON(vcpu, KVM_EXIT_IO);
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
2.38.1.584.g0f3c55d4c2-goog


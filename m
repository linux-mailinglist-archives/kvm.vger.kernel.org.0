Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1499B64319A
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 20:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbiLETPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 14:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbiLETPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 14:15:03 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E4E1F625
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 11:15:02 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id o18-20020a17090aac1200b00219ca917708so3937279pjq.8
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 11:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gqdtlwyr+v8G1ddHR3e3M88XUgYFZaKf3P//fSVXjVQ=;
        b=U9+gDuLRpj8X0uBwWpodlvq9LGm20uFdRJezZJNc0jULKUO19Yg+bRUDdBl5kkl+Tz
         e/UIakZ4CgAQy3x9g8gPWSC/f9X4gTltnxvS8FnVn9kevBCn0nMHHZpgd2FDi/mZRzRs
         4nuV407jmqpoQDdGNwoh8fhraAJ/wpw/VVheyb/LLEUlQWDcDVdZSzCZ4/43wwneYAWQ
         kE6vVJu5SD8NrHgGCgd3wjpcGJzn7kn5kHzF4FI28f3W6BvcSsMgwbgfTRMO3vhOXuDb
         pMExLcWqFhEdjDE0BZ0m1RUC1RBMJWU8gsTMTXwlC2t65iZf26AqEB5zDUnLSt6Uoitf
         kc6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gqdtlwyr+v8G1ddHR3e3M88XUgYFZaKf3P//fSVXjVQ=;
        b=YOsHb+sYRkm5VEjkbrMPrCox1K9iBBTUp5QMu7SkxMQgAL7RTrRv4558qmUuNEm9O+
         pEPydvPi/pO2SXeOTnUfKNHhPseiITdZXDzuGrunp64USaW9TSm2yTKIIJkpEJFaNGkW
         SD1FUFNsiDNLXAZGSnERfKvvOGGGTyK4U+XMamistBveLQS407OWWJ87dXNBaUnfjKor
         /rNGhDBduKWq8Va8xcMRWx1UFPYt0C1MsO1bd+TLJh1X4p2WV8KOzcbQ7e6yXyyTN+If
         C38EuzUXLVGB+2zN+yYDNdygzSqbqw28uCydbD1swFUd1o+1+XGLJeZAl2xt2A6B8M34
         teEw==
X-Gm-Message-State: ANoB5pmQhk2VIx2m+3Nz4tzFkR/NHMxbrqYv6850M1Nza4gbnalIxqpy
        xIHPQwpHlOJFU/5yxXQ9waCtzvQ3TG/k
X-Google-Smtp-Source: AA0mqf5qm/sD7Fvgrx6qOFItxU3U3dSNy18JMdQi2vell6fgv2mxK7W9qMKyoPVhtpsegpoyl/sfwfqmA+1j
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:d086:b0:219:227d:d91f with SMTP id
 k6-20020a17090ad08600b00219227dd91fmr4573263pju.0.1670267701970; Mon, 05 Dec
 2022 11:15:01 -0800 (PST)
Date:   Mon,  5 Dec 2022 11:14:30 -0800
In-Reply-To: <20221205191430.2455108-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221205191430.2455108-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221205191430.2455108-14-vipinsh@google.com>
Subject: [Patch v3 13/13] KVM: selftests: Test Hyper-V extended hypercall exit
 to userspace
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
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
userspace gets the call, update the result and then verify in guest
correct result is received.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
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
index 000000000000..6635f5988d8d
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
2.39.0.rc0.267.gcb52ba06e7-goog


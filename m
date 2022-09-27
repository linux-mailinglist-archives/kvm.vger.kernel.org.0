Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA195ECA26
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 18:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiI0QyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 12:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiI0Qxr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 12:53:47 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12059DDB3
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 09:52:21 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-34558a60c39so96532847b3.16
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 09:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=OSVb/LrkI6NClWCXcoFZkdEyxlIsoga+h/k0Pt6Y3F4=;
        b=rSH5DcVNLrobjpAR9g9gM0iDjVEtB7pMO7jk5o6c7dINt7PffASokS0DBn7A499Cdg
         hSrtuU3pCE+W50Jgj8lLGjWrhtWfnWyHztKOMXN2Aa2XYfGJZ0CzRu1Jb3OwLVSwrXqH
         MMBlnwINuz4mAIyDhhT0tbLABqkax5FlsEyz3X3wTpSiPvhVZM9f5ooVgdBVt3wbSske
         o566E3+iVy5hS0IZarfk4yaFEcHW76J91Vx9JtQ4GJ0dWFX4u3c0A2oR4waloecMs636
         KK8NpitmPZbToasBuyjQSIaJP4yeerBtiN69epHhe6dMekOmUuUO9RQZmJGjyJCR6ofQ
         gZCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=OSVb/LrkI6NClWCXcoFZkdEyxlIsoga+h/k0Pt6Y3F4=;
        b=oXNn9UKyn4Fm2fkl5xB0+Misn0CxJhcG2ddWKcQE9WcEFzCCYyro9tEnDE6b0MMC0Y
         bLnrRrwfRDdSaRa+Zy07T2heZal4LFoC+jr/keDoGNtPPx9hOxumWY969huDp44wu+JA
         Dj4HzuSCviH36KDXYkaXjbK97HORJrcMGD4MCG6vpscvF9sjL9x0AzF7XExNfBVlVV2A
         h+2Vgn8ZDixwQPDYq6WHfVWoRgRUi5RFWRnYZqLYsqLXbVqZ5rgHXd+DIobNr6CmcVvC
         w1nUlg5JNGg+p2lJZY7/gjC/asbpIIKJj6ROjHJRMDjccNq+QHdxtG+f1i/XUWWpWFiH
         nUwQ==
X-Gm-Message-State: ACrzQf1TEf2Mf+A/ZbNm+K9CEjtlwiG3FdE72lEGkkHCl5e+GWApQKfA
        qad6zZwQmRJKoY+8CXtDacXcYSZrt7av2Q==
X-Google-Smtp-Source: AMsMyM4VHovzk6QyvW1Ne3fNqjtBaXdr95G2wfOShrz8BvSX8ZKutY8PvKVWHHBpNNrBtLq+9RhCEyMHc8I1YQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:1908:0:b0:34d:2732:51d9 with SMTP id
 8-20020a811908000000b0034d273251d9mr25712166ywz.487.1664297540031; Tue, 27
 Sep 2022 09:52:20 -0700 (PDT)
Date:   Tue, 27 Sep 2022 09:52:09 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220927165209.930904-1-dmatlack@google.com>
Subject: [PATCH v2] KVM: selftests: Skip tests that require EPT when it is not available
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
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

Skip selftests that require EPT support in the VM when it is not
available. For example, if running on a machine where kvm_intel.ept=N
since KVM does not offer EPT support to guests if EPT is not supported
on the host.

Specifically, this commit causes vmx_dirty_log_test and
dirty_log_perf_test -n to be skipped instead of failing on hosts where
kvm_intel.ept=N.

Signed-off-by: David Matlack <dmatlack@google.com>
---
v2:
 - Use kvm_get_feature_msr() instead of vcpu_get_msr() [Sean]
 - Force each test to call TEST_REQUIRE() [Sean]

v1: https://lore.kernel.org/kvm/20220926171457.532542-1-dmatlack@google.com/


 tools/testing/selftests/kvm/include/x86_64/vmx.h   |  1 +
 .../selftests/kvm/lib/x86_64/perf_test_util.c      |  1 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       | 14 ++++++++++++++
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c      |  1 +
 4 files changed, 17 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 99fa1410964c..0e49fb27698f 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -617,6 +617,7 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 			uint32_t memslot);
 void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
 			    uint64_t addr, uint64_t size);
+bool kvm_cpu_has_ept(void);
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint32_t eptp_memslot);
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c b/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c
index 0f344a7c89c4..e80c182c43ce 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c
@@ -85,6 +85,7 @@ void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
 	int vcpu_id;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+	TEST_REQUIRE(kvm_cpu_has_ept());
 
 	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
 		vmx = vcpu_alloc_vmx(vm, &vmx_gva);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 80a568c439b8..13cd548e5c4c 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -5,6 +5,8 @@
  * Copyright (C) 2018, Google LLC.
  */
 
+#include <asm/msr-index.h>
+
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
@@ -542,6 +544,18 @@ void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
 	__nested_map(vmx, vm, addr, addr, size, PG_LEVEL_1G);
 }
 
+bool kvm_cpu_has_ept(void)
+{
+	uint64_t ctrl;
+
+	ctrl = kvm_get_feature_msr(MSR_IA32_VMX_TRUE_PROCBASED_CTLS) >> 32;
+	if (!(ctrl & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
+		return false;
+
+	ctrl = kvm_get_feature_msr(MSR_IA32_VMX_PROCBASED_CTLS2) >> 32;
+	return ctrl & SECONDARY_EXEC_ENABLE_EPT;
+}
+
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint32_t eptp_memslot)
 {
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
index 2d8c23d639f7..f0456fb031b1 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
@@ -78,6 +78,7 @@ int main(int argc, char *argv[])
 	bool done = false;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+	TEST_REQUIRE(kvm_cpu_has_ept());
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);

base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
prerequisite-patch-id: 2e3661ba8856c29b769499bac525b6943d9284b8
prerequisite-patch-id: 93031262de7b1f7fab1ad31ea5d6ef812c139179
-- 
2.37.3.998.g577e59143f-goog


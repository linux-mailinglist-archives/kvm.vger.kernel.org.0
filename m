Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9CE5EAE71
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 19:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiIZRqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 13:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiIZRpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 13:45:25 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE935AA0B
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 10:15:07 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b18-20020a253412000000b006b0177978eeso6429697yba.21
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 10:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=RE/JsjGUQrnQcj8UCJ57nZMuTC6+7BH+odTmwu7mCmU=;
        b=FCd4QDYVY+vHNTFTwP8iyGxsvsJVAPltiKJ3OEu0MrZmNBUEaNxxFhVs7pJCrGrg+S
         MWMcVMujSoiDwKCqhGPLaBagrFJDzltt6bTDqcKZyfOCeL/CBKfNZAWYjPSaaHwWxIx7
         nMCg/44mshjU6sYdkosaQ4XS00egJBe35p8l+XpQhUCmybq+Ak6i/+z3d8RFVIm9Oq6x
         1L6CVTaORkBBi0Bp8lGTqZgDTZoQMN5ai71iepNRtOT2xJpgZB4PezpfvoculeYWyHVy
         n5eOyUiXaoD9smjwOK8+Di975oHI/Dv6nutGbz9kvsIKFzUBDzaibUU+vMlst+r+uzsc
         hccA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=RE/JsjGUQrnQcj8UCJ57nZMuTC6+7BH+odTmwu7mCmU=;
        b=yY5EK1TXsdkxw4XlDP3Wx1N8fTtx4NykBJ4GbcVze3KfPW0HVneBfAv2lLPVIRERHo
         YLFzkKhHlK29JOa2CdJN9syj4++1ISdsyj3tk/+9m8fEId6rQDidA2zTwx/iYVmpx7EQ
         77pVGC/WcP7c+iyMTpdYWHwWdWUKEDT6NHdtP2D2ht/jq5162FnFbZf5kkAoZdovc/vV
         i+KSN2C63z4bLwSPWmj9Ah0C/vtAFnNNAZPjyt/btMjN8gf5FZxIssAaiYS7Mj6klnsQ
         F8vTJOTmKqxr5kqi+U22wlpaQZPktreeGuy4LGwNlz9BrZrfsKiDL9e58Y+1ykaQR/eD
         qS9A==
X-Gm-Message-State: ACrzQf0rtspfhm0HI/Ypz++NtfK7Ozpx+S6qMV3fUB++SEjzwM7vWHWf
        ktdnz3saB6+i3XZIEPObiKQafTva1VvnTg==
X-Google-Smtp-Source: AMsMyM6AZgOQ7xGY0hhUT0cIgpmSZG8KWpwpDja5mqso+3MSmO9B3zP9pLgQnMyMj9vt2ZV71UCrucaqjdBQew==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:ef4f:0:b0:6ae:f5ce:91e8 with SMTP id
 w15-20020a25ef4f000000b006aef5ce91e8mr22245710ybm.280.1664212506207; Mon, 26
 Sep 2022 10:15:06 -0700 (PDT)
Date:   Mon, 26 Sep 2022 10:14:57 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220926171457.532542-1-dmatlack@google.com>
Subject: [PATCH] KVM: selftests: Skip tests that require EPT when it is not available
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
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

This commit causes vmx_dirty_log_test to be skipped instead of failing
on hosts where kvm_intel.ept=N.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/include/x86_64/vmx.h        |  1 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  | 20 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 99fa1410964c..790c6d1ecb34 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -617,6 +617,7 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 			uint32_t memslot);
 void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
 			    uint64_t addr, uint64_t size);
+bool kvm_vm_has_ept(struct kvm_vm *vm);
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint32_t eptp_memslot);
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 80a568c439b8..d21049c38fc5 100644
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
@@ -542,9 +544,27 @@ void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
 	__nested_map(vmx, vm, addr, addr, size, PG_LEVEL_1G);
 }
 
+bool kvm_vm_has_ept(struct kvm_vm *vm)
+{
+	struct kvm_vcpu *vcpu;
+	uint64_t ctrl;
+
+	vcpu = list_first_entry(&vm->vcpus, struct kvm_vcpu, list);
+	TEST_ASSERT(vcpu, "Cannot determine EPT support without vCPUs.\n");
+
+	ctrl = vcpu_get_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS) >> 32;
+	if (!(ctrl & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
+		return false;
+
+	ctrl = vcpu_get_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS2) >> 32;
+	return ctrl & SECONDARY_EXEC_ENABLE_EPT;
+}
+
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint32_t eptp_memslot)
 {
+	TEST_REQUIRE(kvm_vm_has_ept(vm));
+
 	vmx->eptp = (void *)vm_vaddr_alloc_page(vm);
 	vmx->eptp_hva = addr_gva2hva(vm, (uintptr_t)vmx->eptp);
 	vmx->eptp_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->eptp);

base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
prerequisite-patch-id: 2e3661ba8856c29b769499bac525b6943d9284b8
prerequisite-patch-id: 93031262de7b1f7fab1ad31ea5d6ef812c139179
-- 
2.37.3.998.g577e59143f-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A98453C219
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240402AbiFCAq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240208AbiFCApX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:23 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7823465F
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:22 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z11-20020a17090a468b00b001dc792e8660so3412473pjf.1
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5M+4hKEItsfPOKfockwlyyAZ7LBuR8xnZS1ca9weHs4=;
        b=a8aEFk0sQTnjnegfFASz0toC68xR3x6A7feoHYGWo+SPU4JXsUxiISCoHmbf09fb9/
         vkuV8xGIV8vo4YYCJL22JzjCOCwRgHF6cDZ2/f3O4NVvvijddR5HFQ7ZsAG4gkdx/fTB
         oP0ZYCuY+hO1AOwYQKtgFXhdgO7lsYu03zzr3mPRz441yuOu/IdspNBXh1qqOMIkB/ln
         RfSNdd5sntKkkcx/LvzEQed4EXKzNXF6QEJy8yR9Uq0tJEAfej3aM7IEzZXjc+fgVtSz
         YtZmCS5vKmSJDD2mAfaBWny2TxXxLrHYrt+b7xKg7eQ0gEdXlFnBixth6i+KYMQhPAg9
         dVtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5M+4hKEItsfPOKfockwlyyAZ7LBuR8xnZS1ca9weHs4=;
        b=UbhRdOdN9huW2VLch5z5Cir2VXFA2V2NQBJnvUWQwnBT/uTD8gGWn0QnVd2rv6/dQX
         iKYrw64wyylruMxhFx476EWPmMNLjiKPFbqAtn4wB49P/siroD4K4INvYlZpFMi/MOJp
         orX3HOTlCpFMX8mk84c0OgqWU1O7GovbsEGmBnPJuoIpcVUPEl7BKGadoGBZajtbUfdP
         jt3W7kHOIs+TwPFogCEjulkbuj56rStIaR85/pRquLrK9pKxRddBp0Wx8cwpI+EXZigo
         v1inkNiMsuVfUPFUHQaDE9tqGwgJeX+9KKdwqfTMbj4fSTfsENE6IECRFQ8yy7kQDuhg
         vB8w==
X-Gm-Message-State: AOAM532pa+4hC5k9AVtHIIA1cCmkP2H1uqR3wScfiLWFI9qNOwAvEUQz
        BzrMVm2SZjz3IjFQCvnOeZVmAmExxZs=
X-Google-Smtp-Source: ABdhPJwgkY51U4aRoXTNi3VkSv9oUlR9dBTMl8QutZhPJiEbL+mrxTTX67SpR/M3pzLiZzYSCgYfFIWxxFg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce82:b0:163:f215:e3b6 with SMTP id
 f2-20020a170902ce8200b00163f215e3b6mr7820910plg.51.1654217121609; Thu, 02 Jun
 2022 17:45:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:04 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-58-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 057/144] KVM: selftests: Convert mmu_role_test away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert mmu_role_test to use vm_create_with_one_vcpu() and pass around
a 'struct kvm_vcpu' object instead of using a global VCPU_ID.
Note, this is a "functional" change in the sense that the test now
creates a vCPU with vcpu_id==0 instead of vcpu_id==1.  The non-zero
VCPU_ID was 100% arbitrary and added little to no validation coverage.
If testing non-zero vCPU IDs is desirable for generic tests, that can be
done in the future by tweaking the VM creation helpers.

Opportunistically use vcpu_run() instead of _vcpu_run() plus an open
coded assert that KVM_RUN succeeded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/mmu_role_test.c      | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
index da2325fcad87..809aa0153cee 100644
--- a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
+++ b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
@@ -3,8 +3,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define VCPU_ID			1
-
 #define MMIO_GPA	0x100000000ull
 
 static void guest_code(void)
@@ -25,22 +23,21 @@ static void guest_pf_handler(struct ex_regs *regs)
 static void mmu_role_test(u32 *cpuid_reg, u32 evil_cpuid_val)
 {
 	u32 good_cpuid_val = *cpuid_reg;
+	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 	uint64_t cmd;
-	int r;
 
 	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	run = vcpu_state(vm, VCPU_ID);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
 
 	/* Map 1gb page without a backing memlot. */
 	__virt_pg_map(vm, MMIO_GPA, MMIO_GPA, X86_PAGE_SIZE_1G);
 
-	r = _vcpu_run(vm, VCPU_ID);
+	vcpu_run(vm, vcpu->id);
 
 	/* Guest access to the 1gb page should trigger MMIO. */
-	TEST_ASSERT(r == 0, "vcpu_run failed: %d\n", r);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_MMIO,
 		    "Unexpected exit reason: %u (%s), expected MMIO exit (1gb page w/o memslot)\n",
 		    run->exit_reason, exit_reason_str(run->exit_reason));
@@ -57,7 +54,7 @@ static void mmu_role_test(u32 *cpuid_reg, u32 evil_cpuid_val)
 	 * returns the struct that contains the entry being modified.  Eww.
 	 */
 	*cpuid_reg = evil_cpuid_val;
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+	vcpu_set_cpuid(vm, vcpu->id, kvm_get_supported_cpuid());
 
 	/*
 	 * Add a dummy memslot to coerce KVM into bumping the MMIO generation.
@@ -70,13 +67,12 @@ static void mmu_role_test(u32 *cpuid_reg, u32 evil_cpuid_val)
 
 	/* Set up a #PF handler to eat the RSVD #PF and signal all done! */
 	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vcpu_init_descriptor_tables(vm, vcpu->id);
 	vm_install_exception_handler(vm, PF_VECTOR, guest_pf_handler);
 
-	r = _vcpu_run(vm, VCPU_ID);
-	TEST_ASSERT(r == 0, "vcpu_run failed: %d\n", r);
+	vcpu_run(vm, vcpu->id);
 
-	cmd = get_ucall(vm, VCPU_ID, NULL);
+	cmd = get_ucall(vm, vcpu->id, NULL);
 	TEST_ASSERT(cmd == UCALL_DONE,
 		    "Unexpected guest exit, exit_reason=%s, ucall.cmd = %lu\n",
 		    exit_reason_str(run->exit_reason), cmd);
-- 
2.36.1.255.ge46751e96f-goog


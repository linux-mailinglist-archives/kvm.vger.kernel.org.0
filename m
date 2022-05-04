Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0B751B29E
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240469AbiEDWzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379199AbiEDWye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:34 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D163253A46
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:56 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id r16-20020a17090b051000b001db302efed7so1088365pjz.2
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4VVsw8gfnhvdeThEwym30ZhZrqw6wWwbkKDRVxddGiA=;
        b=o4K0N/Po8AFLVlNIvkHwSP+8V9VsuB5/At8BtBHc5xiUi+L+PG04DQlEfbmlu11Otr
         6t7MhEKCevD9DGBe5b7NobwwDc2+sY7iy28t03UE6ObLba7HceXyh69nRc+mpLFdDj+T
         q4yOeP/0cmwTJKOa3XOYshChB+jgVuxi5tFqwPMdIZGDXf/8LH23qTPIikNpulnVUW12
         fJTl1GfEDktdN2yB/18Ar3guGI5C1jo70512mO8pIjhocDCyEmEv48lUExGVW+DMdAFl
         mpWJd/hoLATzsa7IcSbp1FuUHnRKVOWi9JswsJYnjZIQ+wFD/h+UAU+Ah8O8ys0+E4Jp
         XGPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4VVsw8gfnhvdeThEwym30ZhZrqw6wWwbkKDRVxddGiA=;
        b=XqZeNyhIfU+rh2xrQ5Vb9YBcsP1ec7Ud9XpEldID+8EMIxRD2mIJhDkS975FixaAav
         /mE4Wp+L9rZI+1jIRDq+qHbp4mT6Hqebz7m3mGxBezne/eD9NZTd9KW1S3USm4vGmKb+
         nNIuJT/4/zs2TPykcoIyKxrGljOBfugYgm47jVn3unKg3r/AU0QKNmNmkmAhdOJTYKae
         XLpCuqoKYk62gGJLRpG5p1c3SLEPBJjOGGZwQVkOB7NM/vlwAx2lRLk/Gx79bZ+57AM2
         Xn71uOQRbmFI4GHeC4zMmrEiUnAYn251yg3px+bNEviS4W1VipmQa2Wc4uL60FJUxNO0
         4JBA==
X-Gm-Message-State: AOAM530Hvk7GEIh5cvFBEEIwSzfEapGASccad70H+lYvm/meyTY/6GqB
        0UWRuuIU787HXQWvP0UkT+fY1EE3INg=
X-Google-Smtp-Source: ABdhPJwWSP17Q1MDgVqXdyDw1FJQj7E5Znkn48dx/DArZ7lMT/ah0bnj0Fo/My1FCnFK7+FozEtrv+q1XfA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1784:b0:50d:d8cb:7a4f with SMTP id
 s4-20020a056a00178400b0050dd8cb7a4fmr19712239pfg.23.1651704656268; Wed, 04
 May 2022 15:50:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:55 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-50-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 049/128] KVM: selftests: Convert mmu_role_test away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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
2.36.0.464.gb9c8b46e94-goog


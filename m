Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF5B53C2E1
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240392AbiFCAqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240155AbiFCApX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:23 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4764737A29
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:20 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id z5-20020aa79f85000000b0051baa4e9fb8so3502310pfr.7
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DSBUnWw8fWEElXYGBjXrm88wUvjgXnsj+86R4SkOT0s=;
        b=L+KTRQvkc5WtE0n1dHRlE0Oz69S8WphDnarPbKpfUKLrwfStXEsCflOdIzYVv93Gbr
         cuj3yRWTBkCBVkFdl/eboc88X4F5WL2f7vMUVRGUXYd0PXXjOWj5yRCG/5Aab8ALZ374
         IwJB4T/n78wLajQwj0YBn95HkgV0mFrnLdTU2RNaPCfIKhTHu48ClVWeIMzzgI7Fz05P
         GwLGGr43MuZ7ercC7DqpO9dP4wJ892SI8Pf1uXEDYnTOwytoeaRcOEGGFv34DoslO8iS
         WcwyOSxKcjlJlt9re2J9oL/9hPe675W9Zrms7CxVqJ6hHoH4aifYHg3xoJVQz4QHcs1o
         WYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DSBUnWw8fWEElXYGBjXrm88wUvjgXnsj+86R4SkOT0s=;
        b=qzcD/NRB1HNE6dlKIDxqSJMSIB5rNcOKtnMikjPYzvyazDI8PLfhkawb8FMJvD86d2
         IP79vO72GTorNrk1mjbyEIQVANxe2SLI1o9RGaFcy4ToXW7OnADwnY8t5VetsjKyFUzu
         O00koRidwQZDvT8j/RW0VlTPe3shxRejpyP3r6PuEawzchySbPj5evCIIlJLKljHLKV6
         pC3fX/Z91gLc7mJ5Y+rVhR2qVS9kuAx/sMIM6HvUYyi91K/a0C3bXwJwBeLPHKFu5IIR
         rWvD1SvH4FQqSRmOyCAX7djoEm46wET0ptVjs8DVK7RdYio4zcece5/gRc/j5y/wyNq9
         7sEA==
X-Gm-Message-State: AOAM530VKbKYnlnnHT5YoNRnO5CbJ/jWTG9Awj9EdYYnJpUmj2PRFTJz
        LQ1M24cz1DUaJjDanN69G9aBRnEqWLU=
X-Google-Smtp-Source: ABdhPJxlKuvS5/8eTnTynHN7LMIefNnT056jHuTG8dyjeFayb3K2IOLSjn1g3mfNi/tkZGMEwKuZNpfmyiY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:10cc:b0:506:e0:d6c3 with SMTP id
 d12-20020a056a0010cc00b0050600e0d6c3mr7810109pfu.33.1654217119681; Thu, 02
 Jun 2022 17:45:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:03 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-57-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 056/144] KVM: selftests: Convert vmx_tsc_adjust_test away
 from VCPU_ID
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert vmx_tsc_adjust_test to use vm_create_with_one_vcpu() and pass
around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.
Note, this is a "functional" change in the sense that the test now
creates a vCPU with vcpu_id==0 instead of vcpu_id==5.  The non-zero
VCPU_ID was 100% arbitrary and added little to no validation coverage.
If testing non-zero vCPU IDs is desirable for generic tests, that can be
done in the future by tweaking the VM creation helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c      | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
index 19b35c607dc6..29699d7c16c3 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
@@ -32,8 +32,6 @@
 #define MSR_IA32_TSC_ADJUST 0x3b
 #endif
 
-#define VCPU_ID		5
-
 #define TSC_ADJUST_VALUE (1ll << 32)
 #define TSC_OFFSET_VALUE -(1ll << 48)
 
@@ -127,26 +125,27 @@ static void report(int64_t val)
 int main(int argc, char *argv[])
 {
 	vm_vaddr_t vmx_pages_gva;
+	struct kvm_vcpu *vcpu;
 
 	nested_vmx_check_supported();
 
-	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, (void *) l1_guest_code);
 
 	/* Allocate VMX pages and shared descriptors (vmx_pages). */
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
+	vcpu_args_set(vm, vcpu->id, 1, vmx_pages_gva);
 
 	for (;;) {
-		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+		volatile struct kvm_run *run = vcpu->run;
 		struct ucall uc;
 
-		vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
 			    run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_ABORT:
 			TEST_FAIL("%s", (const char *)uc.args[0]);
 			/* NOT REACHED */
-- 
2.36.1.255.ge46751e96f-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA3751B361
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379519AbiEDW5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379457AbiEDW4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:56:05 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16E054FB9
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:40 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id c202-20020a621cd3000000b0050dd228152aso822624pfc.11
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Cc4J6i9fQqsf9PEcQ2aqKfhVhnlneBcoWg904bFOlIk=;
        b=RICS/+YLRLgXa9sejev5VMnYQdOTUMhmWYPp1u7x36wuWtNgelxFYFIUGxFLmktpPL
         IEIXIFUX146ZPdiroBTy8KCDYjTKq+nT7MybmErCJqwAdZVhxGQ4gZzB2j7xeqJEeAtH
         j4cGOPXqR2pq4Of7gKQEYkL3qBKlExMN4LHxYVpMk/pZ7b+7HWJpbhy81/Iy5dSwd9kd
         Nk+fsg7E78B16HdPUbKeZPYu8YNcHnXnpoxPxaONiRJE8sTnEnLe/cdxK9Oy6xejNJXF
         M5LS6TpW1MIEV8XLL+vLxMbgibeVt+JDz3AlmLTMY48GOqtdtw5Ku7xDRjnFbXNcMz95
         7mAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Cc4J6i9fQqsf9PEcQ2aqKfhVhnlneBcoWg904bFOlIk=;
        b=evUEXbzmqKTscoquJ64wJr5GHzETtP6olEH/ndar/tJjFItDujLuOChWIJCIZ5aHiL
         WegrBt0tJWslTnku65+UD3iI+cNeT4x+piVNeZgGbfpBj65+0Kl3Z7K7FQy856jHyMmG
         9fgs22jCY3gXBmUmSVLPfRfWzlNrdCQLUMZ4DqKgI2J/5b3XNBy7PdkRhI+OyKXVA/Oz
         1MGl3GOQFFzUukQgFAQ9NywCGGULIIKLFfYTKmPdFSHLD1LSE/yUn7HVdLKm+8RgVJVh
         c76ezDG50df6vDkuyQiTMarSxWByR0rBhtOpXM855unnTkZcjQBuZDXDcliRf6tEu/q4
         MG1w==
X-Gm-Message-State: AOAM53270YO2Mj/HJNiGIo0vNGM8Bxecack6XIKOXCf4yHo76f6JzxVP
        pCETRtCCXh648B7RXALC7F5QS19xhAQ=
X-Google-Smtp-Source: ABdhPJx5QjtYlYVFRAR7oQtm+mWtkE95fcKSe8vNH+X3mK9TSN8yw9YmHnvq/TyLMiotoHYP5uWPkgkUcJ0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1f0b:b0:50a:8181:fecb with SMTP id
 be11-20020a056a001f0b00b0050a8181fecbmr22839456pfb.12.1651704700406; Wed, 04
 May 2022 15:51:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:21 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-76-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 075/128] KVM: selftests: Convert amx_test away from VCPU_ID
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

Convert amx_test to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.o

Opportunistically use vcpu_run() instead of _vcpu_run(), the test expects
KVM_RUN to succeed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 33 +++++++++----------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 2f01247da0b5..7755fe8fcffb 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -25,7 +25,6 @@
 # error This test is 64-bit only
 #endif
 
-#define VCPU_ID				0
 #define X86_FEATURE_XSAVE		(1 << 26)
 #define X86_FEATURE_OSXSAVE		(1 << 27)
 
@@ -319,6 +318,7 @@ int main(int argc, char *argv[])
 	struct kvm_cpuid_entry2 *entry;
 	struct kvm_regs regs1, regs2;
 	bool amx_supported = false;
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	struct kvm_x86_state *state;
@@ -331,7 +331,7 @@ int main(int argc, char *argv[])
 	vm_xsave_req_perm(XSTATE_XTILE_DATA_BIT);
 
 	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	entry = kvm_get_supported_cpuid_entry(1);
 	if (!(entry->ecx & X86_FEATURE_XSAVE)) {
@@ -350,12 +350,12 @@ int main(int argc, char *argv[])
 		xsave_restore_size = entry->ecx;
 	}
 
-	run = vcpu_state(vm, VCPU_ID);
-	vcpu_regs_get(vm, VCPU_ID, &regs1);
+	run = vcpu->run;
+	vcpu_regs_get(vm, vcpu->id, &regs1);
 
 	/* Register #NM handler */
 	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vcpu_init_descriptor_tables(vm, vcpu->id);
 	vm_install_exception_handler(vm, NM_VECTOR, guest_nm_handler);
 
 	/* amx cfg for guest_code */
@@ -369,16 +369,16 @@ int main(int argc, char *argv[])
 	/* xsave data for guest_code */
 	xsavedata = vm_vaddr_alloc_pages(vm, 3);
 	memset(addr_gva2hva(vm, xsavedata), 0, 3 * getpagesize());
-	vcpu_args_set(vm, VCPU_ID, 3, amx_cfg, tiledata, xsavedata);
+	vcpu_args_set(vm, vcpu->id, 3, amx_cfg, tiledata, xsavedata);
 
 	for (stage = 1; ; stage++) {
-		_vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Stage %d: unexpected exit reason: %u (%s),\n",
 			    stage, run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
 				  __FILE__, uc.args[1]);
@@ -403,7 +403,7 @@ int main(int argc, char *argv[])
 				 * size subtract 8K amx size.
 				 */
 				amx_offset = xsave_restore_size - NUM_TILES*TILE_SIZE;
-				state = vcpu_save_state(vm, VCPU_ID);
+				state = vcpu_save_state(vm, vcpu->id);
 				void *amx_start = (void *)state->xsave + amx_offset;
 				void *tiles_data = (void *)addr_gva2hva(vm, tiledata);
 				/* Only check TMM0 register, 1 tile */
@@ -424,22 +424,21 @@ int main(int argc, char *argv[])
 			TEST_FAIL("Unknown ucall %lu", uc.cmd);
 		}
 
-		state = vcpu_save_state(vm, VCPU_ID);
+		state = vcpu_save_state(vm, vcpu->id);
 		memset(&regs1, 0, sizeof(regs1));
-		vcpu_regs_get(vm, VCPU_ID, &regs1);
+		vcpu_regs_get(vm, vcpu->id, &regs1);
 
 		kvm_vm_release(vm);
 
 		/* Restore state in a new VM.  */
-		kvm_vm_restart(vm);
-		vm_vcpu_add(vm, VCPU_ID);
-		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
-		vcpu_load_state(vm, VCPU_ID, state);
-		run = vcpu_state(vm, VCPU_ID);
+		vcpu = vm_recreate_with_one_vcpu(vm);
+		vcpu_set_cpuid(vm, vcpu->id, kvm_get_supported_cpuid());
+		vcpu_load_state(vm, vcpu->id, state);
+		run = vcpu->run;
 		kvm_x86_state_cleanup(state);
 
 		memset(&regs2, 0, sizeof(regs2));
-		vcpu_regs_get(vm, VCPU_ID, &regs2);
+		vcpu_regs_get(vm, vcpu->id, &regs2);
 		TEST_ASSERT(!memcmp(&regs1, &regs2, sizeof(regs2)),
 			    "Unexpected register values after vcpu_load_state; rdi: %lx rsi: %lx",
 			    (ulong) regs2.rdi, (ulong) regs2.rsi);
-- 
2.36.0.464.gb9c8b46e94-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0710F53C202
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241140AbiFCAu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240432AbiFCArO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:14 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FF037A91
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:08 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id m5-20020a17090a4d8500b001e0cfe135c7so3410605pjh.3
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GH/SGjUQcTjXdPIk3f8SiBnr6WQtoymdX7cMO8jw2AQ=;
        b=CBbY9FSQSRI+5Nn15KhNkyfRuLRo58UWX22DGfkDjiiJnmycelDYHAzOkQsiq3GPpc
         /p4cgBIQ+1kzR48V6qINZ9JCxyFdetlKt0WGOu8VH39jRv3iQpf/O5DtFtMY56FFwTu/
         VFE6JNA3V3lTh2KmbxCkCMMBii5hwVBmmMF6D0x5HWu4/vm98EgFIxPNUmRjMidUiS5i
         XhlLWt1UVUpPQD0mNeYt0LWPsstXzRb/tR1wJZ7Jadyq/4ce7JrPoHJ6BJWw2lRS2sew
         bWF5CbyHfZMqoja0T+39N2B2EVrfccyWnZVdgB2JYZVssxGfEuX9jyHPs1AcJmSAJeIB
         +u/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GH/SGjUQcTjXdPIk3f8SiBnr6WQtoymdX7cMO8jw2AQ=;
        b=KMJiRPWMT3rPjKHuCLlLsLXFlQuGKDFu5vREPmfZKCm/CtRt76g9ThaE1Y8+ovtzGG
         scxdzpeoPhesbpqCtOjog09tXBg8to6UQf+j2XZvumoFSHqgrpLofgyDpMJ2bTelwS05
         75/yOYK7635s4Qjarl7NYkDSnBNQz/Et+6wtOGFLd18ydBgVHAt72LumWmresnCYEF3b
         YCWJcLbIEdHOSCcHCy6E38AGxQAZQSX1mg6OVLbMBgSpXxnyoH6ZDScZHSs8fDKZBBoi
         cRAL6MDHhV8/SqZHTMuwYWDIKwubmokP37IXUvoPQckfq1xzu3LXRTz+XY2YIatbiN3Y
         79lg==
X-Gm-Message-State: AOAM533XuvabevYbjt+GR1h+3sKvlfcBQb6AfDGFEg8SJfSTtoUt4u+J
        M8rWv3hbdqEuyPnsjrdP1EZacJJfxvs=
X-Google-Smtp-Source: ABdhPJz7U8mxfzh6uUWZ2K6x0L/59/Op9I3blF4IuR/EjFB4AN9ky9KVEOyH9b1b4oweqVzgozaUPfseQTM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:11c4:b0:15f:14df:a919 with SMTP id
 q4-20020a17090311c400b0015f14dfa919mr7581193plh.21.1654217167835; Thu, 02 Jun
 2022 17:46:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:30 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-84-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 083/144] KVM: selftests: Convert amx_test away from VCPU_ID
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
2.36.1.255.ge46751e96f-goog


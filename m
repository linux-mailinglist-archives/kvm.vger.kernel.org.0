Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32DC51B351
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379472AbiEDW4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379386AbiEDWyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:54 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB8853A64
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:59 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id i188-20020a636dc5000000b003c143f97bc2so1342157pgc.11
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=lmx6VYDYlzO+No2WJfy7zjV6NsiyPkW+VRxJ/N9LEIo=;
        b=VBIw4luXJfro5fky397gWb1NvoeZfr0UzJj7OR3cncvthmWJZXRKeTfUHve+SVKzAV
         Guxn/l/fOUZOpMw74s4GVSK11cWSGRjhoh9w3mp5SxvMLxvmCABA4xVDraSQW06pxn/Y
         E6liVEpkWeGTq6C8QhUSICut5flo12TVHglm5FVPPWa3kUwAdNT24hoAcBvI26lC5/Cs
         s94NWqj7GgygPwH5Voj1lywUB2XTA2SayLQ7RRC3jG1p/I6CXEBV+8/ujQAUciDI7Pu9
         bOSuWOatPYkeESwLA+LpCLbFG/w4otOpReSEWopjlJfEs5kufXKNcomTmNNrPq0IEb3t
         XAnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=lmx6VYDYlzO+No2WJfy7zjV6NsiyPkW+VRxJ/N9LEIo=;
        b=yJsHJW/n6rXDzgjzeY1kzopSlkizAU/LlARu+ncO4JQPQ7B/9kHHfuygOmKOg20Zay
         rRGxrAeUajoLZI7K9ZoGhMJ6MIuZSnIRM1ORVu/4XhzhTfjXG2PzQBUuRwHYn9hQ0t9N
         JJFKJ/JzgwGcqDmOnEy1Ktk4djG+MZ1taOxGoERS1/4d6Siq5Iyuc3chAc/phkFzS6mB
         XmFheQLFuD3XEE+Ugiw0d3NDTrnNdBm/QtezPc9fflCV02k0fZprsyOH8+xpseDXomxb
         7Kx8ePV3fvwRZyDQ4+uxnfUpsyx3ua6G1xe6bmW2gljihkAxjtCti+Tc1MkJBxbZuUaJ
         PH8w==
X-Gm-Message-State: AOAM531VHZtPqWm6LOX8aB3h1vCaZHViEIOzp4QceezmWbtOFK0p7tSP
        KRwtKrN6J4RCeP9ePDDa7IWqqA9St5Q=
X-Google-Smtp-Source: ABdhPJy+vA1SD/lT6UPFbleU26/wLUKvND0BfPKSK9HSk8J1bYwInODiVY7KpGMz8d+sYgfnEe+9E9w6XxQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:11d1:b0:1db:d99f:62cc with SMTP id
 gv17-20020a17090b11d100b001dbd99f62ccmr2230222pjb.200.1651704659207; Wed, 04
 May 2022 15:50:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:57 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-52-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 051/128] KVM: selftests: Convert smm_test away from VCPU_ID
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

Convert smm_test to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note, this
is a "functional" change in the sense that the test now creates a vCPU
with vcpu_id==0 instead of vcpu_id==1.  The non-zero VCPU_ID was 100%
arbitrary and added little to no validation coverage.  If testing
non-zero vCPU IDs is desirable for generic tests, that can be done in the
future by tweaking the VM creation helpers.

Opportunistically use vcpu_run() instead of _vcpu_run(), the test expects
KVM_RUN to succeed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/smm_test.c | 37 +++++++++----------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index dd2c1522ab90..36165b774a28 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -19,8 +19,6 @@
 #include "vmx.h"
 #include "svm_util.h"
 
-#define VCPU_ID	      1
-
 #define SMRAM_SIZE 65536
 #define SMRAM_MEMSLOT ((1 << 16) | 1)
 #define SMRAM_PAGES (SMRAM_SIZE / PAGE_SIZE)
@@ -116,22 +114,23 @@ static void guest_code(void *arg)
 	sync_with_host(DONE);
 }
 
-void inject_smi(struct kvm_vm *vm)
+void inject_smi(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_events events;
 
-	vcpu_events_get(vm, VCPU_ID, &events);
+	vcpu_events_get(vcpu->vm, vcpu->id, &events);
 
 	events.smi.pending = 1;
 	events.flags |= KVM_VCPUEVENT_VALID_SMM;
 
-	vcpu_events_set(vm, VCPU_ID, &events);
+	vcpu_events_set(vcpu->vm, vcpu->id, &events);
 }
 
 int main(int argc, char *argv[])
 {
 	vm_vaddr_t nested_gva = 0;
 
+	struct kvm_vcpu *vcpu;
 	struct kvm_regs regs;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
@@ -139,9 +138,9 @@ int main(int argc, char *argv[])
 	int stage, stage_reported;
 
 	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-	run = vcpu_state(vm, VCPU_ID);
+	run = vcpu->run;
 
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, SMRAM_GPA,
 				    SMRAM_MEMSLOT, SMRAM_PAGES, 0);
@@ -152,7 +151,7 @@ int main(int argc, char *argv[])
 	memcpy(addr_gpa2hva(vm, SMRAM_GPA) + 0x8000, smi_handler,
 	       sizeof(smi_handler));
 
-	vcpu_set_msr(vm, VCPU_ID, MSR_IA32_SMBASE, SMRAM_GPA);
+	vcpu_set_msr(vm, vcpu->id, MSR_IA32_SMBASE, SMRAM_GPA);
 
 	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
 		if (nested_svm_supported())
@@ -164,17 +163,17 @@ int main(int argc, char *argv[])
 	if (!nested_gva)
 		pr_info("will skip SMM test with VMX enabled\n");
 
-	vcpu_args_set(vm, VCPU_ID, 1, nested_gva);
+	vcpu_args_set(vm, vcpu->id, 1, nested_gva);
 
 	for (stage = 1;; stage++) {
-		_vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Stage %d: unexpected exit reason: %u (%s),\n",
 			    stage, run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
 		memset(&regs, 0, sizeof(regs));
-		vcpu_regs_get(vm, VCPU_ID, &regs);
+		vcpu_regs_get(vm, vcpu->id, &regs);
 
 		stage_reported = regs.rax & 0xff;
 
@@ -191,7 +190,7 @@ int main(int argc, char *argv[])
 		 * return from it. Do not perform save/restore while in SMM yet.
 		 */
 		if (stage == 8) {
-			inject_smi(vm);
+			inject_smi(vcpu);
 			continue;
 		}
 
@@ -200,15 +199,15 @@ int main(int argc, char *argv[])
 		 * during L2 execution.
 		 */
 		if (stage == 10)
-			inject_smi(vm);
+			inject_smi(vcpu);
 
-		state = vcpu_save_state(vm, VCPU_ID);
+		state = vcpu_save_state(vm, vcpu->id);
 		kvm_vm_release(vm);
-		kvm_vm_restart(vm);
-		vm_vcpu_add(vm, VCPU_ID);
-		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
-		vcpu_load_state(vm, VCPU_ID, state);
-		run = vcpu_state(vm, VCPU_ID);
+
+		vcpu = vm_recreate_with_one_vcpu(vm);
+		vcpu_set_cpuid(vm, vcpu->id, kvm_get_supported_cpuid());
+		vcpu_load_state(vm, vcpu->id, state);
+		run = vcpu->run;
 		kvm_x86_state_cleanup(state);
 	}
 
-- 
2.36.0.464.gb9c8b46e94-goog


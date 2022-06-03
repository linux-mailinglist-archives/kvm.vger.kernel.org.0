Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC1453C2E8
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240548AbiFCAss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240367AbiFCAqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:46:22 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A05D37A3D
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:03 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q13-20020a65624d000000b003fa74c57243so3042109pgv.19
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=HgYYf1LZj3Pxp/woJQ4WmwXirUtLeO88klFNgII9A6M=;
        b=rlfb1woa39KK5XdBDBt7vJY13J1rJndFM3Y7QvRcMvZtLApa9e6QV5v6uzBwvWYr0O
         kYFNyooL4p8exP/q15qA7GrwehtkVotxytSmXECCLdTVg6Aw01GYcjp+h/kbPEIED1Nj
         qFHZbvaQchkABanJBPty4ofHmPrMsFqF/wAigKP0AOdTN5gm3FsMbpekd6yphZSrOTRW
         l/F0w3cU1KQHb5TT0OxjLfw9Q/wXN0cgzQT2hkBYvWth5X28BLTSqHBfRt+oeigVZUN2
         Ilrj37ejMGEFGQ+iMAu5I43ZGjW9OBgtRL2DrCpLQjLFsrm3HICj4gmuCGBj/QoechDI
         NZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=HgYYf1LZj3Pxp/woJQ4WmwXirUtLeO88klFNgII9A6M=;
        b=xuUY47F9oFV8LAHQ7e3f8nnekobLgjKc1QdB98h7NqPq+3aKVScv5suDLrAAbGfWTg
         BR6HTrbn7yqVobT1Z3tTn+RFxtUiGQ/8UcScy2NYRKAjYLjIaDCKZuyJ3UCWZhGYVg9t
         FU+KS6UccFMjxmzBVEjBUfiAn+wmbx7Jzf0JHslp/ctebdbxEogWFTCoqGfbivlgo3k4
         B5k+WdzGjZJCaamW2cL3LwX2FLf6ZUJS5eKl2fECLiEHvltNazTfEHcwvVJy9RI4hMlJ
         C+Fxttr7c77rfOcfRnn+AkvOOSUMJbBV1Ruk2r1aZq9pduw8wYBuK0e98R8qPmvI2JfY
         hAKQ==
X-Gm-Message-State: AOAM530h1y2TS1DhV+lPqBi+kTeFqDe+61Czja8fFF9nPgNtd5WU/DXs
        Vcxbn6IaBGUKioNRaAFuynweCzbPDQs=
X-Google-Smtp-Source: ABdhPJwEqaGPjVCVc/bPJzER8f738JoZbRX/l2ZGkTrqL/TLXL7AdAaeU7Je8n/g8ZpjG/J3rBciV68drLk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:32d2:b0:166:3747:8465 with SMTP id
 i18-20020a17090332d200b0016637478465mr7514130plr.143.1654217162681; Thu, 02
 Jun 2022 17:46:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:27 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-81-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 080/144] KVM: selftests: Convert emulator_error_test away
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert emulator_error_test to use vm_create_with_one_vcpu() and pass
around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note,
this is a "functional" change in the sense that the test now creates a vCPU
with vcpu_id==0 instead of vcpu_id==5.  The non-zero VCPU_ID was 100%
arbitrary and added little to no validation coverage.  If testing non-zero
vCPU IDs is desirable for generic tests, that can be done in the future by
tweaking the VM creation helpers.

Opportunistically use vcpu_run() instead of _vcpu_run() with an open
coded assert that KVM_RUN succeeded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/emulator_error_test.c          | 65 ++++++++-----------
 1 file changed, 28 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index 9c156f9cfa15..08a95dab3a6b 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -11,7 +11,6 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
-#define VCPU_ID	   1
 #define MAXPHYADDR 36
 
 #define MEM_REGION_GVA	0x0000123456789000
@@ -27,14 +26,6 @@ static void guest_code(void)
 	GUEST_DONE();
 }
 
-static void run_guest(struct kvm_vm *vm)
-{
-	int rc;
-
-	rc = _vcpu_run(vm, VCPU_ID);
-	TEST_ASSERT(rc == 0, "vcpu_run failed: %d\n", rc);
-}
-
 /*
  * Accessors to get R/M, REG, and Mod bits described in the SDM vol 2,
  * figure 2-2 "Table Interpretation of ModR/M Byte (C8H)".
@@ -56,9 +47,9 @@ static bool is_flds(uint8_t *insn_bytes, uint8_t insn_size)
 	       GET_RM(insn_bytes[1]) != 0x5;
 }
 
-static void process_exit_on_emulation_error(struct kvm_vm *vm)
+static void process_exit_on_emulation_error(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_run *run = vcpu->run;
 	struct kvm_regs regs;
 	uint8_t *insn_bytes;
 	uint8_t insn_size;
@@ -92,50 +83,49 @@ static void process_exit_on_emulation_error(struct kvm_vm *vm)
 			 * contained an flds instruction that is 2-bytes in
 			 * length (ie: no prefix, no SIB, no displacement).
 			 */
-			vcpu_regs_get(vm, VCPU_ID, &regs);
+			vcpu_regs_get(vcpu->vm, vcpu->id, &regs);
 			regs.rip += 2;
-			vcpu_regs_set(vm, VCPU_ID, &regs);
+			vcpu_regs_set(vcpu->vm, vcpu->id, &regs);
 		}
 	}
 }
 
-static void do_guest_assert(struct kvm_vm *vm, struct ucall *uc)
+static void do_guest_assert(struct ucall *uc)
 {
 	TEST_FAIL("%s at %s:%ld", (const char *)uc->args[0], __FILE__,
 		  uc->args[1]);
 }
 
-static void check_for_guest_assert(struct kvm_vm *vm)
+static void check_for_guest_assert(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
 	struct ucall uc;
 
-	if (run->exit_reason == KVM_EXIT_IO &&
-	    get_ucall(vm, VCPU_ID, &uc) == UCALL_ABORT) {
-		do_guest_assert(vm, &uc);
+	if (vcpu->run->exit_reason == KVM_EXIT_IO &&
+	    get_ucall(vcpu->vm, vcpu->id, &uc) == UCALL_ABORT) {
+		do_guest_assert(&uc);
 	}
 }
 
-static void process_ucall_done(struct kvm_vm *vm)
+static void process_ucall_done(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
-	check_for_guest_assert(vm);
+	check_for_guest_assert(vcpu);
 
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 		    "Unexpected exit reason: %u (%s)",
 		    run->exit_reason,
 		    exit_reason_str(run->exit_reason));
 
-	TEST_ASSERT(get_ucall(vm, VCPU_ID, &uc) == UCALL_DONE,
+	TEST_ASSERT(get_ucall(vcpu->vm, vcpu->id, &uc) == UCALL_DONE,
 		    "Unexpected ucall command: %lu, expected UCALL_DONE (%d)",
 		    uc.cmd, UCALL_DONE);
 }
 
-static uint64_t process_ucall(struct kvm_vm *vm)
+static uint64_t process_ucall(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
@@ -143,14 +133,14 @@ static uint64_t process_ucall(struct kvm_vm *vm)
 		    run->exit_reason,
 		    exit_reason_str(run->exit_reason));
 
-	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	switch (get_ucall(vcpu->vm, vcpu->id, &uc)) {
 	case UCALL_SYNC:
 		break;
 	case UCALL_ABORT:
-		do_guest_assert(vm, &uc);
+		do_guest_assert(&uc);
 		break;
 	case UCALL_DONE:
-		process_ucall_done(vm);
+		process_ucall_done(vcpu);
 		break;
 	default:
 		TEST_ASSERT(false, "Unexpected ucall");
@@ -163,6 +153,7 @@ int main(int argc, char *argv[])
 {
 	struct kvm_cpuid_entry2 *entry;
 	struct kvm_cpuid2 *cpuid;
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	uint64_t gpa, pte;
 	uint64_t *hva;
@@ -171,20 +162,20 @@ int main(int argc, char *argv[])
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
-
 	if (!kvm_check_cap(KVM_CAP_SMALLER_MAXPHYADDR)) {
 		printf("module parameter 'allow_smaller_maxphyaddr' is not set.  Skipping test.\n");
 		return 0;
 	}
 
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
 	cpuid = kvm_get_supported_cpuid();
 
 	entry = kvm_get_supported_cpuid_index(0x80000008, 0);
 	entry->eax = (entry->eax & 0xffffff00) | MAXPHYADDR;
 	set_cpuid(cpuid, entry);
 
-	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	vcpu_set_cpuid(vm, vcpu->id, cpuid);
 
 	rc = kvm_check_cap(KVM_CAP_EXIT_ON_EMULATION_FAILURE);
 	TEST_ASSERT(rc, "KVM_CAP_EXIT_ON_EMULATION_FAILURE is unavailable");
@@ -199,14 +190,14 @@ int main(int argc, char *argv[])
 	virt_map(vm, MEM_REGION_GVA, MEM_REGION_GPA, 1);
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 	memset(hva, 0, PAGE_SIZE);
-	pte = vm_get_page_table_entry(vm, VCPU_ID, MEM_REGION_GVA);
-	vm_set_page_table_entry(vm, VCPU_ID, MEM_REGION_GVA, pte | (1ull << 36));
+	pte = vm_get_page_table_entry(vm, vcpu->id, MEM_REGION_GVA);
+	vm_set_page_table_entry(vm, vcpu->id, MEM_REGION_GVA, pte | (1ull << 36));
 
-	run_guest(vm);
-	process_exit_on_emulation_error(vm);
-	run_guest(vm);
+	vcpu_run(vm, vcpu->id);
+	process_exit_on_emulation_error(vcpu);
+	vcpu_run(vm, vcpu->id);
 
-	TEST_ASSERT(process_ucall(vm) == UCALL_DONE, "Expected UCALL_DONE");
+	TEST_ASSERT(process_ucall(vcpu) == UCALL_DONE, "Expected UCALL_DONE");
 
 	kvm_vm_free(vm);
 
-- 
2.36.1.255.ge46751e96f-goog


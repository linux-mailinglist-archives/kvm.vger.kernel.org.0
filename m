Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC392543F5D
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 00:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbiFHWpa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 18:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiFHWpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 18:45:24 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BFD2506EB
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 15:45:23 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h190-20020a636cc7000000b003fd5d5452cfso6356662pgc.8
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 15:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bMeLzNqhuJTdm9rwRjOvyOW1NIK0cUo/UeP8lk5uQQk=;
        b=RTci0xO1Vz2BmgyGPbxy8QXpFkdH+ggaqzqeLo4Jix+zXRb8DSVHAG43bnDq8z+FjZ
         bFtvXGvgyTmMJqGChfSf9JkiBxoWo52u2B4fyD46Hf3h2Kv8F2ZqO3b2p9F/Fz+JbLEi
         DcIyW7+KfXcZ2YsECuT7Hnpwk46+HBI9Vb0J51B7pvaOLcfOP28Bt8FXxWzwXvZlybCQ
         2HMeoUC/bQmTMKV8gRc5xK1QWfRNwiql78g//a4YiSbgKmLIQrdOwjXXMel1JUrTYixs
         qY1RYUKbttjV9CpnXX67owvnSRxwvouR2wp9oVazITMEj7gqt7ZUBvC/dwZ73ZPTf5E4
         v2rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bMeLzNqhuJTdm9rwRjOvyOW1NIK0cUo/UeP8lk5uQQk=;
        b=AmNEZXR7WlqX2qjZdbjWIRrICo1I/01zdfnDDL3VItULe02PVpk6h53SQgwaUqMj5J
         DoQFqBwi7tlwFJOy0UqYo0m0qewXrg13+oH9OIcZ6FmYDww6XjaIDfjaUqA6uIEF0GD2
         WabyYOYlHpeCOr1onjwtK46lMaBWItHA6LQOWJwynD71O78AeNJEgnBdzGqMxon6R4oO
         b95DWm44XSf0QyefLEeESq7uP95tfm2YtWZqQkJocFPcaaeRdcvQ7opbjtws/+eT3HQC
         pMHg11/ixtFgizMiGddcw+uiy8ExtZffQj63dS6Sn3WF1bi1UcNPj4Bh5sWLK4ypt+8t
         eUTg==
X-Gm-Message-State: AOAM5321EfdoNaxr0OLivbCPUS+Wh7Pzm+Hcmn5UAhulJTb05sNEN/Ny
        qZm4Xq7p1sqV3HdoGTTk7ftgKci6aqg=
X-Google-Smtp-Source: ABdhPJxAB+hWrNgX9ONVVmSW2qP7kFPqjUnpslfLFOoCOsg6wzg7WB0oSO0Faqf1QF6xWquQUnOPTmoaVoE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1946:b0:4fe:309f:d612 with SMTP id
 s6-20020a056a00194600b004fe309fd612mr104701730pfk.10.1654728322537; Wed, 08
 Jun 2022 15:45:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 22:45:13 +0000
In-Reply-To: <20220608224516.3788274-1-seanjc@google.com>
Message-Id: <20220608224516.3788274-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220608224516.3788274-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 2/5] KVM: selftests: Add x86-64 support for exception fixup
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Add x86-64 support for exception fixup on single instructions, without
forcing tests to install their own fault handlers.  Use registers r9-r11
to flag the instruction as "safe" and pass fixup/vector information,
i.e. introduce yet another flavor of fixup (versus the kernel's in-memory
tables and KUT's per-CPU area) to take advantage of KVM sefltests being
64-bit only.

Using only registers avoids the need to allocate fixup tables, ensure
FS or GS base is valid for the guest, ensure memory is mapped into the
guest, etc..., and also reduces the potential for recursive faults due to
accessing memory.

Providing exception fixup trivializes tests that just want to verify that
an instruction faults, e.g. no need to track start/end using global
labels, no need to install a dedicated handler, etc...

Deliberately do not support #DE in exception fixup so that the fixup glue
doesn't need to account for a fault with vector == 0, i.e. the vector can
also indicate that a fault occurred.  KVM injects #DE only for esoteric
emulation scenarios, i.e. there's very, very little value in testing #DE.
Force any test that wants to generate #DEs to install its own handler(s).

Use kvm_pv_test as a guinea pig for the new fixup, as it has a very
straightforward use case of wanting to verify that RDMSR and WRMSR fault.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 74 +++++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 17 ++++
 .../selftests/kvm/x86_64/kvm_pv_test.c        | 82 ++++---------------
 3 files changed, 109 insertions(+), 64 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 3fd3d58148c2..15aa076765a5 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -15,6 +15,8 @@
 #include <asm/msr-index.h>
 #include <asm/prctl.h>
 
+#include <linux/stringify.h>
+
 #include "../kvm_util.h"
 
 #define NMI_VECTOR		0x02
@@ -750,6 +752,78 @@ void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu);
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 			void (*handler)(struct ex_regs *));
 
+/* If a toddler were to say "abracadabra". */
+#define KVM_EXCEPTION_MAGIC 0xabacadabaull
+
+/*
+ * KVM selftest exception fixup uses registers to coordinate with the exception
+ * handler, versus the kernel's in-memory tables and KVM-Unit-Tests's in-memory
+ * per-CPU data.  Using only registers avoids having to map memory into the
+ * guest, doesn't require a valid, stable GS.base, and reduces the risk of
+ * for recursive faults when accessing memory in the handler.  The downside to
+ * using registers is that it restricts what registers can be used by the actual
+ * instruction.  But, selftests are 64-bit only, making register* pressure a
+ * minor concern.  Use r9-r11 as they are volatile, i.e. don't need* to be saved
+ * by the callee, and except for r11 are not implicit parameters to any
+ * instructions.  Ideally, fixup would use r8-r10 and thus avoid implicit
+ * parameters entirely, but Hyper-V's hypercall ABI uses r8 and testing Hyper-V
+ * is higher priority than testing non-faulting SYSCALL/SYSRET.
+ *
+ * Note, the fixup handler deliberately does not handle #DE, i.e. the vector
+ * is guaranteed to be non-zero on fault.
+ *
+ * REGISTER INPUTS:
+ * r9  = MAGIC
+ * r10 = RIP
+ * r11 = new RIP on fault
+ *
+ * REGISTER OUTPUTS:
+ * r9  = exception vector (non-zero)
+ */
+#define KVM_ASM_SAFE(insn)					\
+	"mov $" __stringify(KVM_EXCEPTION_MAGIC) ", %%r9\n\t"	\
+	"lea 1f(%%rip), %%r10\n\t"				\
+	"lea 2f(%%rip), %%r11\n\t"				\
+	"1: " insn "\n\t"					\
+	"mov $0, %[vector]\n\t"					\
+	"jmp 3f\n\t"						\
+	"2:\n\t"						\
+	"mov  %%r9b, %[vector]\n\t"				\
+	"3:\n\t"
+
+#define KVM_ASM_SAFE_OUTPUTS(v)	[vector] "=qm"(v)
+#define KVM_ASM_SAFE_CLOBBERS	"r9", "r10", "r11"
+
+#define kvm_asm_safe(insn, inputs...)			\
+({							\
+	uint8_t vector;					\
+							\
+	asm volatile(KVM_ASM_SAFE(insn)			\
+		     : KVM_ASM_SAFE_OUTPUTS(vector)	\
+		     : inputs				\
+		     : KVM_ASM_SAFE_CLOBBERS);		\
+	vector;						\
+})
+
+static inline uint8_t rdmsr_safe(uint32_t msr, uint64_t *val)
+{
+	uint8_t vector;
+	uint32_t a, d;
+
+	asm volatile(KVM_ASM_SAFE("rdmsr")
+		     : "=a"(a), "=d"(d), KVM_ASM_SAFE_OUTPUTS(vector)
+		     : "c"(msr)
+		     : KVM_ASM_SAFE_CLOBBERS);
+
+	*val = (uint64_t)a | ((uint64_t)d << 32);
+	return vector;
+}
+
+static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
+{
+	return kvm_asm_safe("wrmsr", "A"(val), "c"(msr));
+}
+
 uint64_t vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 				 uint64_t vaddr);
 void vm_set_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 5cb73b2f9978..95db8eebcc1d 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1079,6 +1079,20 @@ static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
 	e->offset2 = addr >> 32;
 }
 
+
+static bool kvm_fixup_exception(struct ex_regs *regs)
+{
+	if (regs->r9 != KVM_EXCEPTION_MAGIC || regs->rip != regs->r10)
+		return false;
+
+	if (regs->vector == DE_VECTOR)
+		return false;
+
+	regs->rip = regs->r11;
+	regs->r9 = regs->vector;
+	return true;
+}
+
 void kvm_exit_unexpected_vector(uint32_t value)
 {
 	ucall(UCALL_UNHANDLED, 1, value);
@@ -1094,6 +1108,9 @@ void route_exception(struct ex_regs *regs)
 		return;
 	}
 
+	if (kvm_fixup_exception(regs))
+		return;
+
 	kvm_exit_unexpected_vector(regs->vector);
 }
 
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 7ab61f3f2a20..37875e864030 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -12,55 +12,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-extern unsigned char rdmsr_start;
-extern unsigned char rdmsr_end;
-
-static u64 do_rdmsr(u32 idx)
-{
-	u32 lo, hi;
-
-	asm volatile("rdmsr_start: rdmsr;"
-		     "rdmsr_end:"
-		     : "=a"(lo), "=c"(hi)
-		     : "c"(idx));
-
-	return (((u64) hi) << 32) | lo;
-}
-
-extern unsigned char wrmsr_start;
-extern unsigned char wrmsr_end;
-
-static void do_wrmsr(u32 idx, u64 val)
-{
-	u32 lo, hi;
-
-	lo = val;
-	hi = val >> 32;
-
-	asm volatile("wrmsr_start: wrmsr;"
-		     "wrmsr_end:"
-		     : : "a"(lo), "c"(idx), "d"(hi));
-}
-
-static int nr_gp;
-
-static void guest_gp_handler(struct ex_regs *regs)
-{
-	unsigned char *rip = (unsigned char *)regs->rip;
-	bool r, w;
-
-	r = rip == &rdmsr_start;
-	w = rip == &wrmsr_start;
-	GUEST_ASSERT(r || w);
-
-	nr_gp++;
-
-	if (r)
-		regs->rip = (uint64_t)&rdmsr_end;
-	else
-		regs->rip = (uint64_t)&wrmsr_end;
-}
-
 struct msr_data {
 	uint32_t idx;
 	const char *name;
@@ -89,14 +40,16 @@ static struct msr_data msrs_to_test[] = {
 
 static void test_msr(struct msr_data *msr)
 {
+	uint64_t ignored;
+	uint8_t vector;
+
 	PR_MSR(msr);
-	do_rdmsr(msr->idx);
-	GUEST_ASSERT(READ_ONCE(nr_gp) == 1);
 
-	nr_gp = 0;
-	do_wrmsr(msr->idx, 0);
-	GUEST_ASSERT(READ_ONCE(nr_gp) == 1);
-	nr_gp = 0;
+	vector = rdmsr_safe(msr->idx, &ignored);
+	GUEST_ASSERT_1(vector == GP_VECTOR, vector);
+
+	vector = wrmsr_safe(msr->idx, 0);
+	GUEST_ASSERT_1(vector == GP_VECTOR, vector);
 }
 
 struct hcall_data {
@@ -156,12 +109,6 @@ static void pr_hcall(struct ucall *uc)
 	pr_info("testing hcall: %s (%lu)\n", hc->name, hc->nr);
 }
 
-static void handle_abort(struct ucall *uc)
-{
-	TEST_FAIL("%s at %s:%ld", (const char *)uc->args[0],
-		  __FILE__, uc->args[1]);
-}
-
 static void enter_guest(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
@@ -181,7 +128,9 @@ static void enter_guest(struct kvm_vcpu *vcpu)
 			pr_hcall(&uc);
 			break;
 		case UCALL_ABORT:
-			handle_abort(&uc);
+			TEST_FAIL("%s at %s:%ld, vector = %lu",
+				  (const char *)uc.args[0], __FILE__,
+				  uc.args[1], uc.args[2]);
 			return;
 		case UCALL_DONE:
 			return;
@@ -191,6 +140,7 @@ static void enter_guest(struct kvm_vcpu *vcpu)
 
 int main(void)
 {
+	struct kvm_cpuid_entry2 *entry;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
@@ -200,11 +150,15 @@ int main(void)
 
 	vcpu_enable_cap(vcpu, KVM_CAP_ENFORCE_PV_FEATURE_CPUID, 1);
 
-	vcpu_clear_cpuid_entry(vcpu, KVM_CPUID_FEATURES);
+	entry = vcpu_get_cpuid_entry(vcpu, KVM_CPUID_FEATURES);
+	entry->eax = 0;
+	entry->ebx = 0;
+	entry->ecx = 0;
+	entry->edx = 0;
+	vcpu_set_cpuid(vcpu);
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
-	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
 
 	enter_guest(vcpu);
 	kvm_vm_free(vm);
-- 
2.36.1.255.ge46751e96f-goog


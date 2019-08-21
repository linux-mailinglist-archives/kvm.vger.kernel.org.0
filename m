Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF75978AD
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 13:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfHUL5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 07:57:53 -0400
Received: from foss.arm.com ([217.140.110.172]:56478 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbfHUL5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 07:57:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5E1F28;
        Wed, 21 Aug 2019 04:57:51 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D32B63F718;
        Wed, 21 Aug 2019 04:57:50 -0700 (PDT)
Subject: Re: [PATCH 16/59] KVM: arm64: nv: Save/Restore vEL2 sysregs
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-17-marc.zyngier@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ced39c72-010e-4cff-cece-e2f96b89c953@arm.com>
Date:   Wed, 21 Aug 2019 12:57:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-17-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/21/19 10:38 AM, Marc Zyngier wrote:
> From: Andre Przywara <andre.przywara@arm.com>
>
> Whenever we need to restore the guest's system registers to the CPU, we
> now need to take care of the EL2 system registers as well. Most of them
> are accessed via traps only, but some have an immediate effect and also
> a guest running in VHE mode would expect them to be accessible via their
> EL1 encoding, which we do not trap.
>
> Split the current __sysreg_{save,restore}_el1_state() functions into
> handling common sysregs, then differentiate between the guest running in
> vEL2 and vEL1.
>
> For vEL2 we write the virtual EL2 registers with an identical format directly
> into their EL1 counterpart, and translate the few registers that have a
> different format for the same effect on the execution when running a
> non-VHE guest guest hypervisor.
>
>   [ Commit message reworked and many bug fixes applied by Marc Zyngier
>     and Christoffer Dall. ]
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  arch/arm64/kvm/hyp/sysreg-sr.c | 160 +++++++++++++++++++++++++++++++--
>  1 file changed, 153 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 62866a68e852..2abb9c3ff24f 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -22,6 +22,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
> +#include <asm/kvm_nested.h>
>  
>  /*
>   * Non-VHE: Both host and guest must save everything.
> @@ -51,11 +52,9 @@ static void __hyp_text __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
>  	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
>  }
>  
> -static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
> +static void __hyp_text __sysreg_save_vel1_state(struct kvm_cpu_context *ctxt)
>  {
> -	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
>  	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(SYS_SCTLR);
> -	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
>  	ctxt->sys_regs[CPACR_EL1]	= read_sysreg_el1(SYS_CPACR);
>  	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg_el1(SYS_TTBR0);
>  	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg_el1(SYS_TTBR1);
> @@ -69,14 +68,58 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  	ctxt->sys_regs[CONTEXTIDR_EL1]	= read_sysreg_el1(SYS_CONTEXTIDR);
>  	ctxt->sys_regs[AMAIR_EL1]	= read_sysreg_el1(SYS_AMAIR);
>  	ctxt->sys_regs[CNTKCTL_EL1]	= read_sysreg_el1(SYS_CNTKCTL);
> -	ctxt->sys_regs[PAR_EL1]		= read_sysreg(par_el1);
> -	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
>  
>  	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
>  	ctxt->gp_regs.elr_el1		= read_sysreg_el1(SYS_ELR);
>  	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(SYS_SPSR);
>  }
>  
> +static void __sysreg_save_vel2_state(struct kvm_cpu_context *ctxt)
> +{
> +	ctxt->sys_regs[ESR_EL2]		= read_sysreg_el1(SYS_ESR);
> +	ctxt->sys_regs[AFSR0_EL2]	= read_sysreg_el1(SYS_AFSR0);
> +	ctxt->sys_regs[AFSR1_EL2]	= read_sysreg_el1(SYS_AFSR1);
> +	ctxt->sys_regs[FAR_EL2]		= read_sysreg_el1(SYS_FAR);
> +	ctxt->sys_regs[MAIR_EL2]	= read_sysreg_el1(SYS_MAIR);
> +	ctxt->sys_regs[VBAR_EL2]	= read_sysreg_el1(SYS_VBAR);
> +	ctxt->sys_regs[CONTEXTIDR_EL2]	= read_sysreg_el1(SYS_CONTEXTIDR);
> +	ctxt->sys_regs[AMAIR_EL2]	= read_sysreg_el1(SYS_AMAIR);
> +
> +	/*
> +	 * In VHE mode those registers are compatible between EL1 and EL2,
> +	 * and the guest uses the _EL1 versions on the CPU naturally.
> +	 * So we save them into their _EL2 versions here.
> +	 * For nVHE mode we trap accesses to those registers, so our
> +	 * _EL2 copy in sys_regs[] is always up-to-date and we don't need
> +	 * to save anything here.
> +	 */
> +	if (__vcpu_el2_e2h_is_set(ctxt)) {
> +		ctxt->sys_regs[SCTLR_EL2]	= read_sysreg_el1(SYS_SCTLR);
> +		ctxt->sys_regs[CPTR_EL2]	= read_sysreg_el1(SYS_CPACR);
> +		ctxt->sys_regs[TTBR0_EL2]	= read_sysreg_el1(SYS_TTBR0);
> +		ctxt->sys_regs[TTBR1_EL2]	= read_sysreg_el1(SYS_TTBR1);
> +		ctxt->sys_regs[TCR_EL2]		= read_sysreg_el1(SYS_TCR);
> +		ctxt->sys_regs[CNTHCTL_EL2]	= read_sysreg_el1(SYS_CNTKCTL);
> +	}

This can break guests that run with VHE on, then disable it. I stumbled into
this while working on kvm-unit-tests, which uses TTBR0 for the translation
tables. Let's consider the following scenario:

1. Guest sets HCR_EL2.E2H
2. Guest programs translation tables in TTBR0_EL1, which should reflect in
TTBR0_EL2.
3. Guest enabled MMU and does stuff.
4. Guest disables MMU and clears HCR_EL2.E2H
5. Guest turns MMU on. It doesn't change TTBR0_EL2, because it will use the same
translation tables as when running with E2H set.
6. The vcpu gets scheduled out. E2H is not set, so the value that the guest
programmed in hardware TTBR0_EL1 won't be copied to virtual TTBR0_EL2.
7. The vcpu gets scheduled back in. KVM will write the reset value for virtual
TTBR0_EL2 (which is 0x0).
8. The guest hangs.

I think this is actually a symptom of a deeper issue. When E2H is cleared, the
values that the guest wrote to the EL1 registers aren't immediately reflected in
the virtual EL2 registers, as it happens on real hardware. Instead, some of the
hardware values from the EL1 registers are copied to the corresponding EL2
registers on the next vcpu_put, which happens at a later time.

I am thinking that something like this will fix the issues (it did fix disabling
VHE in kvm-unit-tests):

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d896113f1f8..f2b5a39762d0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -333,7 +333,8 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
                 * to reverse-translate virtual EL2 system registers for a
                 * non-VHE guest hypervisor.
                 */
-               __vcpu_sys_reg(vcpu, reg) = val;
+               if (reg != HCR_EL2)
+                       __vcpu_sys_reg(vcpu, reg) = val;
 
                switch (reg) {
                case ELR_EL2:
@@ -370,7 +371,17 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int
reg)
                return;
 
 memory_write:
-        __vcpu_sys_reg(vcpu, reg) = val;
+       if (reg == HCR_EL2 && vcpu_el2_e2h_is_set(vcpu) && !(val & HCR_E2H)) {
+               preempt_disable();
+               kvm_arch_vcpu_put(vcpu);
+
+               __vcpu_sys_reg(vcpu, reg) = val;
+
+               kvm_arch_vcpu_load(vcpu, smp_processor_id());
+               preempt_enable();
+       } else {
+                __vcpu_sys_reg(vcpu, reg) = val;
+       }
 }
 
 /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */

I don't think there's any need to convert EL1 registers to their non-vhe EL2
format because of how RES0/RES1 is defined in the architecture glossary (ARM DDI
0487E.a, page 7893 for RES0 and 7894 for RES1):

"If a bit is RES0 only in some contexts:
A read of the bit must return the value last successfully written to the bit, by
either a direct or an indirect write, regardless of the use of the register when
the bit was written
[..]
While the use of the register is such that the bit is described as RES0, the
value of the bit must have no effect on the operation of the PE, other than
determining the value read back from that bit, unless this Manual explicitly
defines additional properties for the bit"

We have the translate functions that should take care of converting the non-vhe
EL2 format to the hardware EL1 format.

As an aside, the diff looks weird because the vcpu_write_sys_reg is very
complex, there are a LOT of exit points from the function, and the register
value is written twice for some registers. I think it's worth considering making
the function simpler, maybe splitting it into two separate functions, one for
EL2 registers, one for regular registers.

Here's the kvm-unit-tests diff that I used to spot the bug. It's very far from
being correct, but the test is able to finish with the fix (it hangs otherwise).
You can apply it on top of 2130fd4154ad ("tscdeadline_latency: Check condition
first before loop"):

diff --git a/arm/cstart64.S b/arm/cstart64.S
index b0e8baa1a23a..01357b3b116b 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -51,6 +51,18 @@ start:
     b    1b
 
 1:
+    mrs    x4, CurrentEL
+    cmp    x4, CurrentEL_EL2
+    b.ne    1f
+    mrs    x4, mpidr_el1
+    msr    vmpidr_el2, x4
+    mrs    x4, midr_el1
+    msr    vpidr_el2, x4
+    ldr    x4, =(HCR_EL2_TGE | HCR_EL2_E2H)
+    msr    hcr_el2, x4
+    isb
+
+1:
     /* set up stack */
     mov    x4, #1
     msr    spsel, x4
@@ -101,6 +113,18 @@ get_mmu_off:
 
 .globl secondary_entry
 secondary_entry:
+    mrs    x0, CurrentEL
+    cmp    x0, CurrentEL_EL2
+    b.ne    1f
+    mrs    x0, mpidr_el1
+    msr    vmpidr_el2, x0
+    mrs    x0, midr_el1
+    msr    vpidr_el2, x0
+    ldr    x0, =(HCR_EL2_TGE | HCR_EL2_E2H)
+    msr    hcr_el2, x0
+    isb
+
+1:
     /* Enable FP/ASIMD */
     mov    x0, #(3 << 20)
     msr    cpacr_el1, x0
@@ -194,6 +218,33 @@ asm_mmu_enable:
 
     ret
 
+asm_mmu_enable_hyp:
+       ic      iallu
+       tlbi    alle2is
+       dsb     ish
+
+        /* TCR */
+       ldr     x1, =TCR_EL2_RES1 |                     \
+                    TCR_T0SZ(VA_BITS) |                \
+                    TCR_TG0_64K |                      \
+                    TCR_IRGN0_WBWA | TCR_ORGN0_WBWA |  \
+                    TCR_SH0_IS
+       mrs     x2, id_aa64mmfr0_el1
+       bfi     x1, x2, #TCR_EL2_PS_SHIFT, #3
+       msr     tcr_el2, x1
+
+       /* Same MAIR and TTBR0 as in VHE mode */
+
+       /* SCTLR */
+       ldr     x1, =SCTLR_EL2_RES1 |                   \
+                    SCTLR_EL2_C |                      \
+                    SCTLR_EL2_I |                      \
+                    SCTLR_EL2_M
+       msr     sctlr_el2, x1
+       isb
+
+       ret
+
 .globl asm_mmu_disable
 asm_mmu_disable:
     mrs    x0, sctlr_el1
@@ -202,6 +253,18 @@ asm_mmu_disable:
     isb
     ret
 
+.globl asm_disable_vhe
+asm_disable_vhe:
+    str     x30, [sp, #-16]!
+
+    bl      asm_mmu_disable
+    msr     hcr_el2, xzr
+    isb
+    bl      asm_mmu_enable_hyp
+
+    ldr     x30, [sp], #16
+    ret
+
 /*
  * Vectors
  * Adapted from arch/arm64/kernel/entry.S
diff --git a/arm/selftest.c b/arm/selftest.c
index 28a17f7a7531..68a18036221b 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -287,6 +287,12 @@ static void user_psci_system_off(struct pt_regs *regs,
unsigned int esr)
 {
     __user_psci_system_off();
 }
+
+extern void asm_disable_vhe(void);
+static void check_el2(void)
+{
+    asm_disable_vhe();
+}
 #endif
 
 static void check_vectors(void *arg __unused)
@@ -369,6 +375,10 @@ int main(int argc, char **argv)
         report("PSCI version", psci_check());
         on_cpus(cpu_report, NULL);
 
+    } else if (strcmp(argv[1], "el2") == 0) {
+
+        check_el2();
+
     } else {
         printf("Unknown subtest\n");
         abort();
diff --git a/lib/arm/psci.c b/lib/arm/psci.c
index c3d399064ae3..5ef1c0386ce1 100644
--- a/lib/arm/psci.c
+++ b/lib/arm/psci.c
@@ -16,7 +16,7 @@ int psci_invoke(unsigned long function_id, unsigned long arg0,
         unsigned long arg1, unsigned long arg2)
 {
     asm volatile(
-        "hvc #0"
+        "smc #0"
     : "+r" (function_id)
     : "r" (arg0), "r" (arg1), "r" (arg2));
     return function_id;
diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
index 045a3ce12645..6b80e34dda0c 100644
--- a/lib/arm64/asm/pgtable-hwdef.h
+++ b/lib/arm64/asm/pgtable-hwdef.h
@@ -95,18 +95,42 @@
 /*
  * TCR flags.
  */
-#define TCR_TxSZ(x)        (((UL(64) - (x)) << 16) | ((UL(64) - (x)) << 0))
-#define TCR_IRGN_NC        ((UL(0) << 8) | (UL(0) << 24))
-#define TCR_IRGN_WBWA        ((UL(1) << 8) | (UL(1) << 24))
-#define TCR_IRGN_WT        ((UL(2) << 8) | (UL(2) << 24))
-#define TCR_IRGN_WBnWA        ((UL(3) << 8) | (UL(3) << 24))
-#define TCR_IRGN_MASK        ((UL(3) << 8) | (UL(3) << 24))
-#define TCR_ORGN_NC        ((UL(0) << 10) | (UL(0) << 26))
-#define TCR_ORGN_WBWA        ((UL(1) << 10) | (UL(1) << 26))
-#define TCR_ORGN_WT        ((UL(2) << 10) | (UL(2) << 26))
-#define TCR_ORGN_WBnWA        ((UL(3) << 10) | (UL(3) << 26))
-#define TCR_ORGN_MASK        ((UL(3) << 10) | (UL(3) << 26))
-#define TCR_SHARED        ((UL(3) << 12) | (UL(3) << 28))
+#define TCR_T0SZ(x)        ((UL(64) - (x)) << 0)
+#define TCR_T1SZ(x)        ((UL(64) - (x)) << 16)
+#define TCR_TxSZ(x)        (TCR_T0SZ(x) | TCR_T1SZ(x))
+#define TCR_IRGN0_NC        (UL(0) << 8)
+#define TCR_IRGN1_NC        (UL(0) << 24)
+#define TCR_IRGN_NC        (TCR_IRGN0_NC | TCR_IRGN1_NC)
+#define TCR_IRGN0_WBWA        (UL(1) << 8)
+#define TCR_IRGN1_WBWA        (UL(1) << 24)
+#define TCR_IRGN_WBWA        (TCR_IRGN0_WBWA | TCR_IRGN1_WBWA)
+#define TCR_IRGN0_WT        (UL(2) << 8)
+#define TCR_IRGN1_WT        (UL(2) << 24)
+#define TCR_IRGN_WT        (TCR_IRGN0_WT | TCR_IRGN1_WT)
+#define TCR_IRGN0_WBnWA        (UL(3) << 8)
+#define TCR_IRGN1_WBnWA        (UL(3) << 24)
+#define TCR_IRGN_WBnWA        (TCR_IRGN0_WBnWA | TCR_IRGN1_WBnWA)
+#define TCR_IRGN0_MASK        (UL(3) << 8)
+#define TCR_IRGN1_MASK        (UL(3) << 24)
+#define TCR_IRGN_MASK        (TCR_IRGN0_MASK | TCR_IRGN1_MASK)
+#define TCR_ORGN0_NC        (UL(0) << 10)
+#define TCR_ORGN1_NC        (UL(0) << 26)
+#define TCR_ORGN_NC        (TCR_ORGN0_NC | TCR_ORGN1_NC)
+#define TCR_ORGN0_WBWA        (UL(1) << 10)
+#define TCR_ORGN1_WBWA        (UL(1) << 26)
+#define TCR_ORGN_WBWA        (TCR_ORGN0_WBWA | TCR_ORGN1_WBWA)
+#define TCR_ORGN0_WT        (UL(2) << 10)
+#define TCR_ORGN1_WT        (UL(2) << 26)
+#define TCR_ORGN_WT        (TCR_ORGN0_WT | TCR_ORGN1_WT)
+#define TCR_ORGN0_WBnWA        (UL(3) << 8)
+#define TCR_ORGN1_WBnWA        (UL(3) << 24)
+#define TCR_ORGN_WBnWA        (TCR_ORGN0_WBnWA | TCR_ORGN1_WBnWA)
+#define TCR_ORGN0_MASK        (UL(3) << 10)
+#define TCR_ORGN1_MASK        (UL(3) << 26)
+#define TCR_ORGN_MASK        (TCR_ORGN0_MASK | TCR_ORGN1_MASK)
+#define TCR_SH0_IS        (UL(3) << 12)
+#define TCR_SH1_IS        (UL(3) << 28)
+#define TCR_SHARED        (TCR_SH0_IS | TCR_SH1_IS)
 #define TCR_TG0_4K        (UL(0) << 14)
 #define TCR_TG0_64K        (UL(1) << 14)
 #define TCR_TG0_16K        (UL(2) << 14)
@@ -116,6 +140,9 @@
 #define TCR_ASID16        (UL(1) << 36)
 #define TCR_TBI0        (UL(1) << 37)
 
+#define TCR_EL2_RES1        ((UL(1) << 31) | (UL(1) << 23))
+#define TCR_EL2_PS_SHIFT    16
+
 /*
  * Memory types available.
  */
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 1d9223f728a5..b2136acda743 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -16,6 +16,16 @@
 #define SCTLR_EL1_A    (1 << 1)
 #define SCTLR_EL1_M    (1 << 0)
 
+#define HCR_EL2_TGE    (1 << 27)
+#define HCR_EL2_E2H    (1 << 34)
+
+#define SCTLR_EL2_RES1    ((UL(3) << 28) | (UL(3) << 22) |    \
+            (UL(1) << 18) | (UL(1) << 16) |        \
+            (UL(1) << 11) | (UL(3) << 4))
+#define SCTLR_EL2_I    SCTLR_EL1_I
+#define SCTLR_EL2_C    SCTLR_EL1_C
+#define SCTLR_EL2_M    SCTLR_EL1_M
+
 #ifndef __ASSEMBLY__
 #include <asm/ptrace.h>
 #include <asm/esr.h>


To run it:

lkvm run -f selftest.flat -c 1 -m 128 -p el2 --nested --irqchip gicv3 --console
serial

Thanks,
Alex

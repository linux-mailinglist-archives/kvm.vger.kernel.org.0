Return-Path: <kvm+bounces-34280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA5BA9FA2A5
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 22:49:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22390164689
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 21:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73DB1DC05F;
	Sat, 21 Dec 2024 21:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bVMEC9Y+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D180149C50;
	Sat, 21 Dec 2024 21:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734817746; cv=none; b=N40sWI4Zh26pt40D9X9WDyQ1kB/oFV9Y9q67WWApZbW/str+BXf3QfnkKRblKgCaHvzLs0T8HD1N20mrAxC7GrZjCHoiUhrQM/6aBRNagdrmtQsT8w+MbwjR5jR8T63jCHpna3TP9E0qOLTN1/Zil9IUaTjJti4xncIOOI/MQeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734817746; c=relaxed/simple;
	bh=ddnMBrXLwpca2AnEflgP/5lR3wooUpnI/oec70m/B+8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=izJxuSkhOeIoxALoyODo35Vd0vnCeHYeGGi8R4neabJqBdMQI1bYUt0GNPEujeA+D/UkMppIMZZRIP//Or4GrajaUoBcOnSSwBuwK9I6Hh2R1jW+M84tYhlhNftJ56LgHWmymoRraUqmxoMGAsza7pWxlto2V2hmte7a6cLDB+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bVMEC9Y+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796B9C4CEDC;
	Sat, 21 Dec 2024 21:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734817745;
	bh=ddnMBrXLwpca2AnEflgP/5lR3wooUpnI/oec70m/B+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVMEC9Y+3g6+cIIS9eYVgivhAatjZ0OpNIXVQ2VcHyv7/HFz5VBer93QzOpcLyKpY
	 d/8+mRB3ScdGvGaldZRtw2UXwc3xVv1Siy0CLpaOoA62OXbZGv1hrulnOlq5X3Pg4+
	 CzRPjGDAz0d1TuK+BS6dAGxcH0ybef8UPMLT3rE/YinbeDwoNj8GUf62H/xHM2FSVc
	 qNxT4kn96rrzTcesHgC43AUD/3fVG7jwVppA0KV9SKYZmbQHFox4bW0UZ/RnYjQO3c
	 feI8HVkzyswER/TPMGQdzGXr8ehzgR3pvBwNTEa/POstchWGM79DDySwMxVgzdNh/v
	 tcZDiYCaCDvgA==
From: Arnd Bergmann <arnd@kernel.org>
To: kvm@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alexander Graf <graf@amazon.com>,
	Crystal Wood <crwood@redhat.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Marc Zyngier <maz@kernel.org>,
	"A. Wilcox" <AWilcox@Wilcox-Tech.com>,
	linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org
Subject: [PATCH v2 1/5] mips: kvm: drop support for 32-bit hosts
Date: Sat, 21 Dec 2024 22:42:19 +0100
Message-Id: <20241221214223.3046298-2-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241221214223.3046298-1-arnd@kernel.org>
References: <20241221214223.3046298-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

KVM support on MIPS was added in 2012 with both 32-bit and 64-bit mode
included, but there is only one CPU implementation that actually includes
the required VZ support with the Warrior P5600 core. Support for the
one SoC using this core did not fully get merged into mainline, and
very likely never will.

Simplify the KVM code by dropping the corresponding #ifdef checks for
32-bit mode, leaving only 64-bit mode available in Loongson, Cavium,
Mobileye and Fungible SoCs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/mips/Kconfig                |  3 ---
 arch/mips/include/asm/kvm_host.h |  4 ----
 arch/mips/kvm/Kconfig            |  1 +
 arch/mips/kvm/emulate.c          |  8 --------
 arch/mips/kvm/msa.S              | 12 ------------
 arch/mips/kvm/vz.c               | 22 ----------------------
 6 files changed, 1 insertion(+), 49 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index a33f05e1ad6d..7705d634d9c7 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1415,7 +1415,6 @@ config CPU_MIPS32_R5
 	select CPU_SUPPORTS_32BIT_KERNEL
 	select CPU_SUPPORTS_HIGHMEM
 	select CPU_SUPPORTS_MSA
-	select CPU_SUPPORTS_VZ
 	select MIPS_O32_FP64_SUPPORT
 	help
 	  Choose this option to build a kernel for release 5 or later of the
@@ -1431,7 +1430,6 @@ config CPU_MIPS32_R6
 	select CPU_SUPPORTS_32BIT_KERNEL
 	select CPU_SUPPORTS_HIGHMEM
 	select CPU_SUPPORTS_MSA
-	select CPU_SUPPORTS_VZ
 	select MIPS_O32_FP64_SUPPORT
 	help
 	  Choose this option to build a kernel for release 6 or later of the
@@ -1517,7 +1515,6 @@ config CPU_P5600
 	select CPU_SUPPORTS_HIGHMEM
 	select CPU_SUPPORTS_MSA
 	select CPU_SUPPORTS_CPUFREQ
-	select CPU_SUPPORTS_VZ
 	select CPU_MIPSR2_IRQ_VI
 	select CPU_MIPSR2_IRQ_EI
 	select MIPS_O32_FP64_SUPPORT
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index f7222eb594ea..1a506892322d 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -261,11 +261,7 @@ enum emulation_result {
 	EMULATE_HYPERCALL,	/* HYPCALL instruction */
 };
 
-#if defined(CONFIG_64BIT)
 #define VPN2_MASK		GENMASK(cpu_vmbits - 1, 13)
-#else
-#define VPN2_MASK		0xffffe000
-#endif
 #define KVM_ENTRYHI_ASID	cpu_asid_mask(&boot_cpu_data)
 #define TLB_IS_GLOBAL(x)	((x).tlb_lo[0] & (x).tlb_lo[1] & ENTRYLO_G)
 #define TLB_VPN2(x)		((x).tlb_hi & VPN2_MASK)
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index ab57221fa4dd..2508ebbf49ba 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -18,6 +18,7 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on CPU_SUPPORTS_VZ
+	depends on 64BIT
 	depends on MIPS_FP_SUPPORT
 	select EXPORT_UASM
 	select KVM_COMMON
diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
index 0feec52222fb..c84eaf21643c 100644
--- a/arch/mips/kvm/emulate.c
+++ b/arch/mips/kvm/emulate.c
@@ -994,7 +994,6 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
 		goto out_fail;
 
 	switch (inst.i_format.opcode) {
-#if defined(CONFIG_64BIT)
 	case sd_op:
 		run->mmio.len = 8;
 		*(u64 *)data = vcpu->arch.gprs[rt];
@@ -1003,7 +1002,6 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
 			  vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
 			  vcpu->arch.gprs[rt], *(u64 *)data);
 		break;
-#endif
 
 	case sw_op:
 		run->mmio.len = 4;
@@ -1092,7 +1090,6 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
 			  vcpu->arch.gprs[rt], *(u32 *)data);
 		break;
 
-#if defined(CONFIG_64BIT)
 	case sdl_op:
 		run->mmio.phys_addr = kvm_mips_callbacks->gva_to_gpa(
 					vcpu->arch.host_cp0_badvaddr) & (~0x7);
@@ -1186,7 +1183,6 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
 			  vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
 			  vcpu->arch.gprs[rt], *(u64 *)data);
 		break;
-#endif
 
 #ifdef CONFIG_CPU_LOONGSON64
 	case sdc2_op:
@@ -1299,7 +1295,6 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 
 	vcpu->mmio_needed = 2;	/* signed */
 	switch (op) {
-#if defined(CONFIG_64BIT)
 	case ld_op:
 		run->mmio.len = 8;
 		break;
@@ -1307,7 +1302,6 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 	case lwu_op:
 		vcpu->mmio_needed = 1;	/* unsigned */
 		fallthrough;
-#endif
 	case lw_op:
 		run->mmio.len = 4;
 		break;
@@ -1374,7 +1368,6 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 		}
 		break;
 
-#if defined(CONFIG_64BIT)
 	case ldl_op:
 		run->mmio.phys_addr = kvm_mips_callbacks->gva_to_gpa(
 					vcpu->arch.host_cp0_badvaddr) & (~0x7);
@@ -1446,7 +1439,6 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 			break;
 		}
 		break;
-#endif
 
 #ifdef CONFIG_CPU_LOONGSON64
 	case ldc2_op:
diff --git a/arch/mips/kvm/msa.S b/arch/mips/kvm/msa.S
index d02f0c6cc2cc..c73858efb975 100644
--- a/arch/mips/kvm/msa.S
+++ b/arch/mips/kvm/msa.S
@@ -93,20 +93,8 @@ LEAF(__kvm_restore_msa)
 	.macro	kvm_restore_msa_upper	wr, off, base
 	.set	push
 	.set	noat
-#ifdef CONFIG_64BIT
 	ld	$1, \off(\base)
 	insert_d \wr, 1
-#elif defined(CONFIG_CPU_LITTLE_ENDIAN)
-	lw	$1, \off(\base)
-	insert_w \wr, 2
-	lw	$1, (\off+4)(\base)
-	insert_w \wr, 3
-#else /* CONFIG_CPU_BIG_ENDIAN */
-	lw	$1, (\off+4)(\base)
-	insert_w \wr, 2
-	lw	$1, \off(\base)
-	insert_w \wr, 3
-#endif
 	.set	pop
 	.endm
 
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index ccab4d76b126..b376ac870256 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -746,7 +746,6 @@ static int kvm_vz_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 			*gpa = gva32 & 0x1fffffff;
 			return 0;
 		}
-#ifdef CONFIG_64BIT
 	} else if ((gva & 0xc000000000000000) == 0x8000000000000000) {
 		/* XKPHYS */
 		if (cpu_guest_has_segments) {
@@ -771,7 +770,6 @@ static int kvm_vz_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 		 */
 		*gpa = gva & 0x07ffffffffffffff;
 		return 0;
-#endif
 	}
 
 tlb_mapped:
@@ -1740,9 +1738,7 @@ static u64 kvm_vz_get_one_regs[] = {
 	KVM_REG_MIPS_CP0_CONFIG4,
 	KVM_REG_MIPS_CP0_CONFIG5,
 	KVM_REG_MIPS_CP0_CONFIG6,
-#ifdef CONFIG_64BIT
 	KVM_REG_MIPS_CP0_XCONTEXT,
-#endif
 	KVM_REG_MIPS_CP0_ERROREPC,
 
 	KVM_REG_MIPS_COUNT_CTL,
@@ -1752,9 +1748,7 @@ static u64 kvm_vz_get_one_regs[] = {
 
 static u64 kvm_vz_get_one_regs_contextconfig[] = {
 	KVM_REG_MIPS_CP0_CONTEXTCONFIG,
-#ifdef CONFIG_64BIT
 	KVM_REG_MIPS_CP0_XCONTEXTCONFIG,
-#endif
 };
 
 static u64 kvm_vz_get_one_regs_segments[] = {
@@ -1937,13 +1931,11 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 		*v = read_gc0_userlocal();
 		break;
-#ifdef CONFIG_64BIT
 	case KVM_REG_MIPS_CP0_XCONTEXTCONFIG:
 		if (!cpu_guest_has_contextconfig)
 			return -EINVAL;
 		*v = read_gc0_xcontextconfig();
 		break;
-#endif
 	case KVM_REG_MIPS_CP0_PAGEMASK:
 		*v = (long)read_gc0_pagemask();
 		break;
@@ -2083,11 +2075,9 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 		*v = kvm_read_sw_gc0_maari(&vcpu->arch.cop0);
 		break;
-#ifdef CONFIG_64BIT
 	case KVM_REG_MIPS_CP0_XCONTEXT:
 		*v = read_gc0_xcontext();
 		break;
-#endif
 	case KVM_REG_MIPS_CP0_ERROREPC:
 		*v = (long)read_gc0_errorepc();
 		break;
@@ -2163,13 +2153,11 @@ static int kvm_vz_set_one_reg(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 		write_gc0_userlocal(v);
 		break;
-#ifdef CONFIG_64BIT
 	case KVM_REG_MIPS_CP0_XCONTEXTCONFIG:
 		if (!cpu_guest_has_contextconfig)
 			return -EINVAL;
 		write_gc0_xcontextconfig(v);
 		break;
-#endif
 	case KVM_REG_MIPS_CP0_PAGEMASK:
 		write_gc0_pagemask(v);
 		break;
@@ -2360,11 +2348,9 @@ static int kvm_vz_set_one_reg(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 		kvm_write_maari(vcpu, v);
 		break;
-#ifdef CONFIG_64BIT
 	case KVM_REG_MIPS_CP0_XCONTEXT:
 		write_gc0_xcontext(v);
 		break;
-#endif
 	case KVM_REG_MIPS_CP0_ERROREPC:
 		write_gc0_errorepc(v);
 		break;
@@ -2632,11 +2618,9 @@ static int kvm_vz_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_restore_gc0_context(cop0);
 	if (cpu_guest_has_contextconfig)
 		kvm_restore_gc0_contextconfig(cop0);
-#ifdef CONFIG_64BIT
 	kvm_restore_gc0_xcontext(cop0);
 	if (cpu_guest_has_contextconfig)
 		kvm_restore_gc0_xcontextconfig(cop0);
-#endif
 	kvm_restore_gc0_pagemask(cop0);
 	kvm_restore_gc0_pagegrain(cop0);
 	kvm_restore_gc0_hwrena(cop0);
@@ -2717,11 +2701,9 @@ static int kvm_vz_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
 	kvm_save_gc0_context(cop0);
 	if (cpu_guest_has_contextconfig)
 		kvm_save_gc0_contextconfig(cop0);
-#ifdef CONFIG_64BIT
 	kvm_save_gc0_xcontext(cop0);
 	if (cpu_guest_has_contextconfig)
 		kvm_save_gc0_xcontextconfig(cop0);
-#endif
 	kvm_save_gc0_pagemask(cop0);
 	kvm_save_gc0_pagegrain(cop0);
 	kvm_save_gc0_wired(cop0);
@@ -3030,12 +3012,10 @@ static int kvm_vz_check_extension(struct kvm *kvm, long ext)
 		/* we wouldn't be here unless cpu_has_vz */
 		r = 1;
 		break;
-#ifdef CONFIG_64BIT
 	case KVM_CAP_MIPS_64BIT:
 		/* We support 64-bit registers/operations and addresses */
 		r = 2;
 		break;
-#endif
 	case KVM_CAP_IOEVENTFD:
 		r = 1;
 		break;
@@ -3179,12 +3159,10 @@ static int kvm_vz_vcpu_setup(struct kvm_vcpu *vcpu)
 	if (cpu_guest_has_contextconfig) {
 		/* ContextConfig */
 		kvm_write_sw_gc0_contextconfig(cop0, 0x007ffff0);
-#ifdef CONFIG_64BIT
 		/* XContextConfig */
 		/* bits SEGBITS-13+3:4 set */
 		kvm_write_sw_gc0_xcontextconfig(cop0,
 					((1ull << (cpu_vmbits - 13)) - 1) << 4);
-#endif
 	}
 
 	/* Implementation dependent, use the legacy layout */
-- 
2.39.5



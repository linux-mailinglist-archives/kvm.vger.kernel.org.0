Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73E54992EB
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 14:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733249AbfHVMK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 08:10:58 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:57043 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730980AbfHVMK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 08:10:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566475856; x=1598011856;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=vzGuqnfOUEFsxt7fROuX+KXEkhbP8AQE/wXmqJj7hwE=;
  b=QwLnRqbvZ8jZBI4UMzH6RZBEr/dVJuKE//T1Cvyk8sPY2JY7EKkrGwnF
   bAM3yBYwTkms3gumHS/IizTV04x+uisMVTs7eG0mZ0hgqB6KLN46VS1Ih
   yibGFl2vg6rQM0S45i9NyK5APD/MPWbK3H1yK52QV0SFSKXZQ7I3BZIFK
   4=;
X-IronPort-AV: E=Sophos;i="5.64,416,1559520000"; 
   d="scan'208";a="822653353"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 22 Aug 2019 12:10:56 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id 7204AA2755;
        Thu, 22 Aug 2019 12:10:55 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 22 Aug 2019 12:10:54 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.67) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 22 Aug 2019 12:10:50 +0000
Subject: Re: [PATCH v5 10/20] RISC-V: KVM: Handle MMIO exits for VCPU
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Christoph Hellwig" <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190822084131.114764-1-anup.patel@wdc.com>
 <20190822084131.114764-11-anup.patel@wdc.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <13cf8e10-3f54-a50a-0796-ecb2da4577d2@amazon.com>
Date:   Thu, 22 Aug 2019 14:10:48 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822084131.114764-11-anup.patel@wdc.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.67]
X-ClientProxiedBy: EX13D28UWC003.ant.amazon.com (10.43.162.48) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.08.19 10:44, Anup Patel wrote:
> We will get stage2 page faults whenever Guest/VM access SW emulated
> MMIO device or unmapped Guest RAM.
> 
> This patch implements MMIO read/write emulation by extracting MMIO
> details from the trapped load/store instruction and forwarding the
> MMIO read/write to user-space. The actual MMIO emulation will happen
> in user-space and KVM kernel module will only take care of register
> updates before resuming the trapped VCPU.
> 
> The handling for stage2 page faults for unmapped Guest RAM will be
> implemeted by a separate patch later.
> 
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/riscv/include/asm/kvm_host.h |  11 +
>   arch/riscv/kvm/mmu.c              |   7 +
>   arch/riscv/kvm/vcpu_exit.c        | 436 +++++++++++++++++++++++++++++-
>   3 files changed, 451 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 18f1097f1d8d..4388bace6d70 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -53,6 +53,12 @@ struct kvm_arch {
>   	phys_addr_t pgd_phys;
>   };
>   
> +struct kvm_mmio_decode {
> +	unsigned long insn;
> +	int len;
> +	int shift;
> +};
> +
>   struct kvm_cpu_context {
>   	unsigned long zero;
>   	unsigned long ra;
> @@ -141,6 +147,9 @@ struct kvm_vcpu_arch {
>   	unsigned long irqs_pending;
>   	unsigned long irqs_pending_mask;
>   
> +	/* MMIO instruction details */
> +	struct kvm_mmio_decode mmio_decode;
> +
>   	/* VCPU power-off state */
>   	bool power_off;
>   
> @@ -160,6 +169,8 @@ static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>   int kvm_riscv_setup_vsip(void);
>   void kvm_riscv_cleanup_vsip(void);
>   
> +int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva,
> +			 bool is_write);
>   void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
>   int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
>   void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 04dd089b86ff..2b965f9aac07 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -61,6 +61,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>   	return 0;
>   }
>   
> +int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva,
> +			 bool is_write)
> +{
> +	/* TODO: */
> +	return 0;
> +}
> +
>   void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu)
>   {
>   	/* TODO: */
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index e4d7c8f0807a..efc06198c259 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -6,9 +6,371 @@
>    *     Anup Patel <anup.patel@wdc.com>
>    */
>   
> +#include <linux/bitops.h>
>   #include <linux/errno.h>
>   #include <linux/err.h>
>   #include <linux/kvm_host.h>
> +#include <asm/csr.h>
> +
> +#define INSN_MATCH_LB		0x3
> +#define INSN_MASK_LB		0x707f
> +#define INSN_MATCH_LH		0x1003
> +#define INSN_MASK_LH		0x707f
> +#define INSN_MATCH_LW		0x2003
> +#define INSN_MASK_LW		0x707f
> +#define INSN_MATCH_LD		0x3003
> +#define INSN_MASK_LD		0x707f
> +#define INSN_MATCH_LBU		0x4003
> +#define INSN_MASK_LBU		0x707f
> +#define INSN_MATCH_LHU		0x5003
> +#define INSN_MASK_LHU		0x707f
> +#define INSN_MATCH_LWU		0x6003
> +#define INSN_MASK_LWU		0x707f
> +#define INSN_MATCH_SB		0x23
> +#define INSN_MASK_SB		0x707f
> +#define INSN_MATCH_SH		0x1023
> +#define INSN_MASK_SH		0x707f
> +#define INSN_MATCH_SW		0x2023
> +#define INSN_MASK_SW		0x707f
> +#define INSN_MATCH_SD		0x3023
> +#define INSN_MASK_SD		0x707f
> +
> +#define INSN_MATCH_C_LD		0x6000
> +#define INSN_MASK_C_LD		0xe003
> +#define INSN_MATCH_C_SD		0xe000
> +#define INSN_MASK_C_SD		0xe003
> +#define INSN_MATCH_C_LW		0x4000
> +#define INSN_MASK_C_LW		0xe003
> +#define INSN_MATCH_C_SW		0xc000
> +#define INSN_MASK_C_SW		0xe003
> +#define INSN_MATCH_C_LDSP	0x6002
> +#define INSN_MASK_C_LDSP	0xe003
> +#define INSN_MATCH_C_SDSP	0xe002
> +#define INSN_MASK_C_SDSP	0xe003
> +#define INSN_MATCH_C_LWSP	0x4002
> +#define INSN_MASK_C_LWSP	0xe003
> +#define INSN_MATCH_C_SWSP	0xc002
> +#define INSN_MASK_C_SWSP	0xe003
> +
> +#define INSN_LEN(insn)		((((insn) & 0x3) < 0x3) ? 2 : 4)
> +
> +#ifdef CONFIG_64BIT
> +#define LOG_REGBYTES		3
> +#else
> +#define LOG_REGBYTES		2
> +#endif
> +#define REGBYTES		(1 << LOG_REGBYTES)
> +
> +#define SH_RD			7
> +#define SH_RS1			15
> +#define SH_RS2			20
> +#define SH_RS2C			2
> +
> +#define RV_X(x, s, n)		(((x) >> (s)) & ((1 << (n)) - 1))
> +#define RVC_LW_IMM(x)		((RV_X(x, 6, 1) << 2) | \
> +				 (RV_X(x, 10, 3) << 3) | \
> +				 (RV_X(x, 5, 1) << 6))
> +#define RVC_LD_IMM(x)		((RV_X(x, 10, 3) << 3) | \
> +				 (RV_X(x, 5, 2) << 6))
> +#define RVC_LWSP_IMM(x)		((RV_X(x, 4, 3) << 2) | \
> +				 (RV_X(x, 12, 1) << 5) | \
> +				 (RV_X(x, 2, 2) << 6))
> +#define RVC_LDSP_IMM(x)		((RV_X(x, 5, 2) << 3) | \
> +				 (RV_X(x, 12, 1) << 5) | \
> +				 (RV_X(x, 2, 3) << 6))
> +#define RVC_SWSP_IMM(x)		((RV_X(x, 9, 4) << 2) | \
> +				 (RV_X(x, 7, 2) << 6))
> +#define RVC_SDSP_IMM(x)		((RV_X(x, 10, 3) << 3) | \
> +				 (RV_X(x, 7, 3) << 6))
> +#define RVC_RS1S(insn)		(8 + RV_X(insn, SH_RD, 3))
> +#define RVC_RS2S(insn)		(8 + RV_X(insn, SH_RS2C, 3))
> +#define RVC_RS2(insn)		RV_X(insn, SH_RS2C, 5)
> +
> +#define SHIFT_RIGHT(x, y)		\
> +	((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
> +
> +#define REG_MASK			\
> +	((1 << (5 + LOG_REGBYTES)) - (1 << LOG_REGBYTES))
> +
> +#define REG_OFFSET(insn, pos)		\
> +	(SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
> +
> +#define REG_PTR(insn, pos, regs)	\
> +	(ulong *)((ulong)(regs) + REG_OFFSET(insn, pos))
> +
> +#define GET_RM(insn)		(((insn) >> 12) & 7)
> +
> +#define GET_RS1(insn, regs)	(*REG_PTR(insn, SH_RS1, regs))
> +#define GET_RS2(insn, regs)	(*REG_PTR(insn, SH_RS2, regs))
> +#define GET_RS1S(insn, regs)	(*REG_PTR(RVC_RS1S(insn), 0, regs))
> +#define GET_RS2S(insn, regs)	(*REG_PTR(RVC_RS2S(insn), 0, regs))
> +#define GET_RS2C(insn, regs)	(*REG_PTR(insn, SH_RS2C, regs))
> +#define GET_SP(regs)		(*REG_PTR(2, 0, regs))
> +#define SET_RD(insn, regs, val)	(*REG_PTR(insn, SH_RD, regs) = (val))
> +#define IMM_I(insn)		((s32)(insn) >> 20)
> +#define IMM_S(insn)		(((s32)(insn) >> 25 << 5) | \
> +				 (s32)(((insn) >> 7) & 0x1f))
> +#define MASK_FUNCT3		0x7000
> +
> +#define STR(x)			XSTR(x)
> +#define XSTR(x)			#x
> +
> +/* TODO: Handle traps due to unpriv load and redirect it back to VS-mode */
> +static ulong get_insn(struct kvm_vcpu *vcpu)
> +{
> +	ulong __sepc = vcpu->arch.guest_context.sepc;
> +	ulong __hstatus, __sstatus, __vsstatus;
> +#ifdef CONFIG_RISCV_ISA_C
> +	ulong rvc_mask = 3, tmp;
> +#endif
> +	ulong flags, val;
> +
> +	local_irq_save(flags);
> +
> +	__vsstatus = csr_read(CSR_VSSTATUS);
> +	__sstatus = csr_read(CSR_SSTATUS);
> +	__hstatus = csr_read(CSR_HSTATUS);
> +
> +	csr_write(CSR_VSSTATUS, __vsstatus | SR_MXR);
> +	csr_write(CSR_SSTATUS, vcpu->arch.guest_context.sstatus | SR_MXR);
> +	csr_write(CSR_HSTATUS, vcpu->arch.guest_context.hstatus | HSTATUS_SPRV);
> +
> +#ifndef CONFIG_RISCV_ISA_C
> +	asm ("\n"
> +#ifdef CONFIG_64BIT
> +		STR(LWU) " %[insn], (%[addr])\n"
> +#else
> +		STR(LW) " %[insn], (%[addr])\n"
> +#endif
> +		: [insn] "=&r" (val) : [addr] "r" (__sepc));
> +#else
> +	asm ("and %[tmp], %[addr], 2\n"
> +		"bnez %[tmp], 1f\n"
> +#ifdef CONFIG_64BIT
> +		STR(LWU) " %[insn], (%[addr])\n"
> +#else
> +		STR(LW) " %[insn], (%[addr])\n"
> +#endif
> +		"and %[tmp], %[insn], %[rvc_mask]\n"
> +		"beq %[tmp], %[rvc_mask], 2f\n"
> +		"sll %[insn], %[insn], %[xlen_minus_16]\n"
> +		"srl %[insn], %[insn], %[xlen_minus_16]\n"
> +		"j 2f\n"
> +		"1:\n"
> +		"lhu %[insn], (%[addr])\n"
> +		"and %[tmp], %[insn], %[rvc_mask]\n"
> +		"bne %[tmp], %[rvc_mask], 2f\n"
> +		"lhu %[tmp], 2(%[addr])\n"
> +		"sll %[tmp], %[tmp], 16\n"
> +		"add %[insn], %[insn], %[tmp]\n"
> +		"2:"
> +	: [vsstatus] "+&r" (__vsstatus), [insn] "=&r" (val),
> +	  [tmp] "=&r" (tmp)
> +	: [addr] "r" (__sepc), [rvc_mask] "r" (rvc_mask),
> +	  [xlen_minus_16] "i" (__riscv_xlen - 16));
> +#endif
> +
> +	csr_write(CSR_HSTATUS, __hstatus);
> +	csr_write(CSR_SSTATUS, __sstatus);
> +	csr_write(CSR_VSSTATUS, __vsstatus);
> +
> +	local_irq_restore(flags);
> +
> +	return val;
> +}
> +
> +static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +			unsigned long fault_addr)
> +{
> +	int shift = 0, len = 0;
> +	ulong insn = get_insn(vcpu);
> +
> +	/* Decode length of MMIO and shift */
> +	if ((insn & INSN_MASK_LW) == INSN_MATCH_LW) {
> +		len = 4;
> +		shift = 8 * (sizeof(ulong) - len);
> +	} else if ((insn & INSN_MASK_LB) == INSN_MATCH_LB) {
> +		len = 1;
> +		shift = 8 * (sizeof(ulong) - len);
> +	} else if ((insn & INSN_MASK_LBU) == INSN_MATCH_LBU) {
> +		len = 1;
> +		shift = 8 * (sizeof(ulong) - len);
> +#ifdef CONFIG_64BIT
> +	} else if ((insn & INSN_MASK_LD) == INSN_MATCH_LD) {
> +		len = 8;
> +		shift = 8 * (sizeof(ulong) - len);
> +	} else if ((insn & INSN_MASK_LWU) == INSN_MATCH_LWU) {
> +		len = 4;
> +#endif
> +	} else if ((insn & INSN_MASK_LH) == INSN_MATCH_LH) {
> +		len = 2;
> +		shift = 8 * (sizeof(ulong) - len);
> +	} else if ((insn & INSN_MASK_LHU) == INSN_MATCH_LHU) {
> +		len = 2;
> +#ifdef CONFIG_RISCV_ISA_C
> +#ifdef CONFIG_64BIT
> +	} else if ((insn & INSN_MASK_C_LD) == INSN_MATCH_C_LD) {
> +		len = 8;
> +		shift = 8 * (sizeof(ulong) - len);
> +		insn = RVC_RS2S(insn) << SH_RD;
> +	} else if ((insn & INSN_MASK_C_LDSP) == INSN_MATCH_C_LDSP &&
> +		   ((insn >> SH_RD) & 0x1f)) {
> +		len = 8;
> +		shift = 8 * (sizeof(ulong) - len);
> +#endif
> +	} else if ((insn & INSN_MASK_C_LW) == INSN_MATCH_C_LW) {
> +		len = 4;
> +		shift = 8 * (sizeof(ulong) - len);
> +		insn = RVC_RS2S(insn) << SH_RD;
> +	} else if ((insn & INSN_MASK_C_LWSP) == INSN_MATCH_C_LWSP &&
> +		   ((insn >> SH_RD) & 0x1f)) {
> +		len = 4;
> +		shift = 8 * (sizeof(ulong) - len);
> +#endif
> +	} else {
> +		return -ENOTSUPP;
> +	}
> +
> +	/* Fault address should be aligned to length of MMIO */
> +	if (fault_addr & (len - 1))
> +		return -EIO;
> +
> +	/* Save instruction decode info */
> +	vcpu->arch.mmio_decode.insn = insn;
> +	vcpu->arch.mmio_decode.shift = shift;
> +	vcpu->arch.mmio_decode.len = len;
> +
> +	/* Exit to userspace for MMIO emulation */
> +	vcpu->stat.mmio_exit_user++;
> +	run->exit_reason = KVM_EXIT_MMIO;
> +	run->mmio.is_write = false;
> +	run->mmio.phys_addr = fault_addr;
> +	run->mmio.len = len;
> +
> +	/* Move to next instruction */
> +	vcpu->arch.guest_context.sepc += INSN_LEN(insn);

Doesn't that make more sense on the reentry path? What if you want to 
inject an MCE on access to unmapped addresses from user space?

> +
> +	return 0;
> +}
> +
> +static int emulate_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +			 unsigned long fault_addr)
> +{
> +	u8 data8;
> +	u16 data16;
> +	u32 data32;
> +	u64 data64;
> +	ulong data;
> +	int len = 0;
> +	ulong insn = get_insn(vcpu);
> +
> +	data = GET_RS2(insn, &vcpu->arch.guest_context);
> +	data8 = data16 = data32 = data64 = data;
> +
> +	if ((insn & INSN_MASK_SW) == INSN_MATCH_SW) {
> +		len = 4;
> +	} else if ((insn & INSN_MASK_SB) == INSN_MATCH_SB) {
> +		len = 1;
> +#ifdef CONFIG_64BIT
> +	} else if ((insn & INSN_MASK_SD) == INSN_MATCH_SD) {
> +		len = 8;
> +#endif
> +	} else if ((insn & INSN_MASK_SH) == INSN_MATCH_SH) {
> +		len = 2;
> +#ifdef CONFIG_RISCV_ISA_C
> +#ifdef CONFIG_64BIT
> +	} else if ((insn & INSN_MASK_C_SD) == INSN_MATCH_C_SD) {
> +		len = 8;
> +		data64 = GET_RS2S(insn, &vcpu->arch.guest_context);
> +	} else if ((insn & INSN_MASK_C_SDSP) == INSN_MATCH_C_SDSP &&
> +		   ((insn >> SH_RD) & 0x1f)) {
> +		len = 8;
> +		data64 = GET_RS2C(insn, &vcpu->arch.guest_context);
> +#endif
> +	} else if ((insn & INSN_MASK_C_SW) == INSN_MATCH_C_SW) {
> +		len = 4;
> +		data32 = GET_RS2S(insn, &vcpu->arch.guest_context);
> +	} else if ((insn & INSN_MASK_C_SWSP) == INSN_MATCH_C_SWSP &&
> +		   ((insn >> SH_RD) & 0x1f)) {
> +		len = 4;
> +		data32 = GET_RS2C(insn, &vcpu->arch.guest_context);
> +#endif
> +	} else {
> +		return -ENOTSUPP;
> +	}
> +
> +	/* Fault address should be aligned to length of MMIO */
> +	if (fault_addr & (len - 1))
> +		return -EIO;
> +
> +	/* Clear instruction decode info */
> +	vcpu->arch.mmio_decode.insn = 0;
> +	vcpu->arch.mmio_decode.shift = 0;
> +	vcpu->arch.mmio_decode.len = 0;
> +
> +	/* Copy data to kvm_run instance */
> +	switch (len) {
> +	case 1:
> +		*((u8 *)run->mmio.data) = data8;
> +		break;
> +	case 2:
> +		*((u16 *)run->mmio.data) = data16;
> +		break;
> +	case 4:
> +		*((u32 *)run->mmio.data) = data32;
> +		break;
> +	case 8:
> +		*((u64 *)run->mmio.data) = data64;
> +		break;
> +	default:
> +		return -ENOTSUPP;
> +	};
> +
> +	/* Exit to userspace for MMIO emulation */
> +	vcpu->stat.mmio_exit_user++;
> +	run->exit_reason = KVM_EXIT_MMIO;
> +	run->mmio.is_write = true;
> +	run->mmio.phys_addr = fault_addr;
> +	run->mmio.len = len;
> +
> +	/* Move to next instruction */
> +	vcpu->arch.guest_context.sepc += INSN_LEN(insn);

Same comment here.


Alex

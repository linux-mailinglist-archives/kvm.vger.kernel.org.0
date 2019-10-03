Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD8FBC9C04
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 12:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfJCKSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 06:18:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59412 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbfJCKSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 06:18:08 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1EACDC059758
        for <kvm@vger.kernel.org>; Thu,  3 Oct 2019 10:18:07 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id z8so902666wrs.14
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 03:18:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0xkQgFP4pTnHjezRp6vps6wWhNTvIUwHU4/PLLGzYd8=;
        b=qIIdbd0rN3+4X/0Q1vdJPL3HcNVKo7H/m0HTTwRlT//yHg0X/hbUg4H7Y1HYvFkLVX
         ikJtIS3RjwOxS9+QuDx/TZSgieIGSu6BCywWTNtw0Rj+eIblhjFaH9I4mPZq4Csv0aDQ
         UMRZQZwgGNS52WRHfjjcKp5QIe//nno4qbFiSk65tHrzsW/H4XgBBCkbYhGXmuUvTBWd
         E/trMm5PoxVQtshMmrBXBXNMaRGc7HXlKlMs+TSmo9+4939wny8yUuW+L8GhkyD9OM31
         tFWyotT2m8R+9BGsfqvShCPSLRNRK6v/DVCfFHZja0hnygNAkCxNkWs0adLtDEwwxO6V
         bpDw==
X-Gm-Message-State: APjAAAUk7GEj6Xjdxbygt5VRXHnVh6IpOoqlAYEl9pep17MpZoiWR801
        jFRGTuSTKeOy153OduSKAE67PFuTl7m3/+MtVWmC6aeM+3oGYFxDM23k9SCVojVzVJ4ITVzP4uV
        bRDtDmyO9rkQo
X-Received: by 2002:adf:e58b:: with SMTP id l11mr6204555wrm.110.1570097885485;
        Thu, 03 Oct 2019 03:18:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxq6I4Wf4RutSO+cfuVFmkc8hGZAHBjSJdIvcZj4zww2qf4HHu4JhwngpZ38Ss50npvHlTy/A==
X-Received: by 2002:adf:e58b:: with SMTP id l11mr6204512wrm.110.1570097885010;
        Thu, 03 Oct 2019 03:18:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b903:6d6f:a447:e464? ([2001:b07:6468:f312:b903:6d6f:a447:e464])
        by smtp.gmail.com with ESMTPSA id 3sm1790355wmo.22.2019.10.03.03.18.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 03:18:04 -0700 (PDT)
Subject: Re: [PATCH v8 08/19] RISC-V: KVM: Handle MMIO exits for VCPU
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20191003050558.9031-1-anup.patel@wdc.com>
 <20191003050558.9031-9-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <68f7a4f9-1dc4-1102-0820-1d56fefb19e0@redhat.com>
Date:   Thu, 3 Oct 2019 12:18:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003050558.9031-9-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 07:07, Anup Patel wrote:
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
> Reviewed-by: Alexander Graf <graf@amazon.com>

The changes look good.

Paolo

> ---
>  arch/riscv/include/asm/kvm_host.h |  20 ++
>  arch/riscv/kvm/mmu.c              |   7 +
>  arch/riscv/kvm/vcpu_exit.c        | 505 +++++++++++++++++++++++++++++-
>  arch/riscv/kvm/vcpu_switch.S      |  14 +
>  4 files changed, 543 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 18f1097f1d8d..2a5209fff68d 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -53,6 +53,13 @@ struct kvm_arch {
>  	phys_addr_t pgd_phys;
>  };
>  
> +struct kvm_mmio_decode {
> +	unsigned long insn;
> +	int len;
> +	int shift;
> +	int return_handled;
> +};
> +
>  struct kvm_cpu_context {
>  	unsigned long zero;
>  	unsigned long ra;
> @@ -141,6 +148,9 @@ struct kvm_vcpu_arch {
>  	unsigned long irqs_pending;
>  	unsigned long irqs_pending_mask;
>  
> +	/* MMIO instruction details */
> +	struct kvm_mmio_decode mmio_decode;
> +
>  	/* VCPU power-off state */
>  	bool power_off;
>  
> @@ -160,11 +170,21 @@ static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>  int kvm_riscv_setup_vsip(void);
>  void kvm_riscv_cleanup_vsip(void);
>  
> +int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva,
> +			 bool is_write);
>  void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
>  int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
>  void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
>  void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu);
>  
> +void __kvm_riscv_unpriv_trap(void);
> +
> +unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
> +					 bool read_insn,
> +					 unsigned long guest_addr,
> +					 unsigned long *trap_scause);
> +void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
> +				  unsigned long scause, unsigned long stval);
>  int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  			unsigned long scause, unsigned long stval);
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 04dd089b86ff..2b965f9aac07 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -61,6 +61,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	return 0;
>  }
>  
> +int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva,
> +			 bool is_write)
> +{
> +	/* TODO: */
> +	return 0;
> +}
> +
>  void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu)
>  {
>  	/* TODO: */
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index e4d7c8f0807a..f1378c0a447f 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -6,9 +6,430 @@
>   *     Anup Patel <anup.patel@wdc.com>
>   */
>  
> +#include <linux/bitops.h>
>  #include <linux/errno.h>
>  #include <linux/err.h>
>  #include <linux/kvm_host.h>
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
> +#define INSN_16BIT_MASK		0x3
> +
> +#define INSN_IS_16BIT(insn)	(((insn) & INSN_16BIT_MASK) != INSN_16BIT_MASK)
> +
> +#define INSN_LEN(insn)		(INSN_IS_16BIT(insn) ? 2 : 4)
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
> +static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +			unsigned long fault_addr)
> +{
> +	int shift = 0, len = 0;
> +	unsigned long ut_scause = 0;
> +	struct kvm_cpu_context *ct = &vcpu->arch.guest_context;
> +	ulong insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
> +						&ut_scause);
> +
> +	/* Redirect trap if we failed to read instruction */
> +	if (ut_scause) {
> +		if (ut_scause == EXC_LOAD_PAGE_FAULT)
> +			ut_scause = EXC_INST_PAGE_FAULT;
> +		kvm_riscv_vcpu_trap_redirect(vcpu, ut_scause, ct->sepc);
> +		return 1;
> +	}
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
> +	vcpu->arch.mmio_decode.return_handled = 0;
> +
> +	/* Exit to userspace for MMIO emulation */
> +	vcpu->stat.mmio_exit_user++;
> +	run->exit_reason = KVM_EXIT_MMIO;
> +	run->mmio.is_write = false;
> +	run->mmio.phys_addr = fault_addr;
> +	run->mmio.len = len;
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
> +	unsigned long ut_scause = 0;
> +	struct kvm_cpu_context *ct = &vcpu->arch.guest_context;
> +	ulong insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
> +						&ut_scause);
> +
> +	/* Redirect trap if we failed to read instruction */
> +	if (ut_scause) {
> +		if (ut_scause == EXC_LOAD_PAGE_FAULT)
> +			ut_scause = EXC_INST_PAGE_FAULT;
> +		kvm_riscv_vcpu_trap_redirect(vcpu, ut_scause, ct->sepc);
> +		return 1;
> +	}
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
> +	vcpu->arch.mmio_decode.shift = 0;
> +	vcpu->arch.mmio_decode.len = len;
> +	vcpu->arch.mmio_decode.return_handled = 0;
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
> +	return 0;
> +}
> +
> +static int stage2_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +			     unsigned long scause, unsigned long stval)
> +{
> +	struct kvm_memory_slot *memslot;
> +	unsigned long hva;
> +	bool writable;
> +	gfn_t gfn;
> +	int ret;
> +
> +	gfn = stval >> PAGE_SHIFT;
> +	memslot = gfn_to_memslot(vcpu->kvm, gfn);
> +	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
> +
> +	if (kvm_is_error_hva(hva) ||
> +	    (scause == EXC_STORE_PAGE_FAULT && !writable)) {
> +		switch (scause) {
> +		case EXC_LOAD_PAGE_FAULT:
> +			return emulate_load(vcpu, run, stval);
> +		case EXC_STORE_PAGE_FAULT:
> +			return emulate_store(vcpu, run, stval);
> +		default:
> +			return -ENOTSUPP;
> +		};
> +	}
> +
> +	ret = kvm_riscv_stage2_map(vcpu, stval, hva,
> +			(scause == EXC_STORE_PAGE_FAULT) ? true : false);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 1;
> +}
> +
> +#define STR(x)		XSTR(x)
> +#define XSTR(x)		#x
> +
> +/**
> + * kvm_riscv_vcpu_unpriv_read -- Read machine word from Guest memory
> + *
> + * @vcpu: The VCPU pointer
> + * @read_insn: Flag representing whether we are reading instruction
> + * @guest_addr: Guest address to read
> + * @trap_scause: Output pointer for unprivilege trap cause
> + */
> +unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
> +					 bool read_insn,
> +					 unsigned long guest_addr,
> +					 unsigned long *trap_scause)
> +{
> +	register unsigned long tscause asm("a0");
> +	register unsigned long val asm("a1");
> +	register unsigned long addr asm("a2") = guest_addr;
> +	unsigned long guest_sstatus =
> +		vcpu->arch.guest_context.sstatus | ((read_insn) ? SR_MXR : 0);
> +	unsigned long guest_hstatus =
> +		vcpu->arch.guest_context.hstatus | HSTATUS_SPRV;
> +	unsigned long old_stvec, tmp;
> +
> +	BUG_ON(guest_sstatus & SR_SIE);
> +
> +	guest_sstatus = csr_swap(CSR_SSTATUS, guest_sstatus);
> +	old_stvec = csr_swap(CSR_STVEC, (ulong)&__kvm_riscv_unpriv_trap);
> +
> +	if (read_insn) {
> +		asm volatile ("\n"
> +			"csrrw %[hstatus], " STR(CSR_HSTATUS) ", %[hstatus]\n"
> +			"li %[tscause], 0\n"
> +			"lhu %[val], (%[addr])\n"
> +			"andi %[tmp], %[val], 3\n"
> +			"addi %[tmp], %[tmp], -3\n"
> +			"bne %[tmp], zero, 2f\n"
> +			"lhu %[tmp], 2(%[addr])\n"
> +			"sll %[tmp], %[tmp], 16\n"
> +			"add %[val], %[val], %[tmp]\n"
> +			"2: csrw " STR(CSR_HSTATUS) ", %[hstatus]"
> +		: [hstatus] "+&r"(guest_hstatus), [val] "=&r" (val),
> +		  [tmp] "=&r" (tmp), [tscause] "+&r" (tscause)
> +		: [addr] "r" (addr));
> +	} else {
> +		asm volatile ("\n"
> +			"csrrw %[hstatus], " STR(CSR_HSTATUS) ", %[hstatus]\n"
> +			"li %[tscause], 0\n"
> +			".option push\n"
> +			".option norvc\n"
> +#ifdef CONFIG_64BIT
> +			"ld %[val], (%[addr])\n"
> +#else
> +			"lw %[val], (%[addr])\n"
> +#endif
> +			".option pop\n"
> +			"csrw " STR(CSR_HSTATUS) ", %[hstatus]"
> +		: [hstatus] "+&r"(guest_hstatus),
> +		  [val] "=&r" (val), [tscause] "+&r" (tscause)
> +		: [addr] "r" (addr));
> +	}
> +
> +	csr_write(CSR_STVEC, old_stvec);
> +	csr_write(CSR_SSTATUS, guest_sstatus);
> +
> +	*trap_scause = tscause;
> +
> +	return val;
> +}
> +
> +/**
> + * kvm_riscv_vcpu_trap_redirect -- Redirect trap to Guest
> + *
> + * @vcpu: The VCPU pointer
> + * @scause: Trap exception cause
> + * @stval: Trap value
> + */
> +void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
> +				  unsigned long scause, unsigned long stval)
> +{
> +	unsigned long vsstatus = csr_read(CSR_VSSTATUS);
> +
> +	/* Change Guest SSTATUS.SPP bit */
> +	vsstatus &= ~SR_SPP;
> +	if (vcpu->arch.guest_context.sstatus & SR_SPP)
> +		vsstatus |= SR_SPP;
> +
> +	/* Change Guest SSTATUS.SPIE bit */
> +	vsstatus &= ~SR_SPIE;
> +	if (vsstatus & SR_SIE)
> +		vsstatus |= SR_SPIE;
> +
> +	/* Clear Guest SSTATUS.SIE bit */
> +	vsstatus &= ~SR_SIE;
> +
> +	/* Update Guest SSTATUS */
> +	csr_write(CSR_VSSTATUS, vsstatus);
> +
> +	/* Update Guest SCAUSE, STVAL, and SEPC */
> +	csr_write(CSR_VSCAUSE, scause);
> +	csr_write(CSR_VSTVAL, stval);
> +	csr_write(CSR_VSEPC, vcpu->arch.guest_context.sepc);
> +
> +	/* Set Guest PC to Guest exception vector */
> +	vcpu->arch.guest_context.sepc = csr_read(CSR_VSTVEC);
> +}
>  
>  /**
>   * kvm_riscv_vcpu_mmio_return -- Handle MMIO loads after user space emulation
> @@ -19,7 +440,54 @@
>   */
>  int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
> -	/* TODO: */
> +	u8 data8;
> +	u16 data16;
> +	u32 data32;
> +	u64 data64;
> +	ulong insn;
> +	int len, shift;
> +
> +	if (vcpu->arch.mmio_decode.return_handled)
> +		return 0;
> +
> +	vcpu->arch.mmio_decode.return_handled = 1;
> +	insn = vcpu->arch.mmio_decode.insn;
> +
> +	if (run->mmio.is_write)
> +		goto done;
> +
> +	len = vcpu->arch.mmio_decode.len;
> +	shift = vcpu->arch.mmio_decode.shift;
> +
> +	switch (len) {
> +	case 1:
> +		data8 = *((u8 *)run->mmio.data);
> +		SET_RD(insn, &vcpu->arch.guest_context,
> +			(ulong)data8 << shift >> shift);
> +		break;
> +	case 2:
> +		data16 = *((u16 *)run->mmio.data);
> +		SET_RD(insn, &vcpu->arch.guest_context,
> +			(ulong)data16 << shift >> shift);
> +		break;
> +	case 4:
> +		data32 = *((u32 *)run->mmio.data);
> +		SET_RD(insn, &vcpu->arch.guest_context,
> +			(ulong)data32 << shift >> shift);
> +		break;
> +	case 8:
> +		data64 = *((u64 *)run->mmio.data);
> +		SET_RD(insn, &vcpu->arch.guest_context,
> +			(ulong)data64 << shift >> shift);
> +		break;
> +	default:
> +		return -ENOTSUPP;
> +	};
> +
> +done:
> +	/* Move to next instruction */
> +	vcpu->arch.guest_context.sepc += INSN_LEN(insn);
> +
>  	return 0;
>  }
>  
> @@ -30,6 +498,37 @@ int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  			unsigned long scause, unsigned long stval)
>  {
> -	/* TODO: */
> -	return 0;
> +	int ret;
> +
> +	/* If we got host interrupt then do nothing */
> +	if (scause & SCAUSE_IRQ_FLAG)
> +		return 1;
> +
> +	/* Handle guest traps */
> +	ret = -EFAULT;
> +	run->exit_reason = KVM_EXIT_UNKNOWN;
> +	switch (scause) {
> +	case EXC_INST_PAGE_FAULT:
> +	case EXC_LOAD_PAGE_FAULT:
> +	case EXC_STORE_PAGE_FAULT:
> +		if ((vcpu->arch.guest_context.hstatus & HSTATUS_SPV) &&
> +		    (vcpu->arch.guest_context.hstatus & HSTATUS_STL))
> +			ret = stage2_page_fault(vcpu, run, scause, stval);
> +		break;
> +	default:
> +		break;
> +	};
> +
> +	/* Print details in-case of error */
> +	if (ret < 0) {
> +		kvm_err("VCPU exit error %d\n", ret);
> +		kvm_err("SEPC=0x%lx SSTATUS=0x%lx HSTATUS=0x%lx\n",
> +			vcpu->arch.guest_context.sepc,
> +			vcpu->arch.guest_context.sstatus,
> +			vcpu->arch.guest_context.hstatus);
> +		kvm_err("SCAUSE=0x%lx STVAL=0x%lx\n",
> +			scause, stval);
> +	}
> +
> +	return ret;
>  }
> diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
> index e1a17df1b379..04b318b9eef8 100644
> --- a/arch/riscv/kvm/vcpu_switch.S
> +++ b/arch/riscv/kvm/vcpu_switch.S
> @@ -192,3 +192,17 @@ __kvm_switch_return:
>  	/* Return to C code */
>  	ret
>  ENDPROC(__kvm_riscv_switch_to)
> +
> +ENTRY(__kvm_riscv_unpriv_trap)
> +	/*
> +	 * We assume that faulting unpriv load/store instruction is
> +	 * is 4-byte long and blindly increment SEPC by 4.
> +	 *
> +	 * The trap exception cause will be saved in 'A0' register.
> +	 */
> +	csrr	a0, CSR_SEPC
> +	addi	a0, a0, 4
> +	csrw	CSR_SEPC, a0
> +	csrr	a0, CSR_SCAUSE
> +	sret
> +ENDPROC(__kvm_riscv_unpriv_trap)
> 


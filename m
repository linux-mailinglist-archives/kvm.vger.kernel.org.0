Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474781DF7A0
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 15:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387932AbgEWN17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 09:27:59 -0400
Received: from [115.28.160.31] ([115.28.160.31]:60522 "EHLO
        mailbox.box.xen0n.name" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S2387929AbgEWN15 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 23 May 2020 09:27:57 -0400
Received: from [192.168.9.172] (unknown [112.65.48.63])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 758A56006D;
        Sat, 23 May 2020 21:27:51 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=xen0n.name; s=mail;
        t=1590240471; bh=06nHkBkR+xh+IOmYfVe/D7EJimMjxgNIi5UoHzD61f0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=IDSuIcvV8A2j4UqOcKEJTe+iLF7ldKDcEVrIVluZZzOSZnm+0RRtS6yc5eYFLZOSI
         jfDYDkIvO0+DzhfQlNaNtRab0p4YkXycB1ZbsKlUcHJJXABJ1qyiugeeHCUpEaAmh6
         3214DosgUSK8QLGmAHt137FFIfrJWSR3PrEL3CtY=
Subject: Re: [PATCH V7 12/15] KVM: MIPS: Add CONFIG6 and DIAG registers
 emulation
To:     Huacai Chen <chenhc@lemote.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
 <1590220602-3547-13-git-send-email-chenhc@lemote.com>
From:   WANG Xuerui <kernel@xen0n.name>
Message-ID: <a52129ed-80ff-304a-59d6-f132c7553646@xen0n.name>
Date:   Sat, 23 May 2020 21:27:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.0a1
MIME-Version: 1.0
In-Reply-To: <1590220602-3547-13-git-send-email-chenhc@lemote.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Huacai,

On 5/23/20 3:56 PM, Huacai Chen wrote:

> Loongson-3 has CONFIG6 and DIAG registers which need to be emulated.
> CONFIG6 is mostly used to enable/disable FTLB and SFB, while DIAG is
> mostly used to flush BTB, ITLB, DTLB, VTLB and FTLB.
>
> Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>   arch/mips/include/asm/kvm_host.h |  7 +++++
>   arch/mips/include/asm/mipsregs.h |  7 +++++
>   arch/mips/kvm/tlb.c              | 41 ++++++++++++++++++++++++++
>   arch/mips/kvm/vz.c               | 62 +++++++++++++++++++++++++++++++++++++++-
>   4 files changed, 116 insertions(+), 1 deletion(-)
>
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 3fd2f1c..30b5e33 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -68,9 +68,11 @@
>   #define KVM_REG_MIPS_CP0_CONFIG3	MIPS_CP0_32(16, 3)
>   #define KVM_REG_MIPS_CP0_CONFIG4	MIPS_CP0_32(16, 4)
>   #define KVM_REG_MIPS_CP0_CONFIG5	MIPS_CP0_32(16, 5)
> +#define KVM_REG_MIPS_CP0_CONFIG6	MIPS_CP0_32(16, 6)
>   #define KVM_REG_MIPS_CP0_CONFIG7	MIPS_CP0_32(16, 7)
>   #define KVM_REG_MIPS_CP0_MAARI		MIPS_CP0_64(17, 2)
>   #define KVM_REG_MIPS_CP0_XCONTEXT	MIPS_CP0_64(20, 0)
> +#define KVM_REG_MIPS_CP0_DIAG		MIPS_CP0_32(22, 0)
>   #define KVM_REG_MIPS_CP0_ERROREPC	MIPS_CP0_64(30, 0)
>   #define KVM_REG_MIPS_CP0_KSCRATCH1	MIPS_CP0_64(31, 2)
>   #define KVM_REG_MIPS_CP0_KSCRATCH2	MIPS_CP0_64(31, 3)
> @@ -256,6 +258,7 @@ struct mips_coproc {
>   #define MIPS_CP0_WATCH_LO	18
>   #define MIPS_CP0_WATCH_HI	19
>   #define MIPS_CP0_TLB_XCONTEXT	20
> +#define MIPS_CP0_DIAG		22
>   #define MIPS_CP0_ECC		26
>   #define MIPS_CP0_CACHE_ERR	27
>   #define MIPS_CP0_TAG_LO		28
> @@ -927,6 +930,10 @@ void kvm_vz_save_guesttlb(struct kvm_mips_tlb *buf, unsigned int index,
>   			  unsigned int count);
>   void kvm_vz_load_guesttlb(const struct kvm_mips_tlb *buf, unsigned int index,
>   			  unsigned int count);
> +#ifdef CONFIG_CPU_LOONGSON64
> +void kvm_loongson_clear_guest_vtlb(void);
> +void kvm_loongson_clear_guest_ftlb(void);
> +#endif
>   #endif
>   
>   void kvm_mips_suspend_mm(int cpu);
> diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm/mipsregs.h
> index 796fe47..ce40fbf 100644
> --- a/arch/mips/include/asm/mipsregs.h
> +++ b/arch/mips/include/asm/mipsregs.h
> @@ -993,6 +996,8 @@
>   /* Disable Branch Return Cache */
>   #define R10K_DIAG_D_BRC		(_ULCAST_(1) << 22)
>   
> +/* Flush BTB */
> +#define LOONGSON_DIAG_BTB	(_ULCAST_(1) << 1)
>   /* Flush ITLB */
>   #define LOONGSON_DIAG_ITLB	(_ULCAST_(1) << 2)
>   /* Flush DTLB */
> @@ -2825,7 +2830,9 @@ __BUILD_SET_C0(status)
>   __BUILD_SET_C0(cause)
>   __BUILD_SET_C0(config)
>   __BUILD_SET_C0(config5)
> +__BUILD_SET_C0(config6)
>   __BUILD_SET_C0(config7)
> +__BUILD_SET_C0(diag)
>   __BUILD_SET_C0(intcontrol)
>   __BUILD_SET_C0(intctl)
>   __BUILD_SET_C0(srsmap)
> diff --git a/arch/mips/kvm/tlb.c b/arch/mips/kvm/tlb.c
> index 7cd9216..1418715 100644
> --- a/arch/mips/kvm/tlb.c
> +++ b/arch/mips/kvm/tlb.c
> @@ -20,6 +20,7 @@
>   
>   #include <asm/cpu.h>
>   #include <asm/bootinfo.h>
> +#include <asm/mipsregs.h>
>   #include <asm/mmu_context.h>
>   #include <asm/pgtable.h>
>   #include <asm/cacheflush.h>
> @@ -622,6 +623,46 @@ void kvm_vz_load_guesttlb(const struct kvm_mips_tlb *buf, unsigned int index,
>   }
>   EXPORT_SYMBOL_GPL(kvm_vz_load_guesttlb);
>   
> +#ifdef CONFIG_CPU_LOONGSON64
> +void kvm_loongson_clear_guest_vtlb(void)
> +{
> +	int idx = read_gc0_index();
> +
> +	/* Set root GuestID for root probe and write of guest TLB entry */
> +	set_root_gid_to_guest_gid();
> +
> +	write_gc0_index(0);
> +	guest_tlbinvf();
> +	write_gc0_index(idx);
> +
> +	clear_root_gid();
> +	set_c0_diag(LOONGSON_DIAG_ITLB | LOONGSON_DIAG_DTLB);
> +}
> +EXPORT_SYMBOL_GPL(kvm_loongson_clear_guest_vtlb);
> +
> +void kvm_loongson_clear_guest_ftlb(void)
> +{
> +	int i;
> +	int idx = read_gc0_index();
> +
> +	/* Set root GuestID for root probe and write of guest TLB entry */
> +	set_root_gid_to_guest_gid();
> +
> +	for (i = current_cpu_data.tlbsizevtlb;
> +	     i < (current_cpu_data.tlbsizevtlb +
> +		     current_cpu_data.tlbsizeftlbsets);
> +	     i++) {
> +		write_gc0_index(i);
> +		guest_tlbinvf();
> +	}
> +	write_gc0_index(idx);
> +
> +	clear_root_gid();
> +	set_c0_diag(LOONGSON_DIAG_ITLB | LOONGSON_DIAG_DTLB);
> +}
> +EXPORT_SYMBOL_GPL(kvm_loongson_clear_guest_ftlb);
> +#endif
> +
>   #endif
>   
>   /**
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index 72a62f1..73701c3 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -127,6 +127,11 @@ static inline unsigned int kvm_vz_config5_guest_wrmask(struct kvm_vcpu *vcpu)
>   	return mask;
>   }
>   
> +static inline unsigned int kvm_vz_config6_guest_wrmask(struct kvm_vcpu *vcpu)
> +{
> +	return MIPS_CONF6_LOONGSON_INTIMER | MIPS_CONF6_LOONGSON_EXTIMER;

This depends on the "MIPS: Tidy up CP0.Config6 bits definition" patch 
which is not yet upstream.

I'd suggest backing this change out to prioritize upstreaming of v6. 
Cleanups can always come later. It's not like this kind of minor 
cleanups should block progress of greater things...

> +}
> +
>   /*
>    * VZ optionally allows these additional Config bits to be written by root:
>    * Config:	M, [MT]
> @@ -181,6 +186,12 @@ static inline unsigned int kvm_vz_config5_user_wrmask(struct kvm_vcpu *vcpu)
>   	return kvm_vz_config5_guest_wrmask(vcpu) | MIPS_CONF5_MRP;
>   }
>   
> +static inline unsigned int kvm_vz_config6_user_wrmask(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_vz_config6_guest_wrmask(vcpu) |
> +		MIPS_CONF6_LOONGSON_SFBEN | MIPS_CONF6_LOONGSON_FTLBDIS;
> +}
> +
>   static gpa_t kvm_vz_gva_to_gpa_cb(gva_t gva)
>   {
>   	/* VZ guest has already converted gva to gpa */
> @@ -930,7 +941,8 @@ static enum emulation_result kvm_vz_gpsi_cop0(union mips_instruction inst,
>   				    (sel == 2 ||	/* SRSCtl */
>   				     sel == 3)) ||	/* SRSMap */
>   				   (rd == MIPS_CP0_CONFIG &&
> -				    (sel == 7)) ||	/* Config7 */
> +				    (sel == 6 ||	/* Config6 */
> +				     sel == 7)) ||	/* Config7 */
>   				   (rd == MIPS_CP0_LLADDR &&
>   				    (sel == 2) &&	/* MAARI */
>   				    cpu_guest_has_maar &&
> @@ -938,6 +950,11 @@ static enum emulation_result kvm_vz_gpsi_cop0(union mips_instruction inst,
>   				   (rd == MIPS_CP0_ERRCTL &&
>   				    (sel == 0))) {	/* ErrCtl */
>   				val = cop0->reg[rd][sel];
> +#ifdef CONFIG_CPU_LOONGSON64
> +			} else if (rd == MIPS_CP0_DIAG &&
> +				   (sel == 0)) {	/* Diag */
> +				val = cop0->reg[rd][sel];
> +#endif
>   			} else {
>   				val = 0;
>   				er = EMULATE_FAIL;
> @@ -1000,9 +1017,40 @@ static enum emulation_result kvm_vz_gpsi_cop0(union mips_instruction inst,
>   				   cpu_guest_has_maar &&
>   				   !cpu_guest_has_dyn_maar) {
>   				kvm_write_maari(vcpu, val);
> +			} else if (rd == MIPS_CP0_CONFIG &&
> +				   (sel == 6)) {
> +				cop0->reg[rd][sel] = (int)val;
>   			} else if (rd == MIPS_CP0_ERRCTL &&
>   				   (sel == 0)) {	/* ErrCtl */
>   				/* ignore the written value */
> +#ifdef CONFIG_CPU_LOONGSON64
> +			} else if (rd == MIPS_CP0_DIAG &&
> +				   (sel == 0)) {	/* Diag */
> +				unsigned long flags;
> +
> +				local_irq_save(flags);
> +				if (val & LOONGSON_DIAG_BTB) {
> +					/* Flush BTB */
> +					set_c0_diag(LOONGSON_DIAG_BTB);
> +				}
> +				if (val & LOONGSON_DIAG_ITLB) {
> +					/* Flush ITLB */
> +					set_c0_diag(LOONGSON_DIAG_ITLB);
> +				}
> +				if (val & LOONGSON_DIAG_DTLB) {
> +					/* Flush DTLB */
> +					set_c0_diag(LOONGSON_DIAG_DTLB);
> +				}
> +				if (val & LOONGSON_DIAG_VTLB) {
> +					/* Flush VTLB */
> +					kvm_loongson_clear_guest_vtlb();
> +				}
> +				if (val & LOONGSON_DIAG_FTLB) {
> +					/* Flush FTLB */
> +					kvm_loongson_clear_guest_ftlb();
> +				}
> +				local_irq_restore(flags);
> +#endif
>   			} else {
>   				er = EMULATE_FAIL;
>   			}
> @@ -1692,6 +1740,7 @@ static u64 kvm_vz_get_one_regs[] = {
>   	KVM_REG_MIPS_CP0_CONFIG3,
>   	KVM_REG_MIPS_CP0_CONFIG4,
>   	KVM_REG_MIPS_CP0_CONFIG5,
> +	KVM_REG_MIPS_CP0_CONFIG6,
>   #ifdef CONFIG_64BIT
>   	KVM_REG_MIPS_CP0_XCONTEXT,
>   #endif
> @@ -2019,6 +2068,9 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *vcpu,
>   			return -EINVAL;
>   		*v = read_gc0_config5();
>   		break;
> +	case KVM_REG_MIPS_CP0_CONFIG6:
> +		*v = kvm_read_sw_gc0_config6(cop0);
> +		break;
>   	case KVM_REG_MIPS_CP0_MAAR(0) ... KVM_REG_MIPS_CP0_MAAR(0x3f):
>   		if (!cpu_guest_has_maar || cpu_guest_has_dyn_maar)
>   			return -EINVAL;
> @@ -2288,6 +2340,14 @@ static int kvm_vz_set_one_reg(struct kvm_vcpu *vcpu,
>   			write_gc0_config5(v);
>   		}
>   		break;
> +	case KVM_REG_MIPS_CP0_CONFIG6:
> +		cur = kvm_read_sw_gc0_config6(cop0);
> +		change = (cur ^ v) & kvm_vz_config6_user_wrmask(vcpu);
> +		if (change) {
> +			v = cur ^ change;
> +			kvm_write_sw_gc0_config6(cop0, (int)v);
> +		}
> +		break;
>   	case KVM_REG_MIPS_CP0_MAAR(0) ... KVM_REG_MIPS_CP0_MAAR(0x3f):
>   		if (!cpu_guest_has_maar || cpu_guest_has_dyn_maar)
>   			return -EINVAL;

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F96E1A6597
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 13:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgDMLTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 07:19:31 -0400
Received: from vultr.net.flygoat.com ([149.28.68.211]:58484 "EHLO
        vultr.net.flygoat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728826AbgDMLTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 07:19:30 -0400
Received: from flygoat-x1e (unknown [IPv6:240e:390:49e:92c0::d68])
        by vultr.net.flygoat.com (Postfix) with ESMTPSA id 88A9020CF7;
        Mon, 13 Apr 2020 11:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com; s=vultr;
        t=1586776769; bh=UXhLwWCtxUcz+mKOYtgex60WB9mqNaOsxhp6uoAkwDQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nI9oLpWikjHYtk1zNWU+DAzDzaMZA5aGVQ5Y+oRg9DRD1x6X3g0D3C+3rJeKzCnDY
         0LiOvuPyh3RbzyG96fPZrV6B9+gDU6G9gwzcjPtHW2OP9CJCknU8JbxFESB8MPItu4
         Tdqs8cdoy0aihdmxQsH6kDVITEUyE7DTdYVP2uSLmWuPIucmzFnSW2/vmg2jkw1cfP
         5ycXxy570mDfm9CY0u/GM9PONSQGylnb3PLtSvHp1/k+dx06VG1GoIiZONVyIzWgyh
         owu3dZOIlrVo5Upn01hkd5VLu09QdGgHOeww2BzGnnOMJZ6XB3alzQrUHS3ob1gd5W
         pbhH302tpwGBw==
Date:   Mon, 13 Apr 2020 19:19:09 +0800
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>
Subject: Re: [PATCH 13/15] KVM: MIPS: Add CONFIG6 and DIAG registers
 emulation
Message-ID: <20200413191909.4e776272@flygoat-x1e>
In-Reply-To: <1586763024-12197-14-git-send-email-chenhc@lemote.com>
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
        <1586763024-12197-14-git-send-email-chenhc@lemote.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Apr 2020 15:30:22 +0800
Huacai Chen <chenhc@lemote.com> wrote:

> Loongson-3 has CONFIG6 and DIAG registers which need to be emulate.
> CONFIG6 is mostly used to enable/disable FTLB and SFB, while DIAG is
> mostly used to flush BTB, ITLB, DTLB, VTLB and FTLB.
> 
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>

It should be guarded by CONFIG_CPU_LOONGSON64 as well.

Thanks.

> ---
>  arch/mips/include/asm/kvm_host.h |  5 ++++
>  arch/mips/include/asm/mipsregs.h |  7 +++++
>  arch/mips/kvm/tlb.c              | 39 +++++++++++++++++++++++++++
>  arch/mips/kvm/vz.c               | 58
> +++++++++++++++++++++++++++++++++++++++- 4 files changed, 108
> insertions(+), 1 deletion(-)
> 
> diff --git a/arch/mips/include/asm/kvm_host.h
> b/arch/mips/include/asm/kvm_host.h index c291767..3ef6ca8 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -68,9 +68,11 @@
>  #define KVM_REG_MIPS_CP0_CONFIG3	MIPS_CP0_32(16, 3)
>  #define KVM_REG_MIPS_CP0_CONFIG4	MIPS_CP0_32(16, 4)
>  #define KVM_REG_MIPS_CP0_CONFIG5	MIPS_CP0_32(16, 5)
> +#define KVM_REG_MIPS_CP0_CONFIG6	MIPS_CP0_32(16, 6)
>  #define KVM_REG_MIPS_CP0_CONFIG7	MIPS_CP0_32(16, 7)
>  #define KVM_REG_MIPS_CP0_MAARI		MIPS_CP0_64(17, 2)
>  #define KVM_REG_MIPS_CP0_XCONTEXT	MIPS_CP0_64(20, 0)
> +#define KVM_REG_MIPS_CP0_DIAG		MIPS_CP0_32(22, 0)
>  #define KVM_REG_MIPS_CP0_ERROREPC	MIPS_CP0_64(30, 0)
>  #define KVM_REG_MIPS_CP0_KSCRATCH1	MIPS_CP0_64(31, 2)
>  #define KVM_REG_MIPS_CP0_KSCRATCH2	MIPS_CP0_64(31, 3)
> @@ -256,6 +258,7 @@ struct mips_coproc {
>  #define MIPS_CP0_WATCH_LO	18
>  #define MIPS_CP0_WATCH_HI	19
>  #define MIPS_CP0_TLB_XCONTEXT	20
> +#define MIPS_CP0_DIAG		22
>  #define MIPS_CP0_ECC		26
>  #define MIPS_CP0_CACHE_ERR	27
>  #define MIPS_CP0_TAG_LO		28
> @@ -927,6 +930,8 @@ void kvm_vz_save_guesttlb(struct kvm_mips_tlb
> *buf, unsigned int index, unsigned int count);
>  void kvm_vz_load_guesttlb(const struct kvm_mips_tlb *buf, unsigned
> int index, unsigned int count);
> +void kvm_loongson_clear_guest_vtlb(void);
> +void kvm_loongson_clear_guest_ftlb(void);
>  #endif
>  
>  void kvm_mips_suspend_mm(int cpu);
> diff --git a/arch/mips/include/asm/mipsregs.h
> b/arch/mips/include/asm/mipsregs.h index 796fe47..ce40fbf 100644
> --- a/arch/mips/include/asm/mipsregs.h
> +++ b/arch/mips/include/asm/mipsregs.h
> @@ -674,6 +674,9 @@
>  #define MIPS_CONF5_CV		(_ULCAST_(1) << 29)
>  #define MIPS_CONF5_K		(_ULCAST_(1) << 30)
>  
> +#define MIPS_CONF6_INTIMER	(_ULCAST_(1) << 6)
> +#define MIPS_CONF6_EXTIMER	(_ULCAST_(1) << 7)
> +#define MIPS_CONF6_SFBEN	(_ULCAST_(1) << 8)
>  #define MIPS_CONF6_SYND		(_ULCAST_(1) << 13)
>  /* proAptiv FTLB on/off bit */
>  #define MIPS_CONF6_FTLBEN	(_ULCAST_(1) << 15)
> @@ -993,6 +996,8 @@
>  /* Disable Branch Return Cache */
>  #define R10K_DIAG_D_BRC		(_ULCAST_(1) << 22)
>  
> +/* Flush BTB */
> +#define LOONGSON_DIAG_BTB	(_ULCAST_(1) << 1)
>  /* Flush ITLB */
>  #define LOONGSON_DIAG_ITLB	(_ULCAST_(1) << 2)
>  /* Flush DTLB */
> @@ -2825,7 +2830,9 @@ __BUILD_SET_C0(status)
>  __BUILD_SET_C0(cause)
>  __BUILD_SET_C0(config)
>  __BUILD_SET_C0(config5)
> +__BUILD_SET_C0(config6)
>  __BUILD_SET_C0(config7)
> +__BUILD_SET_C0(diag)
>  __BUILD_SET_C0(intcontrol)
>  __BUILD_SET_C0(intctl)
>  __BUILD_SET_C0(srsmap)
> diff --git a/arch/mips/kvm/tlb.c b/arch/mips/kvm/tlb.c
> index 7cd9216..1efb9a0 100644
> --- a/arch/mips/kvm/tlb.c
> +++ b/arch/mips/kvm/tlb.c
> @@ -20,6 +20,7 @@
>  
>  #include <asm/cpu.h>
>  #include <asm/bootinfo.h>
> +#include <asm/mipsregs.h>
>  #include <asm/mmu_context.h>
>  #include <asm/pgtable.h>
>  #include <asm/cacheflush.h>
> @@ -622,6 +623,44 @@ void kvm_vz_load_guesttlb(const struct
> kvm_mips_tlb *buf, unsigned int index, }
>  EXPORT_SYMBOL_GPL(kvm_vz_load_guesttlb);
>  
> +void kvm_loongson_clear_guest_vtlb(void)
> +{
> +	int idx = read_gc0_index();
> +
> +	/* Set root GuestID for root probe and write of guest TLB
> entry */
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
> +	/* Set root GuestID for root probe and write of guest TLB
> entry */
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
> +
>  #endif
>  
>  /**
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index 0772565..2ea1f13 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -127,6 +127,11 @@ static inline unsigned int
> kvm_vz_config5_guest_wrmask(struct kvm_vcpu *vcpu) return mask;
>  }
>  
> +static inline unsigned int kvm_vz_config6_guest_wrmask(struct
> kvm_vcpu *vcpu) +{
> +	return MIPS_CONF6_INTIMER | MIPS_CONF6_EXTIMER |
> MIPS_CONF6_SYND; +}
> +
>  /*
>   * VZ optionally allows these additional Config bits to be written
> by root:
>   * Config:	M, [MT]
> @@ -181,6 +186,12 @@ static inline unsigned int
> kvm_vz_config5_user_wrmask(struct kvm_vcpu *vcpu) return
> kvm_vz_config5_guest_wrmask(vcpu) | MIPS_CONF5_MRP; }
>  
> +static inline unsigned int kvm_vz_config6_user_wrmask(struct
> kvm_vcpu *vcpu) +{
> +	return kvm_vz_config6_guest_wrmask(vcpu) |
> +		MIPS_CONF6_SFBEN | MIPS_CONF6_FTLBEN |
> MIPS_CONF6_FTLBDIS; +}
> +
>  static gpa_t kvm_vz_gva_to_gpa_cb(gva_t gva)
>  {
>  	/* VZ guest has already converted gva to gpa */
> @@ -930,7 +941,8 @@ static enum emulation_result
> kvm_vz_gpsi_cop0(union mips_instruction inst, (sel == 2 ||	/*
> SRSCtl */ sel == 3)) ||	/* SRSMap */
>  				   (rd == MIPS_CP0_CONFIG &&
> -				    (sel == 7)) ||	/* Config7
> */
> +				    (sel == 6 ||	/* Config6 */
> +				     sel == 7)) ||	/* Config7
> */ (rd == MIPS_CP0_LLADDR &&
>  				    (sel == 2) &&	/* MAARI */
>  				    cpu_guest_has_maar &&
> @@ -938,6 +950,9 @@ static enum emulation_result
> kvm_vz_gpsi_cop0(union mips_instruction inst, (rd == MIPS_CP0_ERRCTL
> && (sel == 0))) {	/* ErrCtl */
>  				val = cop0->reg[rd][sel];
> +			} else if (rd == MIPS_CP0_DIAG &&
> +				   (sel == 0)) {	/* Diag */
> +				val = cop0->reg[rd][sel];
>  			} else {
>  				val = 0;
>  				er = EMULATE_FAIL;
> @@ -1000,9 +1015,38 @@ static enum emulation_result
> kvm_vz_gpsi_cop0(union mips_instruction inst, cpu_guest_has_maar &&
>  				   !cpu_guest_has_dyn_maar) {
>  				kvm_write_maari(vcpu, val);
> +			} else if (rd == MIPS_CP0_CONFIG &&
> +				   (sel == 6)) {
> +				cop0->reg[rd][sel] = (int)val;
>  			} else if (rd == MIPS_CP0_ERRCTL &&
>  				   (sel == 0)) {	/* ErrCtl */
>  				/* ignore the written value */
> +			} else if (rd == MIPS_CP0_DIAG &&
> +				   (sel == 0)) {	/* Diag */
> +				unsigned long flags;
> +
> +				local_irq_save(flags);
> +				if (val & LOONGSON_DIAG_BTB) {
> +					/* Flush BTB */
> +
> set_c0_diag(LOONGSON_DIAG_BTB);
> +				}
> +				if (val & LOONGSON_DIAG_ITLB) {
> +					/* Flush ITLB */
> +
> set_c0_diag(LOONGSON_DIAG_ITLB);
> +				}
> +				if (val & LOONGSON_DIAG_DTLB) {
> +					/* Flush DTLB */
> +
> set_c0_diag(LOONGSON_DIAG_DTLB);
> +				}
> +				if (val & LOONGSON_DIAG_VTLB) {
> +					/* Flush VTLB */
> +
> kvm_loongson_clear_guest_vtlb();
> +				}
> +				if (val & LOONGSON_DIAG_FTLB) {
> +					/* Flush FTLB */
> +
> kvm_loongson_clear_guest_ftlb();
> +				}
> +				local_irq_restore(flags);
>  			} else {
>  				er = EMULATE_FAIL;
>  			}
> @@ -1665,6 +1709,7 @@ static u64 kvm_vz_get_one_regs[] = {
>  	KVM_REG_MIPS_CP0_CONFIG3,
>  	KVM_REG_MIPS_CP0_CONFIG4,
>  	KVM_REG_MIPS_CP0_CONFIG5,
> +	KVM_REG_MIPS_CP0_CONFIG6,
>  #ifdef CONFIG_64BIT
>  	KVM_REG_MIPS_CP0_XCONTEXT,
>  #endif
> @@ -1992,6 +2037,9 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu
> *vcpu, return -EINVAL;
>  		*v = read_gc0_config5();
>  		break;
> +	case KVM_REG_MIPS_CP0_CONFIG6:
> +		*v = kvm_read_sw_gc0_config6(cop0);
> +		break;
>  	case KVM_REG_MIPS_CP0_MAAR(0) ...
> KVM_REG_MIPS_CP0_MAAR(0x3f): if (!cpu_guest_has_maar ||
> cpu_guest_has_dyn_maar) return -EINVAL;
> @@ -2261,6 +2309,14 @@ static int kvm_vz_set_one_reg(struct kvm_vcpu
> *vcpu, write_gc0_config5(v);
>  		}
>  		break;
> +	case KVM_REG_MIPS_CP0_CONFIG6:
> +		cur = kvm_read_sw_gc0_config6(cop0);
> +		change = (cur ^ v) &
> kvm_vz_config6_user_wrmask(vcpu);
> +		if (change) {
> +			v = cur ^ change;
> +			kvm_write_sw_gc0_config6(cop0, (int)v);
> +		}
> +		break;
>  	case KVM_REG_MIPS_CP0_MAAR(0) ...
> KVM_REG_MIPS_CP0_MAAR(0x3f): if (!cpu_guest_has_maar ||
> cpu_guest_has_dyn_maar) return -EINVAL;


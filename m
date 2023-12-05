Return-Path: <kvm+bounces-3570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9D8D8055CF
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 14:25:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FA3D2818EC
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 13:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A405D8E8;
	Tue,  5 Dec 2023 13:25:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id D3F0018C;
	Tue,  5 Dec 2023 05:25:42 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8AxjuvVJG9lKgs_AA--.57318S3;
	Tue, 05 Dec 2023 21:25:41 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxeuTRJG9l6IZVAA--.59809S3;
	Tue, 05 Dec 2023 21:25:39 +0800 (CST)
Subject: Re: [PATCH v2 1/2] LoongArch: KVM: Add LSX support
To: Tianrui Zhao <zhaotianrui@loongson.cn>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, loongarch@lists.linux.dev,
 Jens Axboe <axboe@kernel.dk>, Mark Brown <broonie@kernel.org>,
 Alex Deucher <alexander.deucher@amd.com>,
 Oliver Upton <oliver.upton@linux.dev>
References: <20231201084619.2255983-1-zhaotianrui@loongson.cn>
 <20231201084619.2255983-2-zhaotianrui@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <4757aae2-83f4-6e20-8fc2-d2ad39126008@loongson.cn>
Date: Tue, 5 Dec 2023 21:25:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20231201084619.2255983-2-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxeuTRJG9l6IZVAA--.59809S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoW3Cw18CF13AryrXFykKw47Jrc_yoW8Jw4UJo
	WjyF10grW8Gw42kan8Kw17tayUZFy0ka1Yka9xCr95u3W7X34Ygry8Kw4SvFy3Xr1qgF43
	ua47KF1DXas3trn5l-sFpf9Il3svdjkaLaAFLSUrUUUUnb8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUOn7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
	xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	JF0_Jw1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwI
	xGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_
	Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8uc_3
	UUUUU==



On 2023/12/1 下午4:46, Tianrui Zhao wrote:
> This patch adds LSX support for LoongArch KVM.
> There will be LSX exception in KVM when guest use the LSX
> instruction. KVM will enable LSX and restore the vector
> registers for guest then return to guest to continue running.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>   arch/loongarch/include/asm/kvm_host.h |  12 ++-
>   arch/loongarch/include/asm/kvm_vcpu.h |  12 +++
>   arch/loongarch/include/uapi/asm/kvm.h |  19 +++--
>   arch/loongarch/kvm/exit.c             |  18 +++++
>   arch/loongarch/kvm/switch.S           |  21 +++++
>   arch/loongarch/kvm/trace.h            |   4 +-
>   arch/loongarch/kvm/vcpu.c             | 109 ++++++++++++++++++++++++--
>   7 files changed, 179 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index 11328700d4f..a53b47093f4 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -21,8 +21,10 @@
>   #include <asm/loongarch.h>
>   
>   /* Loongarch KVM register ids */
> -#define KVM_GET_IOC_CSR_IDX(id)		((id & KVM_CSR_IDX_MASK) >> LOONGARCH_REG_SHIFT)
> -#define KVM_GET_IOC_CPUCFG_IDX(id)	((id & KVM_CPUCFG_IDX_MASK) >> LOONGARCH_REG_SHIFT)
> +#define KVM_GET_IOC_CSR_IDX(id)			((id & KVM_CSR_IDX_MASK) >> LOONGARCH_REG_SHIFT)
> +#define KVM_GET_IOC_CPUCFG_IDX(id)		((id & KVM_CPUCFG_IDX_MASK) >> LOONGARCH_REG_SHIFT)
> +#define KVM_GET_IOC_CPUCFG_SUPPORTED_IDX(id)	((id & KVM_CPUCFG_SUPPORTED_IDX_MASK) >> \
> +						 LOONGARCH_REG_SHIFT)
>   
>   #define KVM_MAX_VCPUS			256
>   #define KVM_MAX_CPUCFG_REGS		21
> @@ -94,6 +96,7 @@ enum emulation_result {
>   #define KVM_LARCH_FPU		(0x1 << 0)
>   #define KVM_LARCH_SWCSR_LATEST	(0x1 << 1)
>   #define KVM_LARCH_HWCSR_USABLE	(0x1 << 2)
> +#define KVM_LARCH_LSX		(0x1 << 3)
>   
>   struct kvm_vcpu_arch {
>   	/*
> @@ -175,6 +178,11 @@ static inline void writel_sw_gcsr(struct loongarch_csrs *csr, int reg, unsigned
>   	csr->csrs[reg] = val;
>   }
>   
> +static inline bool kvm_guest_has_lsx(struct kvm_vcpu_arch *arch)
> +{
> +	return arch->cpucfg[2] & CPUCFG2_LSX;
> +}
> +
>   /* Debug: dump vcpu state */
>   int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
>   
> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
> index 553cfa2b2b1..c629771e122 100644
> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> @@ -55,6 +55,18 @@ void kvm_save_fpu(struct loongarch_fpu *fpu);
>   void kvm_restore_fpu(struct loongarch_fpu *fpu);
>   void kvm_restore_fcsr(struct loongarch_fpu *fpu);
>   
> +#ifdef CONFIG_CPU_HAS_LSX
> +void kvm_own_lsx(struct kvm_vcpu *vcpu);
> +void kvm_save_lsx(struct loongarch_fpu *fpu);
> +void kvm_restore_lsx(struct loongarch_fpu *fpu);
> +void kvm_restore_lsx_upper(struct loongarch_fpu *fpu);
> +#else
> +static inline void kvm_own_lsx(struct kvm_vcpu *vcpu) { }
> +static inline void kvm_save_lsx(struct loongarch_fpu *fpu) { }
> +static inline void kvm_restore_lsx(struct loongarch_fpu *fpu) { }
> +static inline void kvm_restore_lsx_upper(struct loongarch_fpu *fpu) { }
> +#endif
> +
>   void kvm_acquire_timer(struct kvm_vcpu *vcpu);
>   void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long hz);
>   void kvm_reset_timer(struct kvm_vcpu *vcpu);
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
> index c6ad2ee6106..cfea150be8e 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -59,14 +59,16 @@ struct kvm_fpu {
>    * have its own identifier in bits[31..16].
>    */
>   
> -#define KVM_REG_LOONGARCH_GPR		(KVM_REG_LOONGARCH | 0x00000ULL)
> -#define KVM_REG_LOONGARCH_CSR		(KVM_REG_LOONGARCH | 0x10000ULL)
> -#define KVM_REG_LOONGARCH_KVM		(KVM_REG_LOONGARCH | 0x20000ULL)
> -#define KVM_REG_LOONGARCH_FPSIMD	(KVM_REG_LOONGARCH | 0x30000ULL)
> -#define KVM_REG_LOONGARCH_CPUCFG	(KVM_REG_LOONGARCH | 0x40000ULL)
> -#define KVM_REG_LOONGARCH_MASK		(KVM_REG_LOONGARCH | 0x70000ULL)
> -#define KVM_CSR_IDX_MASK		0x7fff
> -#define KVM_CPUCFG_IDX_MASK		0x7fff
> +#define KVM_REG_LOONGARCH_GPR			(KVM_REG_LOONGARCH | 0x00000ULL)
> +#define KVM_REG_LOONGARCH_CSR			(KVM_REG_LOONGARCH | 0x10000ULL)
> +#define KVM_REG_LOONGARCH_KVM			(KVM_REG_LOONGARCH | 0x20000ULL)
> +#define KVM_REG_LOONGARCH_FPSIMD		(KVM_REG_LOONGARCH | 0x30000ULL)
> +#define KVM_REG_LOONGARCH_CPUCFG		(KVM_REG_LOONGARCH | 0x40000ULL)
> +#define KVM_REG_LOONGARCH_CPUCFG_SUPPORTED	(KVM_REG_LOONGARCH | 0x50000ULL)
> +#define KVM_REG_LOONGARCH_MASK			(KVM_REG_LOONGARCH | 0x70000ULL)
> +#define KVM_CSR_IDX_MASK			0x7fff
> +#define KVM_CPUCFG_IDX_MASK			0x7fff
> +#define KVM_CPUCFG_SUPPORTED_IDX_MASK		0x7fff
>   
>   /*
>    * KVM_REG_LOONGARCH_KVM - KVM specific control registers.
> @@ -79,6 +81,7 @@ struct kvm_fpu {
>   #define LOONGARCH_REG_64(TYPE, REG)	(TYPE | KVM_REG_SIZE_U64 | (REG << LOONGARCH_REG_SHIFT))
>   #define KVM_IOC_CSRID(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
>   #define KVM_IOC_CPUCFG(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
> +#define KVM_IOC_CPUCFG_SUPPORTED(REG)	LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG_SUPPORTED, REG)
>   
>   struct kvm_debug_exit_arch {
>   };
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index ce8de3fa472..1b1c58ccc83 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -659,6 +659,23 @@ static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
>   	return RESUME_GUEST;
>   }
>   
> +/*
> + * kvm_handle_lsx_disabled() - Guest used LSX while disabled in root.
> + * @vcpu:      Virtual CPU context.
> + *
> + * Handle when the guest attempts to use LSX when it is disabled in the root
> + * context.
> + */
> +static int kvm_handle_lsx_disabled(struct kvm_vcpu *vcpu)
> +{
> +	if (!kvm_guest_has_lsx(&vcpu->arch))
> +		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> +	else
> +		kvm_own_lsx(vcpu);
> +
> +	return RESUME_GUEST;
> +}
> +
>   /*
>    * LoongArch KVM callback handling for unimplemented guest exiting
>    */
> @@ -687,6 +704,7 @@ static exit_handle_fn kvm_fault_tables[EXCCODE_INT_START] = {
>   	[EXCCODE_TLBS]			= kvm_handle_write_fault,
>   	[EXCCODE_TLBM]			= kvm_handle_write_fault,
>   	[EXCCODE_FPDIS]			= kvm_handle_fpu_disabled,
> +	[EXCCODE_LSXDIS]                = kvm_handle_lsx_disabled,
>   	[EXCCODE_GSPR]			= kvm_handle_gspr,
>   };
>   
> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
> index 0ed9040307b..6c48f7d1ca5 100644
> --- a/arch/loongarch/kvm/switch.S
> +++ b/arch/loongarch/kvm/switch.S
> @@ -245,6 +245,27 @@ SYM_FUNC_START(kvm_restore_fpu)
>   	jr                 ra
>   SYM_FUNC_END(kvm_restore_fpu)
>   
> +#ifdef CONFIG_CPU_HAS_LSX
> +SYM_FUNC_START(kvm_save_lsx)
> +	fpu_save_csr    a0 t1
> +	fpu_save_cc     a0 t1 t2
> +	lsx_save_data   a0 t1
> +	jr              ra
> +SYM_FUNC_END(kvm_save_lsx)
> +
> +SYM_FUNC_START(kvm_restore_lsx)
> +	lsx_restore_data a0 t1
> +	fpu_restore_cc   a0 t1 t2
> +	fpu_restore_csr  a0 t1 t2
> +	jr               ra
> +SYM_FUNC_END(kvm_restore_lsx)
> +
> +SYM_FUNC_START(kvm_restore_lsx_upper)
> +	lsx_restore_all_upper a0 t0 t1
> +	jr                    ra
> +SYM_FUNC_END(kvm_restore_lsx_upper)
> +#endif
> +
>   	.section ".rodata"
>   SYM_DATA(kvm_exception_size, .quad kvm_exc_entry_end - kvm_exc_entry)
>   SYM_DATA(kvm_enter_guest_size, .quad kvm_enter_guest_end - kvm_enter_guest)
> diff --git a/arch/loongarch/kvm/trace.h b/arch/loongarch/kvm/trace.h
> index a1e35d65541..7da4e230e89 100644
> --- a/arch/loongarch/kvm/trace.h
> +++ b/arch/loongarch/kvm/trace.h
> @@ -102,6 +102,7 @@ TRACE_EVENT(kvm_exit_gspr,
>   #define KVM_TRACE_AUX_DISCARD		4
>   
>   #define KVM_TRACE_AUX_FPU		1
> +#define KVM_TRACE_AUX_LSX		2
>   
>   #define kvm_trace_symbol_aux_op				\
>   	{ KVM_TRACE_AUX_SAVE,		"save" },	\
> @@ -111,7 +112,8 @@ TRACE_EVENT(kvm_exit_gspr,
>   	{ KVM_TRACE_AUX_DISCARD,	"discard" }
>   
>   #define kvm_trace_symbol_aux_state			\
> -	{ KVM_TRACE_AUX_FPU,     "FPU" }
> +	{ KVM_TRACE_AUX_FPU,     "FPU" },		\
> +	{ KVM_TRACE_AUX_LSX,     "LSX" }
>   
>   TRACE_EVENT(kvm_aux,
>   	    TP_PROTO(struct kvm_vcpu *vcpu, unsigned int op,
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 73d0c2b9c1a..4820c95091f 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -309,6 +309,34 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
>   	return ret;
>   }
>   
> +static int kvm_get_cpucfg_supported(int id, u64 *v)
> +{
> +	int ret = 0;
> +
> +	if (id < 0 && id >= KVM_MAX_CPUCFG_REGS)
> +		return -EINVAL;
> +
> +	switch (id) {
> +	/* Only CPUCFG2 checking are supported, we will add all CPUCFGs checking later. */
> +	case 2:
> +		/* return CPUCFG2 features which have been supported by KVM */
> +		*v = CPUCFG2_FP     | CPUCFG2_FPSP  | CPUCFG2_FPDP     |
> +		     CPUCFG2_FPVERS | CPUCFG2_LLFTP | CPUCFG2_LLFTPREV |
> +		     CPUCFG2_LAM;
> +		/*
> +		 * if LSX is supported by CPU, it is also supported by KVM,
> +		 * as we implement it.
> +		 */
> +		if (cpu_has_lsx)
> +			*v |= CPUCFG2_LSX;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +	return ret;
> +}
> +
>   static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
>   		const struct kvm_one_reg *reg, u64 *v)
>   {
> @@ -327,6 +355,10 @@ static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
>   		else
>   			ret = -EINVAL;
>   		break;
> +	case KVM_REG_LOONGARCH_CPUCFG_SUPPORTED:
> +		id = KVM_GET_IOC_CPUCFG_SUPPORTED_IDX(reg->id);
> +		ret = kvm_get_cpucfg_supported(id, v);
> +		break;
To be frankly, KVM_REG_LOONGARCH_CPUCFG_SUPPORTED is a little strange, I 
prefer to DEVICE_ATTR for vcpu such as KVM_GET_DEVICE_ATTR, since it 
exists already and also pv stealtime can be used by this ioctl command.


>   	case KVM_REG_LOONGARCH_KVM:
>   		switch (reg->id) {
>   		case KVM_REG_LOONGARCH_COUNTER:
> @@ -365,6 +397,36 @@ static int kvm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   	return ret;
>   }
>   
> +static int kvm_check_cpucfg(int id, u64 val)
> +{
> +	u64 mask;
> +	int ret = 0;
> +
> +	if (id < 0 && id >= KVM_MAX_CPUCFG_REGS)
> +		return -EINVAL;
> +
> +	switch (id) {
> +	case 2:
> +		ret = kvm_get_cpucfg_supported(id, &mask);
> +		/*
> +		 * CPUCFG2 features checking, if features are not supported, return false.
> +		 * Features version checking, if feature enabled but without version bits
> +		 * or feature disabled but along with version bits, return false.
> +		 */
> +		if (!ret) {
> +			if ((val & ~mask) ||
> +			    (!!(val & CPUCFG2_FP)    != !!(val & CPUCFG2_FPVERS)) ||
> +			    (!!(val & CPUCFG2_LLFTP) != !!(val & CPUCFG2_LLFTPREV)))
> +				ret = -EINVAL;
What is the logic for the above sentences? Is there special logic about 
FPVERS?
How about such lines like this?

/*
  * Reserved bit for future usage can not be set
  * FP and LLFTP must be enabled
  */
if ((val & ~mask) || !(val & CPUCFG2_LLFTP) || !(val & CPUCFG2_FP))

Regards
Bibo Mao
> +		} else
> +			ret = -EINVAL;
> +		break;
> +	default:
> +		break;
> +	}
> +	return ret;
> +}
> +
>   static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
>   			const struct kvm_one_reg *reg, u64 v)
>   {
> @@ -378,10 +440,10 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
>   		break;
>   	case KVM_REG_LOONGARCH_CPUCFG:
>   		id = KVM_GET_IOC_CPUCFG_IDX(reg->id);
> -		if (id >= 0 && id < KVM_MAX_CPUCFG_REGS)
> -			vcpu->arch.cpucfg[id] = (u32)v;
> -		else
> -			ret = -EINVAL;
> +		ret = kvm_check_cpucfg(id, v);
> +		if (ret)
> +			break;
> +		vcpu->arch.cpucfg[id] = (u32)v;
>   		break;
>   	case KVM_REG_LOONGARCH_KVM:
>   		switch (reg->id) {
> @@ -561,12 +623,49 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
>   	preempt_enable();
>   }
>   
> +#ifdef CONFIG_CPU_HAS_LSX
> +/* Enable LSX for guest and restore context */
> +void kvm_own_lsx(struct kvm_vcpu *vcpu)
> +{
> +	preempt_disable();
> +
> +	/* Enable LSX for guest */
> +	set_csr_euen(CSR_EUEN_LSXEN | CSR_EUEN_FPEN);
> +	switch (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
> +	case KVM_LARCH_FPU:
> +		/*
> +		 * Guest FPU state already loaded,
> +		 * only restore upper LSX state
> +		 */
> +		kvm_restore_lsx_upper(&vcpu->arch.fpu);
> +		break;
> +	default:
> +		/* Neither FP or LSX already active,
> +		 * restore full LSX state
> +		 */
> +		kvm_restore_lsx(&vcpu->arch.fpu);
> +	break;
> +	}
> +
> +	trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LSX);
> +	vcpu->arch.aux_inuse |= KVM_LARCH_LSX | KVM_LARCH_FPU;
> +	preempt_enable();
> +}
> +#endif
> +
>   /* Save context and disable FPU */
>   void kvm_lose_fpu(struct kvm_vcpu *vcpu)
>   {
>   	preempt_disable();
>   
> -	if (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
> +	if (vcpu->arch.aux_inuse & KVM_LARCH_LSX) {
> +		kvm_save_lsx(&vcpu->arch.fpu);
> +		vcpu->arch.aux_inuse &= ~(KVM_LARCH_LSX | KVM_LARCH_FPU);
> +		trace_kvm_aux(vcpu, KVM_TRACE_AUX_SAVE, KVM_TRACE_AUX_LSX);
> +
> +		/* Disable LSX & FPU */
> +		clear_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN);
> +	} else if (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
>   		kvm_save_fpu(&vcpu->arch.fpu);
>   		vcpu->arch.aux_inuse &= ~KVM_LARCH_FPU;
>   		trace_kvm_aux(vcpu, KVM_TRACE_AUX_SAVE, KVM_TRACE_AUX_FPU);
> 



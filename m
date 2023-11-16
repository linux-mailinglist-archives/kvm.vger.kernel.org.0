Return-Path: <kvm+bounces-1877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD1177EDBDB
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 08:19:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEF1E1C209EA
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 07:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 641E1FBE2;
	Thu, 16 Nov 2023 07:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="KA5J/G4U"
X-Original-To: kvm@vger.kernel.org
X-Greylist: delayed 263 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Nov 2023 23:19:25 PST
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A96C5;
	Wed, 15 Nov 2023 23:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1700119163; bh=q2AuehPSVg0PAMSpgfi8EJzOTmrs6NwGqXh97Sh11+Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KA5J/G4UWDHFRE1c0EwMstzoUwRQYy+31GHqhkrgTtAWX/o/FY1SZ+czziBtEZvQ0
	 dzHnpB3y4OGJwtuBJ/hJQJBBEjd23BRQcHBVdWZBvPa+ZiQPPfGTYO8rqqRe3g7Tt8
	 dWbA+U4QiRy6lUamE8A0a7NCfw+BNQmftIqM97r8=
Received: from [IPV6:240e:388:8d26:bf00:6f50:1e00:d62c:dcf9] (unknown [IPv6:240e:388:8d26:bf00:6f50:1e00:d62c:dcf9])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 79AC16018A;
	Thu, 16 Nov 2023 15:19:23 +0800 (CST)
Message-ID: <f003f38d-37fd-43ed-ada6-fb2d5b282e91@xen0n.name>
Date: Thu, 16 Nov 2023 15:19:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] LoongArch: KVM: Add lasx support
Content-Language: en-US
To: Tianrui Zhao <zhaotianrui@loongson.cn>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, loongarch@lists.linux.dev,
 Jens Axboe <axboe@kernel.dk>, Mark Brown <broonie@kernel.org>,
 Alex Deucher <alexander.deucher@amd.com>,
 Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
 Xi Ruoyao <xry111@xry111.site>
References: <20231115091921.85516-1-zhaotianrui@loongson.cn>
 <20231115091921.85516-3-zhaotianrui@loongson.cn>
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <20231115091921.85516-3-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/23 17:19, Tianrui Zhao wrote:
> This patch adds LASX support for LoongArch KVM. The LASX means
> LoongArch 256-bits vector instruction.
> There will be LASX exception in KVM when guest use the LASX
> instruction. KVM will enable LASX and restore the vector
> registers for guest then return to guest to continue running.
>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>   arch/loongarch/include/asm/kvm_host.h |  6 ++++
>   arch/loongarch/include/asm/kvm_vcpu.h | 10 +++++++
>   arch/loongarch/kernel/fpu.S           |  1 +
>   arch/loongarch/kvm/exit.c             | 18 +++++++++++
>   arch/loongarch/kvm/switch.S           | 16 ++++++++++
>   arch/loongarch/kvm/trace.h            |  4 ++-
>   arch/loongarch/kvm/vcpu.c             | 43 ++++++++++++++++++++++++++-
>   7 files changed, 96 insertions(+), 2 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index 6c65c25169..4c05b5eca0 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -95,6 +95,7 @@ enum emulation_result {
>   #define KVM_LARCH_SWCSR_LATEST	(0x1 << 1)
>   #define KVM_LARCH_HWCSR_USABLE	(0x1 << 2)
>   #define KVM_LARCH_LSX		(0x1 << 3)
> +#define KVM_LARCH_LASX		(0x1 << 4)
>   
>   struct kvm_vcpu_arch {
>   	/*
> @@ -181,6 +182,11 @@ static inline bool kvm_guest_has_lsx(struct kvm_vcpu_arch *arch)
>   	return arch->cpucfg[2] & CPUCFG2_LSX;
>   }
>   
> +static inline bool kvm_guest_has_lasx(struct kvm_vcpu_arch *arch)
> +{
> +	return arch->cpucfg[2] & CPUCFG2_LASX;
> +}
> +
>   /* Debug: dump vcpu state */
>   int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
>   
> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
> index c629771e12..4f87f16018 100644
> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> @@ -67,6 +67,16 @@ static inline void kvm_restore_lsx(struct loongarch_fpu *fpu) { }
>   static inline void kvm_restore_lsx_upper(struct loongarch_fpu *fpu) { }
>   #endif
>   
> +#ifdef CONFIG_CPU_HAS_LASX
> +void kvm_own_lasx(struct kvm_vcpu *vcpu);
> +void kvm_save_lasx(struct loongarch_fpu *fpu);
> +void kvm_restore_lasx(struct loongarch_fpu *fpu);
> +#else
> +static inline void kvm_own_lasx(struct kvm_vcpu *vcpu) { }
> +static inline void kvm_save_lasx(struct loongarch_fpu *fpu) { }
> +static inline void kvm_restore_lasx(struct loongarch_fpu *fpu) { }
> +#endif
> +
>   void kvm_acquire_timer(struct kvm_vcpu *vcpu);
>   void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long hz);
>   void kvm_reset_timer(struct kvm_vcpu *vcpu);
> diff --git a/arch/loongarch/kernel/fpu.S b/arch/loongarch/kernel/fpu.S
> index d53ab10f46..f4524fe866 100644
> --- a/arch/loongarch/kernel/fpu.S
> +++ b/arch/loongarch/kernel/fpu.S
> @@ -384,6 +384,7 @@ SYM_FUNC_START(_restore_lasx_upper)
>   	lasx_restore_all_upper a0 t0 t1
>   	jr	ra
>   SYM_FUNC_END(_restore_lasx_upper)
> +EXPORT_SYMBOL(_restore_lasx_upper)

Why the added export? It doesn't seem necessary, given the previous 
patch doesn't have a similar export added for _restore_lsx_upper. (Or if 
it's truly needed it should probably become EXPORT_SYMBOL_GPL.)

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/



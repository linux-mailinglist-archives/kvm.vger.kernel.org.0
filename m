Return-Path: <kvm+bounces-11003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 941228720C0
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:48:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7F4C1C2307B
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 757AA86126;
	Tue,  5 Mar 2024 13:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="SmlqgSF0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE26085C58
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646502; cv=none; b=D+4McWvMzQaxcDOpmT6NkhgNbAcH2qQ1j35dciIUz37FNF2Wgx+kJp+uJJCfZVq15NrDQlTgNA6ddtI0fPkQpJpOfoJiE83pTygs855urX97NuRF6OS4C8YCZW+xFb7c+oA/iyQ/Yj1Gq956shd9FEniYrXRlasxz0Dr42qvUUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646502; c=relaxed/simple;
	bh=2KXkpsxN1lgqGABrhGOYrsBzf6Kvvx86Tc1kjd2Zxqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b21bfs/iwPthcQgbws1t9A00+DHWakNNLpBKQ070YqtojjDrHhSP4csUPgRg/gvuasrCXpLVHUHyQqq7wcDA0fEbh+w7K9230w1fafaIA09g6MROJRWipxwyDZAy4vuwzQFwRKJxCOmB1VHfCUmRi8+5WueuKVEfGXK64oj0a7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=SmlqgSF0; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-565b434f90aso8194273a12.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709646499; x=1710251299; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sJuX2pTfeLB+VLJpWMscGvDEOyaaYlSALvyzPhiuVoc=;
        b=SmlqgSF06z+yvyNLny9qCch3XTumzMIlbCaUEEAw+9Sh21IOLobU2gM5YrQGCukbkb
         ld1bJc+InZxwyl9g49CboiOs3D9czT/PYb8r/IzuDR9s4Vs4ios4YUyOscsPdXyWBAKF
         CsB9XYmuC0Qqpa/O+G73gzmaDGkx1FOAtgdnqFB049kA1adgL2kr4fWWMaxkY9EIbzlX
         GD1bYY96mLlfYnjA+5KAmZvG512irQ3Dwi3LpEspXr8iQC6mOpiW6VoM6ThL/ZAC6YgH
         aQi+lAy2T8IoI+7krk5PmkO4iqGTBtoGLOAqsdUQaMdtFZRB9/XpbAilxfOw63ASXbkG
         wbCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646499; x=1710251299;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJuX2pTfeLB+VLJpWMscGvDEOyaaYlSALvyzPhiuVoc=;
        b=nlJq2B1T/LH9mk9QpxkAtBtEtPbPVJcqQEKPZm0EU8qs8oEh/gxwPA9a6MCzAUnVcY
         5MZVAqTuC/iuMlKeGwfXzr641vz8vCkZw2WDPqKmlHBRnJ4K4vh/CHQ+qoQraEM7qqJL
         nv/VGVYmqtr+FXPlHBxPJr736w4FI6PFosS8BMvbVtcD0IDiCsk+f9T0VU+E26kMji/+
         bN3FSuYl9G4h2HAnUBn4hCXcdehROfw+ACfWLGRYRyN7nNEHcorrR+yTVO3reDSM+KUD
         9sGplsREh7Ioz13aNE91HlOuoo1CORsQIg643aRALWspW3dPs21ktpI3h2UZlHLYUpck
         P0Xw==
X-Forwarded-Encrypted: i=1; AJvYcCVB+C0sZx6uHXmw2ZyGZIsnHy8gzDP+R5Gs5PI6GmwDAOphd85EV09sRgIdM/uJUE9N4Cb8geEvVpRrDiapiO1Ahqae
X-Gm-Message-State: AOJu0Yybw0FBgdHXoS1SA9WgYI0K83bL0vh0wra9uib8ExUps9gw6kCs
	hIsWmjurX/9c6fJjPRa/gAAU68CgSdxpFPYoE1dc+tqoPQpyQ7nU2zIOYv9o/ro=
X-Google-Smtp-Source: AGHT+IEAgjhT/lqjA5MRldhJ3+hc0q34M6Yq4HfTqIoSvhgdv6g5aHKkTKZQRoGnpi8x/FYUhx3C6w==
X-Received: by 2002:a05:6402:323:b0:566:4ba7:157e with SMTP id q3-20020a056402032300b005664ba7157emr9281905edw.14.1709646499203;
        Tue, 05 Mar 2024 05:48:19 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id h6-20020a0564020e0600b00566d87734c0sm4722138edh.16.2024.03.05.05.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 05:48:18 -0800 (PST)
Date: Tue, 5 Mar 2024 14:48:17 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 04/10] riscv: Add scalar crypto extensions support
Message-ID: <20240305-76d8a07fc239392a757ba9cf@orel>
References: <20240214122141.305126-1-apatel@ventanamicro.com>
 <20240214122141.305126-5-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214122141.305126-5-apatel@ventanamicro.com>

On Wed, Feb 14, 2024 at 05:51:35PM +0530, Anup Patel wrote:
> When the scalar extensions are available expose them to the guest
> via device tree so that guest can use it. This includes extensions
> Zbkb, Zbkc, Zbkx, Zknd, Zkne, Zknh, Zkr, Zksed, Zksh, and Zkt.
> 
> The Zkr extension requires SEED CSR emulation in user space so
> we also add related KVM_EXIT_RISCV_CSR handling.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/fdt.c                         | 10 ++++++++++
>  riscv/include/kvm/csr.h             | 15 ++++++++++++++
>  riscv/include/kvm/kvm-config-arch.h | 30 ++++++++++++++++++++++++++++
>  riscv/kvm-cpu.c                     | 31 +++++++++++++++++++++++++++++
>  4 files changed, 86 insertions(+)
>  create mode 100644 riscv/include/kvm/csr.h
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index 84b6087..be87e9a 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -25,6 +25,9 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"zba", KVM_RISCV_ISA_EXT_ZBA},
>  	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
>  	{"zbc", KVM_RISCV_ISA_EXT_ZBC},
> +	{"zbkb", KVM_RISCV_ISA_EXT_ZBKB},
> +	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC},
> +	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
>  	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
>  	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
>  	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
> @@ -34,6 +37,13 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"zifencei", KVM_RISCV_ISA_EXT_ZIFENCEI},
>  	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
>  	{"zihpm", KVM_RISCV_ISA_EXT_ZIHPM},
> +	{"zknd", KVM_RISCV_ISA_EXT_ZKND},
> +	{"zkne", KVM_RISCV_ISA_EXT_ZKNE},
> +	{"zknh", KVM_RISCV_ISA_EXT_ZKNH},
> +	{"zkr", KVM_RISCV_ISA_EXT_ZKR},
> +	{"zksed", KVM_RISCV_ISA_EXT_ZKSED},
> +	{"zksh", KVM_RISCV_ISA_EXT_ZKSH},
> +	{"zkt", KVM_RISCV_ISA_EXT_ZKT},
>  };
>  
>  static void dump_fdt(const char *dtb_file, void *fdt)
> diff --git a/riscv/include/kvm/csr.h b/riscv/include/kvm/csr.h
> new file mode 100644
> index 0000000..2d27f74
> --- /dev/null
> +++ b/riscv/include/kvm/csr.h
> @@ -0,0 +1,15 @@

SPDX header?

> +#ifndef KVM__KVM_CSR_H
> +#define KVM__KVM_CSR_H
> +
> +#include <linux/const.h>
> +
> +/* Scalar Crypto Extension - Entropy */
> +#define CSR_SEED		0x015
> +#define SEED_OPST_MASK		_AC(0xC0000000, UL)
> +#define SEED_OPST_BIST		_AC(0x00000000, UL)
> +#define SEED_OPST_WAIT		_AC(0x40000000, UL)
> +#define SEED_OPST_ES16		_AC(0x80000000, UL)
> +#define SEED_OPST_DEAD		_AC(0xC0000000, UL)
> +#define SEED_ENTROPY_MASK	_AC(0xFFFF, UL)
> +
> +#endif /* KVM__KVM_CSR_H */
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index 6d09eee..3764d7c 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -52,6 +52,15 @@ struct kvm_config_arch {
>  	OPT_BOOLEAN('\0', "disable-zbc",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBC],	\
>  		    "Disable Zbc Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zbkb",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBKB],	\
> +		    "Disable Zbkb Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zbkc",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBKC],	\
> +		    "Disable Zbkc Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zbkx",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBKX],	\
> +		    "Disable Zbkx Extension"),				\
>  	OPT_BOOLEAN('\0', "disable-zbs",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],	\
>  		    "Disable Zbs Extension"),				\
> @@ -79,6 +88,27 @@ struct kvm_config_arch {
>  	OPT_BOOLEAN('\0', "disable-zihpm",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHPM],	\
>  		    "Disable Zihpm Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zknd",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKND],	\
> +		    "Disable Zknd Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zkne",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKNE],	\
> +		    "Disable Zkne Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zknh",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKNH],	\
> +		    "Disable Zknh Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zkr",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKR],	\
> +		    "Disable Zkr Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zksed",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKSED],	\
> +		    "Disable Zksed Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zksh",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKSH],	\
> +		    "Disable Zksh Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zkt",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKT],	\
> +		    "Disable Zkt Extension"),				\
>  	OPT_BOOLEAN('\0', "disable-sbi-legacy",				\
>  		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_V01],	\
>  		    "Disable SBI Legacy Extensions"),			\
> diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
> index c4e83c4..3e17c12 100644
> --- a/riscv/kvm-cpu.c
> +++ b/riscv/kvm-cpu.c
> @@ -1,3 +1,4 @@
> +#include "kvm/csr.h"
>  #include "kvm/kvm-cpu.h"
>  #include "kvm/kvm.h"
>  #include "kvm/virtio.h"
> @@ -222,11 +223,41 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
>  	return ret;
>  }
>  
> +static bool kvm_cpu_riscv_csr(struct kvm_cpu *vcpu)
> +{
> +	int dfd = kvm_cpu__get_debug_fd();
> +	bool ret = true;
> +
> +	switch (vcpu->kvm_run->riscv_csr.csr_num) {
> +	case CSR_SEED:
> +		/*
> +		 * We ignore the new_value and write_mask and simply
> +		 * return a random value as SEED.
> +		 */
> +		vcpu->kvm_run->riscv_csr.ret_value = rand() & SEED_ENTROPY_MASK;

Shouldn't this be

 vcpu->kvm_run->riscv_csr.ret_value = SEED_OPST_ES16 | (rand() & SEED_ENTROPY_MASK);

> +		break;
> +	default:
> +		dprintf(dfd, "Unhandled CSR access\n");
> +		dprintf(dfd, "csr_num=0x%lx new_value=0x%lx\n",
> +			vcpu->kvm_run->riscv_csr.csr_num,
> +			vcpu->kvm_run->riscv_csr.new_value);
> +		dprintf(dfd, "write_mask=0x%lx ret_value=0x%lx\n",
> +			vcpu->kvm_run->riscv_csr.write_mask,
> +			vcpu->kvm_run->riscv_csr.ret_value);
> +		ret = false;
> +		break;
> +	};

Extra ';'

> +
> +	return ret;
> +}
> +
>  bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
>  {
>  	switch (vcpu->kvm_run->exit_reason) {
>  	case KVM_EXIT_RISCV_SBI:
>  		return kvm_cpu_riscv_sbi(vcpu);
> +	case KVM_EXIT_RISCV_CSR:
> +		return kvm_cpu_riscv_csr(vcpu);
>  	default:
>  		break;
>  	};
> -- 
> 2.34.1
>

Thanks,
drew


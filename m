Return-Path: <kvm+bounces-12677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF51588BD6B
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 10:16:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3FF82E60B5
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 09:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C30B24CB3D;
	Tue, 26 Mar 2024 09:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="nxjU2nqr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3898441A85
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 09:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711444556; cv=none; b=VaPWN2JIIxJaL8d3oyK/7VAssQfH7lN3Kvo/wa9AV0jriQ7z0hLw2/kF/cVkFEABulvw6nTjAIySW9mZRPvAwT2ooXGKvD1bkqpePeA5k7LUPso9rdKIGC8xcFG3KArbQVX+s+W1eZiRVLLfA70BG8I3eZzsrvnwXfmijWWc4zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711444556; c=relaxed/simple;
	bh=XLHFvcnPjTEDcrZ7qtocNMJeEvkNunE37tgelkHYaEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U9BJGefhNzSdR/vsZwKljFvcupl5JiwazklGIuDeA9udg4ED8+MTaEaeHKenQysVBPjfu71tK/OtbvQAmFSqZYZlRN7f3BnShuXUBwwcvvQjU/o3jV0Mmik4lQTSLW+YCk4FKk8xsLByOUL0VwXrxd/tcZS0opr7PoqLRfA0xNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=nxjU2nqr; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-56bdf81706aso5272346a12.2
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 02:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711444553; x=1712049353; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VlCNflLBPKDMrEvVoV3CR1TjZvh2RoiIM/bv6ClNrh8=;
        b=nxjU2nqrEjrI0purgfgrPp09esS1B77/MpyKJM/ksmHW6pdwDPG5cHEGYaIBAZiATe
         pfEeu52VVyCF4PjaXqX2ADTriGHf+Ob31UzHmI6pb4iXfqFThyIu6rguAKDTvYXwQ50H
         d4U7axiMmMOGBy9oRoo4hPfxy4555NmU5zjQ9lKLCND2uM6sLUAeaTIqG6Zpu2jUI3u3
         dRLxdernWg72q2YL0pzeB9LYrDQ1T5trj6oX2Teo7TRdIGCCKjXCb31oCcOhvdGqmDPu
         4s2xxlsRlHkjP5FDZSzaBcwp4BYGqntlmH8mcVIHrHdBVngiw4w/AQNl87OKI2Kb2bOS
         ULKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711444553; x=1712049353;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VlCNflLBPKDMrEvVoV3CR1TjZvh2RoiIM/bv6ClNrh8=;
        b=rw3ENwEyF/ot3+K7dA8vMgE/taN1GQ8qjnNNsGul+8cduY0B/7tOKotQiyRYqjnyYM
         J2BA98YwxUPlBMxHVfxnmNp/i/pMnyehFYlEd0k6+7Aag4xqpoKlzuUQGYqgIpQk2Y01
         Y+Cabq+spr7Yg8ec6lfTMBlHDt0/mFjIIJBkabT56baSMLLJFKFArMVkXKV1pCZeDUJr
         zuePRS7lL5rdvrWA2PFkLmFDt285Z9GsaYh9wB39Shp0Wd+l4J2IP/KgfhlExhuNPBgi
         uMkEoR8nEbkQZD2TUhSH48zBQ0PKDBIHXhCMo6iSvBCkFaUqF4+FRY4V5w+ThjFIKvFo
         UFWg==
X-Forwarded-Encrypted: i=1; AJvYcCWwB2l0MHJA2AaNCZqxhNfYIxOdKoXdh3HHuphThESikMCtWslLbNGy1s7PvjZdPt1ndYTh+QNM5NSddNLkoNa9+WOS
X-Gm-Message-State: AOJu0Yyh2yIhg5f4Dxs6UjdW6l2FXpQLP5UTmTLMXTQMkFSLygNX/pM7
	xNQGmWqM7LU3pWE64z4pkymvZx3EfwozYwXs4EFgYWiYyEMS1oJSC8ClYcR9TH7PYQn6FcOTbX3
	e/O0=
X-Google-Smtp-Source: AGHT+IGYtMJ8dRY4Rj/5t5yzp/k0rZV6v7R3WaDJiXGBPtthp2P3PUfDTlvIW99jVKiYagK4jOS27Q==
X-Received: by 2002:a50:d5c5:0:b0:56b:6ec6:af2f with SMTP id g5-20020a50d5c5000000b0056b6ec6af2fmr434471edj.6.1711444553580;
        Tue, 26 Mar 2024 02:15:53 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id c13-20020a056402100d00b00568abb329a3sm3938382edu.88.2024.03.26.02.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 02:15:53 -0700 (PDT)
Date: Tue, 26 Mar 2024 10:15:52 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH v2 04/10] riscv: Add scalar crypto extensions
 support
Message-ID: <20240326-c6bc7026dec7fb55764ff728@orel>
References: <20240325153141.6816-1-apatel@ventanamicro.com>
 <20240325153141.6816-5-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325153141.6816-5-apatel@ventanamicro.com>

On Mon, Mar 25, 2024 at 09:01:35PM +0530, Anup Patel wrote:
> When the scalar extensions are available expose them to the guest
> via device tree so that guest can use it. This includes extensions
> Zbkb, Zbkc, Zbkx, Zknd, Zkne, Zknh, Zkr, Zksed, Zksh, and Zkt.
> 
> The Zkr extension requires SEED CSR emulation in user space so
> we also add related KVM_EXIT_RISCV_CSR handling.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/fdt.c                         | 10 +++++++++
>  riscv/include/kvm/csr.h             | 16 +++++++++++++++
>  riscv/include/kvm/kvm-config-arch.h | 30 +++++++++++++++++++++++++++
>  riscv/kvm-cpu.c                     | 32 +++++++++++++++++++++++++++++
>  4 files changed, 88 insertions(+)
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
> index 0000000..bcbf61d
> --- /dev/null
> +++ b/riscv/include/kvm/csr.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
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
> index c4e83c4..ae87848 100644
> --- a/riscv/kvm-cpu.c
> +++ b/riscv/kvm-cpu.c
> @@ -1,3 +1,4 @@
> +#include "kvm/csr.h"
>  #include "kvm/kvm-cpu.h"
>  #include "kvm/kvm.h"
>  #include "kvm/virtio.h"
> @@ -222,11 +223,42 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
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
> +		vcpu->kvm_run->riscv_csr.ret_value = SEED_OPST_ES16;
> +		vcpu->kvm_run->riscv_csr.ret_value |= rand() & SEED_ENTROPY_MASK;
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
> +	}
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

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


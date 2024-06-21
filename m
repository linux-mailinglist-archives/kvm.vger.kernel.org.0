Return-Path: <kvm+bounces-20220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B20911F5F
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:52:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA3031C215E2
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 08:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4D9816D9C4;
	Fri, 21 Jun 2024 08:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="oxdPZVSR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8994316D9C8
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 08:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718959941; cv=none; b=FQqwvfU7kI3up2ySimmGTl+d/+pw9iXnZPCDGzdn6RKpHaXyCxY4R0/LBDW1D61gKzdZx/2BqQ67V0RnEIDJ9Nw7rGKcr6EL4VPq7d75Nh1g6KbjFn5/LvqmLJJ4fT2iIBh8VgEiy1ZC5KQMpCDiVKzFGy/PiQQkyIxnhWVHBZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718959941; c=relaxed/simple;
	bh=oyd6tqzCssv79HaS77mTO3luXMR8x4PmFt1/HZ/Luno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=geKKIjWPpSWdLRq0enH7/uRFCHcIqhAODK8M9NDcTJK9cnjgi4i/bHtk+qjUuXsq0YQm51kda9neH4EeRRg0iSu9J1XRssAwhTBf3in42k8EAZ95UbKQFvBkTwXhv1eptaHsMtKEuulHJ3Oj3LaL9oIbzrux/41WIR01IhgGdSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=oxdPZVSR; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-57d1679ee83so1808790a12.2
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 01:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1718959938; x=1719564738; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ukPXaU0glvKU/7I3AqPS9+256PDmrqJDsAc1cKI4X+E=;
        b=oxdPZVSR6YwNifwjMH1+ZayCkGPHsAM3dSZ6SQjJoUA73/OhIa52xdSoTrmJfu/Njk
         UUF6wSR4PsQCPe2uO4nWfP8yLbcpY9eaJK9bfWyViXR1KvRHIVfDOJXdFZLJqCaKBG15
         2NAqSmw0t2XpvdfMiexD9OfehGT+gSAZdqCC8nA9Dtpi5x0HTPdqf/6cobX7dEa28eW+
         mOV450hVDnGw1w15fk/VMiHZMKWTBa1VKy0hZFaqh6IoQdc25sKpiRWFRrYy4WF4xcGZ
         X9i6DB556qklqfLgmhjrhiw6J4Dhbr1SBnc3dDwG7SPxKvDD9PPnM3Q8EbWd1yHIkACZ
         W21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718959938; x=1719564738;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukPXaU0glvKU/7I3AqPS9+256PDmrqJDsAc1cKI4X+E=;
        b=JG+WX31Pash6125u56q1J5zYGqeO6uI9pzJ3oKHDB1Ohbwt0mDgIm88K7HndGfFJWR
         VgxraGZ0JV06L4aMrV9zCW41f8M30jLo1qUHNdOSENMHrppGIRxLpEP+OXtBhFevRXZH
         iJ7Owg+XaF/m8S3Q5/oiDAXJYtIzCEeQ1Kj8A7II8TVAAqWW6hNmu6r5DK3Ou7mNOsJt
         ON9kYEG92gEH+fGpD2OQE2i/qnDYe14dQcfFIXdqXIgNbAJKLgP9iAfq5lkQRMiBLqzW
         iDAR6tc80sXhZvDTJgPSa7SiNHWgN3ZAqX6cNGkDXMdhTHx4Uo/J3rzweF3E++8JUrTn
         30Aw==
X-Forwarded-Encrypted: i=1; AJvYcCWvUW+HG5uvIWQeo4l24cpGZ2bnjfDZPi+htL9/U++KEwkIESM3FQJ20Sg4jvKqEftNOwZxXT0IfYG4+S+kjglb1n6W
X-Gm-Message-State: AOJu0Yy1LfX4aHKsEXYDbJC/C0wnXVI6NwK4kLIIj+GakHPi8extP2ol
	Tmbwza8rsMEngK+Lac0y1RH01cdK2V16uy85gqm94lx1Jn6aLZCS9FT23qT1QIA=
X-Google-Smtp-Source: AGHT+IEOv3FuOP7yCRAQOMLITeYFGmCeSmvpsPwwBR+OGalAkovKxddKBE/uIo2uXeSYC7CiBt7kXA==
X-Received: by 2002:a50:ed07:0:b0:57c:bf3b:76f5 with SMTP id 4fb4d7f45d1cf-57d07edce7amr5090452a12.35.1718959937580;
        Fri, 21 Jun 2024 01:52:17 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57d30535010sm630961a12.59.2024.06.21.01.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 01:52:17 -0700 (PDT)
Date: Fri, 21 Jun 2024 10:52:16 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, apatel@ventanamicro.com, alex@ghiti.fr, 
	greentime.hu@sifive.com, vincent.chen@sifive.com, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH v5 3/4] RISC-V: KVM: Add Svade and Svadu Extensions
 Support for Guest/VM
Message-ID: <20240621-2c3ffd345cba1317bc0f5f9d@orel>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-4-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605121512.32083-4-yongxuan.wang@sifive.com>

On Wed, Jun 05, 2024 at 08:15:09PM GMT, Yong-Xuan Wang wrote:
> We extend the KVM ISA extension ONE_REG interface to allow VMM tools to
> detect and enable Svade and Svadu extensions for Guest/VM. Since the
> henvcfg.ADUE is read-only zero if the menvcfg.ADUE is zero, the Svadu
> extension is available for Guest/VM only when arch_has_hw_pte_young()
> is true.
> 
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 2 ++
>  arch/riscv/kvm/vcpu.c             | 6 ++++++
>  arch/riscv/kvm/vcpu_onereg.c      | 6 ++++++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index e878e7cc3978..a5e0c35d7e9a 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -168,6 +168,8 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_ZTSO,
>  	KVM_RISCV_ISA_EXT_ZACAS,
>  	KVM_RISCV_ISA_EXT_SSCOFPMF,
> +	KVM_RISCV_ISA_EXT_SVADE,
> +	KVM_RISCV_ISA_EXT_SVADU,
>  	KVM_RISCV_ISA_EXT_MAX,
>  };
>  
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 17e21df36cc1..21edd60c4756 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -540,6 +540,12 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
>  	if (riscv_isa_extension_available(isa, ZICBOZ))
>  		cfg->henvcfg |= ENVCFG_CBZE;
>  
> +	if (riscv_isa_extension_available(isa, SVADU))
> +		cfg->henvcfg |= ENVCFG_ADUE;
> +
> +	if (riscv_isa_extension_available(isa, SVADE))
> +		cfg->henvcfg &= ~ENVCFG_ADUE;

nit: I'd write this as

	if (!riscv_isa_extension_available(isa, SVADE) &&
	    riscv_isa_extension_available(isa, SVADU))
		cfg->henvcfg |= ENVCFG_ADUE;

> +
>  	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN)) {
>  		cfg->hstateen0 |= SMSTATEEN0_HSENVCFG;
>  		if (riscv_isa_extension_available(isa, SSAIA))
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index c676275ea0a0..06e930f1e206 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -15,6 +15,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/cpufeature.h>
>  #include <asm/kvm_vcpu_vector.h>
> +#include <asm/pgtable.h>
>  #include <asm/vector.h>
>  
>  #define KVM_RISCV_BASE_ISA_MASK		GENMASK(25, 0)
> @@ -38,6 +39,8 @@ static const unsigned long kvm_isa_ext_arr[] = {
>  	KVM_ISA_EXT_ARR(SSAIA),
>  	KVM_ISA_EXT_ARR(SSCOFPMF),
>  	KVM_ISA_EXT_ARR(SSTC),
> +	KVM_ISA_EXT_ARR(SVADE),
> +	KVM_ISA_EXT_ARR(SVADU),
>  	KVM_ISA_EXT_ARR(SVINVAL),
>  	KVM_ISA_EXT_ARR(SVNAPOT),
>  	KVM_ISA_EXT_ARR(SVPBMT),
> @@ -105,6 +108,9 @@ static bool kvm_riscv_vcpu_isa_enable_allowed(unsigned long ext)
>  		return __riscv_isa_extension_available(NULL, RISCV_ISA_EXT_SSAIA);
>  	case KVM_RISCV_ISA_EXT_V:
>  		return riscv_v_vstate_ctrl_user_allowed();
> +	case KVM_RISCV_ISA_EXT_SVADU:
> +		/* The henvcfg.ADUE is read-only zero if menvcfg.ADUE is zero. */
> +		return arch_has_hw_pte_young();
>  	default:
>  		break;
>  	}
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>



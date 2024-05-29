Return-Path: <kvm+bounces-18345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EF9A8D413B
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 00:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0AC11F241D2
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 22:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4402A16C680;
	Wed, 29 May 2024 22:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="DzJyPQRf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6E015D5A3
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 22:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717021019; cv=none; b=dSytDzMOBEwA5sByh0Ji0kHbdEvRi6/TA7tCqcsnt0SK+tuGKULZTmMoIyNp32EpWQw5jdTFRlJpVFnopZTTNtqW45jq2sZx6N64fnFULD7PqyrzffCtfa9dze908uJp3QhCNQQIsglOB3ibMljpiOOyAGuSe3SEGPZ7U22gu5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717021019; c=relaxed/simple;
	bh=3ceb4B2s2dAhT+Ha5t1KxT2Yaybyqn2rSazREJDzWsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z+wIbafpRi9MwaGrQb9rjG99Nz0x5K5M7lX9S0QuWAkVGh2/Yq2DVa48ysd0VshZXoQKecCv3O9LroBds7rWAJYN6VME/91TRO30Hp+bzgJ8vNDFGyWTjp37S8nCPMTnKe6c8JW0grhURfE5Fa6r67Qbjj/B3kRAna6YTMeM2QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=DzJyPQRf; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6ff6fe215c6so228402b3a.3
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 15:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1717021017; x=1717625817; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=80ksSo6mSUkyM2Bp/41caPk6UaONL0Ucenm+2d45iFE=;
        b=DzJyPQRfgsCFxff1YeufgSvHrdKe01vWyepGGguDhnaciLdYntdsF8+3VQ59tr4Xs+
         6vdYbzU74XMSXEiOdH7XCuVb0Q1/kfQWXqRsw0jaq9GyEDp5jqg3ARVvz+fi+c/xEo+1
         /k345GxuKts08OI0dCoPWBw/SK5BAHTrIGlLVTfqyxGpLnxpN0k+kRkWJB6xQ0mNxcIX
         Hig6kkVRiulNicdyl7SF58Ls2nyzOUmkZSZAavEabpc/1xuyDQUNVBAPzavoGba6kSM6
         NrfgnOjYa8/XUE5Ih1neXjoCdkPXKSNPtaeOeqMIqR4yenQo37apdJMpmxSlm6V399fF
         icfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717021017; x=1717625817;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=80ksSo6mSUkyM2Bp/41caPk6UaONL0Ucenm+2d45iFE=;
        b=sYADqCttE1VbpupLd2/ZlLSHTrHKFUHsXIL9rXxI+3YbOgIg7+Whx1qAl/FGtdfYNd
         JHvjtzUo/MuxayCrB8wUocSNGIj8cDsM7Oj7bj4wHsjXOMw8bvZfA2v/DkNY+DAMghin
         CR2qgov48guyG3kVHcFuDukBzWUxsx5xe8F4VWZuu3nPv8Ofkfxxr7P42D1EadYxVVBd
         9klEDsIg52Z3QmCj7m8H5Z4hLjwMVjuRuXQcZs7VeOKmTS+3ffFUWubFaeDaJVauRQ5b
         DohDi/f+6xy6NJR3B5wxIap9sZoo7mmAwGH0gYfDM8EFrz+wUQHv9azEpozzd2MMkK2z
         8PBw==
X-Forwarded-Encrypted: i=1; AJvYcCUYgpWxXianMBIdD4tJLBumNHExpxhLy27PPPielPU/Lxe/0+Zo/B7x26GDqD4MwzHxExCf6OCpQJH4ZxfLf42HxMTs
X-Gm-Message-State: AOJu0YzxuHw5XVOqD0KxiDfupYELDKb4e/FOBpEVyOssH+lzJETPcI2D
	CL454Q8t4vdmmO5yOS+AiYgliKN+/zCCANwLTrnxquhXLF1QrgSTucLRxKzkMEM=
X-Google-Smtp-Source: AGHT+IE5XuXetrfb8TvXQ2JVC0+20NvyBoxanxPvqd5tz8uV2AkKu0FS4Ru4PJq/9qbYZb1FKJwuSg==
X-Received: by 2002:a05:6a00:410f:b0:6ea:d114:5ea1 with SMTP id d2e1a72fcca58-7023113ef39mr464430b3a.17.1717021016699;
        Wed, 29 May 2024 15:16:56 -0700 (PDT)
Received: from ghost ([2601:647:5700:6860:32f9:8d5b:110a:1952])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fd4d4ebcsm8503826b3a.187.2024.05.29.15.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 15:16:56 -0700 (PDT)
Date: Wed, 29 May 2024 15:16:53 -0700
From: Charlie Jenkins <charlie@rivosinc.com>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>, Shuah Khan <shuah@kernel.org>,
	Atish Patra <atishp@atishpatra.org>, linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 04/16] RISC-V: KVM: Allow Zimop extension for Guest/VM
Message-ID: <ZlepVSNhhLzpM32y@ghost>
References: <20240517145302.971019-1-cleger@rivosinc.com>
 <20240517145302.971019-5-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240517145302.971019-5-cleger@rivosinc.com>

On Fri, May 17, 2024 at 04:52:44PM +0200, Clément Léger wrote:
> Extend the KVM ISA extension ONE_REG interface to allow KVM user space
> to detect and enable Zimop extension for Guest/VM.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 1 +
>  arch/riscv/kvm/vcpu_onereg.c      | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index b1c503c2959c..35a12aa1953e 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -167,6 +167,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_ZFA,
>  	KVM_RISCV_ISA_EXT_ZTSO,
>  	KVM_RISCV_ISA_EXT_ZACAS,

KVM_RISCV_ISA_EXT_SSCOFPMF got added here in 6.10-rc1 so there is a
conflict now unfortunately. Easy to fix at least!

- Charlie

> +	KVM_RISCV_ISA_EXT_ZIMOP,
>  	KVM_RISCV_ISA_EXT_MAX,
>  };
>  
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index f4a6124d25c9..c6ee763422f2 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -60,6 +60,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
>  	KVM_ISA_EXT_ARR(ZIHINTNTL),
>  	KVM_ISA_EXT_ARR(ZIHINTPAUSE),
>  	KVM_ISA_EXT_ARR(ZIHPM),
> +	KVM_ISA_EXT_ARR(ZIMOP),
>  	KVM_ISA_EXT_ARR(ZKND),
>  	KVM_ISA_EXT_ARR(ZKNE),
>  	KVM_ISA_EXT_ARR(ZKNH),
> @@ -137,6 +138,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
>  	case KVM_RISCV_ISA_EXT_ZIHINTNTL:
>  	case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
>  	case KVM_RISCV_ISA_EXT_ZIHPM:
> +	case KVM_RISCV_ISA_EXT_ZIMOP:
>  	case KVM_RISCV_ISA_EXT_ZKND:
>  	case KVM_RISCV_ISA_EXT_ZKNE:
>  	case KVM_RISCV_ISA_EXT_ZKNH:
> -- 
> 2.43.0
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv


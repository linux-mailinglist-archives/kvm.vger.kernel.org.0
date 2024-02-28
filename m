Return-Path: <kvm+bounces-10249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A71EF86AFFB
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 14:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DDC3B2738A
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 13:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A96314C59D;
	Wed, 28 Feb 2024 13:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="N0jgYr+8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B784B14A4D6
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 13:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709125807; cv=none; b=Z+szudtTem5jjxqrBRfaZ+dwT3fyI3cCf1eHwJA8Qpi8xLFe8YX336sJr1u+Ncgg/eUYBTTrR/syGohOIj6dlXtiW/e2cSLlMt0HY/sQ8B77Gf8a9euKxnlqXGLO6uRLJDaQ4BASrS5wQuxcBYwhbUFJymZlD77DzvaK7Ob8VAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709125807; c=relaxed/simple;
	bh=DWcNsJpw70dUqdDXiZP1i1pmFUT+Xfz8X2cIrud2GCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZjtU8vQupJOMmngPfcKPSN121bRzW3Da8E3va7dteO5/7ZOCl1qzwUIn7sp5PKfuveZdIEPG2f64QAE9oKlwT7e09+n9Mh3gS+3/7GTf4XktsRmF4g9hZ56f+Z4Nnn9ZnpuloO93V/4ZJkLV4opVyTyrVq5OCreGyVNy5xZg7uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=N0jgYr+8; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a28a6cef709so819137066b.1
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 05:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709125804; x=1709730604; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FODdgKK2rthi98pSiTYr1xV3lmm83pq/eRUzwYsWbyA=;
        b=N0jgYr+81zSQ75AvFojHnG5k8lBRMfwzUt8QGLyFL8n6YpqhseIAzB9Q17Z7EywUEA
         rGXF6wOn1V/0DyhD12Rt15o7FwlpIhKyG7tkugva/zrbueLWDK7RjGNriXVPV1E4ktR3
         OVygJlbTcGtzO+lIq3VHUjAS0P5HxHbheMynEkhGUsQWxMHwswpOvoQsUvfroDK3HoZG
         khjr7sMvUF8Q0uFIXTS0CDM+/rkLwNrmPNULHp1ZbKX+Si4ZPeVHUmS6iZj14HPHkEv+
         izh7lNDPGxfempfppTznDYS16KRbK7BkQnmA96q/znQV80asTyCT1MynYySuG48k9epy
         B1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709125804; x=1709730604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FODdgKK2rthi98pSiTYr1xV3lmm83pq/eRUzwYsWbyA=;
        b=QbelKLabiiOIBQzlj/1sZLtjbouWhaxZ9KRPougpSoGfXALoJzBkT3tHre31zzpGL/
         Sr5PFTEpEBvJ+lkiBcmYBAdgse9PzZkvyACpvSPPFxtdNMj9nj/WmNth4l9LhK4FEEe8
         3JI8wen4N3bUmkECZckIdzHiWGm2QO/JoAD62qsd2iQ1286oudEn0CvxGP1u12HtEOl8
         UviAX7vp/41BZK2x5DN5q0awZWSqkf344g8vdroqjL2lHXjQY/xAB+RHsoWRXir3O09w
         uau3AXZQDBcephL8S7EpN3HCMZjEKJY1OrregoFKi7TzOoSVoqqqM8qsO3n3OWydbq5S
         dnXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXRmWTArcFxIJDgtvRK0FfUYPxYbnPTdy7vE5kkrVnuWBHxUSM1hbQm2mXGV1OTN9vS0Zwr3KVXn8cCGnQcq7YdT2/
X-Gm-Message-State: AOJu0Yz4p0tR23p6t14FRY96iU/Nv9Egn5mmJbZcgA8RbiC+WhbyPz8T
	sWSLqegmg9Fb9nQaGA1UMRBVp0Dy+tKmRlUsUeZuvHcO99twf+kGL+74Wb3PCQjgN5fogqvleFr
	1
X-Google-Smtp-Source: AGHT+IFU51uS0qjugebF15xN6PYsd3m2xoOUPf6Oc1ZPyAiIyB/H+qifcBeGzcYm3FzvQHH5BVTPkQ==
X-Received: by 2002:a17:906:ecaf:b0:a43:a1b6:67a7 with SMTP id qh15-20020a170906ecaf00b00a43a1b667a7mr3790245ejb.73.1709125804046;
        Wed, 28 Feb 2024 05:10:04 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id ty6-20020a170907c70600b00a3f27031d7bsm1845582ejc.104.2024.02.28.05.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 05:10:03 -0800 (PST)
Date: Wed, 28 Feb 2024 14:10:02 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 4/5] RISC-V: KVM: Allow Zacas extension for Guest/VM
Message-ID: <20240228-0e0165118517dc2a94e60941@orel>
References: <20240214123757.305347-1-apatel@ventanamicro.com>
 <20240214123757.305347-5-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214123757.305347-5-apatel@ventanamicro.com>

On Wed, Feb 14, 2024 at 06:07:56PM +0530, Anup Patel wrote:
> We extend the KVM ISA extension ONE_REG interface to allow KVM
> user space to detect and enable Zacas extension for Guest/VM.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 1 +
>  arch/riscv/kvm/vcpu_onereg.c      | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index f8aa9f2ace95..37fb0f70b3e5 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -167,6 +167,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_ZVFHMIN,
>  	KVM_RISCV_ISA_EXT_ZFA,
>  	KVM_RISCV_ISA_EXT_ZTSO,
> +	KVM_RISCV_ISA_EXT_ZACAS,
>  	KVM_RISCV_ISA_EXT_MAX,
>  };
>  
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index 38f5cf286087..f4a6124d25c9 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -40,6 +40,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
>  	KVM_ISA_EXT_ARR(SVINVAL),
>  	KVM_ISA_EXT_ARR(SVNAPOT),
>  	KVM_ISA_EXT_ARR(SVPBMT),
> +	KVM_ISA_EXT_ARR(ZACAS),
>  	KVM_ISA_EXT_ARR(ZBA),
>  	KVM_ISA_EXT_ARR(ZBB),
>  	KVM_ISA_EXT_ARR(ZBC),
> @@ -118,6 +119,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
>  	case KVM_RISCV_ISA_EXT_SSTC:
>  	case KVM_RISCV_ISA_EXT_SVINVAL:
>  	case KVM_RISCV_ISA_EXT_SVNAPOT:
> +	case KVM_RISCV_ISA_EXT_ZACAS:
>  	case KVM_RISCV_ISA_EXT_ZBA:
>  	case KVM_RISCV_ISA_EXT_ZBB:
>  	case KVM_RISCV_ISA_EXT_ZBC:
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


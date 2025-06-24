Return-Path: <kvm+bounces-50493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF595AE66E6
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 15:46:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5704168A94
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 13:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5881A29AB0E;
	Tue, 24 Jun 2025 13:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Bdk3jzkf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D627E288AD
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 13:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750772773; cv=none; b=RF1maOeAYgSBS9LV+dvHDXErLZmTW4VMWcL0UVdW7ae0nNYNOB5B8fJhXhKw9DAUjo6H1KCGe/arNXiR08lIar3g4n9OoN0Gnpfk8Ijeyy3EVAA5NdL0XpMnbeamBbxaVGybgZlUd7dFCyVKKXYyZCPbZr06QK/J+BPvvC4YNXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750772773; c=relaxed/simple;
	bh=jbVm1C8GcylpmFH0UtsGkzTR+h6r1Vp3GAFyh6KopKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pm7PuoIO2itbooqriNvz0jARbQkXxLtR5W+UubVyCEOaa47r9lU2NDGBsCD+v9njYqlbCQCoj5pWSGxvgQfiz8bV7tHBqiCihK42pAR1IYIEpoFBG5pGkVrzClSM3WNf6EPGoiO3CQfcqi50PtqmfAd0164g6/KhpvH8IwkDVIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Bdk3jzkf; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a4e742dc97so3853179f8f.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 06:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750772770; x=1751377570; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Eoo0fa0GCv1oBnTiujtR7cKFf/6yNPbDr+2avmoEsNU=;
        b=Bdk3jzkf56AgdBaGqEzBmLoMpC2SSKkH9dD6gYGskBVmWVDfKz/A9+PnRqcWVqAk5r
         3v+HXG0lscoDUYsS7Q0cAli9HMsSwPOG4mzoaRPNc7HIvFHcPRoiyAAANrSuacp5zv0R
         h/owfusUfl+9LFajWjtk59GxNKFv6D+q61kfP8HSkT4q5hh6R+rDUkIphs/h6o2VyDZZ
         MyfCyK7yl55s0KnUPTQZbDkp6RKMvFuNsz1iEWuvLvwKmrFnHX4937KoU3vcHXs5FB5x
         XOiOB3RnV25WdVNIhWuunDNoDBoOO0hqQSn4b+U3EZXhl1x7YWB355sadPP1Ub20YMFu
         L+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750772770; x=1751377570;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eoo0fa0GCv1oBnTiujtR7cKFf/6yNPbDr+2avmoEsNU=;
        b=aMcMytMbzX2G9cPFet4MnkN8NhCtT4NhBRBX2HFynV85yOK9jT7Z5UXg/yVz8+0TDd
         TGzoh62pb2CWZbXcQMu4j6cYzD3rD8/F6icRRA5yt59HzGmWeoJJ5qEt2T7jQIMNUn98
         GCrxz9ZQO5w7VP7yPQe3MLc0L8AH4V2ETjrGFJ4AS9qfGGbCryM7fA65PdVFB67cnc8F
         BoLnW5S9t7V+0GcfX2KgWtWhr7ucVCcTuNTsY1gz72mkATkMlLCFAJNdj5cXxzAjspPf
         cyXxNa/dkJynX8o+HskBOPC+u5+sNoDUJByJgCCzR9ppuq4TKg9M7tZCFmsIWqvS0fAv
         wlcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKD1BA6rsox8v6qOfMb8XTOChAPtTHwKz2Z9tO542CgcX+8cXVFOw6Nh6PPbOZpJnlDaQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjOd+5paNbL1CJ8QM4lzEexURpGqEwkxKUpk6tege0rsbv6d6w
	CrALMYsOVF9E/J1dymEv6FaKpOLZoi12rvoljiEr2jDAApYG7OJ+YoBWxsnPKJjNB+o=
X-Gm-Gg: ASbGncvh5D/d2WsEzZ2b+HETZ1TgrX3HrNl5y9sK+XxRK751G/enmn/ny0qAKmkUfhA
	EazgFxRvqxpA6szkz40Ti0Tmk8jIKGpz9GZfDi8UFnBTmtHdgKuhsEYdIie6x72UROkxQcRG6Xn
	WDbfpKsAoc5NhYNd1e+GQLX5vY+eESqIauUZEOOxOjB0EYUeTtG6hMtzOOWWKYQX0+J+aOoRZOY
	9INUANKUZfizvC+muTIRsgIzpMknhMrNOh4aoc9rInaLRflPmFjlBsCrJn4r9caqmatbhgemz6B
	K2tDPexPPeob1TszVJKGwn3kj3vSNAjAcUCQ/jrJan013HCAAg==
X-Google-Smtp-Source: AGHT+IFEAC1W+Y170mCC2sU03t16kmaicwlOVBXCKZyNDj9U1iBSb9Gp5uGrQiBVTIpsYnn7B2iLdA==
X-Received: by 2002:a05:6000:2583:b0:3a4:dfbe:2b14 with SMTP id ffacd0b85a97d-3a6e71d4cf3mr2905989f8f.16.1750772770139;
        Tue, 24 Jun 2025 06:46:10 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::5485])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e8068fd0sm2066068f8f.38.2025.06.24.06.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:46:09 -0700 (PDT)
Date: Tue, 24 Jun 2025 15:46:08 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 2/5] RISC-V: KVM: Allow Zicbop extension for Guest/VM
Message-ID: <20250624-fd191a60c31c732c0d401f46@orel>
References: <cover.1750164414.git.zhouquan@iscas.ac.cn>
 <e2a040c161f17c1717b64750e774474d8ee8f0d6.1750164414.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2a040c161f17c1717b64750e774474d8ee8f0d6.1750164414.git.zhouquan@iscas.ac.cn>

On Tue, Jun 17, 2025 at 09:10:30PM +0800, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> Extend the KVM ISA extension ONE_REG interface to allow KVM user space
> to detect and enable Zicbop extension for Guest/VM.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 1 +
>  arch/riscv/kvm/vcpu_onereg.c      | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 0863ca178066..56959d277e86 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -185,6 +185,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_ZICCRSE,
>  	KVM_RISCV_ISA_EXT_ZAAMO,
>  	KVM_RISCV_ISA_EXT_ZALRSC,
> +	KVM_RISCV_ISA_EXT_ZICBOP,
>  	KVM_RISCV_ISA_EXT_MAX,
>  };
>  
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index b08a22eaa7a7..d444ec9e9e8e 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -68,6 +68,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
>  	KVM_ISA_EXT_ARR(ZFH),
>  	KVM_ISA_EXT_ARR(ZFHMIN),
>  	KVM_ISA_EXT_ARR(ZICBOM),
> +	KVM_ISA_EXT_ARR(ZICBOP),
>  	KVM_ISA_EXT_ARR(ZICBOZ),
>  	KVM_ISA_EXT_ARR(ZICCRSE),
>  	KVM_ISA_EXT_ARR(ZICNTR),
> @@ -171,6 +172,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
>  	case KVM_RISCV_ISA_EXT_ZFA:
>  	case KVM_RISCV_ISA_EXT_ZFH:
>  	case KVM_RISCV_ISA_EXT_ZFHMIN:
> +	case KVM_RISCV_ISA_EXT_ZICBOP:
>  	case KVM_RISCV_ISA_EXT_ZICCRSE:
>  	case KVM_RISCV_ISA_EXT_ZICNTR:
>  	case KVM_RISCV_ISA_EXT_ZICOND:
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


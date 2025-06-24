Return-Path: <kvm+bounces-50494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DE80AE66EB
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 15:47:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FF767B7392
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 13:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A18392C159A;
	Tue, 24 Jun 2025 13:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="VArFSy3Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1825819B5B1
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 13:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750772799; cv=none; b=dQhfmx6GFIPKZnJd4OLetn89acoB9EgdPXKT6D0ou8Uvw77g1lT/79P/OGfaxcDH3w7NeoYlTmLl8dxMVImX36J21iI9vA/StZfoPW9jx4+gFFksVCoGP1VbJUMLes4a5YJbMAlLGXbuEnGf5kxgCkCVemoeqdkGRfMfgSbCFG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750772799; c=relaxed/simple;
	bh=qFIGByMEUAEOSSBSnLYh1bAg5aSZ7BTIORyI7l77KDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XKp1KnRgkm9WJmPm77FaEb3ZwXpnnGqJ3XZMgfhK7/gPln6loViQKMC3gh1tmRpDHiDzaf2O8Lw4YCzbt/yOcI9iwB/ANjqpSPqj99Sh45IFpbgEEjrScYYqsMQhIreyo9bh2eyt1DcS+lT0WDiOuBKooYbFv6tZr05orD3lHjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=VArFSy3Z; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a525eee2e3so387856f8f.2
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 06:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750772795; x=1751377595; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ohkRZnrz54pdAWpLhDbJvMYBolnW2mbJhdCUdnmMbJk=;
        b=VArFSy3ZGa2rHx2ImUNrcH3AqgMipuLZsDGeK5wJpMsNk975l9Kp+8uf6jgSQX+sNp
         omEvfl5+RCgQ84RaEsK+X3xXqMP840LqonBppX60cOmV5mUr7Hmvj4oau03Xn3uS3LF2
         wwtGpAlPYSq0RymSYbFRkbg3b7n/B6HFLE2kskKz7UM3ps7PveTzIWdvUShzapM/qWbd
         TuK8sjPCepo4ey2zCETfm8/XTzQFAKbVvfUzBeVCshzpgy49eOBYMQE+p+togmg0XKjV
         /GVD17dQ3vmODDwDl78gaKTkIKKSzS6yzRe3OXgkGga7KmdIsq8KsAvO/Is0QRVyeleB
         tnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750772795; x=1751377595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ohkRZnrz54pdAWpLhDbJvMYBolnW2mbJhdCUdnmMbJk=;
        b=O7ZVvDfaIzCTmUtkLHq0oSVG0uGIH1i28KNjAI0ovliZVib7MucP3Nf4zgSkqUEv23
         2ncM92+IeI/PqLyabyOg8tJtHq3BfhfA6N4Jk5x72VdHoZCDarv2z8SVI9RHG/fIfUZD
         tkC2cGuLHQLBw1OuGDGZPjtFULsD8yHgS2eOID5BVcNJHOqPxiLPcxkMqrQZhIo4V3Az
         EAqcZOX3BNlaketFpgqZkTzR7KfvG6f3JF6pAGWg1oBmdRpnbYgZrbUYKgl0Y6CHatnK
         ZaElue0ax73042H1dNnLDl4LeOnQeHonbuxF385BxKd55yJvY+br+3OghwIM6j/UX1gx
         AmHw==
X-Forwarded-Encrypted: i=1; AJvYcCX8jgqQQzg1j9CNj+k+MDeM50Xe/8nXjy8QTIApkEc7xaQalgxDyCNKye3qwqfNnmDxYaA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/8LUk2cyvh+8TTMrhKDKiy76EZzYPGIJQDz2suUOGOyPbT1Ns
	AfL2i9eQP+0lxkhpIUCAwURlRp1gXFToXCDpWegXlHjWltmcytad69kiWAnyfn0SXHI=
X-Gm-Gg: ASbGncswSnIDFQumBJpCvqsp+t1jeeSDSlH1u4e0G0hTaDH6uYeF7FCUqFxx3OXNkKH
	ZTdOL7Sl/qgS79Qd+Gefbv0brH6s10vPT5JVIkhGI4hKbgW+BiyZ3f6SmO3IfYfv0jlnaCPjqQx
	w/uAHSX5krxAfgv2i9Fd5dLUYe3R+NOPaw/YKI5Zny+lxiW9X+YEXIQq1OROJrtoUhMbbSO0IxJ
	B061o1vekpas7aLpnfWoju77/ukWfe9PJg6OcNi/pg8ulTe13mna3RFyG8qJt5B1LnDRzVEKKGH
	Hf9cldKKOy56yM/y2cmvwdBrX560O4Ev8Pz63qaXWDcKQHUbmA==
X-Google-Smtp-Source: AGHT+IEt7t69RQwxRY3eEXaaUWMwhnlyw5hwc/9b4j97KSvQHGz9sdCKF+wVdRShxiN6h2dbaEha3A==
X-Received: by 2002:a05:6000:491d:b0:3a1:f564:cd9d with SMTP id ffacd0b85a97d-3a6d12d92e1mr13250210f8f.36.1750772795336;
        Tue, 24 Jun 2025 06:46:35 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::5485])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f279dsm2047840f8f.64.2025.06.24.06.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:46:34 -0700 (PDT)
Date: Tue, 24 Jun 2025 15:46:33 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 3/5] RISC-V: KVM: Allow bfloat16 extension for Guest/VM
Message-ID: <20250624-08753b120b1b5b7b88416057@orel>
References: <cover.1750164414.git.zhouquan@iscas.ac.cn>
 <effe218d368a37e397b6526f876b33322dbb6e20.1750164414.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <effe218d368a37e397b6526f876b33322dbb6e20.1750164414.git.zhouquan@iscas.ac.cn>

On Tue, Jun 17, 2025 at 09:10:35PM +0800, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> Extend the KVM ISA extension ONE_REG interface to allow KVM user space
> to detect and enable Zfbmin/Zvfbfmin/Zvfbfwma extension for Guest/VM.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 3 +++
>  arch/riscv/kvm/vcpu_onereg.c      | 6 ++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 56959d277e86..79a5ac86597c 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -186,6 +186,9 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_ZAAMO,
>  	KVM_RISCV_ISA_EXT_ZALRSC,
>  	KVM_RISCV_ISA_EXT_ZICBOP,
> +	KVM_RISCV_ISA_EXT_ZFBFMIN,
> +	KVM_RISCV_ISA_EXT_ZVFBFMIN,
> +	KVM_RISCV_ISA_EXT_ZVFBFWMA,
>  	KVM_RISCV_ISA_EXT_MAX,
>  };
>  
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index d444ec9e9e8e..2ba3f2c942ee 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -65,6 +65,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
>  	KVM_ISA_EXT_ARR(ZCF),
>  	KVM_ISA_EXT_ARR(ZCMOP),
>  	KVM_ISA_EXT_ARR(ZFA),
> +	KVM_ISA_EXT_ARR(ZFBFMIN),
>  	KVM_ISA_EXT_ARR(ZFH),
>  	KVM_ISA_EXT_ARR(ZFHMIN),
>  	KVM_ISA_EXT_ARR(ZICBOM),
> @@ -89,6 +90,8 @@ static const unsigned long kvm_isa_ext_arr[] = {
>  	KVM_ISA_EXT_ARR(ZTSO),
>  	KVM_ISA_EXT_ARR(ZVBB),
>  	KVM_ISA_EXT_ARR(ZVBC),
> +	KVM_ISA_EXT_ARR(ZVFBFMIN),
> +	KVM_ISA_EXT_ARR(ZVFBFWMA),
>  	KVM_ISA_EXT_ARR(ZVFH),
>  	KVM_ISA_EXT_ARR(ZVFHMIN),
>  	KVM_ISA_EXT_ARR(ZVKB),
> @@ -170,6 +173,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
>  	case KVM_RISCV_ISA_EXT_ZCF:
>  	case KVM_RISCV_ISA_EXT_ZCMOP:
>  	case KVM_RISCV_ISA_EXT_ZFA:
> +	case KVM_RISCV_ISA_EXT_ZFBFMIN:
>  	case KVM_RISCV_ISA_EXT_ZFH:
>  	case KVM_RISCV_ISA_EXT_ZFHMIN:
>  	case KVM_RISCV_ISA_EXT_ZICBOP:
> @@ -192,6 +196,8 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
>  	case KVM_RISCV_ISA_EXT_ZTSO:
>  	case KVM_RISCV_ISA_EXT_ZVBB:
>  	case KVM_RISCV_ISA_EXT_ZVBC:
> +	case KVM_RISCV_ISA_EXT_ZVFBFMIN:
> +	case KVM_RISCV_ISA_EXT_ZVFBFWMA:
>  	case KVM_RISCV_ISA_EXT_ZVFH:
>  	case KVM_RISCV_ISA_EXT_ZVFHMIN:
>  	case KVM_RISCV_ISA_EXT_ZVKB:
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


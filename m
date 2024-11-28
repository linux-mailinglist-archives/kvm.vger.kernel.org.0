Return-Path: <kvm+bounces-32739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 854BD9DB469
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 10:00:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F243A1647EF
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 09:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3705E15746F;
	Thu, 28 Nov 2024 09:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="P/Vh/rdh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CB2156641
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 09:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732784407; cv=none; b=B6rFDHr4xgn31E30sBDMKbux3CRpZqFfU8O97KI3NVFHjp5L1QXd7IJRTpmRUETokJVVU5pOnS9taWf3UJyw4aMTSWM/pN2GBIQiJ3qMx1ej8JINIHdgIVpvgurKNmceSyOHOwzFfshtm8/kzreazj21SWmDWMpOVDfCFSCV5IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732784407; c=relaxed/simple;
	bh=SZ1cAPREi8YkOAUu8EjRiSHv6wYYsHvKKWtDYq672/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E3s7szx9ADGNieteNhgV3CrX6PxOeQ3y8Nc69uWmm5GPld0N23ApsdOouV60GzHDdgbjZjhJxv4tVIGkY0JYl4DIpYkO6YsS1A5tf/zR7ZOKQLC01tlOxffLI9iURa9cNJ4XgrQb3mGUZp9OPk3z4vMbw7Gudf21CyQy7Mo0RN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=P/Vh/rdh; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-53de79c2be4so560045e87.2
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1732784404; x=1733389204; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oRwUYsVAjpoLFct6AU+sl41M7ai7g8VdSrVmZPLTLdY=;
        b=P/Vh/rdhvdeRnFtyPcruTtnocJYm/rJAnnd0ATniNMqkgLu0hYV0Der6hR6wikWmgS
         bhDmjHtGs3NIrzL6srPGjRzZbjkX5z7Gaqs0N8fajoSa/Eax/75EB5ZuH+Kwcr7CV/99
         YshDhWJWIAT1vsFzp9/I7FYgScVNvXH0Qghd1VgqX0U0qQmqGID1lGNw1JQzsXc0XbbL
         TBQOfjo/iQ97k9CWC7BhmLLSmyuJe5AgRGl7Ci2dYsoCxKtzKrnDNKSqt19pNyb4SRCv
         JhZctPxC71X/OZHWM9kkhwPvRTXsugCE+aPWebNEyA2wcxNkXx2Oe/qWtBVs42eRMyh0
         yenQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732784404; x=1733389204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oRwUYsVAjpoLFct6AU+sl41M7ai7g8VdSrVmZPLTLdY=;
        b=Z9N/lMWEaVARq4f83l9KXT7Qwb51oBLDyaJAoBOhROFaOJYMftLnNn/eRyGs5QF6np
         9/xbr4noW8G/jq665gQxTHJ2GzIwuLGRdtNaAfkhhK/sAV7BXOA1Lgn81A9FEFFeCBRv
         KCiDYsjz4d0oybFoJwqnMXeYCt6nnvdZdVGbGoAy9mbK1dcIJwBnB9IgpkYF5INwv/rj
         PlV6kR0cjSPmSH53dby4/ZuDsSSbTT0dY2rI13Crr5xzfeWLLSNH4v6Xmw+qF6RdHiW+
         wblj1mq2SKFMbJRjd4bjhM6rDMYmgg3LRuQG4g71srVesHnBzH8fET0bg5iSn2dojnU0
         2Cfg==
X-Forwarded-Encrypted: i=1; AJvYcCXZQG5ToneCzg6lGcEgC9vnk83GH+g9InqXURNz5lq4wgB6j0CrWqcBRIjLnGiFqzy0BqA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCBDlKyVlJRWnZt4OeSPxBCPUq5CJK/16eqZ8Wq4m3rfTgQpN0
	glXgIF1PbY3EpcG9hd8bhHmu/dvKZl3CoFL6/IeIifmK5gVCd3G7mK4829RXEEM=
X-Gm-Gg: ASbGncv8Cx9q5vI76VxQjyeetqKEhJV1KGHLhSjvMI0h5rOG2eJY++nyKOVjcJpTJHP
	UQFc7Ww5iZF+0nD70UT7Oy5YBTPAIq0oEmHRwpk1fpdV8XoG1jBlkSGd7zNMUhn7vTi6iDnu/pm
	dMd3FcS7a8k8rEELPQKsIb9di51gFtOzfyn8VbLVp7kzsSn+sFIEP3/nH35/dOy8T9eKX8lJUOu
	TKtWcUQZsRNHkGsQySHaiiH9tzu0zluQeziqksFplSn1OBXGTR9cVTMH+PBezTUWaSYpm2qAQib
	KeTaexLCGda3pEP5j+y9EIN5kpdH+Rl/gpg=
X-Google-Smtp-Source: AGHT+IFvUjDbauPTmEibS/pMaTmIPzKett7QupGp+AywDNDr/16hkqdHs/Gybk1MALYq8E3o2q+udg==
X-Received: by 2002:a05:6512:3b25:b0:53d:d12c:2f02 with SMTP id 2adb3069b0e04-53df00d1b38mr3726286e87.18.1732784403699;
        Thu, 28 Nov 2024 01:00:03 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0dbf95fsm15201885e9.15.2024.11.28.01.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2024 01:00:03 -0800 (PST)
Date: Thu, 28 Nov 2024 10:00:02 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 4/4] KVM: riscv: selftests: Add Svvptc/Zabha/Ziccrse exts
 to get-reg-list test
Message-ID: <20241128-846f2b5fdfda9e1aa9e373ee@orel>
References: <cover.1732762121.git.zhouquan@iscas.ac.cn>
 <21d3a5314a9cd6ac5b3aa445060ae2679a44c792.1732762121.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d3a5314a9cd6ac5b3aa445060ae2679a44c792.1732762121.git.zhouquan@iscas.ac.cn>

On Thu, Nov 28, 2024 at 11:22:14AM +0800, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> The KVM RISC-V allows Svvptc/Zabha/Ziccrse extensions for Guest/VM
> so add them to get-reg-list test.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> index 54ab484d0000..a697db1ff411 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -48,8 +48,10 @@ bool filter_reg(__u64 reg)
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSNPM:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSTC:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVINVAL:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVVPTC:

Alphabetic order, please.

>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVNAPOT:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVPBMT:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZABHA:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZACAS:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZAWRS:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZBA:
> @@ -69,6 +71,7 @@ bool filter_reg(__u64 reg)
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFHMIN:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOM:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOZ:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICCRSE:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICNTR:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICOND:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICSR:
> @@ -423,8 +426,10 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
>  		KVM_ISA_EXT_ARR(SSNPM),
>  		KVM_ISA_EXT_ARR(SSTC),
>  		KVM_ISA_EXT_ARR(SVINVAL),
> +		KVM_ISA_EXT_ARR(SVVPTC),

Same comment as above.

>  		KVM_ISA_EXT_ARR(SVNAPOT),
>  		KVM_ISA_EXT_ARR(SVPBMT),
> +		KVM_ISA_EXT_ARR(ZABHA),
>  		KVM_ISA_EXT_ARR(ZACAS),
>  		KVM_ISA_EXT_ARR(ZAWRS),
>  		KVM_ISA_EXT_ARR(ZBA),
> @@ -444,6 +449,7 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
>  		KVM_ISA_EXT_ARR(ZFHMIN),
>  		KVM_ISA_EXT_ARR(ZICBOM),
>  		KVM_ISA_EXT_ARR(ZICBOZ),
> +		KVM_ISA_EXT_ARR(ZICCRSE),
>  		KVM_ISA_EXT_ARR(ZICNTR),
>  		KVM_ISA_EXT_ARR(ZICOND),
>  		KVM_ISA_EXT_ARR(ZICSR),
> @@ -956,8 +962,10 @@ KVM_ISA_EXT_SIMPLE_CONFIG(sscofpmf, SSCOFPMF);
>  KVM_ISA_EXT_SIMPLE_CONFIG(ssnpm, SSNPM);
>  KVM_ISA_EXT_SIMPLE_CONFIG(sstc, SSTC);
>  KVM_ISA_EXT_SIMPLE_CONFIG(svinval, SVINVAL);
> +KVM_ISA_EXT_SIMPLE_CONFIG(svvptc, SVVPTC);

Same comment as above.

>  KVM_ISA_EXT_SIMPLE_CONFIG(svnapot, SVNAPOT);
>  KVM_ISA_EXT_SIMPLE_CONFIG(svpbmt, SVPBMT);
> +KVM_ISA_EXT_SIMPLE_CONFIG(zabha, ZABHA);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zacas, ZACAS);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zawrs, ZAWRS);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zba, ZBA);
> @@ -977,6 +985,7 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zfh, ZFH);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zfhmin, ZFHMIN);
>  KVM_ISA_EXT_SUBLIST_CONFIG(zicbom, ZICBOM);
>  KVM_ISA_EXT_SUBLIST_CONFIG(zicboz, ZICBOZ);
> +KVM_ISA_EXT_SIMPLE_CONFIG(ziccrse, ZICCRSE);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zicntr, ZICNTR);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zicond, ZICOND);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zicsr, ZICSR);
> @@ -1021,8 +1030,10 @@ struct vcpu_reg_list *vcpu_configs[] = {
>  	&config_ssnpm,
>  	&config_sstc,
>  	&config_svinval,
> +	&config_svvptc,

Same comment as above.

>  	&config_svnapot,
>  	&config_svpbmt,
> +	&config_zabha,
>  	&config_zacas,
>  	&config_zawrs,
>  	&config_zba,
> @@ -1042,6 +1053,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
>  	&config_zfhmin,
>  	&config_zicbom,
>  	&config_zicboz,
> +	&config_ziccrse,
>  	&config_zicntr,
>  	&config_zicond,
>  	&config_zicsr,
> -- 
> 2.34.1
> 

Otherwise,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew


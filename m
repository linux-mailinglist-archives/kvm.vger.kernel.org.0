Return-Path: <kvm+bounces-50496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E60BAE66F2
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 15:48:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D07D319202E2
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 13:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A8D618E34A;
	Tue, 24 Jun 2025 13:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Xq1039Am"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D34291C1A
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 13:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750772850; cv=none; b=cWilTZoPqRwMwvslmRTVn/scbLGsDTA5rYS3xPBxEzl83WItIzyrxshBbtphqbSpmt2uSxayTDCj5/GdQsS0WHzcjGFFTTdL7imPdko3ks7EkA3o8C/opXNkNU+KlqPEvSgBjfXURC4+vv85bA0fBOP+Cx0StBKfikXuiHm7cAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750772850; c=relaxed/simple;
	bh=FPqOE17+APKrELMb456PcHqUROKib4uvVIedL0A/K7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CI/c0SkIuqTvZA2XbsG3408PlhL1mUK8Y4C2kBPYV3U4KeyrzHHPwiIz/Tb+EP9eaxt9Tt2/MDeqINUf9I7Jx90Ruaz2CcCdGPnANbVVcRPyarysL2+i5SXqckA3iPPNOHle/rdadDMFD6AgKnjgF7Ly5n24K4cO9a65QuTrveg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Xq1039Am; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a507e88b0aso4530116f8f.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 06:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750772847; x=1751377647; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ycq0kX3Vn1ZpP7yxI/jdDggIlJCstgVkDpgaYIcdwgY=;
        b=Xq1039AmgKM/kRcKJpfQ+M+EFxzjmDkRzQMPsUNm7yPox9qqQPD3Im3dKZM04UGQDg
         C1zj9a4aRodqr5W7zjqczr7f5arr2EI/V0oWfhezuoW2mH6NF9K9TWCEUSMOPaxQ5Jz1
         3kKgq7t7mpn8TcCBzXwS0KniE01VAj7OuAl7MBhw6Ug00DlPWsIUwF3BENyif5X4Csrt
         fFiN8muVCFpktfDzicjbZnFOzmEgnf+47ZOMjY91OeplRnpLrr9WksTl7j6lrfNGTXhX
         fTjpCuDt6ioLbCy/vba/iFFPpsFhZnljIPtPtoTozTqj4X2Qfg0PADUmkGxyThxSGlR+
         ajxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750772847; x=1751377647;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ycq0kX3Vn1ZpP7yxI/jdDggIlJCstgVkDpgaYIcdwgY=;
        b=UjhgBKla/RRw+4NWei/1arkVaiClDJPtVWztGwjun6x6WSDigpUUAKhwH+ynvOAsGL
         q0kQlKiImTwSp77z6Xyi+FLqQcj0Qvx8ZlJMRQXHy4YwrbYQgPqMQroqOWvcZfRPAtt7
         n5iGdZ/h047mqO/jLwoNC1Sy/rJV2zop9NqxQ3BQ1YBy1bBgmgIITl6XFmaxkDYUXtzX
         RC/Z7uPyyTWc4CTCFO1+I+l18uQn7A+VgUoffA6yBtsMXA438n2ogTtBfczEk6CFuCvE
         Nv2x+H4Qn8mFeOyyo1kbZM0sscNOaTdGluGYdbaMnrkgj2MD86Xx21zcgIsMze5kf3wc
         0e9g==
X-Forwarded-Encrypted: i=1; AJvYcCW1SwDFndlSFAiSp4euuwOyRp+pSSx76Odd21EC/I71xeRxwI3nq70tbnqBOqFIAztEEqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZjfwyJI+zBmqIBIjnwrmxoM8nqFqG0kwvUGkEfHb0Ktt1jfmQ
	ODji+DmQY5n9b/kGwa7mUm5KyVm6A16sZIkwRvvb5IxXW4OU+DuIRsxj/XQD5w3RJgA=
X-Gm-Gg: ASbGncuCphLUQWn1k35XX81N9Xxs3lyutA/lYB2CyOkZGgj7eWJhQYi8rFudn80cK7R
	1OZGrqL8TmrT+2kml4TK5Si+HfzcHe0JPFvIyCotq2qKuuWIx3MaTnRM1+aYtG9pfA9eHmJkmq/
	eps8A6DuTlr482wZUhykILsnL4BUdIjF4DVGV1JTcLkrftYneymO+HbWjQl0spbGa7HGbPhSt4/
	dyA400zWKbfBzQ6NIHh1IeuORyp7W2jrW6Gi4m9j+7dM2mWwKs1XyaJJWsFpnek0Kyyi7VjUbpG
	0FjR1Xv32+vGW0RXjwf6OEPm9YsIfbL5LmE4GMmhD6h8JXa04w==
X-Google-Smtp-Source: AGHT+IHb76B6ik9Yt3pkD/SAdLPqXg65db3i1R0WxXLtr/BPlZTDKztKX7BSnwY0vPSiL+IcBDUqLw==
X-Received: by 2002:a05:6000:2211:b0:3a4:ed62:c7e1 with SMTP id ffacd0b85a97d-3a6d12c455cmr12967179f8f.12.1750772847157;
        Tue, 24 Jun 2025 06:47:27 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::5485])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f259dsm2035419f8f.50.2025.06.24.06.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:47:26 -0700 (PDT)
Date: Tue, 24 Jun 2025 15:47:26 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 5/5] KVM: riscv: selftests: Add bfloat16 extension to
 get-reg-list test
Message-ID: <20250624-044127e80c3700d93f114280@orel>
References: <cover.1750164414.git.zhouquan@iscas.ac.cn>
 <65752029ed1ae331a9ac867a6fef2e63a797569e.1750164414.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65752029ed1ae331a9ac867a6fef2e63a797569e.1750164414.git.zhouquan@iscas.ac.cn>

On Tue, Jun 17, 2025 at 09:10:50PM +0800, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> The KVM RISC-V allows Zfbfmin/Zvfbfmin/Zvfbfwma extensions for Guest/VM
> so add them to get-reg-list test.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> index ebdc34b58bad..e5a07e000b66 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -80,6 +80,7 @@ bool filter_reg(__u64 reg)
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCF:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCMOP:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFA:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFBFMIN:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFH:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFHMIN:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOM:
> @@ -104,6 +105,8 @@ bool filter_reg(__u64 reg)
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZTSO:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVBB:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVBC:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVFBFMIN:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVFBFWMA:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVFH:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVFHMIN:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVKB:
> @@ -535,6 +538,7 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
>  		KVM_ISA_EXT_ARR(ZCF),
>  		KVM_ISA_EXT_ARR(ZCMOP),
>  		KVM_ISA_EXT_ARR(ZFA),
> +		KVM_ISA_EXT_ARR(ZFBFMIN),
>  		KVM_ISA_EXT_ARR(ZFH),
>  		KVM_ISA_EXT_ARR(ZFHMIN),
>  		KVM_ISA_EXT_ARR(ZICBOM),
> @@ -559,6 +563,8 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
>  		KVM_ISA_EXT_ARR(ZTSO),
>  		KVM_ISA_EXT_ARR(ZVBB),
>  		KVM_ISA_EXT_ARR(ZVBC),
> +		KVM_ISA_EXT_ARR(ZVFBFMIN),
> +		KVM_ISA_EXT_ARR(ZVFBFWMA),
>  		KVM_ISA_EXT_ARR(ZVFH),
>  		KVM_ISA_EXT_ARR(ZVFHMIN),
>  		KVM_ISA_EXT_ARR(ZVKB),
> @@ -1138,6 +1144,7 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zcd, ZCD);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zcf, ZCF);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zcmop, ZCMOP);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zfa, ZFA);
> +KVM_ISA_EXT_SIMPLE_CONFIG(zfbfmin, ZFBFMIN);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zfh, ZFH);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zfhmin, ZFHMIN);
>  KVM_ISA_EXT_SUBLIST_CONFIG(zicbom, ZICBOM);
> @@ -1162,6 +1169,8 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zkt, ZKT);
>  KVM_ISA_EXT_SIMPLE_CONFIG(ztso, ZTSO);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zvbb, ZVBB);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zvbc, ZVBC);
> +KVM_ISA_EXT_SIMPLE_CONFIG(zvfbfmin, ZVFBFMIN);
> +KVM_ISA_EXT_SIMPLE_CONFIG(zvfbfwma, ZVFBFWMA);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zvfh, ZVFH);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zvfhmin, ZVFHMIN);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zvkb, ZVKB);
> @@ -1213,6 +1222,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
>  	&config_zcf,
>  	&config_zcmop,
>  	&config_zfa,
> +	&config_zfbfmin,
>  	&config_zfh,
>  	&config_zfhmin,
>  	&config_zicbom,
> @@ -1237,6 +1247,8 @@ struct vcpu_reg_list *vcpu_configs[] = {
>  	&config_ztso,
>  	&config_zvbb,
>  	&config_zvbc,
> +	&config_zvfbfmin,
> +	&config_zvfbfwma,
>  	&config_zvfh,
>  	&config_zvfhmin,
>  	&config_zvkb,
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


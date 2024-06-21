Return-Path: <kvm+bounces-20221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40E99911F66
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:53:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A53D7B216E7
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 08:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ED3716D9C6;
	Fri, 21 Jun 2024 08:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="aN/6VRiO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E18716D4FF
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 08:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718960017; cv=none; b=NrWIvBThO5zjuzfopjvHfWNsNnKophM5l42FeI8ainFY1jLqiPG/5o3bMSxEHunzxr98LL19V9D5Xt0wi0Cxfw+Sv8wf7WCHdebA57Cma/lqlzJGkSOJ0mL7j30rI3ra4iPkIM/anj/5xL7v0l2k+rS1J9MTt4rgwhVVEl/l9/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718960017; c=relaxed/simple;
	bh=SIpWqkNa7EJeNFdbr+PQ/hPGHfJPvIwqRgf+d2kpABI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Km1ZksNy6DKgVb+rdviCHiGacQatTVJ+r429lUgPOAN22S1+ZMV5hLpyiHgFtP5/Dod058v2gSRqVfrXoa2nfOy05Nnl01NCBJnjLQCj3wHCmKbr7PskretQa9pG0q1ssQ7TPeU1PKOwgkOL8fZBcM4Ph+kLbosLYWzKArDAEik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=aN/6VRiO; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a6f1da33826so219677166b.0
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 01:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1718960013; x=1719564813; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wHbob/VjuwQy7mgeQNSOdhI4orkGQDAEUkxEcv4Rw3I=;
        b=aN/6VRiOCNLSxcAEh0P0f70JbmYMkW6Yw2qPEQj8n3rMElAPkWQTPBja9bLCOtcupe
         HJB+g+tqiQUUNoEz4BJ4RqQZ7sdzIM1hq1ND/Yi1eW5mZYcPl/TnXkG1Knn8VRh98YQh
         s3Sjm+rJXMvxMaFImuDyu2lo/qdc2yfDxBfFFPZb4oL7ThexRybPuDto39GIbpGmJKDM
         O0gl1qkKgF+yRaA3QsoIwNDyta7D0oYJMQZYAJsPQlFxFLs6blbBnF9x8bYLu/usTMVK
         80pCms+W3wlVk7fbPsIFsiSdAiY0H+Jjq08ODEM3fc09imwkDGYTF2WzWnXKKoUb5gNt
         1udg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718960013; x=1719564813;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wHbob/VjuwQy7mgeQNSOdhI4orkGQDAEUkxEcv4Rw3I=;
        b=ieP7uClED/DSPWBhpK3O6RFxO7QwLtD2RmoZtCAyoOu6kUci58xDvqfB6T08+D7sl8
         SkU9KXh+vnihwo5QoJP2vb94lIkBS/IrnwS8KEM4WF24zzck0RzCRdeCYwt6Ko0hL879
         FZlnyC5gNn7vbb+d6zCMWVbE3RcXAbG/BI2EWwj3PQbMPRFx03puJIKlJ5ZWGg63eUZp
         kJigGaU3+4C/63NGhDvzX88/xGSsiY35P3DudNqOB5J2SzW2QKL4KLAi+l7jdRz453sU
         u35/qp+3bLhh5Am9ahS5P/Ez5hx+d5OOJ6s3QmoBWQNjmd+hMQ6t6bPZXLLD1cIFSRhY
         DMRw==
X-Forwarded-Encrypted: i=1; AJvYcCU2d6ncDjf4Ki/+K4ILXLp/GP0o7v940zGkev8p5l/jFWOLVAbEyJMKdJsaeq8xSAOWjwGsOjqsa2Aah2CocZ9HIUY4
X-Gm-Message-State: AOJu0YxX98yb805ahn+S3TZ+EMdeE3ij6sOT7CRwKy9S7LOF8sb33a0S
	XyN//b/TmAdc18e4VyGOVEPRc3tVA1jtz8/eP/Bii11OBlXDSrYqvnX9gEPBw4M=
X-Google-Smtp-Source: AGHT+IHkm/oNBDIDLkuaQ777H0KNvj0PKQQ8b7Mc9eNVWoGzQpZxRs7ccJxtYM++XnYbEFlLwFFDDA==
X-Received: by 2002:a17:907:1b0b:b0:a6a:ab5:6f2a with SMTP id a640c23a62f3a-a6fab60a12fmr716591066b.11.1718960013134;
        Fri, 21 Jun 2024 01:53:33 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6fcf48b4ddsm59093666b.67.2024.06.21.01.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 01:53:32 -0700 (PDT)
Date: Fri, 21 Jun 2024 10:53:31 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, apatel@ventanamicro.com, alex@ghiti.fr, 
	greentime.hu@sifive.com, vincent.chen@sifive.com, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 4/4] KVM: riscv: selftests: Add Svade and Svadu
 Extension to get-reg-list test
Message-ID: <20240621-f02c058395f929dfac9f3883@orel>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-5-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605121512.32083-5-yongxuan.wang@sifive.com>

On Wed, Jun 05, 2024 at 08:15:10PM GMT, Yong-Xuan Wang wrote:
> Update the get-reg-list test to test the Svade and Svadu Extensions are
> available for guest OS.
> 
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> index 222198dd6d04..1d32351ad55e 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -45,6 +45,8 @@ bool filter_reg(__u64 reg)
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSAIA:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSCOFPMF:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSTC:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVADE:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVADU:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVINVAL:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVNAPOT:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVPBMT:
> @@ -411,6 +413,8 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
>  		KVM_ISA_EXT_ARR(SSAIA),
>  		KVM_ISA_EXT_ARR(SSCOFPMF),
>  		KVM_ISA_EXT_ARR(SSTC),
> +		KVM_ISA_EXT_ARR(SVADE),
> +		KVM_ISA_EXT_ARR(SVADU),
>  		KVM_ISA_EXT_ARR(SVINVAL),
>  		KVM_ISA_EXT_ARR(SVNAPOT),
>  		KVM_ISA_EXT_ARR(SVPBMT),
> @@ -935,6 +939,8 @@ KVM_ISA_EXT_SIMPLE_CONFIG(h, H);
>  KVM_ISA_EXT_SUBLIST_CONFIG(smstateen, SMSTATEEN);
>  KVM_ISA_EXT_SIMPLE_CONFIG(sscofpmf, SSCOFPMF);
>  KVM_ISA_EXT_SIMPLE_CONFIG(sstc, SSTC);
> +KVM_ISA_EXT_SIMPLE_CONFIG(svade, SVADE);
> +KVM_ISA_EXT_SIMPLE_CONFIG(svadu, SVADU);
>  KVM_ISA_EXT_SIMPLE_CONFIG(svinval, SVINVAL);
>  KVM_ISA_EXT_SIMPLE_CONFIG(svnapot, SVNAPOT);
>  KVM_ISA_EXT_SIMPLE_CONFIG(svpbmt, SVPBMT);
> @@ -991,6 +997,8 @@ struct vcpu_reg_list *vcpu_configs[] = {
>  	&config_smstateen,
>  	&config_sscofpmf,
>  	&config_sstc,
> +	&config_svade,
> +	&config_svadu,
>  	&config_svinval,
>  	&config_svnapot,
>  	&config_svpbmt,
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


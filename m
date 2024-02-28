Return-Path: <kvm+bounces-10250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA65F86B002
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 14:11:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0711285EAB
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 13:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA5E014EFEB;
	Wed, 28 Feb 2024 13:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="SfoL4P+F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C5214CACC
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 13:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709125832; cv=none; b=I1YWzgVACIFWfquZJ+afameqDGT5Iw/A6GSu+A9Im5hjmDedxO3b+PFbXNVG3K9yl51Ah9fg/PR0/2HlkcrlRbgj+qwDYc8ejiv8rZ15qwZZReNGyEB0z2BwxuRbA1YS208ymvuyTILD0HasZFeLi53zpzEZsaa08UpQDUZnXq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709125832; c=relaxed/simple;
	bh=y+XQ8TER6IUelZZXjUiPLMXBHKScWmB2tiHBXkIHb4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I2tu+DqRuhuhYIvVoBnbDXj7sfTQeyRvblG/p4EcKOzO8D3mQIuz02hM2babvzXQfsWtFh2u47VbxRT8wCf2AII5XayLG7s0SCHQmSBGrl8sLunvo7i6x7dFxmjnAXMdSiB+BGb/91UfgR0Th6XSKpcHn7dbJVYs+9H79Qirn9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=SfoL4P+F; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a26fa294e56so915672666b.0
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 05:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709125829; x=1709730629; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q2NAebkb74PRN2BzyJL1cyLz7aGeJCOrEFsttYow7lE=;
        b=SfoL4P+FPplg00DH4rhlv5mX5o+wIbNBKxndiTNqLidRcd2Qlfu+5dJntU5/XK94vT
         YUqsMv57EpW5+Wbt0A+jbFJHWgf/pzxKQ2IV2PZKtD4VCPGBeeatQpNmicVapDUKGwTO
         P56rfwNo0tuB5bYhiCtLy4xB7Hm0z85DLLXvQyIsuubAh5S82i/PE7obdGmLLuyEhQmO
         286Ehtno8UPieS6dpKQXsvVBd4W5lJKQ/L5W6T0prMUrW70LoINRdfgOn5XQZC+1iIGh
         J7y73HRAfdW96p6XtWnG6yUr0HScGKnJQapPqQRU9IHNRgh5msnfNvSAY4gMJpBVeghn
         mOrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709125829; x=1709730629;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q2NAebkb74PRN2BzyJL1cyLz7aGeJCOrEFsttYow7lE=;
        b=XB87ysK3ODTchEx4RVpaW60ZgtCLPbZMWq6CYi8YPs16hw9xorMsPOkQ2aHSIBw7ci
         8xiHZ+pNTRWpJw4sKnkcIlGZjrFBr0EzJgkEoX6l3HBDP0XkRGztEbM96/wHeVqa9iEt
         vDKIWptGbx4AG9c9Jbf11XdLHnlydZshMKSwp0R6xFvqBdex9im1hcuHOHSityZftW5o
         T9xg185YY9pXWiauYH1DahamRaquneT5trjNhVwvVzTKEUX8FmL2DKwqYr65W8rW1nyM
         4LsQHGh5F+XjdKPbAedyOQV7ca0kFZ0+9wTXtq2x8R7MVZXVNbkzHkNsWc6FSZGpaTj1
         7J+g==
X-Forwarded-Encrypted: i=1; AJvYcCWcHiLxrbYYb4/jp+EMS5XSqJwE43GnPQwryqlaN2x0jQZ+yTd41lJO9NMNJErFV1jDlO7kaJKQAIylRrOGkosHneoP
X-Gm-Message-State: AOJu0YzxmigvatvdxYir7RVONPyf980iRqNAPhEXo1BqqfinmgRA9LWB
	V4wwAA/RYQx/LRNlzgy7UAqxM3tS6MGTRqpsi28UM85T+D18rKuChTnUAxY1fVc=
X-Google-Smtp-Source: AGHT+IF5HIjUzKDomFUnEg6DOvdb72PcuesnipX63O5viuhCdygq+/+gijCmgtIJP5epcZJ7ZF3eDQ==
X-Received: by 2002:a17:906:c305:b0:a44:21c4:91b3 with SMTP id s5-20020a170906c30500b00a4421c491b3mr105263ejz.44.1709125828798;
        Wed, 28 Feb 2024 05:10:28 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id i25-20020a1709063c5900b00a3f596aaf9dsm1851570ejg.26.2024.02.28.05.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 05:10:28 -0800 (PST)
Date: Wed, 28 Feb 2024 14:10:27 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 5/5] KVM: riscv: selftests: Add Zacas extension to
 get-reg-list test
Message-ID: <20240228-8f3f6703b3c14ceaf169da3b@orel>
References: <20240214123757.305347-1-apatel@ventanamicro.com>
 <20240214123757.305347-6-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214123757.305347-6-apatel@ventanamicro.com>

On Wed, Feb 14, 2024 at 06:07:57PM +0530, Anup Patel wrote:
> The KVM RISC-V allows Zacas extension for Guest/VM so let us
> add this extension to get-reg-list test.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> index 5429453561d7..d334c4c9765f 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -47,6 +47,7 @@ bool filter_reg(__u64 reg)
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVINVAL:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVNAPOT:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVPBMT:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZACAS:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZBA:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZBB:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZBC:
> @@ -411,6 +412,7 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
>  		KVM_ISA_EXT_ARR(SVINVAL),
>  		KVM_ISA_EXT_ARR(SVNAPOT),
>  		KVM_ISA_EXT_ARR(SVPBMT),
> +		KVM_ISA_EXT_ARR(ZACAS),
>  		KVM_ISA_EXT_ARR(ZBA),
>  		KVM_ISA_EXT_ARR(ZBB),
>  		KVM_ISA_EXT_ARR(ZBC),
> @@ -933,6 +935,7 @@ KVM_ISA_EXT_SIMPLE_CONFIG(sstc, SSTC);
>  KVM_ISA_EXT_SIMPLE_CONFIG(svinval, SVINVAL);
>  KVM_ISA_EXT_SIMPLE_CONFIG(svnapot, SVNAPOT);
>  KVM_ISA_EXT_SIMPLE_CONFIG(svpbmt, SVPBMT);
> +KVM_ISA_EXT_SIMPLE_CONFIG(zacas, ZACAS);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zba, ZBA);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zbb, ZBB);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zbc, ZBC);
> @@ -987,6 +990,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
>  	&config_svinval,
>  	&config_svnapot,
>  	&config_svpbmt,
> +	&config_zacas,
>  	&config_zba,
>  	&config_zbb,
>  	&config_zbc,
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


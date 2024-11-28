Return-Path: <kvm+bounces-32737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77CD39DB44A
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 09:52:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CD95281A8D
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 08:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FABA1537A8;
	Thu, 28 Nov 2024 08:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="g3Y1U8D7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEAB14D2B7
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 08:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732783932; cv=none; b=Nruh9nQMfoXUs7GhkwCyw0SdCsMsMDb0MCKMu6Mbzmvuaxs2a1CqGWv0YXbZy+pn5Y7AM+UJkYYXo2nssWSlIjncsDSNZEFFRZbr1N6lCgruUdaDY8jxZuE1P+7aiVekeYL0SoR68HCSJ89H3EpA2URAEDZtBn7Y0jFbl2DOdNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732783932; c=relaxed/simple;
	bh=+LxI207fMZyRamK0oRS6I4x/Y6ZteYi0UVGdWJl3k/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CTPsiN8u2Ub/PI5KkcJbsKJzfrA7UoUWaenMqhEa1OHhZBYURpLJC9jCgT/rAPML42V/lI5nOSQD7ii79iAgNpCSgGGjRJtABV1GfBpTLvPNAQ4jg1tn1prRypr3eZqsM6u5QqKYcihMxhh+QSGPXbv0xjFj/3Nf/xZk3PxQSnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=g3Y1U8D7; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-434b3e32e9dso963985e9.2
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1732783929; x=1733388729; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q2iPe56MayituZcdhfXf2NviKcI0B6w7DTgpAVLjkFQ=;
        b=g3Y1U8D7PqfrC8XafvHXGCReHX/C4qcG7O6UhOZPOuF+3Gw99UGag8lDqKLQ4d8yFW
         XHXz5fSIuqetnzPuAi1J0oET+Q9H3pRCp99Jlr0MEoK7m/TrIy5KZSWzp0MJJEhtvJKR
         EhBmrc5pcHC564HtGuoOEyLcn+hzpbjdRVw2PGW2UBlcq3UMN2IihkfLGCzRijZSfqJl
         FGBZ7kQOvBPogfellxlU+nVGat0ag/Yxrhk9pOIAkNwgTCPoXdGDb2rcL6KxVEv9E/dC
         Dl0Aw5EYgSnR4OkWkoIiDzEFfccgmXKW/ABMUq8h+DbtVMD2RPyq9HuPjHIwu1XkOFzr
         bVDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732783929; x=1733388729;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q2iPe56MayituZcdhfXf2NviKcI0B6w7DTgpAVLjkFQ=;
        b=sdfKXAxxxkQ3lKVG4dUfUhV0wzsMkrkwPvzng7i1amzSja+1xzhHfE6iNPoA7ObNg+
         KnnWCgAFdoldj4p+scuQpBLZEr7YGxyP+cVuVUsQOUMcA0uj9q7JkwamTv+tSfaJ8T1j
         GUww0hBi3J/R9AUImarh8qbM08QKnlf96B+l3ndvDVyAYOQBA3cE1oyAAyacW5YZamc4
         sQd3R6We28Zh9vAHEuWn7Khi2hAjp9Us+LiHKNB4O9CmGDVKqKTrMm27JI3SbQ/aQy1Q
         euPqCYjyS/PbW57UL+uRDscA7o5R1W7fq0EuhYWabR7j6utDxTx/QBea/rjo0pzxnxD0
         luqA==
X-Forwarded-Encrypted: i=1; AJvYcCU2zR5oVlXmQEyGJ/s/H5zgIdM4gqtr5SijDQ8hcoIMZANhk4Xgij37lWNUXOSJimdv+o8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsbkPLAfYvW2IiEi12pD4wHt/TwKxevBXPgJ2Y3ic901rjS+yZ
	QYwaq3+ndWNPHLC18UKpYZZXPhmS5WH1xrfnictRtN/Q48GopPcb5V3bGryQDsQ=
X-Gm-Gg: ASbGnctF8hBXU/tRxu6yHeeNXZmOzdMhcKWd71w07qqbqoB+0tUJh028J/gAl/Sp7F5
	8r/lBqZ9PYjsBqT4V/uEuZ+RdgJyEiSYHPSWWlMErYd8FBVE1ZXaHaGL2/YX1bQFQ5bsesiCoDk
	22BTTYBtDOiz+DEiuNsnKSneBpzOfnh/Ky1u3AU3E3rC6KurLbJkW1Qb1z1VoW2yJlV9NCArhws
	iq9dJmbBc9umlsb1Z0RhPFafOpIAKF4X6pw14r0Bha0GIbmXJE0dNA5oluzxI4uN+q5ptECOvOp
	zBQ0/wiBSavODP+xlGtTjVubmPbGQ6G789Y=
X-Google-Smtp-Source: AGHT+IEQ7usI6WzT1Sy/dDzpS2PmYGgrjtEHrwwaKksPUcfWEtHLCN5lr8kos91EccHetXt6QvrFmA==
X-Received: by 2002:a05:600c:3b16:b0:434:a4fe:cd6d with SMTP id 5b1f17b1804b1-434a9dc02c5mr57820965e9.12.1732783928908;
        Thu, 28 Nov 2024 00:52:08 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0f7dd78sm14832355e9.44.2024.11.28.00.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2024 00:52:07 -0800 (PST)
Date: Thu, 28 Nov 2024 09:52:06 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 2/4] RISC-V: KVM: Allow Zabha extension for Guest/VM
Message-ID: <20241128-4d652d29ba99a3e8ffa8121a@orel>
References: <cover.1732762121.git.zhouquan@iscas.ac.cn>
 <ea2918b299348aca0f5a45630b7b7c9889f47fa6.1732762121.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea2918b299348aca0f5a45630b7b7c9889f47fa6.1732762121.git.zhouquan@iscas.ac.cn>

On Thu, Nov 28, 2024 at 11:21:26AM +0800, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> Extend the KVM ISA extension ONE_REG interface to allow KVM user space
> to detect and enable Zabha extension for Guest/VM.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 1 +
>  arch/riscv/kvm/vcpu_onereg.c      | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 9db33f52f56e..340618131249 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -178,6 +178,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_SMNPM,
>  	KVM_RISCV_ISA_EXT_SSNPM,
>  	KVM_RISCV_ISA_EXT_SVVPTC,
> +	KVM_RISCV_ISA_EXT_ZABHA,
>  	KVM_RISCV_ISA_EXT_MAX,
>  };
>  
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index 67965feb5b74..9a30a98f30bc 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -44,6 +44,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
>  	KVM_ISA_EXT_ARR(SVVPTC),
>  	KVM_ISA_EXT_ARR(SVNAPOT),
>  	KVM_ISA_EXT_ARR(SVPBMT),
> +	KVM_ISA_EXT_ARR(ZABHA),
>  	KVM_ISA_EXT_ARR(ZACAS),
>  	KVM_ISA_EXT_ARR(ZAWRS),
>  	KVM_ISA_EXT_ARR(ZBA),
> @@ -138,6 +139,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
>  	case KVM_RISCV_ISA_EXT_SVINVAL:
>  	case KVM_RISCV_ISA_EXT_SVVPTC:
>  	case KVM_RISCV_ISA_EXT_SVNAPOT:
> +	case KVM_RISCV_ISA_EXT_ZABHA:
>  	case KVM_RISCV_ISA_EXT_ZACAS:
>  	case KVM_RISCV_ISA_EXT_ZAWRS:
>  	case KVM_RISCV_ISA_EXT_ZBA:
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


Return-Path: <kvm+bounces-10725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 576C986F01A
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 11:53:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7005F1C216A5
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 10:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51BE614296;
	Sat,  2 Mar 2024 10:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="UBIk/dGh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B8A168AC
	for <kvm@vger.kernel.org>; Sat,  2 Mar 2024 10:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709376772; cv=none; b=IIfB/unf8B3EdXpGCn371a1IEtxcYTR2A0iZ8X+GokQQ/+dEC3KgoPH92ej11qNpCCtikGvOL5zE4JK5CjR29crQ+SDzk6XELSOUIHT+9T45PWVlX8rdbRzanByvRz953RnbADKSqOgcObNXh/iQTPUCK6SFNO5KSa/PVcWXKlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709376772; c=relaxed/simple;
	bh=9/WK1BCzR1SLSIxsXa7/3fBLKlJj7gHlyhWQlscExSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hhquz7OrYBNbIJIpd5R4iGXwFktdC/FLb+X7wNVYxVhkY2edJPISkGkWIfwH+6dUQceBb6/hQcFj3XY5cofUwMK48u3b+FdKVWpsL+YC05B98B3Id9StSnuKhJ7ezAaqtx03DEMmYaw86ILgaedy02bxxGvutgxbq/Wid4ULmIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=UBIk/dGh; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-56715e3cfa7so129034a12.0
        for <kvm@vger.kernel.org>; Sat, 02 Mar 2024 02:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709376769; x=1709981569; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PCdvI1CI1wq3H8VWZLB+tHk7uMQZkydnbuu9eDe1Sx0=;
        b=UBIk/dGh5RTiM8tRSw8r0OFWs/wI6f+SL7ppXsL32SRBYKTtI2hZB+I8Et7N+2CYrx
         hk1CWvzdhJPnQkZfl/kdHPDGgpP1V0xf1SNJc+sd3ylppyVGzwJm83wBuDNnRjfuk4lo
         upbJ4nnr1zhpa/BhUtIkFaHfeiO5d3DVK80DlZSuH92U8JhVKig8baxfBFLwUjgE5yT9
         FrHe9KrDlkITToceFRfOC9kj9Q44+GiVew7O+Bl9k802q2Ij3QDTIcukZNTYXGiD48Lz
         CHv1sAZcdSmyklXjE/5W+KLrfOXwUZ19VpeKBH72GDP58WLCpng2VjGafhw1A3KZNocj
         YJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709376769; x=1709981569;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCdvI1CI1wq3H8VWZLB+tHk7uMQZkydnbuu9eDe1Sx0=;
        b=naVx6pZU53ClXtYVuAlyBkupaxqOkTT2CaMLAK6eWtLOSjKxki3o+5x24EFUfMdIRt
         KAVrRVrn1GdEELC3OQ7o1Wy09shoPTL+DsElmGiCUKblPrWV7mSxN0/avEjpq4Cgl2Oc
         g+VGl+sBuz8qqLdu/KaRXpj0eqxEt109Z5rbeNtTmp+6IjVaH5InbYQSU2yRmnQQZCva
         mCt6eYjXyMku349ezU28Ds8dHh1JbnI1NYwxW+ujPLr7fcvxy9PMmPee/u3J6RwJJ7XU
         hb6GW1b8FZ6EmO70F72Pf4TnrIRc7r3HRwL0VD/8hp05EOo8BzMDJVcnBwx3VUOkz4nD
         Tljg==
X-Forwarded-Encrypted: i=1; AJvYcCUvN0jb8os61IlvKJ21B09uevXKpS6iJL34blZqaYNL501ZqnVffujYxvcLnHYrPbB5Q6lDzonOb8a3PjQp78LxMxjR
X-Gm-Message-State: AOJu0YweoJWh0NYHVCCgASnOm7GMnBNEb9T8Ti3dkahJ5810FtvHwuJy
	jb5V0SIkJAGNs6jGzv8rAzW6KvQjDSQIijtqIoywQYVPhSoHfGVcwr3+sYNAvCk=
X-Google-Smtp-Source: AGHT+IH6Pl/QPl+wRDhZFxMPC4+oxVy5/XhywXdvlh+0HQh8Mv83KzaWy/I5XWneZ/OFSKQ1NKD+og==
X-Received: by 2002:a17:906:c2ce:b0:a44:b9e1:560f with SMTP id ch14-20020a170906c2ce00b00a44b9e1560fmr2326365ejb.14.1709376769624;
        Sat, 02 Mar 2024 02:52:49 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id ss1-20020a170907c00100b00a43eb697337sm2596196ejc.49.2024.03.02.02.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Mar 2024 02:52:49 -0800 (PST)
Date: Sat, 2 Mar 2024 11:52:48 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Conor Dooley <conor.dooley@microchip.com>, 
	Guo Ren <guoren@kernel.org>, Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 11/15] KVM: riscv: selftests: Add Sscofpmf to
 get-reg-list test
Message-ID: <20240302-df57978623d37ec586a2748f@orel>
References: <20240229010130.1380926-1-atishp@rivosinc.com>
 <20240229010130.1380926-12-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229010130.1380926-12-atishp@rivosinc.com>

On Wed, Feb 28, 2024 at 05:01:26PM -0800, Atish Patra wrote:
> The KVM RISC-V allows Sscofpmf extension for Guest/VM so let us
> add this extension to get-reg-list test.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> index 8cece02ca23a..ca6d98a5dce5 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -43,6 +43,7 @@ bool filter_reg(__u64 reg)
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_V:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SMSTATEEN:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSAIA:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSCOFPMF:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSTC:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVINVAL:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVNAPOT:
> @@ -406,6 +407,7 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
>  		KVM_ISA_EXT_ARR(V),
>  		KVM_ISA_EXT_ARR(SMSTATEEN),
>  		KVM_ISA_EXT_ARR(SSAIA),
> +		KVM_ISA_EXT_ARR(SSCOFPMF),
>  		KVM_ISA_EXT_ARR(SSTC),
>  		KVM_ISA_EXT_ARR(SVINVAL),
>  		KVM_ISA_EXT_ARR(SVNAPOT),
> @@ -927,6 +929,7 @@ KVM_ISA_EXT_SUBLIST_CONFIG(fp_f, FP_F);
>  KVM_ISA_EXT_SUBLIST_CONFIG(fp_d, FP_D);
>  KVM_ISA_EXT_SIMPLE_CONFIG(h, H);
>  KVM_ISA_EXT_SUBLIST_CONFIG(smstateen, SMSTATEEN);
> +KVM_ISA_EXT_SIMPLE_CONFIG(sscofpmf, SSCOFPMF);
>  KVM_ISA_EXT_SIMPLE_CONFIG(sstc, SSTC);
>  KVM_ISA_EXT_SIMPLE_CONFIG(svinval, SVINVAL);
>  KVM_ISA_EXT_SIMPLE_CONFIG(svnapot, SVNAPOT);
> @@ -980,6 +983,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
>  	&config_fp_d,
>  	&config_h,
>  	&config_smstateen,
> +	&config_sscofpmf,
>  	&config_sstc,
>  	&config_svinval,
>  	&config_svnapot,
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


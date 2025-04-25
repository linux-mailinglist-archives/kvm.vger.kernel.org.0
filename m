Return-Path: <kvm+bounces-44324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D93A9CAD3
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 15:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F91F7B2626
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 13:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D18DF2517A9;
	Fri, 25 Apr 2025 13:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="UFof23l2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC53A71747
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 13:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745589032; cv=none; b=m4Z+tAKeYAAjBDbIN62C1dOq0copA0207znY9BygaHPODqvyDeKo5WBbsK5V2MwwYL+aGd5Yl0z3XWT8stN0QPuUgB9XrZwnBF3UnNfWZ2oGp/SQ17kSF36sAX4gJtGxiDP4STYnKYDTZ+GcupyUcNWDhf0bIewTOy7OZvsW4RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745589032; c=relaxed/simple;
	bh=D+DjpJkVY50DCH/EIM2jyo+5APpyBQvmmE9jeNvI0IY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ci0PwQwrIMBbnw3gW9SLD91RzNxzjsQP6Hx1rX/lBVH0mj2DEgzDIhJJYES2c7zMllENJGA09r3O048LDi9hZuOE55ZJ9FhrWy+F99r5q8owzdmDrqBr2iZaDj/9j1/hA+3q5Y4JEvA1YQ4PGlUsBI8eq0fmf2HypfQuaWO7Kok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=UFof23l2; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43d07ca6a80so9970635e9.1
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 06:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745589029; x=1746193829; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZUA/m6gOa249NNOmchovOHq5LELqOzlt/ubdwJUo+cU=;
        b=UFof23l2l5NNuW4SRlxc5RyBLx3foa/OACM0JNkbNkWglyp3NrALdiOP13LBxFEOCY
         DPBjBTbQVDK9MRRXCDl+/ikzUejmImiGShFwlLTR9KjMeGVGjUDgPmrGVxx36kAHJI+q
         roV1RMdHSja37GodK2QFW8/zVz/p/La0UoeVyKWJk4OxA2Cl/5MBhwH7lJBd4QDOC+sd
         uxiw5iZiJYfD8+ki7R2gZg5oBsyrV8iYm+H/7Ef+3PGWoyzH4H95+ELGn7+KzQgVvXqc
         lOT0lAYw1Zi17Z8e+bqQHCGjHOZgIrPgH9NfITuXRe1qHX7xWZe3AcvXHP9I2MH/+kAF
         wKfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745589029; x=1746193829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZUA/m6gOa249NNOmchovOHq5LELqOzlt/ubdwJUo+cU=;
        b=WjLHKFy6lzkuVQDXg2/mRADd4J3+gdXdNlLIzI4L013UbRKGqQ23M2KXrn0OP7Y2AT
         VHF5L9UwVp/4QKg66NUdbq869aln9BMKGd8rpiXBFsS7naRzQhtams0INpQ5yIvnDJY9
         azW29B0IgJqxzWfTSuntF9x/LZKJt7wFkmf3DrGjLNIfZ6O29O3LG+19iu+j4sA+woH5
         MT8oed4a7ckX5WmL1+TA4kMQalT7zYiFlWDvjR/PpFmSl3Vmgb096S1qo4po8dknI0Qj
         QBRyJAj24zqAEeOdkZemeoG7YVjFDQebbkBjkXjPSHS/RaOtT48MEkRdtlu/Wj7rt/fY
         9WaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLSlYcJ069/XQaS9a+2wvSJGu9GlEqVsGY+cPT8FIJjwjk2iiyGNf5Il6+kgXA81xqtjE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXcbZD1lduMmfFyaLx4GUHn8bu7ckP6QEBOTvyj/QCKs+dfDuC
	dj4X1opjtyYDz9gWbWqjAv9bO6PjD6C1HWecKozm9VKOkceaojvAFoMXped3f0s=
X-Gm-Gg: ASbGnctLdM/4uVvOejD6espxItkRZKcciZghEZSLPG/watsR3MpMetBtQjf1VJY20Ut
	dnkHOeKBwmecMZ28sEJhPGhXejrrZdwVcXgKjCgQLgICLyrulFfItcEKTV2vKs1FGIBIXVSWyDf
	nCuLa+tjJEvzJY/XQG/I5oOsn6Wp9DtFJQgtWf377YiGqLGUGY+fbEqU6ffrIvQ1HM7XQIRNNtQ
	8/janB+I4wLP3nvrJyMu89q3Ur78w6nu+3mDoKwwg7v9elCUAQV56nkYVmOHEjS75X9T1dxZMe+
	9Fv6t6gXjDsKG4FlWBPlF23iEFZC
X-Google-Smtp-Source: AGHT+IF/LMdkzYLBWPyT5ztxJyzb+GPhFh3GxsY5b8ixWQQMljvmNbliBGV7ZjWkl9GsiErnAoI9/g==
X-Received: by 2002:a05:600c:1f82:b0:43d:934:ea97 with SMTP id 5b1f17b1804b1-440a66ab23bmr18288315e9.27.1745589028834;
        Fri, 25 Apr 2025 06:50:28 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073c8cab5sm2480265f8f.10.2025.04.25.06.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 06:50:28 -0700 (PDT)
Date: Fri, 25 Apr 2025 15:50:27 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: riscv: selftests: Add stval to exception
 handling
Message-ID: <20250425-dc44cb547ab5e2f994c94e80@orel>
References: <20250324-kvm_selftest_improve-v1-0-583620219d4f@rivosinc.com>
 <20250324-kvm_selftest_improve-v1-1-583620219d4f@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250324-kvm_selftest_improve-v1-1-583620219d4f@rivosinc.com>

On Mon, Mar 24, 2025 at 05:40:29PM -0700, Atish Patra wrote:
> Save stval during exception handling so that it can be decoded to
> figure out the details of exception type.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  tools/testing/selftests/kvm/include/riscv/processor.h | 1 +
>  tools/testing/selftests/kvm/lib/riscv/handlers.S      | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
> index 5f389166338c..f4a7d64fbe9a 100644
> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> @@ -95,6 +95,7 @@ struct ex_regs {
>  	unsigned long epc;
>  	unsigned long status;
>  	unsigned long cause;
> +	unsigned long stval;
>  };
>  
>  #define NR_VECTORS  2
> diff --git a/tools/testing/selftests/kvm/lib/riscv/handlers.S b/tools/testing/selftests/kvm/lib/riscv/handlers.S
> index aa0abd3f35bb..2884c1e8939b 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/handlers.S
> +++ b/tools/testing/selftests/kvm/lib/riscv/handlers.S
> @@ -45,9 +45,11 @@
>  	csrr  s0, CSR_SEPC
>  	csrr  s1, CSR_SSTATUS
>  	csrr  s2, CSR_SCAUSE
> +	csrr  s3, CSR_STVAL
>  	sd    s0, 248(sp)
>  	sd    s1, 256(sp)
>  	sd    s2, 264(sp)
> +	sd    s3, 272(sp)

We can't add stval without also changing how much stack we allocate at the
top of this macro, but since we need to keep sp 16-byte aligned in order
to call C code (route_exception()) we'll need to decrement -8*36, not
-8*35. Or, we could just switch struct ex_regs to be the kernel's struct
pt_regs which has 36 unsigned longs. The 'badaddr' member is for stval and
the additional long is orig_a0.

>  .endm
>  
>  .macro restore_context

I guess we should restore stval too.

Thanks,
drew

> 
> -- 
> 2.43.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv


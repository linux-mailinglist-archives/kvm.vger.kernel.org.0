Return-Path: <kvm+bounces-30706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A6D89BC8D0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 10:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE3E1281209
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 09:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38BC71CFECE;
	Tue,  5 Nov 2024 09:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="KFylEY26"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905D04317C
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 09:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730798094; cv=none; b=C8+IiLz5B9lAJPcfGP01EXWoTJKpa+Mb3lm2JRBZSINY5bgiabaQAmOkNPhOyq8eHfg4WUqM2BJ2ZjQNrznALa3R7IG2EghKEWL6R847JOwdSIXuIOSnoYSlYAT+A7Em/SNyFNbkgdV9EADmg69d0nZ35EblYnWr1DWKEa/JnQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730798094; c=relaxed/simple;
	bh=fwNtz/Z+NOqo1MyfPZfQNhZLQG3eD5ohKoO0W78enqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OOvsd+qFSG6Q3/85d0oAzBOFRTazScf2HxlTwZp9G85i+aTEciSEu7ctunSK8X9XXm+f7nHe04f9Fnh7UencDQ1CMYdO5rmkT4SbwsZ+Sl+thaJFRH/sYDm+5Tq9CssNpJ37ZKw/qZoq9WRU4Sc+rZGTneQIQIHVFGN2lBJ0I2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=KFylEY26; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2fb50e84ec7so36346811fa.1
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 01:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1730798091; x=1731402891; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P4G0QFpDZpyh7jivQuglDMqb6yzlT1rpR4Jl1yN+DF0=;
        b=KFylEY26KSGOHI8cVyeSwn71wmwPJ90KtcN+YOra5J75CJa4kXbEM5+Uxw1wRVU/cC
         1CIE5hsWTwBnfS4zInOJ/LsN94d+OAnJioTKgBfY0j0VVdvNGq3o4BUXB2OnIEywQMLx
         5M0iyFwG8Llld/rrzI83KQD9VG3LKoFJFxqOLGr8+x0ofELLN9ZKc4mL8fJuhln8Kznd
         caIFCD0ur+gt8DTPiM+svL21gUac4SiQ2NYagCjlDoAnYD3lWIeo/7kqnwYwgEK7XabT
         12gvdS6yVHTZr0avgh91jRJ7O0fAZOvLR+7SPdkpQbE6D5nEAa1F/vSzXkWEI4K2LQWk
         9IaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730798091; x=1731402891;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P4G0QFpDZpyh7jivQuglDMqb6yzlT1rpR4Jl1yN+DF0=;
        b=QDaYB6/1XB/2qhjDxF0m5LuNX33bz41R+vUvpKuFP1DpWxgNBUgdpPeEge0TLZ+/C5
         qyA+WsM8YyoQz5pMIda3r9EdQruaq3UMdsBaacF/s1LMM7Qfu5Ls2+WpDaexEHtxrm02
         FMfH9/RuEdPbC+UElsXc5JcfDfuEkKpHHY94ijySh3+n04Y/u/t8qswWLi/sFeDzB6fo
         zWz0hbl9peH+b65EUD8H/5sXBYqzX/8b0saXSL04SSweAYIlfi1TqPb+K/E6MhLCQKy4
         FxhPDjlgpQa/9HEFGzrt9APb8kLDliTkvBH8FQmF9c1LnIypnScj+RMySXBdEiz1d57y
         5Ycw==
X-Forwarded-Encrypted: i=1; AJvYcCUCUqqewUaNrGJ/P/fPiErr1z6SAqF0UM6sCd2PII3Ui5f5yRJJBpq8MA8cxho55cQ0XSQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3qtWWBRyD+Su9PCyqp1tqaIe0CWArEVXFDGB64yoM6qEmGjcn
	XaItmNOMkIujv1297NGW0GIiiPXEyXPTywgB7PAWWbZbo5d3Vn2OtDjvcXTPZNc=
X-Google-Smtp-Source: AGHT+IF89JsMTBItvysTiIBkAGPevhb1tYo18xBJg4bMSuMI6an6frnp4kuVBULT6FlhF3ie/VWuRQ==
X-Received: by 2002:a2e:a543:0:b0:2fa:cc50:41b with SMTP id 38308e7fff4ca-2fcbdf5fa9amr179020771fa.5.1730798090168;
        Tue, 05 Nov 2024 01:14:50 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd8e8524sm209635175e9.5.2024.11.05.01.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2024 01:14:49 -0800 (PST)
Date: Tue, 5 Nov 2024 10:14:48 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc: Will Deacon <will@kernel.org>, 
	Julien Thierry <julien.thierry.kdev@gmail.com>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH kvmtool] riscv: Pass correct size to snprintf()
Message-ID: <20241105-546ce4236046e9742cf081e7@orel>
References: <20241104192120.75841-1-bjorn@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241104192120.75841-1-bjorn@kernel.org>

On Mon, Nov 04, 2024 at 08:21:19PM +0100, Björn Töpel wrote:
> From: Björn Töpel <bjorn@rivosinc.com>
> 
> The snprintf() function does not get the correct size argument passed,
> when the FDT ISA string is built. Instead of adjusting the size for
> each extension, the full size is passed for every iteration. Doing so
> will make __snprinf_chk() bail out on glibc.
> 
> Adjust size for each iteration.
> 
> Fixes: 8aff29e1dafe ("riscv: Append ISA extensions to the device tree")
> Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
> ---
>  riscv/fdt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index 8189601f46de..85c8f95604f6 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -157,7 +157,7 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
>  					   isa_info_arr[i].name);
>  				break;
>  			}
> -			pos += snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN, "_%s",
> +			pos += snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN - pos, "_%s",

Just above this we confirm strlen(isa_info_arr[i].name) + pos + 1 is less
than CPU_ISA_MAX_LEN, which means we should be able to use anything for
size which is greater than or equal to strlen(isa_info_arr[i].name) + 1,
as snprintf won't write more anyway. But, it's understandable that
__snprinf_chk doesn't know that.

>  					isa_info_arr[i].name);
>  		}
>  		cpu_isa[pos] = '\0';

Not part of this patch, but part of the context, so I'll comment on it
anyway, this '\0' assignment could be removed. It looks like it's a left
over from commit 7c9aac003925 ("riscv: Generate FDT at runtime for
Guest/VM") which could have been removed with commit 8aff29e1dafe ("riscv:
Append ISA extensions to the device tree")

Anyway,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew


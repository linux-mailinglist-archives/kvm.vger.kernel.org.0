Return-Path: <kvm+bounces-56888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30A80B45A38
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 16:22:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D4891CC453F
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 14:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 151FE36CDFC;
	Fri,  5 Sep 2025 14:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WDor94x+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFBE36CDE8
	for <kvm@vger.kernel.org>; Fri,  5 Sep 2025 14:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757082115; cv=none; b=EEb87u/J8PSwlyZ4XiaQjoIxo0H+vkVF7P1e9lHBStZETqQn10J24/K6eeDsI4xoSC7Y+Hw9yf8j5fNTjvP9gO6ke8lN9a8HU+6joqoA4zhsx8V+YaajpnsYaum2LkywhHG9ueAx9HRX7s597dbIUXps+5jYHf/7S4TncRI8sr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757082115; c=relaxed/simple;
	bh=oxUImwhK8PCX5aXJPu6YXlDrtbpPUKA4Yd9Mnt3Xf38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ENStYHnUglFehOZmDMjUcUMIG11YRs1wOjqiHJiOvXVMpNYIBM0SsPHYWvvg70jQ4hDbEfWxX5Hl5LPekDWUsxRWHORWRIrrVc7ree1Z7mEbvZvqxBIm47N1YM37c5eaafzreXGv4RwbcSXK9C8o1geoOrPLNXIIgxLEeM/vcuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=WDor94x+; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3f669e78eadso11537335ab.1
        for <kvm@vger.kernel.org>; Fri, 05 Sep 2025 07:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1757082113; x=1757686913; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WAIXNF/yhxj3WIda95HMOmBhnbf7MpGftHHpVlcqDy4=;
        b=WDor94x+a30PsCd8eKo7y/hwzZozoyy8N/X/5ZTOXIR21HkIsfU4ybqfFbznbM1QuV
         hOoIv9ysNc9EKDDIjQ9bLXrEgncDt7LE3/++NPrcbeULM5on6bYbRLB/NABybZa6dvyC
         iqioslBMr59lrmupnf6ZxnaNSWOxTiDYcdWi6Rv7bs3rEslr3ydWd7gCfTcnT4JlQ4Gu
         5vnIVerOkndj4PI8QEksNoqXFgRZmRz1zcefZVBLz3knON8w/hJGmZh2kFXo7GtoXGea
         OKvuHjcSaxqDVCwJl+dfoqBinYSL7lsIOxwXq+GMJmkp3GsWhn/7bilHmiPAjY0RrjbG
         ky9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757082113; x=1757686913;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAIXNF/yhxj3WIda95HMOmBhnbf7MpGftHHpVlcqDy4=;
        b=mTpEc81H6YzKp1bJKNYKYGSdfLoBn/A44wmKA1r7DxG0UqrB8GHOE002T38Yy2wQW7
         gTD9lvl4MMrRIb8CrWX9/Wf1RSsMxQskb+DMvLDnse0vtjS1nHYzokWTi+0Ur4KXE0Zf
         CPMiJAsOet1WpJ29TSRn7nx3l0npXcAWpAyvq9aFyUZrW6F7zaKNinWJkf4lqCeYpnJJ
         SjI9Hf6syAp5aLlqwbv2Pd+bE1L/cAbVpkHBI0ktd7CLwhoSE88U+UwpcekkBvKEthbA
         dSn6RsUAYzCteXu7sg2KcwpJL49GiyNwBj3heV0Kz1Xn6ma+oa68ISLBe0kS6GhS7Qj8
         3hAA==
X-Forwarded-Encrypted: i=1; AJvYcCW2AQGU8/5j2FSlNWGgIODCO4rfxL/fQFXX76lRQZdu/75yANJWEh44QohNua14+yvB/y8=@vger.kernel.org
X-Gm-Message-State: AOJu0YygQ6+dXRiJvahKT10JliClRVIsYjGqUEucUjSkQ4vB8yfE2bnl
	TeBTzS705RXQizh0Cx2S81gSn7WkfVlD7e0kJd+fMSWmBArNGnT3uqeBwAKVjVfFnm8h6tjW8R8
	gbGFygyU=
X-Gm-Gg: ASbGncvA4ohgyWHhslbNrBlvovF+fBX/3jK1qpfw/qz5k3j1iBQ2Fd5b9R9nU5iu9iP
	TbbRxH6ImXC5ypOSd/lfW8RId4igMlbr/BZls8ETVqQP04ZYPLGsbduQybuqMAEGm168HOHPT+2
	hjqOkj9KSAVTiaKdoWoc5tfpA6Bavav2d/lVbiYGw5HG6rf9Ud7Japgez8V2c5UcV407U/zd486
	IrfgWIBITsx3upjrCDIHHyCJfiQqDeVG1Bc2OVOYzbfuEqBzfP2PFtU1gwY5yDFNt2nQmenpRqH
	I+p3RqJh897lMAwGmXxkh6JwcKzMLko8+iKJ6Lawdt3auQktKfDhSwtHbuubmxUNtPrvVMnRPz/
	W4NMWeGKMq0217PqvZDM/thiw
X-Google-Smtp-Source: AGHT+IGf4qxxSXO6iewjkiZTlmr4yvaEZFX/IytJuUl4Nj32J40fOreM/84N8MX0m+sgaZr+dqFiDw==
X-Received: by 2002:a05:6e02:240c:b0:3f6:6198:b39e with SMTP id e9e14a558f8ab-3f7b6808028mr57130415ab.0.1757082112699;
        Fri, 05 Sep 2025 07:21:52 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d8f0d594fsm6185353173.23.2025.09.05.07.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 07:21:52 -0700 (PDT)
Date: Fri, 5 Sep 2025 09:21:51 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Atish Patra <atish.patra@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 5/6] RISC-V: KVM: Implement ONE_REG interface for SBI
 FWFT state
Message-ID: <20250905-005c0bc3e16e909c5d91eef4@orel>
References: <20250823155947.1354229-1-apatel@ventanamicro.com>
 <20250823155947.1354229-6-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250823155947.1354229-6-apatel@ventanamicro.com>

On Sat, Aug 23, 2025 at 09:29:46PM +0530, Anup Patel wrote:
> The KVM user-space needs a way to save/restore the state of
> SBI FWFT features so implement SBI extension ONE_REG callbacks.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |   1 +
>  arch/riscv/include/uapi/asm/kvm.h          |  15 ++
>  arch/riscv/kvm/vcpu_sbi_fwft.c             | 197 +++++++++++++++++++--
>  3 files changed, 200 insertions(+), 13 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


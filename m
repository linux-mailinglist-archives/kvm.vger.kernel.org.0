Return-Path: <kvm+bounces-60132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 36921BE276E
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 11:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E67DF4FDA48
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 09:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E7B3191D5;
	Thu, 16 Oct 2025 09:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ovYtCXYA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010AC3074BC
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 09:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760607749; cv=none; b=VYqSM/06Z1AQpR0j2x8+HPsL0we5c85xB9N6HX9KOM0KmyG6JdF62QPpn2zUi1YHWUumYSx/IBa+/5ersbyWoyBB/UaxOj55q40mlpPh9/mKuXaEXsyDJaAvWupslT+7dvBuoDslgEKgUHD1U4llfHBCxuluD3nlEMpaIrzPJxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760607749; c=relaxed/simple;
	bh=TJql0MjlEkwtBqWMGqsTiMFcJvnVskrr/wExZvOMmAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YzUeOJa0VB8DlxnJFSr57LyMP1JVZObu1RYMhXSRjpp8nVghPZCvZ691HdLTPGGhp2P/mFOEAuM07h/BzVsWenIPPoAK5wqXaCYvIBUmWk3E3/ejfabfdsbmFsrNr7lfmy3JwySv4S1Zilg3Dlh9GtpqK+Rmq+M5enHSCtAeRjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ovYtCXYA; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-781251eec51so490786b3a.3
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 02:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1760607747; x=1761212547; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XT2WFxsGOH83YnSrOTwI7TIxuKSwIlmbX1n8UfKEr10=;
        b=ovYtCXYAqfWsKhOfcBA9yxBXJwbS4gehvUGTzor4oLgqb4kdSkM85P3qeRZpByL6Xr
         +6aKoAnBmsABh40hGijspdQzuCmTp0kuvzM7zA3pa27kH9JPd3zBhl2rQn0+XwwfPArP
         dYtv4tQ3xgWNje2B8EDfHdZ2+dxNLTB4i6UzvoKLTr1UzUv2rDNF6BD+8Jzd4Jad1GEu
         gd5mkS+e4kqyb7dj6iTAfMVMebi2pY6K0li9mu7Q4T8zfgj639u0lfuOp04EmvkbJlz+
         XEaD9mXpijB3Z1opoXhmnOEszUqadiKTabW9MaFRAHOT4JX6POCOMP7ywS/U2gPH7WLp
         P8rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760607747; x=1761212547;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XT2WFxsGOH83YnSrOTwI7TIxuKSwIlmbX1n8UfKEr10=;
        b=pmXhQ7b8Gl92OhiKhIIJ0j3wIIFLhESN7P7wRGort5DbQ5WusDebFNINTwGV9HWlsD
         RHltu0Fv61oYZQnTesd35hpkqoJJVCS1e7CwdKL8AU33TNw6TNKeW7mWSEO1txC+qELN
         /RXP0gCqDgaEmsA9d48ON0xv5tsJBzIAszzSgejsRGCCTD8FS63vG0ejsFaxmLhhkGdU
         D7dqj7oHZ4V3rMSYApKLdIPPVsqszcEd7da/HpGcC1zBpQlz8xaWs3ffCEpxB5h85zrj
         I5DVhXAFp8COe1agWTbc0WrQFO3ExYwNiobEmbxBt+eKQyMVSzoHFL5NnYt/UUxqhDP6
         P7HA==
X-Forwarded-Encrypted: i=1; AJvYcCUTyOKYuzO9QBrWANVwlQGxLd1x5aKV3FY/Bw1SXJdLTerUha0c896m3hD9DSs9lhaQnCM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLz5auew2mcyMFunEpeK+HzgEkm7swrHcSEUW0eaHsztecsy0g
	PbeLlLT0p2xUBovUTBytmlI+paoPF1102f1O79w94cksYAt7DteBT4qtFQpTfoL8MTCFQQId4yW
	MbAO9yuA=
X-Gm-Gg: ASbGncvEyXToQHOvg/Mu/mVR/AnkcvruN0VD72BdQliSf7K/qihp54k72IUA3c+qxdw
	as5Bvu/lH8ehzDzpwL2OxjUBxqTe9DhlkBO1HQIF6bJ91RfvpLqHNF1RrG00h6/85acUB3tkvTc
	i6ZXN0bXyKwjmofWUidfRpOKKvOz29LMs0We483iSz14+MySKAsie2cU1NDQgUZOaj9gqbDO132
	4dJTFdBRcvQph+NxMn+bpysXc7Mw2A9QyFxN7T01Op5vnjBZ7FUDOLwFn4viukMV+UgaMOqKOW/
	0vw0Y4bnLQcuIcnJ4MBQwhxZz4OdPEMZUOdvHuypWvzqhLWZKvVf21ywwEiJSUd0ZRBAUxwlXE6
	omdbo31B8YkVCpO9lbc6hfE4CgBMVkrZINmZcRcBTbJcxnhx6W5UQrT2hfGW/YZlfU38ZVe7JQn
	MFfICrbOVUNElC
X-Google-Smtp-Source: AGHT+IHCkThTNuYCNDPFDMoaZ326MNb+xnCy44BX/ER0JzSky2C3Wp9VABYjJvXunm9KzBwzZGmmPw==
X-Received: by 2002:a05:6a00:179b:b0:782:2b62:8188 with SMTP id d2e1a72fcca58-79387242eeemr41932448b3a.15.1760607747335;
        Thu, 16 Oct 2025 02:42:27 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992d9932edsm21496728b3a.73.2025.10.16.02.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 02:42:26 -0700 (PDT)
Date: Thu, 16 Oct 2025 04:42:25 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH] RISC-V: KVM: Fix check for local interrupts on riscv32
Message-ID: <20251016-7a89633477ad3dd0ae6eb969@orel>
References: <20251016001714.3889380-1-samuel.holland@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016001714.3889380-1-samuel.holland@sifive.com>

On Wed, Oct 15, 2025 at 05:17:09PM -0700, Samuel Holland wrote:
> To set all 64 bits in the mask on a 32-bit system, the constant must
> have type `unsigned long long`.
> 
> Fixes: 6b1e8ba4bac4 ("RISC-V: KVM: Use bitmap for irqs_pending and irqs_pending_mask")
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---
> 
>  arch/riscv/kvm/vcpu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index bccb919ca615..5ce35aba6069 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -212,7 +212,7 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>  
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>  {
> -	return (kvm_riscv_vcpu_has_interrupts(vcpu, -1UL) &&
> +	return (kvm_riscv_vcpu_has_interrupts(vcpu, -1ULL) &&
>  		!kvm_riscv_vcpu_stopped(vcpu) && !vcpu->arch.pause);
>  }
>  
> -- 
> 2.47.2
> 
> base-commit: 5a6f65d1502551f84c158789e5d89299c78907c7
> branch: up/kvm-aia-fix

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


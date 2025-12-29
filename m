Return-Path: <kvm+bounces-66806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 660E4CE85CB
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 00:53:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CEEBC3002532
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 23:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18C52FBDF5;
	Mon, 29 Dec 2025 23:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y9DoEudi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C9723FC5A
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 23:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767052432; cv=none; b=cXrpscEv071guRD7r7k9YcePS10gtEFKh9e2kA0QOu6JtQA2iYS22Kk7oPKrfzqejMq/0wwdrkyL3Uv6BqYUnWndo1dfOJz1PX8hA+xac3Xfn9qFLFwn919Jrl3FiPRgtZwGVBiLZg3kBiDf7/3TDMmFKc7bGOjxeIYzP+nHzNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767052432; c=relaxed/simple;
	bh=Ntb9jEY4SPxBVh3EUxSg4MS+CP2TInf7U39ONi1LYjQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DCHzu977+77XVnyR90LyhcEmLtY7c3qB/aMc5PCYqeBO2bXbZC7GhS4GRpvE4O7hKD57qjWhqmmeMzNasHr/Fv57WPCUVaR4DkqEQ53Bu/unRPKYrVGy2tYXzMo5ozXeLnDy6s6isUhu6OE1SNRgP/qquGCCAKYIffj5w24sHdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y9DoEudi; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34e70e2e363so21114829a91.1
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 15:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767052431; x=1767657231; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MfH+nMM1+R5XiBAj4XQuKja9fzvGLrp52fBOwIU4gdw=;
        b=y9DoEudi4hknT/PCdFc+sbqxhD0ngHGQ25D7GnUDC91IVyn31zk6bNS4w72Ped5HsC
         Gp9cGSPCFj30r5vNm3ZxKaq70ZBEbqj8f39BhDpwmXwyvv0gufk3317pPdX0hCTLMrmM
         38DQ0zHzT5d9Ycpum6GHqCtcH8JnUrWN0jLUNq8fly4iFM6snVzSgUc9iZm8WyZJWVwc
         tYqg7rPKgXl4Rava3LWaTGccaGwAqYyOz6bZ5FWp/rFCUBaokLU3bgvKGJkU+8yjIlhl
         /shQvj5tWZy/vx4IoeyyJ7o23/IK9L6eOOp7nCDfQXfL2XocvU60+aL/KOH8gzY3rjF1
         TE4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767052431; x=1767657231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MfH+nMM1+R5XiBAj4XQuKja9fzvGLrp52fBOwIU4gdw=;
        b=vF7ff+4sgvHpBlm/nvy1StRjlRPS8KeT1a6Kpkaofwm24bZFU0R1f6b7PdYR2lyot6
         niSGhQg88Oaq2oK4SM2/J8bWUf3MDJw1yVTsM/aCX8lYainf4fIdBwAmwRi6tT0T1vC0
         Sb9d1/bFu5iADecNuy9uHkK+8EyaOxz8NuhkfxQFjcNgAgwks5DLZl5dxuADNJPBmTXc
         tzoK5iOqmgbntpSrE5BP7FxkRyKDEuLqZ9DTzLBTliCis7f9ML9+b5irTHcFbdlieoKm
         fXDmLbckeg5ckxqpofow0OlFQfgoCCKXQXDkgYw3MYPLZlrBDXx5SLfUpILZY3JbmkDv
         /IYA==
X-Forwarded-Encrypted: i=1; AJvYcCUuC+R/zTtBfbS1Vtu2LSraDl+hwWDL7qxAfgne2S4rSggH/Z8bB8ZIsdlol3cirIwDxtQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzscNgBx4pDM7iatjAzdghcVPaC32u2twTu9EdC6GO+szouGuSf
	5swBCtD0JV4z2hjtTgRKtDI85VhITGNo1ip/LtflsxF5p9y9lCOA2cIQtpqAYqu52/7kVkI/NVH
	Ys44bDQ==
X-Google-Smtp-Source: AGHT+IGcYC+xx3tSXCyjmE+DDtKwWQMeLAZOYSJPOu/XmIR2JhJOgGvRMZab63DNNLBjo/SdCM6qftbbhg8=
X-Received: from pjbsi13.prod.google.com ([2002:a17:90b:528d:b0:34a:b869:5ed4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:298:b0:34c:7183:e290
 with SMTP id 98e67ed59e1d1-34e921eaf5dmr19177753a91.31.1767052430831; Mon, 29
 Dec 2025 15:53:50 -0800 (PST)
Date: Mon, 29 Dec 2025 15:53:49 -0800
In-Reply-To: <20251224001249.1041934-6-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251224001249.1041934-1-pbonzini@redhat.com> <20251224001249.1041934-6-pbonzini@redhat.com>
Message-ID: <aVMUjVoFEhazej6I@google.com>
Subject: Re: [PATCH 5/5] KVM: x86: kvm_fpu_get() is fpregs_lock_and_load()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

I'd prefer a shortlog that states what change is being made, but otherwise:

Reviewed-by: Sean Christopherson <seanjc@google.com>

On Wed, Dec 24, 2025, Paolo Bonzini wrote:
> The only difference is the usage of switch_fpu_return() vs.
> fpregs_restore_userregs().  In turn, these are only different
> if there is no FPU at all, but KVM requires one.  Therefore use the
> pre-made export---the code is simpler and there is no functional change.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kernel/fpu/core.c | 2 +--
>  arch/x86/kvm/fpu.h         | 6 +-----
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index ff17c96d290a..6571952c6ef1 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -846,7 +846,6 @@ void switch_fpu_return(void)
>  
>  	fpregs_restore_userregs();
>  }
> -EXPORT_SYMBOL_FOR_KVM(switch_fpu_return);
>  
>  void fpregs_lock_and_load(void)
>  {
> @@ -865,6 +864,7 @@ void fpregs_lock_and_load(void)
>  
>  	fpregs_assert_state_consistent();
>  }
> +EXPORT_SYMBOL_FOR_KVM(fpregs_lock_and_load);
>  
>  void fpu_load_guest_fpstate(struct fpu_guest *gfpu)
>  {
> @@ -899,7 +899,6 @@ void fpregs_assert_state_consistent(void)
>  
>  	WARN_ON_FPU(!fpregs_state_valid(fpu, smp_processor_id()));
>  }
> -EXPORT_SYMBOL_FOR_KVM(fpregs_assert_state_consistent);
>  #endif
>  
>  void fpregs_mark_activate(void)
> diff --git a/arch/x86/kvm/fpu.h b/arch/x86/kvm/fpu.h
> index f898781b6a06..b6a03d8fa8af 100644
> --- a/arch/x86/kvm/fpu.h
> +++ b/arch/x86/kvm/fpu.h
> @@ -149,11 +149,7 @@ static inline void _kvm_write_mmx_reg(int reg, const u64 *data)
>  
>  static inline void kvm_fpu_get(void)
>  {
> -	fpregs_lock();
> -
> -	fpregs_assert_state_consistent();
> -	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> -		switch_fpu_return();
> +	fpregs_lock_and_load();
>  }
>  
>  static inline void kvm_fpu_put(void)
> -- 
> 2.52.0
> 


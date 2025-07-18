Return-Path: <kvm+bounces-52895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F79AB0A5E8
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 16:12:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3834C5A5C79
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 14:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B06B2DAFCC;
	Fri, 18 Jul 2025 14:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZCdFg+RO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156F315E5C2
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 14:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752847967; cv=none; b=qu75cqh6xZF2rIBPwuYGO2i0EZek4urZvuxVI99jn/H4cgFizxELKTO4NciGN+DIN8R4hkhMms7wRiqX4wBJPvv1Cj6yV1AsooRNEJoeQvnKNnV6/4ldUD4QBBtKdGSzpe/kbGiqL0qjBKst2rSHzgT9YVoExiWECgCq/rxQGgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752847967; c=relaxed/simple;
	bh=TRsnlJOPX7jCuAnxZwxDgaXcSECNuOkl4qnz6n2qg90=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hp1UvdLZMDMdi8+qqoIvtpZ82zRb/Aa4l7XqMlQSW5GjvbfkUcurifYbDj4wT8nFk2L7P+7HNLFkxOaiYvxgA2ay/F4iXbw6KpFv9WU1XjW4UPpSPssNMEBF+e4KZayA7DG38pWOqj15uweDZNrPFIJ/bfBZgn87WfTOTj9y6js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZCdFg+RO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31327b2f8e4so1945868a91.1
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 07:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752847965; x=1753452765; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KOmjp1uxaXV9NwwZtk4ium+A2qkDcoP/OhzCbXJxhdo=;
        b=ZCdFg+ROnfm3lSU2AfhwS6v42FClEuM7y4mHTNQzbcff0jqEa5ONrchysMTnm/qWHz
         y22AtQGhn07zHw8Yg/275/K4qEhaG0t6/TvDY4d3ayoFQgNGJ+GMEFnc1zu35p8K2SEE
         /Ppgr/YEcu2t2okJ5foEEJxqXC0IZhDPO0o9EtI90Tl3qVIJSllE4mTQdAV9nKSfMUs6
         ky/K15S2Lwd85Ct1i7TCw/eO5j0bOACWRpm1E3qqb6dS3C54f/jv9zeJM3eO9MOO74Lj
         jk2SyWYqeU0q69F02fJvgfkOh0Bg4injdmMYYUbGxVkDVd6Ktk4Hkie1cQrM9zr+5o4M
         NLbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752847965; x=1753452765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KOmjp1uxaXV9NwwZtk4ium+A2qkDcoP/OhzCbXJxhdo=;
        b=K1hG8G+YLxDQokXSn6IYCuqHFmveNiu0O5Se3I+llmracws/jX0oEwEKrY4PPfJaQ+
         A62efOWIQ3kx2zMpadKbwLBwRpWqbcJYF4n4fZh5+z5xj672960xFD9GcTIr089a56DL
         5L2hR5uow/aje/TZcIv092nWIi2vDIa8QYabndJh3Y46oybt3+jRFTPL0T/8D+KwwQ8i
         /cV3x31uvjNB4PukOdElBE6/YcW16DOCGpR9JQNlIYi69ZMiQ+O97tlaFQ2xZWDfLQ5f
         HTPa5tH3+DlKYuIHNB/78FT0SH4AwOHhuTRCGzXNmFgd+yDSURKjWM0/K9nIA8vJsOmW
         QjAw==
X-Forwarded-Encrypted: i=1; AJvYcCWcV8V733rASS8T+Fh5kY0srcRWuJqEIgITI1eloGdJRbghbTxwjl5fAxtXYTMzyLuHHeA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiB1YnmLs9TQ3bNTCC1un9GT8+ZJrEy8xfNjc9mTz0PwFeLu3k
	CtsW9xcslh7uLwCqx9j8qAJp+4bb64RNAwj0b3F1IuI9i7dbsh5p0pCBRTUiQwNQNppySrrMHJD
	mAEBXlg==
X-Google-Smtp-Source: AGHT+IFB5nkXPUyu2pYjwVK7IdJa8WggIY0+Fxvu5N89HC12/p5Z2za6gUbziFQbMNmw/LiH0Z6X1QOb+qg=
X-Received: from pjk3.prod.google.com ([2002:a17:90b:5583:b0:31c:2fe4:33be])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e46:b0:313:2754:5910
 with SMTP id 98e67ed59e1d1-31c9f3eea5amr15716875a91.15.1752847965493; Fri, 18
 Jul 2025 07:12:45 -0700 (PDT)
Date: Fri, 18 Jul 2025 07:12:43 -0700
In-Reply-To: <20250718094936.5283-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250718094936.5283-1-lirongqing@baidu.com>
Message-ID: <aHpWW0ZPuI5thDqZ@google.com>
Subject: Re: [PATCH] x86/kvm: Reorder PV spinlock checks for dedicated CPU case
From: Sean Christopherson <seanjc@google.com>
To: lirongqing <lirongqing@baidu.com>
Cc: pbonzini@redhat.com, vkuznets@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 18, 2025, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> When a vCPU has a dedicated physical CPU, typically, the hypervisor
> disables the HLT exit too, 

But certainly not always.  E.g. the hypervisor may disable MWAIT exiting but not
HLT exiting, so that the hypervisor can take action if a guest kernel refuses to
use MWAIT for whatever reason.

I assume native qspinlocks outperform virt_spin_lock() irrespective of HLT exiting
when the vCPU has a dedicated pCPU?  If so, it's probably worth calling that out
in the changelog, e.g. to assuage any fears/concerns about this being undesirable
for setups with KVM_HINTS_REALTIME *and* KVM_FEATURE_PV_UNHALT.

> rendering the KVM_FEATURE_PV_UNHALT feature unavailable, and
> virt_spin_lock_key is expected to be disabled in this configuration, but:
> 
> The problematic execution flow caused the enabled virt_spin_lock_key:
> - First check PV_UNHALT
> - Then check dedicated CPUs
> 
> So change the order:
> - First check dedicated CPUs
> - Then check PV_UNHALT
> 
> This ensures virt_spin_lock_key is disable when dedicated physical
> CPUs are available and HLT exit is disabled, and this will gives a
> pretty performance boost at high contention level
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kernel/kvm.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 921c1c7..9cda79f 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -1073,16 +1073,6 @@ static void kvm_wait(u8 *ptr, u8 val)
>  void __init kvm_spinlock_init(void)
>  {
>  	/*
> -	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
> -	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
> -	 * preferred over native qspinlock when vCPU is preempted.
> -	 */
> -	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
> -		pr_info("PV spinlocks disabled, no host support\n");
> -		return;
> -	}
> -
> -	/*
>  	 * Disable PV spinlocks and use native qspinlock when dedicated pCPUs
>  	 * are available.
>  	 */
> @@ -1101,6 +1091,16 @@ void __init kvm_spinlock_init(void)
>  		goto out;
>  	}
>  
> +	/*
> +	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
> +	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
> +	 * preferred over native qspinlock when vCPU is preempted.
> +	 */
> +	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
> +		pr_info("PV spinlocks disabled, no host support\n");
> +		return;
> +	}
> +
>  	pr_info("PV spinlocks enabled\n");
>  
>  	__pv_init_lock_hash();
> -- 
> 2.9.4
> 


Return-Path: <kvm+bounces-45755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AEC83AAE854
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 20:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75AD71C203E5
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 18:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768FE28DF26;
	Wed,  7 May 2025 18:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kv0G2HrY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3975E1E1DF6
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 18:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746640883; cv=none; b=W3eakjsZQeGf6QjTmZd+RiWXZmkGyhmio5qNl5pNgG3q7SesnVuvJz2uvlRmSzTq+sNzxnz3+tnpdmFTpCoud3uM9+5XyCjxD5eUrgMbZM9FL/cPBYzdk7mzCqnmE2luBux7N/t1H5RJ+eG8MPjlf8AnGkoigxLqmez+eQmW2/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746640883; c=relaxed/simple;
	bh=26Zb7LiBJSl3gQZzW3a8HzAfTQc562cMCy6AuDfWssI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FNn0ElXIcIAyrj+o2HsJGHZKOH544AoYb8ETr8y7i0T2aBHl7VjQeW+viTfckXBwvc0uYMCdUv7mrvg36nQPPz8mhHuvBMw5vkLOQKB/yC4s5lF4h0AvnIQfPQO20fFLbQXYMfz+JzoVYv0T3i/pB1tw+ibcqBC2M5TPPJ7OjFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kv0G2HrY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30a29af28d1so160541a91.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 11:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746640881; x=1747245681; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FbajxzigzwfB6KYWyyGtLYt8OcNqKAvCe8D0yhsQfcc=;
        b=Kv0G2HrY9qAgSd8eRvjxJAABOFB5W2JhoUYOizCb6BznTq3hWvud6UF440GgE/8uvK
         oEg1a4uIS68bqihONhGoxFd8uIpyTDnhUOKIK6CMtOzu4SM4AmFfYqHLIQDox+4VIA5s
         y+HsGMUuA0fmC+KZ7Heh4XAeOvKAxLcYjiHQgRZaZ5qkAWSq32en+Ic3d075fUcNyFNw
         o3XXtlZK4SqrcbLg5a6pt3W25tpQ1ijEJSfjpc2LqOKdkF6CLdNr/fIQds2QQQPE/+4n
         5lAzSL66QYG1YuJIqVwAtCzk/Ch/IsgO/tXr/KJG+VP7rZkrWA+DuOgsngCob0N1Q/rF
         68MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746640881; x=1747245681;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FbajxzigzwfB6KYWyyGtLYt8OcNqKAvCe8D0yhsQfcc=;
        b=fUtLYvEIOqh/EdaX34rTzZRy/lleTVEmoN+UUtaIDLWz7kEjj/wDSnVq87EUBNkZeX
         eBN/2d5Q7/l9B+Wa1aN8jUulxfxHe4U3GfHjBvWRANVnmJn0LmgduSFmaYbsv5IUDe9Y
         2HWQEJl0gxTGbq0cD9KNrMTlGioqgkpQ386g6OiHq67xTrXZwL8d0F6C/ad/cE91dH9W
         gF2pEn9GftRe1srXHl18O8nZnswv/4vhAZ7yNPU7nV7EigYN2WEQE49gpbL6QdVR2ksA
         Xrf2OyJGY2AGMs/1qdUxRGoXvuWT4yoiw4ZHpWwqvokaqz8uU2fBKZ2Wsf0XQsTc+qRW
         ysaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaQUpLYR80kie3BHpQmAu7Y7lkgSKEVMUcClzjPgaC2rAM2zBVecjXV8QOQ4v6lGry9iA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSC+mC5nJHPwnk9zpyPb7bDa+aPHEdeKU0DiLqscQc0hEyHFCR
	EJV8fMNmdWcblvqqGwqdZrpFwAmGidjUEvNpE8xvJbz4SNIkF4knzDEeI9kz03fstpYiJFHbcWl
	bPQ==
X-Google-Smtp-Source: AGHT+IFAAB1cRX2ShIDeBVkV9/+IDWgDLmDry9yYG7heeYgF6kyohsv+w+LtJtnvKy1ws16F4ufVFsvvfC8=
X-Received: from pjbpm5.prod.google.com ([2002:a17:90b:3c45:b0:2ef:d136:17fc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d02:b0:30a:255c:9c89
 with SMTP id 98e67ed59e1d1-30b3a6634a4mr119512a91.19.1746640881483; Wed, 07
 May 2025 11:01:21 -0700 (PDT)
Date: Wed, 7 May 2025 11:01:19 -0700
In-Reply-To: <aBsNxmHE7UO03iCs@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250506093740.2864458-1-chao.gao@intel.com> <20250506093740.2864458-6-chao.gao@intel.com>
 <aBpFvyITMc0WhlX4@google.com> <aBsNxmHE7UO03iCs@intel.com>
Message-ID: <aBuf7wiiDT0Wflhk@google.com>
Subject: Re: [PATCH v6 5/7] x86/fpu: Initialize guest fpstate and FPU pseudo
 container from guest defaults
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	tglx@linutronix.de, dave.hansen@intel.com, pbonzini@redhat.com, 
	peterz@infradead.org, rick.p.edgecombe@intel.com, weijiang.yang@intel.com, 
	john.allen@amd.com, bp@alien8.de, chang.seok.bae@intel.com, xin3.li@intel.com, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Eric Biggers <ebiggers@google.com>, 
	Stanislav Spassov <stanspas@amazon.de>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 07, 2025, Chao Gao wrote:
> From: Chao Gao <chao.gao@intel.com>
> Date: Fri, 31 May 2024 02:03:30 -0700
> Subject: [PATCH] x86/fpu: Initialize guest fpstate and FPU pseudo container
>  from guest defaults
> 
> fpu_alloc_guest_fpstate() currently uses host defaults to initialize guest
> fpstate and pseudo containers. Guest defaults were introduced to
> differentiate the features and sizes of host and guest FPUs. Switch to
> using guest defaults instead.
> 
> Adjust __fpstate_reset() to handle different defaults for host and guest
> FPUs. And to distinguish between the types of FPUs, move the initialization
> of indicators (is_guest and is_valloc) before the reset.
> 
> Suggested-by: Chang S. Bae <chang.seok.bae@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>  arch/x86/kernel/fpu/core.c | 27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 444e517a8648..0d501bd25d79 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -236,19 +236,22 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>  	struct fpstate *fpstate;
>  	unsigned int size;
>  
> -	size = fpu_kernel_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
> +	size = guest_default_cfg.size + ALIGN(offsetof(struct fpstate, regs), 64);
> +
>  	fpstate = vzalloc(size);
>  	if (!fpstate)
>  		return false;
>  
> +	/* Initialize indicators to reflect properties of the fpstate */
> +	fpstate->is_valloc	= true;
> +	fpstate->is_guest	= true;
> +
>  	/* Leave xfd to 0 (the reset value defined by spec) */
>  	__fpstate_reset(fpstate, 0);
>  	fpstate_init_user(fpstate);
> -	fpstate->is_valloc	= true;
> -	fpstate->is_guest	= true;
>  
>  	gfpu->fpstate		= fpstate;
> -	gfpu->xfeatures		= fpu_kernel_cfg.default_features;
> +	gfpu->xfeatures		= guest_default_cfg.features;
>  
>  	/*
>  	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
> @@ -535,10 +538,20 @@ void fpstate_init_user(struct fpstate *fpstate)
>  
>  static void __fpstate_reset(struct fpstate *fpstate, u64 xfd)
>  {
> -	/* Initialize sizes and feature masks */
> -	fpstate->size		= fpu_kernel_cfg.default_size;
> +	/*
> +	 * Initialize sizes and feature masks. Supervisor features and
> +	 * sizes may diverge between guest FPUs and host FPUs, whereas
> +	 * user features and sizes are always identical the same.
> +	 */
> +	if (fpstate->is_guest) {
> +		fpstate->size		= guest_default_cfg.size;
> +		fpstate->xfeatures	= guest_default_cfg.features;
> +	} else {
> +		fpstate->size		= fpu_kernel_cfg.default_size;
> +		fpstate->xfeatures	= fpu_kernel_cfg.default_features;
> +	}

Nice!  I like this idea.

> +
>  	fpstate->user_size	= fpu_user_cfg.default_size;
> -	fpstate->xfeatures	= fpu_kernel_cfg.default_features;
>  	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
>  	fpstate->xfd		= xfd;

And then a follow-up patch (or same patch?) to do this?

	if (fpstate->is_guest) {
		fpstate->size           = guest_default_cfg.size;
		fpstate->xfeatures      = guest_default_cfg.features;
		fpstate->xfd		= 0;
	} else {
		fpstate->size           = fpu_kernel_cfg.default_size;
		fpstate->xfeatures      = fpu_kernel_cfg.default_features;
		fpstate->xfd		= init_fpstate.xfd;
	}
>  }
> -- 
> 2.47.1


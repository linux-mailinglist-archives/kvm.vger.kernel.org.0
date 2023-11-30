Return-Path: <kvm+bounces-3003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68D917FF96B
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:32:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B4211C20FBA
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D3A55A104;
	Thu, 30 Nov 2023 18:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TweqnZzU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DABD6C
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701369159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uf3Ss8OAEWvNG8bOfwQMtLxEfVJoUheXU7f8sA0Je4M=;
	b=TweqnZzUgcc34ifEWUhW6oze/ldBASjHkqEGk+AUm4lMeMTM2Wc/GDr6TzGyaZQd2e09ny
	1Y7ih3gle1GStD7TLN7k/5u8zjBITeSFQ3hIB9vX+ajTgzgneluRKcPWn4go4e4PHIHRx9
	CFlutKTYsdOEMFGNJ7LbHbvsNPBdSso=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-PqPVQ2lnOfa6q0pvlUZA-w-1; Thu, 30 Nov 2023 13:32:38 -0500
X-MC-Unique: PqPVQ2lnOfa6q0pvlUZA-w-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40b4e24adc7so10085385e9.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:32:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701369157; x=1701973957;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uf3Ss8OAEWvNG8bOfwQMtLxEfVJoUheXU7f8sA0Je4M=;
        b=tDnRvHwIYJXP51jJ14BkAJ8flw3VTKHf0+cQ69T6hDTW7kGXAxQo8pJk5wj32hWPvF
         SM2nXicbvQ/b1P9elKspcBOGjnIADgR5Uc4iYo96ElnFMcsUfdsyx/7nQAKWindK+b9f
         KKE2YZROBTjk5dMlX5mMtcF/oxrqjZ7H3nEqTf4VeDX451hH6luKKHHG6H7Hvm0QgZNO
         KhX8T/N2xk2wE+K5F3DFQcMLIyOVN/Ab/+0+OvtNeVnVSWElvHYlV78MBwaHbznOso9f
         vkwQyw3nGD02ZrxRwxlR/cH9WomCtvBw03jgDeJjw4vLscMHGlHEV24QrXIDaWQPGarN
         qBeg==
X-Gm-Message-State: AOJu0YxIyTuGG7nviGwRcx2zmyKZWYHHGKbO9i411kj/FNoAyYaP0RTL
	tuxvnRybSkgUmI0q6KIjQebQLv60jNydIW5UbdO+3m00XWZiX9uIMyevvbfusAVkSWfy0fFIneh
	L1R2VhhbaOK1N
X-Received: by 2002:a2e:9083:0:b0:2b9:412a:111d with SMTP id l3-20020a2e9083000000b002b9412a111dmr6604ljg.42.1701365790347;
        Thu, 30 Nov 2023 09:36:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IExhvZ3xoy34KD/kfCKvq7DxJbGWwzQscJxZr25xdZlOmm9bJQSkcAj8siZ+c1DsISgYLI8iA==
X-Received: by 2002:a2e:9083:0:b0:2b9:412a:111d with SMTP id l3-20020a2e9083000000b002b9412a111dmr6402ljg.42.1701365787477;
        Thu, 30 Nov 2023 09:36:27 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id h6-20020a2ea486000000b002c505a6a398sm199616lji.89.2023.11.30.09.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:36:27 -0800 (PST)
Message-ID: <e1469c732e179dfd7870d0f4ba69f791af0b5d57.camel@redhat.com>
Subject: Re: [PATCH v7 06/26] x86/fpu/xstate: Create guest fpstate with
 guest specific config
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 30 Nov 2023 19:36:24 +0200
In-Reply-To: <20231124055330.138870-7-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-7-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
> Use fpu_guest_cfg to calculate guest fpstate settings, open code for
> __fpstate_reset() to avoid using kernel FPU config.
> 
> Below configuration steps are currently enforced to get guest fpstate:
> 1) Kernel sets up guest FPU settings in fpu__init_system_xstate().
> 2) User space sets vCPU thread group xstate permits via arch_prctl().
> 3) User space creates guest fpstate via __fpu_alloc_init_guest_fpstate()
>    for vcpu thread.
> 4) User space enables guest dynamic xfeatures and re-allocate guest
>    fpstate.
> 
> By adding kernel dynamic xfeatures in above #1 and #2, guest xstate area
> size is expanded to hold (fpu_kernel_cfg.default_features | kernel dynamic
> xfeatures | user dynamic xfeatures), then host xsaves/xrstors can operate
> for all guest xfeatures.
> 
> The user_* fields remain unchanged for compatibility with KVM uAPIs.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kernel/fpu/core.c   | 48 ++++++++++++++++++++++++++++--------
>  arch/x86/kernel/fpu/xstate.c |  2 +-
>  arch/x86/kernel/fpu/xstate.h |  1 +
>  3 files changed, 40 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 516af626bf6a..985eaf8b55e0 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -194,8 +194,6 @@ void fpu_reset_from_exception_fixup(void)
>  }
>  
>  #if IS_ENABLED(CONFIG_KVM)
> -static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
> -
>  static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
>  {
>  	struct fpu_state_perm *fpuperm;
> @@ -216,25 +214,55 @@ static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
>  	gfpu->perm = perm & ~FPU_GUEST_PERM_LOCKED;
>  }
>  
> -bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
> +static struct fpstate *__fpu_alloc_init_guest_fpstate(struct fpu_guest *gfpu)
>  {
> +	bool compacted = cpu_feature_enabled(X86_FEATURE_XCOMPACTED);
> +	unsigned int gfpstate_size, size;
>  	struct fpstate *fpstate;
> -	unsigned int size;
>  
> -	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
> +	/*
> +	 * fpu_guest_cfg.default_features includes all enabled xfeatures
> +	 * except the user dynamic xfeatures. If the user dynamic xfeatures
> +	 * are enabled, the guest fpstate will be re-allocated to hold all
> +	 * guest enabled xfeatures, so omit user dynamic xfeatures here.
> +	 */

This is a very good comment to have, although I don't think there is any way
to ensure that the whole thing is not utterly confusing.....


> +	gfpstate_size = xstate_calculate_size(fpu_guest_cfg.default_features,
> +					      compacted);
> +
> +	size = gfpstate_size + ALIGN(offsetof(struct fpstate, regs), 64);
> +
>  	fpstate = vzalloc(size);
>  	if (!fpstate)
> -		return false;
> +		return NULL;
> +	/*
> +	 * Initialize sizes and feature masks, use fpu_user_cfg.*
> +	 * for user_* settings for compatibility of exiting uAPIs.
> +	 */
> +	fpstate->size		= gfpstate_size;
> +	fpstate->xfeatures	= fpu_guest_cfg.default_features;

> +	fpstate->user_size	= fpu_user_cfg.default_size;
> +	fpstate->user_xfeatures	= fpu_user_cfg.default_features;

The whole thing makes my head spin like the good old CD/DVD writers used to ....

So just to summarize this is what we have:


KERNEL FPU CONFIG

/* 
   all known and CPU supported user and supervisor features except 
   - "dynamic" kernel features" (CET_S)
   - "independent" kernel features (XFEATURE_LBR)
*/
fpu_kernel_cfg.max_features;

/* 
   all known and CPU supported user and supervisor features except 
    - "dynamic" kernel features" (CET_S)
    - "independent" kernel features (arch LBRs)
    - "dynamic" userspace features (AMX state)
*/
fpu_kernel_cfg.default_features;


// size of compacted buffer with 'fpu_kernel_cfg.max_features'
fpu_kernel_cfg.max_size;


// size of compacted buffer with 'fpu_kernel_cfg.default_features'
fpu_kernel_cfg.default_size;


USER FPU CONFIG

/*
   all known and CPU supported user features
*/
fpu_user_cfg.max_features;

/*
   all known and CPU supported user features except
   - "dynamic" userspace features (AMX state)
*/
fpu_user_cfg.default_features;

// size of non compacted buffer with 'fpu_user_cfg.max_features'
fpu_user_cfg.max_size;

// size of non compacted buffer with 'fpu_user_cfg.default_features'
fpu_user_cfg.default_size;


GUEST FPU CONFIG
/* 
   all known and CPU supported user and supervisor features except 
   - "independent" kernel features (XFEATURE_LBR)
*/
fpu_guest_cfg.max_features;

/* 
   all known and CPU supported user and supervisor features except 
    - "independent" kernel features (arch LBRs)
    - "dynamic" userspace features (AMX state)
*/
fpu_guest_cfg.default_features;

// size of compacted buffer with 'fpu_guest_cfg.max_features'
fpu_guest_cfg.max_size;

// size of compacted buffer with 'fpu_guest_cfg.default_features'
fpu_guest_cfg.default_size;



---


So in essence, guest FPU config is guest kernel fpu config and that is why 
'fpu_user_cfg.default_size' had to be used above.

How about that we have fpu_guest_kernel_config and fpu_guest_user_config instead
to make the whole horrible thing maybe even more complicated but at least a bit more orthogonal? 

Best regards,
	Maxim Levitsky





> +	fpstate->xfd		= 0;
>  
> -	/* Leave xfd to 0 (the reset value defined by spec) */
> -	__fpstate_reset(fpstate, 0);
>  	fpstate_init_user(fpstate);
>  	fpstate->is_valloc	= true;
>  	fpstate->is_guest	= true;
>  
>  	gfpu->fpstate		= fpstate;
> -	gfpu->xfeatures		= fpu_user_cfg.default_features;
> -	gfpu->perm		= fpu_user_cfg.default_features;
> +	gfpu->xfeatures		= fpu_guest_cfg.default_features;
> +	gfpu->perm		= fpu_guest_cfg.default_features;
> +
> +	return fpstate;
> +}
> +
> +bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
> +{
> +	struct fpstate *fpstate;
> +
> +	fpstate = __fpu_alloc_init_guest_fpstate(gfpu);
> +
> +	if (!fpstate)
> +		return false;
>  
>  	/*
>  	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index aa8f8595cd41..253944cb2298 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -559,7 +559,7 @@ static bool __init check_xstate_against_struct(int nr)
>  	return true;
>  }
>  
> -static unsigned int xstate_calculate_size(u64 xfeatures, bool compacted)
> +unsigned int xstate_calculate_size(u64 xfeatures, bool compacted)
>  {
>  	unsigned int topmost = fls64(xfeatures) -  1;
>  	unsigned int offset = xstate_offsets[topmost];
> diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
> index 3518fb26d06b..c032acb56306 100644
> --- a/arch/x86/kernel/fpu/xstate.h
> +++ b/arch/x86/kernel/fpu/xstate.h
> @@ -55,6 +55,7 @@ extern void fpu__init_cpu_xstate(void);
>  extern void fpu__init_system_xstate(unsigned int legacy_size);
>  
>  extern void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
> +extern unsigned int xstate_calculate_size(u64 xfeatures, bool compacted);
>  
>  static inline u64 xfeatures_mask_supervisor(void)
>  {






Return-Path: <kvm+bounces-24405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BD4D954FF1
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 19:23:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 217321F261C2
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 17:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A7E1C0DFE;
	Fri, 16 Aug 2024 17:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xjnm+6ra"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDEF1BDA8D
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 17:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723828981; cv=none; b=HBmQoltLQPKIJ6N9lyUhtlEpeQb6UxWWig73C7E8CP5VFE1RGc4v3aXwCFbpJYTSLLjWRi0c8qw6H14YVN/uEFAXCP7XQGk/tgcMoeUrUH6xS8iWbNzoS3SvBIOK2/Vg9C4UpG/2Wb5aXhGQTV70MTU71UisUwZrYsxYBCGZXP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723828981; c=relaxed/simple;
	bh=8h0AWqNO7UAdNfFMUWGicTqDBGvZ9smz37DLrgwNgjM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WDMjCnB2JTZDRnLhSHo4MqO9tccDtxzFaYDdo9d2aYiMYWSM73yOkWiFJzAKIEE/VU+BGd/2/9kfwbMZpaP3KtqduM3Blf5Kpc3LNEUY3BXf9NlhXLf1YxeZDshQsVDakDwB03OpGy0yRepsohAvF5SlTYR8WrKHqRpe3NF921c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xjnm+6ra; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e02a4de4f4eso3828289276.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 10:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723828978; x=1724433778; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0C6ZQ6yjWsSYaXFSRs0NsNHAbv6yGvt9QfBOklOP38I=;
        b=xjnm+6rauctOFxcrbaswg4Ucj8m2X8iPcqGs6Y2EHA72Nuv/pCrh7849unxMgkNIuQ
         QTBE33O7JuTl6ighyS7rExrLoSsKFT1HQ+JrP6F4TBe79dl4Ad/ya5xk64sQahMXt4JN
         WaLDOjGamhHo8oaezjGQDvue1fryBaf7PaVUw3P219MgCOSqnSK982/Ey6FO9jaWxkzc
         HtAgoq3CWi1l+KKQemAVmKogsI13mQyb3SAwLm2lByqv74qzOFKrRZM2KW1y3yFjEg3R
         DBmYqPY0iYAgjOi6LP9JSwlZEyFj+HKF6i17LnX8Wba/hCBP46Pz8VCVVksX5hUyVib0
         ZYJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723828978; x=1724433778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0C6ZQ6yjWsSYaXFSRs0NsNHAbv6yGvt9QfBOklOP38I=;
        b=BSJwMgJhpKVK/8OO8VH8mGL8846Ujjo4/8COmnkerE/nm17etHbdi13rFbsEgsEXI1
         FtXHgfKEwVnvwfhSmgvYXEGLI7ADSuJaA18tGLSAWyFFbcu0r1t6KghjlHSwbURUzCUN
         B+mWXO6yRJjkb3ouCogqvYK5zE0o8Us40F0fEPIrP5lpfLvoA75JWoqOIZ8OonwEZmS3
         ot+6HAf7i2d/chdmV61r6S6aYQIoi4VBNwppdIVQy/6GT/6t7gg3yJR5sJ/xkkvX6JZp
         LkIAmwC+V4t4jrlEIcG8cz3br6Xl21vC0nSZCDcifqmbXKJmkXkOxik+6h+g7F/wMoln
         dHcA==
X-Gm-Message-State: AOJu0YwDJ6tHGEYCReMks0jqu9n+VaCm3PMVw34ujI8YLgsjJC+AXCkh
	PJPfpg9WEM/dK5t6nEckVwSqalI73QXj7oNUXdRfPhD7j9TZGwulO5ZNEQmcQhKMJoixuEYx7E2
	9Cw==
X-Google-Smtp-Source: AGHT+IF17EAvkZnF/avNY0BjLuFmi2uQ6ckNqRFvdbeBzm4AslZUUqh0U7+/c7dVSU2di4sOPVEBkfjJ6sI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2d23:0:b0:e0e:ce19:4e51 with SMTP id
 3f1490d57ef6-e1180e4a636mr5828276.3.1723828977460; Fri, 16 Aug 2024 10:22:57
 -0700 (PDT)
Date: Fri, 16 Aug 2024 10:22:56 -0700
In-Reply-To: <20240501202934.1365061-3-kishen.maloor@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240501202934.1365061-1-kishen.maloor@intel.com> <20240501202934.1365061-3-kishen.maloor@intel.com>
Message-ID: <Zr-K8Gd0ynQJ_V6n@google.com>
Subject: Re: [PATCH v3 2/2] KVM: x86: nSVM/nVMX: Fix RSM logic leading to L2 VM-Entries
From: Sean Christopherson <seanjc@google.com>
To: Kishen Maloor <kishen.maloor@intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, mlevitsk@redhat.com, 
	zheyuma97@gmail.com, Michal Wilczynski <michal.wilczynski@intel.com>
Content-Type: text/plain; charset="us-ascii"

Sorry for the super slow review, I was dreading looking at KVM's SMM mess :-)

On Wed, May 01, 2024, Kishen Maloor wrote:
> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> index d06d43d8d2aa..b1dac967f1a5 100644
> --- a/arch/x86/kvm/smm.c
> +++ b/arch/x86/kvm/smm.c
> @@ -633,8 +633,16 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
>  
>  #ifdef CONFIG_X86_64
>  	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
> -		return rsm_load_state_64(ctxt, &smram.smram64);
> +		ret = rsm_load_state_64(ctxt, &smram.smram64);
>  	else
>  #endif
> -		return rsm_load_state_32(ctxt, &smram.smram32);
> +		ret = rsm_load_state_32(ctxt, &smram.smram32);
> +
> +	/*
> +	 * Set nested_run_pending to ensure completion of a nested VM-Entry
> +	 */
> +	if (ret == X86EMUL_CONTINUE && ctxt->ops->is_guest_mode(ctxt))

No need to bounce through the emulation context, this can simply be

	if (ret == X86EMUL_CONTINUE && is_guest_mode(vcpu))

> +		vcpu->arch.nested_run_pending = 1;

That said, while I 100% agree that KVM shouldn't set nested_run_pending before
loading state from SMRAM, I think it's actually the wrong fix.  I am fairly certain
that the real issue is that KVM is synthesizing shutdown _for L2_.  Neither the
the SDM and APM state that a shutdown on RSM to guest mode can trigger a VM-Exit,
Intel's pseudocode explicitly says state is loaded from SMRAM before transitioning
the CPU back to non-root mode, and AMD saves VMCB state in SMRAM, i.e. it's not
treated differently (like Intel does for VMX state).

So, the more correct, and amusingly easier, fix is to forcibly leave nested mode
prior to signalling shutdown.  I'll post a patch for that.

I think I'll also grab patch 1 and post it in a slightly larger cleanup series
at some point.  Making nested_run_pending a common field is worthwhile regardless
of this SMM mess.


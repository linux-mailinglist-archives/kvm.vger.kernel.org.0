Return-Path: <kvm+bounces-20684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C482B91C354
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 18:09:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2D131C23509
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 16:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 865B51C8FDB;
	Fri, 28 Jun 2024 16:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ACrxuD85"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579AA157E91
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 16:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719590959; cv=none; b=MsRSdPJO6/AYvXmwxDpKU3XfVpg74eik6z/CpSBa1aFiZAvgqor8B+I3AKNqdPOEIqEfauMSLV4TT21D2hu8XCTXWDU8KX+IhUjD4pRuQUUMr/QG6SNom2ERAJDTM8f1hG1W8RijIVP7TkaNWPRJxBqz4UZw1c+by/xOLoucR7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719590959; c=relaxed/simple;
	bh=xSiS5VbBTWtHkMjKE2FM2x8QgKqasXrVFPcpXxJBCgY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mocUPUB7smI9EO4j69yov+hRBcaqxyuAfSTdZONUMBv0HAhnWSQzcOD0C0w560o909uXA+k+Dp1zfxEZZcP0Dp7k20FRzKTi1Rq/oNbino+xJBwOgm2/jVTibEDCYL80c80PyKMFnSfThY5+fOZvqMg2iXUqtEP0xxvFSTKTcWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ACrxuD85; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-643acc141cbso8622857b3.1
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 09:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719590957; x=1720195757; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+dLquM4FkT/DoL6SKER0hksUwO28Urfz4ARvtIF4KV8=;
        b=ACrxuD85npxF2sDckIotp0Zetm0RVFfhRzm4nDfgqWP7MfB5RWNKnL3J3Bn+qZ+kFS
         56ywuwwvhT6HMl0wfQEqxdAmuiEejUEVc7JdR+04ABJUbzxX1KfIhzhJqaLZa8umEio2
         QLNHTSbART3obQGDdUu8AJ3bEaLvfsIvRfDawauPfY1+bQaNxm6pgeNXczdhws4xkQ+x
         bYx0F/f/HO6bDM8MK0MMUdv0tLPvhpASLf3tNhqOZjO0tsHcH0EUDwzhRf/ZbmGRqAEp
         xp1RQS8xy7KWipIAzMqX1jB19PYmMYIQRHnfrNQuxqrckYQ8Jscjfre4O88ayU+GCfG2
         4o6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719590957; x=1720195757;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+dLquM4FkT/DoL6SKER0hksUwO28Urfz4ARvtIF4KV8=;
        b=kkEjj8sxFJFuHm3Ba489naFrrx5wcihAkQNoxhxQ/xeSgBeMDKmWdZ2+VBU8y3dw+1
         0JNCBHM0T3f/PJu3TWhjVJkqn2M2ixW+wB0AS4raFd/ZRolWyjZv5jRZ1ZHz57V9DGl4
         Ipfku0fE3xYAUMLUNe+x3q/iehjewjNAPUUWnCqU1iz2ETtFQZriym/k0oLh79T78Km3
         rPxCzkELTAFpW19z8I6jkTtC8qJ4RFsVHCwZUjLCsQgPBCP5y/LqD6Z0ipXBPjwB04Cq
         kHfPAT0+GQK86JOZZoigCZdIAqSQmcUcfvqcfSvLXod5VB6KL7wD5TYrMnDFVvZwT4P/
         7now==
X-Forwarded-Encrypted: i=1; AJvYcCUHM47I04y6rIEPLreOEHPxUBs9SP0nZj9LEvBkBstuUnMO43QGl1fIlmeHUoZl5GGWt2vDZy6jhFacnahLqLw/V+60
X-Gm-Message-State: AOJu0Yza3+cSNl3uUp6rcV96AoE53KAS4RIR7hneLVefFtjcPAOFynEM
	StFnrAdRJt6uFG8nSsKsdu6a9eVeaYoiC9qumssPjup9z0GofIT4q1kQ+yHP6u/ZniGE26mLjhJ
	HCw==
X-Google-Smtp-Source: AGHT+IHJY/lTxp/95vjfGeiS7oXbM4P6tRf14ezu1AV3VayEqpmqGBX9AHi66wPOpt9anlmG2eQslSmpJn4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:8451:0:b0:627:edcb:cbe2 with SMTP id
 00721157ae682-64af5dfeb07mr216687b3.5.1719590957359; Fri, 28 Jun 2024
 09:09:17 -0700 (PDT)
Date: Fri, 28 Jun 2024 09:09:15 -0700
In-Reply-To: <20240626073719.5246-1-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240626073719.5246-1-amit@kernel.org>
Message-ID: <Zn7gK9KZKxBwgVc_@google.com>
Subject: Re: [PATCH v2] KVM: SVM: let alternatives handle the cases when RSB
 filling is required
From: Sean Christopherson <seanjc@google.com>
To: Amit Shah <amit@kernel.org>
Cc: pbonzini@redhat.com, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, amit.shah@amd.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kim.phillips@amd.com, david.kaplan@amd.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 26, 2024, Amit Shah wrote:
> ---
>  arch/x86/kvm/svm/vmenter.S | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
> index a0c8eb37d3e1..2ed80aea3bb1 100644
> --- a/arch/x86/kvm/svm/vmenter.S
> +++ b/arch/x86/kvm/svm/vmenter.S
> @@ -209,10 +209,8 @@ SYM_FUNC_START(__svm_vcpu_run)
>  7:	vmload %_ASM_AX
>  8:
>  
> -#ifdef CONFIG_MITIGATION_RETPOLINE
>  	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
> -	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
> -#endif
> +	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT

Out of an abundance of paranoia, shouldn't this be?

	FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT,\
			   X86_FEATURE_RSB_VMEXIT_LITE

Hmm, but it looks like that would incorrectly trigger the "lite" flavor for
families 0xf - 0x12.  I assume those old CPUs aren't affected by whatever on earth
EIBRS_PBRSB is.

	/* AMD Family 0xf - 0x12 */
	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_BHI),
	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_BHI),
	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_BHI),
	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_BHI),

	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB | NO_BHI),
	VULNWL_HYGON(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB | NO_BHI),

>  
>  	/* Clobbers RAX, RCX, RDX.  */
>  	RESTORE_HOST_SPEC_CTRL
> @@ -348,10 +346,8 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
>  
>  2:	cli
>  
> -#ifdef CONFIG_MITIGATION_RETPOLINE
>  	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
> -	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
> -#endif
> +	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
>  
>  	/* Clobbers RAX, RCX, RDX, consumes RDI (@svm) and RSI (@spec_ctrl_intercepted). */
>  	RESTORE_HOST_SPEC_CTRL
> -- 
> 2.45.2
> 


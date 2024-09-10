Return-Path: <kvm+bounces-26338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AF759743CD
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 21:59:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D568D1F26813
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 19:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B641A7AEE;
	Tue, 10 Sep 2024 19:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xRPH8BL/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE46F1A38F4
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 19:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725998368; cv=none; b=uBXCHhEBl1P+Lg9GiHHXmgM1xSTF5wjUd01LtfR7Pxl39A4yZ+O61g5O6skzD7dY0YYZCI0yH4Onsf/bev6A7MdA/MmDvU1IjrI0iLsq0WvR+RnoKYWxFNrgeydRPPdIv/FYPCEkzz3ojSjS4Oxxv94N/XE+0V0UiaJ0MuJaDYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725998368; c=relaxed/simple;
	bh=JsFgjG7RzN9cW564KrDmIlGbzKdzMWvwxWy1OkvvXKs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DWD7C0i9WjtRRHDkpIdx+Iz2ysg0brxBNjTP0NyDaSiTWniU+bshSjpGVkPID5dJRVaqco0HZudFkDsNJxIDwG1Kcn/2Q0kvApcWnLLNTmV+3KgOst9fxFqlmnjrzt4SJHr8ypR2z6jl6oiaAl1AWHY9qtFWrvMk76rlgRNb+sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xRPH8BL/; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d5235d1bcaso177515637b3.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 12:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725998366; x=1726603166; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+/I5yu5GXZLZbi8Yezk0wN06GpM5EScQUnSnfcKR680=;
        b=xRPH8BL/FokU1vcU2fw3YYuYLv7KrGrqL+CqrU+PdI30GYd7d0hIc0ElDAvqT8agd3
         wmjpAUurthPQZDdswIqOOemE6/4wUjUG0Hv/8kQ6xfilG5KhglEkdU8uwCcJ2l8goVPX
         DL6aC0bMnhSQwLi7Lpvg6Sc9ZlKuDJV3ksR0LdNYVXmoZmbLNKMFbgk/D+YA7/Ot5Eyc
         IBkUNG+VX9L975M15X32p9DKuCfSMbw8CN/089W5murXVnlH7TGHApvBlbOEvqlvMXnr
         LROJ+2wJFlXDsqK49X5eVunLQoQT2tsX9ZGxKVbIHl4rHFgcvvAXUUX/DtKDvyH5vdVm
         BOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725998366; x=1726603166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+/I5yu5GXZLZbi8Yezk0wN06GpM5EScQUnSnfcKR680=;
        b=E4GqKZEvIqzm7Sj+8OnZNYY1kEQKkS+Zu7E9UsULW+N7oyF+KbsKGbDFpxFKbC0QaD
         44b0p1XsxmE8mdR8Ci/NRwmJ5A+jCHIGrVS/xHeQMcnJ8dtstZXCrNRsrCNTaUuC0t9W
         rnAF8cMq6xlQEDWPLAwfAOdMX0quCmRktROUL5OwI1xtXkqcbEjRoleySnf+RyPawF4b
         WVRb4uioaub/Sl3OTsveEAq2pEu5m9tpNySjLvgoo7CQloX/5J19l+qKS3/82KHvPcoY
         N2CoOnGWA1pUzwgiWA4nEQYOYCq6kUdKuVn4JtjD+rMBxpw2N1SRv3t5LI4nSAmnfhAx
         +g+g==
X-Forwarded-Encrypted: i=1; AJvYcCWetl4cb4liyWHsiaIKGD5mcWdS3UB1k+Q90kGhaAcvRkjV29DI7KLgyXqJwTV1loP9IL4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRXkSjo7KiljkJQUSCAlQDmMTIN5pmZzDyZwXJuFr7YzuBx36G
	fGklXYQbt6k4szTHjGyyp+LXBFN3BuJEwboZTy3sqfcMX0pWsz4Vx6ai6yGi3OYrQC7d/cBkdhe
	JZA==
X-Google-Smtp-Source: AGHT+IG3eA252S/hkQDQt3UF35eC4bseSdWlEpPLcwdC9CQyLSErJtQ3fXwKL14p5eudAjUWJUQUgzKZPd8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:38c:b0:6af:623c:7694 with SMTP id
 00721157ae682-6db44a5d200mr10392687b3.0.1725998366004; Tue, 10 Sep 2024
 12:59:26 -0700 (PDT)
Date: Tue, 10 Sep 2024 12:59:24 -0700
In-Reply-To: <20240807123531.69677-1-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240807123531.69677-1-amit@kernel.org>
Message-ID: <ZuClHCQJf6JY5gMe@google.com>
Subject: Re: [PATCH v4] KVM: SVM: let alternatives handle the cases when RSB
 filling is required
From: Sean Christopherson <seanjc@google.com>
To: Amit Shah <amit@kernel.org>
Cc: pbonzini@redhat.com, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, amit.shah@amd.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kim.phillips@amd.com, david.kaplan@amd.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 07, 2024, Amit Shah wrote:
> From: Amit Shah <amit.shah@amd.com>
> 
> Remove superfluous RSB filling after a VMEXIT when the CPU already has
> flushed the RSB after a VMEXIT when AutoIBRS is enabled.
> 
> The initial implementation for adding RETPOLINES added an ALTERNATIVES
> implementation for filling the RSB after a VMEXIT in
> 
> commit 117cc7a908c836 ("x86/retpoline: Fill return stack buffer on vmexit")

Nit, no need for 14 digits, 12 is still the "official" recommendation.  To make
this flow better, I would also prefer to not have each commit reference be on
its own line.

> Later, X86_FEATURE_RSB_VMEXIT was added in
> 
> commit 2b129932201673 ("x86/speculation: Add RSB VM Exit protections")

Oh, the irony.  That commit didn't add RSB_VMEXIT, it added RSB_VMEXIT_LITE.
Commit 9756bba28470 ("x86/speculation: Fill RSB on vmexit for IBRS") added the
"heavy" version.  This is also a good opportunity to call out with RSB_VMEXIT
actually does.

> The AutoIBRS (on AMD CPUs) feature implementation added in
> 
> commit e7862eda309ecf ("x86/cpu: Support AMD Automatic IBRS")
> 
> used the already-implemented logic for EIBRS in
> spectre_v2_determine_rsb_fill_type_on_vmexit() -- but did not update the
> code at VMEXIT to act on the mode selected in that function -- resulting
> in VMEXITs continuing to clear the RSB when RETPOLINES are enabled,
> despite the presence of AutoIBRS.
> 
> Signed-off-by: Amit Shah <amit.shah@amd.com>
> 
> ---
> diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
> index a0c8eb37d3e1..69d9825ebdd9 100644
> --- a/arch/x86/kvm/svm/vmenter.S
> +++ b/arch/x86/kvm/svm/vmenter.S
> @@ -209,10 +209,14 @@ SYM_FUNC_START(__svm_vcpu_run)
>  7:	vmload %_ASM_AX
>  8:
>  
> -#ifdef CONFIG_MITIGATION_RETPOLINE
> -	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
> -	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
> -#endif
> +	/*
> +	 * IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET!
> +	 *
> +	 * Unlike VMX, AMD does not have the hardware bug that necessitates
> +	 * RSB_VMEXIT_LITE
> +	 */

I would rather do nothing than carry these comments.  Long term, I would still
prefer to have RSB_VMEXIT_LITE, but that's not a hill worth dying on, and I am
a-ok waiting to deal with that if/when I (or someone else) takes on the task
of unifying the VM-Enter/VM-Exit flows.

So, with the comment changes dropped and the changelog massaged to this:

    Remove superfluous RSB filling after a VMEXIT when the CPU already has
    flushed the RSB after a VMEXIT when AutoIBRS is enabled.
    
    The initial implementation for adding RETPOLINES added an ALTERNATIVES
    implementation for filling the RSB after a VMEXIT in commit 117cc7a908c8
    ("x86/retpoline: Fill return stack buffer on vmexit").
    
    Later, X86_FEATURE_RSB_VMEXIT was added in commit 9756bba28470
    ("x86/speculation: Fill RSB on vmexit for IBRS") to handle stuffing the
    RSB if RETPOLINE=y *or* KERNEL_IBRS=y, i.e. to also stuff the RSB if the
    kernel is configured to do IBRS mitigations on entry/exit.
    
    The AutoIBRS (on AMD) feature implementation added in commit e7862eda309e
    ("x86/cpu: Support AMD Automatic IBRS") used the already-implemented logic
    for EIBRS in spectre_v2_determine_rsb_fill_type_on_vmexit() -- but did not
    update the code at VMEXIT to act on the mode selected in that function --
    resulting in VMEXITs continuing to clear the RSB when RETPOLINES are
    enabled, despite the presence of AutoIBRS.

Applied to kvm-x86 svm.

[1/1] KVM: SVM: let alternatives handle the cases when RSB filling is required
      https://github.com/kvm-x86/linux/commit/4440337af4d4

--
https://github.com/kvm-x86/linux/tree/next


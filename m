Return-Path: <kvm+bounces-61680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86685C24D2D
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 12:45:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9269B3BBAD7
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 11:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A110B346E7B;
	Fri, 31 Oct 2025 11:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JQl3emHF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6E8345CB0
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 11:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761911079; cv=none; b=ciyTmHhzAo8FzANdxF8Pu65xyNB8G8SOc2JI53utNAF0G7ESTDhWtGBUfxNV2P+8sWFRCAR+6eyjPHkP1v6Y3KYL8WLjew+st9JLEq615J03Mbwt3mfzEQPPmr+BV1AM1u7YbRXMbFOp0oLg3uD2UmRz6Z5sme+pn228fmtdMb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761911079; c=relaxed/simple;
	bh=1ziLgSIkrp0a6AmlIEBk33I+PNnB6tRTqq43dI1gfd4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HgN9/Z5JXSCa+oOxvg7jIDhX2C5DwfDYeu78/DIOjZ2sOL1GNNKAJGlUQDiDOqmU9D+V3/nrOkEXgDSa/HLkQJMebAVJKFZjZRmUnFQleb+pOCUcGNcoH1A8jqDqT8zuUxW9gLaa7NirSAC3LtxnqkeOuRfGrXzwmfbMQzZcFuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JQl3emHF; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47113538d8cso11121465e9.1
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 04:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761911076; x=1762515876; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sI9GGke3gGadVIlamH57BbMeWwa+Ka12HvCc9u9b0lQ=;
        b=JQl3emHF5KL2WvimvAW7QWlSelGHSM8uwJ2AMOoxsbgnMi5f4QgkkfuXP/b4yonkwR
         DvMPDvsREoJYMnO3rB8KUN0niAxe2Wrulfab7UdVxQAGTtiDjnrR8JTrL56xGLXdN3V4
         ifqsw3w67YKac96slu78/If6PcoURPb1HxmSQtqGc+1pk0LfxHIgOtfChhKYjyDhf23k
         TFJPyKdNkCReBNZRSAaEOl4N2oxwaBp+OwcUq06qzs4Iw2tbqw9F4HtbJvs2AxEF35Oh
         MS0tByH2AOhM8h1A9XIg8vweCroveq73kTtD1lD1FyKcj2awNCzcce6+rQTuAc/HtwPW
         Fe6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761911076; x=1762515876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sI9GGke3gGadVIlamH57BbMeWwa+Ka12HvCc9u9b0lQ=;
        b=OtBTnHaRFWy7uUxZ+cS7ue15AFgFEZNsjT7ShQqXikMyXFjcEp60McNUoRF2j3PEUx
         e9RlQKY3bhx2bk4uIL5Sxg1JbdgZA5yCcPWwkJsO5jAJ1TE6UeeINSvChr1q3stz/hIz
         J3d4VGei0Sl4e+rsnEpxuZuYpZxIT6//p0l1cIAFoaVDryHcAZkViOH7wnUuNmJehrTH
         9MRbiCte5btSL5tkfWckkRT0ytl6Cy6Lf7EiqxDaE7Yi6Yc0r+fsVZzxn14u6KjnrkSN
         JBqSNaw5lvbhBzWGks8E2BkpeUG1USlDDg7IuC3Wicdv819LdR90Zw0/1PO00AVglmFE
         5adQ==
X-Gm-Message-State: AOJu0YymcpBhm30bO7iZ67NPSjA2xOt7ExD+382cb5cVEqVXHu/h05GZ
	DAgurdcic6u1GkPrh9w3npASZxDAve9kcuBUxGlhmI/Wz92Jil+TvcrVcKEQY0NiF3tBXwiCKqz
	NgvIXiZ/y4vkxfA==
X-Google-Smtp-Source: AGHT+IEKamMZcdzktkM4szUvZ/YKxOvtrM+iKDRRu3XsTBqM5qLLJOr1Cmw34NbBirHIxm9Qj3Kdpxe2bePlBg==
X-Received: from wmlm20.prod.google.com ([2002:a7b:ca54:0:b0:475:d8ff:6aae])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5304:b0:475:dd04:128a with SMTP id 5b1f17b1804b1-477308c0182mr32166645e9.31.1761911076666;
 Fri, 31 Oct 2025 04:44:36 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:44:36 +0000
In-Reply-To: <20251031003040.3491385-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <20251031003040.3491385-4-seanjc@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDWHCMBU8GVB.1CXGUGVWSF8RD@google.com>
Subject: Re: [PATCH v4 3/8] x86/bugs: Use an X86_FEATURE_xxx flag for the MMIO
 Stale Data mitigation
From: Brendan Jackman <jackmanb@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri Oct 31, 2025 at 12:30 AM UTC, Sean Christopherson wrote:
> Convert the MMIO Stale Data mitigation flag from a static branch into an
> X86_FEATURE_xxx so that it can be used via ALTERNATIVE_2 in KVM.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/cpufeatures.h   |  1 +
>  arch/x86/include/asm/nospec-branch.h |  2 --
>  arch/x86/kernel/cpu/bugs.c           | 11 +----------
>  arch/x86/kvm/mmu/spte.c              |  2 +-
>  arch/x86/kvm/vmx/vmx.c               |  4 ++--
>  5 files changed, 5 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 7129eb44adad..d1d7b5ec6425 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -501,6 +501,7 @@
>  #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
>  #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
>  #define X86_FEATURE_X2AVIC_EXT		(21*32+17) /* AMD SVM x2AVIC support for 4k vCPUs */
> +#define X86_FEATURE_CLEAR_CPU_BUF_MMIO	(21*32+18) /* Clear CPU buffers using VERW before VMRUN, iff the vCPU can access host MMIO*/
>  
>  /*
>   * BUG word(s)
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index 923ae21cbef1..b29df45b1edb 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -579,8 +579,6 @@ DECLARE_STATIC_KEY_FALSE(cpu_buf_idle_clear);
>  
>  DECLARE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
>  
> -DECLARE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
> -
>  extern u16 x86_verw_sel;
>  
>  #include <asm/segment.h>
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 723666a1357e..9acf6343b0ac 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -192,14 +192,6 @@ EXPORT_SYMBOL_GPL(cpu_buf_idle_clear);
>   */
>  DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
>  
> -/*
> - * Controls CPU Fill buffer clear before VMenter. This is a subset of
> - * X86_FEATURE_CLEAR_CPU_BUF_VM, and should only be enabled when KVM-only
> - * mitigation is required.
> - */

This comment wasn't super clear IMO but now that we're losing it, maybe
we can replace it with a WARN_ON() at the end of
cpu_apply_mitigations() or something (maybe it belongs in VMX code)? To
make it more obvious that X86_FEATURE_CLEAR_CPU_BUF_VM and
X86_FEATURE_CLEAR_CPU_BUF_MMIO are mutually exclusive.

Other than the continued bikeshedding,

Reviewed-by: Brendan Jackman <jackmanb@google.com>


Return-Path: <kvm+bounces-72430-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Mi8MkkTpmnlJgAAu9opvQ
	(envelope-from <kvm+bounces-72430-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:46:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 46CF91E5E36
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:46:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 050B53036E90
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 22:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41FC32D592C;
	Mon,  2 Mar 2026 22:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MuWqXkry"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7683F1F4176
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 22:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772491580; cv=none; b=b3Mb4FKCQJkla/n7jAmQVKr8qr+U8CVCiBdLCSFlasryRVGSxDDHcr3ruBpJS/jRpBGm5Ocx5ibWzrmbV2NLOh+nhMlyHWIk/SXAFYK7eOvwuUEt1NLFZ45gX5V0i0EPCAGu0ZlWaRraQepMNIqRuzzYCnie+ve+lw3XwxEYRzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772491580; c=relaxed/simple;
	bh=vRUnFk/4YjqA8aVK6C5vOSkumDpwteYY9GhbEfoN7Ds=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gh33nX6pjRuovySydC7f6OVb/r/Zrt4GKbY+2h8lTNh5Bi+mytQdgAHFpizHjARFt4EP0K65Fn184E9I86dxZ2VpvQh8RJ2KtgO7wsL4/duep3SeVyd1WQjdCjW7106AnizwfRqKfEl5qUG1XuUgJHyAEF3ZGFkargO82i5z01Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MuWqXkry; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae53ec06b0so52782535ad.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 14:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772491579; x=1773096379; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2gsF250ql7Atn/IIODygSV13jGj0UvlZEzVcGG6p2FA=;
        b=MuWqXkryK8214d0Heur23U7Ib6JWKToo++syOTg7iVx9rADgwFmEEg2LSSDiOy8+kS
         gPYUgf6DVAMsgB6OXrVBChrTjAIoz3ObBUZeuclGZWGPyBjzjRY91ZyoNMWURuSD8O87
         Gxcd34tZuLOhd9NdwnX/boXfJyuEJvvC1Ocr1rM6RydN9Ji2CZv2NsB9/bMSQv8H5oHA
         vyuqpAG4szEagd7nUk7U0WaRXLMd4kkOJhM4+E9aC46Pdi1ldpILlkIrpQjGooKQrXuN
         36HNZs1Di6ZQN0aU3AuEtGSNekiH7KUY854zew1L17grkG3D0jyBPvk2WPX+W3RMgeer
         EDxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772491579; x=1773096379;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2gsF250ql7Atn/IIODygSV13jGj0UvlZEzVcGG6p2FA=;
        b=oXZhbUIhPuS2j5KB6kO433NeuzGiJgQlH1b9S7fIHY3ZUI0eMmDpybjCWISbcwrCq2
         iv72yiY9zCzuHXuOJCsT45GpxcBJ0OCV395C3ZQn3783itFibxZyO/Chq6r+TxCmV83H
         1MVTP25Rr1KlzJmxFJiQn+sk6UsQENKgQ/LCFzzEIOO+4zS731gJ4kmRmJJs77pmiP91
         aj2NB6btf317poDcjueik70uHjJ3RvsOD4fHaAUCMtKyFbuJF6Hj57LgRToDIYDKnAn+
         57xtPSVS0HzjTq9md0M8/lMkDBFXz+nHP1ldAEi595XaYbq/CF19eyGumBkX9aSr5+Nt
         VQQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzOR9e8TfdVYdTwJZMLgVoyRhytzIuimcyh/hMXog9+Iu5yOosIF2RK4ub1M5bqKFUTTk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy07u6/D5OSmiPlKFf5KA9FAWJE+z0slM4GCC0NXGuIZcNUal9d
	j9ed+E1SjTiPoNlQ71H2s/679r3jWCx/yhbb6nbc1fXSlB0Ow6Tt81+U8+QX7A3w8kChUCLs1yM
	8YJ0b9g==
X-Received: from ploc3.prod.google.com ([2002:a17:902:8483:b0:29f:25cf:e576])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc87:b0:2ae:5104:571e
 with SMTP id d9443c01a7336-2ae510458f2mr41552335ad.9.1772491578542; Mon, 02
 Mar 2026 14:46:18 -0800 (PST)
Date: Mon, 2 Mar 2026 14:46:17 -0800
In-Reply-To: <20260210234613.1383279-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260210234613.1383279-1-jmattson@google.com>
Message-ID: <aaYTOXlgX-cnkvoy@google.com>
Subject: Re: [PATCH] KVM: x86: Ignore cpuid faulting in SMM
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jamie Liu <jamieliu@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 46CF91E5E36
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72430-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Feb 10, 2026, Jim Mattson wrote:
> The Intel Virtualization Technology FlexMigration Application Note says,
> "When CPUID faulting is enabled, all executions of the CPUID instruction
> outside system-management mode (SMM) cause a general-protection exception
> (#GP(0)) if the current privilege level (CPL) is greater than 0."
> 
> Always allow the execution of CPUID in SMM.
> 
> Fixes: db2336a80489 ("KVM: x86: virtualize cpuid faulting")

I feel like we need a Technically-fixes-but-really-just-a-bad-spec tag for things
like this.  MISC_ENABLES and MSR_K7_HWCR in particular are a bizarre game of
"Hold my beer!".

> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c   | 3 ++-
>  arch/x86/kvm/emulate.c | 6 +++---
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 7fe4e58a6ebf..863ce81023e9 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -2157,7 +2157,8 @@ int kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	u32 eax, ebx, ecx, edx;
>  
> -	if (cpuid_fault_enabled(vcpu) && !kvm_require_cpl(vcpu, 0))
> +	if (!is_smm(vcpu) && cpuid_fault_enabled(vcpu) &&
> +	    !kvm_require_cpl(vcpu, 0))
>  		return 1;
>  
>  	eax = kvm_rax_read(vcpu);
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index c8e292e9a24d..4b7289a82bf8 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3583,10 +3583,10 @@ static int em_cpuid(struct x86_emulate_ctxt *ctxt)
>  	u64 msr = 0;
>  
>  	ctxt->ops->get_msr(ctxt, MSR_MISC_FEATURES_ENABLES, &msr);
> -	if (msr & MSR_MISC_FEATURES_ENABLES_CPUID_FAULT &&
> -	    ctxt->ops->cpl(ctxt)) {
> +	if (!ctxt->ops->is_smm(ctxt) &&
> +	    (msr & MSR_MISC_FEATURES_ENABLES_CPUID_FAULT &&
> +	     ctxt->ops->cpl(ctxt)))

I assume you intended the parentheses to wrap the bitwise-AND.  I'll fixup to
this when applying.

	if (!ctxt->ops->is_smm(ctxt) &&
	    (msr & MSR_MISC_FEATURES_ENABLES_CPUID_FAULT) &&
	    ctxt->ops->cpl(ctxt))


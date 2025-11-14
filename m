Return-Path: <kvm+bounces-63254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CB7CFC5F446
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:46:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7AA5634DF3E
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E552FABE7;
	Fri, 14 Nov 2025 20:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wlt+ye3E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767D826FD9A
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153210; cv=none; b=r2+c6Opf6l6j16E3OT7qmBqgHmrE1eCErRum8hsF4ZHDNCqotrqUoejd/QKNUx1gRLcYB18UfCNVO07tEqlKHXlqad2bKuWebaeNpaet6e46fgP5NpguPgh2oFD/hIFnQqKIbvSf7niq8pGa1gnFvvyovVzCHid5UsKuVO1jA58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153210; c=relaxed/simple;
	bh=dfYx47d/ipGR2oWtZ/TvRaAmjrloUIS22pGR+l33fvQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vfq9DtqUTkXj6gCwVsFoQ1JvaJr04mR3EBArrvEVSdCTP3uVbvTt2BtK9rz5ty9qa59D3fvvEU8R+PLHm7R/wGIhuEhhhyxYQ2bvWlluGIBgFzWvpLeTqedWYncpNj6hAkl0tqfRf2aU4BAMM3xQfwP4xAPKtHX9loqELInMa5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wlt+ye3E; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b849837305so1792046b3a.0
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153209; x=1763758009; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OThgu7e60vX+NtlrxIN2GNEyI0Z437I9e5LP4XWE8zQ=;
        b=wlt+ye3EH31QkUATD3iyvizUPRKGjuDaWMyWgE2yGzXrRqThtvAlbT2SmkSVJEyjfT
         oLRMNVeMrPm/bWs3yJRbNi6sQqDn0UVnpVbXFCGrFJgAjJgTASjavO+qfOquYUBWPP8o
         0c7mM/gPWwYaDwyauYE+sMG+I9Sk5+wykkByyaWKPy7+KNTPr78zPt39vHnsfXP+G2US
         mnp5QGhYFYWK3NSz9XrwugtFRRI1YLdPwKjgZjtfM+6Y5P5akr8GqC/XAiGuA08w/QTq
         Ep4vi5JKBljSR7NR5wxvBc4TmxKZEcXAo40evgL4VuHniBSgVWIP/K6/pI0P/9t7Auxf
         0M5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153209; x=1763758009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OThgu7e60vX+NtlrxIN2GNEyI0Z437I9e5LP4XWE8zQ=;
        b=gKuKudbKhcYynUYUynKkAeU3CAz52hpSMI+BsiaMtSp4AouQKqIbDQmSGxceYOgv5/
         XVGdyR/kOtmwkPUkDPixPmfzfrdDcTaufXgPYDDk0jIlvSg/23Lz8zjmPKmd8T0j0KwQ
         htr39NHQa9z9F4r0cl8gnu/c5rQKAhKVzRs9ZeypaHa3R161XSF2bOlfnYDjElXsHegC
         4IicR7IUKWaE1BfT8ROMZnuWBIhyqoo6LcntN/4mYKVD1wFzfW9JN+xxrRZuriI0j9xN
         XIZ5zA3LJUu/8Co1Mdy5o7eyzr+RfwAiEDMWVu/RfQad5LliOXio/jUwriWzY4bN+gAe
         q0Tg==
X-Gm-Message-State: AOJu0YzXrbdMDxhe7cRaeF7FeOOm/cGt3iCKipYhppXP4ddEdtNVnxM5
	zVsxXYUb8A7cIZjR2rAAa/7WxU+sh+V2MjwzI5JffETYXzCOVoC0Tt17uNPcKj/UPMKziHMk9jk
	dpY7Rfw==
X-Google-Smtp-Source: AGHT+IH0uuUBeHfU976U7yclqa8BVzdqD1ZxOdEDh4a82wLAfbZLEM0+UvKRyZJ4iR7scWkLkIn/gsVVcQw=
X-Received: from pfbhk2.prod.google.com ([2002:a05:6a00:8782:b0:77f:33ea:96e9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3a0d:b0:7b8:e83:1de4
 with SMTP id d2e1a72fcca58-7ba3a0bd2eemr5145540b3a.9.1763153208655; Fri, 14
 Nov 2025 12:46:48 -0800 (PST)
Date: Fri, 14 Nov 2025 12:46:47 -0800
In-Reply-To: <dbe12f67-79d0-4d92-b510-56f32401e330@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com> <20251114001258.1717007-2-seanjc@google.com>
 <dbe12f67-79d0-4d92-b510-56f32401e330@grsecurity.net>
Message-ID: <aReVN65Tgaanqd_l@google.com>
Subject: Re: [kvm-unit-tests PATCH v3 01/17] x86/run_in_user: Add an "end
 branch" marker on the user_mode destination
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 14, 2025, Mathias Krause wrote:
> On 14.11.25 01:12, Sean Christopherson wrote:
> > Add an endbr64 at the user_mode "entry point" so that run_in_user() can be
> > used when CET's Indirect Branch Tracking is enabled.
> 
> I don't think that's needed, as 'user_mode' is branched to via IRETQ and
> that isn't covered by IBT -- nor is any other RET instruction.
> 
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  lib/x86/usermode.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
> > index c3ec0ad7..f4ba0af4 100644
> > --- a/lib/x86/usermode.c
> > +++ b/lib/x86/usermode.c
> > @@ -68,6 +68,9 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
> >  			"iretq\n"
> >  
> >  			"user_mode:\n\t"
> > +#ifdef __x86_64__
> > +			"endbr64\n\t"
> > +#endif
> 
> The thing is, this ENDBR64 is actually masking a missing cleanup step in
> the IBT tests. The first failing IBT test will make the CET_U IBT
> tracker state get stuck in the WAIT_FOR_ENDBRANCH state. This means,
> every time we return to userland (and thereby implicitly switching to
> the CET_U state again), it wants to see an ENDBR64 first or it will
> directly trigger a #CP(3) again. This ENDBR64 will please that demand
> and make it transition to IDLE and allow executing the test. However,
> it's really the old test that should have fixed the tracker state and
> not a blanket ENDBR64 when entering usermode.
> 
> Attached is a patch on top of [1] that does that but is, admitted, a
> little hacky and evolved. However, it shows that above ENDBR64 is, in
> fact, not needed.

You say hacky, I say clever and correct. :-)

> diff --git a/x86/cet.c b/x86/cet.c
> index 801d8da6e929..bcf1ca6d740a 100644
> --- a/x86/cet.c
> +++ b/x86/cet.c
> @@ -1,4 +1,3 @@
> -
>  #include "libcflat.h"
>  #include "x86/desc.h"
>  #include "x86/processor.h"
> @@ -192,6 +191,10 @@ static uint64_t cet_ibt_emulation(void)
>  #define CET_ENABLE_SHSTK	BIT(0)
>  #define CET_ENABLE_IBT		BIT(2)
>  #define CET_ENABLE_NOTRACK	BIT(4)
> +#define CET_IBT_SUPPRESS	BIT(10)
> +#define CET_IBT_TRACKER_STATE	BIT(11)
> +#define     IBT_TRACKER_IDLE			0
> +#define     IBT_TRACKER_WAIT_FOR_ENDBRANCH	BIT(11)

For this, I think it makes sense to diverge slightly from the SDM and just do

  #define CET_IBT_TRACKER_WAIT_FOR_ENDBRANCH	BIT(11)

because...

>  static void test_shstk(void)
>  {
> @@ -244,6 +247,22 @@ static void test_shstk(void)
>  	report(vector == GP_VECTOR, "MSR_IA32_PL3_SSP alignment test.");
>  }
>  
> +static void ibt_tracker_fixup(struct ex_regs *regs)
> +{
> +	u64 cet_u = rdmsr(MSR_IA32_U_CET);
> +
> +	/*
> +	 * Switch the IBT tracker state to IDLE to have a clean state for
> +	 * following tests.
> +	 */
> +	if ((cet_u & CET_IBT_TRACKER_STATE) == IBT_TRACKER_WAIT_FOR_ENDBRANCH) {
> +		cet_u &= ~IBT_TRACKER_WAIT_FOR_ENDBRANCH;

...this is quite weird/confusing.  It relies on CET_IBT_TRACKER_STATE being a
single bit, and "(x & y) == z)" is very un-idiomatic for a single bit.

> +		printf("CET: suppressing IBT WAIT_FOR_ENDBRANCH state at RIP: %lx\n",
> +		       regs->rip);
> +		wrmsr(MSR_IA32_U_CET, cet_u);
> +	}
> +}


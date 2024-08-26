Return-Path: <kvm+bounces-25102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2576595FC27
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 23:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49DB81C22445
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 21:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3F6719D074;
	Mon, 26 Aug 2024 21:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sU2iZ5aD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8B8199392
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 21:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724709147; cv=none; b=UrgJ9XJ+F2PoujAQHhuQ10yjwJhGFim/u849AnJ/2m4zg7hesYr4hlx8s1A1bzOUy+jDnWSQyu3y3N1q4kK+iOpngIV2nf8gjRSdta167d0cJJCU7SvIu/Js57OZA8Kp9/n1o3bbym8U7yLs1fkWxuQ53v8pQhDHBg6Fqv5yfwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724709147; c=relaxed/simple;
	bh=clkIC11LEfRUogh7/iQfcvBJKcILbTGFZELo7tbP9u0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dbfWBQmWANlW3jp2NaQcy5AjT/5cxbcGASHK1e9JoYmFJ7rNGRdV8I44XJmwoig7ugNypT47qbzfeHCPSM3/Q7CndBcBCqXDvAu5bc66o2DLvX7ZIveovvxnqDjto40UsQjTnDT3pW/9CfdWQwJhcv6FWYzsorkrPZ0jCuhHFS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sU2iZ5aD; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7143d76d29fso3841759b3a.3
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 14:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724709144; x=1725313944; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IOXjacHH12PA9mjnU5h3pCGXV3TjaEslg0P5RM9tkQk=;
        b=sU2iZ5aDEOHRR3HIPR3577o1r10ok9qN5MMOAozGUo2d8/IUVWd3cOOHEbYuA9/Gfv
         DW+Zgy+LpnCK9BfABeb8sRZsUV1Xu9zG6kzC08zy1mAc5TXQD3qtEuway+jJeewxXiDS
         cfHyNj1UDRbfEp5OdACU5H6vKJ7frUCaTKpB2PSiWG9ApWU03zXg9DUx/JURsGcAhX/j
         O5rlUOUSZDijADiRB9/lssFCuZqEIZVuRChREFBXvP4af1MXX9lsetDPEgNWdpbBiknZ
         xDuDNGZ8VOxr+6mQX7r3c2IjvTnc9/EjFSCTWkYYsUVJUt7GZb53yjEuVavJwIQn5bYi
         GBOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724709144; x=1725313944;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IOXjacHH12PA9mjnU5h3pCGXV3TjaEslg0P5RM9tkQk=;
        b=HuGhXXMOdtaSe4oU/tdNMAi53nxamIbeAl2WbEh/05U/03+dJZevIiD/54NHQ/8FxQ
         B0Zuk+rdIWy5M3Neokzyf1+kfDNAwOzII8IbKZWAd2lrYGsUv7vKiapX46FZK5oRuE3q
         YZnCm1FVfFpb69/wBbBv7zer93htytuLb34FEn4gaw7lzwrirrl3G2wWQn1wP9Yr220o
         sO7+BibHsxD3NmLyzI6ear8FcRudzKngCgNnerAxmudf6HNzi4SHN22GKZp4sFUhJMfw
         4E6zhE9CfGCrMpEo23eYRYycR4w7HaOKxobClKlVNe1Ekt5rnb1ZCmXVzHuy4uS/A6tE
         84QQ==
X-Gm-Message-State: AOJu0YzAfz6nTdy9u4aOZAi2vbM2M6mXwUe9MvFc+H7ocpUwK/3sJa29
	IZhyEQmOQcANFX2+a1BHDdjy1kdRJHBJq7uaAsuTHwmYBfWT1QkmzZUhh3M/wQTOS726NfoxvfY
	JFQ==
X-Google-Smtp-Source: AGHT+IHnY9bsvf3HDj+Czwk3K/62fc3xk6tEUECZIUZQdup+bZCUVT0jjuwTaJiDsMVK4zFWj1+T3yk9oCk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:804b:0:b0:710:4d08:e41f with SMTP id
 d2e1a72fcca58-7144595af02mr31438b3a.4.1724709143503; Mon, 26 Aug 2024
 14:52:23 -0700 (PDT)
Date: Mon, 26 Aug 2024 14:52:22 -0700
In-Reply-To: <41d307b3-78d9-4be1-80f0-9a9652e7ee37@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com> <20240809190319.1710470-16-seanjc@google.com>
 <41d307b3-78d9-4be1-80f0-9a9652e7ee37@redhat.com>
Message-ID: <Zsz5Furdqs2ys1Ps@google.com>
Subject: Re: [PATCH 15/22] KVM: x86/mmu: Move event re-injection
 unprotect+retry into common path
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 14, 2024, Paolo Bonzini wrote:
> On 8/9/24 21:03, Sean Christopherson wrote:
> > @@ -6037,8 +6018,15 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >   	 * execute the instruction.  If no shadow pages were zapped, then the
> >   	 * write-fault is due to something else entirely, i.e. KVM needs to
> >   	 * emulate, as resuming the guest will put it into an infinite loop.
> > +	 *
> > +	 * For indirect MMUs, i.e. if KVM is shadowing the current MMU, try to
> > +	 * unprotect the gfn and retry if an event is awaiting reinjection.  If
> > +	 * KVM emulates multiple instructions before completing even injection,
> > +	 * the event could be delayed beyond what is architecturally allowed,
> > +	 * e.g. KVM could inject an IRQ after the TPR has been raised.
> 
> This paragraph should go before the description of
> kvm_mmu_unprotect_gfn_and_retry:

Hmm, I disagree.  The comment ends up being disconnected from the code, especially
by the end of the series.  E.g. when reading kvm_mmu_write_protect_fault(), someone
would have to jump twice (to kvm_mmu_unprotect_gfn_and_retry and then
__kvm_mmu_unprotect_gfn_and_retry()) in order to understand the checks buried
in kvm_mmu_write_protect_fault().

And the comment also becomes stale when kvm_mmu_unprotect_gfn_and_retry() is
used by x86_emulate_instruction().  That's obviously solvable by extending the
function comment, but then we end up with a rather massive function comment that
documents its callers, not the function itself.

> 
> 	 * There are two cases in which we try to unprotect the page here
> 	 * preemptively, i.e. zap any shadow pages, before emulating the
> 	 * instruction.
> 	 *
> 	 * First, the access may be due to L1 accessing nested NPT/EPT entries
> 	 * used for L2, i.e. if the gfn being written is for gPTEs that KVM is
> 	 * shadowing and has write-protected.  In this case, because AMD CPUs
> 	 * walk nested page table using a write operation, walking NPT entries
> 	 * in L1 can trigger write faults even when L1 isn't modifying PTEs.
> 	 * KVM would then emulate an excessive number of L1 instructions
> 	 * without triggering KVM's write-flooding detection, i.e. without
> 	 * unprotecting the gfn.  This is detected as a RO violation while
> 	 * translating the guest page when the current MMU is direct.
> 	 *
> 	 * Second, for indirect MMUs, i.e. if KVM is shadowing the current MMU,
> 	 * unprotect the gfn and reenter the guest if an event is awaiting
> 	 * reinjection.  If KVM emulates multiple instructions before completing
> 	 * event injection, the event could be delayed beyond what is
> 	 * architecturally allowed, e.g. KVM could inject an IRQ after the
> 	 * TPR has been raised.
> 	 *
> 	 * In both cases, if one or more shadow pages were zapped, skip
> 	 * emulation and resume L1 to let it natively execute the instruction.
> 	 * If no shadow pages were zapped, then the write-fault is due to
> 	 * something else entirely and KVM needs to emulate, as resuming
> 	 * the guest will put it into an infinite loop.
> 
> Thanks,
> 
> Paolo
> 
> >   	 */
> > -	if (direct && (is_write_to_guest_page_table(error_code)) &&
> > +	if (((direct && is_write_to_guest_page_table(error_code)) ||
> > +	     (!direct && kvm_event_needs_reinjection(vcpu))) &&
> >   	    kvm_mmu_unprotect_gfn_and_retry(vcpu, cr2_or_gpa))
> >   		return RET_PF_FIXED;
> 


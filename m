Return-Path: <kvm+bounces-24265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5912B9532EC
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:12:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9B4CB23709
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 14:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF2401A01D4;
	Thu, 15 Aug 2024 14:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HWMotfgD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5ED1AD41F
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 14:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730948; cv=none; b=nYjbBCtkk4sxptrWnXMm7W11CnuUgQ0V448xmxjBB7KvruJNI/lmNJIZTHobfNP8yA9wH5LHrVrX+ohF7QdygASL1gkae++esDdimDDs/aVZCPj4/SA9SOYlKKKO2vCLelFjx1u7dafYODZtAfTmiokF6WeUTofJxM3oTy221cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730948; c=relaxed/simple;
	bh=qo9ZE4dFQ6mM/Bc850JYi0KMklchFhxHbwhodm8U5P8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m84FDEvJZxnfM0uXUaXd8J5NHndMp9/DzSS+xQWXvEV3YSKkUFS03KfbjTkAlqCl2P8lu9PidWI0Jaid2g+6CXah8NioOtFCKMHI8AGooM8bKQPy2Q6Ne4Ip7AC1jDcEE/J02AB2SpDMut5ljev2FYvEdpNg6TZV5rEroKIsKoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HWMotfgD; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0b3742b309so1498470276.1
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 07:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723730945; x=1724335745; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qIvQlh/LEmcc/D/obNuZ6E+YY/ClqP2nQTGGm+92/XA=;
        b=HWMotfgDUfdZSYw8ZSXij6R9WdNMMsZ2E+HJc6307o4WXfBFy+834Bx3LYyDiMQjsf
         Lesj5wm9Uj6kKEDoZfUTL/4Pf9onA+KqhU1IS+OaS7W4tgiitSppFfub0jEiMS3feSig
         n7Sw39mWzCawqcZCR3h2zISm5Lp/JYKq/Lqd+vrXTfb7rQiItuQNBNPBbr2dUtbyCIIH
         o8GeMlDlr+/IQSmOQtqzhzZuT9r/dmcIVfY3gMg4a2cXIFv9Ytv9vlysNcX4Q9QEBy49
         1A1ppUw8CgpGCGzR3S7hD6NXOCLq6gmth89M7elHCD7WMgnEzwvC46XRY+H64InOiBEU
         jB4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723730945; x=1724335745;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qIvQlh/LEmcc/D/obNuZ6E+YY/ClqP2nQTGGm+92/XA=;
        b=PZ0Jc6NYEUPDa6tr1uMLBsNtTTpA8LBG4NAxzArxNCOFskX3DiU6jWmoS5LV0Gndhj
         KANphoHKQwG5E3CzzK6PvqBVPCjaXnrXrhgCnkqb7Tegu0/FQkXinr993q4J4CzHPVd9
         wcrc2LxcCtuSdkEVOZGJ4oB/FHzcFRMgSurEhcTdVhEotuc9r819z5jZw9g15iqguf8b
         ysiCaum2XgQMp/qqxx7CmosPO2S8t7EnZaFGPmdfWmHKXMOwQ+jTRCRP17atU5r5b7n1
         X/5mmoIq0iDGc5jjcAhzn6x4ZB68+Oy1VX/0BokkM7awP4Wg44ke+JZ+4S17W09H5X9H
         7M+w==
X-Gm-Message-State: AOJu0Yz1WnJbGIWGxp7ndXa42Tuh4reVHMU7uIzHfplwwYya5ajbWIFA
	Ns5riBQKfuNdYNDx99HR94mk0sjWta3c5q7mcYMMaQL5fHjw2hAXpiefc1omy6XemFD+M3Yh6ml
	h2w==
X-Google-Smtp-Source: AGHT+IF6xQQzYTHNueQz5cB9KMs+14iCDwXd48e2Sh7vGWOyT8D00eLV92GkWwL3v1SLnd0khMovT1/aszU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2783:0:b0:e05:eccb:95dc with SMTP id
 3f1490d57ef6-e1155aa6f02mr27854276.6.1723730945293; Thu, 15 Aug 2024 07:09:05
 -0700 (PDT)
Date: Thu, 15 Aug 2024 07:09:03 -0700
In-Reply-To: <e50240f9-a476-4ace-86aa-f2fd33fbe320@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com> <20240809190319.1710470-10-seanjc@google.com>
 <e50240f9-a476-4ace-86aa-f2fd33fbe320@redhat.com>
Message-ID: <Zr4L_4dzZl-qa3xu@google.com>
Subject: Re: [PATCH 09/22] KVM: x86/mmu: Try "unprotect for retry" iff there
 are indirect SPs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 14, 2024, Paolo Bonzini wrote:
> On 8/9/24 21:03, Sean Christopherson wrote:
> > Try to unprotect shadow pages if and only if indirect_shadow_pages is non-
> > zero, i.e. iff there is at least one protected such shadow page.  Pre-
> > checking indirect_shadow_pages avoids taking mmu_lock for write when the
> > gfn is write-protected by a third party, i.e. not for KVM shadow paging,
> > and in the *extremely* unlikely case that a different task has already
> > unprotected the last shadow page.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/mmu/mmu.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 09a42dc1fe5a..358294889baa 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2736,6 +2736,9 @@ bool kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa)
> >   	gpa_t gpa = cr2_or_gpa;
> >   	bool r;
> > +	if (!vcpu->kvm->arch.indirect_shadow_pages)
> > +		return false;
> 
> indirect_shadow_pages is accessed without a lock, so here please add a note
> that, while it may be stale, a false negative will only cause KVM to skip
> the "unprotect and retry" optimization.

Correct, I'll add a comment.

> (This is preexisting in reexecute_instruction() and goes away in patch 18, if
> I'm pre-reading that part of the series correctly).
> 
> Bonus points for opportunistically adding a READ_ONCE() here and in
> kvm_mmu_track_write().

Hmm, right, this one should have a READ_ONCE(), but I don't see any reason to
add one in kvm_mmu_track_write().  If the compiler was crazy and generate multiple
loads between the smp_mb() and write_lock(), _and_ the value transitioned from
1->0, reading '0' on the second go is totally fine because it means the last
shadow page was zapped.  Amusingly, it'd actually be "better" in that it would
avoid unnecessary taking mmu_lock.

Practically speaking, the compiler would have to be broken to generate multiple
loads in the 0->1 case, as that would mean the generated code loaded the value
but ignored the result.  But even if that were to happen, a final read of '1' is
again a-ok.

This code is different because a READ_ONCE() would ensure that indirect_shadow_pages
isn't reloaded for every check.  Though that too would be functionally ok, just
weird.

Obviously the READ_ONCE() would be harmless, but IMO it would be more confusing
than helpful, e.g. would beg the question of why kvm_vcpu_exit_request() doesn't
wrap vcpu->mode with READ_ONCE().  Heh, though arguably vcpu->mode should be
wrapped with READ_ONCE() since it's a helper and could be called multiple times
without any code in between that would guarantee a reload.


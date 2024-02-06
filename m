Return-Path: <kvm+bounces-8126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7471484BCE0
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:24:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5AC0CB24A29
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 18:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6168134A8;
	Tue,  6 Feb 2024 18:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AQU9tmvR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA75012E6D
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 18:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707243879; cv=none; b=C0iFrb1KANMjGGx7I7LfAC8T6c+AgQql3nCiHEvx5UakBjrVSZAP/8M+Dw7I3L5SIb4+ji2aV8bVF2rY5ZTRk1czftcxncI1Tu5SkHYOtotL3x1fMSuIGRf0k6fseNXf+mKi5KTQWuHDko7bq+0W/PIYCtcVFRkrjk4oExtz5C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707243879; c=relaxed/simple;
	bh=3XRkBdQfwW4w64dMyBhf0pLPvTaX2Rh9tYurk60kiRY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qZ+yBFbP7M7K+Lln1K38eav4k2wIaHI2mnT4NNbRTd8Lrp3rLZa65SKBZ6eZo01TLAax0/wYvc6n5a2DUtyBP61L5vf4HtthTAxaC089PEtsN/xs/C/80D21ATsGkIZvdfanLbKE6zYh6YXTlkFXGwW3aQ0OFtYX2fFTgzdhcPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AQU9tmvR; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6040ffa60ddso118581147b3.2
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 10:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707243875; x=1707848675; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UHpFGN7bZpvSRKW2Mb0WAZadQ59xIOL/eJg6s/rvYcQ=;
        b=AQU9tmvR9GTyxeKjNJ0GeEmY2aYI11OUhKamgHj/5HHsg4w9FmnHlFGa009G77j/YF
         ivEGMnLu9j41917l2abNey1x2QBwI+8kO85PtfV55luaZz61Gt9r2stQOZaclEZbUyH8
         ZxD35YPrrYvQuWwjeIRTK7k22SA8PmyxU/on1SjI5InOtCklnoAWdUeRhB+aSUR6Rfva
         cG3CmcgSgSkimDkAUfb1xvZCsTbaarfNgwI738mcmVBM5Um6bZUTNUpdRFAYlw03HhfO
         i+pKNSM8ofMVlrYIg4MHU171y9/Zv/jEX+mj8ENkN7u7L7Hca+SCtoCoFdyDdguyP3Gy
         W8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707243875; x=1707848675;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UHpFGN7bZpvSRKW2Mb0WAZadQ59xIOL/eJg6s/rvYcQ=;
        b=ZRDtXXe6Iiy1aeTJIXBVRdO8rml/kusQJmGqrmlzalM/aTQSV+rx/Y0ZGMdj4BqBmN
         7FK3b7YJDqd1ncZmxSvroq1uVQe4ZvaUHtrG6qS9ySW0PRqRJq1F/fywqiy2N4PtGTcc
         jrwv5PPlkYhodSgkbrk5jX4q/OnSyjvW5bDi08pXGUeYzjCn/ZsLIEkfyigSIPunq6PR
         geef1sK1E9oGPO8QTI4X+Wo2LYqnoSG7lOAmHxp6wEIHreE4cDJGuEKpAVBWyR47/U6w
         Hb7zp0MC0cCia6QXL0OL8k8sTWkSJWjI4rYNJSbSlic0g88j7PsrUTzMva4XkMwGRPFh
         XpAw==
X-Gm-Message-State: AOJu0YycLl2WzAa/56NWvWWFDBffGxH/H9mJQY7/OUCRx05QXaC40CY5
	nBnmsn/xL2xpfVrYGmUPGCAfxyiLXTZTS94gEniBg06XXRAKQxiQM4jfjGxG9S5ueXUjoEFG64p
	wrg==
X-Google-Smtp-Source: AGHT+IEAYC5DP+WALGCslCUhkqhj950VXqpoXobu1Y2ptKdXx7bdQQQelEJEr6mZ39T+LNoUSOa9+KH+ffg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:1d:b0:604:103:567d with SMTP id
 bc29-20020a05690c001d00b006040103567dmr544616ywb.0.1707243875607; Tue, 06 Feb
 2024 10:24:35 -0800 (PST)
Date: Tue, 6 Feb 2024 10:24:34 -0800
In-Reply-To: <86024ab8-0483-42a2-ab71-56c720b01b9e@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203124522.592778-1-minipli@grsecurity.net>
 <20240203124522.592778-3-minipli@grsecurity.net> <ZcE8rXJiXFS6OFRR@google.com>
 <86024ab8-0483-42a2-ab71-56c720b01b9e@grsecurity.net>
Message-ID: <ZcJ5YqJhSOrt-GMk@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Simplify kvm_vcpu_ioctl_x86_get_debugregs()
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 06, 2024, Mathias Krause wrote:
> On 05.02.24 20:53, Sean Christopherson wrote:
> > On Sat, Feb 03, 2024, Mathias Krause wrote:
> >> Take 'dr6' from the arch part directly as already done for 'dr7'.
> >> There's no need to take the clunky route via kvm_get_dr().
> >>
> >> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> >> ---
> >>  arch/x86/kvm/x86.c | 5 +----
> >>  1 file changed, 1 insertion(+), 4 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >> index 13ec948f3241..0f958dcf8458 100644
> >> --- a/arch/x86/kvm/x86.c
> >> +++ b/arch/x86/kvm/x86.c
> >> @@ -5504,12 +5504,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
> >>  static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
> >>  					     struct kvm_debugregs *dbgregs)
> >>  {
> >> -	unsigned long val;
> >> -
> >>  	memset(dbgregs, 0, sizeof(*dbgregs));
> >>  	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
> >> -	kvm_get_dr(vcpu, 6, &val);
> >> -	dbgregs->dr6 = val;
> >> +	dbgregs->dr6 = vcpu->arch.dr6;
> > 
> > Blech, kvm_get_dr() is so dumb, it takes an out parameter despite have a void
> > return.
> 
> Jepp, that's why I tried to get rid of it.
> 
> >          I would rather fix that wart and go the other direction, i.e. make dr7
> > go through kvm_get_dr().  This obviously isn't a fast path, so the extra CALL+RET
> > is a non-issue.
> 
> Okay. I thought, as this is an indirect call which is slightly more
> expensive under RETPOLINE, I'd go the other way and simply open-code the
> access, as done a few lines below in kvm_vcpu_ioctl_x86_set_debugregs().

It's not an indirect call.  It's not even strictly guaranteed to be a function
call, e.g. within x86.c, kvm_get_dr() is in scope of kvm_vcpu_ioctl_x86_get_debugregs()
and so a very smart compiler could fully inline and optimize it to just
"xxx = vcpu->arch.dr6" through dead code elimination (I doubt gcc or clang actually
does this, but it's possible).


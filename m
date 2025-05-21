Return-Path: <kvm+bounces-47304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7538ABFCB4
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 20:19:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11FF67A5AD2
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 18:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC9A028ECEE;
	Wed, 21 May 2025 18:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ei3xO6w+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323D71E3DED
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 18:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747851565; cv=none; b=ivCBhAzvP1RkX0Gt76nbkz0uhnwn4rsU1OQ+jj1LmJ4BlDoEqFnk/CN1rhFOBB9vA2K1Zm79Cvz0WUXOg+80eRI7zz/EoS6i5CKIs8eRbL9tuxWLKQB59Icmx6wR3EcLYC0sELFpoAXkbwBPVr5omLkA+N0d01u852rXj3ndAQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747851565; c=relaxed/simple;
	bh=hNOCCsT7WfpiM1b/accfoXI44kJhoT550SBK2E3F0tM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DUJdWkeryfgeFCjH2jdLxcxgqrAgwhmQ6QDZHC4lAIkcduiN5nnQFwMWKj0aIwWrnpiG4ElvplcPI2fTyCnGnLxfQGVBsKzJHfYQKzwYuMDvev8cbVuF3YHoFrma9qjnaEZNJILb3jAg686V/c7n/G7k3qqmgwicpliOzshpNsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ei3xO6w+; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2320ffaa4a9so70889935ad.2
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 11:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747851561; x=1748456361; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EpmXi2p97nfKGtbYPsKrqYABLynLWTxDiX5+ukiqgG4=;
        b=Ei3xO6w+KBdY1VJlYqibocHC+FO477mHl8m86z1QQWmWf2/OQjvrktvHdX0YrA/kQU
         w3tKexUyTeg0rwk1qBHLD8ZCvWuWMl692b0xVOdX8wKTJlDhG1HG9781NiXn+nyXG3dc
         R/mBgjKnicelO5NgDT+pGpFUnoUoIDxcgkHbnUJbwZd0iaY4kJHQkJJ8tCxUE/kQ/2k9
         RxkE2YAuWGf1JEkEpOCKR9Zc0liCGy/KVZ7Xs2KNlB9pmBepGRuuNINNauruUHSm3N51
         1soSl4WdCLB50Pm/kt7C5jjxxepx+z6jh6nmPSRTsIclAIB0H7uQir1UUwrsCv+D+ThD
         C8UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747851561; x=1748456361;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EpmXi2p97nfKGtbYPsKrqYABLynLWTxDiX5+ukiqgG4=;
        b=n7HtN6xTcJOKaMopjzxOMmeXa473cxJaTcsbhMGHutjwlioRcoO1hD5W6ZSENCigqW
         ABRVgunScYPHKtF09yUzfBLfUC+TWyMND4Vf9lznvwhXKpZSCn4bj3F7cv1/L9bFp9t+
         2QkXZHhmxPytJt36zqZwuO4LvIs9xKsk10hUcaF+FErKkChSqNjS62pA4GSs5PXlER3r
         SgG+dd1PASW+sHHyCBFsRA5wYI8or8pSXDKONDvla2A42dGFxgbzHQbEz5Ms7YrAQzEQ
         gejmJU1jsp0C2Lhzv2EM5jKbegM9DscxCLdzZfeQc+eEhM76vbX9wO9cGvaw/Yy6oMMB
         3RcA==
X-Gm-Message-State: AOJu0YyfEOEgn2racXm1zCwQrMxFOCVKeKZq9L0NgoSsL1PKbIXm2ja2
	qmki2z1L3YJ6ulXBwxMMLd4zaFp+5hLjpC7wDgzyCtnCIjnJba+B/A1sA+j7clOCiVOJtsgNrM1
	xXJ53Uw==
X-Google-Smtp-Source: AGHT+IEVAnp3aJri/4G8yCbjAGvCZIIAYw69WH0s/hXr+QEcz+tLscv1MFZEYlYAAbnwEEtRsZruxVuyc5E=
X-Received: from plkv11.prod.google.com ([2002:a17:903:1a2b:b0:22e:17e6:898f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1aec:b0:21f:1202:f2f5
 with SMTP id d9443c01a7336-231de351473mr239997055ad.8.1747851561301; Wed, 21
 May 2025 11:19:21 -0700 (PDT)
Date: Wed, 21 May 2025 11:19:19 -0700
In-Reply-To: <CAAH4kHai8JStj+=HUiPVxbH9P79GorviG2GykEP7jQ=NB2MbUQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250515220400.1096945-1-dionnaglaze@google.com>
 <20250515220400.1096945-2-dionnaglaze@google.com> <aCZtdN0LhkRqm1Vn@google.com>
 <CAAH4kHai8JStj+=HUiPVxbH9P79GorviG2GykEP7jQ=NB2MbUQ@mail.gmail.com>
Message-ID: <aC4ZJyRPpX6eLKsC@google.com>
Subject: Re: [PATCH v5 1/2] kvm: sev: Add SEV-SNP guest request throttling
From: Sean Christopherson <seanjc@google.com>
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, Thomas Lendacky <Thomas.Lendacky@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <jroedel@suse.de>, Peter Gonda <pgonda@google.com>, 
	Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="us-ascii"

On Fri, May 16, 2025, Dionna Amalie Glaze wrote:
> > > @@ -4015,6 +4042,12 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
> > >
> > >       mutex_lock(&sev->guest_req_mutex);
> > >
> > > +     if (!__ratelimit(&sev->snp_guest_msg_rs)) {
> > > +             svm_vmgexit_no_action(svm, SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_BUSY, 0));
> > > +             ret = 1;
> > > +             goto out_unlock;
> >
> > Can you (or anyone) explain what a well-behaved guest will do in in response to
> > BUSY?  And/or explain why KVM injecting an error into the guest is better than
> > exiting to userspace.
> 
> Ah, I missed this question. The guest is meant to back off and try again
> after waiting a bit.  This is the behavior added in
> https://lore.kernel.org/all/20230214164638.1189804-2-dionnaglaze@google.com/

Nice, it's already landed and considered legal VMM behavior.

> If KVM returns to userspace with an exit type that the guest request was
> throttled, then what is user space supposed to do with that?

The userspace exit doesn't have to notify userspace that the guest was throttled,
e.g. KVM could exit on _every_ request and let userspace do its own throttling.

I have no idea whether or not that's sane/useful, which is why I'm asking.  The
cover letter, changelog, and documentation are all painfully sparse with respect
to explaining why *this* uAPI is the right uAPI.

> It could wait a bit before trying KVM_RUN again, but with the enlightened
> method, the guest could at least work on other kernel tasks while it waits
> for its turn to get an attestation report.

Nothing prevents KVM from providing userspace a way to communicate VMM_ERR_BUSY,
e.g. as done for KVM_EXIT_SNP_REQ_CERTS:

https://lore.kernel.org/all/20250428195113.392303-2-michael.roth@amd.com

> Perhaps this is me not understanding the preferred KVM way of doing things.

The only real preference at play is to not end up with uAPI and ABI that doesn't
fit "everyone's" needs.  It's impossible to fully future-proof KVM's ABI, but we
can at least perform due diligence to ensure we didn't simply pick the the path
of least resistance.

The bar gets lowered a tiny bit if we go with a module param (which I think we
should do), but I'd still like an explanation of why a fairly simple ratelimiting
mechanism is the best overall approach.


Return-Path: <kvm+bounces-11700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 731C9879F7B
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 00:01:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A7601F230B2
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 23:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27BEB46556;
	Tue, 12 Mar 2024 23:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kB4H4wSX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB26446420
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 23:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710284454; cv=none; b=URhJiV/IDXSJgz2tgTU+H1LrQkTTvJMx1KG2WEJzyREU1R/H1DHXfuNlyQ6+eNLQM06wxfGU6KDH/Mjyl8y1k7UMrVzeR6E431Y3hfVoTaFKepEQMLi5sTm8B1U9XMLOZZw0UlLRBIfjvJjUum83kXK/Qz6aQUoyP7uwqpZgHm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710284454; c=relaxed/simple;
	bh=qO2dOJwYXiHGsrBD/FdzA/KF9c8kSd9g7Y7J4bPgbmI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e9j7DQ5kV4oGFF4FMEIsuIIE9KwWIuEfL7K1DVNm/o9RzEa5XuNAzhmcbPSh4K45YBYUD4lk3+shAzEfCjmu2LByDp5pCDYMlig+k1uRIl8Fa5Jat9VhvqpvGuAX23RkctHzDpJynbcfvBrtwfiiyxPmWT1CTh/qDz4NGS7zfwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kB4H4wSX; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcbee93a3e1so7932060276.3
        for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 16:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710284452; x=1710889252; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LoycAKQrzvuQYrnmzWabhjdIoZbB1BxJilyBQoB+qZI=;
        b=kB4H4wSXEAsUKfpRUpMmqoduBOGFESBiovb9E+zQVgmZOSHBPocWEfFYXZltkIyMHV
         ZMMCynAoVx6kEulz23OTsqydHOfA0xNduwBD2XET+qRLbVbuTdhgTAIBQVjR2lWynJwi
         6EiB3tqEBVyFQ5Ghgf3jN66Qevjyo+6ZuTubVIA3j4Q69dZo4qiRz5bXhnLGt2a9dWa/
         bbAIcI9h19Lgsg6h3mexwDlV09OIEf/G5QWsqEcuUZqI137UhfqNt6DGjdTUQavHdJlD
         wkSi61U/kBTHis0WhR9VwKrdQ2D7oghRxJhTVDHIZbuXZV61ijCY6eDTjmRO/YJzYndU
         4miQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710284452; x=1710889252;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LoycAKQrzvuQYrnmzWabhjdIoZbB1BxJilyBQoB+qZI=;
        b=HHjPtbPa2smmZbPPM0jrELtXORTMtNEO12cDxM5GT6WVHaxSwqmspjs6QT4t6OPy2D
         LAiPOzir5mVYwj3CCFIui0m9dz3ZlipNjB6ufRCfdecsLtCSiX2Tn7yKcQi8T93e4PlS
         vcBjdwxgGyNcfHyxNWy7Tv5Gq4XdZ1iZMPz5PV+PEZ3k3p1NeN7U7BqDE4henXELJM5o
         8p/Sw8iVxJGa2n0rzkCShN0kXEVG8rHV96DTTP68Hp+6RXNUWQ+LhEhJDgWoClBedC/R
         SHgMdSnf8r58+ycQa9u671e7DcptmlL7Hr0mtK3Hybfi7eYh5+2fqAbscHPag8tUoipb
         cTmQ==
X-Gm-Message-State: AOJu0YzrUJ5em/z0PusOaiBUwN/xA6uSK9kykEsZZsvvYwb98pIB+tVf
	mG5gkK2Gcj0ZcoVZLm4QvDsOqXbFW0/Xd7QBtLMFe09MTM0+dwNOlo1qSW+/lYhBE+gj6mb2hnr
	jBg==
X-Google-Smtp-Source: AGHT+IFGUdhgsgVJ8mgWrHNthZAEjKQcuSF0mvEDkwwjRyC0VHPHtI8nOYpsZHnTIn7Wy+TGMLNJXNZF3Bk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100d:b0:dcc:8be2:7cb0 with SMTP id
 w13-20020a056902100d00b00dcc8be27cb0mr87342ybt.0.1710284451989; Tue, 12 Mar
 2024 16:00:51 -0700 (PDT)
Date: Tue, 12 Mar 2024 16:00:50 -0700
In-Reply-To: <5e302bfa-19a8-4849-82d0-0adada3e8041@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240308223702.1350851-1-seanjc@google.com> <20240308223702.1350851-7-seanjc@google.com>
 <5e302bfa-19a8-4849-82d0-0adada3e8041@redhat.com>
Message-ID: <ZfDeohmtLXERhyzC@google.com>
Subject: Re: [GIT PULL] KVM: x86: Selftests changes for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 11, 2024, Paolo Bonzini wrote:
> On 3/8/24 23:36, Sean Christopherson wrote:
> > Add SEV(-ES) smoke tests, and start building out infrastructure to utilize the
> > "core" selftests harness and TAP.  In addition to provide TAP output, using the
> > infrastructure reduces boilerplate code and allows running all testscases in a
> > test, even if a previous testcase fails (compared with today, where a testcase
> > failure is terminal for the entire test).
> 
> Hmm, now I remember why I would have liked to include the AMD SEV changes in
> 6.9 --- because they get rid of the "subtype" case in selftests.
> 
> It's not a huge deal, it's just a nicer API, and anyway I'm not going to ask
> you to rebase on top of my changes; and you couldn't have known that when we
> talked about it last Wednesday, since the patches are for the moment closely
> guarded on my hard drive.

Heh, though it is obvious in hindsight.
 
> But it may still be a good reason to sneak those as well in the second week
> of the 6.9 merge window, though I'm not going to make a fuss if you disagree.

My preference is still to wait.  I would be very surprised if the subtype code
gains any users in the next few weeks, i.e. I doubt it'll be any harder to rip
out the subtype code in 6.9 versus 6.10.

On the other hand, waiting until 6.10 for the SEV changes will give us a bit more
time to see how they interact with the SNP and TDX series, e.g. in the off chance
there's something in the uAPI that could be done better for SNP and/or TDX.


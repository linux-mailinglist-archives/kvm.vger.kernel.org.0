Return-Path: <kvm+bounces-52406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B6708B04D1A
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 02:41:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EADD7188982F
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8905519D081;
	Tue, 15 Jul 2025 00:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BuzDbETN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3489210E3
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 00:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752540092; cv=none; b=rlneuCOLW5IgvtWvAMLeiCB7S4gwm3mgyHGlJ3TMwLqHdpQ0wkJbQGZJhf2kYy0Db1DBtUXHJQmBaCXtDwwaVkdFdtBeoz1hA4OiFW2ErDg+a5AEmIi9rvnt1fea/AkeNhrlsTIaR0jy0aGyXJ8l/K7+3zJ1CCNNGjDDcq7LjmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752540092; c=relaxed/simple;
	bh=e6u4kzbTlpY6XgWvdx0C4bqIzQlBCHDgDKiaDMRpPo4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XgSRahKQnrBaES2gBtKRBHoELsWJ0NVLcLvq9mocBnTv6n5t183k4yzFxdyUQBxn2SK3AFBOi3sL6FKeMNYmU+jGSOxWWlr/+dPW6W/5LMeFHDA/RzzNAKPcJ2ChTskO9lfK3CmdSVKfVV1ddTJ+1pPnqzAxrBq2nDcBSRHGl64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BuzDbETN; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-235e389599fso97715ad.0
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 17:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752540090; x=1753144890; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UX1iqBfYXGafPsZgRW8n/DgE7iPmep19kIXNMUQ2HJk=;
        b=BuzDbETNvmIL53e3+0KoqNUHsuY7KjKSfZ+D3km9sfIIyrMA1jjzestPzCPQ48QQAB
         +HV2xiDtIMMSmTheQRdDx2Kwmj7sESw9yDHUOKpCWPJbG5mYQ13JqCbUGAIv0D2jGOAz
         WjZPlSC4X0YoMK10OaCruS4rFgwOgtoAjVW3FCNEtRhJs62K025I1H23/7+Hd1cz6dMU
         NgMc6sP+6mX4M6oqaLlhsNo2/f1KYgu3hx9oqdywFp4yY1qITuygiSnfIcifJCK4eZXA
         BhGVwDbnbZfrhmxc7Gft7UjMrH3Y/vfcRFfU2kfGW5sFwOdgN92Akccc1waMqwTqlXHk
         cdUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752540090; x=1753144890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UX1iqBfYXGafPsZgRW8n/DgE7iPmep19kIXNMUQ2HJk=;
        b=ctWjPAogb0x8ZEj9h3GweHrQRjAUlWI/FeD6VmQQZSKaWBtb5F1HVAG+PBr0hpby9K
         P/11mMxLJd2AWLL+GNSymJRvIQUGZO18O0f9NeuFGjDnvWgOf7ps+qQHYKRzJ8bEUz0x
         zz6Gb7Ttw2kWUyoxtcwEgqV1PT9Yo/uOEJjoTo387/mpP5gjBaGwgswzlTMZAgr8LbDO
         BVf+SjNDGF/kyTQ+Y70iFrmAHMYptpFjKHnC/JKewsL3JdQ8m/5ueX4i3ncSJoxF0i7U
         euRDpKrt8CLi700Gn8XM0SJV6WoLJOqQFppw7Rem/S4N17vjx9wDfxyHyRL6hEH2I5MV
         zhZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPwb/to5cEuKGHDc4du2ioOs1WIwjqP5c9Cdn5MENVlQHGvy/n1W3LGEuexYnH9kGWKJc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIzpk83eExRRcJ2fujhtGgNXHFzhI27qPkGesbua0tdRIeoW9W
	wcLvAKbAPYk6WJyhmBF/q1wggOWVXUdePRiP6c53BLazXfSt0lPcmsa3qAteAYgKXAs1X5YIbkP
	7w9gDXctbU/7bIvNjI0MDO9K8fPml5wknbsbFiVEU
X-Gm-Gg: ASbGncuBa+bb7sMEGsk8Jyi/FRZvn8cQZn92L9P7t6NGA8Jui2LHp1RvevOgTjTvFMF
	ufCP4Pcd6aBPp3VCIZ0kn0/Cs1v0wtqJnKjadR3xLRA1FA6HcXw3Fxah5USqob+GKLDt1fP5qMu
	Hp4aHNYbHgZZIFTxJs9eklJUu/Y1HRABmcol8CqvYNjLuOj4iQEx4TMtsTpJgZNZnsjIxaozFs7
	3MOL2/4EjA/f17Zc0n4eUsOfy66VJHTnz1p5jaFa9c/tVP9
X-Google-Smtp-Source: AGHT+IFnnn5TfVGyd1D3iP7UwsZJHVlC2o421euyx05G3rKVs3eMXQL5ccITcJ6SIchFux3YCwHP/tZwUq7+K6O/qMY=
X-Received: by 2002:a17:903:185:b0:234:9f02:e937 with SMTP id
 d9443c01a7336-23e1b55fab4mr567335ad.25.1752540090046; Mon, 14 Jul 2025
 17:41:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250703062641.3247-1-yan.y.zhao@intel.com> <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com> <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com> <aHEwT4X0RcfZzHlt@google.com>
 <20250711163440.kwjebnzd7zeb4bxt@amd.com> <68717342cfafc_37c14b294a6@iweiny-mobl.notmuch>
 <aHGWtsqr8c403nIj@google.com> <CAGtprH8trSVcES50p6dFCMQ+2aY2YSDMOPW0C03iBN4tfvgaWQ@mail.gmail.com>
 <68758e893367f_38ba712947a@iweiny-mobl.notmuch>
In-Reply-To: <68758e893367f_38ba712947a@iweiny-mobl.notmuch>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 14 Jul 2025 17:41:17 -0700
X-Gm-Features: Ac12FXw6OnnBeRg5tzGo9zODyPTk-FHWOunP2TNCEpzwOFdIR4F6wxZS-QA4P7E
Message-ID: <CAGtprH8O535VFYSTp+zqXF0cptDwOn5gwmJa=BLy1zoCdLa=iQ@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
To: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, david@redhat.com, ackerleytng@google.com, 
	tabba@google.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2025 at 4:10=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> wro=
te:
>
> Vishal Annapurve wrote:
> > On Fri, Jul 11, 2025 at 3:56=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Fri, Jul 11, 2025, Ira Weiny wrote:
> > > > Michael Roth wrote:
> > > > > For in-place conversion: the idea is that userspace will convert
> > > > > private->shared to update in-place, then immediately convert back
> > > > > shared->private;
> > > >
> > > > Why convert from private to shared and back to private?  Userspace =
which
> > > > knows about mmap and supports it should create shared pages, mmap, =
write
> > > > data, then convert to private.
> > >
> > > Dunno if there's a strong usecase for converting to shared *and* popu=
lating the
> > > data, but I also don't know that it's worth going out of our way to p=
revent such
> > > behavior, at least not without a strong reason to do so.  E.g. if it =
allowed for
> > > a cleaner implementation or better semantics, then by all means.  But=
 I don't
> > > think that's true here?  Though I haven't thought hard about this, so=
 don't
> > > quote me on that. :-)
> >
> > If this is a huge page backing, starting as shared will split all the
> > pages to 4K granularity upon allocation.
>
> Why?  What is the reason it needs to be split?

I think you and Sean have similar questions.

This init private-> shared-> fill -> private scheme is for userspace
for the initial guest payload population. Another choice userspace has
is to begin the whole file as shared -> fill -> only needed ranges to
private.

Regarding shared memory ranges for CC VMs, guest_memfd huge page
support [1] simply works by splitting hugepages in 4K chunks for
shared regions to allow core-mm to manage the pages without affecting
rest of the private ranges within a hugepage. The need for splitting
has been discussed in MM alignment calls and LPC 2024[2].

[1] https://lore.kernel.org/lkml/cover.1747264138.git.ackerleytng@google.co=
m/
[2] https://lpc.events/event/18/contributions/1764/


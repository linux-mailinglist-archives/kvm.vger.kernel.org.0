Return-Path: <kvm+bounces-27014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C741B97A74B
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 20:24:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71AE41F28777
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 18:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC7215B984;
	Mon, 16 Sep 2024 18:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PhDmi8QY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7549F158545
	for <kvm@vger.kernel.org>; Mon, 16 Sep 2024 18:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726511070; cv=none; b=F2x30VU3BdG2dimrVhuCHfa1FJJUsvml0sdxcc/JpXaWLrWq0Pr1/I2Hex+ZazGHg4O967FSj5564ERw0m9QlSWxRofxIBoaiujiYcUKX0F68TmGMg5Zrz1maE18F50U8VE88Cij7ogYzwirAaErwgIMKxYxI7zMxhUq0SFRXQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726511070; c=relaxed/simple;
	bh=KyN8GKvHoP6oAAePFJM111cdcf+1s0w20NMicGPpf5o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nmMuhXwNzVW/D8OWQoSJHD76hug9HNnI6KfJa2t2ZuYLvIsJZVYrivtBjNYW2gH64wj4mV5BSTOcSyKw8343GkC0KdqN74FaNv+oJp7b6fmaePfgEUGjpRaMCZxWffo0uJqE+Gkv6SZyi9+dtt/92e0EFYXHtROKeJ0bgPFqZPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PhDmi8QY; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ddc768e85aso21306807b3.1
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2024 11:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726511067; x=1727115867; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PWVVert/0duLgr8lppMjlBcvaVlhn5CV2P73SctPY5A=;
        b=PhDmi8QY8HXvWeZDVLCDmpjTTaxYVgf3GoXVan3Qim27iF9p3KG+odLNLZwNB5WOTd
         EvnBVSKt3lZ7/PSSMsLs8/y7OcXPsfiAyylEQt8KESVWflKzdbcMtVjxvL7GNYQpMRWJ
         QHCCqzf0NidZ27O8zNMBZZMGNSa44LAFz56kzDWstcWxIc3Lqi10TpIhn4gNQlXvo5qp
         tgt8410g4gkdZ1HRExxHOWOn4MFZte8qEDzAwPJ+AiaabGVjC4hVwqncbgWCxDqbmA4W
         VpOsuytOtojxEwfHDGkp4ivWF4B/ym4813pmIp7DTjIY8sxuUMHXEGWgVcXQ4fEJzmJj
         VYMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726511067; x=1727115867;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PWVVert/0duLgr8lppMjlBcvaVlhn5CV2P73SctPY5A=;
        b=D62vU+62jXDpSriSpbaUBCIwTytlk7sg6Ne/si4FGozgDQ21Eo+jOH3YVUlxjWJ/j+
         xuNXdg5ZllGDLHmJLcwFPLaUKThwFm66phI0+xjL4XHi9vIpnKjsQCCeypjdIkUMRKRQ
         8BBvvWQyR2i6X3otfd5zAJLQ5DMOb4fFdaLdXCU1isu2Wa9J2O7e85qi/PMqnSayMG/f
         64kU02D/QwRYgjgqLjhquYFQYz848a30EnE26yAKf4Kj3RXj50OWl+iiR3a1RN8Sol4s
         HPj0ETE/6rMlfZu30eqC6qolRWwA4d/CtGLqNZHRNWxQvsCicZAjsspFdqzbW6uUCO2K
         66Mw==
X-Gm-Message-State: AOJu0Yy6touGg3nG3pzOdbmW68AYhKJMqQhBP8dZrrczCILuC3nl5G1W
	aKnHme6IT2Zx5QP+0ofdlMIRpgAxBPvg+BSeqx9Ipb7DjspwJ3herpTpRmutDmNSb9kv5xNbdTu
	qNw==
X-Google-Smtp-Source: AGHT+IGw6+fTdMMlTRPuPFeoq64qFkHtSG8aeQPj9JG0eFHtNo93fBF43eoD6YBxvGRG6q4NAAC5M9oExS0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:c4a:0:b0:e17:c4c5:bcb2 with SMTP id
 3f1490d57ef6-e1db00d2b9dmr49146276.7.1726511067380; Mon, 16 Sep 2024 11:24:27
 -0700 (PDT)
Date: Mon, 16 Sep 2024 11:24:25 -0700
In-Reply-To: <CABgObfZ1oZHU+9LKc_uiPZs1uwqxczcknspCD=BJCFZd5+-yyw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240914011348.2558415-1-seanjc@google.com> <CABgObfbV0HOAPA-4XjdUR2Q-gduEQhgSdJb1SzDQXd08M_pD+A@mail.gmail.com>
 <CABgObfZ1oZHU+9LKc_uiPZs1uwqxczcknspCD=BJCFZd5+-yyw@mail.gmail.com>
Message-ID: <Zuh32evWMcs8hTAM@google.com>
Subject: Re: [GIT PULL] KVM: x86 pull requests for 6.12
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 15, 2024, Paolo Bonzini wrote:
> On Sat, Sep 14, 2024 at 4:54=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.co=
m> wrote:
> >
> > On Sat, Sep 14, 2024 at 3:13=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > There's a trivial (and amusing) conflict with KVM s390 in the selftes=
ts pull
> > > request (we both added "config" to the .gitignore, within a few days =
of each
> > > other, after the goof being around for a good year or more).
> > >
> > > Note, the pull requests are relative to v6.11-rc4.  I got a late star=
t, and for
> > > some reason thought kvm/next would magically end up on rc4 or later.
> > >
> > > Note #2, I had a brainfart and put the testcase for verifying KVM's f=
astpath
> > > correctly exits to userspace when needed in selftests, whereas the ac=
tual KVM
> > > fix is in misc.  So if you run KVM selftests in the middle of pulling=
 everything,
> > > expect the debug_regs test to fail.
> >
> > Pulled all, thanks. Due to combination of being recovering from flu +
> > preparing to travel I will probably spend not be able to run tests for
> > a few days, but everything should be okay for the merge window.
>=20
> Hmm, I tried running tests in a slightly non-standard way (compiling
> the will-be-6.12 code on a 6.10 kernel and installing the module)
> because that's what I could do for now, and I'm getting system hangs
> in a few tests. The first ones that hung were
>=20
> hyperv_ipi
> hyperv_tlb_flush

This one failing gives me hope that it's some weird combination of 6.10 and=
 the
for-6.12 code.  Off the top of my head, I can't think of any relevant chang=
es.

FWIW, I haven't been able to reproduce any failures with kvm/next+kvm-x86/n=
ext,
on AMD or Intel.

> xapic_ipi_test
>=20
> And of course, this is on a machine that doesn't have serial
> console... :( I think for now I'll push the non-x86 stuff to kvm/next
> and then either bisect or figure out how to run tests normally.


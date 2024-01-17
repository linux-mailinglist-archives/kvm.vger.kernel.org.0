Return-Path: <kvm+bounces-6405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 60F0B830C87
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 19:14:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6ECAB234AA
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 18:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1556C2374B;
	Wed, 17 Jan 2024 18:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iYe8PtEY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A8823741
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 18:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705515279; cv=none; b=HwIcK1NYY+JJqsnQTkdK/F+2PPiMJ5J4Im1urk1bpTtI8b9yrEHs5uasfORzXvXFZH30tPYQTX8578ABG1kV4sCKnjwGpmNnguyRGRPVM4iDLy6zWkd9HFVrQ8eG0MrfBjpaf+giF9i+KEyDNX4JbUzHSPb98ZzqYujI+Fy0V9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705515279; c=relaxed/simple;
	bh=nqFeB4KyYhxgWfOLQ8JdxLgIdQrEhqY45Ev2FxA0YdM=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Date:
	 In-Reply-To:Mime-Version:References:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding; b=WI2hpyQ2iphh21BtSvDiy9WNujuY7CX5kg4DpLdaKIoRzS11qw0FfdfyIVWr5yRCRj7ZO2mdQwANiCVeHa5Kl1kR9hp/Cx88M90oBG8s4LkSwl80XNzLe2wbELqCZIgp9Nrd/Rl3YLGlEAbmaqk43A5nGCZ1F3dNTyHidltghRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iYe8PtEY; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbeac1f5045so13154491276.1
        for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 10:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705515277; x=1706120077; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f9FM8iaRssC6gMDw8kwXbRU73ClZB/0yxb7YbFDMCy0=;
        b=iYe8PtEYFOtqdkgCgXeJtNPweXMPu5rTMXEBlHx9o2R9aWhmwzX9iSRZNrKCUalQDl
         zxxUm75kzeZQb1XWfaFgr9wf2ZdwcYWXDl/UVZCJXvwcc3kwByTjj/EiKrxiMjmDV0UA
         S25NwHbVNY7b+3EoQaiSKtYlFFZaxPqlbTp8YZCy/3+UO7q49O1aRWhPowjekcHKYEBi
         gCCLafDyKZYRyiBaKzBl7N0CxfU0y+xOpwuIc+ZJL5wR0vtJSEGH2NAdr5Zwkp+wxqII
         yntoxKnf1ejDBHyPloubtRu2/CNJmIqCZSk7wa7nEZT7w0JODHFwH6ku06iMAjMEvIIs
         i33g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705515277; x=1706120077;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f9FM8iaRssC6gMDw8kwXbRU73ClZB/0yxb7YbFDMCy0=;
        b=BlvF7XcnPpjR60iYCwsq9Qu3VW5HFGsB0CqspVlJrrjfQKOkoELEy7yIDvVX/Gtsja
         JBEu2INLfR43UBLICf13L/OUxGWVJLmYTSgpjyKkl4+SPK713CudSOjWUfhKAMd7rbgC
         8/lSSIMn7icpgg1NRB1faJUnxqKInl1vxfDDfdYN4CZWEJEXZ4UpxrB7YirX9fkV47GR
         NYljPsqE2D6JPGQ6jgzt1r/ebLWa0DmniPUfydNbOwTmNr9t/0C4WbGpuboW0CzIf80o
         KpsG/mdTC6Dw26os8BlpgAO3Zh0ddEvOcgPa9szs/QNaZUZsOhd32n47PowWvhrA2v26
         RI+g==
X-Gm-Message-State: AOJu0YzGFXJl9FHWvQ4YsdLx6/+7s/DZnWpiA64yg6mubDK9blb2eXiT
	Ns1tXWdwHUFtWFc0wJqDXKGZHJKV9WF4p4RlIg==
X-Google-Smtp-Source: AGHT+IHicoqkQ6e+5OmMMh3OOXoscDSgEbUBjvIvyQOcZkt1juLxfCN0XZ1RUXntI+MGI/XYZtm9iiN5Zp0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:b1d:b0:dbd:b4e8:1565 with SMTP id
 ch29-20020a0569020b1d00b00dbdb4e81565mr425771ybb.4.1705515276966; Wed, 17 Jan
 2024 10:14:36 -0800 (PST)
Date: Wed, 17 Jan 2024 10:14:35 -0800
In-Reply-To: <6851f05943c5a9792755cc0e97564e1eb5586b77.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <9a82db197449bdb97ee889d2f3cdd7998abd9692.camel@amazon.co.uk>
 <Zaf7yCYt8XFuMhAd@google.com> <ef60725c38faa30132ab45cf14ee0af86e885596.camel@amazon.co.uk>
 <ZagFm0tmZ4_nWf9L@google.com> <6851f05943c5a9792755cc0e97564e1eb5586b77.camel@infradead.org>
Message-ID: <ZagZC7AVufStb90I@google.com>
Subject: Re: [PATCH] KVM: pfncache: rework __kvm_gpc_refresh() to fix locking issues
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Paul Durrant <pdurrant@amazon.co.uk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 17, 2024, David Woodhouse wrote:
> On Wed, 2024-01-17 at 08:51 -0800, Sean Christopherson wrote:
> > On Wed, Jan 17, 2024, David Woodhouse wrote:
> > > On Wed, 2024-01-17 at 08:09 -0800, Sean Christopherson wrote:
> > > > On Fri, Jan 12, 2024, David Woodhouse wrote:
> > > > As you note above, some other mutex _should_ be held.=C2=A0 I think=
 we should lean
> > > > into that.=C2=A0 E.g.
> > >=20
> > > I don't. I'd like this code to stand alone *without* making the calle=
r
> > > depend on "some other lock" just for its own internal consistency.
> >=20
> > Hmm, I get where you're coming from, but protecting a per-vCPU asset wi=
th
> > vcpu->mutex is completely sane/reasonable.=C2=A0 Xen's refresh from a c=
ompletely
> > different task is the oddball.=C2=A0=C2=A0
>=20
> Well yes, because that's what the gfn_to_pfn_cache is *for*, surely?
>=20
> If we were in a context where we could sleep and take mutexes like the
> vcpu mutex (and without deadlocking with a thread actually running that
> vCPU), then we could mostly just use kvm_write_guest().
>=20
> The gfn_to_pfn_cache exists specifically to handle that 'oddball' case.

No?  As I see it, the main role of the gpc code is to handle the mmu_notifi=
er
interactions.  I am not at all convinced that the common code should take o=
n
supporting "oh, and by the way, any task can you use the cache from any con=
text".

That's the "oddball" I am referring to.  I'm not entirely opposed to making=
 the
gpc code fully standalone, but I would like to at least get to the point wh=
ere
have very high confidence that arch.xen.xen_lock can be fully excised befor=
e
committing to handling that use case in the common gpc code.

> > And unnecessarily taking multiple mutexes muddies
> > the water, e.g. it's not clear what role kvm->arch.xen.xen_lock plays w=
hen it's
> > acquired by kvm_xen_set_evtchn().
>=20
> Right, I was frowning at that the other day. I believe it's there
> purely because the gfn_to_pfn_cache *wasn't* self-contained with its
> own consistent locking, and did this awful "caller must do my locking
> for me" thing.
>=20
> I'd like to fix the gfn_to_pfn_cache locking to be internally complete
> and consistent, then I think we probably don't need arch.xen.xen_lock
> in kvm_xen_set_evtchn(). I'm going to give that a lot more thought
> though and not attempt to shoe-horn it into this patch though.
>=20




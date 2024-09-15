Return-Path: <kvm+bounces-26940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FF359794C0
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 08:33:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 075142829E5
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 06:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 135F31DFED;
	Sun, 15 Sep 2024 06:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cagWJBCt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA50A1B960
	for <kvm@vger.kernel.org>; Sun, 15 Sep 2024 06:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726381983; cv=none; b=svD5uefNQKkMuAmSb786ChjnImvr9kfDiHd5BUisL8e3Gv8Zy7RuRIghptLY8+BNDhrATIlFs0o3PWylwXe1O/OVikw+eRnE14nnOjGKRb9zRiqfWPOLdLnwHkzV6cJvGsO2EIX6bUMRY/gjjp+gw9eLSAcq2d/Levaeoq///a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726381983; c=relaxed/simple;
	bh=lm+XUmAmVSDgb3EJXa1VZap5D/+Aow7c0ziBALSJypw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I228Semg1Z85+YoeExbBbFLd5gnAnhNZdVEK7VAs10qspOo3WtQUmIZiRgehADGw0Z+6Q8DWX1lNc6q1XFI/Hx2c9ZTOAn6EfYXz7VSZ1qkZQhAKwcgcVo9WgA15dIyxjuHk/YbBLM6OVEJtPxHWn50HIDHsyNGzCaCwq0lycIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cagWJBCt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726381979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dMKHOf1xuC7TpHTelTfyEy/DYa5PwD5G1Ptu+WtDrxk=;
	b=cagWJBCtTHnQ46qRChAFRUHx513E90eVF2sLMTnBvCBYsHMfCCxxumHgK53YPDEMVHjYKp
	utW0WTwdztytdA9A0KxCiBpvll3uBBS2yAizb9CH8jMmsPlt5c/MRB6xLw/r2EZtdrvDr7
	JLhY3kkQGzZ9p40QXM27gZtV4upTcgc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-zcYcT0ioM_aZDRSnXRFiQA-1; Sun, 15 Sep 2024 02:32:58 -0400
X-MC-Unique: zcYcT0ioM_aZDRSnXRFiQA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-374bb1e931cso2173158f8f.0
        for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 23:32:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726381977; x=1726986777;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dMKHOf1xuC7TpHTelTfyEy/DYa5PwD5G1Ptu+WtDrxk=;
        b=fwhrZEIJW6XOeWsYd1Djr7dHkXZ70bVMh85Jg5ori4hVwF5U2dHBLr0nsCoFZpbLyt
         bdaMJyiGxZhX22y0gv3QRuFYQd4HDX+JwWkESo07Mz5fkuqvIIv8YeAxF5E1lXkZ6Fe8
         pSzYvK+MiLkbjNQxgbVgLAMBDahrKODU4nbNta7quhgaVP+SRDcV3uoomJ5djKmvkbYr
         8RRsxNUj2PgnuPd1eH3BDnhqNy8XlEm5u4LV3zM1eNWwKPT5CM3rZkhN6PU7E5NSMFyM
         SkUrRrc+ERbJSAtnDz5+xYAkqdUDBYnUkPcJRigNvWn9HoLTt0s15WgYDVt1MocGlq5D
         oRxQ==
X-Gm-Message-State: AOJu0YykpEwWHKl3WoN5eyLzGI8mLuKMe7wwazSAU+aIjWmj50URCMTr
	bWSfqGZCse82xt2Lrzkf4jOL+Gn+841kYTdwx0+s4gVsoe7G9SUa4M7VzDzODGhhL+cVBTu50Xh
	aAZ65mriFYTVNGgLT0FBHDifVJk23lHbBO7ivKNLeRjsHC7kSbyVfJGxENciMMT0BcbpdtV9dI2
	OisHncMsS7EPs1JjXgos1gbHe/
X-Received: by 2002:a5d:5d81:0:b0:374:bb1a:eebb with SMTP id ffacd0b85a97d-378c5e5d6a3mr5139447f8f.25.1726381976839;
        Sat, 14 Sep 2024 23:32:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlQQUMooRrySbo5EAnMxgrKZk9K6rI27EWehhL1UM/p80ojVgXzTvwa2jrK0uOjw7akO5/N/u1DZ4KKGetqP4=
X-Received: by 2002:a5d:5d81:0:b0:374:bb1a:eebb with SMTP id
 ffacd0b85a97d-378c5e5d6a3mr5139435f8f.25.1726381976355; Sat, 14 Sep 2024
 23:32:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240914011348.2558415-1-seanjc@google.com> <CABgObfbV0HOAPA-4XjdUR2Q-gduEQhgSdJb1SzDQXd08M_pD+A@mail.gmail.com>
In-Reply-To: <CABgObfbV0HOAPA-4XjdUR2Q-gduEQhgSdJb1SzDQXd08M_pD+A@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 15 Sep 2024 08:32:44 +0200
Message-ID: <CABgObfZ1oZHU+9LKc_uiPZs1uwqxczcknspCD=BJCFZd5+-yyw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86 pull requests for 6.12
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 14, 2024 at 4:54=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On Sat, Sep 14, 2024 at 3:13=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > There's a trivial (and amusing) conflict with KVM s390 in the selftests=
 pull
> > request (we both added "config" to the .gitignore, within a few days of=
 each
> > other, after the goof being around for a good year or more).
> >
> > Note, the pull requests are relative to v6.11-rc4.  I got a late start,=
 and for
> > some reason thought kvm/next would magically end up on rc4 or later.
> >
> > Note #2, I had a brainfart and put the testcase for verifying KVM's fas=
tpath
> > correctly exits to userspace when needed in selftests, whereas the actu=
al KVM
> > fix is in misc.  So if you run KVM selftests in the middle of pulling e=
verything,
> > expect the debug_regs test to fail.
>
> Pulled all, thanks. Due to combination of being recovering from flu +
> preparing to travel I will probably spend not be able to run tests for
> a few days, but everything should be okay for the merge window.

Hmm, I tried running tests in a slightly non-standard way (compiling
the will-be-6.12 code on a 6.10 kernel and installing the module)
because that's what I could do for now, and I'm getting system hangs
in a few tests. The first ones that hung were

hyperv_ipi
hyperv_tlb_flush
xapic_ipi_test

And of course, this is on a machine that doesn't have serial
console... :( I think for now I'll push the non-x86 stuff to kvm/next
and then either bisect or figure out how to run tests normally.

Paolo



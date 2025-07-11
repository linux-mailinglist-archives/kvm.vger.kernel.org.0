Return-Path: <kvm+bounces-52212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC3FB02740
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 00:54:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDF963A8507
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 22:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B5476BFCE;
	Fri, 11 Jul 2025 22:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S3MyEZh9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F348C2222B0
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 22:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752274471; cv=none; b=k/x2cHCZs4PJGOf4+b03DQTkwdtn+k1Q5EbTg5enbKARphL7L/MQWxyqZ0KQnPRzyG5bZHm+s0G84Skm/UHgTvED8FWMtqfpRq1GBqaEK57cAoiHBpEU2AZACMLZAjfPJPWofmjlYqF8KgsOG9Q8p2O9NHTAuzWEFLjx2Yta/Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752274471; c=relaxed/simple;
	bh=lVn5pDzlXY6RTuCujP1CnONLhKOTka/7U9V+8Hu4HVI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZVmYQwQu7lyPrivtLVA/SjfBD848L81AIC8Vz2uRWEs9paFZUMwxmxq9m8UTLoz8jhnCe/gO9mN20EAT6OFLVP8mA/geuk59Xan0ZUhPFK4mSl8fqZHNltYHOcKl5wPzaqIIfwFsnZg4Tg8LldmUhfHNOUVmp05pAFI3YCLX6ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S3MyEZh9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31202bbaafaso2682100a91.1
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 15:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752274469; x=1752879269; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SIuGUC3mLbCXmkyRuAmzk7oLEBnMAn1PVKR9BryRRw4=;
        b=S3MyEZh9WEyVlQGUyOARLfecl3m/6xbRl1Xk6NMAuqMmwslJGRScpZ1lqP5QQikcpt
         +F41WNg0V5BrfMZWskCPmO/uGuGnP4HgunERp/J0GU4wk30q2XawsTfv+6Ligfddqh7Z
         eKu+C1selAKom3wW6lCD44wdu5NPTWUcSKnQ5LYyns6AKQGdPGroQXDGYx+QwXy+npeF
         aewEx/sd+N8go7znundhpAnOzoUINqxw2DSBX5rAypbLLcbC+co8/m0Y8KHHjmcVJ+00
         Aw7VIPIc4EnOJSLmMeudt7SKxWH7wpjJ7NpJHNbKAZn8Rf1dTfJKLmUexXkmidP0ox7/
         IowA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752274469; x=1752879269;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SIuGUC3mLbCXmkyRuAmzk7oLEBnMAn1PVKR9BryRRw4=;
        b=KJb97XRqzo1A7fOdPtU/xmELPq4fL1Z8QmCGTiS2o5u2bTdBRL1KP2J2J4wxM8NJhZ
         hwq8FPqzuR24kDiZrBgsGSlpPgVce6iffapyLo8wjDZk1efkV3WX5C/lcYyz5R5mLIXT
         y9YK9swz6dCjYAi+y7abnwMIdLq+sUgSs9mVLhu8/vcSTVq+32fe1GBkP8rUiL2XqNAY
         wo+dftanehZq8FyzLMGzco1LCeU6aMPJTmkQPeHbsfuhKtrfQUJfJvRe5kcRVlxn+Bmj
         PCv3Jkt3oYrV9M5wHcEGcGWoawdDwpobt8CfSAkO4Jncn7RgqNVNAGWwXiI3HeksSeTG
         +/Ug==
X-Forwarded-Encrypted: i=1; AJvYcCUYctgK6RQbICIxrdMabqMGzUuIX7SDPCr8KxnQdOnR6OYD7bmf0S1l1cRurBKCXQkNCTI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLvSXZgjIBjjRru4kELRJa12q/ogzvi9BO5nJx/rfBi6U/cPDA
	5Teu1arpRp1KlcUka3oCy+8DQKYtrSiLp5OtBFgzf2ZxgSshhMv1Fyw7pPaQyzuz8l1sABKZGWE
	cOYXzEg==
X-Google-Smtp-Source: AGHT+IHFnjhw4QQpkeot/8YKj/C1tp+0TDPhazgJHgZNENXoJXz/JmzOY1Z1Soj24fl9TqLUN991H8MYtfs=
X-Received: from pjtq14.prod.google.com ([2002:a17:90a:c10e:b0:313:2213:1f54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d407:b0:311:c939:c848
 with SMTP id 98e67ed59e1d1-31c4f381335mr7078093a91.0.1752274469271; Fri, 11
 Jul 2025 15:54:29 -0700 (PDT)
Date: Fri, 11 Jul 2025 15:54:27 -0700
In-Reply-To: <08cef2fec1426330d32ada6b2de662d8837f2fb1.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <175088949072.720373.4112758062004721516.b4-ty@google.com>
 <aF1uNonhK1rQ8ViZ@google.com> <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
 <aHEMBuVieGioMVaT@google.com> <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
 <aHEdg0jQp7xkOJp5@google.com> <08cef2fec1426330d32ada6b2de662d8837f2fb1.camel@intel.com>
Message-ID: <aHGWI5_BsFg1JJCx@google.com>
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025, Rick P Edgecombe wrote:
> On Fri, 2025-07-11 at 07:19 -0700, Sean Christopherson wrote:
> > > > Bugger, you're right.=C2=A0 It's sitting at the top of 'kvm-x86 vmx=
', so it
> > > > should be
> > > > easy enough to tack on a capability.
> > > >=20
> > > > This?
> > >=20
> > > I'm wondering if we need a TDX centralized enumeration interface, e.g=
., new
> > > field in struct kvm_tdx_capabilities. I believe there will be more an=
d more
> > > TDX new features, and assigning each a KVM_CAP seems wasteful.
> >=20
> > Oh, yeah, that's a much better idea.=C2=A0 In addition to not polluting=
 KVM_CAP,
>=20
> How do you guys see it as wasteful? The highest cap is currently 242. For=
 32 bit
> KVM that leaves 2147483405 caps. If we create an interface we grow some c=
ode and
> docs, and get 64 additional ones for TDX only.

It bleeds TDX details into arch neutral code.

> The less interfaces the better I say, so KVM_CAP_TDX_TERMINATE_VM seems b=
etter.

But we already have KVM_TDX_CAPABILITIES.  This isn't really a new interfac=
e, it's
a new field in a pre-existing interface.

> Xiaoyao, is this something QEMU needs? Or more of a completeness kind of =
thing?

Required by VMMs.  KVM always needs to be able enumerate its new features. =
 We
absolutely do not want userspace making guesses based on e.g. kernel versio=
n.


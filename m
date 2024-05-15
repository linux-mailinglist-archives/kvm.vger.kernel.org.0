Return-Path: <kvm+bounces-17460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E3FC8C6CF7
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 21:48:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBBD528403B
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 19:48:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C211A15ADB6;
	Wed, 15 May 2024 19:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V+fuC2lD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04B01591FD
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 19:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715802506; cv=none; b=hkRou3dQXwSuOAc9VwjxrGIOix4Ngp+3MXTmgt6TOnA1cbii+PY3S4bPrPpWbnkPtZDPY4pikvdhDPgYA+DKljEmBOttrhWdZu7W0YHj81Icc0qj1JhfwS4+hMd2A/hglRX0BX9WRvGjEt6LiDO6nVBpC7Ev+JvxjEFZ4Yzkko8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715802506; c=relaxed/simple;
	bh=LhuG2prDzHD7FiRNOpEILqpVbpbUT/MhZyE+R28q/c8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DBseLSBhk5txYsr+6yzl0+NQRl7ytg3xx+gQ95l5BsHphUGILvpGFl1BP5psVmlpnEe+rjEYicSf0e+WxTZ/LNfyNDW6jAOVFQvI1eBjYasi9sBCiz4kBQMfmZUVmVmAq2isF+m1NtSc9NDHoQNDEq0u6eQb5/kfBAdGXvMO58w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V+fuC2lD; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso5817883a12.0
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 12:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715802504; x=1716407304; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DuXPEzGaaZtFfJIXFswfN/K4R/gxi6rRkUbBSTMNW4c=;
        b=V+fuC2lDXDEeBH0nGI0lvrnAz5QO94zNYfeS15bBA/HXogEqNYvitlHEGIUmURf2gu
         6dOFSVWqiNFXzLFHG74dApKTvQ8dASVtIVUGn31af1wBewjT0aSpAL2tuB4aWTx3meWe
         SPbRIDSyM4JzyhCFajjo2ek7WykbbapOqIftCpmVfnMWVEII3mMqQfxf/aLi5z8Bksrw
         mNlle9vNc490eYHXLr4yvIuS1CAJeDthGHZCrzS9blx4BITfvGiqFZfyGb9S0UBAcdLO
         5OYkEdAJaWeMnrk+5WeThmQLLXzkk0TtapjFnC3DW0Cx+3hUNIO2LqUoUoF7y+F3FfRA
         ufGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715802504; x=1716407304;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DuXPEzGaaZtFfJIXFswfN/K4R/gxi6rRkUbBSTMNW4c=;
        b=uuziOp/6t4boHzbe1lg3O0u5dod5rcO8sP4ecCVCT7+m8EVflAxRgZeCt1XJgL5c4m
         odC7QKH6h/y3tf5golZe2Z0e2DNOHnAUKm/k+Gt7SvZzWUjOKHTK3181rroxcCjVbSgN
         hPlA8YY02mc1gQfQ51r1z66o0WJr8hrqbXWaonRPjqPn+BYbhpi8g+zGayCu57EcQEbU
         wohq3SFo6qF2xM2rWBowCZRtfm5GvNMilAGk0VDxNwu9hoEqgKflFsEWAQGtzgwhVei4
         AVcGttjHM2IS6BZtRecSxTgYEhh0W3L97POnWMgWRKVoargX1cH7PndXBvgwVF+ivf1R
         pjJg==
X-Forwarded-Encrypted: i=1; AJvYcCXGtn+UuP9zcDLpXuVacrRl2CGydS1VKz8ZxoxQ0sCpktkMcq9qGcPhJkiOFsoNgJuwPo9tPOrki5+U0f01K2JUZ9ii
X-Gm-Message-State: AOJu0YxWDbdqTrVEsagxZKwpvcuJYiVstiComaQYkDXsN/O1u+PcyyTT
	i2RHhwCdI02Cf2OkUg/0RNOfvm7yo8r5vxE3ipodgfQ3iMvw+kHSAzmqbZEZBG6qbQkPyhZEj8B
	DzA==
X-Google-Smtp-Source: AGHT+IHg+7nKgv1J+G75aQuiIGXRKnJ9zRrb6RNegMzgu94C/HSLmw+4P4o9YO+4q5fseUzQM8jw+bYFNOI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5a4b:0:b0:656:fe50:5c70 with SMTP id
 41be03b00d2f7-656fe505d64mr3712a12.4.1715802503735; Wed, 15 May 2024 12:48:23
 -0700 (PDT)
Date: Wed, 15 May 2024 12:48:22 -0700
In-Reply-To: <77ae4629139784e7239ce7c03db2c2db730ab4e9.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-9-rick.p.edgecombe@intel.com> <ZkTWDfuYD-ThdYe6@google.com>
 <f64c7da52a849cd9697b944769c200dfa3ee7db7.camel@intel.com>
 <747192d5fe769ae5d28bbb6c701ee9be4ad09415.camel@intel.com>
 <ZkTcbPowDSLVgGft@google.com> <de3cb02ae9e639f423ae47ef2fad1e89aa9dd3d8.camel@intel.com>
 <ZkT4RC_l_F_9Rk-M@google.com> <77ae4629139784e7239ce7c03db2c2db730ab4e9.camel@intel.com>
Message-ID: <ZkURaxF57kybgMm0@google.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Erdem Aktas <erdemaktas@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 15, 2024, Rick P Edgecombe wrote:
> On Wed, 2024-05-15 at 11:09 -0700, Sean Christopherson wrote:
> > On Wed, May 15, 2024, Rick P Edgecombe wrote:
> > > On Wed, 2024-05-15 at 09:02 -0700, Sean Christopherson wrote:
> > > > > Or most specifically, we only need this zapping if we *try* to ha=
ve
> > > > > consistent cache attributes between private and shared. In the
> > > > > non-coherent DMA case we can't have them be consistent because TD=
X
> > > > > doesn't support changing the private memory in this way.
> > > >=20
> > > > Huh?=C2=A0 That makes no sense.=C2=A0 A physical page can't be simu=
ltaneously mapped
> > > > SHARED and PRIVATE, so there can't be meaningful cache attribute al=
iasing
> > > > between private and shared EPT entries.
> > > >=20
> > > > Trying to provide consistency for the GPA is like worrying about ha=
ving
> > > > matching PAT entires for the virtual address in two different proce=
sses.
> > >=20
> > > No, not matching between the private and shared mappings of the same =
page.
> > > The
> > > whole private memory will be WB, and the whole shared half will honor=
 PAT.
> >=20
> > I'm still failing to see why that's at all interesting.=C2=A0 The non-c=
oherent DMA
> > trainwreck is all about KVM worrying about the guest and host having di=
fferent
> > memtypes for the same physical page.
>=20
> Ok. The split seemed a little odd and special. I'm not sure it's the most
> interesting thing in the world, but there was some debate internally abou=
t it.
>=20
> >=20
> > If the host is accessing TDX private memory, we have far, far bigger pr=
oblems
> > than aliased memtypes.
>=20
> This wasn't the concern.
>=20
> > =C2=A0 And so the fact that TDX private memory is forced WB is
> > interesting only to the guest, not KVM.
>=20
> It's just another little quirk in an already complicated solution. They t=
hird
> thing we discussed was somehow rejecting or not supporting non-coherent D=
MA.
> This seemed simpler than that.

Again, huh?  This has _nothing_ to do with non-coherent DMA.  Devices can't=
 DMA
into TDX private memory.


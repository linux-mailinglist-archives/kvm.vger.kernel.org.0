Return-Path: <kvm+bounces-14906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EC7E8A783A
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 01:00:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A11CB1C213FC
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 23:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11FB513A3E8;
	Tue, 16 Apr 2024 23:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ACTaVNrV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A4D6EB4C
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 23:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713308449; cv=none; b=jWaBE42fqJHQvT8HrdNaXoAxi55f8jE93WMnY2ONPxt4MvMbFIhdxw+IMkYq3yKvvMhhUy7M/BFfeIq2k/2VLTpaCzXn6jnwn66B3XprGTitm0kOdQLWL6c3rs/FimqyMGFMupjfC7Ia6ydo2MuPGvQ8BBYMo3IdGMPaPRbRjUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713308449; c=relaxed/simple;
	bh=938CDYTogAtfMd1cQm26cNVOklu3dGsvJ7jgtq4RFlU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O0MidvZW01b7Wdd98YybT1GGp1BnwVuhGLdlrhd5jQnWyoYX3ky9En9vJg4Rnl84CiDhBZgRy1O5VBVTG5eYpj6/VH3huaMXHRrhmzG4K2EjLsCCQKRIP4lk/rGQbGiKj8qdXcLDBmAaC83tAINoCFq6Ir42y6wBA9gXn09/oio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ACTaVNrV; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dd0ae66422fso587359276.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 16:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713308447; x=1713913247; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gUTtXSCxfr7roX4tv8e3CeB2xn8HuprapDcEtfWKNTY=;
        b=ACTaVNrVlaHruOYoVyqPS3OKmX7SdAPNIjoPF+QYfN+kmtAhl+hBlT7e4zhQ22ByK4
         gc7cXCOGRX3c4LLz6ZslXrIci8h0wVK70MVKbDMgOiK1KPdjSlFrP7vqF6hXvuqydkEm
         dUfLNjzZBRr0BsjQjtWQg6mJ5aIIlAjkPPEta2xNdZFIu/cBUI4SJk6wvpsWjVqUymdA
         ZrUrDkEQ5k645g9AsyFSCBivs81JSA3ysv2BdZ98iO63wJ2PTLiIjmrAZvzJ5jYOrdFO
         nCQ0bBO0hVnCuJE3KiCCpQI4mljAY8FhPLQ1Mr7f65B7AJArDANpfoI+AFCIbLL3zmCP
         SLRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713308447; x=1713913247;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gUTtXSCxfr7roX4tv8e3CeB2xn8HuprapDcEtfWKNTY=;
        b=qlNHFVXHEJS1ZdDJ4ZhryhsPU1VGlkVXB/qhqk7IDOfudye6EqLDMe7iw5BFrmhW1D
         NAiWO/tNNiwudyfo1KteZohn7k0V/XpzAQSqeg4GqmYbizzk4vhYxQUbNdEC3cjKx+Ft
         uNYvHci8NrjthFoENPxFiKuAKVQoMWzKPEMpKL/+DqJ+jB7aIiV3TgZpfESw0GXBYNGS
         rKj6bgNZVicY3tsor0AZf7F+AD9ubJVupA919pSE4hKhCElrpSWamGXnY6KhQ58WtrQG
         M0JTrvxof/ztoV/xZmlQ2mB4G2Bo5XkGRgMONQUBJ3FpF8punRyYIESkuowt0IjWGH/r
         7lZg==
X-Forwarded-Encrypted: i=1; AJvYcCWV139UTXj6i2jSxE0fUXXACBveeB6mF/iOsijn4c/oMAVGk04HkpAj3WZk51CFaZExaNAtPRjc3nNvK8T83es9SppV
X-Gm-Message-State: AOJu0YycCWaZqIXr9ZdUHphT7MQ+EO9FZVW3Uax7Ni8pJEmITOEYZi+Y
	kJ92H+Aus4ND0bpmdfW8I6wfpZugWi3RS0gAdD8823RVqkjvNU4i+cjMcm6JT6ET2iEyGGGZ/PN
	fVQ==
X-Google-Smtp-Source: AGHT+IGGPg5F3xVITgD22MhVeOLN2C5A9N7DTwy2uE0PPWyJU/iLFIj8WJZfjoHCNNmaAQgWOu404YDQs2I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:72c:b0:dda:c4ec:7db5 with SMTP id
 l12-20020a056902072c00b00ddac4ec7db5mr1295216ybt.4.1713308446874; Tue, 16 Apr
 2024 16:00:46 -0700 (PDT)
Date: Tue, 16 Apr 2024 16:00:45 -0700
In-Reply-To: <CABgObfZq9dzvq3tsPMM3D+Zn-c77QrVd2Z1gW5ZKfb5fPu_8WA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <2f1de1b7b6512280fae4ac05e77ced80a585971b.1712785629.git.isaku.yamahata@intel.com>
 <116179545fafbf39ed01e1f0f5ac76e0467fc09a.camel@intel.com>
 <Zh2ZTt4tXXg0f0d9@google.com> <CABgObfZq9dzvq3tsPMM3D+Zn-c77QrVd2Z1gW5ZKfb5fPu_8WA@mail.gmail.com>
Message-ID: <Zh8DHbb8FzoVErgX@google.com>
Subject: Re: [PATCH v2 07/10] KVM: x86: Always populate L1 GPA for KVM_MAP_MEMORY
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"federico.parola@polito.it" <federico.parola@polito.it>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2024, Paolo Bonzini wrote:
> On Mon, Apr 15, 2024 at 11:17=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > The first question to answer is, do we want to return an error or "sile=
ntly"
> > install mappings for !SMM, !guest_mode.  And so this option becomes rel=
evant only
> > _if_ we want to unconditionally install mappings for the 'base" mode.
> >
> > > > - Return error on guest mode or SMM mode:  Without this patch.
> > > >   Pros: No additional patch.
> > > >   Cons: Difficult to use.
> > >
> > > Hmm... For the non-TDX use cases this is just an optimization, right?=
 For TDX
> > > there shouldn't be an issue. If so, maybe this last one is not so hor=
rible.
>=20
> It doesn't even have to be ABI that it gives an error. As you say,
> this ioctl can just be advisory only for !confidential machines. Even
> if it were implemented, the shadow MMU can drop roots at any moment

Sure, but there's a difference between KVM _potentially_ dropping roots and
guaranteed failure because userspace is trying to do something that's unsup=
ported.
But I think this is a non-issue, because it should really just be as simple=
 as:

	if (!mmu->pre_map_memory)
		return -EOPNOTSUPP;

Hmm, or probably this to avoid adding an MMU hook for a single MMU flavor:

	if (!tdp_mmu_enabled || !mmu->root_role.direct)
		return -EOPNOTSUPP;

> and/or kill the mapping via the shrinker.

Ugh, we really need to kill that code.

> That said, I can't fully shake the feeling that this ioctl should be
> an error for !TDX and that TDX_INIT_MEM_REGION wasn't that bad. The
> implementation was ugly but the API was fine.=20

Hmm, but IMO the implementation was ugly in no small part because of the co=
ntraints
put on KVM by the API.  Mapping S-EPT *and* doing TDH.MEM.PAGE.ADD in the s=
ame
ioctl() forced KVM to operate on vcpu0, and necessitated shoving temporary =
data
into a per-VM structure in order to get the source contents into TDH.MEM.PA=
GE.ADD.

We could eliminate the vcpu0 grossness, but it would require a massive refa=
ctor,
which is also not a problem per se, but it's obviously not free.  Eliminati=
ng
kvm_tdx.source_page is also doable, but it's not clear to me that end resul=
t would
be a net positive.

If userspace pre-maps the S-EPT entries ahead of time, then KVM should have=
 a
straight shot to PAGE.ADD, i.e. doesn't need to "pass" the source page via =
a
scratch field in kvm_tdx, and I think/hope would avoid the need to grab vcp=
u0
in order to get at an MMU to build the S-EPT.

And stating the obvious, TDX_INIT_MEM_REGION also doesn't allow pre-mapping=
 memory,
which is generally useful, and can be especially beneficial for confidentia=
l VMs
(and TDX in particular) due to the added cost of a page fault VM-Exit.

I'm not dead set on this generic ioctl(), but unless it ends up being a tra=
in wreck
for userspace, I think it will allow for cleaner and more reusable code in =
KVM.


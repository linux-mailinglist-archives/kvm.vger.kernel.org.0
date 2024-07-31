Return-Path: <kvm+bounces-22793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A86AC943313
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:22:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA8541C218B3
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 832351BD4F6;
	Wed, 31 Jul 2024 15:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FAfUbDq8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F221BC06D
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722439205; cv=none; b=FAGB5GMNKTfnhtBkgPuJrxBY8zCQ5QbQZqQB7uhIvdcCZQth4SmklGkVexiwHPSIaHB9YkLaNv3+lEeABAqxh8rBDUnSxvKSvDOY+KVFGJuyl7VwZ3H2O4racG5tXmWtSW68phohvHDHldWMZSBioijy83fEYSl23XZwz8SAh/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722439205; c=relaxed/simple;
	bh=mrnvQl6M+lb/gTQFQ85ejkCOiwiHss34vbITuDkqy5c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fYjxRwN+6tO+beA96I4si6TNNc5MJwodWaLAbcNZgz2CdbfiMriBUq25IYDWCxEg5xrMnoHpAwKepCcCK4aQFsnAML733bLKGqF7Z6SgcPbWwPx/RjhJIfmpUPODBk75DGCQ5JuNPWOysX0bWY5qI72Z8RITESpaujoPqZpbU2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FAfUbDq8; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-650fccfd1dfso105493397b3.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 08:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722439203; x=1723044003; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+awCnTQ6n6w0kReOKqFcxkIXj5QkErgyYJsc3T/RE3k=;
        b=FAfUbDq8Gb7FiRiYhZvQzWZTus2szjlVXl4ruAlQtmiq+6Yy+KMBeh2pSJx3I8uG5c
         Hg7cJYYOpSiW2GFqMKEO1Ro8XmFTZnUmImTg5bcVQ2nFeDTb4VWUHpjr1LH8BxpKJLhk
         I04lx5LHulGtsjPECWXbpLf9WagimgKewzu8q+qBCEkMKv1QZ79ApY4v4MSruwZO2xyi
         xnxewVstaGV2SzLwR5Q68JkvyAfgPlX2vc4tjz9XIuwIC/eb+IDgnzLJgPFyLBMfWVtE
         45WqTaXI8SMHEvLxVialdg9rFo8jFCB8ezoGdsQJn1E+0bdUNH6ThPLhT1QTvmXgl6Ik
         CUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722439203; x=1723044003;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+awCnTQ6n6w0kReOKqFcxkIXj5QkErgyYJsc3T/RE3k=;
        b=lqYZsi3gCjgvjwWvtKsZ/NO40mZd0ykUJFJyoUYjv8w8Lw6U7ek6fj3I2EOBIEccbT
         Cyy7cyz4OlOgaT5lpUJsGTQWktx7FN3XtTs+2bHejUoC5pP7CEyy8zYIgHF3maMaQl1d
         8B0BIBTwNU7JbgXSm2wQuL/hArS68hxwSX3DpDFfeeiaO5fu+EzPkR4FGB3yiGcN3Yuy
         jg3b8TY+HmZM6dD/1oQPHTA/7u25EgtI+g5rVIeHXobqqLbpegy6A9a7QWPeBDAEMSgf
         vTug6M/E8m11g1v6N/awjV+i44dFnm0SJBb/oU7pjvHOwuaZ7tiyjd+UR/95Kkou7g5D
         rEsA==
X-Forwarded-Encrypted: i=1; AJvYcCUcqwpg4e8IyHaTroHcxlhsoOE+k3QefwkY1bfV+xLoq9518J8HqP8PA5ivkapjS7Dr1E78TiOnkUDSrphzkdE1W9Zn
X-Gm-Message-State: AOJu0Yz/ikOdkDaX7jTvufNyS23/pHy/db24cxyKBvdYNL5Sek6DGz66
	2WJ7D8rnpykLB2L3WRYZXwLZyDXW9Ujbq+IEcYTvkgSLdOMNRoBjIuqONECc64UHqEGg8PlVABA
	q7Q==
X-Google-Smtp-Source: AGHT+IHkbvLVC/6tbuP4uZAhmbZgdzd7NoE0b5j4mmANdCAtR4G9YeAyrN7wTLF0fWbNpjsi5YL6he30vJc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:ece:b0:62f:f535:f2c with SMTP id
 00721157ae682-67a053db18cmr4236867b3.2.1722439203063; Wed, 31 Jul 2024
 08:20:03 -0700 (PDT)
Date: Wed, 31 Jul 2024 08:20:01 -0700
In-Reply-To: <CABgObfb2MX_ZAX3Mz=2E0PwMp2p9XK+BrHXQ-tN0=MS+1BGsHg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240730053215.33768-1-flyingpeng@tencent.com>
 <db00e68b-2b34-49e1-aa72-425a35534762@redhat.com> <ZqlMob2o-97KsB8t@google.com>
 <CAPm50aLGRrK12ZSJzYadqO7Z7hM25NyXPdCD1sg_dTPCKKhJ-w@mail.gmail.com>
 <2e66f368-4502-4604-a98f-d8afb43413eb@redhat.com> <CAPm50aJ2RtxM4bQE9Mq5Fz1tQy85K_eVW7cyKX3-n4o7H07YvQ@mail.gmail.com>
 <CABgObfb2MX_ZAX3Mz=2E0PwMp2p9XK+BrHXQ-tN0=MS+1BGsHg@mail.gmail.com>
Message-ID: <ZqpWIXR1I53SD1-7@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Conditionally call kvm_zap_obsolete_pages
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hao Peng <flyingpenghao@gmail.com>, kvm@vger.kernel.org, 
	Peng Hao <flyingpeng@tencent.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024, Paolo Bonzini wrote:
> On Wed, Jul 31, 2024 at 1:19=E2=80=AFPM Hao Peng <flyingpenghao@gmail.com=
> wrote:
> > > So if anything you could check list_empty(&kvm->arch.active_mmu_pages=
)
> > > before the loop of kvm_zap_obsolete_pages(), similar to what is done =
in
> > > kvm_mmu_zap_oldest_mmu_pages().  I doubt it can have any practical
> > > benefit, though.
> >
> > I did some tests, when ept=3D0,  kvm_zap_obsolete_pages was called 42
> > times, and only 17 times
> > active_mmu_page list was not empty. When tdp_mmu was enabled,
> > active_mmu_page list
> > was always empty.
>=20
> Did you also test with nested virtual machines running?
>=20
> In any case, we're talking of a difference of about 100 instructions
> at most, so it's irrelevant.

It's not even remotely close to 100 instructions.  It's not even 10 instruc=
tions.
It's 3 instructions, and maybe two uops?

Modern compilers are smart enough to optimize usage of kvm_mmu_commit_zap_p=
age()
so that the caller inlines the list_empty(invalid_list) check, but the guts=
 of
the zap code are non-inlined.

So, as is, the generated code is:

   0x00000000000599a7 <+55>:	mov    0x8d40(%r12),%rbp
   0x00000000000599af <+63>:	cmp    %rbp,%r15
   0x00000000000599b2 <+66>:	mov    0x8(%rbp),%rbx
   0x00000000000599b6 <+70>:	je     0x599d6 <kvm_zap_obsolete_pages+102>

   0x00000000000599d6 <+102>:	mov    0x8d48(%r12),%rax
   0x00000000000599de <+110>:	cmp    %r14,%rax
   0x00000000000599e1 <+113>:	je     0x59a5f <kvm_zap_obsolete_pages+239>

   0x0000000000059a5f <+239>:	mov    0x8(%rsp),%rax
   0x0000000000059a64 <+244>:	sub    %gs:0x28,%rax
   0x0000000000059a6d <+253>:	jne    0x59a86 <kvm_zap_obsolete_pages+278>
   0x0000000000059a6f <+255>:	add    $0x10,%rsp
   0x0000000000059a73 <+259>:	pop    %rbx
   0x0000000000059a74 <+260>:	pop    %rbp
   0x0000000000059a75 <+261>:	pop    %r12
   0x0000000000059a77 <+263>:	pop    %r13
   0x0000000000059a79 <+265>:	pop    %r14
   0x0000000000059a7b <+267>:	pop    %r15
   0x0000000000059a7d <+269>:	ret

and adding an extra list_empty(kvm->arch.active_mmu_pages) generates:

   0x000000000005999a <+42>:	mov    0x8d38(%rdi),%rax
   0x00000000000599a1 <+49>:	cmp    %rax,%r15
   0x00000000000599a4 <+52>:	je     0x59a6f <kvm_zap_obsolete_pages+255>

   0x0000000000059a6f <+255>:	mov    0x8(%rsp),%rax
   0x0000000000059a74 <+260>:	sub    %gs:0x28,%rax
   0x0000000000059a7d <+269>:	jne    0x59a96 <kvm_zap_obsolete_pages+294>
   0x0000000000059a7f <+271>:	add    $0x10,%rsp
   0x0000000000059a83 <+275>:	pop    %rbx
   0x0000000000059a84 <+276>:	pop    %rbp
   0x0000000000059a85 <+277>:	pop    %r12
   0x0000000000059a87 <+279>:	pop    %r13
   0x0000000000059a89 <+281>:	pop    %r14
   0x0000000000059a8b <+283>:	pop    %r15
   0x0000000000059a8d <+285>:	ret

i.e. it elides the list_empty(invalid_list) check, that's it.


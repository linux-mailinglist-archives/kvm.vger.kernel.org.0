Return-Path: <kvm+bounces-8241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90CA384CE1E
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 16:35:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CFB01F25C90
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 15:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7D167FBBD;
	Wed,  7 Feb 2024 15:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jB0s7ann"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE157F7F2
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 15:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707320111; cv=none; b=n81TVeOM1hir/DfCDHIa6YKW/lL6O40VNZuEA0bf+lu7Q5NyzJblIQIJvqddI09nlWimC3kr9IWiR7ibEo6yDv7P2S0yyYZ5MV/e/eykxeIGZYW+GLwcp4j6gEU3EyrCZ9o8PO8kIj8RLM03xv+DfMCLSkzRkjYWDpBYX3on/4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707320111; c=relaxed/simple;
	bh=CwV1A4uK5GmAyxOXYq/FsdNF/7KtFozivV5RY9X8wcw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=En4MgJcyZ1mbxhPcRJa9fLxa2kLDw7MxQKv0I2+RRWGoTLHI0tHkCraAmmINK503pPRvFDXntuyUXXCWMCJn/d5GeFiwulY9T0HxF1mELYpS9HiIRUPmJ1w1Hr/GmlVnFRbysQREY8TWInvgj84yUi2wc84kHqyuqYNfg4OfBMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jB0s7ann; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e0519304b2so750265b3a.3
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 07:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707320109; x=1707924909; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wSeG2eqmAx2jExNdfFUztfiEkREy+BFe1695QlzXVIE=;
        b=jB0s7annSwYndBpO1fJd4csvDusrcJeeeVzUA7a2pZtOckHbcPKOtXrFiyIHEU9O1L
         kFdJ1b1HJgsGE5mM/dvF7W9K0Bq830aKoICi+WhCba7wziF+74ckE36SlwdbWfnJH4vg
         QXjpEBoWh96ZY7lDi5FcqXfZwjqzBPfW9qq9Soi3EaoBI5v3Vd4TuLYmRVkMjv9yp52O
         u/BuKG+tA9CeS0OfAR1E3wBBea8Jgn8385moT8Tb27lo+AKPr5cBFzBVNRw//YFSwz4y
         lIA6Vv8InHcplIS5jdpxvXfEZ6SPpHki9N8PK1iHj9AqYlwyPbhzm0k+s+DrD6kGNAGf
         OUBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707320109; x=1707924909;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wSeG2eqmAx2jExNdfFUztfiEkREy+BFe1695QlzXVIE=;
        b=WD27Cwa+1bF2fw01SGpTtCNUGjGvhQRLSAshARPZAEsOfumru3I2B8DaWSkqMmkpFI
         wmmseSSKhfZ5C57lBhD8W4v4Kev1IgaosAiebHTR2Cqr8aeqOzCIQNIv4QF9DBnFI5Mu
         xH5snV1kkBU/9PqtGDbGrYvty+myz3zujMFQiLgEVIpb3MVOIQLO7U0iuSLBGcTiJ1Q1
         JgUdGdfLxgIgOKP/vm07etytJRJPLU9RMpyISF2CfvZiap4iNLvDowOxmV+ML8be50Zu
         znopO5qkp+OlXQ1ujymeo/dFi+QOYcsNybkOsAtUGMWcUvJypPfHXgbsPDpjHuhB9OVh
         5hWQ==
X-Gm-Message-State: AOJu0Yz+d5taHmJKoRJ54vtExcKV/hzn2YwfYDc1zCJ2aixY3PEFThbf
	vpDf/0xLvqRRDu4iWSns8zSvO0lU8vLFZOcUcxrg9e7b+w8MEcOT8x5EEP3J6dxBMWVGfypvS6K
	F/w==
X-Google-Smtp-Source: AGHT+IGsbkoD2FJ2/8WDV2J4uygfhhxJUf4mK7R3Ftk1NHOFsCN9F7TwWUTEGOj7G2AbtTdqxQxgnbqaH5M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d84:b0:6e0:3f5d:8222 with SMTP id
 fb4-20020a056a002d8400b006e03f5d8222mr125395pfb.3.1707320108692; Wed, 07 Feb
 2024 07:35:08 -0800 (PST)
Date: Wed, 7 Feb 2024 07:35:07 -0800
In-Reply-To: <CAF7b7morHn_-WQBPFexpS_Eb-bXSyu_7CCf-EpBWbAvxReWZXg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
 <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
 <ZbvCU5wPAnePJZtI@google.com> <CAF7b7morHn_-WQBPFexpS_Eb-bXSyu_7CCf-EpBWbAvxReWZXg@mail.gmail.com>
Message-ID: <ZcOjK9UzmCzu8s0r@google.com>
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 01, 2024, Anish Moorthy wrote:
> On Thu, Feb 1, 2024 at 8:09=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Wed, Jan 31, 2024, Anish Moorthy wrote:
> > > On Tue, Jan 30, 2024 at 4:26=E2=80=AFPM James Houghton <jthoughton@go=
ogle.com> wrote:
> > > >
> > > > Feel free to add:
> > > >
> > > > Reviewed-by: James Houghton <jthoughton@google.com>
> > >
> > > > If we include KVM_MEM_GUEST_MEMFD here, we should point the reader =
to
> > > > KVM_SET_USER_MEMORY_REGION2 and explain that using
> > > > KVM_SET_USER_MEMORY_REGION with this flag will always fail.
> > >
> > > Done and done (I've split the guest memfd doc update off into its own
> > > commit too).
> > >
> > > > > @@ -3070,6 +3074,15 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struc=
t kvm_memory_slot *slot, gfn_t gfn,
> > > > >                 writable =3D NULL;
> > > > >         }
> > > > >
> > > > > +       if (!atomic && can_exit_on_missing
> > > > > +           && kvm_is_slot_exit_on_missing(slot)) {
> >
> > Operators go on the preceding line:
>=20
> Thanks. On a side note, is this actually documented anywhere? I
> searched coding-style.rst but couldn't find it.

Maybe?  But the fact there are very few, if any, patterns like this in KVM =
should
be a big clue that it's not the One True Way.  The formal docs will never b=
e 100%
complete, and preferences do evolve and change, but if your code sticks out=
 like
a sore thumb, odds are good you're doing something wrong.


Return-Path: <kvm+bounces-42591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D54C5A7A5BE
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 16:55:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D895188BE7F
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 14:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A233250BF3;
	Thu,  3 Apr 2025 14:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vsy700o/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078F92505BF
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 14:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743691982; cv=none; b=pgDxRdSlWCmvWxACRG8s/RILKwLbOAKgId22sq7pwVLYfCas7n1n1eRAcXsumLKrBdhjsU0Hd7zpNErzNqH7s2gLKlFj2wU3RMjZWbQd/wTcE4YG5XeF3L4lSJKRP8zhPbD2ZQFkig7R1F35GHfpR8/vJYM4qFEE/7fz1hv8MnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743691982; c=relaxed/simple;
	bh=AVdSxJIcU4RKxuhGNXbCgFqmfGPH+Nz+W+zhYxQaoGw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QOgZZlW2TX5q+jCVqrBisehc2CYLkzNosiaY9ujYlDpwQZbSTsRpq4Eb2LpHrbrw1eVfXLxj3LyygSwtGILECJelOq2sFdxPWzl9t0qvHMKsP0DWFrpeCwmWlY1RQyIZulbbZBpzzYwbFrUOKDN459ASV22xMa4VWH+oMD8Ue7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vsy700o/; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-229668c8659so8361475ad.3
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 07:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743691980; x=1744296780; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lAYnbFZKyAbKvQrvS445eKEFXwY5377UYiGWqzU8Erc=;
        b=Vsy700o/L7mwv613GNElsvXrjFjmTWyJNJ51avYG9vCnqIzJbbj7jRb6pbxFVHQU4/
         uZIEBew3/ZBeOu1y0GYyZgSgcsqSURwXipdL68xW2rERRweWHiDfEGevMxbr2D0Fkot7
         Lz7Gs7uMEpSO/W89b2kH0nolp/Z5nbPzOV2E9fTdndmgj5DEcGtx7ViCZPglSGAe0WmO
         h1iXchw8thvAx5oKdUKD3HX2FBBDavCsGNp8fQZLUGzmIHTb055skup4gMuVCo8y0vq6
         4qqvK+W4WELmYxCKbnY76Ll7/i2K6z7HqJ2ZlVpz9VwraFoJgsOwGjFGXuk8Gb/OexuW
         FsPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743691980; x=1744296780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lAYnbFZKyAbKvQrvS445eKEFXwY5377UYiGWqzU8Erc=;
        b=IdbqnikY5v/8ilbQU09UZiW8R/xArdgHJcdza2bUpW850A7g4IMJPM65/wzI5SrCjy
         XCniAqSH+GP3hDaWg3ehQbnqvFLdfqn9h9vNM6X1OFS+08R45lWDZixPf3X5u5Rtt90+
         oQhSq34xRrerMrNn/S/c4LBAqj/NooQjJeajJN1ygAdiG8oe/yJIqR7Eh6fSYZ4YFMQ5
         oKPGYijrvJeH+BnjGYOAb7hL7FR8Fz6ihcDy52Tem6eAcSqLb3qaiEdwoMEviHVxswtR
         iMz6ldiHp4dPHqtQNZRSojahvlSNz7zXOMhRIkxLTC71ATgDSjh2mJCj7oY0Mpg+AW0F
         d5LQ==
X-Gm-Message-State: AOJu0Yx3/mT5WiTsXzuVcT7w1e+ZK7tXTssh3MH/A3UHlZ33SQB5OcR9
	df4Z3iLZztn9gArTn9Yc34ALHQaXWzEtw9BNys+wxbGdSx+GYoR3B+nsYaBs0dRGfK3faO+FHjx
	zuw==
X-Google-Smtp-Source: AGHT+IEwHAV0IdPXJuTi1AWuTFEvm067MrqutP5JF2wd5KRJr1f+gjc9bNyas3if7P/Pkfz/DaoRj5MNF4I=
X-Received: from pfbif12.prod.google.com ([2002:a05:6a00:8b0c:b0:736:38eb:5860])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e549:b0:223:4bd6:3863
 with SMTP id d9443c01a7336-2292f944b79mr343506635ad.10.1743691980164; Thu, 03
 Apr 2025 07:53:00 -0700 (PDT)
Date: Thu, 3 Apr 2025 07:52:58 -0700
In-Reply-To: <CA+EHjTzSe_TMENtx3DXamgYba-TV1ww+vtm8j8H=x4=1EHaaRA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328153133.3504118-1-tabba@google.com> <20250328153133.3504118-5-tabba@google.com>
 <Z-3UGmcCwJtaP-yF@google.com> <CA+EHjTzSe_TMENtx3DXamgYba-TV1ww+vtm8j8H=x4=1EHaaRA@mail.gmail.com>
Message-ID: <Z-6gymjL0S74plfU@google.com>
Subject: Re: [PATCH v7 4/7] KVM: guest_memfd: Folio sharing states and
 functions that manage their transition
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 03, 2025, Fuad Tabba wrote:
> Hi Sean,
> 
> On Thu, 3 Apr 2025 at 01:19, Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Mar 28, 2025, Fuad Tabba wrote:
> > > @@ -389,22 +381,211 @@ static void kvm_gmem_init_mount(void)
> > >  }
> > >
> > >  #ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > > -static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
> > > +/*
> > > + * An enum of the valid folio sharing states:
> > > + * Bit 0: set if not shared with the guest (guest cannot fault it in)
> > > + * Bit 1: set if not shared with the host (host cannot fault it in)
> > > + */
> > > +enum folio_shareability {
> > > +     KVM_GMEM_ALL_SHARED     = 0b00, /* Shared with the host and the guest. */
> > > +     KVM_GMEM_GUEST_SHARED   = 0b10, /* Shared only with the guest. */
> > > +     KVM_GMEM_NONE_SHARED    = 0b11, /* Not shared, transient state. */
> >
> > Absolutely not.  The proper way to define bitmasks is to use BIT(xxx).  Based on
> > past discussions, I suspect you went this route so that the most common value
> > is '0' to avoid extra, but that should be an implementation detail buried deep
> > in the low level xarray handling, not a
> >
> > The name is also bizarre and confusing.  To map memory into the guest as private,
> > it needs to be in KVM_GMEM_GUEST_SHARED.  That's completely unworkable.
> > Of course, it's not at all obvious that you're actually trying to create a bitmask.
> > The above looks like an inverted bitmask, but then it's used as if the values don't
> > matter.
> >
> >         return (r == KVM_GMEM_ALL_SHARED || r == KVM_GMEM_GUEST_SHARED);
> 
> Ack.
> 
> > Given that I can't think of a sane use case for allowing guest_memfd to be mapped
> > into the host but not the guest (modulo temporary demand paging scenarios), I
> > think all we need is:
> >
> >         KVM_GMEM_SHARED           = BIT(0),
> >         KVM_GMEM_INVALID          = BIT(1),
> 
> We need the third state for the transient case, i.e., when a page is
> transitioning from being shared with the host to going back to
> private, in order to ensure that neither the guest nor the host can
> install a mapping/fault it in. But I see your point.

That's KVM_GMEM_INVALID.  Translating to what you had:

  KVM_GMEM_ALL_SHARED   = KVM_GMEM_SHARED
  KVM_GMEM_GUEST_SHARED = 0
  KVM_GMEM_NONE_SHARED  = KVM_GMEM_INVALID


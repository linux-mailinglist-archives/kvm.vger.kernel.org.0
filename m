Return-Path: <kvm+bounces-45596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92C22AAC723
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 15:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECD0C4A7CD3
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 13:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB1E6278745;
	Tue,  6 May 2025 13:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tjGlUpwz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B63C280A3D
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 13:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746539889; cv=none; b=KZ0zeuFzDdVi3slzLTyCbVhMRLRdCHfzyeGQh+cRYIty1FHpgdVz9qLpNdz8OUSd7yKZ5W2mDyoYf9AiZKrJUzhbg7Tyl/IZxzwN0NGzkIhoKjtHhZGx0P54gyuO4iWgCucWsybOYS2rbROIiOsb/Yob296v8+vEh29YTn1Mrqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746539889; c=relaxed/simple;
	bh=B/1kMBr0dMDjBz8qR4hZMYey3tTkE8Ew1cHXX/tWHi0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V3YSKd//sx5O/IsieWYqMZN49qh0IZ+QkghnGahDR5pDI3blpy6uW0s3lNNUoUpG6dcgYt2wDDWdmn+Q4LS5jwU9Wz7O49DvMMQEUUmDirxJ6IMXOQSQhidgcPBq2SBKwSzmSX+f7h63+GJUHUsuvditLNh7bKaMGzrVwpHsOc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tjGlUpwz; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22650077995so82578075ad.3
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 06:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746539887; x=1747144687; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Epkui4TROaYfaMdtDACEwRS7LcO5Q0jHyiEGdQbOTDo=;
        b=tjGlUpwz88McXQxWhYoonh0UjPU2Sy5iVVVbSW6HukQuIM3vnznT+1T2x2VW2iwOGR
         6V+V0ocpNVSSzIRk/T+enLGd66j4QoP332PmiETY/1jb766m1Sw8SiDQo+HKzZtSO8JR
         R/z+twBTNbAzSdr4zYY6sDTlasG5+comauwzqFLX3DnR9XvoVJ+n4lbq8b09s30ZNzeF
         az0vlX0ta+2PoJh2sLwDTABaFe3ThRpMQ1vvBI5Z0F7o71y2rf7xkPizJ+jzjIy6LAKC
         PU8uKsi+uz+Q332lYSxrUzws6zsMimKD7PxJ4b+YKkuNKQiRYE7YIQkk478xQ7/3+1al
         P77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746539887; x=1747144687;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Epkui4TROaYfaMdtDACEwRS7LcO5Q0jHyiEGdQbOTDo=;
        b=vJBGHeqRzed1HlPN+svjx+83ZfNiaLr4iK3pLsoUK918d45Njb0pSq8udtRwIMCgIk
         bgznPM5qswOK7XuZLqbTObBEFtCi3JAI+AEhi14QAg8lupPxZ9gJsc1B6VE5Qevg0CB2
         uH0ZLILvKoMnKMP83L5+7n0+Pa/UfI+cLZcu4XGc1OVPBfi1sQDItp/XdvtXw/En48dR
         lLJZigOS4896bn8Dh5EYxop2JXx2Z+XZg8UZaM67Zof06uaeJquq+USeHifgYmNF8DDu
         QU13V+fbVO7KUbINTPPjfnv9zx9GMKZkAqmHR4nQ6o3fdjryVSl+KFp9DOxkwZXv8sP/
         NpXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCTMH/7pggFpDhPH4LryW51OLglA9Csv5GS1iqo/vTK7Fl6G6UAKLCMp4OENIsAVJbp7A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw1yhTuDxvemSNPhTD8J8+S2klPobII3w7YiGe06Pym9OBr+To
	UNGPUb/cSttRv1gyknR9Ox+Ret83RiMyvHVlK9D4lE5QziufEQ0owYyL4E0DjHTbN5buiURglel
	L1A==
X-Google-Smtp-Source: AGHT+IHreTuRAhH/wUxgD8PQxg1UOE2znzyhgkrxDm9K+FWFaiZsk+OikDER4lrfDo4rClwDb4vAN5nmo08=
X-Received: from plbml4.prod.google.com ([2002:a17:903:34c4:b0:223:536f:9461])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:8ce:b0:220:d078:eb33
 with SMTP id d9443c01a7336-22e36366425mr50533145ad.36.1746539886699; Tue, 06
 May 2025 06:58:06 -0700 (PDT)
Date: Tue, 6 May 2025 06:58:04 -0700
In-Reply-To: <CAGtprH9AVUiFsSELhmt4p24fssN2x7sXnUqn39r31GbA0h39Sw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <diqz7c31xyqs.fsf@ackerleytng-ctop.c.googlers.com>
 <386c1169-8292-43d1-846b-c50cbdc1bc65@redhat.com> <aBTxJvew1GvSczKY@google.com>
 <diqzjz6ypt9y.fsf@ackerleytng-ctop.c.googlers.com> <7e32aabe-c170-4cfc-99aa-f257d2a69364@redhat.com>
 <aBlCSGB86cp3B3zn@google.com> <CAGtprH8DW-hqxbFdyo+Mg7MddsOAnN+rpLZUOHT-msD+OwCv=Q@mail.gmail.com>
 <CAGtprH9AVUiFsSELhmt4p24fssN2x7sXnUqn39r31GbA0h39Sw@mail.gmail.com>
Message-ID: <aBoVbJZEcQ2OeXhG@google.com>
Subject: Re: [PATCH v8 06/13] KVM: x86: Generalize private fault lookups to
 guest_memfd fault lookups
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: David Hildenbrand <david@redhat.com>, Ackerley Tng <ackerleytng@google.com>, 
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 05, 2025, Vishal Annapurve wrote:
> On Mon, May 5, 2025 at 10:17=E2=80=AFPM Vishal Annapurve <vannapurve@goog=
le.com> wrote:
> >
> > On Mon, May 5, 2025 at 3:57=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > > ...
> > > > And not worry about lpage_infor for the time being, until we actual=
ly do
> > > > support larger pages.
> > >
> > > I don't want to completely punt on this, because if it gets messy, th=
en I want
> > > to know now and have a solution in hand, not find out N months from n=
ow.
> > >
> > > That said, I don't expect it to be difficult.  What we could punt on =
is
> > > performance of the lookups, which is the real reason KVM maintains th=
e rather
> > > expensive disallow_lpage array.
> > >
> > > And that said, memslots can only bind to one guest_memfd instance, so=
 I don't
> > > immediately see any reason why the guest_memfd ioctl() couldn't proce=
ss the
> > > slots that are bound to it.  I.e. why not update KVM_LPAGE_MIXED_FLAG=
 from the
> > > guest_memfd ioctl() instead of from KVM_SET_MEMORY_ATTRIBUTES?
> >
> > I am missing the point here to update KVM_LPAGE_MIXED_FLAG for the
> > scenarios where in-place memory conversion will be supported with
> > guest_memfd. As guest_memfd support for hugepages comes with the
> > design that hugepages can't have mixed attributes. i.e. max_order
> > returned by get_pfn will always have the same attributes for the folio
> > range.

Oh, if this will naturally be handled by guest_memfd, then do that.  I was =
purely
reacting to David's suggestion to "not worry about lpage_infor for the time=
 being,
until we actually do support larger pages".

> > Is your suggestion around using guest_memfd ioctl() to also toggle
> > memory attributes for the scenarios where guest_memfd instance doesn't
> > have in-place memory conversion feature enabled?
>=20
> Reading more into your response, I guess your suggestion is about
> covering different usecases present today and new usecases which may
> land in future, that rely on kvm_lpage_info for faster lookup. If so,
> then it should be easy to modify guest_memfd ioctl to update
> kvm_lpage_info as you suggested.

Nah, I just missed/forgot that using a single guest_memfd for private and s=
hared
would naturally need to split the folio and thus this would Just Work.


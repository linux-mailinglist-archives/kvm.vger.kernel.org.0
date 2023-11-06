Return-Path: <kvm+bounces-826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63CF57E3148
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 00:23:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF80E280F32
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 23:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 257D92FE09;
	Mon,  6 Nov 2023 23:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o6PnWpWa"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AD02EB1F
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 23:22:51 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1A81FF3
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 15:22:36 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-32fdd0774d9so379771f8f.2
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 15:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699312955; x=1699917755; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VVecUYo8dIaEffbXGnsSzKGQEUoJGHjef1Zsi2l0OOM=;
        b=o6PnWpWaUv5h7lBXwCE3qJ+qpFgm6c6l5IN76Ti/qSa/HfChmJXc3IGBxjLLykA4ck
         0dLRNmoIvj6lNFXC0//dzsOksijs5siu7ehzJGKZ6wreSZPXSGZJoVhDJOrLOQypVOYj
         8Qe8fyTsfv+x9MOJq6qzVQmwy4WWrZNmOnFXg2WN6eW+Ej4H/1tC/GHBIlklQVVMRVNh
         8yKIdu3OHaI39quhFBr+yMwQtRQ4r1JiX09ImB6RYQFolGlx/XozI/Fhk5DC3ungM5CH
         JCvHoSlYJUmvvx7PeAqvWJcaBnxn5pa3zQTo0Nt865KU904h4hu1rnUC6fxBJyJVU4Js
         omlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699312955; x=1699917755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VVecUYo8dIaEffbXGnsSzKGQEUoJGHjef1Zsi2l0OOM=;
        b=e7/OXTgFf7vzjYII6sz9ljm1gYIMekGvOY2Mn5Yi3YUxzrxhgMlb1prUppvEBpqDA2
         AHgK42xY/h5AIg62tiKaeffu5MSWClnOgYq/10T/wEtmoa6MyGbfviQOh7ze9svgUnnd
         Mq0PHjao2TO9ct1WPn1+b5ZB6IgecAIk8PukTY2LKuBalbJytSKPQAOvFGh0ZlY+w114
         d9zw20VQEEO5SBf0Vq5XeacLm/XlqCLfrhaKc/M8LyZOWMAARfgSLIYeUogcdgWUidHS
         71n/OrolvfAFbaNsP/yCQKDBPBEK5coVUvY+aln6LVfhCce6s5rKBJiUnR8PXVj8HLzA
         zhtg==
X-Gm-Message-State: AOJu0YyKKnHiezF9nyVMJWaIW7zYAgvFb2IekwvySQ0bEL4HjhDyMFtF
	RhAeDcGFptZ6EW80uEPU5RbZEMxa9DO6C04HSKDKEQ==
X-Google-Smtp-Source: AGHT+IGddgBCALaArplstUiTM3Zszws9Wl+wtLpe/tmVdJZHpvVdpCAAyugecXQ8XfNPEGRZt137jVYNUve89IJK+6o=
X-Received: by 2002:adf:e701:0:b0:32d:a242:c6ba with SMTP id
 c1-20020adfe701000000b0032da242c6bamr25265532wrm.40.1699312955204; Mon, 06
 Nov 2023 15:22:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <CAJHvVciC3URbJJMwhU0ahhzq6bomr7juuWqPdpczV6Qgb8OUuQ@mail.gmail.com>
 <ZUlw163pvpJ+Uue8@x1n>
In-Reply-To: <ZUlw163pvpJ+Uue8@x1n>
From: David Matlack <dmatlack@google.com>
Date: Mon, 6 Nov 2023 15:22:05 -0800
Message-ID: <CALzav=d=sAJBK7fBeJwi3BVJ+4ai5MjU7-u0RD4BQMGNRYi_Tw@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm list <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>, Oliver Upton <oupton@google.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 3:03=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
> On Mon, Nov 06, 2023 at 02:24:13PM -0800, Axel Rasmussen wrote:
> > On Mon, Nov 6, 2023 at 12:23=E2=80=AFPM Peter Xu <peterx@redhat.com> wr=
ote:
> > > On Mon, Nov 06, 2023 at 10:25:13AM -0800, David Matlack wrote:
> > > >
> > > >   * Memory Overhead: UserfaultFD requires an extra 8 bytes per page=
 of
> > > >     guest memory for the userspace page table entries.
> > >
> > > What is this one?
> >
> > In the way we use userfaultfd, there are two shared userspace mappings
> > - one non-UFFD registered one which is used to resolve demand paging
> > faults, and another UFFD-registered one which is handed to KVM et al
> > for the guest to use. I think David is talking about the "second"
> > mapping as overhead here, since with the KVM-based approach he's
> > describing we don't need that mapping.
>
> I see, but then is it userspace relevant?  IMHO we should discuss the
> proposal based only on the design itself, rather than relying on any
> details on possible userspace implementations if two mappings are not
> required but optional.

What I mean here is that for UserfaultFD to track accesses at
PAGE_SIZE granularity, that requires 1 PTE per page, i.e. 8 bytes per
page. Versus the KVM-based approach which only requires 1 bit per page
for the present bitmap. This is inherent in the design of UserfaultFD
because it uses PTEs to track what is present, not specific to how we
use UserfaultFD.


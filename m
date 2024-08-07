Return-Path: <kvm+bounces-23545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FEC694AB2B
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 17:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43A431C21585
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 15:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A98C84A5B;
	Wed,  7 Aug 2024 15:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EG+mZLEb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F003282499
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042985; cv=none; b=QTEo/VRgO4Ewrpq6cVUVetqTlPGciIHnyvIzwMT2L50bfTd/gYTZRQ+JZp7rSYWsK5ajnMy2sBRuj/OmeRNMNHq4+7qlYiQ5FqVSgk95QMPeEyrxsIDgp5Kb4J9gzQ61yq/1d+cWKO11OnH0Eg42RMd/DbeZCwpdA1xUFp+3CNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042985; c=relaxed/simple;
	bh=i+cKN7kvlmSwCbheJAMEk6ZSnnzPsXRqTPu/u16iMjk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lz3aV4ttsfkUYtwQoWILGPpVIHFcBzAWEmdxkrh/JXWz2BwrY6a5/ZKUURdrXKf+8AO80/2S8YWkLjEsa4y/HKhvq+xc6a8qcYcmj0orK9MeYMvgOwgDizcBxNspnHgo63wRmTttNyU6uDCZ8LkaGFAWMNxVf/NsR7rjEHSqrYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EG+mZLEb; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1fd657c9199so395435ad.1
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 08:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723042983; x=1723647783; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kl+B4ZpfEXlczthXYPnKJxRHMc3GQi5TyNP+ymJuxKA=;
        b=EG+mZLEbaT3VFrKjoBA4rnhDFCsVUYDtbW5eXWP0KEBc+bqXPU/BlUL5JRbzhT4rMS
         Sc4ygkpSSJ0+wt1MAYP1WzpaTFgyGveKsuVs7H9m50NzkjOBtEX1eeWIVqJE8YRGg3wy
         PDbyeSK4obJF60B1USCt4aKkhlCwxSYbXfktUiWP9FF2MqZWbR5mWUzItB1c8eIIaOKL
         R7uVO6cxJSxNDu9DHLCgNuGAZ0FxCx7+W2+xd4XFoTN1HBb55rxuXJPqMtIpEVq5Tv9r
         77jt+iJioUEkz1QvpNlSgf/Fmtpb0d4ZDdE3Db7yXXnClgGg8mCAYzgvI/On2H1/cTYO
         cSQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723042983; x=1723647783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kl+B4ZpfEXlczthXYPnKJxRHMc3GQi5TyNP+ymJuxKA=;
        b=xS1Rd0ylx9ktgUQlWjJh4J4BEqPO4iCZJVR2CQRsMoMUzofDx/09m50VsMRt23ihlk
         it3XcfsNV18yDsduOnTc2MAtLk6aCv3DPq4LYan5uy1DICN4yxTy4Ex7Qs+to7B4ortX
         j8SBLR+0AldkCDuQKK7HrJ5Y3LNku0NvbEcjneFToW9Ft7v950IQopA3BrjX5KvYm9+o
         TpqPeUFZx071w2+G6xsXNZmiGkD36WwtTC7q3+rX4g40A0hZ3I0I+Fi2MwUg9NcSbSfZ
         uamRpEcsmqn/1K84N6e8UdVoTWJeMPwtmK/8uqR12yx031FhcSldkUEszzrZLT/BPB2d
         5ahQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpjbpWdGHLYfheNqBYMmmSI8GrGmsD5cmlQUse22H3IluYdBMEYO+NYCzwDuOlMEDg+uWAp0o0FMr73H061ZWFIRjR
X-Gm-Message-State: AOJu0YzRN3JfVoG26GXOL7LD3ZOBkiXwdRaz815gMEQiwSbT1ubh8MeN
	MK6pxtp5O5oESQA0uyXhoPhfHMJy/uoK99O4tyVBwPcSRA5fi4jC8mSpNJrydOWNEfPzMdyRyDV
	B/zBeX7dKOB2zf5ELvN36GIVHHHTt/Nr5OU8q
X-Google-Smtp-Source: AGHT+IEr49aHCdjCgL7YLIeYK1keo+SAW0FFZJxDENp6M5+q2ZuFNNnSP3R4yjqSv3wfAioC7aVTpFhpJO2Or0Jv1jg=
X-Received: by 2002:a17:902:f547:b0:1fb:563:3c25 with SMTP id
 d9443c01a7336-20083799d8emr3462625ad.18.1723042982895; Wed, 07 Aug 2024
 08:03:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-6-jthoughton@google.com> <37ae59f2-777a-4a58-ae58-4a20066364dd@redhat.com>
 <CADrL8HUmQWDc-75p=Z2KZzHkyWCCh8xnX=+ZXm5MZ-drALjKTA@mail.gmail.com> <20240806172349.GQ676757@ziepe.ca>
In-Reply-To: <20240806172349.GQ676757@ziepe.ca>
From: James Houghton <jthoughton@google.com>
Date: Wed, 7 Aug 2024 08:02:26 -0700
Message-ID: <CADrL8HXFK=1cUS+0Z5k048U4rzpTNL634f57VtJ7TD_umrbNiA@mail.gmail.com>
Subject: Re: [PATCH v6 05/11] mm: Add fast_only bool to test_young and
 clear_young MMU notifiers
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 10:23=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Thu, Aug 01, 2024 at 04:13:40PM -0700, James Houghton wrote:
> > --- a/include/linux/mmu_notifier.h
> > +++ b/include/linux/mmu_notifier.h
> > @@ -106,6 +106,18 @@ struct mmu_notifier_ops {
> >          * clear_young is a lightweight version of clear_flush_young. L=
ike the
> >          * latter, it is supposed to test-and-clear the young/accessed =
bitflag
> >          * in the secondary pte, but it may omit flushing the secondary=
 tlb.
> > +        *
> > +        * The fast_only parameter indicates that this call should not =
block,
> > +        * and this function should not cause other MMU notifier calls =
to
> > +        * block. Usually this means that the implementation should be
> > +        * lockless.
> > +        *
> > +        * When called with fast_only, this notifier will be a no-op un=
less
> > +        * has_fast_aging is set on the struct mmu_notifier.
>
> If you add a has_fast_aging I wonder if it is better to introduce new
> ops instead? The semantics are a bit easier to explain that way

v5 implemented these with a new op[1]. *Just* having the new op is
kind of problematic -- we have yet another op to do something very
similar to what already exists. We are left with two options:
consolidate everything into a single notifier[2] or add a new
parameter to test/clear_young()[3]. The latter, implemented in this
v6, is somewhat simpler to implement (fewer LoC, reduces some
duplication in KVM), though it does indeed make the explanation for
test/clear_young() slightly more complex. I don't feel very strongly,
but unless you do, I think I just ought to stick with how the v6 does
it. :)

Thanks Jason!

[1]: https://lore.kernel.org/linux-mm/20240611002145.2078921-5-jthoughton@g=
oogle.com/
[2]: https://lore.kernel.org/linux-mm/CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9=
ZpueyifgNdGggw@mail.gmail.com/
[3]: https://lore.kernel.org/linux-mm/CADrL8HXhGFWwHt728Bg15x1YxJmS=3DWD8z=
=3DKJc_Koaah=3DOvHDwg@mail.gmail.com/


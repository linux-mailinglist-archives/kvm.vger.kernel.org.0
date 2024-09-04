Return-Path: <kvm+bounces-25901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AF2C96C4EE
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 19:07:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DC311C24D27
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 17:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC3471E1300;
	Wed,  4 Sep 2024 17:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NjhDPTtW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617DC1CC171
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 17:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725469654; cv=none; b=BpDr6IFgp8zSVatwhPpcwtp1ZouZjfGT2DvkKRZ3ZIIawZT2A65M0j+mUypsvkDW73XI86Hk8N70Trmw6A+1WnlfkiD+C8CvAzWbxKD3V1vaaS+E1VIx2y6PxenHR6iY3iqoQOfULoWOWOnwSn28R5W8OD8NUQF6scyGFbAIarU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725469654; c=relaxed/simple;
	bh=Xlgw2GMMp/03ibSeh6HYCn+WWH+tFS60FEPDSbg/2pU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L37OThbHPPhsu6h+Db7BbPWV/bve9CJ9iTZlHlqCZv02Dw/8heR4X19N7eP5cpp9p6g7fa8H6ZnQ2RDfGyuor/3xAHKRU4s3afDgA9VS9poFM6g/WBmZUXd2uXwdo1fPnQueJ/FyWs4OkRW3VoIGTRUUwrEVMraYqvrHYOLiNAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NjhDPTtW; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-429d1a9363aso2095e9.1
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 10:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725469651; x=1726074451; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xlgw2GMMp/03ibSeh6HYCn+WWH+tFS60FEPDSbg/2pU=;
        b=NjhDPTtWW2UcqBHap1r/7zYnUZl6zQCFA1orP55YjGA+qnzKSlU7J3Jl9nAeWWWLuL
         JazpnOhC4B6DzU25/0m+ph4MVwhxqOsTqQ3X3YDXJED91p/UtSr02yZrwXCRkc41Neht
         Dp7DIRzQMQAZUxmlEzHFv6LiohMq4u3rlELA/5RlQKavNhj5yadie360HHspDtg7RSN+
         jnoeVpVkplmyyKu3LazrpyQ0Uz1oNNa0k8d8CjGOu5s08DOHKjBPxOWcsWT4AQA58cwP
         3pBuN2FHJspjoLTsHmaJgHk9kHIOhOsI8ud09Ld1CQOn7cYpb8w+UNHvgrETk6Fg45Lz
         /2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725469651; x=1726074451;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xlgw2GMMp/03ibSeh6HYCn+WWH+tFS60FEPDSbg/2pU=;
        b=qEaMZNEAQhhV9Ys2KqJhwowBQCypglUK2LniJhbh8AhObJC7yY4t0Fnt+2BLzrDfwm
         yARY6+frGmIAHi5kafrqILbmuezJwUbGG15uu5XlRoUEdoui8jOPLJTZswjG9RNOWqRD
         y1trva2RVplP/hgG6Uvw7gTPen1crbeaKwODYgNyEThEydvV6NXn4/ZM/uIJQNurxgfJ
         RvCkSL4b/tbhapldgAH6ND5t45XwdPDLVQ58I90N7ypJV/ublofUId/XnLdZz3Ya2SqL
         R+ZgwRzurvBo5iO35t/6riqEdkuzQb7o31gxbRB9zkyPkXxudR892F3nHnDpUPveN8Dj
         cSLw==
X-Forwarded-Encrypted: i=1; AJvYcCWdHADxL12QTRNjuat9JN9TSfWKIpG3Q+WArj1O3YF1YkQpWI0JqI/6hizqkXehvrGnGA0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyR50DzbEi1BcylBnCtc8H0SM3ogPpsvJb4Xp8OdEFXmLwRWrhX
	dIQuUSr/2v8tFh1hJa3jQdOSm8t0MPjrqgNYG9ves1viwARkkOkd9cznoyhomecTlq68jvM+DSi
	4Dth81dD9VeGBKFpTB3LjzM2TbvZodZoFDd9q
X-Google-Smtp-Source: AGHT+IGDPmKBCRMKvig2+wSno2hrrMerXw5gQJsXdFfViNnACMu5y6zs3h8saPjc7a+y+FozaMvEKkcpnkLIwPGgoyM=
X-Received: by 2002:a05:600c:4e4e:b0:426:6edd:61a7 with SMTP id
 5b1f17b1804b1-42c95599759mr1450555e9.7.1725469650395; Wed, 04 Sep 2024
 10:07:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Zs5Z0Y8kiAEe3tSE@x1n> <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
 <20240828142422.GU3773488@nvidia.com> <CACw3F53QfJ4anR0Fk=MHJv8ad_vcG-575DX=bp7mfPpzLgUxbQ@mail.gmail.com>
 <20240828234958.GE3773488@nvidia.com> <CACw3F52dyiAyo1ijKfLUGLbh+kquwoUhGMwg4-RObSDvqxreJw@mail.gmail.com>
 <20240904155203.GJ3915968@nvidia.com> <CACw3F52qyX-Ea99zV4c8NjyWKgtqAKtNc8GP0JTcLOCOjnEajg@mail.gmail.com>
 <20240904164324.GO3915968@nvidia.com> <CACw3F53ojc+m9Xq_2go3Fdn8aVumxwmBvPgiUJgmrQP3ExdT-g@mail.gmail.com>
 <20240904170041.GR3915968@nvidia.com>
In-Reply-To: <20240904170041.GR3915968@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 4 Sep 2024 10:07:19 -0700
Message-ID: <CACw3F51F9J0UYva56TYo4pVbM0XrtHnx9AkBbfUVL1rnHzhaHA@mail.gmail.com>
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, 
	Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Borislav Petkov <bp@alien8.de>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Hildenbrand <david@redhat.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Alex Williamson <alex.williamson@redhat.com>, 
	ankita@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 10:00=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Wed, Sep 04, 2024 at 09:58:54AM -0700, Jiaqi Yan wrote:
> > On Wed, Sep 4, 2024 at 9:43=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com>=
 wrote:
> > >
> > > On Wed, Sep 04, 2024 at 09:38:22AM -0700, Jiaqi Yan wrote:
> > > > On Wed, Sep 4, 2024 at 8:52=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.=
com> wrote:
> > > > >
> > > > > On Thu, Aug 29, 2024 at 12:21:39PM -0700, Jiaqi Yan wrote:
> > > > >
> > > > > > I think we still want to attempt to SIGBUS userspace, regardles=
s of
> > > > > > doing unmap_mapping_range or not.
> > > > >
> > > > > IMHO we need to eliminate this path if we actually want to keep t=
hings
> > > > > mapped.
> > > > >
> > > > > There is no way to generate the SIGBUS without poking a 4k hole i=
n the
> > > > > 1G page, as only that 4k should get SIGBUS, every other byte of t=
he 1G
> > > > > is clean.
> > > >
> > > > Ah, sorry I wasn't clear. The SIGBUS will be only for poisoned PFN;
> > > > clean PFNs under the same PUD/PMD for sure don't need any SIGBUS,
> > > > which is the whole purpose of not unmapping.
> > >
> > > You can't get a SIGBUS if the things are still mapped. This is why th=
e
> > > SIGBUS flow requires poking a non-present hole around the poisoned
> > > memory.
> > >
> > > So keeping things mapped at 1G also means giving up on SIGBUS.
> >
> > SIGBUS during page fault is definitely impossible when memory is still
> > mapped, but the platform still MCE or SEA in case of poison
> > consumption, right? So I wanted to propose new code to SIGBUS (either
> > BUS_MCEERR_AR or BUS_OBJERR) as long as the platform notifies the
> > kernel in the synchronous poison consumption context, e.g. MCE on X86
> > and SEA on ARM64.
>
> So you want a SIGBUS that is delivered asynchronously instead of via
> the page fault handler? Something like that is sort of what I ment by
> "eliminate this path", though I didn't think keeping an async SIGBUS
> was an option?

Not really, I don't think an SIGBUS *async* to the poison consuming
thread is critical, at least not as useful as SIGBUS *sync* to the
poison consuming thread.

>
> Jason


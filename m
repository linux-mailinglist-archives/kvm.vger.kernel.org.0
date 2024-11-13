Return-Path: <kvm+bounces-31697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 32A749C66DD
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 02:45:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2CF71F25644
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 01:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A984C62E;
	Wed, 13 Nov 2024 01:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cIifM1pP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E7F22611
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 01:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731462342; cv=none; b=lzix9CS8Ujb8nGkm7vu5B/TReSFnsLl/9sxrNm04g9mkZ9TDkVSimPZvQwvnbR4IVh2HCdOKn5FQ5Tm6cK3K/R/wj06pO22ob3NELWPB3GszxhEKsVb3j1mvj4Cs+qZjvAdlSEv8gg6t9nqkvy7K5y6NCvssglE8KA5Zpck2sYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731462342; c=relaxed/simple;
	bh=IHqK+x1Y09bwvF/XCMLoniBLajGJIlrCvJ2pbrpso1k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SnTQG6m0AZnI58RtibSD8E8uLBh6nP7NYlPS+lpE6Rgn4ChK5hb1QNKa60uQKxaFhI5V5s8yFVa2R3aKahNsXVLmaMhqzLc3JjxMJSRP8mkOaFpjyJnbgWZrRP7wJNTvmo7mTleY+AubtHjNCXOXgvh6XFdFwIy55uG2YlK7Nbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cIifM1pP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731462338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4PfKM7yVBtn6DsluopLq3/TSPiAd2245iTdr55Tku6s=;
	b=cIifM1pPGWYMXd1wUAbEI04mUJS78d2fvmoh7sbSFEfDk4Fa8g+bIU+G2HYcddINGAoZr/
	JqilwqppbKBmv7B338Pn52HXIEl2DOsS+kh90cOQyE93xx6uBBTZ6FTnCs8Wey/G+NQHOO
	k09fKCwYMdYhl5aCpPTN+ajihlOMtJM=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-HJVAFhxINZCcR4UFXjlMTA-1; Tue, 12 Nov 2024 20:45:37 -0500
X-MC-Unique: HJVAFhxINZCcR4UFXjlMTA-1
X-Mimecast-MFC-AGG-ID: HJVAFhxINZCcR4UFXjlMTA
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2e9b2c5189fso5980812a91.0
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 17:45:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731462336; x=1732067136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4PfKM7yVBtn6DsluopLq3/TSPiAd2245iTdr55Tku6s=;
        b=m8P/m96gE/El3JZMzvfzlwlPtHp5pNHvXXH0Pxs4CGHCdYz36LYj+l7G4fvOXMuhV9
         yg6cFxckiTMHHIIZHWwnVzjgBwJ81QGB4JYZxS2WzozeCnG7BaLvdJZZyR9iqfDg0kN0
         EjcbKSojVaPLQK0Af3yLF9qalJ2LZgxOkXiRIfiSv1NfPkL4kCbC9IjC5T/UlJowB8tX
         b8P87ACOWaXKSCtHKXmUI70bZEL+SrDpSuUqOule7Pmx6a+R2kyHAPysvFIyLHz1Di3C
         SECpf6iW1xEtTheHiY92Eo2oSFOeMoYg0vcjdqhRqVuEEnVIPGJzDHpq9ZM2eAn7lrlF
         9jJg==
X-Forwarded-Encrypted: i=1; AJvYcCUggzBpJ7K1PPQUP7xSXVU7xu8T+Yb50HPiVbxv8+j8Sl0EEvdY7M2myc8tipiFOXdTnk8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiagArZo1bKx8g1SlCCDb1/5FozEvT976ixmF2MxHM8XFatdIA
	GjCCZUvEF9c464kIAxyjTkSR654GqtIRTl0ywcDoet8tXcEs/g5DVJ7ln+gd7dsB8wqS33zisHv
	mEm2iwVx/YuTT2O98+R2dQm1btXvBGbc62AULdqmCaz1fR6dF8lBVsRroBVa06YgxXPfRyqvGUT
	Ze/7KxgaRes+cMSTpvzVNkQad0
X-Received: by 2002:a17:90b:2688:b0:2e2:cd80:4d44 with SMTP id 98e67ed59e1d1-2e9f2d5e8e7mr1164937a91.28.1731462336101;
        Tue, 12 Nov 2024 17:45:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGpt28y46cAkPewPR7Xrwmv966EDN/L2ttyudwenZUFGZgN49d7cCsAg3yPz/0wpucLUNN5z0msD0DruQuHYlQ=
X-Received: by 2002:a17:90b:2688:b0:2e2:cd80:4d44 with SMTP id
 98e67ed59e1d1-2e9f2d5e8e7mr1164913a91.28.1731462335659; Tue, 12 Nov 2024
 17:45:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241021134040.975221-1-dtatulea@nvidia.com> <8e93cd9e-7237-4863-a5a7-a6561d5ca015@nvidia.com>
In-Reply-To: <8e93cd9e-7237-4863-a5a7-a6561d5ca015@nvidia.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 13 Nov 2024 09:45:22 +0800
Message-ID: <CACGkMEtALWqmoyOBu8vywnk=SuU=N1zKt7sxwueKkYQi3LB0MQ@mail.gmail.com>
Subject: Re: [PATCH vhost 0/2] vdpa/mlx5: Iova mapping related fixes
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev, 
	Si-Wei Liu <si-wei.liu@oracle.com>, Eugenio Perez Martin <eperezma@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11, 2024 at 4:58=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
>
>
> On 21.10.24 15:40, Dragos Tatulea wrote:
> > Here are 2 fixes from Si-Wei:
> > - The first one is an important fix that has to be applied as far
> >   back as possible (hence CC'ing linux-stable).
> > - The second is more of an improvement. That's why it doesn't have the
> >   Fixes tag.
> >
> > I'd like to thank Si-Wei for the effort of finding and fixing these
> > issues. Especially the first issue which was very well hidden and
> > was there since day 1.
> >
> > Si-Wei Liu (2):
> >   vdpa/mlx5: Fix PA offset with unaligned starting iotlb map
> >   vdpa/mlx5: Fix suboptimal range on iotlb iteration
> >
> >  drivers/vdpa/mlx5/core/mr.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> Gentle nudge for a review. The bug fixed by the first patch is a very
> serious and insidious one.

I think I've acked to those patches, have you received that?

Thanks

>
> Thanks,
> Dragos
>
>



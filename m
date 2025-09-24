Return-Path: <kvm+bounces-58625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0BE9B98E64
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 10:33:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 319EE1884EF0
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 08:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FAED285CB6;
	Wed, 24 Sep 2025 08:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fizYTUlT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396D2283FF8
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 08:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758702664; cv=none; b=oBQ/LvySt1irw/cAUtOW2BN08j/we6khTY2UbqA4kPk1ThUDXY7KqoZpBsqfbxZ4AbCbiIe6SWzbdnHfujJZKqJb4OUeGAEefSE+o+gfTfL3xpjaAvJJmPlAtktf8pP5wMB1o1F2kbji8a0VnTs50QhX4TK/6v4MDThARif2g04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758702664; c=relaxed/simple;
	bh=tvDkOCfsuaQ7GYS4gx1Mnhg3p9IRHU5mftTan4zgXSM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=giOCd6Z4WMXzq506nF1oMWt+k5Pzj25aSeFNgVnq2qVw3K6yoPQgt8ERODq5r/DkSGa0CTNny1Hi5WaO+biwxn1N02W7Jwt22YlHU0gYc994XAfQJ47jZmBbOFPcHNfySjqcA+IF4NsNfNyqbUyQT4tYlidCVKcxEYerImBbKaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fizYTUlT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758702662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tvDkOCfsuaQ7GYS4gx1Mnhg3p9IRHU5mftTan4zgXSM=;
	b=fizYTUlTM92NULZQOUlyVi/eefquuLTErqxvWr16jy8AFVY+0d2qiECPFgQnhhwhzKJ9tk
	+J0JOraVWVW5Ke//TfRMfWR+LuDWLI28RoKCBclM0Xr6ykNlzWEgEN6toxlFazrys3ivyS
	yHn8LiH4NCg6cAEzoT0MRA4MMw2Qb1Q=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-5m-os49HNf278SoyaxsdGg-1; Wed, 24 Sep 2025 04:31:00 -0400
X-MC-Unique: 5m-os49HNf278SoyaxsdGg-1
X-Mimecast-MFC-AGG-ID: 5m-os49HNf278SoyaxsdGg_1758702659
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3307af9b595so4611536a91.0
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 01:31:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758702659; x=1759307459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tvDkOCfsuaQ7GYS4gx1Mnhg3p9IRHU5mftTan4zgXSM=;
        b=FUj/SrYGbOgyHhqo2iCdu6YNTvaKQ6NUxGf1etcNchigkQfUsdj8wsMbv1/XgW33Ob
         ZfYKXJIZ7o7xgT8lRh2KTVPFcS972Zt4zzik9F9IhBG5iq9h+FNoPL8Ivj63wFnGhA1o
         YjegoTyV/myzBjrnt9+bWdQ+ozpX4luAIJNce2oj61UOTP+HSvxwghbGyyy6B8DQKsJo
         pQxn4tekH9JHjLV4Psy2VbBqxkOpYxHUSQgKmLBxpDJxrQ42otoQVwWdIrHgifDOf1MV
         WR2ODiCzIdD+iUGdVUVyWw7pCHeEgHyy9mxFZk9QUbQt+7ajs1Vg1qs+fHvRA7Zf/TCS
         lMUQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/r1mtYXXmuiD7pT/gnGGSGYJ+vwZ/S3mXE0IssBcxD8SLZ0bLvHECMdf/ESmN+YOSczw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzVGi0GdAQVywMUKBPEk0m4BofqLBjngWPB30cBpQlcEPv7aGy
	tOZrjH5P/zadHR1pdHB2Qcj9EabpswPN3NtqyeiqvBmrWcmmzekam118gHi4Kg/NPOK3EbyC7Hy
	l/GuEjijL9HzqBhJ1LDiOXvdApfOVMmjh1/7I4JU3+WVd5MSnFyO5IRDITKpcDeJPoP9hjmyhq8
	3+otH989k7DJPAgyQUjvOuConWmhqb
X-Gm-Gg: ASbGncuu8nEiON/wGS4ewdIL3VVLFwLy7Xi2ljb5C58t+kMtD1VEdW+5L98PStFsOQQ
	jB/W7hxuDMhvO3Ipaj1xpSLJ30Iw+txAtKUSSwbW5bGBN7M16+kOqMoboPA1ebBhHRetFCQXXrM
	IbIHi8VS/I/YxESkNTXA==
X-Received: by 2002:a17:90b:54cb:b0:332:250e:eec8 with SMTP id 98e67ed59e1d1-332a9513715mr7286804a91.15.1758702659077;
        Wed, 24 Sep 2025 01:30:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSuHUP7PGnJisv3R6suoi7mEFCXCrr7ybnyTOFly8Wrp69Kyr1dy9P3+Fdf6NLo31cwCaZ5AfWhe2/V/RdhQ0=
X-Received: by 2002:a17:90b:54cb:b0:332:250e:eec8 with SMTP id
 98e67ed59e1d1-332a9513715mr7286747a91.15.1758702658536; Wed, 24 Sep 2025
 01:30:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
 <20250924031105-mutt-send-email-mst@kernel.org> <CACGkMEuriTgw4+bFPiPU-1ptipt-WKvHdavM53ANwkr=iSvYYg@mail.gmail.com>
 <20250924034112-mutt-send-email-mst@kernel.org> <CACGkMEtdQ8j0AXttjLyPNSKq9-s0tSJPzRtKcWhXTF3M_PkVLQ@mail.gmail.com>
 <20250924040915-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250924040915-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 24 Sep 2025 16:30:45 +0800
X-Gm-Features: AS18NWC70PosrkMr5g8LAeoMZx5xvquUOdY0YTAw2VzbuPvii9GWMNdWpFU8UFA
Message-ID: <CACGkMEtfbZv+6BYT-oph1r8HsFTL0dVxcfsEwC6T-OvHOA1Ciw@mail.gmail.com>
Subject: Re: [PATCH net-next v5 0/8] TUN/TAP & vhost_net: netdev queue flow
 control to avoid ptr_ring tail drop
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>, willemdebruijn.kernel@gmail.com, 
	eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2025 at 4:10=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Wed, Sep 24, 2025 at 04:08:33PM +0800, Jason Wang wrote:
> > On Wed, Sep 24, 2025 at 3:42=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > >
> > > On Wed, Sep 24, 2025 at 03:33:08PM +0800, Jason Wang wrote:
> > > > On Wed, Sep 24, 2025 at 3:18=E2=80=AFPM Michael S. Tsirkin <mst@red=
hat.com> wrote:
> > > > >
> > > > > On Tue, Sep 23, 2025 at 12:15:45AM +0200, Simon Schippers wrote:
> > > > > > This patch series deals with TUN, TAP and vhost_net which drop =
incoming
> > > > > > SKBs whenever their internal ptr_ring buffer is full. Instead, =
with this
> > > > > > patch series, the associated netdev queue is stopped before thi=
s happens.
> > > > > > This allows the connected qdisc to function correctly as report=
ed by [1]
> > > > > > and improves application-layer performance, see our paper [2]. =
Meanwhile
> > > > > > the theoretical performance differs only slightly:
> > > > >
> > > > >
> > > > > About this whole approach.
> > > > > What if userspace is not consuming packets?
> > > > > Won't the watchdog warnings appear?
> > > > > Is it safe to allow userspace to block a tx queue
> > > > > indefinitely?
> > > >
> > > > I think it's safe as it's a userspace device, there's no way to
> > > > guarantee the userspace can process the packet in time (so no watch=
dog
> > > > for TUN).
> > > >
> > > > Thanks
> > >
> > > Hmm. Anyway, I guess if we ever want to enable timeout for tun,
> > > we can worry about it then.
> >
> > The problem is that the skb is freed until userspace calls recvmsg(),
> > so it would be tricky to implement a watchdog. (Or if we can do, we
> > can do BQL as well).
>
> I thought the watchdog generally watches queues not individual skbs?

Yes, but only if ndo_tx_timeout is implemented.

I mean it would be tricky if we want to implement ndo_tx_timeout since
we can't choose a good timeout.

Thanks



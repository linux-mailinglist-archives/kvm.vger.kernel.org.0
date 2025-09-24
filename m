Return-Path: <kvm+bounces-58623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1946B98C41
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 10:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BDD63B5C67
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 08:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C11428136B;
	Wed, 24 Sep 2025 08:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PIaKNLU5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3107528031C
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 08:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758701400; cv=none; b=KgRc2dqinZXgNWEc0OG1DLr+foHDpz7rK2CPKDo2Ff5/26aMOYHiC3sjy7DeiZg84x6V9zbPTO3cyJr0BW1IqArAPEA90uiA4WdQjUZCOy/uJi3KpCHqCJEFzDVLH7sZP1TdG2hgZ+oVuGzA41L2g14dtRhASngydRZ7DN5RFlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758701400; c=relaxed/simple;
	bh=iyV5w9cbgt6ZgVOTxo8iAQ4w6DBDgBjEsyMsIZQh/kU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOowvhTsIEEuvgPXvlY9KtRD8Rw4YbFm0m+ewS+D5o5OcWzOMVlR8YfeQ+TM1n8Uo0adyh65Qu3j1SD+mUJ7241MuPZSW1IBLjt5iRlyn/mlkZHcVG4Lf/3wVKEdNr6YoS/RiVaQ+97CPajWekBGHrudmFPLiR+13Z6QeVcg7dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PIaKNLU5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758701398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CkM4oXRVV4nD2vjM2JL+8uqwWZZi2+21i3PZycL5UHY=;
	b=PIaKNLU5Anfh732lj7csOM1LaofINFbc6I4L4Oe0GG6CLB9C8aYy8BXk58JAHurJA7nNWP
	HqudR35Cf7km8ENtqyDtRUw6+emaVNuTrKURA8aXlGY7FqamhM1csDAh6Uv2LTA1mH0Mli
	hgCYyNIqyuO/+9/NsU8MY8F0v83yinY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-mj5cBJk8N_OxQ4J1zjOsnQ-1; Wed, 24 Sep 2025 04:09:56 -0400
X-MC-Unique: mj5cBJk8N_OxQ4J1zjOsnQ-1
X-Mimecast-MFC-AGG-ID: mj5cBJk8N_OxQ4J1zjOsnQ_1758701395
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b990eb77cso4376815e9.0
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 01:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758701395; x=1759306195;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CkM4oXRVV4nD2vjM2JL+8uqwWZZi2+21i3PZycL5UHY=;
        b=mfzP4df1WcKpchK0KrfFbRZB3qjv9Y/D+uXKDNlxwETXTGDxB6LI5bbljA0RM8HhvW
         Y5Mg2XdQ0BqxKzt9iH3n/LXoF0HaQM6Du79aqNQqvOmTgZxiAHxpUd27xYX7cKlI+CGm
         CJbwnJEiVLIC0e1B9u7orKhthQpm3s3AXc4/6/rtlfcvN8KHJOGxn2HaMPLky6x/31h5
         qRB5MsfRCEo3AKc5JVZvEgZ+8OxEhs2FsPLT4TknTfN7AhZkm37oLREUIb4Jk8dOI7cK
         HK28vHgVWtxmq8vTEpUb3W83LuCKgNOD1f6ZVELlpE+qag7n/UwSRjRHfDi0q68T8F5B
         TmwA==
X-Forwarded-Encrypted: i=1; AJvYcCVpj4B0MmYhkmUGcn2WeAFKJrdlspLWBLtDoIhZYMRasHR9ZorW41uhAXMkJP6O481AC5M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjYi5k4guLrbIlwomZ3+Aje9hqrhIp1XXivL3TFyBo8dolCLND
	uuLC6Q+fJNC/uJ0s2Slt9rGPmF2YlK8qB+V7GMhhWD0KU+foVv29cHmtUmgkAslOymTcoaXfaYm
	mTLpTbrGZy1K5pfmV6OKpyk3GyWHkOKbCZQDzDBXQ3tKWXVN2AQc9dA==
X-Gm-Gg: ASbGncuAzte0qSPxVRmJkDf2LmHnS+aUEN7b38T88DzJiv9Kl7of0668tCH7WaVjN9Z
	VlMQMzXQQI4J2o6ZSoe2ea2KCNtQUO7kYuYmAtrBUYc2RUe76Ddw2qzAcPtSeQRbgJZKZMr03Sg
	JwU6+/G4wr9b6pyG89ak/ujtDNxcE9z3bMbPYBssr5fi7KXRiXzWLbzDTssvhjDNBTHlFhT4xE6
	89T+2q+6ZngfHKWHjbyBrvCMj93rG+IZSkkC7g96Qd3fpmvoebtcLetuBUwsU8M/6eJmtL15wLF
	oEygJ+rXQkMNHvzqdO+502u0WKE8BH5SZeY=
X-Received: by 2002:a05:600c:540b:b0:46e:28cc:e56f with SMTP id 5b1f17b1804b1-46e2b539770mr14433285e9.6.1758701395308;
        Wed, 24 Sep 2025 01:09:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2isQpxZ6pAJzr2vpEkZfoKb5tx8a+WdsYfEl5CDZPv35AgMoMJYvNF0tcDqDtm8H3UIV5Gg==
X-Received: by 2002:a05:600c:540b:b0:46e:28cc:e56f with SMTP id 5b1f17b1804b1-46e2b539770mr14432985e9.6.1758701394926;
        Wed, 24 Sep 2025 01:09:54 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab31bdesm20213965e9.11.2025.09.24.01.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 01:09:54 -0700 (PDT)
Date: Wed, 24 Sep 2025 04:09:51 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
	willemdebruijn.kernel@gmail.com, eperezma@redhat.com,
	stephen@networkplumber.org, leiyang@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/8] TUN/TAP & vhost_net: netdev queue flow
 control to avoid ptr_ring tail drop
Message-ID: <20250924040915-mutt-send-email-mst@kernel.org>
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
 <20250924031105-mutt-send-email-mst@kernel.org>
 <CACGkMEuriTgw4+bFPiPU-1ptipt-WKvHdavM53ANwkr=iSvYYg@mail.gmail.com>
 <20250924034112-mutt-send-email-mst@kernel.org>
 <CACGkMEtdQ8j0AXttjLyPNSKq9-s0tSJPzRtKcWhXTF3M_PkVLQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtdQ8j0AXttjLyPNSKq9-s0tSJPzRtKcWhXTF3M_PkVLQ@mail.gmail.com>

On Wed, Sep 24, 2025 at 04:08:33PM +0800, Jason Wang wrote:
> On Wed, Sep 24, 2025 at 3:42 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Sep 24, 2025 at 03:33:08PM +0800, Jason Wang wrote:
> > > On Wed, Sep 24, 2025 at 3:18 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Tue, Sep 23, 2025 at 12:15:45AM +0200, Simon Schippers wrote:
> > > > > This patch series deals with TUN, TAP and vhost_net which drop incoming
> > > > > SKBs whenever their internal ptr_ring buffer is full. Instead, with this
> > > > > patch series, the associated netdev queue is stopped before this happens.
> > > > > This allows the connected qdisc to function correctly as reported by [1]
> > > > > and improves application-layer performance, see our paper [2]. Meanwhile
> > > > > the theoretical performance differs only slightly:
> > > >
> > > >
> > > > About this whole approach.
> > > > What if userspace is not consuming packets?
> > > > Won't the watchdog warnings appear?
> > > > Is it safe to allow userspace to block a tx queue
> > > > indefinitely?
> > >
> > > I think it's safe as it's a userspace device, there's no way to
> > > guarantee the userspace can process the packet in time (so no watchdog
> > > for TUN).
> > >
> > > Thanks
> >
> > Hmm. Anyway, I guess if we ever want to enable timeout for tun,
> > we can worry about it then.
> 
> The problem is that the skb is freed until userspace calls recvmsg(),
> so it would be tricky to implement a watchdog. (Or if we can do, we
> can do BQL as well).

I thought the watchdog generally watches queues not individual skbs?

> > Does not need to block this patchset.
> 
> Yes.
> 
> Thanks
> 
> >
> > > >
> > > > --
> > > > MST
> > > >
> >



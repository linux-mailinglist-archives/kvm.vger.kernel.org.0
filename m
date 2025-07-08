Return-Path: <kvm+bounces-51793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15DBEAFCFF9
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 18:02:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BD9B5659F9
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 16:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82D142E3AEB;
	Tue,  8 Jul 2025 16:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vq+3H54t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0BF267B92
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 16:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751990456; cv=none; b=BzRn6RKYmcnChHbvfSfpVgvBD9cFgp7IwV0dPIkK2t5a9Jfn8mJ/2ytfevV6z0k5Z9VSSLT6KFHlWthMYXZNCdr8eaGzmmjNVv6O4tgx0FK3Y9E7mpqW5ShBC+y67f/WnJ2AVz9y5BiuvOHXWBvH2jHvyion9m1pPsxw9zZqkpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751990456; c=relaxed/simple;
	bh=StlcZvK6aGILEdk1KZNWda5UzucYRHUtZYuMqW7hhhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ac2AMjbmXdVCDDVsNcR4y486OvnlxOd5SBAKM2QTfYA1Hl/nqXwcSREeVBKj76Vqvdn3tSeMWvJCwt0hahRsUM+uexCLLh1Nxj7hjyTq9o2y8N3OLnfB211263OnciTWdiHAqrKav3y2ZkGWyYxY0iAhkskm5+gGrbx4S41NcrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vq+3H54t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751990454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k7rmSrQYi60FMAPm+K5LDdHo//beZbxEAuJpXe2zQCM=;
	b=Vq+3H54trZwTo2iLjo8VTt9Ez9Q5tEuz8HinD9jpPSiilF8Xq2R/YNR5OgH0VgKrqN7Ao2
	2wWQIErvpv5ZnEcuDWIKvBCG3oz/RnPNDHZlxPPFhJdytS6iDQdsaMZLkf79x0HfjWlLeR
	C3cCBBMfNmp1wVi2U6PThZemF1X48OY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-IJ98GSjyMnyshYNPi3hBvw-1; Tue, 08 Jul 2025 12:00:52 -0400
X-MC-Unique: IJ98GSjyMnyshYNPi3hBvw-1
X-Mimecast-MFC-AGG-ID: IJ98GSjyMnyshYNPi3hBvw_1751990452
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-450d64026baso22682745e9.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 09:00:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751990451; x=1752595251;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k7rmSrQYi60FMAPm+K5LDdHo//beZbxEAuJpXe2zQCM=;
        b=vHF7QvlHUANEUfmYpi5q0G1oO6vTnNFZ2UsmkFx+vQInbAx3EWH2RtCTlRc4AbbD3n
         OAYQhrbCJyabtEua244kpPepqtz8zHjvXqAypvOl9NktTGpxLGE0BpOZ8muZa8LgMD0L
         ILSDSucYTJTF9Vf1rE8GqEq3mdMqKVbpYdgwDBUnrC8SYwFOUVTG5nxXsvoE7wczAJrw
         7BXHYecOjZJlIZCt/0XHLu5b8hfj5Aiq4eHMMu4yBmd1waM9nMMl1QHSo5YV6HeznNAO
         hp1KhIPEdrlWivPejKBygdwjeVFv2LH7AYlpei0wBagwuH+SX1NSbDNRNMvmqnP6mv8t
         B0iQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/S5cL6PSBEHCrBrMT0BdmblzVLml7T8wvjCM5rApwgrunyFSt9k08TjVlh5q+tykfVSc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgiWkrmgyP5yMH109Y2dIrsCbjSQlpr8fXkpMv7aw80nalC8R2
	6QlAYrRZbLDFwqi1MiTDyR2OS/BKRnotPtb1L418nkKlBR+rFAegldq63fmZ8TkscD0vp3ScPAP
	x4EPsJkceHNtPmnq2ilu/fRbAWS51wXMqKhlHZoKV6NBD5NywS5CP/w==
X-Gm-Gg: ASbGncu9oYEzHAZ/kZpRpXcZqoksD+uDvqDvldoqUYpjtm6NgjI/NO+WuXKxSrnMgWM
	q/72K5aKhhhEWAb7bEem2vnnDOnaqC9aL9URiIQh5BS08lw/iWiSpmoXxowxqkWcQA6LjiOIEIU
	Ns8erHzxwTqywlAlKdnSo5XDFA9eQT3Ppp6K98GbCtnATWnpE5qV9LOMqQSDDstf8Vck9PryaDP
	yRppDAhefsSpLUPqLosao/m5VKCXcvSVUZTE8yz6bKIWLNqvYRUT3DPQVYs45C43E+6z6SmTrQA
	n2WSmsTsWnWkF80=
X-Received: by 2002:a05:600c:3e0d:b0:43c:f0ae:da7 with SMTP id 5b1f17b1804b1-454d35ffbdemr2267445e9.7.1751990451158;
        Tue, 08 Jul 2025 09:00:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGiSR0msPRTkgKz930LJ0aKsR6/r+DX3T5MYEMydUmRzbvpCWWwSZ1kxGtK+XaWrTCCG9Ic8A==
X-Received: by 2002:a05:600c:3e0d:b0:43c:f0ae:da7 with SMTP id 5b1f17b1804b1-454d35ffbdemr2265355e9.7.1751990449097;
        Tue, 08 Jul 2025 09:00:49 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:150d:fc00:de3:4725:47c6:6809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454cd3d7d44sm26526055e9.30.2025.07.08.09.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 09:00:48 -0700 (PDT)
Date: Tue, 8 Jul 2025 12:00:45 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 net-next 0/9] virtio: introduce GSO over UDP tunnel
Message-ID: <20250708120014-mutt-send-email-mst@kernel.org>
References: <cover.1751874094.git.pabeni@redhat.com>
 <20250708105816-mutt-send-email-mst@kernel.org>
 <20250708082404.21d1fe61@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708082404.21d1fe61@kernel.org>

On Tue, Jul 08, 2025 at 08:24:04AM -0700, Jakub Kicinski wrote:
> On Tue, 8 Jul 2025 11:01:30 -0400 Michael S. Tsirkin wrote:
> > > git@github.com:pabeni/linux-devel.git virtio_udp_tunnel_07_07_2025
> > > 
> > > The first 5 patches in this series, that is, the virtio features
> > > extension bits are also available at [2]:
> > > 
> > > git@github.com:pabeni/linux-devel.git virtio_features_extension_07_07_2025
> > > 
> > > Ideally the virtio features extension bit should go via the virtio tree
> > > and the virtio_net/tun patches via the net-next tree. The latter have
> > > a dependency in the first and will cause conflicts if merged via the
> > > virtio tree, both when applied and at merge window time - inside Linus
> > > tree.
> > > 
> > > To avoid such conflicts and duplicate commits I think the net-next
> > > could pull from [1], while the virtio tree could pull from [2].  
> > 
> > Or I could just merge all of this in my tree, if that's ok
> > with others?
> 
> No strong preference here. My first choice would be a branch based
> on v6.16-rc5 so we can all pull in and resolve the conflicts that
> already exist. But I haven't looked how bad the conflicts would 
> be for virtio if we did that. On net-next side they look manageable.


OK, let's do it the way Paolo wants then.

-- 
MST



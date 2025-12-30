Return-Path: <kvm+bounces-66827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B03CCE9566
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 11:17:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4D36B303E647
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 10:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52303279DC8;
	Tue, 30 Dec 2025 10:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P0yYMVW3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bQ/HbEYj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA448212557
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 10:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089752; cv=none; b=L0dT6IYXS5MbFCtlYd6NpkC7XLzogMgH65pSoF6lhJKFejd2+rdEbHoJqXfJc610INdiP4KxnHWTk3wR2zmGobCAa49abPrgEkZLgAxegPkesszKlpU9pdH3JePNi+deiuNphVNRbtnjJlV6BJLXvyrCdqTrDkE70osws93DvHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089752; c=relaxed/simple;
	bh=LCt+6pV3SVXX+jVlhPofZ+B+PV2iA9I/7Ha5xrB3hCU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=St36WZMtz/9pEpuo79Y2iDmEGsM7VnOB6T//K9X5fbLNq4xnCPdqXEbefTbMHin/jg2ssrNKcvdWHVvJZpC1wt+ITr19ip1t0PYFmBbUDaMqw1KzUbMvmICGZHalFeKvUWzyJ4Aqft78Sbd+fi+P/xo4Ws5Kg5J83PY1OCjg4V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P0yYMVW3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bQ/HbEYj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=QPeHJm+twCiufdOXqLeCn+SgUmZXimx3Kj8OMbSgWcg=;
	b=P0yYMVW35jxYgBF3YWX+d5Ks1WvgEpHVbY7hSsHdHk78Zw0WyrCeBBSmS2yyK5oTbRjjF3
	I2ThzC+UAqPDYagw+qh9Y0x6x56cCzUJauXeqWrqndmgRCxf/08HSGzrcABR2iQB8QGVxM
	4lSXGaXGdADw9gUk4PbTfeYlI1of3DM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-44A5UbFqPMW-mHa_C8s4Dg-1; Tue, 30 Dec 2025 05:15:48 -0500
X-MC-Unique: 44A5UbFqPMW-mHa_C8s4Dg-1
X-Mimecast-MFC-AGG-ID: 44A5UbFqPMW-mHa_C8s4Dg_1767089747
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-430ffa9fccaso7718805f8f.1
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 02:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089747; x=1767694547; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QPeHJm+twCiufdOXqLeCn+SgUmZXimx3Kj8OMbSgWcg=;
        b=bQ/HbEYjNkNw4GOqt29NjfpwNJkMUoztoEvr64Ppr8lbJ3224HO5X8wrOAe+mil+Pz
         Tz1I0PKlgmqhMtQFmBGBSCLC/Omr1qWBkrAkVME27WwwXQ/vtgA7j1IqAHRWqRWFRl2G
         /ns5g2z/FMVxRZEozM550fAkUewyL5nAUJj1T5/Z70GbdMjHTHLhG7+DiZfqEvKPctjV
         KVM6uHGAP0ULWx1FjNINl3cd7Gcx7vwi7I/xJ84jnZygb5VPe50x62PvVKLT60UjIM3v
         mGBb0I2g9F9gw0qbl+/IdaOhP4baFcH3/2DCOkfKmwfkVjObQk103KmD6GGz0GXvuTFS
         a/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089747; x=1767694547;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QPeHJm+twCiufdOXqLeCn+SgUmZXimx3Kj8OMbSgWcg=;
        b=dCf/ekA6xiBhSxj+v22SOpgTgvJ6/6BH8dI2L1Oyn22G8cC7KsQn5YHZAhbH0/HsuO
         ed9WIVhqPyLM6paj4FaZXPckKdffh7t1FT4SXlInVBL/Svf4/wyakjQl9KmiNi8SE3zI
         bxJgT65HtEeB3ZxtEYQXEkASj/QREFqphJO/C1YoiGHaGPWpKI2kaxMXPQkkPa6PexQ8
         qVINbkcIyj8RyY/AdIXyMnF4yPY6SNlcr3gqFSrcu5PsC5Wbf5PIxPXm4oFoIWX6ha3P
         pskGfibaDOivlQc5iFwiIEJkYlPaXtE9PXciI+1v4AJjysj2sUOXjW0daIRFhcNTY2eR
         q1fw==
X-Forwarded-Encrypted: i=1; AJvYcCVZcLbXAxWn3vSwwhzZdwsjDzT6StejgHLJu6QW1n4z4WdzIc2ZhEuqNzHjHgqO7xseUZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLZXxTvcOhoQV1lP+H8OHsKvx/elqHZivoimoRTv5T8EU5cGm6
	dTwkVxnD9ZfDGQnMWPawDpaHWHXK7WSrUxJolRdiOUbTM9F+CjGRR4GuTAFTHWIYa1khBa2tcJU
	6mraaD6zNkBbiNaTzGAU1XNdlIqSn+P0C4FXEdoYDAjooIDX+/4Mr7g==
X-Gm-Gg: AY/fxX5QpBZVdPLcQBUtIA3A6KlY4aF3Xqz5phrH8gFHFRy2jHNo5dSUiXskMsD73+M
	viGa7oM77pZtmStNIj9nybMmgWJ3jRV/sd4Cp6p3P82c+tNhoJButPepboxFBF/2ZhkTn1k5Nq7
	db4csEuXf9Fj3IGXGgNp/hJ03Q89k2GoD+gls6iaNUWGvviGAGdeLm3jUXBM31On+/TpPDnDuuL
	HFfuMp1IotJVcGJTJvkuZQV+Jzq6aq4Wn/c8F3NKlQwSWEWU5V89vq6lkD1GUBYv24/d/Z4BlO0
	i/4Gu2gd7ZxtQOWzGxyRZoBLPqL9RfGOKeK38GJ8BR1A5mtktojCXV2hBVBamfKoq0gNdXDVPh4
	9o1aKQ2HN1Rmm3onmqtbyTsyN+PT2LJNs3Q==
X-Received: by 2002:a05:6000:2503:b0:431:a33:d872 with SMTP id ffacd0b85a97d-4324e4c1219mr30005604f8f.8.1767089746604;
        Tue, 30 Dec 2025 02:15:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEbvOFHJ91a0TKLxq+k7tMABBS8U1GQCYZPCELRU5Zsc1Gaj+GYCwYcD6RmChYOtX8+5x3fqQ==
X-Received: by 2002:a05:6000:2503:b0:431:a33:d872 with SMTP id ffacd0b85a97d-4324e4c1219mr30005566f8f.8.1767089746108;
        Tue, 30 Dec 2025 02:15:46 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324e9ba877sm67681523f8f.0.2025.12.30.02.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:15:45 -0800 (PST)
Date: Tue, 30 Dec 2025 05:15:42 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RFC 00/13] fix DMA aligment issues around virtio
Message-ID: <cover.1767089672.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent


Cong Wang reported dma debug warnings with virtio-vsock
and proposed a patch, see:

https://lore.kernel.org/all/20251228015451.1253271-1-xiyou.wangcong@gmail.com/

however, the issue is more widespread.
This is an attempt to fix it systematically.
Note: i2c and gio might also be affected, I am still looking
into it. Help from maintainers welcome.

Early RFC, compile tested only. Sending for early feedback/flames.
Cursor/claude used liberally mostly for refactoring, and english.

DMA maintainers, could you please confirm the DMA core changes
are ok with you?

Thanks!


Michael S. Tsirkin (13):
  dma-mapping: add __dma_from_device_align_begin/end
  docs: dma-api: document __dma_align_begin/end
  dma-mapping: add DMA_ATTR_CPU_CACHE_CLEAN
  docs: dma-api: document DMA_ATTR_CPU_CACHE_CLEAN
  dma-debug: track cache clean flag in entries
  virtio: add virtqueue_add_inbuf_cache_clean API
  vsock/virtio: fix DMA alignment for event_list
  vsock/virtio: use virtqueue_add_inbuf_cache_clean for events
  virtio_input: fix DMA alignment for evts
  virtio_scsi: fix DMA cacheline issues for events
  virtio-rng: fix DMA alignment for data buffer
  virtio_input: use virtqueue_add_inbuf_cache_clean for events
  vsock/virtio: reorder fields to reduce struct padding

 Documentation/core-api/dma-api-howto.rst  | 42 +++++++++++++
 Documentation/core-api/dma-attributes.rst |  9 +++
 drivers/char/hw_random/virtio-rng.c       |  2 +
 drivers/scsi/virtio_scsi.c                | 18 ++++--
 drivers/virtio/virtio_input.c             |  5 +-
 drivers/virtio/virtio_ring.c              | 72 +++++++++++++++++------
 include/linux/dma-mapping.h               | 17 ++++++
 include/linux/virtio.h                    |  5 ++
 kernel/dma/debug.c                        | 26 ++++++--
 net/vmw_vsock/virtio_transport.c          |  8 ++-
 10 files changed, 172 insertions(+), 32 deletions(-)

-- 
MST



Return-Path: <kvm+bounces-2881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6249D7FEC13
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:44:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 850A81C20A27
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:44:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B1839869;
	Thu, 30 Nov 2023 09:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ABNAuljz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B23D7F
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701337462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CxCSv1JU9Ny4rjT7OLghWcyP96ZpHESLwySqeBe1CEg=;
	b=ABNAuljzP1lQEPXXtWD6Y5gsUE1vH7ePaS5VuEXx6GXTqg7xh4Kmb2l81EhR8dJoU4tbiK
	LpD7u/9kALWw+z4Z9XVlPdkj/9uBjTzOoXn2fEWwgv8Rthm2HgVjjj2+7hHpySL1mb4tQT
	aVU67VERdoWTenH/SFvwGwsqkYguqKM=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-1W4E1r2qPjWJJjx2GNBhBQ-1; Thu, 30 Nov 2023 04:44:20 -0500
X-MC-Unique: 1W4E1r2qPjWJJjx2GNBhBQ-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2c9c265c5bdso7953201fa.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:44:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701337458; x=1701942258;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CxCSv1JU9Ny4rjT7OLghWcyP96ZpHESLwySqeBe1CEg=;
        b=HBhAAEjwkuwiWoMrnf8YTA3p3Up0TpFaBLozwenX6axF/G49y3LzDzHs/fixf6BhAq
         yuJkF38t0qzhYeNrq6gC83QPrRPsNCMkSCGT0KuzVGsVQvqv1R3qP3QLXHvdA7z27xAe
         RsTzAvTKxr33Xp9vlM0jamO7qaizteUwBUiStMnapzlZNEoPgM3cCCYcYaZIeSRfyDw9
         8A68qfA5zJiZRuLIVZPPhGk7F/fIqdeUTzXTPa/NoUszal14s2f8HWjLfIjhFUNOk2OS
         5vqQ6EjmtHmGyqcdVT0g0CPkEMJTT5Qny4u5o2eH+AHmyqJW8o55FS/2XYEzBljucpkz
         yzCg==
X-Gm-Message-State: AOJu0YyCZ2NEQjuckabwA4kb5inRAM7KvTPgL6qh9zjanpZK6bzA1H4Z
	7FAY/zwRbxYjaTqWWf1o571D+BiqpNBjU2rKKCJeFtrRc37DdQFJeZLR0DVwJ8ClKCrnxu458cs
	sciF/D8mNZacE
X-Received: by 2002:a2e:80d6:0:b0:2c9:b1ff:f951 with SMTP id r22-20020a2e80d6000000b002c9b1fff951mr5651672ljg.25.1701337458769;
        Thu, 30 Nov 2023 01:44:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGQ3ETQ8qMwSfAMQqyRN2zbxUusE+Cde6ncuv72WYiZ/hQyYq4rhX69dbPlKoUxjc6/4LtSUA==
X-Received: by 2002:a2e:80d6:0:b0:2c9:b1ff:f951 with SMTP id r22-20020a2e80d6000000b002c9b1fff951mr5651646ljg.25.1701337458370;
        Thu, 30 Nov 2023 01:44:18 -0800 (PST)
Received: from redhat.com ([2.55.10.128])
        by smtp.gmail.com with ESMTPSA id i2-20020adffc02000000b003330aede2aesm1023337wrr.112.2023.11.30.01.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 01:44:17 -0800 (PST)
Date: Thu, 30 Nov 2023 04:44:13 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: "Ning, Hongyu" <hongyu.ning@linux.intel.com>,
	xuanzhuo@linux.alibaba.com,
	Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, eperezma@redhat.com,
	shannon.nelson@amd.com, yuanyaogoog@chromium.org,
	yuehaibing@huawei.com, kirill.shutemov@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com,
	alexander.shishkin@linux.intel.com
Subject: Re: [GIT PULL] virtio: features
Message-ID: <20231130044045-mutt-send-email-mst@kernel.org>
References: <20230903181338-mutt-send-email-mst@kernel.org>
 <647701d8-c99b-4ca8-9817-137eaefda237@linux.intel.com>
 <CACGkMEvoGOO0jtq5T7arAjRoB_0_fHB2+hPJe1JsPqcAuvr98w@mail.gmail.com>
 <6f84bbad-62f9-43df-8134-a6836cc3b66c@linux.intel.com>
 <CACGkMEvtus2BseZec8at6YORO=As1v9r9p=xtZjE1e2i=uhwhA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEvtus2BseZec8at6YORO=As1v9r9p=xtZjE1e2i=uhwhA@mail.gmail.com>

On Wed, Nov 29, 2023 at 06:20:31PM +0800, Jason Wang wrote:
> On Wed, Nov 29, 2023 at 6:12 PM Ning, Hongyu
> <hongyu.ning@linux.intel.com> wrote:
> >
> >
> > On 2023/11/29 17:16, Jason Wang wrote:
> > > On Wed, Nov 29, 2023 at 5:05 PM Ning, Hongyu
> > > <hongyu.ning@linux.intel.com> wrote:
> > >>
> > >>
> > >>
> > >> On 2023/9/4 6:13, Michael S. Tsirkin wrote:
> > >>> The following changes since commit 2dde18cd1d8fac735875f2e4987f11817cc0bc2c:
> > >>>
> > >>>     Linux 6.5 (2023-08-27 14:49:51 -0700)
> > >>>
> > >>> are available in the Git repository at:
> > >>>
> > >>>     https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> > >>>
> > >>> for you to fetch changes up to 1acfe2c1225899eab5ab724c91b7e1eb2881b9ab:
> > >>>
> > >>>     virtio_ring: fix avail_wrap_counter in virtqueue_add_packed (2023-09-03 18:10:24 -0400)
> > >>>
> > >>> ----------------------------------------------------------------
> > >>> virtio: features
> > >>>
> > >>> a small pull request this time around, mostly because the
> > >>> vduse network got postponed to next relase so we can be sure
> > >>> we got the security store right.
> > >>>
> > >>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > >>>
> > >>> ----------------------------------------------------------------
> > >>> Eugenio Pérez (4):
> > >>>         vdpa: add VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK flag
> > >>>         vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend feature
> > >>>         vdpa: add get_backend_features vdpa operation
> > >>>         vdpa_sim: offer VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK
> > >>>
> > >>> Jason Wang (1):
> > >>>         virtio_vdpa: build affinity masks conditionally
> > >>>
> > >>> Xuan Zhuo (12):
> > >>>         virtio_ring: check use_dma_api before unmap desc for indirect
> > >>>         virtio_ring: put mapping error check in vring_map_one_sg
> > >>>         virtio_ring: introduce virtqueue_set_dma_premapped()
> > >>>         virtio_ring: support add premapped buf
> > >>>         virtio_ring: introduce virtqueue_dma_dev()
> > >>>         virtio_ring: skip unmap for premapped
> > >>>         virtio_ring: correct the expression of the description of virtqueue_resize()
> > >>>         virtio_ring: separate the logic of reset/enable from virtqueue_resize
> > >>>         virtio_ring: introduce virtqueue_reset()
> > >>>         virtio_ring: introduce dma map api for virtqueue
> > >>>         virtio_ring: introduce dma sync api for virtqueue
> > >>>         virtio_net: merge dma operations when filling mergeable buffers
> > >>
> > >> Hi,
> > >> above patch (upstream commit 295525e29a5b) seems causing a virtnet
> > >> related Call Trace after WARNING from kernel/dma/debug.c.
> > >>
> > >> details (log and test setup) tracked in
> > >> https://bugzilla.kernel.org/show_bug.cgi?id=218204
> > >>
> > >> it's recently noticed in a TDX guest testing since v6.6.0 release cycle
> > >> and can still be reproduced in latest v6.7.0-rc3.
> > >>
> > >> as local bisects results show, above WARNING and Call Trace is linked
> > >> with this patch, do you mind to take a look?
> > >
> > > Looks like virtqueue_dma_sync_single_range_for_cpu() use
> > > DMA_BIDIRECTIONAL unconditionally.
> > >
> > > We should use dir here.
> > >
> > > Mind to try?
> > >
> > > Thanks
> > >
> >
> > sure, but what I see in the code
> > virtqueue_dma_sync_single_range_for_cpu() is using DMA_FROM_DEVICE,
> > probably I misunderstood your point?
> >
> > Please let me know any patch/setting to try here.
> 
> Something like attached.  (Not even compiling test).
> 
> Thanks

Forwarding it inline for the record - I am not sure all the
0 day machinery handles attachments. Jason given it's reported to work
can you please repost properly with a full commit log etc?
I think we also need to fix virtqueue_dma_sync_single_range_for_device -
please include that too.
 

From: Jason Wang <jasowang@redhat.com>
Date: Wed, 29 Nov 2023 17:14:15 +0800
Subject: [PATCH] virtio_ring: fix DMA dir during sync
Content-type: text/plain

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---
 drivers/virtio/virtio_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 81ecb29c88f1..91d869814373 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -3220,7 +3220,7 @@ void virtqueue_dma_sync_single_range_for_cpu(struct virtqueue *_vq,
 		return;
 
 	dma_sync_single_range_for_cpu(dev, addr, offset, size,
-				      DMA_BIDIRECTIONAL);
+				      dir);
 }
 EXPORT_SYMBOL_GPL(virtqueue_dma_sync_single_range_for_cpu);
 
-- 
2.42.0



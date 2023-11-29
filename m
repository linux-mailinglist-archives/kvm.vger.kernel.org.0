Return-Path: <kvm+bounces-2755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2FA87FD400
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 11:20:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3E0B1C20BE2
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 10:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42CC91B270;
	Wed, 29 Nov 2023 10:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WEWbk3oa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6061E1
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 02:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701253247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8eOgmnDcAOuHVjx4FQ/wfnS7taAjkRaDPrb33RzRzvo=;
	b=WEWbk3oaS/uvhHoWMBHBXQT7sPEOKzSG333zV5NGiq9C90X50hXsNKy5xrintIwYu3LJhh
	7MmgryIYBBjCuv/WlDcZIHz989BzYx6OnhxB2IRhBGnSP1C8nSIMMn35TXuDY6sGhEJ69g
	HvMgpRv3weM6eBInrbeTPQaJn06gxlE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-ncl_OarUOzy-Vg0L1IywfQ-1; Wed, 29 Nov 2023 05:20:44 -0500
X-MC-Unique: ncl_OarUOzy-Vg0L1IywfQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-50bc5907820so455175e87.0
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 02:20:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701253243; x=1701858043;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8eOgmnDcAOuHVjx4FQ/wfnS7taAjkRaDPrb33RzRzvo=;
        b=guPX4EnZB9URkr1SLDBwpoiroa+5ZziC27cuuswWyc8QNKi6pD4OmnoDSQ0zO4OrIR
         9UOibjEOM1NxXGxJ9AlQ/BLYLjBgoh2nb+UJsB9VjdMdaT+DBGl55AxNVd3WFHEZ3MWL
         iqYgSYllM0vppPPMxEskQ5lwP6ybfvQtRXr223U6sKITPUDgrJ7bWyjJxW7sey8xFTeu
         PaEoc9LL+moCbDmb8idn/H7RGo+Z2becfB4AsV6XsbH+VkJdg2u7Hm+quZbbLVXBU/dP
         LfNqjVQ5x3UOjphDa7Mt0EsLVz2RuLZvSz8L8iLre1B6BTJ/waGv9B/z++2apZ9qbRk4
         yIFg==
X-Gm-Message-State: AOJu0YzF2ZHqDXROQSVm6Za1Rkby72O0SohqVPSEGVhNJqz+CIIFdb1y
	NFwfHZmqarqJMLg+8rwXHIIzWIH79r9iPKQzVtQhCMbBQ/9MTsu5+fwVBhU3zXS2JktSFobb5qz
	xLys8kFRJz8Vgd3AeugFXYiqLBY4j
X-Received: by 2002:a05:6512:220a:b0:507:cb04:59d4 with SMTP id h10-20020a056512220a00b00507cb0459d4mr12336127lfu.8.1701253243247;
        Wed, 29 Nov 2023 02:20:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHo6suNvwReIN0wIUEmAKInanQPmGpK3eFZ68I+bpu7dfH9YCETv8WG6Wc9xZCDDfErzyYtBX/TPf0eCASyd2Y=
X-Received: by 2002:a05:6512:220a:b0:507:cb04:59d4 with SMTP id
 h10-20020a056512220a00b00507cb0459d4mr12336107lfu.8.1701253242868; Wed, 29
 Nov 2023 02:20:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230903181338-mutt-send-email-mst@kernel.org>
 <647701d8-c99b-4ca8-9817-137eaefda237@linux.intel.com> <CACGkMEvoGOO0jtq5T7arAjRoB_0_fHB2+hPJe1JsPqcAuvr98w@mail.gmail.com>
 <6f84bbad-62f9-43df-8134-a6836cc3b66c@linux.intel.com>
In-Reply-To: <6f84bbad-62f9-43df-8134-a6836cc3b66c@linux.intel.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 29 Nov 2023 18:20:31 +0800
Message-ID: <CACGkMEvtus2BseZec8at6YORO=As1v9r9p=xtZjE1e2i=uhwhA@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: features
To: "Ning, Hongyu" <hongyu.ning@linux.intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, xuanzhuo@linux.alibaba.com, 
	Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, eperezma@redhat.com, shannon.nelson@amd.com, 
	yuanyaogoog@chromium.org, yuehaibing@huawei.com, 
	kirill.shutemov@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com, 
	alexander.shishkin@linux.intel.com
Content-Type: multipart/mixed; boundary="0000000000003705f2060b47e303"

--0000000000003705f2060b47e303
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 29, 2023 at 6:12=E2=80=AFPM Ning, Hongyu
<hongyu.ning@linux.intel.com> wrote:
>
>
> On 2023/11/29 17:16, Jason Wang wrote:
> > On Wed, Nov 29, 2023 at 5:05=E2=80=AFPM Ning, Hongyu
> > <hongyu.ning@linux.intel.com> wrote:
> >>
> >>
> >>
> >> On 2023/9/4 6:13, Michael S. Tsirkin wrote:
> >>> The following changes since commit 2dde18cd1d8fac735875f2e4987f11817c=
c0bc2c:
> >>>
> >>>     Linux 6.5 (2023-08-27 14:49:51 -0700)
> >>>
> >>> are available in the Git repository at:
> >>>
> >>>     https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tag=
s/for_linus
> >>>
> >>> for you to fetch changes up to 1acfe2c1225899eab5ab724c91b7e1eb2881b9=
ab:
> >>>
> >>>     virtio_ring: fix avail_wrap_counter in virtqueue_add_packed (2023=
-09-03 18:10:24 -0400)
> >>>
> >>> ----------------------------------------------------------------
> >>> virtio: features
> >>>
> >>> a small pull request this time around, mostly because the
> >>> vduse network got postponed to next relase so we can be sure
> >>> we got the security store right.
> >>>
> >>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >>>
> >>> ----------------------------------------------------------------
> >>> Eugenio P=C3=A9rez (4):
> >>>         vdpa: add VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK flag
> >>>         vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend f=
eature
> >>>         vdpa: add get_backend_features vdpa operation
> >>>         vdpa_sim: offer VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK
> >>>
> >>> Jason Wang (1):
> >>>         virtio_vdpa: build affinity masks conditionally
> >>>
> >>> Xuan Zhuo (12):
> >>>         virtio_ring: check use_dma_api before unmap desc for indirect
> >>>         virtio_ring: put mapping error check in vring_map_one_sg
> >>>         virtio_ring: introduce virtqueue_set_dma_premapped()
> >>>         virtio_ring: support add premapped buf
> >>>         virtio_ring: introduce virtqueue_dma_dev()
> >>>         virtio_ring: skip unmap for premapped
> >>>         virtio_ring: correct the expression of the description of vir=
tqueue_resize()
> >>>         virtio_ring: separate the logic of reset/enable from virtqueu=
e_resize
> >>>         virtio_ring: introduce virtqueue_reset()
> >>>         virtio_ring: introduce dma map api for virtqueue
> >>>         virtio_ring: introduce dma sync api for virtqueue
> >>>         virtio_net: merge dma operations when filling mergeable buffe=
rs
> >>
> >> Hi,
> >> above patch (upstream commit 295525e29a5b) seems causing a virtnet
> >> related Call Trace after WARNING from kernel/dma/debug.c.
> >>
> >> details (log and test setup) tracked in
> >> https://bugzilla.kernel.org/show_bug.cgi?id=3D218204
> >>
> >> it's recently noticed in a TDX guest testing since v6.6.0 release cycl=
e
> >> and can still be reproduced in latest v6.7.0-rc3.
> >>
> >> as local bisects results show, above WARNING and Call Trace is linked
> >> with this patch, do you mind to take a look?
> >
> > Looks like virtqueue_dma_sync_single_range_for_cpu() use
> > DMA_BIDIRECTIONAL unconditionally.
> >
> > We should use dir here.
> >
> > Mind to try?
> >
> > Thanks
> >
>
> sure, but what I see in the code
> virtqueue_dma_sync_single_range_for_cpu() is using DMA_FROM_DEVICE,
> probably I misunderstood your point?
>
> Please let me know any patch/setting to try here.

Something like attached.  (Not even compiling test).

Thanks

>
>
> >>
> >>>
> >>> Yuan Yao (1):
> >>>         virtio_ring: fix avail_wrap_counter in virtqueue_add_packed
> >>>
> >>> Yue Haibing (1):
> >>>         vdpa/mlx5: Remove unused function declarations
> >>>
> >>>    drivers/net/virtio_net.c           | 230 ++++++++++++++++++---
> >>>    drivers/vdpa/mlx5/core/mlx5_vdpa.h |   3 -
> >>>    drivers/vdpa/vdpa_sim/vdpa_sim.c   |   8 +
> >>>    drivers/vhost/vdpa.c               |  15 +-
> >>>    drivers/virtio/virtio_ring.c       | 412 +++++++++++++++++++++++++=
+++++++-----
> >>>    drivers/virtio/virtio_vdpa.c       |  17 +-
> >>>    include/linux/vdpa.h               |   4 +
> >>>    include/linux/virtio.h             |  22 ++
> >>>    include/uapi/linux/vhost_types.h   |   4 +
> >>>    9 files changed, 625 insertions(+), 90 deletions(-)
> >>>
> >>
> >
>

--0000000000003705f2060b47e303
Content-Type: application/octet-stream; 
	name="0001-virtio_ring-fix-DMA-dir-during-sync.patch"
Content-Disposition: attachment; 
	filename="0001-virtio_ring-fix-DMA-dir-during-sync.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lpjm8ipj0>
X-Attachment-Id: f_lpjm8ipj0

RnJvbSBmZjVhNTQwMmExMjA5Y2FjNzNhNGIwZTdjMTkzNzM3ODhiNDE3N2Y5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPgpEYXRl
OiBXZWQsIDI5IE5vdiAyMDIzIDE3OjE0OjE1ICswODAwClN1YmplY3Q6IFtQQVRDSF0gdmlydGlv
X3Jpbmc6IGZpeCBETUEgZGlyIGR1cmluZyBzeW5jCkNvbnRlbnQtdHlwZTogdGV4dC9wbGFpbgoK
U2lnbmVkLW9mZi1ieTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4KLS0tCiBkcml2
ZXJzL3ZpcnRpby92aXJ0aW9fcmluZy5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy92aXJ0aW8vdmlydGlv
X3JpbmcuYyBiL2RyaXZlcnMvdmlydGlvL3ZpcnRpb19yaW5nLmMKaW5kZXggODFlY2IyOWM4OGYx
Li45MWQ4Njk4MTQzNzMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdmlydGlvL3ZpcnRpb19yaW5nLmMK
KysrIGIvZHJpdmVycy92aXJ0aW8vdmlydGlvX3JpbmcuYwpAQCAtMzIyMCw3ICszMjIwLDcgQEAg
dm9pZCB2aXJ0cXVldWVfZG1hX3N5bmNfc2luZ2xlX3JhbmdlX2Zvcl9jcHUoc3RydWN0IHZpcnRx
dWV1ZSAqX3ZxLAogCQlyZXR1cm47CiAKIAlkbWFfc3luY19zaW5nbGVfcmFuZ2VfZm9yX2NwdShk
ZXYsIGFkZHIsIG9mZnNldCwgc2l6ZSwKLQkJCQkgICAgICBETUFfQklESVJFQ1RJT05BTCk7CisJ
CQkJICAgICAgZGlyKTsKIH0KIEVYUE9SVF9TWU1CT0xfR1BMKHZpcnRxdWV1ZV9kbWFfc3luY19z
aW5nbGVfcmFuZ2VfZm9yX2NwdSk7CiAKLS0gCjIuNDIuMAoK
--0000000000003705f2060b47e303--



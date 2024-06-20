Return-Path: <kvm+bounces-20068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D813910260
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 13:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 870FFB21BD7
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 11:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50121AB50B;
	Thu, 20 Jun 2024 11:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="s420pftD"
X-Original-To: kvm@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B7E1AB502;
	Thu, 20 Jun 2024 11:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718882287; cv=none; b=uoQtek8pjcCWSgOT4mBqPXngh1Ea80NpHi8FPWuUFPzHRDAPVTW8nxo3T+4Wbao1rXSAJTWiyMrxP59M6riFwVvxwS+gV7fBapzlBOL9UcbgRaKVpYKG4sRQSDlg4/M2P8XhduZy42zK8nqgaj/UMzZkg8ZJagd5BMyc80vOsEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718882287; c=relaxed/simple;
	bh=whIWTQUGNFlcc/ik8hjbVakJq4I0XXiqVkMW3RCqlxI=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To; b=N0mtn/cEi5x8gPzK7Zxxrxm9a0U6j45j8VlfQkmN89d9WV1vhaO1Nz+uwen9D/C/YZg5GGDpq5ckVDiasc5iIih+bO4RB/3b2Yj4KoNfUiv5Pt2+jyPoDBjkSPPLR8SdQII7T/lFdG8I5yBGvttAd9RolglRtFuuykDUWrMlulI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=s420pftD; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1718882282; h=Message-ID:Subject:Date:From:To;
	bh=//x5onozUgYFk/aBqRvitaQ4r9ZfJQATuCruwcqktrU=;
	b=s420pftDecHiaMloTF+zqxrfjDaNx/a4NjgKJr4pJbxOB9lyZUG/YwhmOfwlDbYWSWQ+y+v4fwTTSoi2MY03BnI8J0rZsGkulIs3EDA8rjR+KyZUi68NdV8DoVOan0wWC4SMGArEDTUV/d/6uav64qC8vaVAhR6QSZVVM3bNz/0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045046011;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0W8sDWdc_1718882279;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W8sDWdc_1718882279)
          by smtp.aliyun-inc.com;
          Thu, 20 Jun 2024 19:18:00 +0800
Message-ID: <1718881968.7394087-7-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v9 3/6] virtio: find_vqs: pass struct instead of multi parameters
Date: Thu, 20 Jun 2024 19:12:48 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux.dev,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Hans de Goede <hdegoede@redhat.com>,
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Vadim Pasternak <vadimp@nvidia.com>,
 Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
 <20240424091533.86949-4-xuanzhuo@linux.alibaba.com>
 <20240620034823-mutt-send-email-mst@kernel.org>
 <1718874049.457552-1-xuanzhuo@linux.alibaba.com>
 <20240620050545-mutt-send-email-mst@kernel.org>
 <1718875249.1787696-3-xuanzhuo@linux.alibaba.com>
 <20240620061202-mutt-send-email-mst@kernel.org>
 <1718880210.0475078-2-xuanzhuo@linux.alibaba.com>
 <20240620070354-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240620070354-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Thu, 20 Jun 2024 07:06:53 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Jun 20, 2024 at 06:43:30PM +0800, Xuan Zhuo wrote:
> > On Thu, 20 Jun 2024 06:15:08 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > On Thu, Jun 20, 2024 at 05:20:49PM +0800, Xuan Zhuo wrote:
> > > > On Thu, 20 Jun 2024 05:14:24 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > > On Thu, Jun 20, 2024 at 05:00:49PM +0800, Xuan Zhuo wrote:
> > > > > > > > @@ -226,21 +248,37 @@ struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
> > > > > > > >
> > > > > > > >  static inline
> > > > > > > >  int virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> > > > > > > > -			struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > > > > > > > -			const char * const names[],
> > > > > > > > -			struct irq_affinity *desc)
> > > > > > > > +		    struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > > > > > > > +		    const char * const names[],
> > > > > > > > +		    struct irq_affinity *desc)
> > > > > > > >  {
> > > > > > > > -	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL, desc);
> > > > > > > > +	struct virtio_vq_config cfg = {};
> > > > > > > > +
> > > > > > > > +	cfg.nvqs = nvqs;
> > > > > > > > +	cfg.vqs = vqs;
> > > > > > > > +	cfg.callbacks = callbacks;
> > > > > > > > +	cfg.names = (const char **)names;
> > > > > > >
> > > > > > >
> > > > > > > Casting const away? Not safe.
> > > > > >
> > > > > >
> > > > > >
> > > > > > Because the vp_modern_create_avq() use the "const char *names[]",
> > > > > > and the virtio_uml.c changes the name in the subsequent commit, so
> > > > > > change the "names" inside the virtio_vq_config from "const char *const
> > > > > > *names" to "const char **names".
> > > > >
> > > > > I'm not sure I understand which commit you mean,
> > > > > and this kind of change needs to be documented, but it does not matter.
> > > > > Don't cast away const.
> > > >
> > > >
> > > > Do you mean change the virtio_find_vqs(), from
> > > > const char * const names[] to const char *names[].
> > > >
> > > > And update the caller?
> > > >
> > > > If we do not cast the const, we need to update all the caller to remove the
> > > > const.
> > > >
> > > > Right?
> > > >
> > > > Thanks.
> > >
> > >
> > > Just do not split the patchset at a boundary that makes you do that.
> > > If you are passing in an array from a const section then it
> > > has to be const and attempts to change it are a bad idea.
> >
> > Without this patch set:
> >
> > static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
> > 				     unsigned index, vq_callback_t *callback,
> > 				     const char *name, bool ctx)
> > {
> > 	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
> > 	struct platform_device *pdev = vu_dev->pdev;
> > 	struct virtio_uml_vq_info *info;
> > 	struct virtqueue *vq;
> > 	int num = MAX_SUPPORTED_QUEUE_SIZE;
> > 	int rc;
> >
> > 	info = kzalloc(sizeof(*info), GFP_KERNEL);
> > 	if (!info) {
> > 		rc = -ENOMEM;
> > 		goto error_kzalloc;
> > 	}
> > ->	snprintf(info->name, sizeof(info->name), "%s.%d-%s", pdev->name,
> > 		 pdev->id, name);
> >
> > 	vq = vring_create_virtqueue(index, num, PAGE_SIZE, vdev, true, true,
> > 				    ctx, vu_notify, callback, info->name);
> >
> >
> > The name is changed by vu_setup_vq().
> > If we want to pass names to
> > virtio ring, the names must not be  "const char * const"
> >
> > And the admin queue of pci do the same thing.
> >
> > And I think you are right, we should not cast the const.
> > So we have to remove the "const" from the source.
> > And I checked the source code, if we remove the "const", I think
> > that makes sense.
> >
> > Thanks.
>
> /facepalm
>
> This is a different const.
>
>
> There should be no need to drop the annotation, core
> does not change these things and using const helps make
> sure that is the case.


If you do not like this, the left only way is to allocate new
memory to store the info, if the caller do not change.

In the further, maybe the caller can use the follow struct directly.

struct virtio_vq_config {
 	vq_callback_t      callback;
 	const char         *name;
 	const bool          ctx;
};

For now, we can allocate memory to change the arrays (names, callbacks..)
to the array of struct virtio_vq_config.

And the find_vqs() accepts the array of struct virtio_vq_config.

How about this?

Thanks.

>
>
>
> >
> >
> > >
> > >
> > > > >
> > > > > --
> > > > > MST
> > > > >
> > >
>


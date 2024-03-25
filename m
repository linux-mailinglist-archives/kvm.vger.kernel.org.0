Return-Path: <kvm+bounces-12563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95B42889ED8
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B2EE28BBBB
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 12:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F48B5D723;
	Mon, 25 Mar 2024 08:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bb/Yq7i2"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDFE153566;
	Mon, 25 Mar 2024 06:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711347268; cv=none; b=oLM7yOMrK6391dS2orN0c1ehvEXaBiEd9qAUDht5GGf9fHFkD/q9gTWVy2DL1AaloAVYCBzdfj9E7pA/sieCaJHKYRVzbP0XsIYVdChGqV/ATHJNaxRfPSM0A167KHMrllywZXQElZhXcxyvu/DmtaW1hCaVhALpxhDZLZ5L4I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711347268; c=relaxed/simple;
	bh=GyIKFNRR1qWHImh+cuLOt5QaFS06G20Ha+rQxRimdT8=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=VsjQZ8YJMXM5/CuPNwQFTEwcIi0q4/GbAfC/RdC3DtUFECc0RTRUIXmPW98XEboweG79lKvY9QkSu5inMakUl3qbm7WWFfMnNhotK8PpLCEPF5l9VYjT2WLJWaNPsDbS4X2h7AuJ1mIVFafv2bsno3S2A/K95CDeg9SdjzbyJaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bb/Yq7i2; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711347263; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=BJ2ubMtU85p7XN+WIaKbvt0uua6wwUwRoEIA4BLg6No=;
	b=bb/Yq7i2vT6mBEZEz9Nv65M3Ojh/fe2QB0iNc+7R1DlRJxkYFktmKNfH6ahfV/n11EnTSKPahuRF12R3QSUO8ZAdNIr6Fz3irafdE2E8Ey07lJixM+yFlbzlMduzmJa8fXCXY+Y6D3Q4Q0v3nItbXdb1eTtlmaJnXjIJg+SUiZU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0W39d8Wn_1711347261;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W39d8Wn_1711347261)
          by smtp.aliyun-inc.com;
          Mon, 25 Mar 2024 14:14:22 +0800
Message-ID: <1711346901.0977402-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v4 1/6] virtio_balloon: remove the dependence where names[] is null
Date: Mon, 25 Mar 2024 14:08:21 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: David Hildenbrand <david@redhat.com>
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
 "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org,
 Daniel Verkamp <dverkamp@chromium.org>
References: <20240321101532.59272-1-xuanzhuo@linux.alibaba.com>
 <20240321101532.59272-2-xuanzhuo@linux.alibaba.com>
 <CABVzXAkwcKMb7pC21aUDLEM=RoyOtGA2Vim+LF0oWQ7mjUx68g@mail.gmail.com>
 <b420a545-0a7a-431c-aa48-c5db3d221420@redhat.com>
In-Reply-To: <b420a545-0a7a-431c-aa48-c5db3d221420@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Fri, 22 Mar 2024 22:02:27 +0100, David Hildenbrand <david@redhat.com> wr=
ote:
> On 22.03.24 20:16, Daniel Verkamp wrote:
> > On Thu, Mar 21, 2024 at 3:16=E2=80=AFAM Xuan Zhuo <xuanzhuo@linux.aliba=
ba.com> wrote:
> >>
> >> Currently, the init_vqs function within the virtio_balloon driver reli=
es
> >> on the condition that certain names array entries are null in order to
> >> skip the initialization of some virtual queues (vqs). This behavior is
> >> unique to this part of the codebase. In an upcoming commit, we plan to
> >> eliminate this dependency by removing the function entirely. Therefore,
> >> with this change, we are ensuring that the virtio_balloon no longer
> >> depends on the aforementioned function.
> >
> > This is a behavior change, and I believe means that the driver no
> > longer follows the spec [1].
> >
> > For example, the spec says that virtqueue 4 is reporting_vq, and
> > reporting_vq only exists if VIRTIO_BALLOON_F_PAGE_REPORTING is set,
> > but there is no mention of its virtqueue number changing if other
> > features are not set. If a device/driver combination negotiates
> > VIRTIO_BALLOON_F_PAGE_REPORTING but not VIRTIO_BALLOON_F_STATS_VQ or
> > VIRTIO_BALLOON_F_FREE_PAGE_HINT, my reading of the specification is
> > that reporting_vq should still be vq number 4, and vq 2 and 3 should
> > be unused. This patch would make the reporting_vq use vq 2 instead in
> > this case.
> >
> > If the new behavior is truly intended, then the spec does not match
> > reality, and it would need to be changed first (IMO); however,
> > changing the spec would mean that any devices implemented correctly
> > per the previous spec would now be wrong, so some kind of mechanism
> > for detecting the new behavior would be warranted, e.g. a new
> > non-device-specific virtio feature flag.
> >
> > I have brought this up previously on the virtio-comment list [2], but
> > it did not receive any satisfying answers at that time.
>
> Rings a bell, but staring at this patch, I thought that there would be
> no behavioral change. Maybe I missed it :/
>
> I stared at virtio_ccw_find_vqs(), and it contains:
>
> 	for (i =3D 0; i < nvqs; ++i) {
> 		if (!names[i]) {
> 			vqs[i] =3D NULL;
> 			continue;
> 		}
>
> 		vqs[i] =3D virtio_ccw_setup_vq(vdev, queue_idx++, callbacks[i],
> 					     names[i], ctx ? ctx[i] : false,
> 					     ccw);
> 		if (IS_ERR(vqs[i])) {
> 			ret =3D PTR_ERR(vqs[i]);
> 			vqs[i] =3D NULL;
> 			goto out;
> 		}
> 	}
>
> We increment queue_idx only if an entry was not NULL. SO I thought no
> behavioral change? (at least on s390x :) )
>
> It's late here in Germany, so maybe I'm missing something.

I think we've encountered a tricky issue. Currently, all transports handle =
queue
id by incrementing them in order, without skipping any queue id. So, I'm qu=
ite
surprised that my changes would affect the spec. The fact that the
'names' value is null is just a small trick in the Linux kernel implementat=
ion
and should not have an impact on the queue id.

I believe that my recent modification will not affect the spec. So, let's
consider the issues with this patch set separately for now. Regarding the M=
emory
Balloon Device, it has been operational for many years, and perhaps we shou=
ld
add to the spec that if a certain vq does not exist, then subsequent vqs wi=
ll
take over its id.

Thanks.



>
> --
> Cheers,
>
> David / dhildenb
>


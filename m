Return-Path: <kvm+bounces-11558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B071878449
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 16:57:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 157171F20FA2
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 15:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E54F4597C;
	Mon, 11 Mar 2024 15:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YmdYOxDo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE5D4207B;
	Mon, 11 Mar 2024 15:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710172614; cv=none; b=gyKNINkGsIr3/pM7UbQq282y+eQJz6SOdq7RgCmdZfKYxQGTyk0trgC9osmi+kjQdHBhyCzhX47gsKZQW7wfCAKGAb1N063Bz7CCp93JOSgbaK9/6DO0KyOQONuYw3EwH06TAwFFOoUIXWel0+5AKZBBZHL0wZsvpIGUY2gV66s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710172614; c=relaxed/simple;
	bh=DeVDHoqrlAAYXO82i9sgG6eEpZuSi3CQXTqHB7uSVqM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LD+IL+3Xbv37vtGn7rD+ZneYFvu2WniLCLqTlGNtgqr4VHwmV9vYnSrybGg18C529JuTRFLlSJBM1Qo4RKwDHuA2iTVZyjo51WyAjrz27B6M0yGwhw4fB/KFiA/+UyLGymuljpXMv5WZxo3bFqFqSkcExjpjGI6klNQHt3QI5Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YmdYOxDo; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42BFsGpW014793;
	Mon, 11 Mar 2024 15:54:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=YX+/25KQmDMtuk6beAw4gYUoyBzSATAPBx7GNiWq54Q=;
 b=YmdYOxDolyGbGPL9tNk9GWxfrU6bez1t6A6uuOAgfd3c6gPF7a8F1wV6/IEn6+LzkZJb
 mg9Hf5CQ05nV96S4Cp87LwWzUCJA3HogqsdJHQxWEYDWi4YWX2tgMekg8J2sAknj6B0H
 MM7RKnRQzTD2A9yM+iNhFtcKaFagcuiF/oIKVN22uKkHz7b42w8nG3JD+UuSEnRIxVQA
 u9duTtkS3VLU02VwH1MxYWgMrlS4Dv28MiKOO57SrmGm40faReKgcaU4jvZCBqdu298a
 h0v6nCOZ2YSRYC14JfkznihYWVDqsZIHpMGmyU+6RCcmc69cbk+fDTK2dQ1vtDl8MDqU Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wt4p88ex0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Mar 2024 15:54:25 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42BFXPgD024404;
	Mon, 11 Mar 2024 15:54:24 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wt4p88er3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Mar 2024 15:54:24 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42BCx5tT015485;
	Mon, 11 Mar 2024 15:52:25 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ws2fyhk6h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Mar 2024 15:52:25 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42BFqMDW45548004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Mar 2024 15:52:24 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0212C58053;
	Mon, 11 Mar 2024 15:52:22 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B30958059;
	Mon, 11 Mar 2024 15:52:19 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.78.110])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 11 Mar 2024 15:52:19 +0000 (GMT)
Message-ID: <77e02ecf8b87ab83ee6e34d1118f13c8fb83353b.camel@linux.ibm.com>
Subject: Re: [PATCH vhost v2 1/4] virtio: find_vqs: pass struct instead of
 multi parameters
From: Eric Farman <farman@linux.ibm.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>, virtualization@lists.linux.dev
Cc: Richard Weinberger <richard@nod.at>,
        Anton Ivanov
 <anton.ivanov@cambridgegreys.com>,
        Johannes Berg
 <johannes@sipsolutions.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Ilpo
 =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Vadim
 Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck
 <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Michael
 S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-um@lists.infradead.org,
        platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 11 Mar 2024 11:52:19 -0400
In-Reply-To: <20240311072113.67673-2-xuanzhuo@linux.alibaba.com>
References: <20240311072113.67673-1-xuanzhuo@linux.alibaba.com>
	 <20240311072113.67673-2-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FMt9OmBDBX8TW4TdSfNa-7EqZo2-lqc6
X-Proofpoint-GUID: yINxBnMN9NkSpBInJ1GIjKG1RBbYvE1Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-11_10,2024-03-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311290000 definitions=main-2403110120

On Mon, 2024-03-11 at 15:21 +0800, Xuan Zhuo wrote:
> Now, we pass multi parameters to find_vqs. These parameters
> may work for transport or work for vring.
>=20
> And find_vqs has multi implements in many places:
>=20
> =C2=A0arch/um/drivers/virtio_uml.c
> =C2=A0drivers/platform/mellanox/mlxbf-tmfifo.c
> =C2=A0drivers/remoteproc/remoteproc_virtio.c
> =C2=A0drivers/s390/virtio/virtio_ccw.c
> =C2=A0drivers/virtio/virtio_mmio.c
> =C2=A0drivers/virtio/virtio_pci_legacy.c
> =C2=A0drivers/virtio/virtio_pci_modern.c
> =C2=A0drivers/virtio/virtio_vdpa.c
>=20
> Every time, we try to add a new parameter, that is difficult.
> We must change every find_vqs implement.
>=20
> One the other side, if we want to pass a parameter to vring,
> we must change the call path from transport to vring.
> Too many functions need to be changed.
>=20
> So it is time to refactor the find_vqs. We pass a structure
> cfg to find_vqs(), that will be passed to vring by transport.
>=20
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> =C2=A0arch/um/drivers/virtio_uml.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 23 +++----
> =C2=A0drivers/platform/mellanox/mlxbf-tmfifo.c | 13 ++--
> =C2=A0drivers/remoteproc/remoteproc_virtio.c=C2=A0=C2=A0 | 28 ++++-----
> =C2=A0drivers/s390/virtio/virtio_ccw.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 29 +++++----
> =C2=A0drivers/virtio/virtio_mmio.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 26 ++++----
> =C2=A0drivers/virtio/virtio_pci_common.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 60 +++++++++---------
> =C2=A0drivers/virtio/virtio_pci_common.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 9 +--
> =C2=A0drivers/virtio/virtio_pci_legacy.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 11 ++--
> =C2=A0drivers/virtio/virtio_pci_modern.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 33 ++++++----
> =C2=A0drivers/virtio/virtio_vdpa.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 36 +++++------
> =C2=A0include/linux/virtio_config.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 77 +++++++++++++++++++---
> --
> =C2=A011 files changed, 192 insertions(+), 153 deletions(-)
>=20
>=20

...snip...

>=20
> diff --git a/drivers/virtio/virtio_pci_modern.c
> b/drivers/virtio/virtio_pci_modern.c
> index f62b530aa3b5..b2cdf5d3824d 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -530,9 +530,7 @@ static bool vp_notify_with_data(struct virtqueue
> *vq)
> =C2=A0static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
> =C2=A0				=C2=A0 struct virtio_pci_vq_info *info,
> =C2=A0				=C2=A0 unsigned int index,
> -				=C2=A0 void (*callback)(struct virtqueue
> *vq),
> -				=C2=A0 const char *name,
> -				=C2=A0 bool ctx,
> +				=C2=A0 struct virtio_vq_config *cfg,
> =C2=A0				=C2=A0 u16 msix_vec)
> =C2=A0{
> =C2=A0
> @@ -563,8 +561,11 @@ static struct virtqueue *setup_vq(struct
> virtio_pci_device *vp_dev,
> =C2=A0	/* create the vring */
> =C2=A0	vq =3D vring_create_virtqueue(index, num,
> =C2=A0				=C2=A0=C2=A0=C2=A0 SMP_CACHE_BYTES, &vp_dev->vdev,
> -				=C2=A0=C2=A0=C2=A0 true, true, ctx,
> -				=C2=A0=C2=A0=C2=A0 notify, callback, name);
> +				=C2=A0=C2=A0=C2=A0 true, true,
> +				=C2=A0=C2=A0=C2=A0 cfg->ctx ? cfg->ctx[cfg-
> >cfg_idx] : false,
> +				=C2=A0=C2=A0=C2=A0 notify,
> +				=C2=A0=C2=A0=C2=A0 cfg->callbacks[cfg->cfg_idx],
> +				=C2=A0=C2=A0=C2=A0 cfg->names[cfg->cfg_idx]);
> =C2=A0	if (!vq)
> =C2=A0		return ERR_PTR(-ENOMEM);
> =C2=A0
> @@ -593,15 +594,11 @@ static struct virtqueue *setup_vq(struct
> virtio_pci_device *vp_dev,
> =C2=A0	return ERR_PTR(err);
> =C2=A0}
> =C2=A0
> -static int vp_modern_find_vqs(struct virtio_device *vdev, unsigned
> int nvqs,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct virtqueue *vqs[],
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vq_callback_t *callbacks[],
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const char * const names[], const bool
> *ctx,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct irq_affinity *desc)
> +static int vp_modern_find_vqs(struct virtio_device *vdev, struct
> virtio_vq_config *cfg)
> =C2=A0{
> =C2=A0	struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> =C2=A0	struct virtqueue *vq;
> -	int rc =3D vp_find_vqs(vdev, nvqs, vqs, callbacks, names, ctx,
> desc);
> +	int rc =3D vp_find_vqs(vdev, cfg);
> =C2=A0
> =C2=A0	if (rc)
> =C2=A0		return rc;
> @@ -739,10 +736,17 @@ static bool vp_get_shm_region(struct
> virtio_device *vdev,
> =C2=A0static int vp_modern_create_avq(struct virtio_device *vdev)
> =C2=A0{
> =C2=A0	struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> +	vq_callback_t *callbacks[] =3D { NULL };
> +	struct virtio_vq_config cfg =3D {};
> =C2=A0	struct virtio_pci_admin_vq *avq;
> =C2=A0	struct virtqueue *vq;
> +	const char *names[1];
> =C2=A0	u16 admin_q_num;
> =C2=A0
> +	cfg.nvqs =3D 1;
> +	cfg.callbacks =3D callbacks;
> +	cfg.names =3D names;
> +
> =C2=A0	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
> =C2=A0		return 0;
> =C2=A0
> @@ -753,8 +757,11 @@ static int vp_modern_create_avq(struct
> virtio_device *vdev)
> =C2=A0	avq =3D &vp_dev->admin_vq;
> =C2=A0	avq->vq_index =3D vp_modern_avq_index(&vp_dev->mdev);
> =C2=A0	sprintf(avq->name, "avq.%u", avq->vq_index);
> -	vq =3D vp_dev->setup_vq(vp_dev, &vp_dev->admin_vq.info, avq-
> >vq_index, NULL,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 avq->name, NULL,
> VIRTIO_MSI_NO_VECTOR);
> +
> +	cfg.names[0] =3D avq->name;

While looking at the s390 changes, I observe that the above fails to
compile and is subsequently fixed in patch 2:

drivers/virtio/virtio_pci_modern.c: In function =E2=80=98vp_modern_create_a=
vq=E2=80=99:
drivers/virtio/virtio_pci_modern.c:761:22: error: assignment of read-
only location =E2=80=98*cfg.names=E2=80=99
  761 |         cfg.names[0] =3D avq->name;
      |                      ^




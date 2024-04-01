Return-Path: <kvm+bounces-13288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2553894543
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 21:06:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D43941C2159B
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 19:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE73651C52;
	Mon,  1 Apr 2024 19:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FKMzgUr0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28063F9DF;
	Mon,  1 Apr 2024 19:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711998399; cv=none; b=VJc1sGPX2cmWdiLbrH9FOUuUiH4oQfndQaZ/IFJbo4n4AacPR5pYXp1Tk7gl2dZREyP+kEakG6ajK5j74mRd/DepbjssEZaMHDEIS4sEMQg73DpcY+pcTmEgGGXwqcQ9TlH36CBxMIunlllYB4lU6AEHqvcpXGn7LGvdQQOASLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711998399; c=relaxed/simple;
	bh=rjNr/pkF7Zi9GQbj36MX++L9VFMLGqOwGMlKWkh3//g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OeX9kX59WMasWVCLJ2RZ4rDd2/bkZOIaqWBt1mPr0rn6Vyrsk6Tryn+Ni16n7Tqxvp2XJpjfbkbglZyJGUjhnGhKbdvDK01f9Yt6uOtco3cJl8p9R0kDDMySqqx/x4Htobr0YZawBvgQsomaazyRROkzoxyobEYyEaJirBR/1bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FKMzgUr0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 431H0tna025580;
	Mon, 1 Apr 2024 19:06:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=rjNr/pkF7Zi9GQbj36MX++L9VFMLGqOwGMlKWkh3//g=;
 b=FKMzgUr0AzqDormifWvPE6DsILKOBJO3u+o/acdlt2fzj9QwbZzzCfXeuCLjHIMUxL8B
 eJE7Z6eXsl/QCcXaAM+wCOwcQr8Mq6ZwJ7zStxERYxToKcPovpGK7Bq2fIeGyVF+4MZ6
 dqKnx4T9oUkL2c815+XyUPkuILfA8I3c0UdgyE2fg1rOtX1Qu/kxbfugurZ6YKIoX4tT
 TZBzhGQ/b4BvQmJEg7QhTOgnrL856pSpawhTmA7tTEnTvbL/MckFI0HGW5JCVeVHVXB9
 ctBtE4I8Mj7Izy0zEyZrf27bpaNVhPuG/5KP8zrAAyJufg1P4IuD5zLVF418VhYPCYkw tA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x80xtr93u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Apr 2024 19:06:10 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 431J6Ai0020189;
	Mon, 1 Apr 2024 19:06:10 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x80xtr93q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Apr 2024 19:06:10 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 431Gq9Vl029593;
	Mon, 1 Apr 2024 19:06:09 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3x6ys2sfqq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Apr 2024 19:06:09 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 431J65Ug38470398
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Apr 2024 19:06:08 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAE015805B;
	Mon,  1 Apr 2024 19:06:05 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4DF9B5805D;
	Mon,  1 Apr 2024 19:06:03 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.184.184])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Apr 2024 19:06:03 +0000 (GMT)
Message-ID: <c872bd1d0f437c7902c2f451d73b99b753326a62.camel@linux.ibm.com>
Subject: Re: [PATCH vhost v7 3/6] virtio: find_vqs: pass struct instead of
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
        David Hildenbrand <david@redhat.com>,
        Jason
 Wang <jasowang@redhat.com>, linux-um@lists.infradead.org,
        platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 01 Apr 2024 15:06:02 -0400
In-Reply-To: <20240328080348.3620-4-xuanzhuo@linux.alibaba.com>
References: <20240328080348.3620-1-xuanzhuo@linux.alibaba.com>
	 <20240328080348.3620-4-xuanzhuo@linux.alibaba.com>
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
X-Proofpoint-GUID: ktYJ0UIuKBdVSR5gs4b-tBSFX-AjU1vl
X-Proofpoint-ORIG-GUID: zfc1teemjjE0oSdJpzeK0Lx1Y510ppG4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-01_14,2024-04-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2404010134

On Thu, 2024-03-28 at 16:03 +0800, Xuan Zhuo wrote:
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
> Because the vp_modern_create_avq() use the "const char *names[]",
> and the virtio_uml.c changes the name in the subsequent commit, so
> change the "names" inside the virtio_vq_config from "const char
> *const
> *names" to "const char **names".
>=20
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> ---
> =C2=A0arch/um/drivers/virtio_uml.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 22 +++----
> =C2=A0drivers/platform/mellanox/mlxbf-tmfifo.c | 13 ++--
> =C2=A0drivers/remoteproc/remoteproc_virtio.c=C2=A0=C2=A0 | 25 ++++----
> =C2=A0drivers/s390/virtio/virtio_ccw.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 28 ++++-----
> =C2=A0drivers/virtio/virtio_mmio.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 23 ++++---
> =C2=A0drivers/virtio/virtio_pci_common.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 57 ++++++++----------
> =C2=A0drivers/virtio/virtio_pci_common.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 9 +--
> =C2=A0drivers/virtio/virtio_pci_legacy.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 11 ++--
> =C2=A0drivers/virtio/virtio_pci_modern.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 32 ++++++----
> =C2=A0drivers/virtio/virtio_vdpa.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 33 +++++-----
> =C2=A0include/linux/virtio_config.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 76 ++++++++++++++++++----
> --
> =C2=A011 files changed, 175 insertions(+), 154 deletions(-)

Acked-by: Eric Farman <farman@linux.ibm.com> # s390


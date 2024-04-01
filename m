Return-Path: <kvm+bounces-13287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84CB5894527
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 21:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BA9D281BC6
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 19:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D587B51C46;
	Mon,  1 Apr 2024 19:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bAc4K7FD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFF0249E4;
	Mon,  1 Apr 2024 19:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711998186; cv=none; b=GDKdSTiD+YxaWEDfeWtKN2P3Hhi9AdlIObxzIjNoFY5tyUED+dbLhXWRv61n2UnlwX9TuZ7E5Tz+7od4CwH/VD28ae9PDEHkFAr9WKDA6UlZ1WmgGfhqSny75GPXm0XX1rYlmyE+r7QdJFgLEnTw9T7Sa6ezSyM6uBgE/nDRVnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711998186; c=relaxed/simple;
	bh=JbQ/vyagne1B2SNAZ1pSK9x8j0xrTBqxnXBPQrwReEA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NjibEzeIE4linYMskbtOxCnmoXJ4CFXxmoZHNSVGNFcQkuBeTT6x0eg/VoLZi5ascGbDipSO01j5LFScKmialA8TNdmlSccqjp4zT/ueroHFnEXghylkrLAJUp0nl3sJmlwoFXg6P8Z/mOnYAKAz71tRRBDkiGged8dh1UlK0Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bAc4K7FD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 431IvYNB011088;
	Mon, 1 Apr 2024 19:02:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=JbQ/vyagne1B2SNAZ1pSK9x8j0xrTBqxnXBPQrwReEA=;
 b=bAc4K7FDIfOzcAy62OkeeAUsX6ql6uHvU/ukjq5DsKj7m96BB1g3nuoRzKfPz/IUm1xt
 0fy2cUAG1IgJqQH24E3k0a3ZPX3Z/7hozrvV/+m5MjL4+LdTcbBoT9ZF7AmMq58FUOyD
 0ztKcecNXpz9I5+juG+tT9Of/8Bpd6hrSvYBKYCznnVYqCVWK8PnQuoI9gEG5xt3Rc6+
 L12jo4rcmbD+5bevoeW6ZwlgCvmnMzvTi0SnUHxeamPh0vqoqgZXDEmqxkt4Ig3Zkq4W
 sdoPpLXleVhq4Kl7GHQYBmIM10vOyMubCxbpyWbqbiKxNCDfRJDOugnp/33z8skRRDmV Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x82nf00gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Apr 2024 19:02:23 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 431J2MA1020505;
	Mon, 1 Apr 2024 19:02:22 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x82nf00gn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Apr 2024 19:02:22 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 431J2Ds3015234;
	Mon, 1 Apr 2024 19:02:21 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3x6y9ksk1b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Apr 2024 19:02:21 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 431J2Iru23134946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Apr 2024 19:02:20 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 536B058058;
	Mon,  1 Apr 2024 19:02:18 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A75E25805C;
	Mon,  1 Apr 2024 19:02:15 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.184.184])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Apr 2024 19:02:15 +0000 (GMT)
Message-ID: <00311e8bb63ba873da9906d87e49499f40df5134.camel@linux.ibm.com>
Subject: Re: [PATCH vhost v7 2/6] virtio: remove support for names array
 entries being null.
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
Date: Mon, 01 Apr 2024 15:02:15 -0400
In-Reply-To: <20240328080348.3620-3-xuanzhuo@linux.alibaba.com>
References: <20240328080348.3620-1-xuanzhuo@linux.alibaba.com>
	 <20240328080348.3620-3-xuanzhuo@linux.alibaba.com>
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
X-Proofpoint-ORIG-GUID: P1ukwj2SO_fm-loIj3BYJeRlaiRy_jcA
X-Proofpoint-GUID: coub_UfOYCf5qBMsA2tFbBkXJ8453ebI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-01_14,2024-04-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2404010134

On Thu, 2024-03-28 at 16:03 +0800, Xuan Zhuo wrote:
> commit 6457f126c888 ("virtio: support reserved vqs") introduced this
> support. Multiqueue virtio-net use 2N as ctrl vq finally, so the
> logic
> doesn't apply. And not one uses this.
>=20
> On the other side, that makes some trouble for us to refactor the
> find_vqs() params.
>=20
> So I remove this support.
>=20
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> ---
> =C2=A0arch/um/drivers/virtio_uml.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 8 ++++----
> =C2=A0drivers/remoteproc/remoteproc_virtio.c | 11 ++++-------
> =C2=A0drivers/s390/virtio/virtio_ccw.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 8 ++++----
> =C2=A0drivers/virtio/virtio_mmio.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 11 ++++-------
> =C2=A0drivers/virtio/virtio_pci_common.c=C2=A0=C2=A0=C2=A0=C2=A0 | 18 +++=
++++++---------
> =C2=A0drivers/virtio/virtio_vdpa.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 11 ++++-------
> =C2=A0include/linux/virtio_config.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A07 files changed, 30 insertions(+), 39 deletions(-)

Acked-by: Eric Farman <farman@linux.ibm.com> # s390


Return-Path: <kvm+bounces-13289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC0BB894548
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 21:08:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E009A1C21932
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 19:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED574524DD;
	Mon,  1 Apr 2024 19:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h8kngFWD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69428F9DF;
	Mon,  1 Apr 2024 19:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711998475; cv=none; b=MPyVmYcV/lWErSIXrTkVeObExN/GjzlfBDWY7XrAvVN0kWqDv9HP6QIuK2SimK4N/8ynXdRfSmEbdZB+O22zzphSs0KO8uO7id9JxJnpRqsTxmWcqOv2h0Zmhbx2gV0Kw4XVOxZsm8NDpSysR8i2gzGcgP3FxvsVDgcbJzanXO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711998475; c=relaxed/simple;
	bh=/Zzsl+Bkc3z9NpQG00hOGWdteA94EcSnyYVSA5spADQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EEJjbja9Hy7FhbKFpZvqqfEEfD6aJ90qyQAuAT6sPpOFrCrzwTaRN7onr/avqhcN+RguoTdijc0LVlhNYRor34YyymY+WSSLp/vUCVFGKgFdHfNVP6fuj323mggTyCb0GKDxn6O824zS/Z+l7hMSZwCrL1Zbge8B88CupUt/wBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=h8kngFWD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 431J3Bsq027876;
	Mon, 1 Apr 2024 19:07:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/Zzsl+Bkc3z9NpQG00hOGWdteA94EcSnyYVSA5spADQ=;
 b=h8kngFWDGj4HGyH/fr/piW0YeLuVa2s2IAGvNTjGwsDN/g6F4gE4LSqXCXOLLZkT4QV7
 ZMIwG+lr4glBhpvd2zW/LqovGYk0HO6hKj0rVJl6LITxrRlojirADhKhWCUpILYxbD95
 +DYDf2cpMvNdHO+zRHTw7YPz4I/fSctrlgSbwwd9Dx3xmCwo0Lt+9JHN59x8cj4vDA3z
 I6cHYfs1hLABzR54cry5cekh6PC3tBLjxb5i/F4KH9AZ9/rG+QteQh5AAxa6t2Ur83Bb
 k9BFjjPWeGKWIWvtnNL2NBWmCGXS4e1V9D1D38/W4/ehPi2zwzfIRTllUJZfVwlJwa7l VA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x82r2g090-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Apr 2024 19:07:33 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 431J7Xm7000549;
	Mon, 1 Apr 2024 19:07:33 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x82r2g08w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Apr 2024 19:07:33 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 431H2k6B008425;
	Mon, 1 Apr 2024 19:07:32 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3x6w2tt8a1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Apr 2024 19:07:32 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 431J7SLR22479482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Apr 2024 19:07:30 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 60B555805A;
	Mon,  1 Apr 2024 19:07:28 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC2EA5806E;
	Mon,  1 Apr 2024 19:07:26 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.184.184])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Apr 2024 19:07:26 +0000 (GMT)
Message-ID: <64ab5c9cc88caa904e76f650b19849d39be7038b.camel@linux.ibm.com>
Subject: Re: [PATCH vhost v7 4/6] virtio: vring_create_virtqueue: pass
 struct instead of multi parameters
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
Date: Mon, 01 Apr 2024 15:07:26 -0400
In-Reply-To: <20240328080348.3620-5-xuanzhuo@linux.alibaba.com>
References: <20240328080348.3620-1-xuanzhuo@linux.alibaba.com>
	 <20240328080348.3620-5-xuanzhuo@linux.alibaba.com>
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
X-Proofpoint-ORIG-GUID: 1K2BfUVYRRE0SvKwv6mgrRPJ9DAZrLuc
X-Proofpoint-GUID: fFVMYXoCuPhDEznBbvUxsMiJXZL01SvC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-01_14,2024-04-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2404010134

On Thu, 2024-03-28 at 16:03 +0800, Xuan Zhuo wrote:
> Now, we pass multi parameters to vring_create_virtqueue. These
> parameters
> may from transport or from driver.
>=20
> vring_create_virtqueue is called by many places.
> Every time, we try to add a new parameter, that is difficult.
>=20
> If parameters from the driver, that should directly be passed to
> vring.
> Then the vring can access the config from driver directly.
>=20
> If parameters from the transport, we squish the parameters to a
> structure. That will be helpful to add new parameter.
>=20
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> ---
> =C2=A0arch/um/drivers/virtio_uml.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
14 +++++---
> =C2=A0drivers/s390/virtio/virtio_ccw.c=C2=A0=C2=A0 | 14 ++++----
> =C2=A0drivers/virtio/virtio_mmio.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
14 ++++----
> =C2=A0drivers/virtio/virtio_pci_legacy.c | 15 ++++----
> =C2=A0drivers/virtio/virtio_pci_modern.c | 15 ++++----
> =C2=A0drivers/virtio/virtio_ring.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
57 ++++++++++++----------------
> --
> =C2=A0drivers/virtio/virtio_vdpa.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
21 +++++------
> =C2=A0include/linux/virtio_ring.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 51 +++++++++++++-------------
> =C2=A08 files changed, 101 insertions(+), 100 deletions(-)

Acked-by: Eric Farman <farman@linux.ibm.com> # s390


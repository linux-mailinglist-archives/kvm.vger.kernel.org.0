Return-Path: <kvm+bounces-19588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3D77907582
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 16:43:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 162F61C225FE
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 14:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 051B414601C;
	Thu, 13 Jun 2024 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RKJFOfg5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B7D399;
	Thu, 13 Jun 2024 14:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718289798; cv=none; b=D9DsRlb4/D04a+WltEhTd+RxcXsF2wI9Q/Vn5DyHvk5RL80qAeR1Wifkw4prnWMC5j+4/G1Z9EMg0G8vhZF6b0eVjOMG+Qs84glvgR1WwTTkoNlcf8YZmutlipv73Fm2oxRy89dtBQKYtZTc4k2c5EqDn1mzvnwQVjUyifiXdFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718289798; c=relaxed/simple;
	bh=MNLHafA+Ciwm9ca/YPOlFYz5pnxVndCTdaEEfb5f84Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VMDYtrPPPQr3pW3eMJK/WyOHQj4k4DeyiT/8Q8W+C6xZhBTpmu8NYVmW4Iv5oJ4j07305gZlnZjhgtnWXgudCa+GGpz985gvp8IprfQ/koixpxU6GR5+RMSeM5obQH1a1pLVG6PmqF+tnQsuxSTAndI5/fg19CwjUi59VGq8WTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RKJFOfg5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45DBv55Z015855;
	Thu, 13 Jun 2024 14:43:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	MNLHafA+Ciwm9ca/YPOlFYz5pnxVndCTdaEEfb5f84Y=; b=RKJFOfg5jMYlpIKq
	NgLlGlqnlABBtOVKsjOoNzfQchuM6mUiSdIX8e5pzvghQnPks3k/m6GfB+3+t1yQ
	kiHIMXg4qXGELJrRLNWAe6fKGXdpxJOjTs1SUTy0Fe5Sc9VpVNQgFQGhNKUUD+tV
	R9X2NO72Rw5gZd1O2r6iHBvmbh90I9ofMlpjL77l/MFLre3lzM9RlNvOpZUNhJR2
	mDKBUJXlp7QK1L0KEXWderLvHUjrw+xfdNFoLADAPUKRsw5WM8dh0N7q4cCfXwkk
	+ozymA8NUXmBPo1RLiNw00v6P360NZLTUQ/Jc0F74+HH4dQtYEYI6Q0detX52PMJ
	iOMcYA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yqr0vssf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Jun 2024 14:43:14 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45DEhE6V010922;
	Thu, 13 Jun 2024 14:43:14 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yqr0vssey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Jun 2024 14:43:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45DD8U6X028690;
	Thu, 13 Jun 2024 14:43:13 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yn1murrvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Jun 2024 14:43:13 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45DEhAUp56885742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Jun 2024 14:43:12 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC97258063;
	Thu, 13 Jun 2024 14:43:09 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45B545806A;
	Thu, 13 Jun 2024 14:43:08 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.123.97])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Jun 2024 14:43:08 +0000 (GMT)
Message-ID: <aea0fbb0d44748bb4419495d6d95485e585f65f0.camel@linux.ibm.com>
Subject: Re: [PATCH 1/1] s390/virtio_ccw: fix config change notifications
From: Eric Farman <farman@linux.ibm.com>
To: Halil Pasic <pasic@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Boqiao Fu <bfu@redhat.com>, Sebastian Mitterle <smitterl@redhat.com>
Date: Thu, 13 Jun 2024 10:43:07 -0400
In-Reply-To: <20240611214716.1002781-1-pasic@linux.ibm.com>
References: <20240611214716.1002781-1-pasic@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 (3.52.2-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XlhU8Oxnafd1emPskSXGiTk1rdePy1qK
X-Proofpoint-ORIG-GUID: moV_gGsPmA9CWHT4ECPWkM9LYP6jqp6v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_07,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 clxscore=1011 malwarescore=0 mlxscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=788 priorityscore=1501 spamscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406130105

On Tue, 2024-06-11 at 23:47 +0200, Halil Pasic wrote:
> Commit e3e9bda38e6d ("s390/virtio_ccw: use DMA handle from DMA API")
> broke configuration change notifications for virtio-ccw by putting
> the
> DMA address of *indicatorp directly into ccw->cda disregarding the
> fact
> that if !!(vcdev->is_thinint) then the function
> virtio_ccw_register_adapter_ind() will overwrite that ccw->cda value
> with the address of the virtio_thinint_area so it can actually set up
> the adapter interrupts via CCW_CMD_SET_IND_ADAPTER.=C2=A0 Thus we end up
> pointing to the wrong object for both CCW_CMD_SET_IND if setting up
> the
> adapter interrupts fails, and for CCW_CMD_SET_CONF_IND regardless
> whether it succeeds or fails.
>=20
> To fix this, let us save away the dma address of *indicatorp in a
> local
> variable, and copy it to ccw->cda after the "vcdev->is_thinint"
> branch.
>=20
> Reported-by: Boqiao Fu <bfu@redhat.com>
> Reported-by: Sebastian Mitterle <smitterl@redhat.com>
> Fixes: e3e9bda38e6d ("s390/virtio_ccw: use DMA handle from DMA API")
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> ---
> I know that checkpatch.pl complains about a missing 'Closes' tag.
> Unfortunately I don't have an appropriate URL at hand. @Sebastian,
> @Boqiao: do you have any suggetions?
> ---
> =C2=A0drivers/s390/virtio/virtio_ccw.c | 4 +++-
> =C2=A01 file changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Eric Farman <farman@linux.ibm.com>


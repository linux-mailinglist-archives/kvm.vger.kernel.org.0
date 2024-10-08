Return-Path: <kvm+bounces-28119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB86C994301
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 10:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B54E1F294DF
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 08:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C166C1C1AB1;
	Tue,  8 Oct 2024 08:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Uy16n8FC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE0823A6;
	Tue,  8 Oct 2024 08:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728377293; cv=none; b=jRK359xumk/9yec8ueVA/+jWTX/7X3HD8Iyi3y4+92mj/CFC3B5zSYaToPctAlh/GqrJamC3q0eLS/hc4+wIMIRb2ygKTBLTG6yrqjQ4NoJ74Ap0T+WXDI+8kfStTxUwC5gWbbpyN0AcDkOrl3XrVCkPJwi43Un2F8wTPoApQpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728377293; c=relaxed/simple;
	bh=P5IJuUy+T74DhW4ApCo/oZ/vVvE3y/nqd0OTnW1YJq8=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=oswHVXzOUIQE3Fls97bUEg0W77+ZDXAm7nbQSZ7HTgTXETc85xILYpz/vsHWKW3uwhdvwghyfN1UyeeYMSARyFAa1cAufpA0dX4XeWCprYZO7qxuurgfoZ17Y+bsJNSc91zJAaMOgLllZiTfvie7wXG5gLX255lWkX2PM4iuN+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Uy16n8FC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4988NU54025972;
	Tue, 8 Oct 2024 08:47:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:subject:in-reply-to:references:date:message-id:content-type
	:content-transfer-encoding:mime-version; s=pp1; bh=7MP11VUlfXKwc
	pm96rLnvLT5SEO86aFkUlgq9ArC7xw=; b=Uy16n8FC6csKR+UeqXTVERRc6GQKK
	anpypxPvUC9hrahxjnQQXcYusKfEu+f7cgbfij1D/AnD7Kn5dylE8Nr3Z6cpisvw
	9ByKKgEykA7NE+ipO/C/jWsLN5LMnuX61x/PXQrI+iQBoqr1kRl9M5goQ0/81J7g
	WzN6BPKltUAU84EHUKSW2oyRFiTGdEItVii4WChHeYlwVQ6F2jEmURFPQqLhoMq/
	4quwa9IRLmudpI5jHgKqpo0W/mZ4I+ws5rPwHn6gIbZnaDNzawn6kBbHMv4NIv8q
	m8DAqpWfUkUsBlG9ppfcldq7/OyL0YMyewjNv/2h3K8RatusEARTHoQow==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 425168047k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Oct 2024 08:47:56 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4988lu97023436;
	Tue, 8 Oct 2024 08:47:56 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 425168047a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Oct 2024 08:47:56 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4986n1O6022856;
	Tue, 8 Oct 2024 08:47:54 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 423h9ju3cy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Oct 2024 08:47:54 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4988loZu52232558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 8 Oct 2024 08:47:50 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 81E8020040;
	Tue,  8 Oct 2024 08:47:50 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F8CF20049;
	Tue,  8 Oct 2024 08:47:49 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.60.219])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  8 Oct 2024 08:47:49 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Halil Pasic <pasic@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Robin Murphy
 <robin.murphy@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-s390@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] s390/virtio_ccw: fix dma_parm pointer not set up
In-Reply-To: <20241007201030.204028-1-pasic@linux.ibm.com>
References: <20241007201030.204028-1-pasic@linux.ibm.com>
Date: Tue, 08 Oct 2024 10:47:48 +0200
Message-ID: <875xq3yo97.fsf@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T7Va_BBmWNw-LhTa-SzgYLXU2lafAMMM
X-Proofpoint-ORIG-GUID: yESAaKcR7NlJ8V719IsRdztHZgQzCCjk
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-08_06,2024-10-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 adultscore=0
 clxscore=1011 spamscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410080056

On Mon, Oct 07, 2024 at 10:10 PM +0200, Halil Pasic <pasic@linux.ibm.com> w=
rote:
> At least since commit 334304ac2bac ("dma-mapping: don't return errors
> from dma_set_max_seg_size") setting up device.dma_parms is basically
> mandated by the DMA API. As of now Channel (CCW) I/O in general does not
> utilize the DMA API, except for virtio. For virtio-ccw however the
> common virtio DMA infrastructure is such that most of the DMA stuff
> hinges on the virtio parent device, which is a CCW device.
>
> So lets set up the dma_parms pointer for the CCW parent device and hope
> for the best!
>
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: 334304ac2bac ("dma-mapping: don't return errors from dma_set_max_s=
eg_size")
> Reported-by: "Marc Hartmayer" <mhartmay@linux.ibm.com>
> Closes: https://bugzilla.linux.ibm.com/show_bug.cgi?id=3D209131

I guess, this line can be removed as it=E2=80=99s internal only.

> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> ---
>
> In the long run it may make sense to move dma_parms into struct
> ccw_device, since layering-wise it is much cleaner. I decided
> to put it in virtio_ccw_device because currently it is only used for
> virtio.
>
> ---

[=E2=80=A6snip=E2=80=A6]

Thanks for fixing this!

Tested-by: Marc Hartmayer <mhartmay@linux.ibm.com>

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294


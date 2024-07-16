Return-Path: <kvm+bounces-21698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BBFC93247E
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 12:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1610F1F240D3
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 10:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C82551990A5;
	Tue, 16 Jul 2024 10:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="g1MqdYC1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D0913A416;
	Tue, 16 Jul 2024 10:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721127457; cv=none; b=gIaamZXbhCbUPaaQLqc9/vwhBu1euNMcUGqL8apnqaD8wPgyRpfVd4BuRpswRiA+sErWeJNB/nfMj2fjoOiMEcJl+Ug2WxnYgKcpFD3Wo+fFfRQ3sZpbuiKZ6dyNG0y00Ax6lmr0KCnU+Y4HgLZVkw37JkOwDSGC2W+KTElnOgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721127457; c=relaxed/simple;
	bh=u3tdViBmCFTWsqM5V2S0H18K58R1pakhIEDmxZF6AJE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H5WI6relJD1sCEc2vHZ/ptOYWLn9BNiDgOxKxMbYmCRWV9kJ8ZmgMT4Quoup977rNV37KkHHpfWiQ7fipAx0A8+AmxfMizmkKFyiAlEJTuiAZZgU3IxcWUNMRmBPYn3tcr29Y1bGEzk8BJCE24vfXSgNfQ3qh9LhORWAFeT1TyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=g1MqdYC1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46GAlTkY013924;
	Tue, 16 Jul 2024 10:57:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	5YpLZBFHa4u/yz0h1zDRTMe6ArvUdZ8SFwam82a19uI=; b=g1MqdYC16MSvXnSC
	RNEUUAV6nWW70hptfnT8bMAMjyQxdsV2SFbXGn8CI13yDWySB4Ja2XsLnHD9WD+w
	F4dCLeD19qYDE+Hanm7ADpvxXUtJ+1xh5ydIb236y6HJVCuAM4FiZ0ezaYWbFPWo
	U7LlV9dh+yAjYN6Gb5wAk9KzmylwwBSXGUU8sHtOPAyl6dLSWYDhnfYOoOfLw2LK
	Jjps/xcGLznmIpWBejvZ+cjh5WYclyfHesVhYvVizdkJrLT2GFOHnaw6GCqLTnF0
	zWJAk0TggqHOX5ZKbTf8tqrhLJRIFC2PNVQcUcIwBt/7tpZF7ckkIM9OMD6GC/Vo
	XPo38A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40dq4wr1fr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 10:57:06 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46GAv5nb025254;
	Tue, 16 Jul 2024 10:57:05 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40dq4wr1cv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 10:57:05 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46G8jlL1030523;
	Tue, 16 Jul 2024 10:52:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40c4a0ktt3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 10:52:27 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46GAqMU322872322
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 10:52:24 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA57920043;
	Tue, 16 Jul 2024 10:52:21 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C3D220040;
	Tue, 16 Jul 2024 10:52:21 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.152.224.212])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Jul 2024 10:52:21 +0000 (GMT)
Date: Tue, 16 Jul 2024 12:52:20 +0200
From: Halil Pasic <pasic@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Alexander Duyck
 <alexander.h.duyck@linux.intel.com>,
        Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg
 <johannes@sipsolutions.net>,
        Bjorn Andersson <andersson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck
 <cohuck@redhat.com>, Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Jason
 Wang <jasowang@redhat.com>,
        Eugenio =?UTF-8?B?UMOpcmV6?=
 <eperezma@redhat.com>,
        linux-um@lists.infradead.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, Halil Pasic
 <pasic@linux.ibm.com>
Subject: Re: [PATCH v2 2/2] virtio: fix vq # for balloon
Message-ID: <20240716125220.677dccf4.pasic@linux.ibm.com>
In-Reply-To: <3d655be73ce220f176b2c163839d83699f8faf43.1720611677.git.mst@redhat.com>
References: <cover.1720611677.git.mst@redhat.com>
	<3d655be73ce220f176b2c163839d83699f8faf43.1720611677.git.mst@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -ciPuNbu1ulB9x3MDH6mw0VxJdTjfl_5
X-Proofpoint-ORIG-GUID: _zkRs-FyWlqEBV9NEtx1Xwx1HT6kmSDZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_19,2024-07-16_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 clxscore=1011 priorityscore=1501 adultscore=0
 impostorscore=0 phishscore=0 mlxlogscore=866 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407160079

On Wed, 10 Jul 2024 07:42:46 -0400
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -694,7 +694,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  {
>  	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>  	dma64_t *indicatorp = NULL;
> -	int ret, i, queue_idx = 0;
> +	int ret, i;
>  	struct ccw1 *ccw;
>  	dma32_t indicatorp_dma = 0;
>  
> @@ -710,7 +710,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  			continue;
>  		}
>  
> -		vqs[i] = virtio_ccw_setup_vq(vdev, queue_idx++, vqi->callback,
> +		vqs[i] = virtio_ccw_setup_vq(vdev, i, vqi->callback,
>  					     vqi->name, vqi->ctx, ccw);
>  		if (IS_ERR(vqs[i])) {
>  			ret = PTR_ERR(vqs[i]);

Acked-by: Halil Pasic <pasic@linux.ibm.com> #s390


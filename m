Return-Path: <kvm+bounces-13397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51D60895DF3
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 22:43:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74EFE1C2241D
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 20:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C60D15E1EA;
	Tue,  2 Apr 2024 20:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WKpIK81j"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B4015ADB1;
	Tue,  2 Apr 2024 20:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712090611; cv=none; b=ZJFC2hlFBlpJCWM0I/oZ7t+nhVu816sL6bnMl+H3jCFv05Sk4JmAW71o2eGINnN5OmVQdaVgwrO7f4tMAemPZ5nbFFZzpJepH/tuhrzUujW7JKtWrYbTq4LXkD9sWwuNnn7ZQQilFTVRsmCOHj9dORi77smLYmHLIPplOGrcv7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712090611; c=relaxed/simple;
	bh=aaHxh0ZajOvHS5KfJxmXsd5EvOqogaNIUdS3zyMuvq8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sPe7Pv75/6/Bz5EAmLj3oTdSU5MZouSLLjSGSf0mWzsOJvFKmHM89AgQnerWiZIgiLhXiL6XN9UovJExdgxaYS9/I8DzEL8hqpFDKUCDWj8uNdTWTeNnD8uk6aEBj3I8Ng2GF0ePcdezLiq3Hd8ZsXaOivLG4lGAh1BxwsSrcc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WKpIK81j; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 432KbuAs008721;
	Tue, 2 Apr 2024 20:43:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=vPV0uWN8wwP3Lj+X6ad0Mvu8PMemMzWRl2tBGJIudWY=;
 b=WKpIK81j1Sqg94bsntLMPQv9DGV1qFPm3nebW2nt/+tSfOsjZGEpxl25t5xvLbd7K8rG
 3ACZ0dTlEQl+fexcnfdhhyAJpG68B9zsqBuCIeGcaY0j7GliwJAUK3EtZXFDgN9INzy/
 iE3aeD+8Q41BzjAyTa4083y35u0VsjncXBR+Y8RrJVEJXJtyRd3NoVv8vQLpJZBn0JiK
 KbSZAFgpKaI2V+Of9y7eKjMp3bSA6aYQMwp/PR6A9qwgVwwgq/qW/TwBCzgcURpaScHe
 DxGtkwsa91Nk02nJXzskSvJrVwM9OUoEBGj4TfHxPfeONuQinWZECG+3ZUW7IAzOr8zB ng== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x8s7680bu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Apr 2024 20:43:09 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 432Kh8P9017157;
	Tue, 2 Apr 2024 20:43:08 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x8s7680br-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Apr 2024 20:43:08 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 432IZ0X8029593;
	Tue, 2 Apr 2024 20:43:07 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3x6ys30m11-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Apr 2024 20:43:07 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 432Kh00s55509312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Apr 2024 20:43:02 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3371F20043;
	Tue,  2 Apr 2024 20:43:00 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 908DB20040;
	Tue,  2 Apr 2024 20:42:58 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.41.83])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue,  2 Apr 2024 20:42:58 +0000 (GMT)
Date: Tue, 2 Apr 2024 22:42:56 +0200
From: Halil Pasic <pasic@linux.ibm.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg
 <johannes@sipsolutions.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Ilpo
 =?UTF-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
        Vadim Pasternak
 <vadimp@nvidia.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Mathieu
 Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>, Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
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
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic
 <pasic@linux.ibm.com>
Subject: Re: [PATCH vhost v7 4/6] virtio: vring_create_virtqueue: pass
 struct instead of multi parameters
Message-ID: <20240402224256.7370d18b.pasic@linux.ibm.com>
In-Reply-To: <20240328080348.3620-5-xuanzhuo@linux.alibaba.com>
References: <20240328080348.3620-1-xuanzhuo@linux.alibaba.com>
	<20240328080348.3620-5-xuanzhuo@linux.alibaba.com>
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
X-Proofpoint-ORIG-GUID: 3GI-WGeK5s55lBMUzMMapcBrCW7xXaZl
X-Proofpoint-GUID: 6iUy-UfqbpinpmO9UNn-I9GuSFsVdcSl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-02_13,2024-04-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 impostorscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2404020153

On Thu, 28 Mar 2024 16:03:46 +0800
Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:

> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -503,6 +503,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
>  					     struct virtio_vq_config *cfg)
>  {
>  	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
> +	struct vq_transport_config tp_cfg = {};
>  	bool (*notify)(struct virtqueue *vq);
>  	int err;
>  	struct virtqueue *vq = NULL;
> @@ -536,13 +537,14 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
>  		goto out_err;
>  	}
>  	may_reduce = vcdev->revision > 0;
> -	vq = vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_ALIGN,
> -				    vdev, true, may_reduce,
> -				    cfg->ctx ? cfg->ctx[i] : false,
> -				    notify,
> -				    cfg->callbacks[i],
> -				    cfg->names[i]);
>  
> +	tp_cfg.num = info->num;
> +	tp_cfg.vring_align = KVM_VIRTIO_CCW_RING_ALIGN;
> +	tp_cfg.weak_barriers = true;
> +	tp_cfg.may_reduce_num = may_reduce;
> +	tp_cfg.notify = notify;
> +
> +	vq = vring_create_virtqueue(vdev, i, &tp_cfg, cfg);
>  	if (!vq) {
>  		/* For now, we fail if we can't get the requested size. */
>  		dev_warn(&vcdev->cdev->dev, "no vq\n");

For the virtio-ccw part:
Acked-by: Halil Pasic <pasic@linux.ibm.com>


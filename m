Return-Path: <kvm+bounces-13389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C987F895B4C
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 20:01:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E4A51F21F4D
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 18:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EEF315AAD1;
	Tue,  2 Apr 2024 18:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aRpk6iA+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2532A14B07B;
	Tue,  2 Apr 2024 18:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712080901; cv=none; b=Tvm+4h9QI0YOV/Qi1AcMAuf7xcHA5HiZdvjjiz6FXn3HvzUKAVxmtjK9Pabvvvbjjbbltg4mkgUKns5sP7KiIL/xSz6UntPt6ebsM9FsafZ0P+dOitC5yCMvcELLVErwj1SrYYREV4yVglF7Wu2tCRORsz4lTTCkJjQ0IFbs7cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712080901; c=relaxed/simple;
	bh=I/KfB5CieqB04RJ8p97BvpVXen9Z0TrS8q4lo+lHyiI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OJxHqYr6dWv9nLDPMskoxUjojys/0SnhiWh+itFmbxJnCKFqlJJzYtiFtQZhthwiO0tuMQg8Cy32AsRJcUmjy2oIfY+G4Qp6fbi6j/17I7YFZ1x+fCu5XQ3aMAHid9uHNXh/OGXywRXqw3ghloqxKjK+FL6QWErutIKiRWw8OLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aRpk6iA+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 432HqscV029201;
	Tue, 2 Apr 2024 18:01:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ge+PCdmfdapG3nCKI7WpuuoKJVjlsUHNMa5EZQPh+Qk=;
 b=aRpk6iA+UUeeVLtiuFhtNmSaMQsQ7/8MXvzEu8Mz9fU+69iduRNpXZr4ilYShTeGvl7j
 izRH42UiYy1PGawVts2wptHJH9nKHPEVcb9LeC9zAChnX8rdlYfUdPqXyejA8yLVyAVn
 bxYtOAW+XsUXB9qZHA8XprmlMQF3LrMq9kFoE6/2LIbrud66CVO1vAVsYomrl6m0O/nC
 MZu3H4GhAdO0FgpD2zJ+yEFYnXlgSPrjIuQOZ1Tc4Sa9vK0QZ040Glv38O99yavZ9mP0
 BNS823odZ/QAGUbl7LUJSOPsZi+h31FyUGa/ykcnCSSXz75mj31jzypSvf1L76ucvfrX WA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x8pt70121-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Apr 2024 18:01:14 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 432I1Dtf009350;
	Tue, 2 Apr 2024 18:01:13 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x8pt7011r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Apr 2024 18:01:13 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 432I0tfR029616;
	Tue, 2 Apr 2024 18:01:12 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3x6ys2ypvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Apr 2024 18:01:12 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 432I16XT33620508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Apr 2024 18:01:08 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A898A2004F;
	Tue,  2 Apr 2024 18:01:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 305C120043;
	Tue,  2 Apr 2024 18:01:05 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.41.83])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue,  2 Apr 2024 18:01:05 +0000 (GMT)
Date: Tue, 2 Apr 2024 20:01:03 +0200
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
Subject: Re: [PATCH vhost v7 2/6] virtio: remove support for names array
 entries being null.
Message-ID: <20240402200103.19618d0c.pasic@linux.ibm.com>
In-Reply-To: <20240328080348.3620-3-xuanzhuo@linux.alibaba.com>
References: <20240328080348.3620-1-xuanzhuo@linux.alibaba.com>
	<20240328080348.3620-3-xuanzhuo@linux.alibaba.com>
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
X-Proofpoint-ORIG-GUID: 6KSAETINDiOyU9QFEllktnLI-PyY1diP
X-Proofpoint-GUID: xwEdoevRFYCwufoSFRJa0qEo9oBQY5g_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-02_10,2024-04-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 adultscore=0
 clxscore=1011 mlxscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2403210000 definitions=main-2404020133

On Thu, 28 Mar 2024 16:03:44 +0800
Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:

> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -659,7 +659,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  {
>  	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>  	unsigned long *indicatorp = NULL;
> -	int ret, i, queue_idx = 0;
> +	int ret, i;
>  	struct ccw1 *ccw;
>  
>  	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
> @@ -668,11 +668,11 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  
>  	for (i = 0; i < nvqs; ++i) {
>  		if (!names[i]) {
> -			vqs[i] = NULL;
> -			continue;
> +			ret = -EINVAL;
> +			goto out;
>  		}
>  
> -		vqs[i] = virtio_ccw_setup_vq(vdev, queue_idx++, callbacks[i],
> +		vqs[i] = virtio_ccw_setup_vq(vdev, i, callbacks[i],
>  					     names[i], ctx ? ctx[i] : false,
>  					     ccw);
>  		if (IS_ERR(vqs[i])) {

For the virtio-ccw part:
Acked-by: Halil Pasic <pasic@linux.ibm.com>


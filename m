Return-Path: <kvm+bounces-13396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83F20895DDA
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 22:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A3C9281937
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 20:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D03C15E1ED;
	Tue,  2 Apr 2024 20:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DW2RbcUO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8AF56B9F;
	Tue,  2 Apr 2024 20:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712090159; cv=none; b=BL70aWdvgJ61FP8xfrM6wUrFM2PsDqY+NKyce/vNJxsXdP3CBficzD3SuUIyjMulkQrhUbF5P39z67VN4ux4nJ9deQOUXhSrvy4gV/iD8YU8mG5alF1cVceR1w4sSQ0YgHQKD22i5K5DoWzCM7qVBMLMCc88Y+Ab0A2TeP9ciwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712090159; c=relaxed/simple;
	bh=gj4A/Yuus2r0ATrEc4MnLay186mwH83WZsXyCYyWME4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BVHsXju4lQgysvodfhXWOOaq28RyGjba2gP73SKBMcYKpqXlNpqDgAR+Hz+mErlm8chM0ckksnMSGpXatOkkJAGHiLlAX+RNVqEZPku71TQR7WBF8eVtAAmAJUzhJ3NcihhgoCAYmXgOY0eNZG5u9cP6PcIBmZA0B8cjxpj6fDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DW2RbcUO; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 432KPY5t000389;
	Tue, 2 Apr 2024 20:35:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=6EFIqdA8XplVJ0ZlXfVio2BHcRwEuUtC9S9wzigAU+M=;
 b=DW2RbcUO3AVtSM2K4B4m8Fk5O7A/sDhJrjK5noD2OpuJhzqpTwUJMstFQknfuSLL6J68
 FX8UjmJ5uXNrup4N2jjlYnNb03fnEFYnhoZtLfWVTUzkpGBZr1uEkkkQJkxY0Uk/5+hI
 PEoczFJ3b2mVMmlKTr+rHQBRzGlSEiUJG1qSuxclS4swMLUSCfdQ8ot1D6NybNAJ8Grl
 vijMU7WSd/WuXdIBIszVJM7axoa6Dt8AJF9/T9Rvgg3xHgK2SmZ9A7zVr36RZ6M7dgfB
 scNBTZtYHptON1oz0lyjHuxYdGFP9/vuEcdl2U61TvqeMcXAwOK6qcFEEVMPOj1smAvO HA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x8ruj81cm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Apr 2024 20:35:29 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 432KZSkJ017805;
	Tue, 2 Apr 2024 20:35:28 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x8ruj81ch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Apr 2024 20:35:28 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 432JnwGb002181;
	Tue, 2 Apr 2024 20:35:27 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3x6xjmgvag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Apr 2024 20:35:26 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 432KZLrl31392128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Apr 2024 20:35:23 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A2102004E;
	Tue,  2 Apr 2024 20:35:21 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B4B4F20043;
	Tue,  2 Apr 2024 20:35:19 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.41.83])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue,  2 Apr 2024 20:35:19 +0000 (GMT)
Date: Tue, 2 Apr 2024 22:35:18 +0200
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
Subject: Re: [PATCH vhost v7 3/6] virtio: find_vqs: pass struct instead of
 multi parameters
Message-ID: <20240402223518.0add6cd3.pasic@linux.ibm.com>
In-Reply-To: <20240328080348.3620-4-xuanzhuo@linux.alibaba.com>
References: <20240328080348.3620-1-xuanzhuo@linux.alibaba.com>
	<20240328080348.3620-4-xuanzhuo@linux.alibaba.com>
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
X-Proofpoint-GUID: 7jDpQ1yMOWcm-IM2KD26JVVAa_AXcVrs
X-Proofpoint-ORIG-GUID: sstjIMr-0FUHN7IGukXRCXEPlGwbSdCP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-02_13,2024-04-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2404020152

On Thu, 28 Mar 2024 16:03:45 +0800
Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:

> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -499,9 +499,8 @@ static void virtio_ccw_del_vqs(struct virtio_device *vdev)
>  }
>  
>  static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
> -					     int i, vq_callback_t *callback,
> -					     const char *name, bool ctx,
> -					     struct ccw1 *ccw)
> +					     int i, struct ccw1 *ccw,
> +					     struct virtio_vq_config *cfg)
>  {
>  	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>  	bool (*notify)(struct virtqueue *vq);
> @@ -538,8 +537,11 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
>  	}
>  	may_reduce = vcdev->revision > 0;
>  	vq = vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_ALIGN,
> -				    vdev, true, may_reduce, ctx,
> -				    notify, callback, name);
> +				    vdev, true, may_reduce,
> +				    cfg->ctx ? cfg->ctx[i] : false,
> +				    notify,
> +				    cfg->callbacks[i],
> +				    cfg->names[i]);
>  
>  	if (!vq) {
>  		/* For now, we fail if we can't get the requested size. */
> @@ -650,15 +652,13 @@ static int virtio_ccw_register_adapter_ind(struct virtio_ccw_device *vcdev,
>  	return ret;
>  }
>  
> -static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> -			       struct virtqueue *vqs[],
> -			       vq_callback_t *callbacks[],
> -			       const char * const names[],
> -			       const bool *ctx,
> -			       struct irq_affinity *desc)
> +static int virtio_ccw_find_vqs(struct virtio_device *vdev,
> +			       struct virtio_vq_config *cfg)
>  {
>  	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
> +	struct virtqueue **vqs = cfg->vqs;
>  	unsigned long *indicatorp = NULL;
> +	unsigned int nvqs = cfg->nvqs;
>  	int ret, i;
>  	struct ccw1 *ccw;
>  
> @@ -667,14 +667,12 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  		return -ENOMEM;
>  
>  	for (i = 0; i < nvqs; ++i) {
> -		if (!names[i]) {
> +		if (!cfg->names[i]) {
>  			ret = -EINVAL;
>  			goto out;
>  		}
>  
> -		vqs[i] = virtio_ccw_setup_vq(vdev, i, callbacks[i],
> -					     names[i], ctx ? ctx[i] : false,
> -					     ccw);
> +		vqs[i] = virtio_ccw_setup_vq(vdev, i, ccw, cfg);
>  		if (IS_ERR(vqs[i])) {
>  			ret = PTR_ERR(vqs[i]);
>  			vqs[i] = NULL;

For the virtio-ccw part:
Acked-by: Halil Pasic <pasic@linux.ibm.com>


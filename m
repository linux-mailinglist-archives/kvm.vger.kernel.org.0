Return-Path: <kvm+bounces-53641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3E11B14EC6
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 15:52:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC54118A35C2
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 13:52:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A791B4223;
	Tue, 29 Jul 2025 13:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CVukV2Yu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40F24C98;
	Tue, 29 Jul 2025 13:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753797113; cv=none; b=dKXB4tTy807lC+9Kd8Tn2dpCJH5G5RIOBZ+zIu3FC2S/IVnQZ47q+3vJlG3Sqqlgmov+2RvK6iEMONJxmLVUIrYoyh4+//9VDQCl69AiNaWP+bvzBBUHPZkALgJ0G1nttLTUW5EO9Hp8LrtvsMBFYAeBo2cqUbx9kNG0u2wh9go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753797113; c=relaxed/simple;
	bh=hoo0VZ8djB8RitqLM6jiFX6GVzpj9dIvdPNFEKlhtDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LHn4WE6+ub4GlP2GN+Jvz+jOdUAERRgVOlY1CexnYSi67WzU0RQBuRFMkw0p/YeHFv6rH1VFRDp2QclY1wdZNvFGfO4VCmcI6oQ88w1Xy3qGg7epsItCTwMfIB/IYGsPKqvd2QiJJFZ6eTBRCVsnDkssxD/Vz7fA2vchNffc1Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CVukV2Yu; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56T4YuKp022242;
	Tue, 29 Jul 2025 13:51:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=mHhfNB
	3oDoP8UAbSAi6vxVgPlsnKrJzYQS128/QQKiE=; b=CVukV2Yu4MWjjN/Vc/qcNU
	JzMQeTvoP9MQTHTq2SbeE9+OdZdqJv5wJ9KOWJy5jsSrt1PBrIYC5Ozt7VIP68j7
	EijeCaxKDsCILDFUgkSEuf0Kaa7bM9G7tc5GP6BbVO1EB77ytsAJNos5s/0w5eu1
	PYrg7EvBa1t2TqOk0OEFY/Pv4ygGGrWpbEqPolu22U29fqeen+rR+I+nWgyY6CCD
	txwFJc+tdpjCSjhy+V8niZNB0GdeJrGN8bOf/tBwKkGg2adzt7ux5Mn3OPpBsQlV
	Vr8lyYgLUBEx7SIi6j8BlPa91lENn/luI5H1ta8vIPPnkGmj7qk1iqlY/YvKlPPA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qd5f0y3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 13:51:34 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56TD3s77017464;
	Tue, 29 Jul 2025 13:51:33 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4859r02q2j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 13:51:33 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56TDpW7525428588
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 13:51:32 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF3CB5805D;
	Tue, 29 Jul 2025 13:51:32 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5995958057;
	Tue, 29 Jul 2025 13:51:32 +0000 (GMT)
Received: from [9.61.242.224] (unknown [9.61.242.224])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 29 Jul 2025 13:51:32 +0000 (GMT)
Message-ID: <f2d3027f-44d1-44d2-b89c-e01085c6d036@linux.ibm.com>
Date: Tue, 29 Jul 2025 08:51:31 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vhost: initialize vq->nheads properly
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com, eperezma@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgarzare@redhat.com, will@kernel.org, Breno Leitao <leitao@debian.org>
References: <20250729073916.80647-1-jasowang@redhat.com>
Content-Language: en-US
From: JAEHOON KIM <jhkim@linux.ibm.com>
In-Reply-To: <20250729073916.80647-1-jasowang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDEwNyBTYWx0ZWRfX3Yflp5UMOpWy
 O/YRFoiaTO1Le9cN3kuuAX9CILQQXc8SCTD/TgqoTiat/DU/Bj02LF9XA333U4W9w3U3lt+V+af
 Acsd5EScOtOT8Yfbpn135cIUC/yeERwEFdUtkxsT8NqiBfpwjU1+oXT5VV7bJiSuytzmkrG89d4
 K7avTQoW7Hj3rL74ldtIeDeHd00I+s7zViDJUCo8EHeoIHctzXuOqXsinhrzDzWy4QlHLBj8xyK
 +umj/h+wek1NOq2gWGjw5wYCQQq2eFy7gTkdB5vmGIktnOLW0lt1KS3AS3+RujSEupl8F/NkSOM
 V5x9fveXiuu9qktiJI5v18IPTzCJ82iuzxe8pc9lcFyuSo//ubT8msx1vtDb5VYLVc6icoAqGrR
 jC0MNoeozy01L+T08Eyk5qFys4FomsNQLBjlG6QKAMuiEnjWtpvr9ro2PrJisjud5J/GuNom
X-Proofpoint-ORIG-GUID: mpOpWW-OLWu6n9CXOeVuW_P66Tb9mhIX
X-Authority-Analysis: v=2.4 cv=B9q50PtM c=1 sm=1 tr=0 ts=6888d1e6 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VnNF1IyMAAAA:8 a=xNf9USuDAAAA:8
 a=20KFwNOVAAAA:8 a=wyMUYbSDCzE7wVUlRWoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: mpOpWW-OLWu6n9CXOeVuW_P66Tb9mhIX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_03,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 mlxscore=0 spamscore=0 mlxlogscore=956
 suspectscore=0 clxscore=1015 impostorscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507290107

On 7/29/2025 2:39 AM, Jason Wang wrote:
> Commit 7918bb2d19c9 ("vhost: basic in order support") introduces
> vq->nheads to store the number of batched used buffers per used elem
> but it forgets to initialize the vq->nheads to NULL in
> vhost_dev_init() this will cause kfree() that would try to free it
> without be allocated if SET_OWNER is not called.
>
> Reported-by: JAEHOON KIM <jhkim@linux.ibm.com>
> Reported-by: Breno Leitao <leitao@debian.org>
> Fixes: 7918bb2d19c9 ("vhost: basic in order support")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/vhost/vhost.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index a4873d116df1..b4dfe38c7008 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -615,6 +615,7 @@ void vhost_dev_init(struct vhost_dev *dev,
>   		vq->log = NULL;
>   		vq->indirect = NULL;
>   		vq->heads = NULL;
> +		vq->nheads = NULL;
>   		vq->dev = dev;
>   		mutex_init(&vq->mutex);
>   		vhost_vq_reset(dev, vq);
>
checked and confirmed no crash occurs.
Thanks for the fast update.

Tested-by: Jaehoon Kim <jhkim@linux.ibm.com>



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041B679F0E7
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 20:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjIMSKr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 14:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjIMSKq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 14:10:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F014219B6;
        Wed, 13 Sep 2023 11:10:41 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DI76DO012217;
        Wed, 13 Sep 2023 18:10:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ugYqT1hNsZOVMNb+4YAW7V6Uo+jc8jveQnvsLy6dC94=;
 b=i80lQLykMN0LnrJ57sx3+JpR3LSrPCyWhPSktqDQXBxK8n/lExjAKeV0QaM9PbAIw8St
 dw4no7Ed9YcxWoNBPS3kyTCBO3/6A/crWlQA2Dy8XcopSvmhKuj+e9fKdF3Vsbmg6DkC
 psxaRVkjE97w5rQg0Ntm3TzHGvQ+Li+dAP3qUGrvBb7fe7KzIr83X8Gh2RbP6MOC/fjz
 dJFDGVkHAFCqnn2YridSZA0gYvMN2TkuHfcmWf39EYP0RgSwFRR8z8LeCmksN6dN7/6m
 ziAOMkBZyPmHMEkYQbnLdwJUc8nkFEyxbeB2fMtiS2J84Pls5GD2eN14YBr8MAQ2sjAk Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3hd2safr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 18:10:40 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38DI78fo012394;
        Wed, 13 Sep 2023 18:10:39 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3hd2saf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 18:10:39 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38DHHbub012151;
        Wed, 13 Sep 2023 18:10:38 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t13dywab8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 18:10:38 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38DIAbts41288082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Sep 2023 18:10:37 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25F4B58052;
        Wed, 13 Sep 2023 18:10:37 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C164F58056;
        Wed, 13 Sep 2023 18:10:35 +0000 (GMT)
Received: from [9.61.141.121] (unknown [9.61.141.121])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 13 Sep 2023 18:10:35 +0000 (GMT)
Message-ID: <a7da9ab2-b137-8a1c-acb0-c973bbda3462@linux.ibm.com>
Date:   Wed, 13 Sep 2023 14:10:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/2] s390/vfio-ap: unpin pages on gisc registration
 failure
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, borntraeger@linux.ibm.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, stable@vger.kernel.org
References: <20230913130626.217665-1-akrowiak@linux.ibm.com>
 <20230913130626.217665-2-akrowiak@linux.ibm.com>
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20230913130626.217665-2-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EMkgyceSzwfu85j1eAKOF7Z5tlmOfSgq
X-Proofpoint-ORIG-GUID: tTXcZgUBThv_bZCFfr1zKb-pXLOHJTAm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_12,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1011 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2308100000 definitions=main-2309130151
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/13/23 9:06 AM, Tony Krowiak wrote:
> From: Anthony Krowiak <akrowiak@linux.ibm.com>
> 
> In the vfio_ap_irq_enable function, after the page containing the
> notification indicator byte (NIB) is pinned, the function attempts
> to register the guest ISC. If registration fails, the function sets the
> status response code and returns without unpinning the page containing
> the NIB. In order to avoid a memory leak, the NIB should be unpinned before
> returning from the vfio_ap_irq_enable function.
> 
> Fixes: 783f0a3ccd79 ("s390/vfio-ap: add s390dbf logging to the vfio_ap_irq_enable function")
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> Cc: <stable@vger.kernel.org>

Oops, good find.

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>  

> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 4db538a55192..9cb28978c186 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -457,6 +457,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
>  		VFIO_AP_DBF_WARN("%s: gisc registration failed: nisc=%d, isc=%d, apqn=%#04x\n",
>  				 __func__, nisc, isc, q->apqn);
>  
> +		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
>  		status.response_code = AP_RESPONSE_INVALID_GISA;
>  		return status;
>  	}


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B330C7D8271
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 14:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344897AbjJZMTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 08:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbjJZMS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 08:18:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BB510A;
        Thu, 26 Oct 2023 05:18:52 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39QCCL3G008403;
        Thu, 26 Oct 2023 12:18:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sdZdlAU9glRvACkHBKlOXwhT6KEbD7cXDC4qYhJBw/8=;
 b=TG6Uv//K+oXq55yNHuK6PUzgL9c53lEc6xH9C7VKv38UV8o/tM+nTijnE9HScm9sN2cH
 uGNaQoE2ag4aVS/FncujV209v8+fQ2fl9Y5YhgneKCVa43lBLvtPZGcrS03kQLiPMske
 EdsPGQ7Bq8lnxdlN/8gR66F4O5KzQtFvgURQs7TuT8vMOv4GPc6oDo0vaRVvmUCmYKLO
 FOkGJE+OLIOvqkidNKcHbStWNHmFtptmx8l9T7QwFptMNloUC9hYo7WOjsMVOH2oaWPu
 wgbLg57oLfQBagoc6vd12ZCBrk1QIq4B94T2Lj/B1dqmZD+CXTEUlV83blb7DdCkQI87 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tyqwq89gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 12:18:52 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39QCDA0B012393;
        Thu, 26 Oct 2023 12:18:51 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tyqwq89g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 12:18:51 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39QAEYfi024372;
        Thu, 26 Oct 2023 12:18:50 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tvu6kdm8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 12:18:50 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39QCIlBL29360612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 12:18:47 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A652920043;
        Thu, 26 Oct 2023 12:18:47 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61FF320040;
        Thu, 26 Oct 2023 12:18:47 +0000 (GMT)
Received: from [9.152.224.53] (unknown [9.152.224.53])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 26 Oct 2023 12:18:47 +0000 (GMT)
Message-ID: <c6951c45-b091-11a6-5684-ba2ef0c94df3@linux.ibm.com>
Date:   Thu, 26 Oct 2023 14:18:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 1/3] s390/vfio-ap: unpin pages on gisc registration
 failure
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>, stable@vger.kernel.org
References: <20231018133829.147226-1-akrowiak@linux.ibm.com>
 <20231018133829.147226-2-akrowiak@linux.ibm.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20231018133829.147226-2-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PYlvQS9aqkfoHYchAqKIuaJqORo4nhBz
X-Proofpoint-ORIG-GUID: CuSy8lGyjY-8wZ_FEoeZw-VkjthMKil3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_10,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 suspectscore=0 spamscore=0 clxscore=1011 mlxscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310260105
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 18.10.23 um 15:38 schrieb Tony Krowiak:
> From: Anthony Krowiak <akrowiak@linux.ibm.com>
> 
> In the vfio_ap_irq_enable function, after the page containing the
> notification indicator byte (NIB) is pinned, the function attempts
> to register the guest ISC. If registration fails, the function sets the
> status response code and returns without unpinning the page containing
> the NIB. In order to avoid a memory leak, the NIB should be unpinned before
> returning from the vfio_ap_irq_enable function.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Where is Janoschs signed off coming from here?

> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Fixes: 783f0a3ccd79 ("s390/vfio-ap: add s390dbf logging to the vfio_ap_irq_enable function")
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 4db538a55192..9cb28978c186 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -457,6 +457,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
>   		VFIO_AP_DBF_WARN("%s: gisc registration failed: nisc=%d, isc=%d, apqn=%#04x\n",
>   				 __func__, nisc, isc, q->apqn);
>   
> +		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
>   		status.response_code = AP_RESPONSE_INVALID_GISA;
>   		return status;
>   	}

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F63964D9C9
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 11:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiLOKyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 05:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiLOKyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 05:54:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9053960CD;
        Thu, 15 Dec 2022 02:54:13 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFApIxJ007790;
        Thu, 15 Dec 2022 10:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=mz5ZZXprmrwC+v2SoNQUY3mBKyzxDqxl15ZC2L463QQ=;
 b=KxJ1A/mmuwsMmstoxfC6FlntMgUXpqqCgkRY8xt+xge3vzsRQJnIYsfe5fCAlWs3cAPW
 zo0S7k6xs+h7PCYqkHV1szwS369bDKnzDyK7zWACQjOkrSRzdyaVRS2Cb2R1/POlQHnY
 GYe+fhvkQD1JowFWHN2ULTKjzvrYs9/uRVa79RWJqJRyqiBncrDIcKUr8H4m1V8nsO7J
 vDxduwk9wqpOZucxJQDfSF7CgIaLoSQj8GD1bLRufrpntWyhY/wR2dXm4gGkBbvaPN5z
 vMGa3X8MbDwLUUHr6NMrjTpxFvwXvnTOS+6Gz0m1DWKv2Mo3XSYzWOpWiE/s1+pcpvy0 yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg26s02ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:54:11 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFApVvs009396;
        Thu, 15 Dec 2022 10:54:11 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg26s02ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:54:11 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFAlRXC018047;
        Thu, 15 Dec 2022 10:54:10 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([9.208.129.113])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3meyqkjmry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:54:09 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BFAs8El2491090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 10:54:08 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60D0358059;
        Thu, 15 Dec 2022 10:54:08 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A5025805B;
        Thu, 15 Dec 2022 10:54:07 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Dec 2022 10:54:07 +0000 (GMT)
MIME-Version: 1.0
Date:   Thu, 15 Dec 2022 11:54:07 +0100
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: Re: [PATCH 4/7] s390/vfio_ap: verify ZAPQ completion after return of
 response code zero
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20221213154437.15480-5-akrowiak@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
 <20221213154437.15480-5-akrowiak@linux.ibm.com>
Message-ID: <e16b6e4e4774976eb2f3efb7adaef6a5@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nMSirgVeNLN_AHrk5E_gdODJLR2rx66y
X-Proofpoint-ORIG-GUID: pgQfKkTfw0hP3WMgaHQ_MI4d_nqhZy1x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_05,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212150082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-12-13 16:44, Tony Krowiak wrote:
> Verification that the asynchronous ZAPQ function has completed only 
> needs
> to be done when the response code indicates the function was 
> successfully
> initiated; so, let's call the apq_reset_check function immediately 
> after
> the response code zero is returned from the ZAPQ.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index 5bf2d93ae8af..c0cf5050be59 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1645,6 +1645,9 @@ static int vfio_ap_mdev_reset_queue(struct
> vfio_ap_queue *q)
>  	switch (status.response_code) {
>  	case AP_RESPONSE_NORMAL:
>  		ret = 0;
> +		/* if the reset has not completed, wait for it to take effect */
> +		if (!status.queue_empty || status.irq_enabled)
> +			ret = apq_reset_check(q);
>  		break;
>  	case AP_RESPONSE_RESET_IN_PROGRESS:
>  		/*
> @@ -1674,10 +1677,6 @@ static int vfio_ap_mdev_reset_queue(struct
> vfio_ap_queue *q)
>  		return -EIO;
>  	}
> 
> -	/* wait for the reset to take effect */
> -	if (!status.queue_empty && status.irq_enabled)
> -		ret = apq_reset_check(q);
> -
>  free_resources:
>  	vfio_ap_free_aqic_resources(q);

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>

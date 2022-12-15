Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33F664D7AF
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 09:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiLOIYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 03:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiLOIYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 03:24:25 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F379F303FC;
        Thu, 15 Dec 2022 00:24:22 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BF8KcR4029248;
        Thu, 15 Dec 2022 08:24:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=fSarSj5L5MZiEmrgPFVE7BZPrSy9rM5N5jE72zOVApA=;
 b=YPienDNC3wdG2lmqHhkVQj8hzF4SFciBvgp2rvSyTB4PQsKC9cT2KkHjS+v9FBqBd0aS
 jTG1zzhzLiazxwVBRBa6i1veT2o5Buges35Jsn2JTSwZJYrvuPngrguQArqNoZJCuJin
 9Z1xhQAQHyBtjqrfbJzMjdwqYDP6LSkRS/hcYerZQQwaI6i0+TNt+0J2HGX9KvtdvZMq
 XVc4J75bYqOcfJs7+RzE/RT3m9ERZEblsAu7NFBiX9oM3aKOdYnXKq2U+BuTkb791+BB
 lw6AFUVs8jh7LhpGtr8V/mFMbleVjARzZJgDc0J1t8NiQzx7qUQMCvBws51VotuxGXFq LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg00581j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 08:24:20 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BF8Ko06029777;
        Thu, 15 Dec 2022 08:24:19 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg00581j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 08:24:19 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BF6AMaB017089;
        Thu, 15 Dec 2022 08:24:18 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([9.208.129.116])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3mf07gm5hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 08:24:18 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BF8OGe449676724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 08:24:17 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1F8758061;
        Thu, 15 Dec 2022 08:24:16 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26AA35803F;
        Thu, 15 Dec 2022 08:24:16 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Dec 2022 08:24:16 +0000 (GMT)
MIME-Version: 1.0
Date:   Thu, 15 Dec 2022 09:24:15 +0100
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: Re: [PATCH 1/7] s390/vfio-ap: verify reset complete in separate
 function
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20221213154437.15480-2-akrowiak@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
 <20221213154437.15480-2-akrowiak@linux.ibm.com>
Message-ID: <29a5eb8259fc9735aa3a7de5334d9919@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xZrHYeajwHwHApuwJ2WmmVQy7yA9wc1I
X-Proofpoint-ORIG-GUID: a9Sk0ZNp1o0GqpjcjId-Oe1aZJndJ72Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_03,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 phishscore=0 mlxscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-12-13 16:44, Tony Krowiak wrote:
> The vfio_ap_mdev_reset_queue() function contains a loop to verify that 
> the
> reset successfully completes within 40ms. This patch moves that loop 
> into
> a separate function.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 30 +++++++++++++++++++++---------
>  1 file changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index 0b4cc8c597ae..83ff94a38102 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1587,12 +1587,30 @@ static struct vfio_ap_queue
> *vfio_ap_find_queue(int apqn)
>  	return q;
>  }
> 
> +static int apq_reset_check(struct vfio_ap_queue *q)
> +{
> +	int iters = 2;
> +	struct ap_queue_status status;
> +
> +	while (iters--) {
> +		msleep(20);
> +		status = ap_tapq(q->apqn, NULL);
> +		if (status.queue_empty && !status.irq_enabled)
> +			return 0;
> +	}
> +	WARN_ONCE(iters <= 0,
> +		  "timeout verifying reset of queue %02x.%04x (%u, %u, %u)",
> +		  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
> +		  status.queue_empty, status.irq_enabled, status.response_code);
> +
> +	return -EBUSY;
> +}
> +
>  static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
>  				    unsigned int retry)
>  {
>  	struct ap_queue_status status;
>  	int ret;
> -	int retry2 = 2;
> 
>  	if (!q)
>  		return 0;
> @@ -1629,14 +1647,8 @@ static int vfio_ap_mdev_reset_queue(struct
> vfio_ap_queue *q,
>  	}
> 
>  	/* wait for the reset to take effect */
> -	while (retry2--) {
> -		if (status.queue_empty && !status.irq_enabled)
> -			break;
> -		msleep(20);
> -		status = ap_tapq(q->apqn, NULL);
> -	}
> -	WARN_ONCE(retry2 <= 0, "unable to verify reset of queue %02x.%04x",
> -		  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn));
> +	if (!status.queue_empty && status.irq_enabled)

Hm, you check for
   a) status.queue_empty and
   b) !status.irq_enabled
   which is (status.queue_empty && !status.irq_enabled)
   and now let's negate this to:
   !(status.queue_empty && !status.irq_enabled)
   with de-morgan this gives:
   (!status.queue_empty || status.irq_enabled)

> +		ret = apq_reset_check(q);
> 
>  free_resources:
>  	vfio_ap_free_aqic_resources(q);

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>

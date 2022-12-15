Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BC664D9ED
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 11:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiLOK71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 05:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiLOK6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 05:58:38 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B2E2ED5A;
        Thu, 15 Dec 2022 02:58:18 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFAiaFs026673;
        Thu, 15 Dec 2022 10:58:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=a9+iHvvWpMFZhcRyyhZQIi942RTSr2kXNnIzWIdEwJ4=;
 b=MuZ6+sX2Xv3iLBCjlcYMUVmA2eoZdaxyBrl0N3d4EsNSaK4FGE65FaWDSwypI0LZnfMu
 IT7dFBSuTj0mDv9+wibpoJDndb8XgiXtCUHtilO8c44/NgjJdqrYa34hrpY9bwVivm7j
 nZPRJmTzy09qy8FIlVM3RU96TVO89/VPp8dN7f0eClRUNCx+0taB9C5Bp1/JyuRcuS8s
 eD0+hBAtW+gkcZbx18fHgfvPLlI0EjfwXjkP/rzOrYdrdR2IcI7R469nWJINxYEWpOwF
 9wqMeAXQzcUlNWOmXb62CCJssRbX/qMAL06S7Z8MSpn/FsPsgCaO8mC/kY+75zvgiEMq lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg23f8ajf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:58:16 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFAmYa0010249;
        Thu, 15 Dec 2022 10:58:16 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg23f8ahv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:58:16 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BF9620V019298;
        Thu, 15 Dec 2022 10:58:15 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3mf03ad2s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:58:15 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BFAwEf642664288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 10:58:14 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 234F358056;
        Thu, 15 Dec 2022 10:58:14 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BF225804E;
        Thu, 15 Dec 2022 10:58:13 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Dec 2022 10:58:13 +0000 (GMT)
MIME-Version: 1.0
Date:   Thu, 15 Dec 2022 11:58:13 +0100
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: Re: [PATCH 6/7] s390/vfio_ap: increase max wait time for reset
 verification
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20221213154437.15480-7-akrowiak@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
 <20221213154437.15480-7-akrowiak@linux.ibm.com>
Message-ID: <14f20c6e389f8a9d169e398621bec13f@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8CSmikqus80HGCcD8ohk_QYjZsAu3ANJ
X-Proofpoint-GUID: wDHcdgLtRaobYAT715M7Qt1FLFmzKItl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_05,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
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
> Increase the maximum time to wait for verification of a queue reset
> operation to 200ms.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index dbf681715a6d..e80c5a6b91be 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -30,6 +30,9 @@
>  #define AP_QUEUE_UNASSIGNED "unassigned"
>  #define AP_QUEUE_IN_USE "in use"
> 
> +#define MAX_RESET_CHECK_WAIT	200	/* Sleep max 200ms for reset check	*/
> +#define AP_RESET_INTERVAL		20	/* Reset sleep interval (20ms)		*/
> +
>  static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable);
>  static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>  static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
> @@ -1615,11 +1618,12 @@ static int apq_status_check(int apqn, struct
> ap_queue_status *status)
> 
>  static int apq_reset_check(struct vfio_ap_queue *q)
>  {
> -	int iters = 2, ret;
> +	int ret;
> +	int iters = MAX_RESET_CHECK_WAIT / AP_RESET_INTERVAL;
>  	struct ap_queue_status status;
> 
> -	while (iters--) {
> -		msleep(20);
> +	for (; iters > 0; iters--) {
> +		msleep(AP_RESET_INTERVAL);
>  		status = ap_tapq(q->apqn, NULL);
>  		ret = apq_status_check(q->apqn, &status);
>  		if (ret != -EBUSY)

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>

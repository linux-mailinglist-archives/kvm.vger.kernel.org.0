Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735F15AF387
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 20:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiIFSXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 14:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiIFSXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 14:23:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F66A98377;
        Tue,  6 Sep 2022 11:23:06 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 286HlXUf007874;
        Tue, 6 Sep 2022 18:23:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CwlwmBvsg+b6sbStzN49WFdYe5vplL40V4hwoNrEci8=;
 b=a6ZXxX4+uT64ATzI+zZdqo+oUccKZCI6eup4PXf8ot+6gD37meOrf27SCx2faXB7+cIJ
 Xw1AvOyadhTXdj9ytqACXi7CRSl14+4eekaqXt5IAMxLiatKDCX1zigPoqfVDh9TJwGW
 rP2tPlHAkYIhstBwafzn8HDDrR0tBUMBQ97Yxs/wzD+ggwyxb62g7sIebMQ8zCnajoRp
 PIPM8jY4QaRFYNXdOCvI+/FPCR1t64iHRqMSAhMVZWgPqSukiZIiGuxjwxNf3G4pqmk8
 gtDwmA5L+AafgMjjzcMi0RR9W4YlxBbj8pydMtHa+O7BW58eTvn1vnR301FYo/SeCcs9 ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jeawggx95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 18:23:06 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 286Hn7aR010895;
        Tue, 6 Sep 2022 18:23:05 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jeawggx8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 18:23:05 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 286ILcGF006456;
        Tue, 6 Sep 2022 18:23:04 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3jbxj9tacq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 18:23:04 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 286IN3fP48824682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Sep 2022 18:23:03 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE76F28059;
        Tue,  6 Sep 2022 18:23:03 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 408A428058;
        Tue,  6 Sep 2022 18:23:03 +0000 (GMT)
Received: from [9.160.64.167] (unknown [9.160.64.167])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  6 Sep 2022 18:23:03 +0000 (GMT)
Message-ID: <5a6d0a34-9815-2de6-f5a1-9f41e6c14033@linux.ibm.com>
Date:   Tue, 6 Sep 2022 14:22:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 0/2] s390/vfio-ap: fix two problems discovered in the
 vfio_ap driver
Content-Language: en-US
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com
References: <20220823150643.427737-1-akrowiak@linux.ibm.com>
In-Reply-To: <20220823150643.427737-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1_yNx7bF9t2x-FppuciTKzRiX_Zv-FYM
X-Proofpoint-GUID: KwU69cjkM8tOlJRRHyKlnQvEASpbmiPX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_09,2022-09-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 malwarescore=0 phishscore=0 mlxscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209060084
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PING!

On 8/23/22 11:06 AM, Tony Krowiak wrote:
> Two problems have been discovered with the vfio_ap device driver since the
> hot plug support was recently introduced:
>
> 1. Attempting to remove a matrix mdev after assigning a duplicate adapter
>     or duplicate domain results in a hang.
>
> 2. The queues associated with an adapter or domain being unassigned from
>     the matrix mdev do not get unlinked from it.
>
> Two patches are provided to resolve these problems.
>
> Change log v2 => v3:
> --------------------
> * Replaced the wrong commit IDs in the 'Fixes' tags in both patches.
>    (Halil and Alexander)
>
> * Changed the subject line and description of patch 01/02 to better reflect the
>    code changes in the patch. (Halil)
>
> Tony Krowiak (2):
>    s390/vfio-ap: bypass unnecessary processing of AP resources
>    s390/vfio-ap: fix unlinking of queues from the mdev
>
>   drivers/s390/crypto/vfio_ap_ops.c | 36 +++++++++++++++++++++++++++----
>   1 file changed, 32 insertions(+), 4 deletions(-)
>

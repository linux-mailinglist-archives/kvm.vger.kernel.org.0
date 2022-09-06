Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F585AF850
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 01:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiIFXR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 19:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiIFXR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 19:17:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232807FFAC;
        Tue,  6 Sep 2022 16:17:54 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 286MfkbG005801;
        Tue, 6 Sep 2022 23:17:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5SuGKV/DFZgA/SSeSLeNHeIczH+WZYvJhWDUc9nbs/w=;
 b=iks+Rxt4Dqo9fR3BezLxNyFs8xqiffqzRdNorrCcG2AThHZJwypT/L8HsOf4BlEQyS/M
 wv8zCF2eRJIU+VDUhi4s5ZzJVvRdYkOfFs2/bO5ZhGlKI97l2ADxESj+v6L/ShFLDYvY
 1ECkVweciMhQo4Vsb0hT7sN06lFN7hEhHvit9PC1aEPt83d9L6zPnjqMU+UfdhQIJw2m
 9jwinNkulT0/e4xW6Rz8V8hbRCV17NhAtHfWTYjFfGkJpL0yQikdladKZP1jS0Wp21yW
 DIRClr4vgPxHvAbR9u+tI7poWbm9OWcWZzhocvOtXZ4HSB65R9tVQQVyZQkOLtERw/Bt 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jef7nrts9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 23:17:53 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 286Mtas3021140;
        Tue, 6 Sep 2022 23:17:53 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jef7nrtry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 23:17:53 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 286N5v90007944;
        Tue, 6 Sep 2022 23:17:51 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03wdc.us.ibm.com with ESMTP id 3jbxj9eddf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 23:17:51 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 286NHpEJ31523214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Sep 2022 23:17:51 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 340472805C;
        Tue,  6 Sep 2022 23:17:51 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B35E528058;
        Tue,  6 Sep 2022 23:17:50 +0000 (GMT)
Received: from [9.160.64.167] (unknown [9.160.64.167])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  6 Sep 2022 23:17:50 +0000 (GMT)
Message-ID: <33b8a9f4-ebe8-d836-807e-7c495c190536@linux.ibm.com>
Date:   Tue, 6 Sep 2022 19:17:50 -0400
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
X-Proofpoint-ORIG-GUID: KwVr9Ej9S5BxOM96aZPFGYqBQiaTEBdC
X-Proofpoint-GUID: hKJr2OyaD-DtDMYzWJmYnTUudnUZwR3c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_09,2022-09-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 adultscore=0 impostorscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209060108
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PING?

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

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5925B6E4B
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 15:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbiIMNW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 09:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiIMNW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 09:22:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7BF44552;
        Tue, 13 Sep 2022 06:22:25 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28DDIJaZ030461;
        Tue, 13 Sep 2022 13:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2/A0NS3W9xVoZHj6mPomZBrOMRNq6H+Nz72F40i5agw=;
 b=miawhnoyxZewUQsHY4ae5Q3eBEHonr8VTzta8gDsGC+zYDucZLq1TUJTpUWRB1rkYr5w
 RApEeDmcXQ1Vg0q1+by0XH2CZHfQbM6Mk+AVCRpVYXexafBqyvwNEwJgsCVm3cBlJzw8
 pGFamHdrEnOzJ5dO1tcA7GqUK7+ub1GKIojKhjfA+EvxkoTtPmi/o6lEQNKhPQvfZjya
 HOzl6YnAW5QCOnwmHfgEijDHp4tRpNd25qU9UTxcy61hzXlgG4H04ERvkTtkGwccZ9ll
 FUgLEonLI0TqhOWtYTLSqUNwoNUSaAB+rHh+pUUsoR3Zh86184cu6b5oRf3vniwpm1GS WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jjtmnr5y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 13:22:24 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28DDK8KL008509;
        Tue, 13 Sep 2022 13:22:24 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jjtmnr5x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 13:22:24 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28DDLqIe010027;
        Tue, 13 Sep 2022 13:22:22 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 3jgj79c69c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 13:22:22 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28DDMMaX9503238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Sep 2022 13:22:22 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB410124054;
        Tue, 13 Sep 2022 13:22:21 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B273124052;
        Tue, 13 Sep 2022 13:22:21 +0000 (GMT)
Received: from [9.160.74.225] (unknown [9.160.74.225])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 13 Sep 2022 13:22:21 +0000 (GMT)
Message-ID: <c2f4e68f-28cb-39c0-ce17-65ab55c55784@linux.ibm.com>
Date:   Tue, 13 Sep 2022 09:22:21 -0400
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
X-Proofpoint-GUID: P8-pYIhjr8cCmz92gCg2U5fU_Fok0XQo
X-Proofpoint-ORIG-GUID: oPfSeu-G7846YaCCFWK-D-_CsXJamU-4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-13_06,2022-09-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2209130059
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are pretty simple, straight forward patches that fix a couple of 
issues recently introduced in the vfio_ap device driver. I would greatly 
appreciate it if someone could review these so we can get the fixes into 
the kernel. Thank you in advance for your attention to this.

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

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A1079F0F0
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 20:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbjIMSNs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 14:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjIMSNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 14:13:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918C519BB;
        Wed, 13 Sep 2023 11:13:42 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DI8dtM018677;
        Wed, 13 Sep 2023 18:13:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=wIo3ra5cexcm4uIo62gOHb+hXHCxB95TaHhFkEaiUhc=;
 b=NBjxY9I2H5I8i++KpsO9e+/0lPgQaIjLuI7s8TtmZMoP0PojnyUGHu4ef3GDThGsbqFa
 sb7ii514qfZ2iL7ptFyV8CFKePzTFSzV3pyR8xe3NlsQzzyPgfSFZB5WoiiFazCoccW0
 Ii8Pql25k1I1z2Qfi4HCGW8Mh9BnxnsBEC8fi718bs5Lol2qnLuFpwkfhJp7YrfTdApi
 AZR/3vJCcbkEr+M8Kl7ASmFT7tw9759huBmF8MuKXXkVN23Ytd6pqGQ7/7FoRnBCECqC
 jYy+bqVAzXq95kYVeuW8QU34n+vng97FMMMoA25IKFSbGtUWmzOgtr0+kPFPPYUYk1t0 VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3ge9k7un-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 18:13:40 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38DIBEMZ031753;
        Wed, 13 Sep 2023 18:13:40 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3ge9k7uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 18:13:40 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38DI2GNW002752;
        Wed, 13 Sep 2023 18:13:39 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t14hm4ybu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 18:13:39 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38DIDcA361407710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Sep 2023 18:13:38 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BD5558045;
        Wed, 13 Sep 2023 18:13:38 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BFBD58050;
        Wed, 13 Sep 2023 18:13:37 +0000 (GMT)
Received: from [9.61.141.121] (unknown [9.61.141.121])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 13 Sep 2023 18:13:37 +0000 (GMT)
Message-ID: <83cab22d-71c3-2bbc-856f-6527479f10ec@linux.ibm.com>
Date:   Wed, 13 Sep 2023 14:13:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 0/2] a couple of corrections to the IRQ enablement
 function
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, borntraeger@linux.ibm.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        Michael Mueller <mimu@linux.ibm.com>
References: <20230913130626.217665-1-akrowiak@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20230913130626.217665-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M2bZ_BChkxBySh3rmR-2UANJPDsN3GVA
X-Proofpoint-ORIG-GUID: 0T3GprBonVwS2HpKoHAKwVsz-fnGoUBn
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_12,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 impostorscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309130151
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/13/23 9:06 AM, Tony Krowiak wrote:
> This series corrects two issues related to enablement of interrupts in 
> response to interception of the PQAP(AQIC) command:
> 
> 1. Returning a status response code 06 (Invalid address of AP-queue 
>    notification byte) when the call to register a guest ISC fails makes no
>    sense.
>    
> 2. The pages containing the interrupt notification-indicator byte are not
>    freed after a failure to register the guest ISC fails.
> 

Hi Tony,

3. Since you're already making changes related to gisc registration, you might consider a 3rd patch that looks at the return code for kvm_s390_gisc_unregister and tags the unexpected error rc somehow.  This came up in a recent conversation I had with Michael, see this conversation towards the bottom:

https://lore.kernel.org/linux-s390/0ddf808c-e929-c975-1b39-5ebc1f2fab62@linux.ibm.com/ 

4. While looking at patch 1 I also had a question re: the AP_RESPONSE_OTHERWISE_CHANGED path in vfio_ap_irq_enable.  Here's a snippet of the current code:

	case AP_RESPONSE_OTHERWISE_CHANGED:
		/* We could not modify IRQ settings: clear new configuration */
		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
		kvm_s390_gisc_unregister(kvm, isc);
		break;

Is it safe to unpin the page before unregistering the gisc in this case?  Or shouldn't the unpin happen after we have unregistered the gisc / set the IAM?

> Anthony Krowiak (2):
>   s390/vfio-ap: unpin pages on gisc registration failure
>   s390/vfio-ap: set status response code to 06 on gisc registration
>     failure
> 
>  drivers/s390/crypto/vfio_ap_ops.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 


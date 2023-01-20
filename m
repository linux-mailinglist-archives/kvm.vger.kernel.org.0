Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D93675647
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 15:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjATOCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 09:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjATOCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 09:02:09 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0B4C13F5;
        Fri, 20 Jan 2023 06:02:08 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30KDrTo0021023;
        Fri, 20 Jan 2023 14:02:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MHYEeb1An0ddYguIQpgCo9rwIVDQ/HwjjdWBu/m9Rf4=;
 b=j0G6Sl2b5Fs/xSn0s5vfPmWQ6IrZeO4ejxGaOav/Dlc5dODf/69b927lUshyL2nsbXBv
 YVJn3U1treC9VtYU/ezVkD4vc5PZDSO9ymgMJ2HbxU8z82IfHGIIm9ueRFlNyKLcVI+W
 PY4l09q4LY8ZYx3qk3sxGoSVzyVUXlDoFdFYgNupQ2oIMjKYZK7khvPdnZJFQW1DWoD8
 +vdcqQ74w45Q9P3vw5HG81yfkFbCnfyny+avd496Z8FnrSejhLQq6Sdn8JeaYLuOtEql
 gW1rdV3X0+P2BejgDqbqEfUihh47guq6rIhGOItBh6wK7V+6CGNRIXqO7x37pC17KY5E 8Q== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n7v85r613-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 14:02:07 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30KDQKRX006166;
        Fri, 20 Jan 2023 14:02:06 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3n3m185235-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 14:02:06 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30KE25m535455350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 14:02:05 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B2285805C;
        Fri, 20 Jan 2023 14:02:05 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABD325805F;
        Fri, 20 Jan 2023 14:02:04 +0000 (GMT)
Received: from [9.160.36.55] (unknown [9.160.36.55])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 20 Jan 2023 14:02:04 +0000 (GMT)
Message-ID: <e51d751f-54c1-b292-7c86-e0b077f138c4@linux.ibm.com>
Date:   Fri, 20 Jan 2023 09:02:04 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 0/6] improve AP queue reset processing
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com, pasic@linux.ibm.com,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
References: <20230118203111.529766-1-akrowiak@linux.ibm.com>
 <d8fe5146-def7-262d-15cb-0bb965102f3c@de.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <d8fe5146-def7-262d-15cb-0bb965102f3c@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: k9FIqbtfj3DyL-buoeHvnG3a-BaNZEWi
X-Proofpoint-ORIG-GUID: k9FIqbtfj3DyL-buoeHvnG3a-BaNZEWi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-20_08,2023-01-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 mlxscore=0 clxscore=1015 suspectscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=857 impostorscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301200133
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/20/23 5:25 AM, Christian Borntraeger wrote:
> Am 18.01.23 um 21:31 schrieb Tony Krowiak:
>> This series introduces several improvements to the function that 
>> performs
>> AP queue resets:
>>
>> * Breaks up reset processing into multiple smaller, more concise 
>> functions.
>>
>> * Use TAPQ to verify completion of a reset in progress rather than 
>> mulitple
>>    invocations of ZAPQ.
>>
>> * Check TAPQ response codes when verifying successful completion of 
>> ZAPQ.
>>
>> * Fix erroneous handling of some error response codes.
>>
>> * Increase the maximum amount of time to wait for successful 
>> completion of
>>    ZAPQ.
>>   Change log v1 => v2:
>> -------------------
>> Remove patch 7/7 to restore original behavior since we don't know 
>> whether
>> interrupts are disabled when an unexpected response code is returned 
>> from
>> ZAPQ. (Halil)
>>
>> Tony Krowiak (6):
>>    s390/vfio-ap: verify reset complete in separate function
>>    s390/vfio_ap: check TAPQ response code when waiting for queue reset
>>    s390/vfio_ap: use TAPQ to verify reset in progress completes
>>    s390/vfio_ap: verify ZAPQ completion after return of response code
>>      zero
>>    s390/vfio_ap: fix handling of error response codes
>>    s390/vfio_ap: increase max wait time for reset verification
>>
>>   drivers/s390/crypto/vfio_ap_ops.c | 104 +++++++++++++++++++++---------
>>   1 file changed, 72 insertions(+), 32 deletions(-)
>>
>
> Thanks applied and queued for CI and regression runs. Will likely go 
> via s390 tree.


Got it, thanks.



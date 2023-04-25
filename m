Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A07A6EE125
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 13:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbjDYLjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 07:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbjDYLi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 07:38:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31E346AB;
        Tue, 25 Apr 2023 04:38:58 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PBcEaP020539;
        Tue, 25 Apr 2023 11:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZINkm6tDLbUBJc9BelkcIaCmWHPpI3Lg8T4nfmCzcW4=;
 b=aDXyIfPzk+dqBNg7/xPRwjgc55SpnbOXjcgBZ3fuWoS0pjtk4YcuawOKs2KUwDldo396
 g52YJDL2+9Jt8NPBUdokJo/a1wilVG+SCXNmiy3u17ZFj7mUWaJA1YpmoxAiV4uigJ00
 FB86/9Qkp9XVN7gVJbbPRlj4DH4SP8tAY4fvorhx1O7N4Rqn12rMlADaecYWN+8+vTOr
 fM2t7/0IeJiqW0/fyhMJqNe6fZrrUMZa48224upGjUC2ueAuujyULJnX+AY+mXuu/v0Q
 JvOg8VvW3uaHZCenxOMmzRQ7YfLKJCh0fAq5jhfSQ1K6Yd/LuzCRN6ca9Mbh6O7xtoMw KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6dfnha4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 11:38:57 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33PBclrT025071;
        Tue, 25 Apr 2023 11:38:57 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6dfnh81b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 11:38:55 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33P4brMt017114;
        Tue, 25 Apr 2023 11:33:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3q47771dkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 11:33:58 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33PBXscZ38470308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 11:33:54 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 567882004B;
        Tue, 25 Apr 2023 11:33:54 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2EA920040;
        Tue, 25 Apr 2023 11:33:53 +0000 (GMT)
Received: from [9.171.45.26] (unknown [9.171.45.26])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Apr 2023 11:33:53 +0000 (GMT)
Message-ID: <738a8001-a651-8e69-7985-511c28fb0485@linux.ibm.com>
Date:   Tue, 25 Apr 2023 13:33:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, kvm@vger.kernel.org,
        david@redhat.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        cohuck@redhat.com
References: <20230424174218.64145-1-pmorel@linux.ibm.com>
 <20230424174218.64145-2-pmorel@linux.ibm.com>
 <20230425102606.4e9bc606@p-imbrenda>
 <5572f655-4cc8-500f-97fd-068c9f06a90b@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/1] s390x: sclp: consider monoprocessor on
 read_info error
In-Reply-To: <5572f655-4cc8-500f-97fd-068c9f06a90b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jpBdL8Tal3DRToXZWG-dWai7Vr7P2j16
X-Proofpoint-GUID: Gm2z16G_ZHm5YZBbNrCH6ngC7NxdKJva
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_04,2023-04-25_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304250103
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/25/23 12:53, Pierre Morel wrote:
> 
> On 4/25/23 10:26, Claudio Imbrenda wrote:
>> On Mon, 24 Apr 2023 19:42:18 +0200
>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>

How is this considered to be a fix and not a workaround?


Set the variable response bit in the control mask and vary the length 
based on stfle 140. See __init sclp_early_read_info() in 
drivers/s390/char/sclp_early_core.c


>>
>>> Fixes: 52076a63d569 ("s390x: Consolidate sclp read info")
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>    lib/s390x/sclp.c | 5 +++--
>>>    1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>>> index acdc8a9..c09360d 100644
>>> --- a/lib/s390x/sclp.c
>>> +++ b/lib/s390x/sclp.c
>>> @@ -119,8 +119,9 @@ void sclp_read_info(void)
>>>    
>>>    int sclp_get_cpu_num(void)
>>>    {
>>> -	assert(read_info);
>>> -	return read_info->entries_cpu;
>>> +    if (read_info)
>>> +	    return read_info->entries_cpu;
>>> +    return 1;
>>>    }
>>>    
>>>    CPUEntry *sclp_get_cpu_entries(void)


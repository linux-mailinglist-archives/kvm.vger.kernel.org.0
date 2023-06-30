Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD6E743E3C
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 17:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbjF3PEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 11:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjF3PEd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 11:04:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F2E171E;
        Fri, 30 Jun 2023 08:04:32 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35UEjhvh014770;
        Fri, 30 Jun 2023 15:04:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kja+RLU7DHy3Lyze3I2Sug9QHc9GFq5ItphJ6LZaSxI=;
 b=Fp3ZHbjoFMsKCyfcdL6S0vwIzaOa25T5WWjmSx1u4T28X/o7MIq0EmVfgfbj8C2aUzNc
 nAYpKrKHZPG77fQlU5FquZSLgEEIY+5K3jQZ1sPbG899MI8esA3DXFKH6zkW+mVwZKNA
 HhVfMFRsnmsa3jy6z7XjBzp8XEYW204UHb/d8NvOy2CQTQRDwG1xwD1aBLWcyhhk7gm0
 Zknd0eWxqBEp7xuHzeaPVkQHBnSJSAnpv4US1h9bCbvTbSETvcnz8hHaASXz1lDJetCE
 6i2p7Zu1q8cxJiW7wcZQVO6BCONep5+wFokH7ylzuL07kPjlAUZwez9HCKZYa7hA+XFd dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj13m8j27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 15:04:31 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35UEkRUR017245;
        Fri, 30 Jun 2023 15:04:31 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj13m8j12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 15:04:31 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35U3Rovk004120;
        Fri, 30 Jun 2023 15:04:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3rdr45476y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 15:04:29 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35UF4P7019071676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jun 2023 15:04:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6C5C20049;
        Fri, 30 Jun 2023 15:04:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C06602004B;
        Fri, 30 Jun 2023 15:04:24 +0000 (GMT)
Received: from [9.171.4.48] (unknown [9.171.4.48])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jun 2023 15:04:24 +0000 (GMT)
Message-ID: <4b4c0a34-f36b-d552-c761-ff4a4ea0d089@linux.ibm.com>
Date:   Fri, 30 Jun 2023 17:04:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [kvm-unit-tests PATCH v3 5/6] s390x: lib: sie: don't reenter SIE
 on pgm int
To:     Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230601070202.152094-1-nrb@linux.ibm.com>
 <20230601070202.152094-6-nrb@linux.ibm.com>
 <baf4bb04-b258-f8b4-e49d-5d400e498bbf@linux.ibm.com>
 <168813714644.32198.9739825161407676099@t14-nrb>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <168813714644.32198.9739825161407676099@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7-Y9pXkxuYzExWV4kI5iK5pJdVrVC9ta
X-Proofpoint-GUID: QJ04PUbFAWVMJUTvHK0SObMSr7CMfD8V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-30_05,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 mlxscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 impostorscore=0 clxscore=1015 suspectscore=0 mlxlogscore=869
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306300123
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/23 16:59, Nico Boehr wrote:
> Quoting Janosch Frank (2023-06-05 11:30:36)
>> On 6/1/23 09:02, Nico Boehr wrote:
>>> At the moment, when a PGM int occurs while in SIE, we will just reenter
>>> SIE after the interrupt handler was called.
>>>
>>> This is because sie() has a loop which checks icptcode and re-enters SIE
>>> if it is zero.
>>>
>>> However, this behaviour is quite undesirable for SIE tests, since it
>>> doesn't give the host the chance to assert on the PGM int. Instead, we
>>> will just re-enter SIE, on nullifing conditions even causing the
>>> exception again.
>>
>> That's the reason why we set an invalid PGM PSW new for the assembly
>> snippets. Seems like I didn't add it for C snippets for some reason -_-
> 
> True, C snippets should have a invalid PGM new PSW too. Let me have a try after
> my holiday... *writes TODO*
> 
>> This code is fine but it doesn't fully fix the usability aspect and
>> leaves a few questions open:
>>    - Do we want to stick to the code 8 handling?
> 
> Well, I think we need to distinguish between two kinds of PGMs:
> - PGMs in the guest,
> - PGMs caused by SIE on the host (e.g. because the gpa-hpa mapping is not
>    present)
> 
> The first case is out of scope for this patch, but certainly something which can
> be improved.
> 
> This patch focuses on the latter case, where code 8 handling is irrelevant since
> the PGM is always delivered to the host.

Seems like I wasn't fully awake and/or distracted by hunger when I was 
reading this patch -_-


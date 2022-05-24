Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AB953268A
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 11:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbiEXJfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 05:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiEXJfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 05:35:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689755FF1E;
        Tue, 24 May 2022 02:35:13 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24O8xbwE031056;
        Tue, 24 May 2022 09:35:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GeuXmSddGhFNk54qmnZ0NNbHnhQzHI9QxtptciyCEXE=;
 b=fx48fS/RK7p6IPzLHkub6cN8qvLFs3HHauikbYRPrmWRu4UUkMtJVs+MbhlImRFJwMqZ
 YVpDOIIzebrC9xIS3IPAPIsHkeNfE0TfW2ZcOUFwR/YycCCF5jY8LeYftgBH00cOuZdB
 YF1BLOLCMKw26aqlIx9+jyT3fPvxnOtVJ2j8FwBEq0h3hjZ44GJ1QOlMU0gMlAQWHTRV
 IXCtAJVqdiE7LFKt6s1ajNlHoJ1Q+dQuzFRvWF40sCEdjUyY+L4QR66aRwO/26n3+ZB5
 bAz9LE4RgU23M3LnYeRwn3P9AwaPYPibJTWiPXXqKbhyPHsf7S6dsiWqTF2VkSg21uHF PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8vbdrnxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 09:35:12 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24O9YO3b010598;
        Tue, 24 May 2022 09:35:11 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8vbdrnxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 09:35:11 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24O9CCBT009076;
        Tue, 24 May 2022 09:35:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3g6qbjc6aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 09:35:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24O9Z6l725231870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 09:35:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4758AE051;
        Tue, 24 May 2022 09:35:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C411AE045;
        Tue, 24 May 2022 09:35:06 +0000 (GMT)
Received: from [9.155.196.57] (unknown [9.155.196.57])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 09:35:06 +0000 (GMT)
Message-ID: <7835de5b-59c6-aeb5-d737-6f56d1c81f05@linux.ibm.com>
Date:   Tue, 24 May 2022 11:35:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: Fix gcc 12 warning about
 array bounds
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220520140546.311193-1-scgl@linux.ibm.com>
 <20220520140546.311193-3-scgl@linux.ibm.com>
 <20220524093158.6404a633@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220524093158.6404a633@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2uQjUJTvNO56RIp6jlLeCFrYjRv3ZF7k
X-Proofpoint-ORIG-GUID: Dk7YrtbJekodJRPgf2oULiTFMtYF_3Ch
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_06,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 impostorscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205240047
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/22 09:31, Claudio Imbrenda wrote:
> On Fri, 20 May 2022 16:05:46 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> gcc 12 warns about pointer constant <4k dereference.
>> Silence the warning by using the extern lowcore symbol to derive the
>> pointers. This way gcc cannot conclude that the pointer is <4k.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>  lib/s390x/asm/mem.h | 4 ++++
>>  s390x/emulator.c    | 5 +++--
>>  s390x/skey.c        | 2 +-
>>  3 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
>> index 845c00cc..e7901fe0 100644
>> --- a/lib/s390x/asm/mem.h
>> +++ b/lib/s390x/asm/mem.h
>> @@ -7,6 +7,10 @@
>>   */
>>  #ifndef _ASMS390X_MEM_H_
>>  #define _ASMS390X_MEM_H_
>> +#include <asm/arch_def.h>
>> +
>> +/* pointer to 0 used to avoid compiler warnings */
>> +uint8_t *mem_all = (uint8_t *)&lowcore;
> 
> this is defined in a .h, so maybe it's better to declare it static?
> 
> 
> although maybe you can simply declare a macro like this:
> 
> #define MEM(x) ((void *)((uint8_t *)&lowcore + (x)))
> 
> and then just use MEM(x)...
> 
> (please find a less generic name for MEM, though)

MEM_ALL
MEM_ABS
MEM_OPAQUE
OPAQUE_PTR

Suggestions welcome, the last would be my favorite.

[...]


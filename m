Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FFD5A0A67
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 09:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237813AbiHYHi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 03:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiHYHi5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 03:38:57 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3A69C527;
        Thu, 25 Aug 2022 00:38:56 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27P7UNrr014451;
        Thu, 25 Aug 2022 07:38:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Q1rBqQtmP6Je6+OrXUr6NTl6nfKO+zK9pwjn5Br5sWE=;
 b=a+zVPYe1y+OF6oxydqfiX9E1B8BnCABrU3yNEKH7Fjm8FpjL2y+R6X2jN737km9Zu6Ix
 AnH1FHp4uYPEdhlqMAvsreYBEFNPGd9t9S404ax6AWiSHOXlxfDc1sNqGEvhYYAqUkGW
 +8EDVb7mat844DN84svQOO9mi/2/8LQf/prRzTgJOxpHvtdzDhE9qJwmzBufm/b1BfgZ
 jOPPc+Ia7A9442t4moEFbPb0zzUue9rnkfe7ITAgAJlcdTC4Cig4KHfHuQB8VGkXO496
 G1I7eIJZnA9ZiyFnKqj/dQEF6IydBwWpr6CSM8Wu9IaON0Mzn7XaZUiAQ7rJz2WbJB+6 TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j64rjgadn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 07:38:51 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27P7YZEE025528;
        Thu, 25 Aug 2022 07:38:51 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j64rjgac9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 07:38:51 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27P7ZU0w019947;
        Thu, 25 Aug 2022 07:38:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3j2q88vfbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 07:38:49 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27P7d6Ih44826916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 07:39:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21CAFAE04D;
        Thu, 25 Aug 2022 07:38:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58203AE045;
        Thu, 25 Aug 2022 07:38:45 +0000 (GMT)
Received: from [9.145.144.57] (unknown [9.145.144.57])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Aug 2022 07:38:45 +0000 (GMT)
Message-ID: <faaf7c8f-9648-e078-2b12-f75f35f0b6c2@linux.ibm.com>
Date:   Thu, 25 Aug 2022 09:38:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v5 1/2] s390x: Add specification exception
 test
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        qemu-s390x@nongnu.org
References: <20220720142526.29634-1-scgl@linux.ibm.com>
 <20220720142526.29634-2-scgl@linux.ibm.com>
 <1d0ef541-2b83-3c61-ec22-d5bf9a7698af@linux.ibm.com>
In-Reply-To: <1d0ef541-2b83-3c61-ec22-d5bf9a7698af@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zixf9AgBMC4aw1OD9nUHbHqpByeSNx5-
X-Proofpoint-ORIG-GUID: 0TBz45Gq90Off6ndtMubmiNWD1-VxLMI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_03,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 clxscore=1015 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250026
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/24/22 11:35, Janosch Frank wrote:
> On 7/20/22 16:25, Janis Schoetterl-Glausch wrote:
>> Generate specification exceptions and check that they occur.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>    s390x/Makefile           |   1 +
>>    lib/s390x/asm/arch_def.h |   5 ++
>>    s390x/spec_ex.c          | 180 +++++++++++++++++++++++++++++++++++++++
>>    s390x/unittests.cfg      |   3 +
>>    4 files changed, 189 insertions(+)
>>    create mode 100644 s390x/spec_ex.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index efd5e0c1..58b1bf54 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -27,6 +27,7 @@ tests += $(TEST_DIR)/uv-host.elf
>>    tests += $(TEST_DIR)/edat.elf
>>    tests += $(TEST_DIR)/mvpg-sie.elf
>>    tests += $(TEST_DIR)/spec_ex-sie.elf
>> +tests += $(TEST_DIR)/spec_ex.elf
>>    tests += $(TEST_DIR)/firq.elf
>>    tests += $(TEST_DIR)/epsw.elf
>>    tests += $(TEST_DIR)/adtl-status.elf
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 78b257b7..8fbc451c 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -41,6 +41,11 @@ struct psw {
>>    	uint64_t	addr;
>>    };
>>    
>> +struct short_psw {
>> +	uint32_t	mask;
>> +	uint32_t	addr;
>> +};
>> +
>>    #define AS_PRIM				0
>>    #define AS_ACCR				1
>>    #define AS_SECN				2
>> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
>> new file mode 100644
>> index 00000000..77fc6246
>> --- /dev/null
>> +++ b/s390x/spec_ex.c
>> @@ -0,0 +1,180 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright IBM Corp. 2021, 2022
>> + *
>> + * Specification exception test.
>> + * Tests that specification exceptions occur when expected.
>> + *
>> + * Can be extended by adding triggers to spec_ex_triggers, see comments below.
>> + */
>> +#include <stdlib.h>
> 
> Which things are you hoping to include from stdlib.h?
> As we normally use libcflat including external files can be pretty
> dangerous.

Ignore that comment, we have stdlib in the lib...

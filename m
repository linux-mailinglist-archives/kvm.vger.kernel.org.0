Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44EBB4F3024
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 14:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354057AbiDEKLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 06:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348202AbiDEJrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 05:47:12 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1E3EA755;
        Tue,  5 Apr 2022 02:33:25 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2356nuep018585;
        Tue, 5 Apr 2022 09:33:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sDs/y5zZUGGjBHXiY1iCCl0ZvJczjosODdX6DYRpMAw=;
 b=O3Ej2Crjr+EH2rZEQdFAo+INXWQbttxMnfmgAZ0FneTOL5QdM/nOyOBno+92keDW+uPE
 Flgud6k3Lw28WDLpsO2hbcGZ8gV2uYgviDZ+HK/+i5cx+uU9amnGyO+i88MXxBSfQRzh
 7IS2DFM7ivZq9u8n8YfyJPIkx8ySKReUKe40qovvT8F6stG+J7ogZzUY7fYfaGHDZ/ot
 tlq72AZeA2L62pWskbay6v1zlQqqA4p/YJ7Ef5P2Rl0MV+wzrypd9sRGBGXaXmMsy26V
 ygYcKN5cdsvR9Z9jTft2RSrqIsI0CSX7LRzDKdgKW5L1wB7d9kmyrCYEJeZvpvmo3qwY Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f80hy4j2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 09:33:24 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2359NrZq003336;
        Tue, 5 Apr 2022 09:33:23 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f80hy4j1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 09:33:23 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2359X9pp003985;
        Tue, 5 Apr 2022 09:33:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3f6e48ve4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 09:33:21 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2359L5Ja26476998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 09:21:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FB4CA4051;
        Tue,  5 Apr 2022 09:33:18 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E47EBA404D;
        Tue,  5 Apr 2022 09:33:17 +0000 (GMT)
Received: from [9.145.34.46] (unknown [9.145.34.46])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 09:33:17 +0000 (GMT)
Message-ID: <68646d2c-0793-e395-4719-d1526983de6b@linux.ibm.com>
Date:   Tue, 5 Apr 2022 11:33:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH 2/8] s390x: diag308: Only test subcode 2
 under QEMU
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
References: <20220405075225.15903-1-frankja@linux.ibm.com>
 <20220405075225.15903-3-frankja@linux.ibm.com>
 <16c254ac-c3ed-6174-5eef-5f309e7a7585@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <16c254ac-c3ed-6174-5eef-5f309e7a7585@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V6SG1R4jdnAOCRhOPtKA4_ptKXMNhbiW
X-Proofpoint-ORIG-GUID: GkzYamAYDeO2K0PVTRSH8m-n4ANyepon
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_10,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 mlxlogscore=923 bulkscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050056
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/22 11:18, Thomas Huth wrote:
> On 05/04/2022 09.52, Janosch Frank wrote:
>> Other hypervisors might implement it and therefore not send a
>> specification exception.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    s390x/diag308.c | 15 ++++++++++++++-
>>    1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/s390x/diag308.c b/s390x/diag308.c
>> index c9d6c499..9614f9a9 100644
>> --- a/s390x/diag308.c
>> +++ b/s390x/diag308.c
>> @@ -8,6 +8,7 @@
>>    #include <libcflat.h>
>>    #include <asm/asm-offsets.h>
>>    #include <asm/interrupt.h>
>> +#include <hardware.h>
>>    
>>    /* The diagnose calls should be blocked in problem state */
>>    static void test_priv(void)
>> @@ -75,7 +76,7 @@ static void test_subcode6(void)
>>    /* Unsupported subcodes should generate a specification exception */
>>    static void test_unsupported_subcode(void)
>>    {
>> -	int subcodes[] = { 2, 0x101, 0xffff, 0x10001, -1 };
>> +	int subcodes[] = { 0x101, 0xffff, 0x10001, -1 };
>>    	int idx;
>>    
>>    	for (idx = 0; idx < ARRAY_SIZE(subcodes); idx++) {
>> @@ -85,6 +86,18 @@ static void test_unsupported_subcode(void)
>>    		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>>    		report_prefix_pop();
>>    	}
>> +
>> +	/*
>> +	 * Subcode 2 is not available under QEMU but might be on other
>> +	 * hypervisors.
>> +	 */
>> +	if (detect_host() != HOST_IS_TCG && detect_host() != HOST_IS_KVM) {
> 
> Shouldn't this be rather the other way round instead?
> 
> 	if (detect_host() == HOST_IS_TCG || detect_host() == HOST_IS_KVM)
> 
> ?

The css if checks if we are under QEMU, this one checks if we're not 
under QEMU.

> 
> ... anyway, since you already used a similar if-clause in your first patch,
> it might make sense to add a helper function a la host_is_qemu() to check
> whether we're running on QEMU or not.

Will do

> 
>> +		report_prefix_pushf("0x%04x", 2);
> 
> 	report_prefix_pushf("0x02") ?
> 
>> +		expect_pgm_int();
>> +		asm volatile ("diag %0,%1,0x308" :: "d"(0), "d"(2));
>> +		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +		report_prefix_pop();
>> +	}
>>    }
> 
>    Thomas
> 


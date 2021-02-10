Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F61316587
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 12:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhBJLqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 06:46:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5330 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229736AbhBJLo1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 06:44:27 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11ABaKgm131239
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 06:43:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7svO4da/Va2xE6TD135t6R34TSsLZVYK/NKFjco+I8I=;
 b=O5bSa03zBwjCFPU1xOSvcPRBxYswp3bqgOpDJR/2KjgmGza/2SdqOH8fzfRFAfCK6Q/j
 ILuxCb51OtDH9fB75RB+OM/aQcYgljavHvd+ijcoc9PA/Wtx+y1ryCjzbGorTBuqUSof
 h/G106t/WcUJ/UlfCBXurc6WcQs4TWn7jrpZ4jFFpHnmJJQKzyt5EHoosEyLXcR4jGk+
 KT0m8LWrb2DFV1YXN04JR+gFvLMUsqiJ41/ypua9xMTIkRMG8aIZT4VqiOKHVPIWyc0F
 XvbYFruEvn6f+ptnPjnbAuG4Cge464GLlssVrdy4Y2rSKG073RfY5cnU/IFlT/LyBgle GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36mdynhe1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 06:43:46 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11ABbTrH140236
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 06:43:46 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36mdynhe0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 06:43:45 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11ABhhgu031375;
        Wed, 10 Feb 2021 11:43:43 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 36hskb2at0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 11:43:43 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11ABhe3x54133068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 11:43:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62B43A4053;
        Wed, 10 Feb 2021 11:43:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02F7EA4040;
        Wed, 10 Feb 2021 11:43:40 +0000 (GMT)
Received: from [9.145.24.226] (unknown [9.145.24.226])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Feb 2021 11:43:39 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 2/3] s390x: check for specific program
 interrupt
To:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com
References: <20210209185154.1037852-1-imbrenda@linux.ibm.com>
 <20210209185154.1037852-3-imbrenda@linux.ibm.com>
 <20210210122356.13f07c91.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <273465a8-4a7e-4f47-e2df-edb524882740@linux.ibm.com>
Date:   Wed, 10 Feb 2021 12:43:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210210122356.13f07c91.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_03:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=876
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 clxscore=1015
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102100108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/21 12:23 PM, Cornelia Huck wrote:
> On Tue,  9 Feb 2021 19:51:53 +0100
> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
> 
>> We already have check_pgm_int_code to check and report if a specific
>> program interrupt has occourred, but this approach has some issues.
> 
> s/occourred/occurred/
> 
>>
>> In order to specify which test is being run, it was needed to push and
>> pop a prefix for each test, which is not nice to read both in the code
>> and in the output.
>>
>> Another issue is that sometimes the condition to test for might require
>> other checks in addition to the interrupt.
>>
>> The simple function added in this patch tests if the program intteruupt
> 
> s/intteruupt/interrupt/
> 
>> received is the one expected.
>>
>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>  lib/s390x/asm/interrupt.h | 1 +
>>  lib/s390x/interrupt.c     | 6 ++++++
>>  2 files changed, 7 insertions(+)
>>
>> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
>> index 1a2e2cd8..a33437b1 100644
>> --- a/lib/s390x/asm/interrupt.h
>> +++ b/lib/s390x/asm/interrupt.h
>> @@ -23,6 +23,7 @@ void expect_pgm_int(void);
>>  void expect_ext_int(void);
>>  uint16_t clear_pgm_int(void);
>>  void check_pgm_int_code(uint16_t code);
>> +int is_pgm(int expected);
>>  
>>  /* Activate low-address protection */
>>  static inline void low_prot_enable(void)
>> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
>> index 59e01b1a..6f660285 100644
>> --- a/lib/s390x/interrupt.c
>> +++ b/lib/s390x/interrupt.c
>> @@ -51,6 +51,12 @@ void check_pgm_int_code(uint16_t code)
>>  	       lc->pgm_int_code);
>>  }
>>  
>> +int is_pgm(int expected)
> 
> is_pgm() is a bit non-descriptive. Maybe check_pgm_int_code_noreport()?
> 
> Also, maybe let it take a uint16_t parameter?

Could we use clear_pgm_int()?
It returns the last code so you can check yourself.

We could rename it to fetch_and_clear_pgm_int()

> 
>> +{
>> +	mb();
>> +	return expected == lc->pgm_int_code;
>> +}
>> +
>>  void register_pgm_cleanup_func(void (*f)(void))
>>  {
>>  	pgm_cleanup_func = f;
> 


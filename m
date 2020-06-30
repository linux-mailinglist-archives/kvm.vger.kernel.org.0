Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACBA420F932
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 18:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732050AbgF3QNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 12:13:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41156 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729341AbgF3QNX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Jun 2020 12:13:23 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05UFWilh095887;
        Tue, 30 Jun 2020 12:13:22 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3204s112yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Jun 2020 12:13:21 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05UGAOFg042870;
        Tue, 30 Jun 2020 12:13:21 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3204s112xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Jun 2020 12:13:20 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05UG1lUg015952;
        Tue, 30 Jun 2020 16:13:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 31wwr7stfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Jun 2020 16:13:18 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05UGDGQV63177176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 16:13:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B59242045;
        Tue, 30 Jun 2020 16:13:16 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C02F14203F;
        Tue, 30 Jun 2020 16:13:15 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.24.54])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Jun 2020 16:13:15 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v9 06/12] s390x: clock and delays
 caluculations
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-7-git-send-email-pmorel@linux.ibm.com>
 <7659047a-a0f9-b959-c286-b150477d15ab@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <ef49bb41-6089-8590-3697-25b1cb0d6e47@linux.ibm.com>
Date:   Tue, 30 Jun 2020 18:13:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <7659047a-a0f9-b959-c286-b150477d15ab@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_06:2020-06-30,2020-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 mlxscore=0 cotscore=-2147483648 suspectscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-22 11:09, Janosch Frank wrote:
> On 6/15/20 11:31 AM, Pierre Morel wrote:
>> The hardware gives us a good definition of the microsecond,
>> let's keep this information and let the routine accessing
>> the hardware keep all the information and return microseconds.
>>
>> Calculate delays in microseconds and take care about wrapping
>> around zero.
>>
>> Define values with macros and use inlines to keep the
>> milliseconds interface.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> Small nit below.

seen, I move it up.

> 
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Thanks,
Pierre


> 
>> ---
>>   lib/s390x/asm/time.h | 29 +++++++++++++++++++++++++++--
>>   1 file changed, 27 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
>> index 1791380..7f1d891 100644
>> --- a/lib/s390x/asm/time.h
>> +++ b/lib/s390x/asm/time.h
>> @@ -13,14 +13,39 @@
>>   #ifndef ASM_S390X_TIME_H
>>   #define ASM_S390X_TIME_H
>>   
>> -static inline uint64_t get_clock_ms(void)
>> +#define STCK_SHIFT_US	(63 - 51)
>> +#define STCK_MAX	((1UL << 52) - 1)
>> +
>> +static inline uint64_t get_clock_us(void)
>>   {
>>   	uint64_t clk;
>>   
>>   	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
>>   
>>   	/* Bit 51 is incrememented each microsecond */
>> -	return (clk >> (63 - 51)) / 1000;
>> +	return clk >> STCK_SHIFT_US;
>> +}
>> +
>> +static inline void udelay(unsigned long us)
>> +{
>> +	unsigned long startclk = get_clock_us();
>> +	unsigned long c;
>> +
>> +	do {
>> +		c = get_clock_us();
>> +		if (c < startclk)
>> +			c += STCK_MAX;
>> +	} while (c < startclk + us);
>> +}
>> +
>> +static inline void mdelay(unsigned long ms)
>> +{
>> +	udelay(ms * 1000);
>> +}
>> +
>> +static inline uint64_t get_clock_ms(void)
>> +{
>> +	return get_clock_us() / 1000;
>>   }
> 
> Why don't you put that below to the get_clock_us()?

right, better.


-- 
Pierre Morel
IBM Lab Boeblingen

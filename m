Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0F13EB603
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 15:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240640AbhHMNPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 09:15:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239062AbhHMNPQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 09:15:16 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DD41Rg049449;
        Fri, 13 Aug 2021 09:14:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=myabMtQaPCdNWRfAyEij1L8HPiaNtrJE7inCLBGOUjY=;
 b=A30uLzPMnKopfMYnASD3n5k8oUqpKnI/XwKc5JgZSIwTTBqcXShCiGxN8W9YMYzgnYPa
 5A5FdsgjPnXbnpNZ7+5vv75G1dHL378rj/pWV2HoEMRua6+PH0H7j6IKPeYzlY6lAiS0
 IzTC6iwvr1oAR7frdrhWRT781lk3r1jOM7EmHx7su1a3aVMkWeTUhAXHl8Mj8gArG7CU
 UONN7fUy+9KFZJqmGRS9I9ZIsbxm1314t0Wy/pU+OhUBByLHzHWv2HDw5Bxjp00wyWqd
 wk6ACDgxyBWJiL9Vc3k2UMH2MKA5pwDyoF/6re8Qyvb1GdEQegg3M8bhZ3smQhppq9WT CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ad4qbfqef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 09:14:48 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17DD4ak9052513;
        Fri, 13 Aug 2021 09:14:48 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ad4qbfqe1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 09:14:47 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17DDDWKh015347;
        Fri, 13 Aug 2021 13:14:46 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ad4kqhngn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 13:14:46 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17DDBPkn32506156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 13:11:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDEFCA4064;
        Fri, 13 Aug 2021 13:14:43 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79FF1A4054;
        Fri, 13 Aug 2021 13:14:43 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.158.198])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Aug 2021 13:14:43 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <20210813073615.32837-1-frankja@linux.ibm.com>
 <20210813073615.32837-6-frankja@linux.ibm.com>
 <20210813104544.17cbbb94@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 5/8] s390x: uv-host: Explain why we set up
 the home space and remove the space change
Message-ID: <13df31b4-f513-8e51-071a-c2fc00fa4900@linux.ibm.com>
Date:   Fri, 13 Aug 2021 15:14:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210813104544.17cbbb94@p-imbrenda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CNuAnrQof6cnHSkbROjmQb-07Ay6Cd8x
X-Proofpoint-ORIG-GUID: FiN1Anvc9LS2Hpn-nrhmpA7516lDgI3l
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_04:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 adultscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108130080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/13/21 10:45 AM, Claudio Imbrenda wrote:
> On Fri, 13 Aug 2021 07:36:12 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> UV home addresses don't require us to be in home space but we need to
>> have it set up so hw/fw can use the home asce to translate home
>> virtual addresses.
>>
>> Hence we add a comment why we're setting up the home asce and remove
>> the address space since it's unneeded.
> 
> oh, we actually never use it?

Yes, as I said, those addresses are not relative to your PSW DAT
settings, they are defined to be home space addresses.

>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks!

> 
>> ---
>>  s390x/uv-host.c | 11 ++++++++---
>>  1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
>> index 426a67f6..28035707 100644
>> --- a/s390x/uv-host.c
>> +++ b/s390x/uv-host.c
>> @@ -444,13 +444,18 @@ static void test_clear(void)
>>  
>>  static void setup_vmem(void)
>>  {
>> -	uint64_t asce, mask;
>> +	uint64_t asce;
>>  
>>  	setup_mmu(get_max_ram_size(), NULL);
>> +	/*
>> +	 * setup_mmu() will enable DAT and set the primary address
>> +	 * space but we need to have a valid home space since UV
>> calls
>> +	 * take home space virtual addresses.
>> +	 *
>> +	 * Hence we just copy the primary asce into the home space.
>> +	 */
>>  	asce = stctg(1);
>>  	lctlg(13, asce);
>> -	mask = extract_psw_mask() | 0x0000C00000000000UL;
>> -	load_psw_mask(mask);
>>  }
>>  
>>  int main(void)
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E555999C1
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 12:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347832AbiHSKbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 06:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347553AbiHSKbc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 06:31:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF95F075C
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 03:31:31 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27JA37iP000865
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 10:31:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SFbFqyGPHdEGCq+cLjXab6BrdwyLWIlT5/UHYaZrCWE=;
 b=BsgLm1ttPemo0JfT7F+vxrdB+6G3tjlSW/Gg/52sXJOjm2YrVqXzpx6nyjSkVKSwrgGj
 Wh+e8ZXXsDIKDf73U42Hil+E8twZqEmw+rCnB7d4f3RwqszoSGnvNQ/8O/IDtu3LHx2J
 ije20KM6w338uKbDLxl3Dun51MwHjIiKtVQufD7ayZOtNMt8pjMGj0YVtTVOj/nGMbCl
 MksPtEZdZFe39IbHAJsdIY0TKysGFlv3YUllNm7DvbFPZ3qkpizIpCbJOseNT+aSsrwh
 hJRSQsZMacC1+XmfaJlztV4MtIxKSgJNvYjgV13q+XOuOpskINdCkT9YA8OCo1RmtScf qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j28e68m5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 10:31:30 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27JA3CiJ002624
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 10:31:29 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j28e68m58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 10:31:29 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27JA8xYJ017415;
        Fri, 19 Aug 2022 10:31:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3hx3k8y3n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 10:31:27 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27JAVO4O13238602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 10:31:24 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99974A405B;
        Fri, 19 Aug 2022 10:31:24 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59272A4054;
        Fri, 19 Aug 2022 10:31:24 +0000 (GMT)
Received: from [9.145.49.220] (unknown [9.145.49.220])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Aug 2022 10:31:24 +0000 (GMT)
Message-ID: <8f9714f6-3780-1499-70db-38c74136ae50@linux.ibm.com>
Date:   Fri, 19 Aug 2022 12:31:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, seiden@linux.ibm.com
References: <20220818152114.213135-1-imbrenda@linux.ibm.com>
 <d65e5beb-e417-b13d-f5f6-eb0e91ccc1f3@linux.ibm.com>
 <20220819111210.4b1e3fe6@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/1] lib/s390x: fix SMP setup bug
In-Reply-To: <20220819111210.4b1e3fe6@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WkDO8kG1divBz8KSWv_I0CVmBmUqnM5x
X-Proofpoint-ORIG-GUID: X9A3qRUst86YbFWPlu7dILry8rrukwCk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_06,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208190040
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/19/22 11:12, Claudio Imbrenda wrote:
> On Fri, 19 Aug 2022 10:52:40 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 8/18/22 17:21, Claudio Imbrenda wrote:
>>> The lowcore pointer pointing to the current CPU (THIS_CPU) was not
>>> initialized for the boot CPU. The pointer is needed for correct
>>> interrupt handling, which is needed in the setup process before the
>>> struct cpu array is allocated.
>>>
>>> The bug went unnoticed because some environments (like qemu/KVM) clear
>>> all memory and don't write anything in the lowcore area before starting
>>> the payload. The pointer thus pointed to 0, an area of memory also not
>>> used. Other environments will write to memory before starting the
>>> payload, causing the unit tests to crash at the first interrupt.
>>>
>>> Fix by assigning a temporary struct cpu before the rest of the setup
>>> process, and assigning the pointer to the correct allocated struct
>>> during smp initialization.
>>>
>>> Fixes: 4e5dd758 ("lib: s390x: better smp interrupt checks")
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>
>> I've considered letting the IPL cpu have a static struct cpu and setting
>> it up in cstart64.S. But that would mean that we would need extra
>> handling when using smp functions and that'll look even worse.
>>
>> Reported-by: Janosch Frank <frankja@linux.ibm.com>
>>
>>> ---
>>>    lib/s390x/io.c  | 9 +++++++++
>>>    lib/s390x/smp.c | 1 +
>>>    2 files changed, 10 insertions(+)
>>>
>>> diff --git a/lib/s390x/io.c b/lib/s390x/io.c
>>> index a4f1b113..fb7b7dda 100644
>>> --- a/lib/s390x/io.c
>>> +++ b/lib/s390x/io.c
>>> @@ -33,6 +33,15 @@ void puts(const char *s)
>>>    
>>>    void setup(void)
>>>    {
>>> +	struct cpu this_cpu_tmp = { 0 };
>>
>> We can setup these struct members here and memcpy in smp_setup()
>> .addr = stap();
>> .stack = stackptr;
> 
> stackptr is accessible in io.c (I would need to add an extern
> declaration)
> 
>> .lowcore = (void *)0;
>> .active = true;
> 
> this temporary struct is then not accessible from smp_setup, so it
> can't be memcpy-ed.
> 
> if you really want something meaningful in the temporary struct, it has
> to be initialized in smp.c and called in io.c (something like
> smp_boot_cpu_tmp_setup(&this_cpu_tmp) ), but then still no memcpy.
> 
> in the end the struct cpu is needed only to allow interrupts to happen
> without crashes, I don't think we strictly need initialization

Ugh, this feels like a quick fix.
But alright, I've just tried setting it up from cstart64.S and it's way 
more ugly code so let's stick with this for now.

> 
>>
>>
>>> +
>>> +	/*
>>> +	 * Set a temporary empty struct cpu for the boot CPU, needed for
>>> +	 * correct interrupt handling in the setup process.
>>> +	 * smp_setup will allocate and set the permanent one.
>>> +	 */
>>> +	THIS_CPU = &this_cpu_tmp;
>>> +
>>>    	setup_args_progname(ipl_args);
>>>    	setup_facilities();
>>>    	sclp_read_info();
>>> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
>>> index 0d98c17d..03d6d2a4 100644
>>> --- a/lib/s390x/smp.c
>>> +++ b/lib/s390x/smp.c
>>> @@ -353,6 +353,7 @@ void smp_setup(void)
>>>    			cpus[0].stack = stackptr;
>>>    			cpus[0].lowcore = (void *)0;
>>>    			cpus[0].active = true;
>>> +			THIS_CPU = &cpus[0];
>>
>> /* Override temporary struct cpu address with permanent one */
> 
> will be done
> 
>>
>>>    		}
>>>    	}
>>>    	spin_unlock(&lock);
>>
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76706EE0A5
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 12:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbjDYKyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 06:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbjDYKyF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 06:54:05 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA80D49D2;
        Tue, 25 Apr 2023 03:54:03 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PAeGgd025149;
        Tue, 25 Apr 2023 10:54:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9M4GRwnADwJQa3TDaGvfIVRiRTwjI2rroa87iqQSeyk=;
 b=fvxmu1yE0Wm4aE4b0lWUK0Uirrl0pV/5YcDUL9geCor93X2dhHGRitVNhyyIr/F1wRnQ
 ON8/6M7VXoa6U3HoguTMlfby5qR1YDa94qR6+Jh8H4uUwnOjMnc5U+PLBTz3VM0OwjFN
 LhV+SW55eYPFuTAHkkWNi7kiMvaCgtmVvqNWSi6JBZVExxqTorhwfM0FZpEgEBCpqqBO
 gkO12jl/598fSJhC6GPR8OoofWRN7/rrT5gw5b0QNYCMwrIoWMgd+Fk+qHjuGoIGm8aK
 uUAlRuT8cF7YvOdqBZ4Ne5Gy8caPITX+Vea5cHU38viK72fZCEljahl+EIJVM5N+wXTF Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6cmqt5vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 10:54:02 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33PAempl026635;
        Tue, 25 Apr 2023 10:54:02 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6cmqt5tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 10:54:02 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33P4UAWT015967;
        Tue, 25 Apr 2023 10:53:58 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3q4776sd4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 10:53:58 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33PArs2X15598242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 10:53:54 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 920DA2004D;
        Tue, 25 Apr 2023 10:53:54 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50EB420043;
        Tue, 25 Apr 2023 10:53:54 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 25 Apr 2023 10:53:54 +0000 (GMT)
Message-ID: <5572f655-4cc8-500f-97fd-068c9f06a90b@linux.ibm.com>
Date:   Tue, 25 Apr 2023 12:53:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH 1/1] s390x: sclp: consider monoprocessor on
 read_info error
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        nrb@linux.ibm.com, nsg@linux.ibm.com, cohuck@redhat.com
References: <20230424174218.64145-1-pmorel@linux.ibm.com>
 <20230424174218.64145-2-pmorel@linux.ibm.com>
 <20230425102606.4e9bc606@p-imbrenda>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20230425102606.4e9bc606@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jYMU7oX65RcgMpHqhFGlrfuJhTSa1oTc
X-Proofpoint-ORIG-GUID: Zf3B9MnPeowZtCRaaqBOGLVAXWOuYIOL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_03,2023-04-25_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 phishscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 suspectscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304250094
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/25/23 10:26, Claudio Imbrenda wrote:
> On Mon, 24 Apr 2023 19:42:18 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
>
>> When we can not read SCP information we can not abort during
>> sclp_get_cpu_num() because this function is called during exit
>> and calling it will lead to an infnite loop.
>>
>> The loop is:
>> abort() -> exit() -> smp_teardown() -> smp_query_num_cpus() ->
>> sclp_get_cpu_num() -> assert() -> abort()
>>
>> Since smp_setup() is done after sclp_read_info() inside setup() this
>> loop happens when only the start processor is running.
>> Let sclp_get_cpu_num() return 1 in this case.
> looks good to me, but please add a comment to explain that this is only
> supposed to happen in exceptional circumstances


Is this ok like this:

"
Read SCP information can fails if the SCLP buffer length is too small
for the information to return which happens for example when defining 248 CPUs.

When SCLP read SCP information did fail during setup, we can currently not abort because
the function sclp_get_cpu_num(), called during exit, asserts on the previous success
of SCLP read SCP information.

The loop is:
abort() -> exit() -> smp_teardown() -> smp_query_num_cpus() ->
sclp_get_cpu_num() -> assert() -> abort()

Since smp_setup() is done after sclp_read_info() inside setup() this
loop happens when only the start processor is running.

Since only one processor is running and we know it, we do not
need to make the SCLP call in sclp_get_cpu_num() and can safely return 1.
"

>
>> Fixes: 52076a63d569 ("s390x: Consolidate sclp read info")
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/sclp.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>> index acdc8a9..c09360d 100644
>> --- a/lib/s390x/sclp.c
>> +++ b/lib/s390x/sclp.c
>> @@ -119,8 +119,9 @@ void sclp_read_info(void)
>>   
>>   int sclp_get_cpu_num(void)
>>   {
>> -	assert(read_info);
>> -	return read_info->entries_cpu;
>> +    if (read_info)
>> +	    return read_info->entries_cpu;
>> +    return 1;
>>   }
>>   
>>   CPUEntry *sclp_get_cpu_entries(void)

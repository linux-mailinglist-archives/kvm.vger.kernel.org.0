Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597D46F17F4
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345353AbjD1M2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbjD1M2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:28:53 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B144A30E8
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:28:51 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33SCS9mu023056;
        Fri, 28 Apr 2023 12:28:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=y18MFp+WejuTwMiPeHoOoyzNcpTpgBzRDZZ/mr7+c0w=;
 b=Ul+yEyUFCI4G17lrZio5Wyu6eoQWyhvBrjKPDgi6f7wEKB8IjZa2ArdtOu2kJcSalj1+
 uQRnF5J0NXpsV+txdrBMtJxHJhOTF9B9/P2ssv1A+dlenykzVOKbZNxW/sB/OHVml5fH
 Vu4HtCm76BTGKLMsxdoA/Y9onTi81JeNN4oG0F4AItRXZbx+0PeFhHd3srfYrca2R6kq
 MwGViruYmhY8zLcVWC92lUfAXyTFPCvGmvUogYJXdaaLPUto6jMQJgvibRCL1IoNONEN
 dtdf4EjvaJv/sjGOzqiLNBFchZUxYAgSOvGHOphFRKc8okbkFN7DrICyo7sbYeCycaGL 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q8dqp0nqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 12:28:19 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33SCQsUB014901;
        Fri, 28 Apr 2023 12:27:57 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q8dqp0n3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 12:27:57 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33RNLrJQ018187;
        Fri, 28 Apr 2023 12:27:25 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3q47773jeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 12:27:25 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33SCRJed34210168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Apr 2023 12:27:20 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA53E20043;
        Fri, 28 Apr 2023 12:27:19 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFF7B20040;
        Fri, 28 Apr 2023 12:27:18 +0000 (GMT)
Received: from [9.171.23.33] (unknown [9.171.23.33])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 28 Apr 2023 12:27:18 +0000 (GMT)
Message-ID: <9ffdbd31-061c-619d-8902-69782ceed7a9@linux.ibm.com>
Date:   Fri, 28 Apr 2023 14:27:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v20 01/21] s390x/cpu topology: add s390 specifics to CPU
 topology
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-2-pmorel@linux.ibm.com>
 <45e09800-6a47-0372-5244-16e2dc72370d@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <45e09800-6a47-0372-5244-16e2dc72370d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Dff9MUfjR9yga7R--plK1u2Dn5GXXItd
X-Proofpoint-GUID: 0uQy4w_317ZDZMrKC7a8nH942PlX-eE6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-28_04,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304280098
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/27/23 10:04, Thomas Huth wrote:
> On 25/04/2023 18.14, Pierre Morel wrote:
>> S390 adds two new SMP levels, drawers and books to the CPU
>> topology.
>> The S390 CPU have specific topology features like dedication
>> and entitlement to give to the guest indications on the host
>> vCPUs scheduling and help the guest take the best decisions
>> on the scheduling of threads on the vCPUs.
>>
>> Let us provide the SMP properties with books and drawers levels
>> and S390 CPU with dedication and entitlement,
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
> ...> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>> index 2e267fa458..42a6a40333 100644
>> --- a/qapi/machine-target.json
>> +++ b/qapi/machine-target.json
>> @@ -342,3 +342,15 @@
>>                      'TARGET_S390X',
>>                      'TARGET_MIPS',
>>                      'TARGET_LOONGARCH64' ] } }
>> +
>> +##
>> +# @CpuS390Polarization:
>> +#
>> +# An enumeration of cpu polarization that can be assumed by a virtual
>> +# S390 CPU
>> +#
>> +# Since: 8.1
>> +##
>> +{ 'enum': 'CpuS390Polarization',
>> +  'prefix': 'S390_CPU_POLARIZATION',
>> +  'data': [ 'horizontal', 'vertical' ] }
>
> It seems like you don't need this here yet ... I think you likely 
> could also introduce it in a later patch instead (patch 11 seems the 
> first one that needs this?)
>
> Also, would a " 'if': 'TARGET_S390X' " be possible here, too?


Yes, I will shift this to patch 11.


>
>> diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
>> index c3dab007da..77bee06304 100644
>> --- a/hw/core/machine-smp.c
>> +++ b/hw/core/machine-smp.c
>> @@ -30,8 +30,19 @@ static char *cpu_hierarchy_to_string(MachineState 
>> *ms)
>>   {
>>       MachineClass *mc = MACHINE_GET_CLASS(ms);
>>       GString *s = g_string_new(NULL);
>> +    const char *multiply = " * ", *prefix = "";
>>   -    g_string_append_printf(s, "sockets (%u)", ms->smp.sockets);
>> +    if (mc->smp_props.drawers_supported) {
>> +        g_string_append_printf(s, "drawers (%u)", ms->smp.drawers);
>> +        prefix = multiply;
>
> That "prefix" stuff looks complicated ... why don't you simply add the 
> "*" at the end of the strings:
>
>     g_string_append_printf(s, "drawers (%u) * ",
>                            ms->smp.drawers);
>
> ?


Right, I did not think enough when I made this change.


>
>> +    }
>> +
>> +    if (mc->smp_props.books_supported) {
>> +        g_string_append_printf(s, "%sbooks (%u)", prefix, 
>> ms->smp.books);
>> +        prefix = multiply;
>> +    }
>> +
>> +    g_string_append_printf(s, "%ssockets (%u)", prefix, 
>> ms->smp.sockets);
>
> ... it's followed by "sockets" here anyway, so adding the " * " at the 
> end of the strings above should be fine.


yes


>
>>   {
>>       MachineClass *mc = MACHINE_GET_CLASS(ms);
>>       unsigned cpus    = config->has_cpus ? config->cpus : 0;
>> +    unsigned drawers = config->has_drawers ? config->drawers : 0;
>> +    unsigned books   = config->has_books ? config->books : 0;
>>       unsigned sockets = config->has_sockets ? config->sockets : 0;
>>       unsigned dies    = config->has_dies ? config->dies : 0;
>>       unsigned clusters = config->has_clusters ? config->clusters : 0;
>> @@ -85,6 +98,8 @@ void machine_parse_smp_config(MachineState *ms,
>>        * explicit configuration like "cpus=0" is not allowed.
>>        */
>>       if ((config->has_cpus && config->cpus == 0) ||
>> +        (config->has_drawers && config->drawers == 0) ||
>> +        (config->has_books && config->books == 0) ||
>>           (config->has_sockets && config->sockets == 0) ||
>>           (config->has_dies && config->dies == 0) ||
>>           (config->has_clusters && config->clusters == 0) ||
>> @@ -111,6 +126,19 @@ void machine_parse_smp_config(MachineState *ms,
>>       dies = dies > 0 ? dies : 1;
>>       clusters = clusters > 0 ? clusters : 1;
>>   +    if (!mc->smp_props.books_supported && books > 1) {
>> +        error_setg(errp, "books not supported by this machine's CPU 
>> topology");
>> +        return;
>> +    }
>> +    books = books > 0 ? books : 1;
>
> Could be shortened to:  book = books ?: 1;


I always forgot that Elvis is not dead


>
>> +    if (!mc->smp_props.drawers_supported && drawers > 1) {
>> +        error_setg(errp,
>> +                   "drawers not supported by this machine's CPU 
>> topology");
>> +        return;
>> +    }
>> +    drawers = drawers > 0 ? drawers : 1;
>
> Could be shortened to:  drawers = drawers ?: 1;


yes


>
>>       /* compute missing values based on the provided ones */
>>       if (cpus == 0 && maxcpus == 0) {
>>           sockets = sockets > 0 ? sockets : 1;
>> @@ -124,33 +152,41 @@ void machine_parse_smp_config(MachineState *ms,
>>               if (sockets == 0) {
>>                   cores = cores > 0 ? cores : 1;
>>                   threads = threads > 0 ? threads : 1;
>> -                sockets = maxcpus / (dies * clusters * cores * 
>> threads);
>> +                sockets = maxcpus /
>> +                          (drawers * books * dies * clusters * cores 
>> * threads);
>>               } else if (cores == 0) {
>>                   threads = threads > 0 ? threads : 1;
>> -                cores = maxcpus / (sockets * dies * clusters * 
>> threads);
>> +                cores = maxcpus /
>> +                        (drawers * books * sockets * dies * clusters 
>> * threads);
>>               }
>
> (not very important, but I wonder whether we should maybe disallow 
> "prefer_sockets" with drawers and books instead of updating the 
> calculation here - since prefer_sockets should only occur on old 
> machine types)


It is OK for me. The contra argument would be that for balancing it is 
nicer.

But as you like, it makes less code and we can add it later if we ever 
set prefer_socket = true again, which is very uncertain.


>
>>           } else {
>>               /* prefer cores over sockets since 6.2 */
>>               if (cores == 0) {
>>                   sockets = sockets > 0 ? sockets : 1;
>>                   threads = threads > 0 ? threads : 1;
>> -                cores = maxcpus / (sockets * dies * clusters * 
>> threads);
>> +                cores = maxcpus /
>> +                        (drawers * books * sockets * dies * clusters 
>> * threads);
>>               } else if (sockets == 0) {
>>                   threads = threads > 0 ? threads : 1;
>> -                sockets = maxcpus / (dies * clusters * cores * 
>> threads);
>> +                sockets = maxcpus /
>> +                          (drawers * books * dies * clusters * cores 
>> * threads);
>>               }
>>           }
>
>  Thomas
>
Thanks Thomas.

Regards,

Pierre


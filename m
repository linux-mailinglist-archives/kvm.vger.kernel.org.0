Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53A86D649D
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 16:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbjDDOFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 10:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235864AbjDDOFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 10:05:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75615255
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 07:04:44 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334DQEJm023501;
        Tue, 4 Apr 2023 14:04:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=x1xOg6hBINjht0ywWl2rsNhpY9WlQ9mVoC/o9PbOpCs=;
 b=UNPHxz5VasSjTDywhA4m6XbjLTzEsBHwyl72kLHQXfOEN6FgSjNHhRMlhlPyz1N+Yrdu
 agWv0TKCCogZL6A2hSe/sNBkqsSflopth0kzdjgSpuPUqOtMW5yCCSk/bXPZRI9F8SEb
 nOO5faFpZyBaGtSRpB+/1KBSJLgQ0e3qibMpMUbRzU0do7Xt5rcpNeBI8juBvSqgZLmH
 yJHEIFHlnQmOCLkhU6w01T88qccJiV34qNIwwOLavD0b8rPfyLGK9LtO/V3D8gHgDkX4
 vOvGdza2don2mmljYFSWoXNWX2GRkYXhHU+PcPO7417I0pik2EjkxGqnfITd+nFI7WHU Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prmsd175r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 14:04:26 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334DQpUk028485;
        Tue, 4 Apr 2023 14:04:25 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prmsd174e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 14:04:25 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 333LTqKD010775;
        Tue, 4 Apr 2023 14:04:23 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ppbvg2jmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 14:04:23 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334E4Jrr30343798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 14:04:19 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51AB32004B;
        Tue,  4 Apr 2023 14:04:19 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D10F32004F;
        Tue,  4 Apr 2023 14:04:18 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue,  4 Apr 2023 14:04:18 +0000 (GMT)
Message-ID: <a46e9349-704c-e842-58c0-515ecb7b2d60@linux.ibm.com>
Date:   Tue, 4 Apr 2023 16:04:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v19 01/21] s390x/cpu topology: add s390 specifics to CPU
 topology
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
 <20230403162905.17703-2-pmorel@linux.ibm.com>
 <4118bb4e-0505-26d3-3ffe-49245eae5364@kaod.org>
 <bd5cc488-20a7-54d1-7c3e-86136db77f84@linux.ibm.com>
 <55c4e517-dbd0-bbd2-7dde-0e2cab746101@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <55c4e517-dbd0-bbd2-7dde-0e2cab746101@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mNB3Mp8q4YtE5SRbJzh8ASdC_ZjHk0y9
X-Proofpoint-GUID: f7Sv0teIcDF-8Ge3K7IQ59SzxMc75Ztn
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_06,2023-04-04_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 mlxlogscore=669 phishscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040130
X-Spam-Status: No, score=-2.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/4/23 14:35, Cédric Le Goater wrote:
>>>> @@ -0,0 +1,15 @@
>>>> +/*
>>>> + * CPU Topology
>>>> + *
>>>> + * Copyright IBM Corp. 2022
>>>
>>> Shouldn't we have some range : 2022-2023 ?
>>
>> There was a discussion on this in the first spins, I think to 
>> remember that Nina wanted 22 and Thomas 23,
>>
>> now we have a third opinion :) .
>>
>> I must say that all three have their reasons and I take what the 
>> majority wants.
>
> There is an internal IBM document describing the copyright tags. If I 
> recall
> well, first date is the first year the code was officially published, 
> second
> year is the last year it was modified (so last commit of the year). Or
> something like that and it's theory, because we tend to forget.
>
> For an example, see the OPAL FW https://github.com/open-power/skiboot/,
> and run :
>
>   "grep Copyright.*IBM" in the OPAL FW


OK for me, it looks logical, and all three of you are right then.

So I will use

Copyright IBM Corp. 2022-2023

in the next spin if nobody is against.

Thanks,

Pierre


>  [ ...]
>
>>>> @@ -30,8 +30,19 @@ static char 
>>>> *cpu_hierarchy_to_string(MachineState *ms)
>>>>   {
>>>>       MachineClass *mc = MACHINE_GET_CLASS(ms);
>>>>       GString *s = g_string_new(NULL);
>>>> +    const char *multiply = " * ", *prefix = "";
>>>>   -    g_string_append_printf(s, "sockets (%u)", ms->smp.sockets);
>>>> +    if (mc->smp_props.drawers_supported) {
>>>> +        g_string_append_printf(s, "drawers (%u)", ms->smp.drawers);
>>>> +    prefix = multiply;
>>>
>>> indent issue.
>>
>> right, seems I forgot to update the patch set after the checkpatch.
>
> nope, you didn't. checkpatch doesn't report it. It's not perfect :/
>
> C.

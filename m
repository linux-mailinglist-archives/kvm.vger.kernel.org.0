Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAE6750DC2
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjGLQOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbjGLQOQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:14:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A75211E
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:13:56 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CG31UH004957;
        Wed, 12 Jul 2023 16:12:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hL1QscgM8TzuEZOPUOJWa2p8IobIBw8mwwqBPp9Zx6Q=;
 b=A9ho07o6NmWaBgnqRX3APK7ARCNHqfZ/dJ366LswEwBFCoSYB2otHymQiit8NZP3h83D
 4FpxFjkn5PhfqJYNTMuhX08AIJ0D5Hw6F6a38dLy2tYKRqeVCKl3cZhJ0R3ANLGYl+Hb
 J4+aET4yo83plT6JkMh4IT+9Emb6BPK+Mp0ZWWD1WfumQKdK7rBciQv1pz+l0d5JTrLr
 LuQshxOb3TDdA/PtpTtm62KyvKvXlf9WVmG2Yt7bDttikijHhODb1lTXu4eXMFTpiHmZ
 6V8toZBCR5+DjGazpbtTCaZyHgvy8dmNsiR2JIpjXr6dEJGFHGJOqQwYExQ1E/HekwQo lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rsybv8cfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 16:12:56 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36CGC4lU019191;
        Wed, 12 Jul 2023 16:12:55 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rsybv8cev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 16:12:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36C2jAgf015105;
        Wed, 12 Jul 2023 16:12:52 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3rpye5aquk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 16:12:52 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36CGCmFI31523158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 16:12:48 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22CC420040;
        Wed, 12 Jul 2023 16:12:48 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88F1A20043;
        Wed, 12 Jul 2023 16:12:47 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 12 Jul 2023 16:12:47 +0000 (GMT)
Message-ID: <47a7518e-2ca6-e2a1-2130-ddf21163ba5e@linux.ibm.com>
Date:   Wed, 12 Jul 2023 18:12:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v21 12/20] qapi/s390x/cpu topology: query-cpu-polarization
 qmp command
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-13-pmorel@linux.ibm.com>
 <3d4d0349-45c1-28c7-1da1-3c66f03025a0@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <3d4d0349-45c1-28c7-1da1-3c66f03025a0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yI3WLEd3lB3400EyHay7aRzl37KU9K5z
X-Proofpoint-ORIG-GUID: RbsFEQxUxlM4QMvoo8OCVmdPuXbNI-3E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_11,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 clxscore=1015 mlxscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307120144
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/5/23 09:58, Thomas Huth wrote:
> On 30/06/2023 11.17, Pierre Morel wrote:
>> The query-cpu-polarization qmp command returns the current
>> CPU polarization of the machine.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   qapi/machine-target.json | 29 +++++++++++++++++++++++++++++
>>   hw/s390x/cpu-topology.c  |  8 ++++++++
>>   2 files changed, 37 insertions(+)
>>
>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>> index 1362e43983..1e4b8976aa 100644
>> --- a/qapi/machine-target.json
>> +++ b/qapi/machine-target.json
>> @@ -445,3 +445,32 @@
>>     'features': [ 'unstable' ],
>>     'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>>   }
>> +
>> +##
>> +# @CpuPolarizationInfo:
>> +#
>> +# The result of a cpu polarization
>> +#
>> +# @polarization: the CPU polarization
>> +#
>> +# Since: 8.1
>> +##
>> +{ 'struct': 'CpuPolarizationInfo',
>> +  'data': { 'polarization': 'CpuS390Polarization' },
>> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>> +}
>> +
>> +##
>> +# @query-cpu-polarization:
>> +#
>> +# Features:
>> +# @unstable: This command may still be modified.
>> +#
>> +# Returns: the machine polarization
>> +#
>> +# Since: 8.1
>> +##
>> +{ 'command': 'query-cpu-polarization', 'returns': 
>> 'CpuPolarizationInfo',
>
> Since this is very specific to s390x, I wonder whether we want to have 
> a "s390x" in the command name? 'query-s390x-cpu-polarization'? ... or 
> is this getting too long already?
>
> Anyway,
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>
I do not know.I prefer short commands but the interface will mostly be 
used by a program, so...

I let it like that unless there is more pressure to change it.

Thanks,

Pierre



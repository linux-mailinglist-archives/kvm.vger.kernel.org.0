Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715D467225A
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 17:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjARQCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 11:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjARQAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 11:00:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590C237F3A
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 07:58:21 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IFhOtj014001;
        Wed, 18 Jan 2023 15:58:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Msm+dv/+e1/SAlRLDe00Cl/x8sVHm+qI2s9ev0bAzAU=;
 b=ii28U3Ok7kq6Id1o7H5X/tsLIbuslSgE74fZbAeEHYh+Ox+Mvl0YLBpJx028gRqWP5Pd
 bisrAXBTgPMjOCSMpt24XXa/lKfUoQ6zbYCwsEOH/oEnPSdjGBnYgZrcdYQta2zjbM2B
 oOfXU7SEzp2yJuAfYG5LI336uEByR62LL51bC237bGjyWfJfDC+O5WKrZARGiarhBHlG
 TBQRBGO0I+na7o/wnD8hVTQy4HKaJzZcfPO5UyWlOkECCeKLy++hDVDTDHHsD8clR2wE
 ggJBKRmbngm5F7jYtQqm1OIrgz7NbSmZIH125ixVvNJcXR+6xk4lSe2i0o+70Z5AqVwr zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6fp6q2jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 15:58:13 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30IDoWgr011352;
        Wed, 18 Jan 2023 15:58:13 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6fp6q2hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 15:58:13 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30IDRCPB009485;
        Wed, 18 Jan 2023 15:58:10 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n3knfngss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 15:58:10 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IFw6Cj23134782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 15:58:07 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEDBB20040;
        Wed, 18 Jan 2023 15:58:06 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C40C20043;
        Wed, 18 Jan 2023 15:58:05 +0000 (GMT)
Received: from [9.179.13.15] (unknown [9.179.13.15])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 15:58:05 +0000 (GMT)
Message-ID: <d97d0a6a-a87e-e0d2-5d95-0645c09d9730@linux.ibm.com>
Date:   Wed, 18 Jan 2023 16:58:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 09/11] qapi/s390/cpu topology: monitor query topology
 information
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-10-pmorel@linux.ibm.com> <Y7/4rm9JYihUpLS1@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <Y7/4rm9JYihUpLS1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HYJ6Mq9762stCJlK-TZ39d0DAnwyDjZ0
X-Proofpoint-ORIG-GUID: liceC4Jt1nbv6FqZaXV-4gUSf2sEPx_Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 malwarescore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180130
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/12/23 13:10, Daniel P. Berrangé wrote:
> On Thu, Jan 05, 2023 at 03:53:11PM +0100, Pierre Morel wrote:
>> Reporting the current topology informations to the admin through
>> the QEMU monitor.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   qapi/machine-target.json | 66 ++++++++++++++++++++++++++++++++++
>>   include/monitor/hmp.h    |  1 +
>>   hw/s390x/cpu-topology.c  | 76 ++++++++++++++++++++++++++++++++++++++++
>>   hmp-commands-info.hx     | 16 +++++++++
>>   4 files changed, 159 insertions(+)
>>
>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>> index 75b0aa254d..927618a78f 100644
>> --- a/qapi/machine-target.json
>> +++ b/qapi/machine-target.json
>> @@ -371,3 +371,69 @@
>>     },
>>     'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>>   }
>> +
>> +##
>> +# @S390CpuTopology:
>> +#
>> +# CPU Topology information
>> +#
>> +# @drawer: the destination drawer where to move the vCPU
>> +#
>> +# @book: the destination book where to move the vCPU
>> +#
>> +# @socket: the destination socket where to move the vCPU
>> +#
>> +# @polarity: optional polarity, default is last polarity set by the guest
>> +#
>> +# @dedicated: optional, if the vCPU is dedicated to a real CPU
>> +#
>> +# @origin: offset of the first bit of the core mask
>> +#
>> +# @mask: mask of the cores sharing the same topology
>> +#
>> +# Since: 8.0
>> +##
>> +{ 'struct': 'S390CpuTopology',
>> +  'data': {
>> +      'drawer': 'int',
>> +      'book': 'int',
>> +      'socket': 'int',
>> +      'polarity': 'int',
>> +      'dedicated': 'bool',
>> +      'origin': 'int',
>> +      'mask': 'str'
>> +  },
>> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>> +}
>> +
>> +##
>> +# @query-topology:
>> +#
>> +# Return information about CPU Topology
>> +#
>> +# Returns a @CpuTopology instance describing the CPU Toplogy
>> +# being currently used by QEMU.
>> +#
>> +# Since: 8.0
>> +#
>> +# Example:
>> +#
>> +# -> { "execute": "cpu-topology" }
>> +# <- {"return": [
>> +#     {
>> +#         "drawer": 0,
>> +#         "book": 0,
>> +#         "socket": 0,
>> +#         "polarity": 0,
>> +#         "dedicated": true,
>> +#         "origin": 0,
>> +#         "mask": 0xc000000000000000,
>> +#     },
>> +#    ]
>> +#   }
>> +#
>> +##
>> +{ 'command': 'query-topology',
>> +  'returns': ['S390CpuTopology'],
>> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>> +}
> 
> IIUC, you're using @mask as a way to compress the array returned
> from query-topology, so that it doesn't have any repeated elements
> with the same data. I guess I can understand that desire when the
> core count can get very large, this can have a large saving.
> 
> The downside of using @mask, is that now you require the caller
> to parse the string to turn it into a bitmask and expand the
> data. Generally this is considered a bit of an anti-pattern in
> QAPI design - we don't want callers to have to further parse
> the data to extract information, we want to directly consumable
> from the parsed JSON doc.

Not exactly, the mask is computed by the firmware to provide it to the 
guest and is already available when querying the topology.
But I understand that for the QAPI user the mask is not the right 
solution, standard coma separated values like (1,3,5,7-11) would be much 
easier to read.

> 
> We already have 'query-cpus-fast' wich returns one entry for
> each CPU. In fact why do we need to add query-topology at all.
> Can't we just add book-id / drawer-id / polarity / dedicated
> to the query-cpus-fast result ?

Yes we can, I think we should, however when there are a lot of CPU it 
will be complicated to find the CPU sharing the same socket and the same 
attributes.
I think having both would be interesting.

What do you think?

regards,
Pierre

> 
> With regards,
> Daniel

-- 
Pierre Morel
IBM Lab Boeblingen

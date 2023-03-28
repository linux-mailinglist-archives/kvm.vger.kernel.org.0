Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748476CBDB1
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 13:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbjC1LaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 07:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbjC1LaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 07:30:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68AD86AD
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 04:29:49 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SBLAOf033391;
        Tue, 28 Mar 2023 11:29:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=c6HQJRbhNxCpRIQ39rTx8yXNmThqIYSIJmDg4MMTnnI=;
 b=IftEuIhRUjSN6eFLdDfsCrNi3/erzcjlLifvg/ZEA94WjfK1liUuMXC5mt3xzvWxvaCC
 N9TnzJSZXMxwvO/hHoOLPfweg2BxADpryPbsstT0WnIc3sH3enO62Gof1HI9fTFLOauB
 ZA8y+srnpayu04OZTbD7PS6oV98eE4aR9lDP3ZnHEAkHb/OaDDeD6dIpdthTzOu0VL5c
 V7uE/LB/hOLGQOOfb6bzJAFG+kcotDK39PHH6vGHjAyxqWB86Cf206FdtgZK1FJOKdpt
 6sliAt/xj+proWNftPrhYJ/cp122Pd0N83CJpmvb7X8/exJPSbsLCJbbwDC+MD058F1b IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pky9f04ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 11:29:21 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32SBMOEe035938;
        Tue, 28 Mar 2023 11:29:20 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pky9f04ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 11:29:20 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32S4Bcr3009599;
        Tue, 28 Mar 2023 11:29:18 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6kw6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 11:29:17 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32SBT9wx66650592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 11:29:09 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DFEC20043;
        Tue, 28 Mar 2023 11:29:09 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1805C20040;
        Tue, 28 Mar 2023 11:29:09 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 28 Mar 2023 11:29:09 +0000 (GMT)
Message-ID: <0bda770f-c073-3ed0-be26-3a77c8e40b8a@linux.ibm.com>
Date:   Tue, 28 Mar 2023 13:29:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v18 01/17] s390x/cpu topology: add s390 specifics to CPU
 topology
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230315143502.135750-1-pmorel@linux.ibm.com>
 <20230315143502.135750-2-pmorel@linux.ibm.com>
 <1facc09195ef25a5f7ecf9c3bcc016fa1b313628.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <1facc09195ef25a5f7ecf9c3bcc016fa1b313628.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R0aNsxmj8rZVYVD_pGTS4g-uzJ3uL0Pd
X-Proofpoint-GUID: thHJOiAEAWR8Wwh2wonchJgMo5S-ABJk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303280091
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/27/23 23:34, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-03-15 at 15:34 +0100, Pierre Morel wrote:
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
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   qapi/machine-common.json        | 22 +++++++++++++++
>>   qapi/machine-target.json        | 12 +++++++++
>>   qapi/machine.json               | 17 +++++++++---
>>   include/hw/boards.h             | 10 ++++++-
>>   include/hw/s390x/cpu-topology.h | 15 +++++++++++
>>   target/s390x/cpu.h              |  6 +++++
>>   hw/core/machine-smp.c           | 48 ++++++++++++++++++++++++++++-----
>>   hw/core/machine.c               |  4 +++
>>   hw/s390x/s390-virtio-ccw.c      |  2 ++
>>   softmmu/vl.c                    |  6 +++++
>>   target/s390x/cpu.c              |  7 +++++
>>   qapi/meson.build                |  1 +
>>   qemu-options.hx                 |  7 +++--
>>   13 files changed, 144 insertions(+), 13 deletions(-)
>>   create mode 100644 qapi/machine-common.json
>>   create mode 100644 include/hw/s390x/cpu-topology.h
>>
> [...]
>> diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
>> index c3dab007da..b8233df5a9 100644
>> --- a/hw/core/machine-smp.c
>> +++ b/hw/core/machine-smp.c
>> @@ -31,6 +31,14 @@ static char *cpu_hierarchy_to_string(MachineState *ms)
>>       MachineClass *mc = MACHINE_GET_CLASS(ms);
>>       GString *s = g_string_new(NULL);
>>   
>> +    if (mc->smp_props.drawers_supported) {
>> +        g_string_append_printf(s, " * drawers (%u)", ms->smp.drawers);
>> +    }
>> +
>> +    if (mc->smp_props.books_supported) {
>> +        g_string_append_printf(s, " * books (%u)", ms->smp.books);
>> +    }
>> +
>>       g_string_append_printf(s, "sockets (%u)", ms->smp.sockets);
> The output of this doesn't look great.
> How about:
>
> static char *cpu_hierarchy_to_string(MachineState *ms)
> {
>      MachineClass *mc = MACHINE_GET_CLASS(ms);
>      GString *s = g_string_new(NULL);
>      const char *multiply = " * ", *prefix = "";
>
>      if (mc->smp_props.drawers_supported) {
>          g_string_append_printf(s, "drawers (%u)", ms->smp.drawers);
>          prefix = multiply;
>      }
>
>      if (mc->smp_props.books_supported) {
>          g_string_append_printf(s, "%sbooks (%u)", prefix, ms->smp.books);
>          prefix = multiply;
>      }
>
>      g_string_append_printf(s, "%ssockets (%u)", prefix, ms->smp.sockets);
>
>      if (mc->smp_props.dies_supported) {
>          g_string_append_printf(s, " * dies (%u)", ms->smp.dies);
>      }
>
>      if (mc->smp_props.clusters_supported) {
>          g_string_append_printf(s, " * clusters (%u)", ms->smp.clusters);
>      }
>
>      g_string_append_printf(s, " * cores (%u)", ms->smp.cores);
>      g_string_append_printf(s, " * threads (%u)", ms->smp.threads);
>
>      return g_string_free(s, false);
> }
>
>
> [...]

Yes, looks better, thanks

regards,

Pierre



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E733E66E433
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 17:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbjAQQ5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 11:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjAQQ5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 11:57:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE8543924
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 08:57:01 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HGOEYg022078;
        Tue, 17 Jan 2023 16:56:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cLYrJ1QEFjs4vXi2mg9tcnsI+okETg5c6qYXCnh5vaA=;
 b=UMi6t+CIeii5L7FussZDBBXyerAu5tE23OgI4gYLPhXXFTYB3tEk0lYEdMGhN7rgL3sq
 kxJ+/QRI9NTGAQy0lt3Z06KVuCWoBYiNYHygPYtn3/iDXTAjCStNDfjft7E4AypDGPUQ
 frHJ6FdflSeaPaNzNGRnmYq0+g8HQCcEEgV3FiupaXb3Lpi62wWej/+dxZ1kZozm6rmC
 ArqT6G9ye8pjCjSx7FUvz2vR2t8UT3/qgOLkFm+UxTZpc98/GbDf5XdoMxgUUyJlalkQ
 iPNly8TpdadAk5jLSledvVHS2lArLgCyCfBB1hwek0NSCzb1zof80LSzI5A5u8QNaWjv PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5y5trrfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 16:56:53 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30HGs8tE009405;
        Tue, 17 Jan 2023 16:56:53 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5y5trrf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 16:56:53 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30H931eC004689;
        Tue, 17 Jan 2023 16:56:51 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16m609-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 16:56:51 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30HGulRu47055212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 16:56:47 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95B8120043;
        Tue, 17 Jan 2023 16:56:47 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CE9F20040;
        Tue, 17 Jan 2023 16:56:46 +0000 (GMT)
Received: from [9.171.42.216] (unknown [9.171.42.216])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 17 Jan 2023 16:56:46 +0000 (GMT)
Message-ID: <01782d4e-4c84-f958-b427-ff294f6c3c3f@linux.ibm.com>
Date:   Tue, 17 Jan 2023 17:56:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 03/11] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org,
        frankja@linux.ibm.com
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-4-pmorel@linux.ibm.com>
 <5cf19913-b2d7-d72d-4332-27aa484f72e4@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <5cf19913-b2d7-d72d-4332-27aa484f72e4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4WOpgVh8CJ5dMeNZ-ogBuGV41xrkzDAX
X-Proofpoint-ORIG-GUID: dJYrOY-1J-nnWscvP53QhM2GJpMRGdum
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_08,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 impostorscore=0 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301170133
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/10/23 15:29, Thomas Huth wrote:
> On 05/01/2023 15.53, Pierre Morel wrote:
>> On interception of STSI(15.1.x) the System Information Block
>> (SYSIB) is built from the list of pre-ordered topology entries.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
> ...
>> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
>> index 39ea63a416..78988048dd 100644
>> --- a/target/s390x/cpu.h
>> +++ b/target/s390x/cpu.h
>> @@ -561,6 +561,25 @@ typedef struct SysIB_322 {
>>   } SysIB_322;
>>   QEMU_BUILD_BUG_ON(sizeof(SysIB_322) != 4096);
>> +#define S390_TOPOLOGY_MAG  6
>> +#define S390_TOPOLOGY_MAG6 0
>> +#define S390_TOPOLOGY_MAG5 1
>> +#define S390_TOPOLOGY_MAG4 2
>> +#define S390_TOPOLOGY_MAG3 3
>> +#define S390_TOPOLOGY_MAG2 4
>> +#define S390_TOPOLOGY_MAG1 5
>> +/* Configuration topology */
>> +typedef struct SysIB_151x {
>> +    uint8_t  reserved0[2];
>> +    uint16_t length;
>> +    uint8_t  mag[S390_TOPOLOGY_MAG];
>> +    uint8_t  reserved1;
>> +    uint8_t  mnest;
>> +    uint32_t reserved2;
>> +    char tle[];
>> +} QEMU_PACKED QEMU_ALIGNED(8) SysIB_151x;
>> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
>> +
>>   typedef union SysIB {
>>       SysIB_111 sysib_111;
>>       SysIB_121 sysib_121;
>> @@ -568,9 +587,68 @@ typedef union SysIB {
>>       SysIB_221 sysib_221;
>>       SysIB_222 sysib_222;
>>       SysIB_322 sysib_322;
>> +    SysIB_151x sysib_151x;
>>   } SysIB;
>>   QEMU_BUILD_BUG_ON(sizeof(SysIB) != 4096);
>> +/*
>> + * CPU Topology List provided by STSI with fc=15 provides a list
>> + * of two different Topology List Entries (TLE) types to specify
>> + * the topology hierarchy.
>> + *
>> + * - Container Topology List Entry
>> + *   Defines a container to contain other Topology List Entries
>> + *   of any type, nested containers or CPU.
>> + * - CPU Topology List Entry
>> + *   Specifies the CPUs position, type, entitlement and polarization
>> + *   of the CPUs contained in the last Container TLE.
>> + *
>> + * There can be theoretically up to five levels of containers, QEMU
>> + * uses only one level, the socket level.
> 
> I guess that sentence needs an update again, now that you've re-added 
> the books and drawers?

yes

> 
>> + * A container of with a nesting level (NL) greater than 1 can only
>> + * contain another container of nesting level NL-1.
>> + *
>> + * A container of nesting level 1 (socket), contains as many CPU TLE
>> + * as needed to describe the position and qualities of all CPUs inside
>> + * the container.
>> + * The qualities of a CPU are polarization, entitlement and type.
>> + *
>> + * The CPU TLE defines the position of the CPUs of identical qualities
>> + * using a 64bits mask which first bit has its offset defined by
>> + * the CPU address orgin field of the CPU TLE like in:
>> + * CPU address = origin * 64 + bit position within the mask
>> + *
>> + */
>> +/* Container type Topology List Entry */
>> +/* Container type Topology List Entry */
> 
> Duplicated comment.

OK

> 
>> +typedef struct SysIBTl_container {
>> +        uint8_t nl;
>> +        uint8_t reserved[6];
>> +        uint8_t id;
>> +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_container;
>> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
>> +
>> +/* CPU type Topology List Entry */
>> +typedef struct SysIBTl_cpu {
>> +        uint8_t nl;
>> +        uint8_t reserved0[3];
>> +        uint8_t reserved1:5;
>> +        uint8_t dedicated:1;
>> +        uint8_t polarity:2;
> 
> Hmmm, yet another bitfield...

Yes, this is the firmware interface.
If it makes problem I can use masks and logic arithmetic

> 
>> +        uint8_t type;
>> +        uint16_t origin;
>> +        uint64_t mask;
>> +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_cpu;
>> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) != 16);
>> +
>> +/* Max size of a SYSIB structure is when all CPU are alone in a 
>> container */
>> +#define S390_TOPOLOGY_SYSIB_SIZE (sizeof(SysIB_151x) 
>> +                         \
>> +                                  S390_MAX_CPUS * 
>> (sizeof(SysIBTl_container) + \
>> +                                                   sizeof(SysIBTl_cpu)))
>> +
>> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);
>> +
>>   /* MMU defines */
>>   #define ASCE_ORIGIN           (~0xfffULL) /* segment table 
>> origin             */
>>   #define ASCE_SUBSPACE         0x200       /* subspace group 
>> control           */
>> diff --git a/target/s390x/kvm/cpu_topology.c 
>> b/target/s390x/kvm/cpu_topology.c
>> new file mode 100644
>> index 0000000000..3831a3264c
>> --- /dev/null
>> +++ b/target/s390x/kvm/cpu_topology.c
>> @@ -0,0 +1,136 @@
>> +/*
>> + * QEMU S390x CPU Topology
>> + *
>> + * Copyright IBM Corp. 2022
> 
> Happy new year?

So after Nina's comment what do I do?
let it be 22 because I started last year or update because what is 
important is when it comes into mainline?

> 
>> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or 
>> (at
>> + * your option) any later version. See the COPYING file in the top-level
>> + * directory.
>> + */
>> +#include "qemu/osdep.h"
>> +#include "cpu.h"
>> +#include "hw/s390x/pv.h"
>> +#include "hw/sysbus.h"
>> +#include "hw/s390x/sclp.h"
>> +#include "hw/s390x/cpu-topology.h"
>> +
>> +static char *fill_container(char *p, int level, int id)
>> +{
>> +    SysIBTl_container *tle = (SysIBTl_container *)p;
>> +
>> +    tle->nl = level;
>> +    tle->id = id;
>> +    return p + sizeof(*tle);
>> +}
>> +
>> +static char *fill_tle_cpu(char *p, S390TopologyEntry *entry)
>> +{
>> +    SysIBTl_cpu *tle = (SysIBTl_cpu *)p;
>> +    s390_topology_id topology_id = entry->id;
> 
> What about the reserved fields? Should they get set to 0 ?

Good question.
I forgot this after changing the allocation.
It must be 0.
I will do that during the allocation.

> 
>> +    tle->nl = 0;
>> +    tle->dedicated = topology_id.d;
>> +    tle->polarity = topology_id.p;
>> +    tle->type = topology_id.type;
>> +    tle->origin = topology_id.origin;
>> +    tle->mask = cpu_to_be64(entry->mask);
> 
> So here you're already taking care of swapping the endianess in case we 
> ever run this code with TCG, too ... so I think it would be great to 
> also eliminate the bitfield in SysIBTl_cpu to be really on the safe side.

OK.

> 
>> +    return p + sizeof(*tle);
>> +}
> ...
>> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
>> +{
>> +    union {
>> +        char place_holder[S390_TOPOLOGY_SYSIB_SIZE];
>> +        SysIB_151x sysib;
>> +    } buffer QEMU_ALIGNED(8) = {};
>> +    int len;
>> +
>> +    if (!s390_has_topology() || sel2 < 2 || sel2 > 
>> SCLP_READ_SCP_INFO_MNEST) {
>> +        setcc(cpu, 3);
>> +        return;
>> +    }
>> +
>> +    len = setup_stsi(cpu, &buffer.sysib, sel2);
>> +
>> +    if (len > 4096) {
> 
> Maybe use TARGET_PAGE_SIZE instead of 4096 ?

I am not sure about this, even TARGET_PAGE_SIZE will probably never 
change, this is the maximal SYSIB size, probably related to page size but...
What about defining it in the cpu.h as

#define SYSIB_MAX_SIZE TARGET_PAGE_SIZE

?

> 
>> +        setcc(cpu, 3);
>> +        return;
>> +    }
>> +
>> +    buffer.sysib.length = cpu_to_be16(len);
>> +    s390_cpu_virt_mem_write(cpu, addr, ar, &buffer.sysib, len);
> 
> Is this supposed to work with protected guests, too? If so, I think you 
> likely need to use s390_cpu_pv_mem_write() for protected guests?

it is not supposed to work with protected guests.

Thanks.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F382D6F185A
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346087AbjD1Mnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346013AbjD1Mng (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:43:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B1A10CF
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:43:11 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33SCe6kB030161;
        Fri, 28 Apr 2023 12:42:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZNnZOlTp/BlAQkVwTgwLSrOWvwaehBqBiD0kbYyoDBE=;
 b=dEnvR9skf9wL8we2yQUd7vEvwac9eBX63ageW1Mqa6TD0a8kSCgrlknBvBo+3wQAPbgP
 kzMc+g9dd4o7GMkaKkCK9uVgrBlgnE0OBsWRd4b3hLJyFyFUBpcSJ2KQ2PQJCuMXcbqh
 wNm4k6yUrqfdrab8maso7yXfVsoRZTvl3isbxae/9EEwMIou/qawFyWhUHqa56PIU2Vu
 DzbfVpdr8Q3rEj/ea3pXwlh6OKd05SaQyOrvk37hiG+8/ZzMNnRYH63aGoIOJB/ZWXQf
 LED+XM/hJCnngNZITbZlY18sj/YhwLTQh6xxRM71vXLAayVepW8GyL9jpKFO0Lf8/RcK VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q8c9jbmcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 12:42:57 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33SCeAsB031409;
        Fri, 28 Apr 2023 12:42:57 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q8c9jbm87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 12:42:57 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33S0bkBV028416;
        Fri, 28 Apr 2023 12:42:53 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3q46ug3j7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 12:42:53 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33SCgjYQ30802564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Apr 2023 12:42:46 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A7192004F;
        Fri, 28 Apr 2023 12:42:45 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B48120040;
        Fri, 28 Apr 2023 12:42:44 +0000 (GMT)
Received: from [9.171.23.33] (unknown [9.171.23.33])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 28 Apr 2023 12:42:44 +0000 (GMT)
Message-ID: <449ae7ff-d815-e863-1d53-c701ce6c0a18@linux.ibm.com>
Date:   Fri, 28 Apr 2023 14:42:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v20 03/21] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
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
 <20230425161456.21031-4-pmorel@linux.ibm.com>
 <7ce19a3d-7b5a-1449-10c2-ee63c1471537@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <7ce19a3d-7b5a-1449-10c2-ee63c1471537@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CXZ-QhYHHpYvzqGw0eD_p-z-iwymKmrb
X-Proofpoint-ORIG-GUID: -RF54hGtHKZqSCQD3iiCsRykKgnHTsFL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-28_04,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304280102
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/27/23 19:01, Thomas Huth wrote:
> On 25/04/2023 18.14, Pierre Morel wrote:
>> On interception of STSI(15.1.x) the System Information Block
>> (SYSIB) is built from the list of pre-ordered topology entries.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   MAINTAINERS                     |   1 +
>>   include/hw/s390x/cpu-topology.h |  24 +++
>>   include/hw/s390x/sclp.h         |   1 +
>>   target/s390x/cpu.h              |  72 ++++++++
>>   hw/s390x/cpu-topology.c         |  13 +-
>>   target/s390x/kvm/cpu_topology.c | 308 ++++++++++++++++++++++++++++++++
>>   target/s390x/kvm/kvm.c          |   5 +-
>>   target/s390x/kvm/meson.build    |   3 +-
>>   8 files changed, 424 insertions(+), 3 deletions(-)
>>   create mode 100644 target/s390x/kvm/cpu_topology.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index bb7b34d0d8..de9052f753 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1659,6 +1659,7 @@ M: Pierre Morel <pmorel@linux.ibm.com>
>>   S: Supported
>>   F: include/hw/s390x/cpu-topology.h
>>   F: hw/s390x/cpu-topology.c
>> +F: target/s390x/kvm/cpu_topology.c
>
> It's somewhat weird to have one file "cpu-topology.c" (in hw/s390x, 
> with a dash), and one file cpu_topology.c (in target/s390x, with an 
> underscore) ... could you come up with a better naming? Maybe call the 
> new file stsi-topology.c or so?


If I keep the two files (see answer to your comments on patch 2) then 
yes I can change it to stsi-topology.c,


>
>> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
>> index bb7cfb0cab..9f97989bd7 100644
>> --- a/target/s390x/cpu.h
>> +++ b/target/s390x/cpu.h
>> @@ -561,6 +561,25 @@ typedef struct SysIB_322 {
>>   } SysIB_322;
>>   QEMU_BUILD_BUG_ON(sizeof(SysIB_322) != 4096);
>
>
> Maybe add a short comment here what MAG stands for (magnitude fields?)?


Yes, in fact Magnitude bytes.


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
>> +} SysIB_151x;
>> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
> ...
>
>> diff --git a/target/s390x/kvm/cpu_topology.c 
>> b/target/s390x/kvm/cpu_topology.c
>> new file mode 100644
>> index 0000000000..86a286afe2
>> --- /dev/null
>> +++ b/target/s390x/kvm/cpu_topology.c
>> @@ -0,0 +1,308 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +/*
>> + * QEMU S390x CPU Topology
>> + *
>> + * Copyright IBM Corp. 2022,2023
>> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + */
>> +#include "qemu/osdep.h"
>> +#include "cpu.h"
>> +#include "hw/s390x/pv.h"
>> +#include "hw/sysbus.h"
>> +#include "hw/s390x/sclp.h"
>> +#include "hw/s390x/cpu-topology.h"
>> +
>> +/**
>> + * fill_container:
>> + * @p: The address of the container TLE to fill
>> + * @level: The level of nesting for this container
>> + * @id: The container receives a uniq ID inside its own container
>
> s/uniq/unique/


yes, thanks,

regards,

Pierre


>
>  Thomas
>

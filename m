Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36A0533823
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 10:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbiEYIQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 04:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237315AbiEYIO7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 04:14:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B05885EFF
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 01:14:56 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24P6LQGQ005426;
        Wed, 25 May 2022 08:14:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uEBYO+e60+IFOnmJXz37vIP5yYWYTXwOrvlfEPQzNas=;
 b=QAbDTyB7+YIwPjm4g+x4EaMyz0FlyMspL+etdChECU+w5BMY9SqjQeVcwami846tif43
 uiDhzbcnxKQdGo3x0Qy4ERgQoOTVhxGY1D9QMc1R3hFwUT211bczNvr9W2okffGmxVyJ
 Bx5D97kYBPJCRIDQD+bhXevRp+694mHEz8JBopUWYZOzL4pREJh3KUYDtdZGwGYu9f39
 mIapO8c8pFTOJzS6AM1HuoCaZ1xiQQhTrYfKRRxttHy/e2kkElQAetCrSKr462jjryGw
 z7bUnH18LvQN6RWinL6VqLfu+TGO8WPyAl5ttorKO+f3BvvGINzi/BzKFcR0CO0ltKN3 Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9f45j5ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 08:14:51 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24P7uCTj000648;
        Wed, 25 May 2022 08:14:51 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9f45j5an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 08:14:51 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24P85g2C001309;
        Wed, 25 May 2022 08:14:49 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3g948n05ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 08:14:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24P8Ekh515401368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 08:14:46 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 302E0A404D;
        Wed, 25 May 2022 08:14:46 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 429AFA4051;
        Wed, 25 May 2022 08:14:45 +0000 (GMT)
Received: from [9.171.31.97] (unknown [9.171.31.97])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 May 2022 08:14:45 +0000 (GMT)
Message-ID: <3e3eccc1-cb74-671d-6c76-9b2fe75f7465@linux.ibm.com>
Date:   Wed, 25 May 2022 10:18:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v7 04/13] s390x: topology: implementating Store Topology
 System Information
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, philmd@redhat.com,
        eblake@redhat.com, armbru@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220420115745.13696-1-pmorel@linux.ibm.com>
 <20220420115745.13696-5-pmorel@linux.ibm.com>
 <3dba48f5-7e12-31b6-24b5-573956219020@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <3dba48f5-7e12-31b6-24b5-573956219020@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pDnvCLv_Awnu5QCqZZOHZydDIYvdZG7w
X-Proofpoint-ORIG-GUID: UzPhlr3lEFQu7QQ9AybBctvMcCJIyj-n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_02,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 priorityscore=1501 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250037
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/24/22 13:08, Thomas Huth wrote:
> On 20/04/2022 13.57, Pierre Morel wrote:
>> The handling of STSI is enhanced with the interception of the
>> function code 15 for storing CPU topology.
>>
>> Using the objects built during the pluging of CPU, we build the
> 
> s/pluging/plugging/
> 

Yes

>> SYSIB 15_1_x structures.
>>
>> With this patch the maximum MNEST level is 2, this is also
>> the only level allowed and only SYSIB 15_1_2 will be built.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
> ...
>> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
>> index f6969b76c5..a617c943ff 100644
>> --- a/target/s390x/cpu.h
>> +++ b/target/s390x/cpu.h
>> @@ -889,4 +889,5 @@ S390CPU *s390_cpu_addr2state(uint16_t cpu_addr);
>>   #include "exec/cpu-all.h"
>> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);
>>   #endif
> 
> Please keep an empty line before the #endif

OK

> 
>> diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
>> new file mode 100644
>> index 0000000000..7f6db18829
>> --- /dev/null
>> +++ b/target/s390x/cpu_topology.c
>> @@ -0,0 +1,112 @@
>> +/*
>> + * QEMU S390x CPU Topology
>> + *
>> + * Copyright IBM Corp. 2021
> 
> 2022 ?

Yes too

> 
>> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or 
>> (at
>> + * your option) any later version. See the COPYING file in the top-level
>> + * directory.
>> + */
> ...
>> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
>> +{
>> +    const MachineState *machine = MACHINE(qdev_get_machine());
>> +    void *p;
>> +    int ret, cc;
>> +
>> +    /*
>> +     * Until the SCLP STSI Facility reporting the MNEST value is used,
>> +     * a sel2 value of 2 is the only value allowed in STSI 15.1.x.
>> +     */
>> +    if (sel2 != 2) {
>> +        setcc(cpu, 3);
>> +        return;
>> +    }
>> +
>> +    p = g_malloc0(TARGET_PAGE_SIZE);
>> +
>> +    setup_stsi(machine, p, 2);
>> +
>> +    if (s390_is_pv()) {
>> +        ret = s390_cpu_pv_mem_write(cpu, 0, p, TARGET_PAGE_SIZE);
>> +    } else {
>> +        ret = s390_cpu_virt_mem_write(cpu, addr, ar, p, 
>> TARGET_PAGE_SIZE);
>> +    }
>> +    cc = ret ? 3 : 0;
>> +    setcc(cpu, cc);
> 
> Just a matter of taste (i.e. keep it if you like) - but you could 
> scratch the cc variable in this function by just doing:
> 
>      setcc(cpu, ret ? 3 : 0);
> 

OK, I will changes all occurences

Thanks,
Pierre

>> +    g_free(p);
>> +}
>> +
> 
>   Thomas
> 

-- 
Pierre Morel
IBM Lab Boeblingen

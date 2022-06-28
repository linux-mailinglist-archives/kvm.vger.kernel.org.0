Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4111E55D448
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344396AbiF1LEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 07:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbiF1LEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 07:04:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DED30F6A
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 04:04:06 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SAiQPD004324;
        Tue, 28 Jun 2022 11:03:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+hI+Ln1+sK3EHyoTSzMshw4CquGVQlSCc6p1CAZ/VSQ=;
 b=DHoLdiLDgODsw39QOt5bo9izxqlU2JHIpL7kR4DKVu3MJF5EcLL6/q6iwNBn0t5H+Hyo
 35A23Y89g6hAPbdu9AHEut2Iv8QZHp173uSMnt95ACSTlaMlOIaLhbpyksCj3osuQ7HJ
 qZpLgwk85q4L/mMs7/4kc1LT7yk7IjLRfyt6XEQ7Gv3N81c2BiHTYL7Us7w35D9mT72g
 wcuSjZ+TmwoLOOxRtY+zbB7DANhDzW4rEe6tcdUnPcvany4u9kxYkLO+y9mbsGtql9go
 aogUFVgwwD869VAodQu/PrXJ4p7KSuBxttuYbOBHAGa4gsUaAEsxo42pegswM/2cxpNY ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h005erehs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 11:03:43 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SAigZm005026;
        Tue, 28 Jun 2022 11:03:42 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h005eregd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 11:03:42 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SAphCE006181;
        Tue, 28 Jun 2022 11:03:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3gwt08ugen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 11:03:40 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SB3a8c24314276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 11:03:37 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6FADAE05D;
        Tue, 28 Jun 2022 11:03:36 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7DF0AE05A;
        Tue, 28 Jun 2022 11:03:35 +0000 (GMT)
Received: from [9.171.41.104] (unknown [9.171.41.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 11:03:35 +0000 (GMT)
Message-ID: <68b59638-cdbb-0b13-dbb9-19cd5b2d2456@linux.ibm.com>
Date:   Tue, 28 Jun 2022 13:08:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v8 02/12] s390x/cpu_topology: CPU topology objects and
 structures
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <20220620140352.39398-3-pmorel@linux.ibm.com>
 <35c562e1-cdcd-41ce-1957-bd35c72a78ca@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <35c562e1-cdcd-41ce-1957-bd35c72a78ca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1Wr3RZ86Je7_yNdXqStJjH_eRhyB3ILr
X-Proofpoint-GUID: HUmCL9VwOpm-96sXbH0LP6jtqeSR-u_J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/27/22 15:31, Janosch Frank wrote:
> On 6/20/22 16:03, Pierre Morel wrote:
>> We use new objects to have a dynamic administration of the CPU topology.
>> The highest level object in this implementation is the s390 book and
>> in this first implementation of CPU topology for S390 we have a single
>> book.
>> The book is built as a SYSBUS bridge during the CPU initialization.
>> Other objects, sockets and core will be built after the parsing
>> of the QEMU -smp argument.
>>
>> Every object under this single book will be build dynamically
>> immediately after a CPU has be realized if it is needed.
>> The CPU will fill the sockets once after the other, according to the
>> number of core per socket defined during the smp parsing.
>>
>> Each CPU inside a socket will be represented by a bit in a 64bit
>> unsigned long. Set on plug and clear on unplug of a CPU.
>>
>> For the S390 CPU topology, thread and cores are merged into
>> topology cores and the number of topology cores is the multiplication
>> of cores by the numbers of threads.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> [...]
> 
>> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
>> index 7d6d01325b..216adfde26 100644
>> --- a/target/s390x/cpu.h
>> +++ b/target/s390x/cpu.h
>> @@ -565,6 +565,53 @@ typedef union SysIB {
>>   } SysIB;
>>   QEMU_BUILD_BUG_ON(sizeof(SysIB) != 4096);
>> +/* CPU type Topology List Entry */
>> +typedef struct SysIBTl_cpu {
>> +        uint8_t nl;
>> +        uint8_t reserved0[3];
>> +        uint8_t reserved1:5;
>> +        uint8_t dedicated:1;
>> +        uint8_t polarity:2;
>> +        uint8_t type;
>> +        uint16_t origin;
>> +        uint64_t mask;
>> +} SysIBTl_cpu;
>> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) != 16);
>> +
>> +/* Container type Topology List Entry */
>> +typedef struct SysIBTl_container {
>> +        uint8_t nl;
>> +        uint8_t reserved[6];
>> +        uint8_t id;
>> +} QEMU_PACKED SysIBTl_container;
>> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
>> +
>> +/* Generic Topology List Entry */
>> +typedef union SysIBTl_entry {
>> +        uint8_t nl;
> 
> This union member is unused, isn't it?

Yes, forgot to remove it.
will do.

> 
>> +        SysIBTl_container container;
>> +        SysIBTl_cpu cpu;
>> +} SysIBTl_entry;
>> +
>> +#define TOPOLOGY_NR_MAG  6
> 
> TOPOLOGY_TOTAL_NR_MAGS ?

OK

> 
>> +#define TOPOLOGY_NR_MAG6 0
> 
> TOPOLOGY_NR_TLES_MAG6 ?
> 
> I'm open to other suggestions but we need to differentiate between the 
> number of mag array entries and the number of TLEs in the MAGs.

it is OK for me

> 
>> +#define TOPOLOGY_NR_MAG5 1
>> +#define TOPOLOGY_NR_MAG4 2
>> +#define TOPOLOGY_NR_MAG3 3
>> +#define TOPOLOGY_NR_MAG2 4
>> +#define TOPOLOGY_NR_MAG1 5
> 
> I'd appreciate a \n here.

ok

> 
>> +/* Configuration topology */
>> +typedef struct SysIB_151x {
>> +    uint8_t  res0[2];
> 
> You're using "reserved" everywhere but now it's "rev"?

ok, will used reserved overall

> 
>> +    uint16_t length;
>> +    uint8_t  mag[TOPOLOGY_NR_MAG];
>> +    uint8_t  res1;
>> +    uint8_t  mnest;
>> +    uint32_t res2;
>> +    SysIBTl_entry tle[0];
>> +} SysIB_151x;
>> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
>> +
>>   /* MMU defines */
>>   #define ASCE_ORIGIN           (~0xfffULL) /* segment table 
>> origin             */
>>   #define ASCE_SUBSPACE         0x200       /* subspace group 
>> control           */
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

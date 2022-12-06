Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBFB6445F3
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 15:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbiLFOpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 09:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbiLFOov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 09:44:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FD423BDC
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 06:44:50 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6E1HSV007692;
        Tue, 6 Dec 2022 14:44:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hkiAwFYu82HYYowy/8C4KkPzhZHc58Q028GKPby8d/4=;
 b=amy1I0Igubb9L74FwMD33Cy5cgbdu2v/BZFTTajt2kTOkQWZsJ1gVQZnSYOcfDRxCphU
 hmE0cQ6M/+U6/N1T1eHi2G88xbRZPH0IcGyxiotTyT5OqveckIkb/hDQN8mdemof7oXC
 QyCQCKqH6Qpcgeke2zW1rGg4vtA/LcL2AC3IMj+/4J7WECG49gghzPApybMYjxqXcIeN
 z/9TNaCARq32/NNxwpf6amAkwFcbbQkL3W8GnjY/m4Uh05I+0MW+APktDmUiQjc0kW5W
 PPjXiIYYhc+wZn6yn6eY2jKW/HzRNzJiJaUE30nGIcjh07GECWtLvW9q1bDaGf1wm864 hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ma58bvpta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 14:44:32 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6Dvha3021240;
        Tue, 6 Dec 2022 14:44:32 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ma58bvpsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 14:44:31 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B69KsKP010516;
        Tue, 6 Dec 2022 14:44:29 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3m9ks41js3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 14:44:29 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B6EiQwY41877970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Dec 2022 14:44:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F103220043;
        Tue,  6 Dec 2022 14:44:25 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B36B820040;
        Tue,  6 Dec 2022 14:44:24 +0000 (GMT)
Received: from [9.171.52.4] (unknown [9.171.52.4])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  6 Dec 2022 14:44:24 +0000 (GMT)
Message-ID: <8c6ae27d-ac83-505f-cf2f-df30c3612e6f@linux.ibm.com>
Date:   Tue, 6 Dec 2022 15:44:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v12 2/7] s390x/cpu topology: reporting the CPU topology to
 the guest
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
 <20221129174206.84882-3-pmorel@linux.ibm.com>
In-Reply-To: <20221129174206.84882-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: i390X9lwAQ9lUpyFQzLZTFP3SjaUg18f
X-Proofpoint-GUID: MIawOmPFpS7vnDfp5-JOFHci7QS39tq-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_10,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 clxscore=1015 phishscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212060115
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/29/22 18:42, Pierre Morel wrote:
> The guest uses the STSI instruction to get information on the
> CPU topology.
> 
> Let us implement the STSI instruction for the basis CPU topology
> level, level 2.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   target/s390x/cpu.h          |  77 +++++++++++++++
>   hw/s390x/s390-virtio-ccw.c  |  12 +--
>   target/s390x/cpu_topology.c | 186 ++++++++++++++++++++++++++++++++++++
>   target/s390x/kvm/kvm.c      |   6 +-
>   target/s390x/meson.build    |   1 +
>   5 files changed, 274 insertions(+), 8 deletions(-)
>   create mode 100644 target/s390x/cpu_topology.c
> 

> + */
> +static void s390_topology_add_cpu(S390Topology *topo, S390CPU *cpu)
> +{
> +    int core_id = cpu->env.core_id;
> +    int bit, origin;
> +    int socket_id;
> +
> +    cpu->machine_data = topo;

Sorry this wrong machine_data is already used as a pointer to the 
S390CcwMachineState machine.



> +    socket_id = core_id / topo->num_cores;
> +    /*

...snip...

> +
> +static int setup_stsi(S390CPU *cpu, SysIB_151x *sysib, int level)
> +{
> +    S390Topology *topo = (S390Topology *)cpu->machine_data;

Sorry, wrong too this must be:

     S390CcwMachineState *s390ms = cpu->machine_data;
     S390Topology *topo = S390_CPU_TOPOLOGY(s390ms->topology);

> +    char *p = sysib->tle;
> +
> +    sysib->mnest = level;
> +    switch (level) {
> +    case 2:
> +        sysib->mag[S390_TOPOLOGY_MAG2] = topo->num_sockets;
> +        sysib->mag[S390_TOPOLOGY_MAG1] = topo->num_cores;
> +        p = s390_top_set_level2(topo, p);
> +        break;
> +    }
> +
> +    return p - (char *)sysib;
> +}
> +


Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

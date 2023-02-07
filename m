Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA7668DC5A
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 16:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjBGPAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 10:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjBGPAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 10:00:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFB31285F
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 07:00:13 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 317EjmRk038928;
        Tue, 7 Feb 2023 15:00:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=v/t0flEagDJCq9Pa20hlESeV4DrVsJ5H6lNgrqRW2vk=;
 b=OuYu2zMskpI/V8sSH8y1BoXlCVBZAkkyeMkmxrPr0gDdjSDtQfqrCULrmnYysJGDx4Wr
 mNAg2wI0QPxggTgWli0YJ8xJTviv7jtr7sfcIpTngEf5Q0lWA1pA1l6AcLFCItxxdLCi
 M4SwnVAK1QI6MzknooWNI1OrD0hLWMFonlAwmFk31yvTJX5m7psNb0gv6gZu2hTSkClL
 muWfT8m1RmY1GpE4c732AdeA8HMAc0MtkUKZcrIpYoo29qDuZ1M8/SkpOpgOsd6PccLw
 s0xb2+DBFc4USeis5WF6Ec4SJhgNZiUygZyzDGTmhIAOFpYgLLSdp6Ma3yE2Nqs3GyXJ iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nkrpp0d4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 15:00:05 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 317EjpKU039690;
        Tue, 7 Feb 2023 15:00:05 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nkrpp0d28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 15:00:05 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3171E4WE016060;
        Tue, 7 Feb 2023 15:00:02 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3nhf06jn09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 15:00:02 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 317ExwbX26346176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Feb 2023 14:59:58 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 915F92004F;
        Tue,  7 Feb 2023 14:59:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44BC520040;
        Tue,  7 Feb 2023 14:59:58 +0000 (GMT)
Received: from [9.152.224.241] (unknown [9.152.224.241])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  7 Feb 2023 14:59:58 +0000 (GMT)
Message-ID: <93ffcaaf-92de-634f-f711-d0d7c8a1914a@linux.ibm.com>
Date:   Tue, 7 Feb 2023 15:59:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v15 08/11] qapi/s390x/cpu topology: x-set-cpu-topology
 monitor command
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-9-pmorel@linux.ibm.com>
In-Reply-To: <20230201132051.126868-9-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XVxRNYmBVO4skG6EdXzePIp8FVZRMFh_
X-Proofpoint-GUID: bIRh5q-1ILjFIZFuvHCymu3cwsiIUtiW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_06,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 impostorscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302070130
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/1/23 14:20, Pierre Morel wrote:
> The modification of the CPU attributes are done through a monitor
> command.
> 
> It allows to move the core inside the topology tree to optimise
> the cache usage in the case the host's hypervisor previously
> moved the CPU.
> 
> The same command allows to modify the CPU attributes modifiers
> like polarization entitlement and the dedicated attribute to notify
> the guest if the host admin modified scheduling or dedication of a vCPU.
> 
> With this knowledge the guest has the possibility to optimize the
> usage of the vCPUs.
> 
> The command is made experimental for the moment.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   qapi/machine-target.json | 29 +++++++++++++
>   include/monitor/hmp.h    |  1 +
>   hw/s390x/cpu-topology.c  | 88 ++++++++++++++++++++++++++++++++++++++++
>   hmp-commands.hx          | 16 ++++++++
>   4 files changed, 134 insertions(+)
> 
> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index 2e267fa458..58df0f5061 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -342,3 +342,32 @@
>                      'TARGET_S390X',
>                      'TARGET_MIPS',
>                      'TARGET_LOONGARCH64' ] } }
> +
> +##
> +# @x-set-cpu-topology:
> +#
> +# @core: the vCPU ID to be moved
> +# @socket: the destination socket where to move the vCPU
> +# @book: the destination book where to move the vCPU
> +# @drawer: the destination drawer where to move the vCPU
> +# @polarity: optional polarity, default is last polarity set by the guest
> +# @dedicated: optional, if the vCPU is dedicated to a real CPU
> +#
> +# Modifies the topology by moving the CPU inside the topology
> +# tree or by changing a modifier attribute of a CPU.
> +#
> +# Returns: Nothing on success, the reason on failure.
> +#
> +# Since: <next qemu stable release, eg. 1.0>
> +##
> +{ 'command': 'x-set-cpu-topology',
> +  'data': {
> +      'core': 'int',
> +      'socket': 'int',
> +      'book': 'int',
> +      'drawer': 'int',
> +      '*polarity': 'int',
> +      '*dedicated': 'bool'
> +  },
> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
> +}
> diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
> index 1b3bdcb446..12827479cf 100644
> --- a/include/monitor/hmp.h
> +++ b/include/monitor/hmp.h
> @@ -151,5 +151,6 @@ void hmp_human_readable_text_helper(Monitor *mon,
>                                       HumanReadableText *(*qmp_handler)(Error **));
>   void hmp_info_stats(Monitor *mon, const QDict *qdict);
>   void hmp_pcie_aer_inject_error(Monitor *mon, const QDict *qdict);
> +void hmp_x_set_cpu_topology(Monitor *mon, const QDict *qdict);
>   
>   #endif
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index c33378577b..6c50050991 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -18,6 +18,10 @@
>   #include "target/s390x/cpu.h"
>   #include "hw/s390x/s390-virtio-ccw.h"
>   #include "hw/s390x/cpu-topology.h"
> +#include "qapi/qapi-commands-machine-target.h"
> +#include "qapi/qmp/qdict.h"
> +#include "monitor/hmp.h"
> +#include "monitor/monitor.h"
>   
>   /*
>    * s390_topology is used to keep the topology information.
> @@ -379,3 +383,87 @@ void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
>       /* topology tree is reflected in props */
>       s390_update_cpu_props(ms, cpu);
>   }
> +
> +/*
> + * qmp and hmp implementations
> + */
> +
> +static void s390_change_topology(int64_t core_id, int64_t socket_id,
> +                                 int64_t book_id, int64_t drawer_id,
> +                                 int64_t polarity, bool dedicated,
> +                                 Error **errp)
> +{
> +    MachineState *ms = current_machine;
> +    S390CPU *cpu;
> +    ERRP_GUARD();
> +
> +    cpu = (S390CPU *)ms->possible_cpus->cpus[core_id].cpu;
> +    if (!cpu) {
> +        error_setg(errp, "Core-id %ld does not exist!", core_id);
> +        return;
> +    }
> +
> +    /* Verify the new topology */

!! Should verify the new topology but ...


> +    s390_topology_check(cpu, errp);

... verifies the old one => I will have to change this.

Sorry, this will impact the patch 2 because I think I should modify the 
s390_topology_check() function to take as arguments the individual 
attributes.

Like:

static void s390_topology_check( uint16_t core_id, uint16_t socket_id,
                                  uint16_t book_id, uint16_t drawer_id,
                                  uint16_t entitlement, bool dedicated,
                                  Error **errp)



Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2DF64B621
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 14:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbiLMN06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 08:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiLMN0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 08:26:33 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9708818388
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 05:26:32 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDD61j9019150;
        Tue, 13 Dec 2022 13:26:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TRJ2c9s8pXGPI66AxrgS9kPc5t22c58iHP/gOZRHrGs=;
 b=haq+iZQUQRncaB4YOeADFCCfwrL3rcVFRvgog3qVDBnoAnlfk42nCq9rak+vCYiCNxHk
 u0gAA4n0Y8HqEw/7l2aKyBAQPQpp4921UzXZ5u+B5JoxhDijBaVClaMITimarFLE2IkW
 /oB42Q/ql4EYIHnEWQlVkqQn/g9BhGpI0L4lWsG16/Skk1GPBRE9bkyMXvmi/UKl2mcw
 GG8qF6h0mXANiFHGHpQyk6snnPnI7jjV+/kjY09KDCanuw1HxTM8jEfOrWUrdl+hKgn8
 GPym81fnYMDoLmNWwI1gib3ulCnky1aKaXF78IIN8EtwG/mz8MT//85oe9mp2dZVeq62 ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3merajjvup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 13:26:16 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDD7cGu029929;
        Tue, 13 Dec 2022 13:26:16 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3merajjvtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 13:26:15 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD4pN8P030148;
        Tue, 13 Dec 2022 13:26:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mchr5v7h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 13:26:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDDQAF646137704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 13:26:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB6EA20043;
        Tue, 13 Dec 2022 13:26:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B801220040;
        Tue, 13 Dec 2022 13:26:08 +0000 (GMT)
Received: from [9.171.21.177] (unknown [9.171.21.177])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 13:26:08 +0000 (GMT)
Message-ID: <65b704e7-ee3a-c9de-45fa-b59c9731cb54@de.ibm.com>
Date:   Tue, 13 Dec 2022 14:26:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v13 4/7] s390x/cpu_topology: CPU topology migration
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
 <20221208094432.9732-5-pmorel@linux.ibm.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20221208094432.9732-5-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ENXuVkDBKE9Ql8-kB-yPUGMGbHDGNRQE
X-Proofpoint-GUID: vxD7194ltoFDMgtGGzvZuDr-inm8PxLe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 clxscore=1011 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212130115
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 08.12.22 um 10:44 schrieb Pierre Morel:
> The migration can only take place if both source and destination
> of the migration both use or both do not use the CPU topology
> facility.
> 
> We indicate a change in topology during migration postload for the
> case the topology changed between source and destination.

I dont get why we need this? If the target QEMU has topology it should
already create this according to the configuration. WHy do we need a
trigger?

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   target/s390x/cpu.h        |  1 +
>   hw/s390x/cpu-topology.c   | 49 +++++++++++++++++++++++++++++++++++++++
>   target/s390x/cpu-sysemu.c |  8 +++++++
>   3 files changed, 58 insertions(+)
> 
> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index bc1a7de932..284c708a6c 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h
> @@ -854,6 +854,7 @@ void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg);
>   int s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch_id,
>                                   int vq, bool assign);
>   void s390_cpu_topology_reset(void);
> +int s390_cpu_topology_mtcr_set(void);
>   #ifndef CONFIG_USER_ONLY
>   unsigned int s390_cpu_set_state(uint8_t cpu_state, S390CPU *cpu);
>   #else
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index f54afcf550..8a2fe041d4 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -18,6 +18,7 @@
>   #include "target/s390x/cpu.h"
>   #include "hw/s390x/s390-virtio-ccw.h"
>   #include "hw/s390x/cpu-topology.h"
> +#include "migration/vmstate.h"
>   
>   /**
>    * s390_has_topology
> @@ -129,6 +130,53 @@ static void s390_topology_reset(DeviceState *dev)
>       s390_cpu_topology_reset();
>   }
>   
> +/**
> + * cpu_topology_postload
> + * @opaque: a pointer to the S390Topology
> + * @version_id: version identifier
> + *
> + * We check that the topology is used or is not used
> + * on both side identically.
> + *
> + * If the topology is in use we set the Modified Topology Change Report
> + * on the destination host.
> + */
> +static int cpu_topology_postload(void *opaque, int version_id)
> +{
> +    int ret;
> +
> +    /* We do not support CPU Topology, all is good */
> +    if (!s390_has_topology()) {
> +        return 0;
> +    }
> +
> +    /* We support CPU Topology, set the MTCR unconditionally */
> +    ret = s390_cpu_topology_mtcr_set();
> +    if (ret) {
> +        error_report("Failed to set MTCR: %s", strerror(-ret));
> +    }
> +    return ret;
> +}
> +
> +/**
> + * cpu_topology_needed:
> + * @opaque: The pointer to the S390Topology
> + *
> + * We always need to know if source and destination use the topology.
> + */
> +static bool cpu_topology_needed(void *opaque)
> +{
> +    return s390_has_topology();
> +}
> +
> +const VMStateDescription vmstate_cpu_topology = {
> +    .name = "cpu_topology",
> +    .version_id = 1,
> +    .post_load = cpu_topology_postload,
> +    .minimum_version_id = 1,
> +    .needed = cpu_topology_needed,
> +};
> +
>   /**
>    * topology_class_init:
>    * @oc: Object class
> @@ -145,6 +193,7 @@ static void topology_class_init(ObjectClass *oc, void *data)
>       device_class_set_props(dc, s390_topology_properties);
>       set_bit(DEVICE_CATEGORY_MISC, dc->categories);
>       dc->reset = s390_topology_reset;
> +    dc->vmsd = &vmstate_cpu_topology;
>   }
>   
>   static const TypeInfo cpu_topology_info = {
> diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
> index e27864c5f5..a8e3e6219d 100644
> --- a/target/s390x/cpu-sysemu.c
> +++ b/target/s390x/cpu-sysemu.c
> @@ -319,3 +319,11 @@ void s390_cpu_topology_reset(void)
>           }
>       }
>   }
> +
> +int s390_cpu_topology_mtcr_set(void)
> +{
> +    if (kvm_enabled()) {
> +        return kvm_s390_topology_set_mtcr(1);
> +    }
> +    return -ENOENT;
> +}

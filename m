Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D33C5AE6E0
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 13:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbiIFLtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 07:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiIFLtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 07:49:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40454E089
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 04:49:43 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 286AkT87020342;
        Tue, 6 Sep 2022 11:49:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Gy2Cab+a5r0gkMrM2JJ5gAKISUTpycmGsQ4quQuVh+g=;
 b=D2hcb6TW6k+nEqzfbAWxN4mKEZ9clkWS5cP2Cjlkkk3QxLJowIwm0VYOZ+wViL8SbNgu
 zIC6cxKtkn94BTQPI9hkWSz36Pamk8usBbt9CROddSZzgekNRGmZ5ZykN3mpQ80a52+0
 JpqIgXJcqyaj5gLyHnDp5/BVWu9BGwEtkO+/l5ZwBFbgKmeGBi8xeHlhrvzR69Z7rMBu
 mlrTeB/y/NwpByiNsdgR0aBT+ytDBCCuiN9GeWuQUWvl7zo2N97K/O7qtJUvGQwgi8Ku
 slLveDEYa7yxlNVtInoouO+YoMD6VffOBKQa6Qo7Nu/xuJkUxb/nXKBVQ6FBHDP/CZFT 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3je4r6hvdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 11:49:34 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 286BbxCc022217;
        Tue, 6 Sep 2022 11:49:33 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3je4r6hvd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 11:49:33 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 286BaD4e011107;
        Tue, 6 Sep 2022 11:49:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3jbxj8uqe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 11:49:31 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 286BnS5X35651918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Sep 2022 11:49:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8735242042;
        Tue,  6 Sep 2022 11:49:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C869B42041;
        Tue,  6 Sep 2022 11:49:27 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.59.224])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Sep 2022 11:49:27 +0000 (GMT)
Message-ID: <e2e5e8dc27ee12981c6df4e5f6b208362bd3671a.camel@linux.ibm.com>
Subject: Re: [PATCH v9 03/10] s390x/cpu topology: reporting the CPU topology
 to the guest
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Date:   Tue, 06 Sep 2022 13:49:27 +0200
In-Reply-To: <20220902075531.188916-4-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
         <20220902075531.188916-4-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ciBaJbb8USuW_s7Ma5Wf1EZVaXaab7i_
X-Proofpoint-GUID: ZXLNsx56aReAS-JMXP9Of-dnqR_qCR8f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_05,2022-09-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 spamscore=0 phishscore=0 clxscore=1011
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2209060055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-09-02 at 09:55 +0200, Pierre Morel wrote:
> The guest can use the STSI instruction to get a buffer filled
> with the CPU topology description.
> 
> Let us implement the STSI instruction for the basis CPU topology
> level, level 2.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  hw/s390x/cpu-topology.c         |   4 ++
>  include/hw/s390x/cpu-topology.h |   5 ++
>  target/s390x/cpu.h              |  49 +++++++++++++++
>  target/s390x/cpu_topology.c     | 108 ++++++++++++++++++++++++++++++++
>  target/s390x/kvm/kvm.c          |   6 +-
>  target/s390x/meson.build        |   1 +
>  6 files changed, 172 insertions(+), 1 deletion(-)
>  create mode 100644 target/s390x/cpu_topology.c
> 
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index a6ca006ec5..e2fd5c7e44 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -76,9 +76,11 @@ void s390_topology_new_cpu(int core_id)
>       * in the CPU container allows to represent up to the maximal number of
>       * CPU inside several CPU containers inside the socket container.
>       */
> +    qemu_mutex_lock(&topo->topo_mutex);

You could use a reader writer lock for this, if qemu has that (I didn't
find any tho).

>      topo->socket[socket_id].active_count++;
>      topo->tle[socket_id].active_count++;
>      set_bit(bit, &topo->tle[socket_id].mask[origin]);
> +    qemu_mutex_unlock(&topo->topo_mutex);
>  }
>  
>  /**
> @@ -104,6 +106,8 @@ static void s390_topology_realize(DeviceState *dev, Error **errp)
>      n = topo->sockets;
>      topo->socket = g_malloc0(n * sizeof(S390TopoContainer));
>      topo->tle = g_malloc0(topo->tles * sizeof(S390TopoTLE));
> +
> +    qemu_mutex_init(&topo->topo_mutex);
>  }
>  
>  /**
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> index 6911f975f4..0b7f3d10b2 100644
> --- a/include/hw/s390x/cpu-topology.h
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -10,6 +10,10 @@
>  #ifndef HW_S390X_CPU_TOPOLOGY_H
>  #define HW_S390X_CPU_TOPOLOGY_H
>  
> +#define S390_TOPOLOGY_CPU_TYPE    0x03

IMO you should add the name of cpu type 0x03 to the name of the
constant, even if there is only one right now.
You did the same for the polarity after all.

> +
> +#define S390_TOPOLOGY_POLARITY_H  0x00
> +
>  typedef struct S390TopoContainer {
>      int active_count;
>  } S390TopoContainer;
> @@ -30,6 +34,7 @@ struct S390Topology {
>      int tles;
>      S390TopoContainer *socket;
>      S390TopoTLE *tle;
> +    QemuMutex topo_mutex;
>  };
>  typedef struct S390Topology S390Topology;
>  
> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index 7d6d01325b..c61fe9b563 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h
> @@ -565,6 +565,53 @@ typedef union SysIB {
>  } SysIB;
>  QEMU_BUILD_BUG_ON(sizeof(SysIB) != 4096);
>  
> +/* CPU type Topology List Entry */
> +typedef struct SysIBTl_cpu {
> +        uint8_t nl;
> +        uint8_t reserved0[3];
> +        uint8_t reserved1:5;
> +        uint8_t dedicated:1;
> +        uint8_t polarity:2;
> +        uint8_t type;
> +        uint16_t origin;
> +        uint64_t mask;
> +} SysIBTl_cpu;
> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) != 16);
> +
> +/* Container type Topology List Entry */
> +typedef struct SysIBTl_container {
> +        uint8_t nl;
> +        uint8_t reserved[6];
> +        uint8_t id;
> +} QEMU_PACKED SysIBTl_container;
> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
> +
> +/* Generic Topology List Entry */
> +typedef union SysIBTl_entry {
> +        uint8_t nl;
> +        SysIBTl_container container;
> +        SysIBTl_cpu cpu;
> +} SysIBTl_entry;

This isn't used for anything but the declaration in SysIB_151x, is it?
> +
> +#define TOPOLOGY_NR_MAG  6
> +#define TOPOLOGY_NR_MAG6 0
> +#define TOPOLOGY_NR_MAG5 1
> +#define TOPOLOGY_NR_MAG4 2
> +#define TOPOLOGY_NR_MAG3 3
> +#define TOPOLOGY_NR_MAG2 4
> +#define TOPOLOGY_NR_MAG1 5
> +/* Configuration topology */
> +typedef struct SysIB_151x {
> +    uint8_t  reserved0[2];
> +    uint16_t length;
> +    uint8_t  mag[TOPOLOGY_NR_MAG];
> +    uint8_t  reserved1;
> +    uint8_t  mnest;
> +    uint32_t reserved2;
> +    SysIBTl_entry tle[0];

I would just use uint64_t[0] as type or uint64_t[] whichever is qemu
style.

> +} SysIB_151x;
> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
> +
>  /* MMU defines */
>  #define ASCE_ORIGIN           (~0xfffULL) /* segment table origin             */
>  #define ASCE_SUBSPACE         0x200       /* subspace group control           */
> @@ -843,4 +890,6 @@ S390CPU *s390_cpu_addr2state(uint16_t cpu_addr);
>  
>  #include "exec/cpu-all.h"
>  
> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);
> +
>  #endif
> diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
> new file mode 100644
> index 0000000000..56865dafc6
> --- /dev/null
> +++ b/target/s390x/cpu_topology.c
> @@ -0,0 +1,108 @@
> +/*
> + * QEMU S390x CPU Topology
> + *
> + * Copyright IBM Corp. 2022
> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +#include "qemu/osdep.h"
> +#include "cpu.h"
> +#include "hw/s390x/pv.h"
> +#include "hw/sysbus.h"
> +#include "hw/s390x/cpu-topology.h"
> +#include "hw/s390x/sclp.h"
> +
> +static char *fill_container(char *p, int level, int id)
> +{
> +    SysIBTl_container *tle = (SysIBTl_container *)p;
> +
> +    tle->nl = level;
> +    tle->id = id;
> +    return p + sizeof(*tle);
> +}
> +
> +static char *fill_tle_cpu(char *p, uint64_t mask, int origin)
> +{
> +    SysIBTl_cpu *tle = (SysIBTl_cpu *)p;
> +
> +    tle->nl = 0;
> +    tle->dedicated = 1;
> +    tle->polarity = S390_TOPOLOGY_POLARITY_H;
> +    tle->type = S390_TOPOLOGY_CPU_TYPE;
> +    tle->origin = origin * 64;
> +    tle->mask = be64_to_cpu(mask);

You convert endianess for mask here...

> +    return p + sizeof(*tle);
> +}
> +
> +static char *s390_top_set_level2(S390Topology *topo, char *p)
> +{
> +    int i, origin;
> +
> +    for (i = 0; i < topo->sockets; i++) {
> +        if (!topo->socket[i].active_count) {
> +            continue;
> +        }
> +        p = fill_container(p, 1, i);
> +        for (origin = 0; origin < S390_TOPOLOGY_MAX_ORIGIN; origin++) {
> +            uint64_t mask = 0L;
> +
> +            mask = be64_to_cpu(topo->tle[i].mask[origin]);

...and here. So one has to go, I guess this one.
Also using cpu_to_be64 seems more intuitive to me.

> +            if (mask) {
> +                p = fill_tle_cpu(p, mask, origin);
> +            }
> +        }
> +    }
> +    return p;
> +}
> +
> +static int setup_stsi(SysIB_151x *sysib, int level)
> +{
> +    S390Topology *topo = s390_get_topology();
> +    char *p = (char *)sysib->tle;
> +
> +    qemu_mutex_lock(&topo->topo_mutex);
> +
> +    sysib->mnest = level;
> +    switch (level) {
> +    case 2:
> +        sysib->mag[TOPOLOGY_NR_MAG2] = topo->sockets;
> +        sysib->mag[TOPOLOGY_NR_MAG1] = topo->cores;
> +        p = s390_top_set_level2(topo, p);
> +        break;
> +    }
> +
> +    qemu_mutex_unlock(&topo->topo_mutex);
> +
> +    return p - (char *)sysib->tle;
> +}
> +
> +#define S390_TOPOLOGY_MAX_MNEST 2
> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
> +{
> +    SysIB_151x *sysib;
> +    int len = sizeof(*sysib);
> +
> +    if (s390_is_pv() || sel2 < 2 || sel2 > S390_TOPOLOGY_MAX_MNEST) {
> +        setcc(cpu, 3);
> +        return;
> +    }
> +
> +    sysib = g_malloc0(TARGET_PAGE_SIZE);

What made you decide against stack allocating this?

> +
> +    len += setup_stsi(sysib, sel2);
> +    if (len > TARGET_PAGE_SIZE) {

If you do the check here it's too late.

> +        setcc(cpu, 3);
> +        goto out_free;
> +    }
> +
> +    sysib->length = be16_to_cpu(len);
> +    s390_cpu_virt_mem_write(cpu, addr, ar, sysib, len);

If the return value of this is <0 it's an error condition.
If you ignore the value we'll keep running.

> +    setcc(cpu, 0);

Is it correct to set the cc value even if s390_cpu_virt_mem_write
causes an exception?
> +
> +out_free:
> +    g_free(sysib);
> +}
> +
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index 6a8dbadf7e..f96630440b 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -51,6 +51,7 @@
>  #include "hw/s390x/s390-virtio-ccw.h"
>  #include "hw/s390x/s390-virtio-hcall.h"
>  #include "hw/s390x/pv.h"
> +#include "hw/s390x/cpu-topology.h"
>  
>  #ifndef DEBUG_KVM
>  #define DEBUG_KVM  0
> @@ -1917,9 +1918,12 @@ static int handle_stsi(S390CPU *cpu)
>          if (run->s390_stsi.sel1 != 2 || run->s390_stsi.sel2 != 2) {
>              return 0;
>          }
> -        /* Only sysib 3.2.2 needs post-handling for now. */
>          insert_stsi_3_2_2(cpu, run->s390_stsi.addr, run->s390_stsi.ar);
>          return 0;
> +    case 15:
> +        insert_stsi_15_1_x(cpu, run->s390_stsi.sel2, run->s390_stsi.addr,
> +                           run->s390_stsi.ar);
> +        return 0;
>      default:
>          return 0;
>      }
> diff --git a/target/s390x/meson.build b/target/s390x/meson.build
> index 84c1402a6a..890ccfa789 100644
> --- a/target/s390x/meson.build
> +++ b/target/s390x/meson.build
> @@ -29,6 +29,7 @@ s390x_softmmu_ss.add(files(
>    'sigp.c',
>    'cpu-sysemu.c',
>    'cpu_models_sysemu.c',
> +  'cpu_topology.c',
>  ))
>  
>  s390x_user_ss = ss.source_set()


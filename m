Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B985AD8E4
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 20:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiIESMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 14:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiIESMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 14:12:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D955B79B
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 11:12:01 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 285Hs8ld031962;
        Mon, 5 Sep 2022 18:11:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=5Sn5DLRkJI/ejM3FYUqA6pKiiZDixmjvdk9MJhVvPjk=;
 b=OQvWRrKLyqS7vuk++ha2oP73S9p13wOdwlsDXhfzmNVvNmqszmhhcBl//yy8zFWnhs/8
 L9mYSMScebTEjplHBX+aR4yOArkZm0KsYuNuIHZm+Kj6+wI/sCB8ukdhHlF8l4BhKS/C
 tou1rhF9buV5TFGm5+cymp3QK6jB1cdyrbSSomFrwAEwhvcLhgcpK7eOeo3rETbkgkP+
 ddv4hMjBHAP7HCKdpVNsDbF2psgfL50L6lP5jsVXzutanrbcC+HmFQfwmyykufJdNrpw
 6xvTliMCpd7i7wlTivzUE7UeJIyXRonATcoljBQwrd8gBE7omoy1uE6HPSI1lm0H7g6B Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jdnwy0gkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 18:11:55 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 285HxNdT018024;
        Mon, 5 Sep 2022 18:11:54 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jdnwy0gj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 18:11:54 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 285I6OQJ025279;
        Mon, 5 Sep 2022 18:11:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3jbxj8t1st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 18:11:52 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 285ICCpW37355960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Sep 2022 18:12:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9386211C04C;
        Mon,  5 Sep 2022 18:11:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D12D011C04A;
        Mon,  5 Sep 2022 18:11:47 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.44.172])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  5 Sep 2022 18:11:47 +0000 (GMT)
Message-ID: <bac31c028a713c32130b397189552f17b43a9485.camel@linux.ibm.com>
Subject: Re: [PATCH v9 02/10] s390x/cpu topology: core_id sets s390x CPU
 topology
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Date:   Mon, 05 Sep 2022 20:11:47 +0200
In-Reply-To: <20220902075531.188916-3-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
         <20220902075531.188916-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qMScA2TnKkuDy6OsHohpjipYX7in9fzM
X-Proofpoint-ORIG-GUID: YQvcNrW1hq7r9HOBMSE2GMaMsL4Ajq6p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-05_13,2022-09-05_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 adultscore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-09-02 at 09:55 +0200, Pierre Morel wrote:
> In the S390x CPU topology the core_id specifies the CPU address
> and the position of the core withing the topology.
> 
> Let's build the topology based on the core_id.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  hw/s390x/cpu-topology.c         | 135 ++++++++++++++++++++++++++++++++
>  hw/s390x/meson.build            |   1 +
>  hw/s390x/s390-virtio-ccw.c      |  10 +++
>  include/hw/s390x/cpu-topology.h |  42 ++++++++++
>  4 files changed, 188 insertions(+)
>  create mode 100644 hw/s390x/cpu-topology.c
>  create mode 100644 include/hw/s390x/cpu-topology.h
> 
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> 
[...]

> +/**
> + * s390_topology_realize:
> + * @dev: the device state
> + * @errp: the error pointer (not used)
> + *
> + * During realize the machine CPU topology is initialized with the
> + * QEMU -smp parameters.
> + * The maximum count of CPU TLE in the all Topology can not be greater
> + * than the maximum CPUs.
> + */
> +static void s390_topology_realize(DeviceState *dev, Error **errp)
> +{
> +    MachineState *ms = MACHINE(qdev_get_machine());
> +    S390Topology *topo = S390_CPU_TOPOLOGY(dev);
> +    int n;
> +
> +    topo->sockets = ms->smp.sockets;
> +    topo->cores = ms->smp.cores;
> +    topo->tles = ms->smp.max_cpus;
> +
> +    n = topo->sockets;
> +    topo->socket = g_malloc0(n * sizeof(S390TopoContainer));
> +    topo->tle = g_malloc0(topo->tles * sizeof(S390TopoTLE));

Seems like a good use case for g_new0.

[...]
> 
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> new file mode 100644
> index 0000000000..6911f975f4
> --- /dev/null
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -0,0 +1,42 @@
> +/*
> + * CPU Topology
> + *
> + * Copyright 2022 IBM Corp.
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +#ifndef HW_S390X_CPU_TOPOLOGY_H
> +#define HW_S390X_CPU_TOPOLOGY_H

Is there a reason this is before the includes?
> +
> +typedef struct S390TopoContainer {
> +    int active_count;
> +} S390TopoContainer;
> +
> +#define S390_TOPOLOGY_MAX_ORIGIN (1 + S390_MAX_CPUS / 64)

This is correct because cpu_id == core_id for s390, right?
So the cpu limit also applies to the core id.
You could do ((S390_MAX_CPUS + 63) / 64) instead.
But if you chose this for simplicity's sake, I'm fine with it.

> +typedef struct S390TopoTLE {
> +    int active_count;

Do you use (read) this field somewhere?
Is this in anticipation of there being multiple TLE arrays, for
different polarizations, etc? If so I would defer this for later.

> +    uint64_t mask[S390_TOPOLOGY_MAX_ORIGIN];
> +} S390TopoTLE;
> +
> +#include "hw/qdev-core.h"
> +#include "qom/object.h"
> +
> +struct S390Topology {
> +    SysBusDevice parent_obj;
> +    int sockets;
> +    int cores;

These are just cached values from machine_state.smp, right?
Not sure if I like the redundancy, it doesn't aid in comprehension.

> +    int tles;
> +    S390TopoContainer *socket;
> +    S390TopoTLE *tle;
> +};
> +typedef struct S390Topology S390Topology;

The DECLARE macro takes care of this typedef.

> +
> +#define TYPE_S390_CPU_TOPOLOGY "s390-topology"
> +OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
> +
> +S390Topology *s390_get_topology(void);
> +void s390_topology_new_cpu(int core_id);
> +
> +#endif


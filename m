Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71C166A1E1
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 19:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjAMSXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 13:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjAMSWe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 13:22:34 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F56D6B5BE
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 10:16:13 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30DIAfSi005946;
        Fri, 13 Jan 2023 18:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=PUvb1vUkC1aasa36qvhCuWrdpClC/2vPjLUlOuAxuoE=;
 b=E6nL9jn17UNMOqryZOKxJOR94EWi3KMNBFONW+pzdwoIRRAclSfLzev4ugjp6b2fsKgX
 JbuLvneybY0aDNYzuvCbHXdAsSx4klB5RfGHGQy4O7O1Cg1fE4OLnF+TnzTrteGljNvQ
 Nsyxm5DxB5J8JPcSD9QtSkpC3flqODxOjNCns1LiQfY5FdmaXbbH32/5RdS0zYc3Ma99
 m6NSKSBSO9CrwnZxgp4E0ysNWs4UAou8oR1cv4XStd806fsOUIwAvT817kAqDU34BnPb
 jLv9qxOBxsVQVHL+Ft+jihat3loPHssGzT8tHh9iB4wHKcVuod1CW8HHUwK/s3BQOb0s eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n3bpt92dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Jan 2023 18:15:57 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30DICBoj011021;
        Fri, 13 Jan 2023 18:15:57 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n3bpt92cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Jan 2023 18:15:57 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30D82tm8017960;
        Fri, 13 Jan 2023 18:15:55 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3n1km6b4ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Jan 2023 18:15:55 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30DIFp3g51511710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Jan 2023 18:15:51 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70E3920043;
        Fri, 13 Jan 2023 18:15:51 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC36920040;
        Fri, 13 Jan 2023 18:15:50 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.201.249])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 13 Jan 2023 18:15:50 +0000 (GMT)
Message-ID: <666b9711b23d807525be06992fffd4d782ee80c7.camel@linux.ibm.com>
Subject: Re: [PATCH v14 02/11] s390x/cpu topology: add topology entries on
 CPU hotplug
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Fri, 13 Jan 2023 19:15:50 +0100
In-Reply-To: <20230105145313.168489-3-pmorel@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
         <20230105145313.168489-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JKlKPGRyl4d9UnZghyR1c3tFb4XKjtn-
X-Proofpoint-ORIG-GUID: NfgFDdRPkz1BA45nZhM_l7leZMG5Kbs5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_08,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 suspectscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301130122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-01-05 at 15:53 +0100, Pierre Morel wrote:
> The topology information are attributes of the CPU and are
> specified during the CPU device creation.
>=20
> On hot plug, we gather the topology information on the core,
> creates a list of topology entries, each entry contains a single
> core mask of each core with identical topology and finaly we
s/finaly/finally/
> orders the list in topological order.
s/orders/order/
> The topological order is, from higher to lower priority:
> - physical topology
>     - drawer
>     - book
>     - socket
>     - core origin, offset in 64bit increment from core 0.
> - modifier attributes
>     - CPU type
>     - polarization entitlement
>     - dedication
>=20
> The possibility to insert a CPU in a mask is dependent on the
> number of cores allowed in a socket, a book or a drawer, the
> checking is done during the hot plug of the CPU to have an
> immediate answer.
>=20
> If the complete topology is not specified, the core is added
> in the physical topology based on its core ID and it gets
> defaults values for the modifier attributes.
>=20
> This way, starting QEMU without specifying the topology can
> still get some adventage of the CPU topology.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  include/hw/s390x/cpu-topology.h |  48 ++++++
>  hw/s390x/cpu-topology.c         | 293 ++++++++++++++++++++++++++++++++
>  hw/s390x/s390-virtio-ccw.c      |  10 ++
>  hw/s390x/meson.build            |   1 +
>  4 files changed, 352 insertions(+)
>  create mode 100644 hw/s390x/cpu-topology.c
>=20
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topol=
ogy.h
> index d945b57fc3..b3fd752d8d 100644
> --- a/include/hw/s390x/cpu-topology.h
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -10,7 +10,11 @@
>  #ifndef HW_S390X_CPU_TOPOLOGY_H
>  #define HW_S390X_CPU_TOPOLOGY_H
> =20
> +#include "qemu/queue.h"
> +#include "hw/boards.h"
> +
>  #define S390_TOPOLOGY_CPU_IFL   0x03
> +#define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
> =20
>  #define S390_TOPOLOGY_POLARITY_HORIZONTAL      0x00
>  #define S390_TOPOLOGY_POLARITY_VERTICAL_LOW    0x01
> @@ -20,4 +24,48 @@
>  #define S390_TOPOLOGY_SHARED    0x00
>  #define S390_TOPOLOGY_DEDICATED 0x01
> =20
> +typedef union s390_topology_id {
> +    uint64_t id;
> +    struct {
> +        uint64_t level_6:8; /* byte 0 BE */
> +        uint64_t level_5:8; /* byte 1 BE */
> +        uint64_t drawer:8;  /* byte 2 BE */
> +        uint64_t book:8;    /* byte 3 BE */
> +        uint64_t socket:8;  /* byte 4 BE */
> +        uint64_t rsrv:5;
> +        uint64_t d:1;
> +        uint64_t p:2;       /* byte 5 BE */
> +        uint64_t type:8;    /* byte 6 BE */
> +        uint64_t origin:2;

This is two bits because it's the core divided by 64, and we have 248 cores=
 at most?
Where is this set?

> +        uint64_t core:6;    /* byte 7 BE */
> +    };
> +} s390_topology_id;

This struct seems to do double duty, 1. it represents a cpu and 2. a topolo=
gy entry.
You also use it for sorting.
I would suggest to just use a cpu object when referring to a specific cpu a=
nd
put the relevant fields directly into the topology entry.
You get rid of the bit field that way.
You'd then need a comparison function for a cpu object and a topology entry=
.
As long as that isn't the only type pair that shouldn't be too ugly.

> +#define TOPO_CPU_MASK       0x000000000000003fUL
> +
> +typedef struct S390TopologyEntry {
> +    s390_topology_id id;
> +    QTAILQ_ENTRY(S390TopologyEntry) next;
> +    uint64_t mask;
> +} S390TopologyEntry;
> +
> +typedef struct S390Topology {
> +    QTAILQ_HEAD(, S390TopologyEntry) list;
> +    uint8_t *sockets;
> +    CpuTopology *smp;
> +} S390Topology;
> +
> +#ifdef CONFIG_KVM
> +bool s390_has_topology(void);
> +void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp)=
;
> +#else
> +static inline bool s390_has_topology(void)
> +{
> +       return false;
> +}
> +static inline void s390_topology_set_cpu(MachineState *ms,
> +                                         S390CPU *cpu,
> +                                         Error **errp) {}
> +#endif
> +extern S390Topology s390_topology;
> +
>  #endif
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..438055c612
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c
> @@ -0,0 +1,293 @@
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022
> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> +
> + * This work is licensed under the terms of the GNU GPL, version 2 or (a=
t
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qemu/error-report.h"
> +#include "hw/qdev-properties.h"
> +#include "hw/boards.h"
> +#include "qemu/typedefs.h"
> +#include "target/s390x/cpu.h"
> +#include "hw/s390x/s390-virtio-ccw.h"
> +#include "hw/s390x/cpu-topology.h"
> +
> +/*
> + * s390_topology is used to keep the topology information.
> + * .list: queue the topology entries inside which
> + *        we keep the information on the CPU topology.
> + *
> + * .smp: keeps track of the machine topology.
> + *
> + * .socket: tracks information on the count of cores per socket.
> + *
> + */
> +S390Topology s390_topology =3D {
> +    .list =3D QTAILQ_HEAD_INITIALIZER(s390_topology.list),
> +    .sockets =3D NULL, /* will be initialized after the cpu model is rea=
lized */

I guess you should do the same for .smp then also.

> +};
> +
> +/**
> + * s390_socket_nb:
> + * @id: s390_topology_id
> + *
> + * Returns the socket number used inside the socket array.
> + */
> +static int s390_socket_nb(s390_topology_id id)
> +{
> +    return (id.socket + 1) * (id.book + 1) * (id.drawer + 1);

This calculation doesn't make a whole lot of sense to me.
It's symmetric with regards to the variables, so (s=3D0 b=3D1 d=3D1)
will have the same result as (s=3D1 b=3D0 d=3D1).
You want the "global" socket number right?
So that would be (drawer * books_per_drawer + book) * sockets_per_book + so=
cket.

> +}
> +
> +/**
> + * s390_has_topology:
> + *
> + * Return value: if the topology is supported by the machine.
> + */
> +bool s390_has_topology(void)
> +{
> +    return false;
> +}
> +
> +/**
> + * s390_topology_init:
> + * @ms: the machine state where the machine topology is defined
> + *
> + * Keep track of the machine topology.
> + * Allocate an array to keep the count of cores per socket.
> + * The index of the array starts at socket 0 from book 0 and
> + * drawer 0 up to the maximum allowed by the machine topology.
> + */
> +static void s390_topology_init(MachineState *ms)
> +{
> +    CpuTopology *smp =3D &ms->smp;
> +
> +    s390_topology.smp =3D smp;
> +    if (!s390_topology.sockets) {

Is this function being called multiple times, or why the if?
Use an assert instead?

> +        s390_topology.sockets =3D g_new0(uint8_t, smp->sockets *
> +                                       smp->books * smp->drawers);
> +    }
> +}
> +
> +/**
> + * s390_topology_from_cpu:
> + * @cpu: The S390CPU
> + *
> + * Initialize the topology id from the CPU environment.
> + */
> +static s390_topology_id s390_topology_from_cpu(S390CPU *cpu)
> +{
> +    s390_topology_id topology_id;
> +
> +    topology_id.core =3D cpu->env.core_id;
> +    topology_id.type =3D cpu->env.cpu_type;
> +    topology_id.p =3D cpu->env.polarity;
> +    topology_id.d =3D cpu->env.dedicated;
> +    topology_id.socket =3D cpu->env.socket_id;
> +    topology_id.book =3D cpu->env.book_id;
> +    topology_id.drawer =3D cpu->env.drawer_id;
> +
> +    return topology_id;
> +}
> +
> +/**
> + * s390_topology_set_entry:
> + * @entry: Topology entry to setup
> + * @id: topology id to use for the setup
> + *
> + * Set the core bit inside the topology mask and
> + * increments the number of cores for the socket.
> + */
> +static void s390_topology_set_entry(S390TopologyEntry *entry,

Not sure if I like the name, what it does is to add a cpu to the entry.

> +                                    s390_topology_id id)
> +{
> +    set_bit(63 - id.core, &entry->mask);

You need to subtract the origin first or that might be negative.

> +    s390_topology.sockets[s390_socket_nb(id)]++;
> +}
> +
> +/**
> + * s390_topology_new_entry:
> + * @id: s390_topology_id to add
> + *
> + * Allocate a new entry and initialize it.
> + *
> + * returns the newly allocated entry.
> + */
> +static S390TopologyEntry *s390_topology_new_entry(s390_topology_id id)
> +{
> +    S390TopologyEntry *entry;
> +
> +    entry =3D g_malloc0(sizeof(S390TopologyEntry));
> +    entry->id.id =3D id.id & ~TOPO_CPU_MASK;
> +    s390_topology_set_entry(entry, id);
> +
> +    return entry;
> +}
> +
> +/**
> + * s390_topology_insert:
> + *
> + * @id: s390_topology_id to insert.
> + *
> + * Parse the topology list to find if the entry already
> + * exist and add the core in it.
> + * If it does not exist, allocate a new entry and insert
> + * it in the queue from lower id to greater id.
> + */
> +static void s390_topology_insert(s390_topology_id id)
> +{
> +    S390TopologyEntry *entry;
> +    S390TopologyEntry *tmp =3D NULL;
> +    uint64_t new_id;
> +
> +    new_id =3D id.id & ~TOPO_CPU_MASK;
> +
> +    /* First CPU to add to an entry */
> +    if (QTAILQ_EMPTY(&s390_topology.list)) {
> +        entry =3D s390_topology_new_entry(id);
> +        QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
> +        return;
> +    }
> +
> +    QTAILQ_FOREACH(tmp, &s390_topology.list, next) {
> +        if (new_id =3D=3D tmp->id.id) {
> +            s390_topology_set_entry(tmp, id);
> +            return;
> +        } else if (new_id < tmp->id.id) {
> +            entry =3D s390_topology_new_entry(id);
> +            QTAILQ_INSERT_BEFORE(tmp, entry, next);
> +            return;
> +        }
> +    }
> +
> +    entry =3D s390_topology_new_entry(id);
> +    QTAILQ_INSERT_TAIL(&s390_topology.list, entry, next);

Consider adding a sentinel entry "at infinity", then that whole code
would simplify.

> +}
> +
> +/**
> + * s390_topology_check:
> + * @errp: Error pointer
> + * id: s390_topology_id to be verified
> + *
> + * The function checks if the topology id fits inside the
> + * system topology.
> + */
> +static void s390_topology_check(Error **errp, s390_topology_id id)
> +{
> +    CpuTopology *smp =3D s390_topology.smp;
> +
> +    if (id.socket > smp->sockets) {
> +            error_setg(errp, "Unavailable socket: %d", id.socket);
> +            return;
> +    }
> +    if (id.book > smp->books) {
> +            error_setg(errp, "Unavailable book: %d", id.book);
> +            return;
> +    }
> +    if (id.drawer > smp->drawers) {
> +            error_setg(errp, "Unavailable drawer: %d", id.drawer);
> +            return;
> +    }
> +    if (id.type !=3D S390_TOPOLOGY_CPU_IFL) {
> +            error_setg(errp, "Unknown cpu type: %d", id.type);
> +            return;
> +    }
> +    /* Polarity and dedication can never be wrong */
> +}
> +
> +/**
> + * s390_topology_cpu_default:
> + * @errp: Error pointer
> + * @cpu: pointer to a S390CPU
> + *
> + * Setup the default topology for unset attributes.
> + *
> + * The function accept only all all default values or all set values
> + * for the geometry topology.
> + *
> + * The function calculates the (drawer_id, book_id, socket_id)
> + * topology by filling the cores starting from the first socket
> + * (0, 0, 0) up to the last (smp->drawers, smp->books, smp->sockets).
> + *
> + */
> +static void s390_topology_cpu_default(Error **errp, S390CPU *cpu)
> +{
> +    CpuTopology *smp =3D s390_topology.smp;
> +    CPUS390XState *env =3D &cpu->env;
> +
> +    /* All geometry topology attributes must be set or all unset */
> +    if ((env->socket_id < 0 || env->book_id < 0 || env->drawer_id < 0) &=
&
> +        (env->socket_id >=3D 0 || env->book_id >=3D 0 || env->drawer_id =
>=3D 0)) {
> +        error_setg(errp,
> +                   "Please define all or none of the topology geometry a=
ttributes");
> +        return;
> +    }
> +
> +    /* Check if one of the geometry topology is unset */
> +    if (env->socket_id < 0) {
> +        /* Calculate default geometry topology attributes */
> +        env->socket_id =3D (env->core_id / smp->cores) % smp->sockets;
> +        env->book_id =3D (env->core_id / (smp->sockets * smp->cores)) %
> +                       smp->books;
> +        env->drawer_id =3D (env->core_id /
> +                          (smp->books * smp->sockets * smp->cores)) %
> +                         smp->drawers;
> +    }
> +}
> +
> +/**
> + * s390_topology_set_cpu:
> + * @ms: MachineState used to initialize the topology structure on
> + *      first call.
> + * @cpu: the new S390CPU to insert in the topology structure
> + * @errp: the error pointer
> + *
> + * Called from CPU Hotplug to check and setup the CPU attributes
> + * before to insert the CPU in the topology.
> + */
> +void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
> +{
> +    Error *local_error =3D NULL;

Can't you just use ERRP_GUARD ?

> +    s390_topology_id id;
> +
> +    /*
> +     * We do not want to initialize the topology if the cpu model
> +     * does not support topology consequently, we have to wait for

", consequently," I think. Could you do the initialization some where else,
after you know what the cpu model is? Not that I object to doing it this wa=
y.

> +     * the first CPU to be realized, which realizes the CPU model
> +     * to initialize the topology structures.
> +     *
> +     * s390_topology_set_cpu() is called from the cpu hotplug.
> +     */
> +    if (!s390_topology.sockets) {
> +        s390_topology_init(ms);
> +    }
> +
> +    s390_topology_cpu_default(&local_error, cpu);
> +    if (local_error) {
> +        error_propagate(errp, local_error);
> +        return;
> +    }
> +
> +    id =3D s390_topology_from_cpu(cpu);
> +
> +    /* Check for space on the socket */
> +    if (s390_topology.sockets[s390_socket_nb(id)] >=3D
> +        s390_topology.smp->sockets) {
> +        error_setg(&local_error, "No more space on socket");
> +        return;
> +    }
> +
> +    s390_topology_check(&local_error, id);
> +    if (local_error) {
> +        error_propagate(errp, local_error);
> +        return;
> +    }
> +
> +    s390_topology_insert(id);
> +}
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index f3cc845d3b..c98b93a15f 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -44,6 +44,7 @@
>  #include "hw/s390x/pv.h"
>  #include "migration/blocker.h"
>  #include "qapi/visitor.h"
> +#include "hw/s390x/cpu-topology.h"
> =20
>  static Error *pv_mig_blocker;
> =20
> @@ -310,10 +311,19 @@ static void s390_cpu_plug(HotplugHandler *hotplug_d=
ev,
>  {
>      MachineState *ms =3D MACHINE(hotplug_dev);
>      S390CPU *cpu =3D S390_CPU(dev);
> +    Error *local_err =3D NULL;
> =20
>      g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
>      ms->possible_cpus->cpus[cpu->env.core_id].cpu =3D OBJECT(dev);
> =20
> +    if (s390_has_topology()) {
> +        s390_topology_set_cpu(ms, cpu, &local_err);
> +        if (local_err) {
> +            error_propagate(errp, local_err);
> +            return;
> +        }
> +    }
> +
>      if (dev->hotplugged) {
>          raise_irq_cpu_hotplug();
>      }
> diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
> index f291016fee..58dfbdff4f 100644
> --- a/hw/s390x/meson.build
> +++ b/hw/s390x/meson.build
> @@ -24,6 +24,7 @@ s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
>    's390-stattrib-kvm.c',
>    'pv.c',
>    's390-pci-kvm.c',
> +  'cpu-topology.c',
>  ))
>  s390x_ss.add(when: 'CONFIG_TCG', if_true: files(
>    'tod-tcg.c',


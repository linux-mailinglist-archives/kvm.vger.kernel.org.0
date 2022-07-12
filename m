Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9153C571FA1
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 17:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbiGLPkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 11:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbiGLPkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 11:40:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21104C1767
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 08:40:18 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CEI9NG034384;
        Tue, 12 Jul 2022 15:40:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : from : subject : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MtVp0SEc4aFV9Avx3+9IiyZVdRJ9oua091aBCdfdw8U=;
 b=C4E4mXH5hQ1cKm3AhxWjtbq7MtEhcTamdOHXeV5BKsM2LFAi9EvCat0yOeu4nzqi83EI
 qSEllt1Kc2vKuXxdVDDdnQNvs8J7keG9JBiMJZzyk9LoOuYkX016lzpe59dcuV+xzRdX
 ULGpMFLR8qrNlO1plI2dQR20sOfHraUDT/BMCzPVsvO8jq8Hzcy0pjqk/CC0EYT1YLRp
 KeyW/nlwiHrhx+8gbB3ozpiubPUFat9xm/W+E7oP8zakWvi/a9M25X6AqzTvY3dOmB48
 gZk6D9qHZaoXM3CCgcUv/L5ZDgGN15WCjXhISnYEC+SnwMVLujamGUvP02GMvFeXdaNP jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9akqtbuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 15:40:10 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26CEoLGQ028915;
        Tue, 12 Jul 2022 15:40:09 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9akqtbt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 15:40:09 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26CFaHKM004083;
        Tue, 12 Jul 2022 15:40:07 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3h71a8uabd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 15:40:07 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26CFcY9323331264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 15:38:34 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F60FA405F;
        Tue, 12 Jul 2022 15:40:03 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E831A405B;
        Tue, 12 Jul 2022 15:40:02 +0000 (GMT)
Received: from [9.171.74.161] (unknown [9.171.74.161])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jul 2022 15:40:02 +0000 (GMT)
Message-ID: <de92ef17-3a17-df44-97aa-19e67d1d5b3d@linux.ibm.com>
Date:   Tue, 12 Jul 2022 17:40:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: Re: [PATCH v8 02/12] s390x/cpu_topology: CPU topology objects and
 structures
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <20220620140352.39398-3-pmorel@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20220620140352.39398-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dOjpKtB6Qc66Htt7w1oEUF-ub471AoXV
X-Proofpoint-GUID: KfZ-dI4IAV2X9OQEqeCc9VFealjd70M6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_08,2022-07-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/22 16:03, Pierre Morel wrote:
> We use new objects to have a dynamic administration of the CPU topology.
> The highest level object in this implementation is the s390 book and
> in this first implementation of CPU topology for S390 we have a single
> book.
> The book is built as a SYSBUS bridge during the CPU initialization.
> Other objects, sockets and core will be built after the parsing
> of the QEMU -smp argument.
> 
> Every object under this single book will be build dynamically
> immediately after a CPU has be realized if it is needed.
> The CPU will fill the sockets once after the other, according to the
> number of core per socket defined during the smp parsing.
> 
> Each CPU inside a socket will be represented by a bit in a 64bit
> unsigned long. Set on plug and clear on unplug of a CPU.
> 
> For the S390 CPU topology, thread and cores are merged into
> topology cores and the number of topology cores is the multiplication
> of cores by the numbers of threads.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  hw/s390x/cpu-topology.c         | 391 ++++++++++++++++++++++++++++++++
>  hw/s390x/meson.build            |   1 +
>  hw/s390x/s390-virtio-ccw.c      |   6 +
>  include/hw/s390x/cpu-topology.h |  74 ++++++
>  target/s390x/cpu.h              |  47 ++++
>  5 files changed, 519 insertions(+)
>  create mode 100644 hw/s390x/cpu-topology.c
>  create mode 100644 include/hw/s390x/cpu-topology.h
> 
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..0fd6f08084
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c
> @@ -0,0 +1,391 @@
> +/*
> + * CPU Topology
> + *
> + * Copyright 2022 IBM Corp.

Should be Copyright IBM Corp. 2022, and maybe even have a year range.

> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> +
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qemu/error-report.h"
> +#include "hw/sysbus.h"
> +#include "hw/s390x/cpu-topology.h"
> +#include "hw/qdev-properties.h"
> +#include "hw/boards.h"
> +#include "qemu/typedefs.h"
> +#include "target/s390x/cpu.h"
> +#include "hw/s390x/s390-virtio-ccw.h"
> +
> +/*
> + * s390_create_cores:
> + * @ms: Machine state
> + * @socket: the socket on which to create the core set
> + * @origin: the origin offset of the first core of the set
> + * @errp: Error pointer
> + *
> + * returns a pointer to the created S390TopologyCores structure
> + *
> + * On error: return NULL
> + */
> +static S390TopologyCores *s390_create_cores(MachineState *ms,
> +                                            S390TopologySocket *socket,
> +                                            int origin, Error **errp)
> +{
> +    DeviceState *dev;
> +    S390TopologyCores *cores;
> +
> +    if (socket->bus->num_children >= ms->smp.cores * ms->smp.threads) {
> +        error_setg(errp, "Unable to create more cores.");
> +        return NULL;
> +    }

Why/How can this happen?
The "location" of the CPU is a function of core_id and the same CPU should not be added twice.
If it's to enforce a limit on the smp arguments that should happen earlier in my opinion.
If it's necessary, you could also make the message more verbose and add ", maximum number reached".
> +
> +    dev = qdev_new(TYPE_S390_TOPOLOGY_CORES);
> +    qdev_realize_and_unref(dev, socket->bus, &error_fatal);

As a result of this, the order of cores in the socket bus is the creation order, correct?
So newest first and not ordered by the origin (since we can hot plug CPUs), correct?
> +
> +    cores = S390_TOPOLOGY_CORES(dev);
> +    cores->origin = origin;

I must admit that I haven't fully grokked the qemu object model, yet, but I'd be more comfortable
if you unref'ed cores after you set the origin.
Does the socket bus own the object after you unref it? Does it then make sense to return cores
after unref'ing it?
But then we don't support CPU unplug, so the object shouldn't just vanish.

> +    socket->cnt += 1;

cnt++ to be consistent with create_socket below.
> +
> +    return cores;
> +}
> +
> +/*
> + * s390_create_socket:
> + * @ms: Machine state
> + * @book: the book on which to create the socket
> + * @id: the socket id
> + * @errp: Error pointer
> + *
> + * returns a pointer to the created S390TopologySocket structure
> + *
> + * On error: return NULL
> + */
> +static S390TopologySocket *s390_create_socket(MachineState *ms,
> +                                              S390TopologyBook *book,
> +                                              int id, Error **errp)
> +{

Same questions/comments as above.

> +    DeviceState *dev;
> +    S390TopologySocket *socket;
> +
> +    if (book->bus->num_children >= ms->smp.sockets) {
> +        error_setg(errp, "Unable to create more sockets.");
> +        return NULL;
> +    }
> +
> +    dev = qdev_new(TYPE_S390_TOPOLOGY_SOCKET);
> +    qdev_realize_and_unref(dev, book->bus, &error_fatal);
> +
> +    socket = S390_TOPOLOGY_SOCKET(dev);
> +    socket->socket_id = id;
> +    book->cnt++;
> +
> +    return socket;
> +}
> +
> +/*
> + * s390_get_cores:
> + * @ms: Machine state
> + * @socket: the socket to search into
> + * @origin: the origin specified for the S390TopologyCores
> + * @errp: Error pointer
> + *
> + * returns a pointer to a S390TopologyCores structure within a socket having
> + * the specified origin.
> + * First search if the socket is already containing the S390TopologyCores
> + * structure and if not create one with this origin.
> + */
> +static S390TopologyCores *s390_get_cores(MachineState *ms,
> +                                         S390TopologySocket *socket,
> +                                         int origin, Error **errp)
> +{
> +    S390TopologyCores *cores;
> +    BusChild *kid;
> +
> +    QTAILQ_FOREACH(kid, &socket->bus->children, sibling) {
> +        cores = S390_TOPOLOGY_CORES(kid->child);
> +        if (cores->origin == origin) {
> +            return cores;
> +        }
> +    }
> +    return s390_create_cores(ms, socket, origin, errp);

I think calling create here is unintuative.
You only use get_cores once when creating a new cpu, I think doing

    cores = s390_get_cores(ms, socket, origin, errp);
    if (!cores) {
        cores = s390_create_cores(...);
    ]
    if (!cores) {
        return false;
    }

is more straight forward and readable.
> +}
> +
> +/*
> + * s390_get_socket:
> + * @ms: Machine state
> + * @book: The book to search into
> + * @socket_id: the identifier of the socket to search for
> + * @errp: Error pointer
> + *
> + * returns a pointer to a S390TopologySocket structure within a book having
> + * the specified socket_id.
> + * First search if the book is already containing the S390TopologySocket
> + * structure and if not create one with this socket_id.
> + */
> +static S390TopologySocket *s390_get_socket(MachineState *ms,
> +                                           S390TopologyBook *book,
> +                                           int socket_id, Error **errp)
> +{
> +    S390TopologySocket *socket;
> +    BusChild *kid;
> +
> +    QTAILQ_FOREACH(kid, &book->bus->children, sibling) {
> +        socket = S390_TOPOLOGY_SOCKET(kid->child);
> +        if (socket->socket_id == socket_id) {
> +            return socket;
> +        }
> +    }
> +    return s390_create_socket(ms, book, socket_id, errp);

As above.

> +}
> +
> +/*
> + * s390_topology_new_cpu:
> + * @core_id: the core ID is machine wide
> + *
> + * We have a single book returned by s390_get_topology(),
> + * then we build the hierarchy on demand.
> + * Note that we do not destroy the hierarchy on error creating
> + * an entry in the topology, we just keep it empty.
> + * We do not need to worry about not finding a topology level
> + * entry this would have been caught during smp parsing.
> + */
> +bool s390_topology_new_cpu(MachineState *ms, int core_id, Error **errp)
> +{
> +    S390TopologyBook *book;
> +    S390TopologySocket *socket;
> +    S390TopologyCores *cores;
> +    int nb_cores_per_socket;

num_cores_per_socket instead?

> +    int origin, bit;
> +
> +    book = s390_get_topology();
> +
> +    nb_cores_per_socket = ms->smp.cores * ms->smp.threads;

We don't support the multithreading facility, do we?
So, I think we should assert smp.threads == 1 somewhere.
In any case I think the correct expression would round the threads up to the next power of 2,
because the core_id has the thread id in the lower bits, but threads per core doesn't need to be
a power of 2 according to the architecture.

> +
> +    socket = s390_get_socket(ms, book, core_id / nb_cores_per_socket, errp);
> +    if (!socket) {
> +        return false;
> +    }
> +
> +    /*
> +     * At the core level, each CPU is represented by a bit in a 64bit
> +     * unsigned long. Set on plug and clear on unplug of a CPU.
> +     * The firmware assume that all CPU in the core description have the same
> +     * type, polarization and are all dedicated or shared.
> +     * In the case a socket contains CPU with different type, polarization
> +     * or dedication then they will be defined in different CPU containers.
> +     * Currently we assume all CPU are identical and the only reason to have
> +     * several S390TopologyCores inside a socket is to have more than 64 CPUs
> +     * in that case the origin field, representing the offset of the first CPU
> +     * in the CPU container allows to represent up to the maximal number of
> +     * CPU inside several CPU containers inside the socket container.
> +     */
> +    origin = 64 * (core_id / 64);
> +
> +    cores = s390_get_cores(ms, socket, origin, errp);
> +    if (!cores) {
> +        return false;
> +    }
> +
> +    bit = 63 - (core_id - origin);
> +    set_bit(bit, &cores->mask);
> +    cores->origin = origin;

This is redundant, origin is already set.
Also I think you should generally pass the core_id and not the origin.
Then on construction you can also set the bit.

> +
> +    return true;
> +}
> +
> +/*
> + * Setting the first topology: 1 book, 1 socket
> + * This is enough for 64 cores if the topology is flat (single socket)
> + */
> +void s390_topology_setup(MachineState *ms)
> +{
> +    DeviceState *dev;
> +
> +    /* Create BOOK bridge device */
> +    dev = qdev_new(TYPE_S390_TOPOLOGY_BOOK);
> +    object_property_add_child(qdev_get_machine(),
> +                              TYPE_S390_TOPOLOGY_BOOK, OBJECT(dev));

Why add it to the machine instead of directly using a static?
So it's visible to the user via info qtree or something?
Would that even be the appropriate location to show that?

> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
> +}
> +
> +S390TopologyBook *s390_get_topology(void)
> +{
> +    static S390TopologyBook *book;
> +
> +    if (!book) {
> +        book = S390_TOPOLOGY_BOOK(
> +            object_resolve_path(TYPE_S390_TOPOLOGY_BOOK, NULL));
> +        assert(book != NULL);
> +    }
> +
> +    return book;
> +}
> +
> +/* --- CORES Definitions --- */
> +
> +static Property s390_topology_cores_properties[] = {
> +    DEFINE_PROP_BOOL("dedicated", S390TopologyCores, dedicated, false),
> +    DEFINE_PROP_UINT8("polarity", S390TopologyCores, polarity,
> +                      S390_TOPOLOGY_POLARITY_H),
> +    DEFINE_PROP_UINT8("cputype", S390TopologyCores, cputype,
> +                      S390_TOPOLOGY_CPU_TYPE),
> +    DEFINE_PROP_UINT16("origin", S390TopologyCores, origin, 0),
> +    DEFINE_PROP_UINT64("mask", S390TopologyCores, mask, 0),
> +    DEFINE_PROP_END_OF_LIST(),
> +};
> +
> +static void cpu_cores_class_init(ObjectClass *oc, void *data)
> +{
> +    DeviceClass *dc = DEVICE_CLASS(oc);
> +    HotplugHandlerClass *hc = HOTPLUG_HANDLER_CLASS(oc);
> +
> +    device_class_set_props(dc, s390_topology_cores_properties);
> +    hc->unplug = qdev_simple_device_unplug_cb;
> +    dc->bus_type = TYPE_S390_TOPOLOGY_SOCKET_BUS;
> +    dc->desc = "topology cpu entry";
> +}
> +
> +static const TypeInfo cpu_cores_info = {
> +    .name          = TYPE_S390_TOPOLOGY_CORES,
> +    .parent        = TYPE_DEVICE,
> +    .instance_size = sizeof(S390TopologyCores),
> +    .class_init    = cpu_cores_class_init,
> +    .interfaces = (InterfaceInfo[]) {
> +        { TYPE_HOTPLUG_HANDLER },

Why implement the hotplug interface? That is not actually supported, is it?
> +        { }
> +    }
> +};
> +
> +static char *socket_bus_get_dev_path(DeviceState *dev)
> +{
> +    S390TopologySocket *socket = S390_TOPOLOGY_SOCKET(dev);
> +    DeviceState *book = dev->parent_bus->parent;
> +    char *id = qdev_get_dev_path(book);
> +    char *ret;
> +
> +    if (id) {
> +        ret = g_strdup_printf("%s:%02d", id, socket->socket_id);
> +        g_free(id);
> +    } else {
> +        ret = g_strdup_printf("_:%02d", socket->socket_id);

How can this case occur? Sockets get attached to the book bus immediately after creation, correct?

> +    }
> +
> +    return ret;
> +}
> +
> +static void socket_bus_class_init(ObjectClass *oc, void *data)
> +{
> +    BusClass *k = BUS_CLASS(oc);
> +
> +    k->get_dev_path = socket_bus_get_dev_path;
> +    k->max_dev = S390_MAX_SOCKETS;

This is the bus the cores are attached to, correct?
Is this constant badly named, or should this be MAX_CORES (which doesn't exist)?
How does this limit get enforced?
Why is there a limit in the first place? I don't see one defined by STSI, other than having to fit in a u8.
> +}
> +
> +static const TypeInfo socket_bus_info = {
> +    .name = TYPE_S390_TOPOLOGY_SOCKET_BUS,
> +    .parent = TYPE_BUS,
> +    .instance_size = 0,

After a bit of grepping it seems to me that omitting that field is more common that setting it to 0.

> +    .class_init = socket_bus_class_init,
> +};
> +
> +static void s390_socket_device_realize(DeviceState *dev, Error **errp)
> +{
> +    S390TopologySocket *socket = S390_TOPOLOGY_SOCKET(dev);
> +    BusState *bus;
> +
> +    bus = qbus_new(TYPE_S390_TOPOLOGY_SOCKET_BUS, dev,
> +                   TYPE_S390_TOPOLOGY_SOCKET_BUS);
> +    qbus_set_hotplug_handler(bus, OBJECT(dev));
> +    socket->bus = bus;
> +}
> +
> +static void socket_class_init(ObjectClass *oc, void *data)
> +{
> +    DeviceClass *dc = DEVICE_CLASS(oc);
> +    HotplugHandlerClass *hc = HOTPLUG_HANDLER_CLASS(oc);
> +
> +    hc->unplug = qdev_simple_device_unplug_cb;
> +    set_bit(DEVICE_CATEGORY_BRIDGE, dc->categories);
> +    dc->bus_type = TYPE_S390_TOPOLOGY_BOOK_BUS;
> +    dc->realize = s390_socket_device_realize;
> +    dc->desc = "topology socket";
> +}
> +
> +static const TypeInfo socket_info = {
> +    .name          = TYPE_S390_TOPOLOGY_SOCKET,
> +    .parent        = TYPE_DEVICE,
> +    .instance_size = sizeof(S390TopologySocket),
> +    .class_init    = socket_class_init,
> +    .interfaces = (InterfaceInfo[]) {
> +        { TYPE_HOTPLUG_HANDLER },
> +        { }
> +    }
> +};
> +
> +static char *book_bus_get_dev_path(DeviceState *dev)
> +{
> +    return g_strdup("00");
> +}
> +
> +static void book_bus_class_init(ObjectClass *oc, void *data)
> +{
> +    BusClass *k = BUS_CLASS(oc);
> +
> +    k->get_dev_path = book_bus_get_dev_path;
> +    k->max_dev = S390_MAX_BOOKS;

Same question as for socket_bus_class_init here.

> +}
> +
> +static const TypeInfo book_bus_info = {
> +    .name = TYPE_S390_TOPOLOGY_BOOK_BUS,
> +    .parent = TYPE_BUS,
> +    .instance_size = 0,
> +    .class_init = book_bus_class_init,
> +};
> +
> +static void s390_book_device_realize(DeviceState *dev, Error **errp)
> +{
> +    S390TopologyBook *book = S390_TOPOLOGY_BOOK(dev);
> +    BusState *bus;
> +
> +    bus = qbus_new(TYPE_S390_TOPOLOGY_BOOK_BUS, dev,
> +                   TYPE_S390_TOPOLOGY_BOOK_BUS);
> +    qbus_set_hotplug_handler(bus, OBJECT(dev));
> +    book->bus = bus;
> +}
> +
> +static void book_class_init(ObjectClass *oc, void *data)
> +{
> +    DeviceClass *dc = DEVICE_CLASS(oc);
> +    HotplugHandlerClass *hc = HOTPLUG_HANDLER_CLASS(oc);
> +
> +    hc->unplug = qdev_simple_device_unplug_cb;
> +    set_bit(DEVICE_CATEGORY_BRIDGE, dc->categories);
> +    dc->realize = s390_book_device_realize;
> +    dc->desc = "topology book";
> +}
> +
> +static const TypeInfo book_info = {
> +    .name          = TYPE_S390_TOPOLOGY_BOOK,
> +    .parent        = TYPE_SYS_BUS_DEVICE,
> +    .instance_size = sizeof(S390TopologyBook),
> +    .class_init    = book_class_init,
> +    .interfaces = (InterfaceInfo[]) {
> +        { TYPE_HOTPLUG_HANDLER },
> +        { }
> +    }
> +};
> +
> +static void topology_register(void)
> +{
> +    type_register_static(&cpu_cores_info);
> +    type_register_static(&socket_bus_info);
> +    type_register_static(&socket_info);
> +    type_register_static(&book_bus_info);
> +    type_register_static(&book_info);
> +}
> +
> +type_init(topology_register);
> diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
> index feefe0717e..3592fa952b 100644
> --- a/hw/s390x/meson.build
> +++ b/hw/s390x/meson.build
> @@ -2,6 +2,7 @@ s390x_ss = ss.source_set()
>  s390x_ss.add(files(
>    'ap-bridge.c',
>    'ap-device.c',
> +  'cpu-topology.c',
>    'ccw-device.c',
>    'css-bridge.c',
>    'css.c',
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index cc3097bfee..a586875b24 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -43,6 +43,7 @@
>  #include "sysemu/sysemu.h"
>  #include "hw/s390x/pv.h"
>  #include "migration/blocker.h"
> +#include "hw/s390x/cpu-topology.h"
>  
>  static Error *pv_mig_blocker;
>  
> @@ -89,6 +90,7 @@ static void s390_init_cpus(MachineState *machine)
>      /* initialize possible_cpus */
>      mc->possible_cpu_arch_ids(machine);
>  
> +    s390_topology_setup(machine);
>      for (i = 0; i < machine->smp.cpus; i++) {
>          s390x_new_cpu(machine->cpu_type, i, &error_fatal);
>      }
> @@ -306,6 +308,10 @@ static void s390_cpu_plug(HotplugHandler *hotplug_dev,
>      g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
>      ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
>  
> +    if (!s390_topology_new_cpu(ms, cpu->env.core_id, errp)) {
> +        return;
> +    }
> +
>      if (dev->hotplugged) {
>          raise_irq_cpu_hotplug();
>      }
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> new file mode 100644
> index 0000000000..beec61706c
> --- /dev/null
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -0,0 +1,74 @@
> +/*
> + * CPU Topology
> + *
> + * Copyright 2022 IBM Corp.

Same issue as with .c copyright notice.
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +#ifndef HW_S390X_CPU_TOPOLOGY_H
> +#define HW_S390X_CPU_TOPOLOGY_H
> +
> +#include "hw/qdev-core.h"
> +#include "qom/object.h"
> +
> +#define S390_TOPOLOGY_CPU_TYPE    0x03

This is the IFL type, right? If so the name should reflect it.
> +
> +#define S390_TOPOLOGY_POLARITY_H  0x00
> +#define S390_TOPOLOGY_POLARITY_VL 0x01
> +#define S390_TOPOLOGY_POLARITY_VM 0x02
> +#define S390_TOPOLOGY_POLARITY_VH 0x03

Why not use an enum?
> +
> +#define TYPE_S390_TOPOLOGY_CORES "topology cores"

Seems to me that using a - instead of a space is the usual way of doing things.
> +    /*
> +     * Each CPU inside a socket will be represented by a bit in a 64bit
> +     * unsigned long. Set on plug and clear on unplug of a CPU.
> +     * All CPU inside a mask share the same dedicated, polarity and
> +     * cputype values.
> +     * The origin is the offset of the first CPU in a mask.
> +     */
> +struct S390TopologyCores {
> +    DeviceState parent_obj;
> +    int id;
> +    bool dedicated;
> +    uint8_t polarity;
> +    uint8_t cputype;

Why not snake_case for cpu type?

> +    uint16_t origin;
> +    uint64_t mask;
> +    int cnt;

num_cores instead ?

> +};
> +typedef struct S390TopologyCores S390TopologyCores;
> +OBJECT_DECLARE_SIMPLE_TYPE(S390TopologyCores, S390_TOPOLOGY_CORES)
> +
> +#define TYPE_S390_TOPOLOGY_SOCKET "topology socket"
> +#define TYPE_S390_TOPOLOGY_SOCKET_BUS "socket-bus"
> +struct S390TopologySocket {
> +    DeviceState parent_obj;
> +    BusState *bus;
> +    int socket_id;
> +    int cnt;
> +};
> +typedef struct S390TopologySocket S390TopologySocket;
> +OBJECT_DECLARE_SIMPLE_TYPE(S390TopologySocket, S390_TOPOLOGY_SOCKET)
> +#define S390_MAX_SOCKETS 4
> +
> +#define TYPE_S390_TOPOLOGY_BOOK "topology book"
> +#define TYPE_S390_TOPOLOGY_BOOK_BUS "book-bus"
> +struct S390TopologyBook {
> +    SysBusDevice parent_obj;
> +    BusState *bus;
> +    int book_id;
> +    int cnt;
> +};
> +typedef struct S390TopologyBook S390TopologyBook;
> +OBJECT_DECLARE_SIMPLE_TYPE(S390TopologyBook, S390_TOPOLOGY_BOOK)
> +#define S390_MAX_BOOKS 1
> +
> +S390TopologyBook *s390_init_topology(void);
> +
> +S390TopologyBook *s390_get_topology(void);
> +void s390_topology_setup(MachineState *ms);
> +bool s390_topology_new_cpu(MachineState *ms, int core_id, Error **errp);
> +
> +#endif
> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index 7d6d01325b..216adfde26 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h

I think these definitions should be moved to the STSI patch since they're not used in this one.

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

I don't like this union, it's only used in SysIB_151x below and that's misleading,
because the entries are packed without padding, but the union members have different
sizes.

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
> +    uint8_t  res0[2];
> +    uint16_t length;
> +    uint8_t  mag[TOPOLOGY_NR_MAG];
> +    uint8_t  res1;
> +    uint8_t  mnest;
> +    uint32_t res2;
> +    SysIBTl_entry tle[0];

I think this should just be a uint64_t[] or uint64_t[0], whichever is QEMU style.
> +} SysIB_151x;
> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
> +
>  /* MMU defines */
>  #define ASCE_ORIGIN           (~0xfffULL) /* segment table origin             */
>  #define ASCE_SUBSPACE         0x200       /* subspace group control           */


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C4E4DA918
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 04:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243311AbiCPDzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 23:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239609AbiCPDzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 23:55:19 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A28329A9
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 20:54:04 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KJGV83C0wzcbG9;
        Wed, 16 Mar 2022 11:49:04 +0800 (CST)
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 11:54:01 +0800
Subject: Re: [PATCH v6 06/11] s390x: topology: Adding books to CPU topology
To:     Pierre Morel <pmorel@linux.ibm.com>, <qemu-s390x@nongnu.org>
CC:     <qemu-devel@nongnu.org>, <borntraeger@de.ibm.com>,
        <pasic@linux.ibm.com>, <richard.henderson@linaro.org>,
        <david@redhat.com>, <thuth@redhat.com>, <cohuck@redhat.com>,
        <mst@redhat.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>,
        <philmd@redhat.com>, <eblake@redhat.com>, <armbru@redhat.com>,
        <seiden@linux.ibm.com>, <nrb@linux.ibm.com>
References: <20220217134125.132150-1-pmorel@linux.ibm.com>
 <20220217134125.132150-7-pmorel@linux.ibm.com>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <e096c7d9-e081-a798-9ead-7e28de10a890@huawei.com>
Date:   Wed, 16 Mar 2022 11:54:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20220217134125.132150-7-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Pierre,

On 2022/2/17 21:41, Pierre Morel wrote:
> S390 CPU topology may have up to 5 topology containers.
> The first container above the cores is level 2, the sockets.
> We introduce here the books, book is the level containing sockets.
>
> Let's add books, level3, containers to the CPU topology.
>
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   hw/core/machine-smp.c      | 29 ++++++++++++++++++++++-------
>   hw/core/machine.c          |  2 ++
>   hw/s390x/s390-virtio-ccw.c |  1 +
>   include/hw/boards.h        |  4 ++++
>   qapi/machine.json          |  7 ++++++-
>   softmmu/vl.c               |  3 +++
>   6 files changed, 38 insertions(+), 8 deletions(-)
>
> diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
> index b39ed21e65..d7aa39d540 100644
> --- a/hw/core/machine-smp.c
> +++ b/hw/core/machine-smp.c
> @@ -31,6 +31,10 @@ static char *cpu_hierarchy_to_string(MachineState *ms)
>       MachineClass *mc = MACHINE_GET_CLASS(ms);
>       GString *s = g_string_new(NULL);
>   
> +    if (mc->smp_props.books_supported) {
> +        g_string_append_printf(s, " * books (%u)", ms->smp.books);
> +    }
> +
>       g_string_append_printf(s, "sockets (%u)", ms->smp.sockets);
>   
Now books become the top level container, string format for sockets should
be tweaked as " * sockets (%u)". Also we need to cut off the " * " at 
the head
of the composite topology string.
>       if (mc->smp_props.dies_supported) {
> @@ -73,6 +77,7 @@ void machine_parse_smp_config(MachineState *ms,
>   {
>       MachineClass *mc = MACHINE_GET_CLASS(ms);
>       unsigned cpus    = config->has_cpus ? config->cpus : 0;
> +    unsigned books   = config->has_books ? config->books : 0;
>       unsigned sockets = config->has_sockets ? config->sockets : 0;
>       unsigned dies    = config->has_dies ? config->dies : 0;
>       unsigned clusters = config->has_clusters ? config->clusters : 0;
> @@ -85,6 +90,7 @@ void machine_parse_smp_config(MachineState *ms,
>        * explicit configuration like "cpus=0" is not allowed.
>        */
>       if ((config->has_cpus && config->cpus == 0) ||
> +        (config->has_books && config->books == 0) ||
>           (config->has_sockets && config->sockets == 0) ||
>           (config->has_dies && config->dies == 0) ||
>           (config->has_clusters && config->clusters == 0) ||
> @@ -111,6 +117,13 @@ void machine_parse_smp_config(MachineState *ms,
>       dies = dies > 0 ? dies : 1;
>       clusters = clusters > 0 ? clusters : 1;
>   
> +    if (!mc->smp_props.books_supported && books > 1) {
> +        error_setg(errp, "books not supported by this machine's CPU topology");
> +        return;
> +    }
nit: maybe move above part to the similar sanity checks of "dies and 
clusters"?...
> +
> +    books = books > 0 ? books : 1;
...and put this line together with the similar operation of "dies and 
clusters"
> +
>       /* compute missing values based on the provided ones */
>       if (cpus == 0 && maxcpus == 0) {
>           sockets = sockets > 0 ? sockets : 1;
> @@ -124,33 +137,35 @@ void machine_parse_smp_config(MachineState *ms,
>               if (sockets == 0) {
>                   cores = cores > 0 ? cores : 1;
>                   threads = threads > 0 ? threads : 1;
> -                sockets = maxcpus / (dies * clusters * cores * threads);
> +                sockets = maxcpus / (books * dies * clusters * cores * threads);
>               } else if (cores == 0) {
>                   threads = threads > 0 ? threads : 1;
> -                cores = maxcpus / (sockets * dies * clusters * threads);
> +                cores = maxcpus / (books * sockets * dies * clusters * threads);
>               }
>           } else {
>               /* prefer cores over sockets since 6.2 */
>               if (cores == 0) {
>                   sockets = sockets > 0 ? sockets : 1;
>                   threads = threads > 0 ? threads : 1;
> -                cores = maxcpus / (sockets * dies * clusters * threads);
> +                cores = maxcpus / (books * sockets * dies * clusters * threads);
>               } else if (sockets == 0) {
>                   threads = threads > 0 ? threads : 1;
> -                sockets = maxcpus / (dies * clusters * cores * threads);
> +                sockets = maxcpus / (books * dies * clusters * cores * threads);
>               }
>           }
>   
>           /* try to calculate omitted threads at last */
>           if (threads == 0) {
> -            threads = maxcpus / (sockets * dies * clusters * cores);
> +            threads = maxcpus / (books * sockets * dies * clusters * cores);
>           }
>       }
>   
> -    maxcpus = maxcpus > 0 ? maxcpus : sockets * dies * clusters * cores * threads;
> +    maxcpus = maxcpus > 0 ? maxcpus : books * sockets * dies *
> +                                      clusters * cores * threads;
>       cpus = cpus > 0 ? cpus : maxcpus;
>   
>       ms->smp.cpus = cpus;
> +    ms->smp.books = books;
>       ms->smp.sockets = sockets;
>       ms->smp.dies = dies;
>       ms->smp.clusters = clusters;
> @@ -159,7 +174,7 @@ void machine_parse_smp_config(MachineState *ms,
>       ms->smp.max_cpus = maxcpus;
>   
>       /* sanity-check of the computed topology */
> -    if (sockets * dies * clusters * cores * threads != maxcpus) {
> +    if (books * sockets * dies * clusters * cores * threads != maxcpus) {
>           g_autofree char *topo_msg = cpu_hierarchy_to_string(ms);
>           error_setg(errp, "Invalid CPU topology: "
>                      "product of the hierarchy must match maxcpus: "
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index d856485cb4..b8c624d2bf 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -743,6 +743,7 @@ static void machine_get_smp(Object *obj, Visitor *v, const char *name,
>       MachineState *ms = MACHINE(obj);
>       SMPConfiguration *config = &(SMPConfiguration){
>           .has_cpus = true, .cpus = ms->smp.cpus,
> +        .has_books = true, .books = ms->smp.books,
>           .has_sockets = true, .sockets = ms->smp.sockets,
>           .has_dies = true, .dies = ms->smp.dies,
>           .has_clusters = true, .clusters = ms->smp.clusters,
> @@ -935,6 +936,7 @@ static void machine_initfn(Object *obj)
>       /* default to mc->default_cpus */
>       ms->smp.cpus = mc->default_cpus;
>       ms->smp.max_cpus = mc->default_cpus;
> +    ms->smp.books = 1;
>       ms->smp.sockets = 1;
>       ms->smp.dies = 1;
>       ms->smp.clusters = 1;
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 12903eb2af..193883fba3 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -666,6 +666,7 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
>       hc->unplug_request = s390_machine_device_unplug_request;
>       nc->nmi_monitor_handler = s390_nmi;
>       mc->default_ram_id = "s390.ram";
> +    mc->smp_props.books_supported = true;
>   }
>   
>   static inline bool machine_get_aes_key_wrap(Object *obj, Error **errp)
> diff --git a/include/hw/boards.h b/include/hw/boards.h
> index c92ac8815c..bc0f7f22dc 100644
> --- a/include/hw/boards.h
> +++ b/include/hw/boards.h
> @@ -130,11 +130,13 @@ typedef struct {
>    * @prefer_sockets - whether sockets are preferred over cores in smp parsing
>    * @dies_supported - whether dies are supported by the machine
>    * @clusters_supported - whether clusters are supported by the machine
> + * @books_supported - whether books are supported by the machine
>    */
>   typedef struct {
>       bool prefer_sockets;
>       bool dies_supported;
>       bool clusters_supported;
> +    bool books_supported;
>   } SMPCompatProps;
>   
>   /**
> @@ -299,6 +301,7 @@ typedef struct DeviceMemoryState {
>   /**
>    * CpuTopology:
>    * @cpus: the number of present logical processors on the machine
> + * @books: the number of books on the machine
>    * @sockets: the number of sockets on the machine
I think we may also need to modify the documentation of "sockets"
accordingly, like "sockets: the number of sockets in one book" simply?
We already have some explanation in qemu-options.hx implying that:
machines will have their own meanings of each topology member
if they have different supported topology hierarchies.
>    * @dies: the number of dies in one socket
>    * @clusters: the number of clusters in one die
> @@ -308,6 +311,7 @@ typedef struct DeviceMemoryState {
>    */
>   typedef struct CpuTopology {
>       unsigned int cpus;
> +    unsigned int books;
>       unsigned int sockets;
>       unsigned int dies;
>       unsigned int clusters;
> diff --git a/qapi/machine.json b/qapi/machine.json
> index 42fc68403d..73206f811a 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -866,12 +866,13 @@
>   # a CPU is being hotplugged.
>   #
>   # @node-id: NUMA node ID the CPU belongs to
> +# @book-id: book number within node/board the CPU belongs to
>   # @socket-id: socket number within node/board the CPU belongs to
>   # @die-id: die number within socket the CPU belongs to (since 4.1)
>   # @core-id: core number within die the CPU belongs to
>   # @thread-id: thread number within core the CPU belongs to
>   #
> -# Note: currently there are 5 properties that could be present
> +# Note: currently there are 6 properties that could be present
>   #       but management should be prepared to pass through other
>   #       properties with device_add command to allow for future
>   #       interface extension. This also requires the filed names to be kept in
> @@ -881,6 +882,7 @@
>   ##
>   { 'struct': 'CpuInstanceProperties',
>     'data': { '*node-id': 'int',
> +            '*book-id': 'int',
>               '*socket-id': 'int',
>               '*die-id': 'int',
>               '*core-id': 'int',
> @@ -1400,6 +1402,8 @@
>   #
>   # @cpus: number of virtual CPUs in the virtual machine
>   #
> +# @books: number of books in the CPU topology
> +#
>   # @sockets: number of sockets in the CPU topology
here too: maybe "number of sockets per book in the CPU topology".
>   #
>   # @dies: number of dies per socket in the CPU topology
> @@ -1416,6 +1420,7 @@
>   ##
>   { 'struct': 'SMPConfiguration', 'data': {
>        '*cpus': 'int',
> +     '*books': 'int',
>        '*sockets': 'int',
>        '*dies': 'int',
>        '*clusters': 'int',
> diff --git a/softmmu/vl.c b/softmmu/vl.c
> index 5e1b35ba48..a680fb12d4 100644
> --- a/softmmu/vl.c
> +++ b/softmmu/vl.c
> @@ -720,6 +720,9 @@ static QemuOptsList qemu_smp_opts = {
>           {
>               .name = "cpus",
>               .type = QEMU_OPT_NUMBER,
> +        }, {
> +            .name = "books",
> +            .type = QEMU_OPT_NUMBER,
>           }, {
>               .name = "sockets",
>               .type = QEMU_OPT_NUMBER,
Thanks,
Yanan

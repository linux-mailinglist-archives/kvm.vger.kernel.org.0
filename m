Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D41A4BA2CF
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 15:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241841AbiBQOVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 09:21:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241830AbiBQOVi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 09:21:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 596722B165B
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645107681;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=4O0+CQbK6wk9fkyoPo8Iv9tdOs7BtuKcNBkdCn4J6FQ=;
        b=Y85TTGtgqZma5QeRdlpyZQAfNT/cuL1GltT2g3u7MbkGAVy7eqIVrp4ngOnjRcEIO/g1lc
        0Xw+xE6CbpByIfFuT+nHEM0Xw1Gh76mjmZjKXLwrccyfnYgAXEvFvKub32xKFJd6ssnFbe
        jokDqpVPELYjmIzYsYHdlHw0h0tq8lA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-yQ5WYX7IOua0JuB1Exikhw-1; Thu, 17 Feb 2022 09:21:17 -0500
X-MC-Unique: yQ5WYX7IOua0JuB1Exikhw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5A862F4F;
        Thu, 17 Feb 2022 14:21:02 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 13B3470D40;
        Thu, 17 Feb 2022 14:20:22 +0000 (UTC)
Date:   Thu, 17 Feb 2022 14:20:20 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     qemu-s390x@nongnu.org, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        david@redhat.com, eblake@redhat.com, cohuck@redhat.com,
        richard.henderson@linaro.org, qemu-devel@nongnu.org,
        armbru@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, philmd@redhat.com
Subject: Re: [PATCH v6 08/11] s390x: topology: Adding drawers to CPU topology
Message-ID: <Yg5ZpEisMK1uWqQH@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220217134125.132150-1-pmorel@linux.ibm.com>
 <20220217134125.132150-9-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220217134125.132150-9-pmorel@linux.ibm.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 17, 2022 at 02:41:22PM +0100, Pierre Morel wrote:
> S390 CPU topology may have up to 5 topology containers.
> The first container above the cores is level 2, the sockets,
> and the level 3, containing sockets are the books.
> 
> We introduce here the drawers, drawers is the level containing books.
> 
> Let's add drawers, level4, containers to the CPU topology.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  hw/core/machine-smp.c      | 33 ++++++++++++++++++++++++++-------
>  hw/core/machine.c          |  2 ++
>  hw/s390x/s390-virtio-ccw.c |  1 +
>  include/hw/boards.h        |  4 ++++
>  qapi/machine.json          |  7 ++++++-
>  softmmu/vl.c               |  3 +++
>  6 files changed, 42 insertions(+), 8 deletions(-)

Needs to update -smp args in qemu-options.hx too.

> 
> diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
> index d7aa39d540..26150c748f 100644
> --- a/hw/core/machine-smp.c
> +++ b/hw/core/machine-smp.c
> @@ -31,6 +31,10 @@ static char *cpu_hierarchy_to_string(MachineState *ms)
>      MachineClass *mc = MACHINE_GET_CLASS(ms);
>      GString *s = g_string_new(NULL);
>  
> +    if (mc->smp_props.drawers_supported) {
> +        g_string_append_printf(s, " * drawers (%u)", ms->smp.drawers);
> +    }
> +
>      if (mc->smp_props.books_supported) {
>          g_string_append_printf(s, " * books (%u)", ms->smp.books);
>      }
> @@ -77,6 +81,7 @@ void machine_parse_smp_config(MachineState *ms,
>  {
>      MachineClass *mc = MACHINE_GET_CLASS(ms);
>      unsigned cpus    = config->has_cpus ? config->cpus : 0;
> +    unsigned drawers = config->has_drawers ? config->drawers : 0;
>      unsigned books   = config->has_books ? config->books : 0;
>      unsigned sockets = config->has_sockets ? config->sockets : 0;
>      unsigned dies    = config->has_dies ? config->dies : 0;
> @@ -90,6 +95,7 @@ void machine_parse_smp_config(MachineState *ms,
>       * explicit configuration like "cpus=0" is not allowed.
>       */
>      if ((config->has_cpus && config->cpus == 0) ||
> +        (config->has_drawers && config->drawers == 0) ||
>          (config->has_books && config->books == 0) ||
>          (config->has_sockets && config->sockets == 0) ||
>          (config->has_dies && config->dies == 0) ||
> @@ -124,6 +130,13 @@ void machine_parse_smp_config(MachineState *ms,
>  
>      books = books > 0 ? books : 1;
>  
> +    if (!mc->smp_props.drawers_supported && drawers > 1) {
> +        error_setg(errp, "drawers not supported by this machine's CPU topology");
> +        return;
> +    }
> +
> +    drawers = drawers > 0 ? drawers : 1;
> +
>      /* compute missing values based on the provided ones */
>      if (cpus == 0 && maxcpus == 0) {
>          sockets = sockets > 0 ? sockets : 1;
> @@ -137,34 +150,40 @@ void machine_parse_smp_config(MachineState *ms,
>              if (sockets == 0) {
>                  cores = cores > 0 ? cores : 1;
>                  threads = threads > 0 ? threads : 1;
> -                sockets = maxcpus / (books * dies * clusters * cores * threads);
> +                sockets = maxcpus /
> +                          (drawers * books * dies * clusters * cores * threads);
>              } else if (cores == 0) {
>                  threads = threads > 0 ? threads : 1;
> -                cores = maxcpus / (books * sockets * dies * clusters * threads);
> +                cores = maxcpus /
> +                        (drawers * books * sockets * dies * clusters * threads);
>              }
>          } else {
>              /* prefer cores over sockets since 6.2 */
>              if (cores == 0) {
>                  sockets = sockets > 0 ? sockets : 1;
>                  threads = threads > 0 ? threads : 1;
> -                cores = maxcpus / (books * sockets * dies * clusters * threads);
> +                cores = maxcpus /
> +                        (drawers * books * sockets * dies * clusters * threads);
>              } else if (sockets == 0) {
>                  threads = threads > 0 ? threads : 1;
> -                sockets = maxcpus / (books * dies * clusters * cores * threads);
> +                sockets = maxcpus /
> +                         (drawers * books * dies * clusters * cores * threads);
>              }
>          }
>  
>          /* try to calculate omitted threads at last */
>          if (threads == 0) {
> -            threads = maxcpus / (books * sockets * dies * clusters * cores);
> +            threads = maxcpus /
> +                      (drawers * books * sockets * dies * clusters * cores);
>          }
>      }
>  
> -    maxcpus = maxcpus > 0 ? maxcpus : books * sockets * dies *
> +    maxcpus = maxcpus > 0 ? maxcpus : drawers * books * sockets * dies *
>                                        clusters * cores * threads;
>      cpus = cpus > 0 ? cpus : maxcpus;
>  
>      ms->smp.cpus = cpus;
> +    ms->smp.drawers = drawers;
>      ms->smp.books = books;
>      ms->smp.sockets = sockets;
>      ms->smp.dies = dies;
> @@ -174,7 +193,7 @@ void machine_parse_smp_config(MachineState *ms,
>      ms->smp.max_cpus = maxcpus;
>  
>      /* sanity-check of the computed topology */
> -    if (books * sockets * dies * clusters * cores * threads != maxcpus) {
> +    if (drawers * books * sockets * dies * clusters * cores * threads != maxcpus) {
>          g_autofree char *topo_msg = cpu_hierarchy_to_string(ms);
>          error_setg(errp, "Invalid CPU topology: "
>                     "product of the hierarchy must match maxcpus: "
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index b8c624d2bf..1db55e36c8 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -743,6 +743,7 @@ static void machine_get_smp(Object *obj, Visitor *v, const char *name,
>      MachineState *ms = MACHINE(obj);
>      SMPConfiguration *config = &(SMPConfiguration){
>          .has_cpus = true, .cpus = ms->smp.cpus,
> +        .has_drawers = true, .drawers = ms->smp.drawers,
>          .has_books = true, .books = ms->smp.books,
>          .has_sockets = true, .sockets = ms->smp.sockets,
>          .has_dies = true, .dies = ms->smp.dies,
> @@ -936,6 +937,7 @@ static void machine_initfn(Object *obj)
>      /* default to mc->default_cpus */
>      ms->smp.cpus = mc->default_cpus;
>      ms->smp.max_cpus = mc->default_cpus;
> +    ms->smp.drawers = 1;
>      ms->smp.books = 1;
>      ms->smp.sockets = 1;
>      ms->smp.dies = 1;
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 193883fba3..03829e90b3 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -667,6 +667,7 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
>      nc->nmi_monitor_handler = s390_nmi;
>      mc->default_ram_id = "s390.ram";
>      mc->smp_props.books_supported = true;
> +    mc->smp_props.drawers_supported = true;
>  }
>  
>  static inline bool machine_get_aes_key_wrap(Object *obj, Error **errp)
> diff --git a/include/hw/boards.h b/include/hw/boards.h
> index bc0f7f22dc..abc5556c50 100644
> --- a/include/hw/boards.h
> +++ b/include/hw/boards.h
> @@ -131,12 +131,14 @@ typedef struct {
>   * @dies_supported - whether dies are supported by the machine
>   * @clusters_supported - whether clusters are supported by the machine
>   * @books_supported - whether books are supported by the machine
> + * @drawers_supported - whether drawers are supported by the machine
>   */
>  typedef struct {
>      bool prefer_sockets;
>      bool dies_supported;
>      bool clusters_supported;
>      bool books_supported;
> +    bool drawers_supported;
>  } SMPCompatProps;
>  
>  /**
> @@ -301,6 +303,7 @@ typedef struct DeviceMemoryState {
>  /**
>   * CpuTopology:
>   * @cpus: the number of present logical processors on the machine
> + * @drawers: the number of drawers on the machine
>   * @books: the number of books on the machine
>   * @sockets: the number of sockets on the machine
>   * @dies: the number of dies in one socket
> @@ -311,6 +314,7 @@ typedef struct DeviceMemoryState {
>   */
>  typedef struct CpuTopology {
>      unsigned int cpus;
> +    unsigned int drawers;
>      unsigned int books;
>      unsigned int sockets;
>      unsigned int dies;
> diff --git a/qapi/machine.json b/qapi/machine.json
> index 73206f811a..fa6bde5617 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -866,13 +866,14 @@
>  # a CPU is being hotplugged.
>  #
>  # @node-id: NUMA node ID the CPU belongs to
> +# @drawer-id: drawer number within node/board the CPU belongs to
>  # @book-id: book number within node/board the CPU belongs to
>  # @socket-id: socket number within node/board the CPU belongs to

So the lack of change here implies that 'socket-id' is unique
across multiple  books/drawers. Is that correct, as its differnt
from semantics for die-id/core-id/thread-id which are scoped
to within the next level of the topology ?

>  # @die-id: die number within socket the CPU belongs to (since 4.1)
>  # @core-id: core number within die the CPU belongs to
>  # @thread-id: thread number within core the CPU belongs to
>  #
> -# Note: currently there are 6 properties that could be present
> +# Note: currently there are 7 properties that could be present
>  #       but management should be prepared to pass through other
>  #       properties with device_add command to allow for future
>  #       interface extension. This also requires the filed names to be kept in
> @@ -882,6 +883,7 @@
>  ##
>  { 'struct': 'CpuInstanceProperties',
>    'data': { '*node-id': 'int',
> +            '*drawer-id': 'int',
>              '*book-id': 'int',
>              '*socket-id': 'int',
>              '*die-id': 'int',

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


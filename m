Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53E668BCBB
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 13:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBFMWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 07:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBFMWK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 07:22:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E501DBF4
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 04:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675686085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lF8bAZFZXmbZU/DEPVYqJZCSZJdql8fkjSoGPpbGjv4=;
        b=OE9tsl3jkpz9c814YPLaWYY0iHzqqpsvZXBazsNS4iN13O07999aPSCW5GLFhy6vblW1Bx
        xFRgu6/03CW5lKpi+JPxnBEocMyYrnFk/ix/XwZT7uoF08OT85ccJMP76VifjXohKVViVO
        7h1i64w7rg9aIh1XMTFIO9yQHnIx2YQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-654-kr0xLbWUOCCVusMax2oHPg-1; Mon, 06 Feb 2023 07:21:23 -0500
X-MC-Unique: kr0xLbWUOCCVusMax2oHPg-1
Received: by mail-qk1-f198.google.com with SMTP id j29-20020a05620a001d00b00724fd33cb3eso7739915qki.14
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 04:21:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lF8bAZFZXmbZU/DEPVYqJZCSZJdql8fkjSoGPpbGjv4=;
        b=YbixjCI8LK6KahMQwSEShQtr9MWspOhvNLkI+lCv3WbvtPRgpM4/CAk+NyGEqqvpfC
         egwlynISRQG+1ix1uhbjTGsr7O0o7vBYkxL+K/WfNGrZVvPDZ/aqWydHF79r+8G9C5IX
         J9Bl6sfC87C/k6aEtfl1fnvWjllc53GcK5HFBFsbSWMg1Pwh65D+SLSayXvJGGzI9sD7
         pRJZ/MaaH7xH/u5UWAwv+7mLwtYLjjPlwp8LkmnSLSJ164oZnDAGOwqBbo2M2nqgL5nY
         7DMxk9Yl9ieKmIL/htmTBSm1CwBZkq0b3U28+M+j1VySUREvzxdAyZQRAMYivosatIbV
         bOBw==
X-Gm-Message-State: AO0yUKV92EnLmIuImpu0vlsMwel1bAVyWmx3BAerYaV2LHCnbiZOS7hK
        Il628ZYlSbO1PYdL5hcBvJNNw9bBthLkQqSPLfUvnvFz+Aq4uJfXi9z0qI8lHIy07zSqDfX4hXu
        xAXfByNqlAW+v
X-Received: by 2002:a05:6214:21af:b0:56b:ebd3:efcc with SMTP id t15-20020a05621421af00b0056bebd3efccmr12340093qvc.25.1675686083178;
        Mon, 06 Feb 2023 04:21:23 -0800 (PST)
X-Google-Smtp-Source: AK7set/VPQWGibD8aEi4WBu4BFREupPLLP5lYGhLm6W7wz/1lYz1CUv9+AexzZjBA2em0/R37jPsiA==
X-Received: by 2002:a05:6214:21af:b0:56b:ebd3:efcc with SMTP id t15-20020a05621421af00b0056bebd3efccmr12340070qvc.25.1675686082893;
        Mon, 06 Feb 2023 04:21:22 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-71.web.vodafone.de. [109.43.177.71])
        by smtp.gmail.com with ESMTPSA id x11-20020a05620a448b00b0072c01a3b6aasm7401405qkp.100.2023.02.06.04.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 04:21:22 -0800 (PST)
Message-ID: <92f02547-569f-2ea8-455b-585dcfaa2a74@redhat.com>
Date:   Mon, 6 Feb 2023 13:21:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-9-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v15 08/11] qapi/s390x/cpu topology: x-set-cpu-topology
 monitor command
In-Reply-To: <20230201132051.126868-9-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/2023 14.20, Pierre Morel wrote:
> The modification of the CPU attributes are done through a monitor
> command.
> 
> It allows to move the core inside the topology tree to optimise

I'm not a native speaker, but "optimize" is more common, I think?

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

Hmm, below you do something like that:

     if (!has_polarity) {
         polarity = POLARITY_VERTICAL_MEDIUM;
     }

... so it rather seems like medium polarity is the default? ... that looks 
weird. I think you should maybe rather pass the has_polarity and 
has_dedication flags to the s390_change_topology() function and only change 
the value if they have really been provided?

> +# @dedicated: optional, if the vCPU is dedicated to a real CPU
> +#
> +# Modifies the topology by moving the CPU inside the topology
> +# tree or by changing a modifier attribute of a CPU.
> +#
> +# Returns: Nothing on success, the reason on failure.
> +#
> +# Since: <next qemu stable release, eg. 1.0>

Please replace with "Since: 8.0" ... I hope we'll get it merged during this 
cycle!

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

I think you should add a sanity check for core_id being in a valid range ... 
otherwise this will cause an access beyond the end of the array if core_id 
is too big or negative.

> +    if (!cpu) {
> +        error_setg(errp, "Core-id %ld does not exist!", core_id);
> +        return;
> +    }
> +
> +    /* Verify the new topology */
> +    s390_topology_check(cpu, errp);
> +    if (*errp) {
> +        return;
> +    }
> +
> +    /* Move the CPU into its new socket */
> +    s390_set_core_in_socket(cpu, drawer_id, book_id, socket_id, true, errp);
> +
> +    /* All checks done, report topology in environment */
> +    cpu->env.drawer_id = drawer_id;
> +    cpu->env.book_id = book_id;
> +    cpu->env.socket_id = socket_id;
> +    cpu->env.dedicated = dedicated;
> +    cpu->env.entitlement = polarity;

As mentioned above, I think dedicated and polarity should only be changed if 
they have really been provided?

> +    /* topology tree is reflected in props */
> +    s390_update_cpu_props(ms, cpu);
> +
> +    /* Advertise the topology change */
> +    s390_cpu_topology_set_modified();
> +}
> +
> +void qmp_x_set_cpu_topology(int64_t core, int64_t socket,
> +                         int64_t book, int64_t drawer,
> +                         bool has_polarity, int64_t polarity,
> +                         bool has_dedicated, bool dedicated,
> +                         Error **errp)
> +{
> +    ERRP_GUARD();
> +
> +    if (!s390_has_topology()) {
> +        error_setg(errp, "This machine doesn't support topology");
> +        return;
> +    }
> +    if (!has_polarity) {
> +        polarity = POLARITY_VERTICAL_MEDIUM;
> +    }
> +    if (!has_dedicated) {
> +        dedicated = false;
> +    }
> +    s390_change_topology(core, socket, book, drawer, polarity, dedicated, errp);
> +}
> +
> +void hmp_x_set_cpu_topology(Monitor *mon, const QDict *qdict)
> +{
> +    const int64_t core = qdict_get_int(qdict, "core");
> +    const int64_t socket = qdict_get_int(qdict, "socket");
> +    const int64_t book = qdict_get_int(qdict, "book");
> +    const int64_t drawer = qdict_get_int(qdict, "drawer");
> +    bool has_polarity    = qdict_haskey(qdict, "polarity");
> +    const int64_t polarity = qdict_get_try_int(qdict, "polarity", 0);
> +    bool has_dedicated    = qdict_haskey(qdict, "dedicated");
> +    const bool dedicated = qdict_get_try_bool(qdict, "dedicated", false);
> +    Error *local_err = NULL;
> +
> +    qmp_x_set_cpu_topology(core, socket, book, drawer,
> +                           has_polarity, polarity,
> +                           has_dedicated, dedicated,
> +                           &local_err);
> +    if (hmp_handle_error(mon, local_err)) {
> +        return;
> +    }
> +}
> diff --git a/hmp-commands.hx b/hmp-commands.hx
> index 673e39a697..bb3c908356 100644
> --- a/hmp-commands.hx
> +++ b/hmp-commands.hx
> @@ -1815,3 +1815,19 @@ SRST
>     Dump the FDT in dtb format to *filename*.
>   ERST
>   #endif
> +
> +#if defined(TARGET_S390X) && defined(CONFIG_KVM)
> +    {
> +        .name       = "x-set-cpu-topology",
> +        .args_type  = "core:l,socket:l,book:l,drawer:l,polarity:l?,dedicated:b?",
> +        .params     = "core socket book drawer [polarity] [dedicated]",
> +        .help       = "Move CPU 'core' to 'socket/book/drawer' "
> +                      "optionaly modifies polarity and dedication",

optionaly ==> optionally

> +        .cmd        = hmp_x_set_cpu_topology,
> +    },
> +
> +SRST
> +``x-set-cpu-topology`` *core* *socket* *book* *drawer* *polarity* *dedicated*
> +  Moves the CPU  *core* to *socket* *book* *drawer* with *polarity* *dedicated*.
> +ERST
> +#endif

  Thomas


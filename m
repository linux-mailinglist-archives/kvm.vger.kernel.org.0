Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A5C663F57
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 12:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbjAJLiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 06:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbjAJLiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 06:38:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDF552779
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 03:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673350641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pu3RT7qcowUmDiVIh0NP56qSN2EZOoXQWqlASCWWjk8=;
        b=JorSKB3mde9+46I/E4g/O7w/Irfoos8HESg0pKi3FKVPYPPuR2xBJUGCJv9gSCIknvvrBL
        OVFKuoe3e3g6cDd0dMiHOfgxNc9ect4zXsmFt0N5l5FlQm4lqFrojqa9muELmk8xWh2Zqf
        II+0+yXzRZwCxhm9/IExfgdYS0KTpiw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-15-4DnVy_oWMdmQ0S8P2hb5dA-1; Tue, 10 Jan 2023 06:37:20 -0500
X-MC-Unique: 4DnVy_oWMdmQ0S8P2hb5dA-1
Received: by mail-qk1-f197.google.com with SMTP id i4-20020a05620a248400b006febc1651bbso8519497qkn.4
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 03:37:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pu3RT7qcowUmDiVIh0NP56qSN2EZOoXQWqlASCWWjk8=;
        b=Sjfbzto4U7RYNXLxY/7d+WwfZZPsp0Y+V8BT5Vqg4nkGB5I1JMcNvHpPfXt+j9DYUh
         S6s9nxWl9aiKEOeFobDftOaJ3YQDm74ecuXlSYrFHxqDz+x/kOY+WED8jISJO7k+nfZe
         z0ZoOjT0KGgHTG+tCNcQKftZeLvVh9cKrOHlepRRqAOd/tU/yfEqB6MhiEusyn8isADV
         D64S4KvJHzC1+D74RmJuOuwlyjJMOOEW3OWLh12vLoT2jjrTtb1XZGHRr7gMg/FHdwj5
         jZV9b7GDRyMMe6pvVbiK0HuJGanGSyWv8t5n3dyrVITgML9iOBzEVWVzTREu7emQXdFj
         SCmA==
X-Gm-Message-State: AFqh2kowlCk2DS5+BD5p9bavI+YluE4aXyM7GqwL2COxU7mYNX87yQAq
        gdu6EPgbKFo1iHjcNb8dEMicLSudkE/y2OfxWJBiON7F/XDxKhwODEZwugDzRso4WuLO4CYIb/b
        Jh4v7+YfvkOJi
X-Received: by 2002:ac8:5297:0:b0:3a6:9cfa:d6c with SMTP id s23-20020ac85297000000b003a69cfa0d6cmr3903574qtn.39.1673350639806;
        Tue, 10 Jan 2023 03:37:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu7DuRgMqmzRXitL9iQyjAQmifcaCoSY8opYmE9WcFM8y9fFzrdT1BVHJ39hSaikGWjrGSm3w==
X-Received: by 2002:ac8:5297:0:b0:3a6:9cfa:d6c with SMTP id s23-20020ac85297000000b003a69cfa0d6cmr3903544qtn.39.1673350639559;
        Tue, 10 Jan 2023 03:37:19 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-179-237.web.vodafone.de. [109.43.179.237])
        by smtp.gmail.com with ESMTPSA id x10-20020a05620a448a00b006faa2c0100bsm7025280qkp.110.2023.01.10.03.37.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 03:37:19 -0800 (PST)
Message-ID: <49d343fb-f41d-455a-8630-3db2650cfcd5@redhat.com>
Date:   Tue, 10 Jan 2023 12:37:09 +0100
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
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-2-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v14 01/11] s390x/cpu topology: adding s390 specificities
 to CPU topology
In-Reply-To: <20230105145313.168489-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/01/2023 15.53, Pierre Morel wrote:
> S390 adds two new SMP levels, drawers and books to the CPU
> topology.
> The S390 CPU have specific toplogy features like dedication
> and polarity to give to the guest indications on the host
> vCPUs scheduling and help the guest take the best decisions
> on the scheduling of threads on the vCPUs.
> 
> Let us provide the SMP properties with books and drawers levels
> and S390 CPU with dedication and polarity,
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
> diff --git a/qapi/machine.json b/qapi/machine.json
> index b9228a5e46..ff8f2b0e84 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -900,13 +900,15 @@
>   # a CPU is being hotplugged.
>   #
>   # @node-id: NUMA node ID the CPU belongs to
> -# @socket-id: socket number within node/board the CPU belongs to
> +# @drawer-id: drawer number within node/board the CPU belongs to
> +# @book-id: book number within drawer/node/board the CPU belongs to
> +# @socket-id: socket number within book/node/board the CPU belongs to

I think the new entries need a "(since 8.0)" comment (similar to die-id and 
cluster-id below).

Other question: Do we have "node-id"s on s390x? If not, is that similar to 
books or drawers, i.e. just another word? If so, we should maybe rather 
re-use "nodes" instead of introducing a new name for the same thing?

>   # @die-id: die number within socket the CPU belongs to (since 4.1)
>   # @cluster-id: cluster number within die the CPU belongs to (since 7.1)
>   # @core-id: core number within cluster the CPU belongs to
>   # @thread-id: thread number within core the CPU belongs to
>   #
> -# Note: currently there are 6 properties that could be present
> +# Note: currently there are 8 properties that could be present
>   #       but management should be prepared to pass through other
>   #       properties with device_add command to allow for future
>   #       interface extension. This also requires the filed names to be kept in
> @@ -916,6 +918,8 @@
>   ##
>   { 'struct': 'CpuInstanceProperties',
>     'data': { '*node-id': 'int',
> +            '*drawer-id': 'int',
> +            '*book-id': 'int',
>               '*socket-id': 'int',
>               '*die-id': 'int',
>               '*cluster-id': 'int',
> @@ -1465,6 +1469,10 @@
>   #
>   # @cpus: number of virtual CPUs in the virtual machine
>   #
> +# @drawers: number of drawers in the CPU topology
> +#
> +# @books: number of books in the CPU topology
> +#

These also need a "(since 8.0)" comment at the end.

>   # @sockets: number of sockets in the CPU topology
>   #
>   # @dies: number of dies per socket in the CPU topology
> @@ -1481,6 +1489,8 @@
>   ##
>   { 'struct': 'SMPConfiguration', 'data': {
>        '*cpus': 'int',
> +     '*drawers': 'int',
> +     '*books': 'int',
>        '*sockets': 'int',
>        '*dies': 'int',
>        '*clusters': 'int',
...
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 7f99d15b23..8dc9a4c052 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -250,11 +250,13 @@ SRST
>   ERST
>   
>   DEF("smp", HAS_ARG, QEMU_OPTION_smp,
> -    "-smp [[cpus=]n][,maxcpus=maxcpus][,sockets=sockets][,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]\n"
> +    "-smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets][,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]\n"

This line now got too long. Please add a newline inbetween.

>       "                set the number of initial CPUs to 'n' [default=1]\n"
>       "                maxcpus= maximum number of total CPUs, including\n"
>       "                offline CPUs for hotplug, etc\n"
> -    "                sockets= number of sockets on the machine board\n"
> +    "                drawers= number of drawers on the machine board\n"
> +    "                books= number of books in one drawer\n"
> +    "                sockets= number of sockets in one book\n"
>       "                dies= number of dies in one socket\n"
>       "                clusters= number of clusters in one die\n"
>       "                cores= number of cores in one cluster\n"

  Thomas


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD6F6F024D
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 10:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242777AbjD0IF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 04:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242675AbjD0IFY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 04:05:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EA54684
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 01:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682582659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R36dlmlB7mS4Q+5i4QZDZFJ2WCUffsynJFMD103cOFM=;
        b=D6cUeqbnyGKWIY1AXs+6PkCRMpJsLG/npJ/3/5P6UiCjojAfCtkLouv76CT+DADfHpUupf
        JPgSyF0mXow6KSU3eSNUZEWReVRHBZ0ZF1J/r/xeqLDulkWI8Zc+Ys1McK+LNvlKDR3Uf0
        5MP1VGTHGkz0miFLrm8i8ADT22WhN38=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-KUIpq8RgMCWrGrOc59Icaw-1; Thu, 27 Apr 2023 04:04:17 -0400
X-MC-Unique: KUIpq8RgMCWrGrOc59Icaw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-301110f1756so2988516f8f.0
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 01:04:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682582656; x=1685174656;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R36dlmlB7mS4Q+5i4QZDZFJ2WCUffsynJFMD103cOFM=;
        b=XYYyP7MrLdwt4N8EQcQknSReX1IVfcYf1GamJwu7Y642FdFnfb61SgpsIbCbaKjoct
         ISDmkhs65hEwnI9LmEi9Ih2+jK/gSvFWh8XWxszyNsSrxF5VFZOkY2vrPkCnLol7qLdX
         CEgFSf+6NyrEvjA1WEmnaYbdOJlIeTOBCofxsmSGdEv+GT5VxkpozJTTmRIwAi6dqhb1
         mSdIZ2sb/PYtjpV2viWHZbBbMIZKV+zXY88v7dcERfEFJ3+PTHn2UUiZw2A1U7qkXvj2
         y+WA8FlHqI4F7nd3xKOQ8b1eS1Jnkfpu5pe+0i++hEE+a+gORozWKxHHOrQ/gitpaJH9
         JkpA==
X-Gm-Message-State: AC+VfDwFD5Ai1yMmPr2GJn8n63cNLVxkcnrjuZ4JUQBbSt4X7nqynarw
        Zvc9WF203iU8uL0VGeUdyampy7J18bQb0BiuB8KRtC+5q37bKVlwBAicroX4Sk4haGvtjaZw/Eg
        pjtTgCc0NCLe/65nPNdER
X-Received: by 2002:a5d:474a:0:b0:2cf:efc7:19ad with SMTP id o10-20020a5d474a000000b002cfefc719admr575919wrs.53.1682582656434;
        Thu, 27 Apr 2023 01:04:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4nVcazw8m5wVRp5FQUk5kfDzYaCyFFT7YJ2VExk+yhU598C2ZQJMln+TwZ9wHCxJsfS15UqA==
X-Received: by 2002:a5d:474a:0:b0:2cf:efc7:19ad with SMTP id o10-20020a5d474a000000b002cfefc719admr575892wrs.53.1682582656101;
        Thu, 27 Apr 2023 01:04:16 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id i3-20020adff303000000b002f4cf72fce6sm17882206wro.46.2023.04.27.01.04.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 01:04:15 -0700 (PDT)
Message-ID: <45e09800-6a47-0372-5244-16e2dc72370d@redhat.com>
Date:   Thu, 27 Apr 2023 10:04:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-2-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v20 01/21] s390x/cpu topology: add s390 specifics to CPU
 topology
In-Reply-To: <20230425161456.21031-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/04/2023 18.14, Pierre Morel wrote:
> S390 adds two new SMP levels, drawers and books to the CPU
> topology.
> The S390 CPU have specific topology features like dedication
> and entitlement to give to the guest indications on the host
> vCPUs scheduling and help the guest take the best decisions
> on the scheduling of threads on the vCPUs.
> 
> Let us provide the SMP properties with books and drawers levels
> and S390 CPU with dedication and entitlement,
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index 2e267fa458..42a6a40333 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -342,3 +342,15 @@
>                      'TARGET_S390X',
>                      'TARGET_MIPS',
>                      'TARGET_LOONGARCH64' ] } }
> +
> +##
> +# @CpuS390Polarization:
> +#
> +# An enumeration of cpu polarization that can be assumed by a virtual
> +# S390 CPU
> +#
> +# Since: 8.1
> +##
> +{ 'enum': 'CpuS390Polarization',
> +  'prefix': 'S390_CPU_POLARIZATION',
> +  'data': [ 'horizontal', 'vertical' ] }

It seems like you don't need this here yet ... I think you likely could also 
introduce it in a later patch instead (patch 11 seems the first one that 
needs this?)

Also, would a " 'if': 'TARGET_S390X' " be possible here, too?

> diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
> index c3dab007da..77bee06304 100644
> --- a/hw/core/machine-smp.c
> +++ b/hw/core/machine-smp.c
> @@ -30,8 +30,19 @@ static char *cpu_hierarchy_to_string(MachineState *ms)
>   {
>       MachineClass *mc = MACHINE_GET_CLASS(ms);
>       GString *s = g_string_new(NULL);
> +    const char *multiply = " * ", *prefix = "";
>   
> -    g_string_append_printf(s, "sockets (%u)", ms->smp.sockets);
> +    if (mc->smp_props.drawers_supported) {
> +        g_string_append_printf(s, "drawers (%u)", ms->smp.drawers);
> +        prefix = multiply;

That "prefix" stuff looks complicated ... why don't you simply add the "*" 
at the end of the strings:

     g_string_append_printf(s, "drawers (%u) * ",
                            ms->smp.drawers);

?

> +    }
> +
> +    if (mc->smp_props.books_supported) {
> +        g_string_append_printf(s, "%sbooks (%u)", prefix, ms->smp.books);
> +        prefix = multiply;
> +    }
> +
> +    g_string_append_printf(s, "%ssockets (%u)", prefix, ms->smp.sockets);

... it's followed by "sockets" here anyway, so adding the " * " at the end 
of the strings above should be fine.

>   {
>       MachineClass *mc = MACHINE_GET_CLASS(ms);
>       unsigned cpus    = config->has_cpus ? config->cpus : 0;
> +    unsigned drawers = config->has_drawers ? config->drawers : 0;
> +    unsigned books   = config->has_books ? config->books : 0;
>       unsigned sockets = config->has_sockets ? config->sockets : 0;
>       unsigned dies    = config->has_dies ? config->dies : 0;
>       unsigned clusters = config->has_clusters ? config->clusters : 0;
> @@ -85,6 +98,8 @@ void machine_parse_smp_config(MachineState *ms,
>        * explicit configuration like "cpus=0" is not allowed.
>        */
>       if ((config->has_cpus && config->cpus == 0) ||
> +        (config->has_drawers && config->drawers == 0) ||
> +        (config->has_books && config->books == 0) ||
>           (config->has_sockets && config->sockets == 0) ||
>           (config->has_dies && config->dies == 0) ||
>           (config->has_clusters && config->clusters == 0) ||
> @@ -111,6 +126,19 @@ void machine_parse_smp_config(MachineState *ms,
>       dies = dies > 0 ? dies : 1;
>       clusters = clusters > 0 ? clusters : 1;
>   
> +    if (!mc->smp_props.books_supported && books > 1) {
> +        error_setg(errp, "books not supported by this machine's CPU topology");
> +        return;
> +    }
> +    books = books > 0 ? books : 1;

Could be shortened to:  book = books ?: 1;

> +    if (!mc->smp_props.drawers_supported && drawers > 1) {
> +        error_setg(errp,
> +                   "drawers not supported by this machine's CPU topology");
> +        return;
> +    }
> +    drawers = drawers > 0 ? drawers : 1;

Could be shortened to:  drawers = drawers ?: 1;

>       /* compute missing values based on the provided ones */
>       if (cpus == 0 && maxcpus == 0) {
>           sockets = sockets > 0 ? sockets : 1;
> @@ -124,33 +152,41 @@ void machine_parse_smp_config(MachineState *ms,
>               if (sockets == 0) {
>                   cores = cores > 0 ? cores : 1;
>                   threads = threads > 0 ? threads : 1;
> -                sockets = maxcpus / (dies * clusters * cores * threads);
> +                sockets = maxcpus /
> +                          (drawers * books * dies * clusters * cores * threads);
>               } else if (cores == 0) {
>                   threads = threads > 0 ? threads : 1;
> -                cores = maxcpus / (sockets * dies * clusters * threads);
> +                cores = maxcpus /
> +                        (drawers * books * sockets * dies * clusters * threads);
>               }

(not very important, but I wonder whether we should maybe disallow 
"prefer_sockets" with drawers and books instead of updating the calculation 
here - since prefer_sockets should only occur on old machine types)

>           } else {
>               /* prefer cores over sockets since 6.2 */
>               if (cores == 0) {
>                   sockets = sockets > 0 ? sockets : 1;
>                   threads = threads > 0 ? threads : 1;
> -                cores = maxcpus / (sockets * dies * clusters * threads);
> +                cores = maxcpus /
> +                        (drawers * books * sockets * dies * clusters * threads);
>               } else if (sockets == 0) {
>                   threads = threads > 0 ? threads : 1;
> -                sockets = maxcpus / (dies * clusters * cores * threads);
> +                sockets = maxcpus /
> +                          (drawers * books * dies * clusters * cores * threads);
>               }
>           }

  Thomas


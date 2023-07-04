Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7CC87471D1
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 14:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjGDMyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 08:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjGDMyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 08:54:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071EEAB
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 05:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688475196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5gv9HGmY8HQzine5JaTlmnV/WU8UAbenpmmWeOB2mpU=;
        b=ZyzfOTRTJgrIMciBNdShIv52cCos79obdbB+Sq6Si8p59S1J2mS7LF2B/hSV4gIRB5tVCy
        H/IjiU4ZNkvIaWKGYyoL+blRCqnrDYHaqcX/t/Blmfg/R//dnvxyaM0tudrSo/1DfzBQo2
        pKI2uOpD4jMQCxaoTABhqB3Ozzd5PsQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-98mo7wlvNxydCLWXPAfnFw-1; Tue, 04 Jul 2023 08:53:15 -0400
X-MC-Unique: 98mo7wlvNxydCLWXPAfnFw-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7659b44990eso471924985a.1
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 05:53:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688475195; x=1691067195;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5gv9HGmY8HQzine5JaTlmnV/WU8UAbenpmmWeOB2mpU=;
        b=Tzs+LL00y0e5ck3ZdN/cZ8D9RS/Nzg/wcEgbDblVetN1IcrYdOIQ4aTF2xnd/Vy5xS
         c1yG3Z0nugL28sH1CQ5XQdTY/b1PoV+H8aPGMQYJuMQnBarj6ckcHdCYpql5EFpdlgET
         V3upHApeS39cgd30Z5w/Fc2hBvG3Jfy9FiADpezYaKyMVMlF64YR2woHLs4Nnf/oD3ZW
         FyRn09jQx+bFWvrKz8r8T8HIfB6uyN0HG9p4UBRDHC8lAsRoCScgbHv6E/XChgXOWI4r
         WC8zexP9TBL0x8u5S1rb2Omp5nDpJp2pJquuy9w2vsfWvwXthBku3Ebt1hp+fYD8dmkm
         drAQ==
X-Gm-Message-State: ABy/qLYMEZvi/+xVAjrst2T9ZSCcOi2xG+VjaKAYA8PtvAbnwQZ35dM6
        4Hn75tmV4ZEHt4+LHCkZq1AWyotLdZCtWurl+H29yOnoz71J+fRS5j7NC6H4LrImAuNmxu39prn
        QVeb8NW2KjP4w
X-Received: by 2002:a05:620a:4256:b0:767:671b:250f with SMTP id w22-20020a05620a425600b00767671b250fmr6019965qko.52.1688475194743;
        Tue, 04 Jul 2023 05:53:14 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHBHZONvVUo6PrOi1MhSBFRGXvvjHRDOV5dqgTxiM2wZNipNp4ex5aVvF7nOAPLkv+myc0jSQ==
X-Received: by 2002:a05:620a:4256:b0:767:671b:250f with SMTP id w22-20020a05620a425600b00767671b250fmr6019948qko.52.1688475194480;
        Tue, 04 Jul 2023 05:53:14 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-126.web.vodafone.de. [109.43.179.126])
        by smtp.gmail.com with ESMTPSA id q26-20020ae9e41a000000b0076722cbcb97sm6762245qkc.33.2023.07.04.05.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 05:53:14 -0700 (PDT)
Message-ID: <7d1797ba-7e19-2fc8-535f-66f3d3aaaa75@redhat.com>
Date:   Tue, 4 Jul 2023 14:53:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v21 08/20] qapi/s390x/cpu topology: set-cpu-topology qmp
 command
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-9-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230630091752.67190-9-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/2023 11.17, Pierre Morel wrote:
> The modification of the CPU attributes are done through a monitor
> command.
> 
> It allows to move the core inside the topology tree to optimize
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
> The command has a feature unstable for the moment.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index 1af70a5049..dfc4cb42a4 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -23,6 +23,7 @@
>   #include "target/s390x/cpu.h"
>   #include "hw/s390x/s390-virtio-ccw.h"
>   #include "hw/s390x/cpu-topology.h"
> +#include "qapi/qapi-commands-machine-target.h"
>   
>   /*
>    * s390_topology is used to keep the topology information.
> @@ -260,6 +261,29 @@ static bool s390_topology_check(uint16_t socket_id, uint16_t book_id,
>       return true;
>   }
>   
> +/**
> + * s390_topology_need_report
> + * @cpu: Current cpu
> + * @drawer_id: future drawer ID
> + * @book_id: future book ID
> + * @socket_id: future socket ID
> + * @entitlement: future entitlement
> + * @dedicated: future dedicated
> + *
> + * A modified topology change report is needed if the topology
> + * tree or the topology attributes change.
> + */
> +static bool s390_topology_need_report(S390CPU *cpu, int drawer_id,
> +                                   int book_id, int socket_id,
> +                                   uint16_t entitlement, bool dedicated)
> +{
> +    return cpu->env.drawer_id != drawer_id ||
> +           cpu->env.book_id != book_id ||
> +           cpu->env.socket_id != socket_id ||
> +           cpu->env.entitlement != entitlement ||
> +           cpu->env.dedicated != dedicated;
> +}
> +
>   /**
>    * s390_update_cpu_props:
>    * @ms: the machine state
> @@ -329,3 +353,113 @@ void s390_topology_setup_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
>       /* topology tree is reflected in props */
>       s390_update_cpu_props(ms, cpu);
>   }
> +
> +static void s390_change_topology(uint16_t core_id,
> +                                 bool has_socket_id, uint16_t socket_id,
> +                                 bool has_book_id, uint16_t book_id,
> +                                 bool has_drawer_id, uint16_t drawer_id,
> +                                 bool has_entitlement,
> +                                 CpuS390Entitlement entitlement,
> +                                 bool has_dedicated, bool dedicated,
> +                                 Error **errp)
> +{
> +    MachineState *ms = current_machine;
> +    int old_socket_entry;
> +    int new_socket_entry;
> +    bool report_needed;
> +    S390CPU *cpu;
> +    ERRP_GUARD();
> +
> +    cpu = s390_cpu_addr2state(core_id);
> +    if (!cpu) {
> +        error_setg(errp, "Core-id %d does not exist!", core_id);
> +        return;
> +    }
> +
> +    /* Get attributes not provided from cpu and verify the new topology */
> +    if (!has_socket_id) {
> +        socket_id = cpu->env.socket_id;
> +    }
> +    if (!has_book_id) {
> +        book_id = cpu->env.book_id;
> +    }
> +    if (!has_drawer_id) {
> +        drawer_id = cpu->env.drawer_id;
> +    }
> +    if (!has_dedicated) {
> +        dedicated = cpu->env.dedicated;
> +    }
> +
> +    /*
> +     * When the user specifies the entitlement as 'auto' on the command line,
> +     * qemu will set the entitlement as:
> +     * Medium when the CPU is not dedicated.
> +     * High when dedicated is true.
> +     */
> +    if (!has_entitlement || (entitlement == S390_CPU_ENTITLEMENT_AUTO)) {
> +        if (dedicated) {
> +            entitlement = S390_CPU_ENTITLEMENT_HIGH;
> +        } else {
> +            entitlement = S390_CPU_ENTITLEMENT_MEDIUM;
> +        }
> +    }
> +
> +    if (!s390_topology_check(socket_id, book_id, drawer_id,
> +                             entitlement, dedicated, errp))
> +        return;

Missing curly braces here.
Not sure why this isn't caught by checkpatch.pl properly :-(

  Thomas


> +    /* Check for space on new socket */
> +    old_socket_entry = s390_socket_nb(cpu);
> +    new_socket_entry = __s390_socket_nb(drawer_id, book_id, socket_id);
> +
> +    if (new_socket_entry != old_socket_entry) {
> +        if (s390_topology.cores_per_socket[new_socket_entry] >=
> +            ms->smp.cores) {
> +            error_setg(errp, "No more space on this socket");
> +            return;
> +        }
> +        /* Update the count of cores in sockets */
> +        s390_topology.cores_per_socket[new_socket_entry] += 1;
> +        s390_topology.cores_per_socket[old_socket_entry] -= 1;
> +    }
> +
> +    /* Check if we will need to report the modified topology */
> +    report_needed = s390_topology_need_report(cpu, drawer_id, book_id,
> +                                              socket_id, entitlement,
> +                                              dedicated);
> +
> +    /* All checks done, report new topology into the vCPU */
> +    cpu->env.drawer_id = drawer_id;
> +    cpu->env.book_id = book_id;
> +    cpu->env.socket_id = socket_id;
> +    cpu->env.dedicated = dedicated;
> +    cpu->env.entitlement = entitlement;
> +
> +    /* topology tree is reflected in props */
> +    s390_update_cpu_props(ms, cpu);
> +
> +    /* Advertise the topology change */
> +    if (report_needed) {
> +        s390_cpu_topology_set_changed(true);
> +    }
> +}
> +
> +void qmp_set_cpu_topology(uint16_t core,
> +                         bool has_socket, uint16_t socket,
> +                         bool has_book, uint16_t book,
> +                         bool has_drawer, uint16_t drawer,
> +                         bool has_entitlement, CpuS390Entitlement entitlement,
> +                         bool has_dedicated, bool dedicated,
> +                         Error **errp)
> +{
> +    ERRP_GUARD();
> +
> +    if (!s390_has_topology()) {
> +        error_setg(errp, "This machine doesn't support topology");
> +        return;
> +    }
> +
> +    s390_change_topology(core, has_socket, socket, has_book, book,
> +                         has_drawer, drawer, has_entitlement, entitlement,
> +                         has_dedicated, dedicated, errp);
> +}


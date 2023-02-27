Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7D66A4391
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 15:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjB0OBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 09:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjB0OBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 09:01:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6ED11284E
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 06:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677506425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jJvrv42+8kO1u4baEkFc/s8k2ZLkeR9CHfUVi0nHTHc=;
        b=VXTNslaar9+26vwLqyD1tcf9NVDitWLvhg7rinwNLwg9BdQih+CO41smmVrUIAjOnsvt1K
        LiC5pd1pqkfoAsiVfkCC2fFbUK8TsVMEL5y2S7v/hsSH6FjQrDRcY2m8tma0PwQc2T6l5M
        UiXfBRO8VR0WI7q3mjk/bZG0sFuNKj4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-623-0-8aBPFzPju4IlHq_0JLsw-1; Mon, 27 Feb 2023 09:00:23 -0500
X-MC-Unique: 0-8aBPFzPju4IlHq_0JLsw-1
Received: by mail-wm1-f70.google.com with SMTP id z6-20020a7bc7c6000000b003e0107732f4so2421066wmk.1
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 06:00:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jJvrv42+8kO1u4baEkFc/s8k2ZLkeR9CHfUVi0nHTHc=;
        b=EN3W7xJ7krSTkRRvkhNI7e8HseLOgXeqkUYkVmfzeraauxap9E52C8KnYI1a11EWsP
         8kJcPq08DClJCgkCyGkvFG/SB/DU1ZkWMSgut0pHPG4D2K9RgNB9atIOHMfptiPzdQVQ
         J6SkrxiFuLjgeTBxf71IPqyjqnknE4c/Pbr9g74SWESnw2iEUYbvlSQttRwMAPUoVsj8
         5fPRUSParv//YlhlVGKiFJQ8b7MTVr2csTxG3r4DMom3nll4Pf4/+GCKxRyBAqHC8Ge3
         oZamYtZnUtb+DALi7LSoUbBKk4153zaIRCZGOhkU1uDjxP7+3omV7UtUURS1NfMEDJtR
         2xxg==
X-Gm-Message-State: AO0yUKXgFESC/QD2tnjJF/b2zISgJBRC+8fXHHTUC3SH3duxXf4F/ETk
        UaZiMqhkwgvVZa5NR/rdtYS1Wo3IIfW0NHIypUh0PtdKg82tH0uHzIgU5oYSmcpaxALVmdT+Rfu
        +t2odFTPuoCVn
X-Received: by 2002:a5d:4642:0:b0:2c7:d575:e8a4 with SMTP id j2-20020a5d4642000000b002c7d575e8a4mr7406373wrs.65.1677506422032;
        Mon, 27 Feb 2023 06:00:22 -0800 (PST)
X-Google-Smtp-Source: AK7set+x3qERT+kFX+PARQu8FHtMg+djDI9i4F1N3cer6PEzyMGpQ5f456gviAU0c/cGGgMrd4XQlw==
X-Received: by 2002:a5d:4642:0:b0:2c7:d575:e8a4 with SMTP id j2-20020a5d4642000000b002c7d575e8a4mr7406349wrs.65.1677506421737;
        Mon, 27 Feb 2023 06:00:21 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-150.web.vodafone.de. [109.43.176.150])
        by smtp.gmail.com with ESMTPSA id z5-20020a5d6545000000b002c5501a5803sm7192314wrv.65.2023.02.27.06.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 06:00:21 -0800 (PST)
Message-ID: <c41ca0c4-3e38-1afa-f113-9f5cb5313995@redhat.com>
Date:   Mon, 27 Feb 2023 15:00:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v16 00/11] s390x: CPU Topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230222142105.84700-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/02/2023 15.20, Pierre Morel wrote:
> Hi,
> 
> No big changes here, some bug corrections and comments modifications
> following Thomas and Nina comments and Daniel and Markus reommandations.
> 
> Implementation discussions
> ==========================
> 
> CPU models
> ----------
> 
> Since the facility 11, S390_FEAT_CONFIGURATION_TOPOLOGY is already
> in the CPU model for old QEMU we could not activate it as usual from
> KVM but needed a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
> Checking and enabling this capability enables facility 11,
> S390_FEAT_CONFIGURATION_TOPOLOGY.
> 
> It is the responsibility of the admin to ensure the same CPU
> model for source and target host in a migration.
> 
> Migration
> ---------
> 
> When the target guest is started, the Multi-processor Topology Change
> Report (MTCR) bit is set during the creation of the vCPU by KVM.
> We do not need to migrate its state, in the worst case, the target
> guest will see the MTCR and actualize its view of the topology
> without necessity, but this will be done only one time.
> 
> Reset
> -----
> 
> Reseting the topology is done during subsystem reset, the
> polarization is reset to horizontal polarization.
> 
> Topology attributes
> -------------------
> 
> The topology attributes are carried by the CPU object and defined
> on object creation.
> In the case the new attributes, socket, book, drawer, dedicated,
> polarity are not provided QEMU provides defaults values.
> 
> - Geometry defaults
>    The geometry default are based on the core-id of the core to
>    fill the geometry in a monotone way starting with drawer 0,
>    book 0, and filling socket 0 with the number of cores per socket,
>    then filling socket 1, socket 2 ... etc until the book is complete
>    and all books until the first drawer is complete before starting with
>    the next drawer.
> 
>    This allows to keep existing start scripts and Libvirt existing
>    interface until it is extended.
> 
> - Modifiers defaults
>    Default polarization is horizontal
>    Default dedication is not dedicated.
> 
> Dynamic topology modification
> -----------------------------
> 
> QAPI interface is extended with:
> - a command: 'x-set-cpu-topology'
> - a query: extension of 'query-cpus-fast'
> - an event: 'CPU_POLARITY_CHANGE'
> 
> The admin may use query-cpus-fast to verify the topology provided
> to the guest and x-set-cpu-topology to modify it.
> 
> The event CPU_POLARITY_CHANGE is sent when the guest successfuly
> uses the PTF(2) instruction to request a polarization change.
> In that case, the admin is supposed to modify the CPU provisioning
> accordingly.
> 
> Testing
> =======
> 
> To use the QEMU patches, you will need Linux V6-rc1 or newer,
> or use the following Linux mainline patches:
> 
> f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report
> 24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function
> 0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF fac..
> 
> Currently this code is for KVM only, I have no idea if it is interesting
> to provide a TCG patch. If ever it will be done in another series.
> 
> Documentation
> =============
> 
> To have a better understanding of the S390x CPU Topology and its
> implementation in QEMU you can have a look at the documentation in the
> last patch of this series.
> 
> The admin will want to match the host and the guest topology, taking
> into account that the guest does not recognize multithreading.
> Consequently, two vCPU assigned to threads of the same real CPU should
> preferably be assigned to the same socket of the guest machine.
> 
> 
> Regards,
> Pierre
> 
> Pierre Morel (11):
>    s390x/cpu topology: add s390 specifics to CPU topology
>    s390x/cpu topology: add topology entries on CPU hotplug
>    target/s390x/cpu topology: handle STSI(15) and build the SYSIB
>    s390x/sclp: reporting the maximum nested topology entries
>    s390x/cpu topology: resetting the Topology-Change-Report
>    s390x/cpu topology: interception of PTF instruction
>    target/s390x/cpu topology: activating CPU topology
>    qapi/s390x/cpu topology: set-cpu-topology monitor command
>    machine: adding s390 topology to query-cpu-fast
>    qapi/s390x/cpu topology: CPU_POLARIZATION_CHANGE qapi event
>    docs/s390x/cpu topology: document s390x cpu topology
> 
>   docs/system/s390x/cpu-topology.rst | 378 ++++++++++++++++++++
>   docs/system/target-s390x.rst       |   1 +
>   qapi/machine-target.json           |  81 +++++
>   qapi/machine.json                  |  37 +-
>   include/hw/boards.h                |  10 +-
>   include/hw/s390x/cpu-topology.h    |  78 +++++
>   include/hw/s390x/s390-virtio-ccw.h |   6 +
>   include/hw/s390x/sclp.h            |   4 +-
>   include/monitor/hmp.h              |   1 +
>   target/s390x/cpu.h                 |  78 +++++
>   target/s390x/kvm/kvm_s390x.h       |   1 +
>   hw/core/machine-qmp-cmds.c         |   2 +
>   hw/core/machine-smp.c              |  48 ++-
>   hw/core/machine.c                  |   4 +
>   hw/s390x/cpu-topology.c            | 534 +++++++++++++++++++++++++++++
>   hw/s390x/s390-virtio-ccw.c         |  27 +-
>   hw/s390x/sclp.c                    |   5 +
>   softmmu/vl.c                       |   6 +
>   target/s390x/cpu-sysemu.c          |  13 +
>   target/s390x/cpu.c                 |   7 +
>   target/s390x/cpu_models.c          |   1 +
>   target/s390x/kvm/cpu_topology.c    | 312 +++++++++++++++++
>   target/s390x/kvm/kvm.c             |  42 ++-
>   hmp-commands.hx                    |  17 +
>   hw/s390x/meson.build               |   1 +
>   qemu-options.hx                    |   7 +-
>   target/s390x/kvm/meson.build       |   3 +-
>   27 files changed, 1685 insertions(+), 19 deletions(-)
>   create mode 100644 docs/system/s390x/cpu-topology.rst
>   create mode 100644 include/hw/s390x/cpu-topology.h
>   create mode 100644 hw/s390x/cpu-topology.c
>   create mode 100644 target/s390x/kvm/cpu_topology.c

Any chance that you could also add some qtests for checking that the 
topology works as expected? I.e. set some topology via the command line, 
then use QMP to check whether all CPUs got the right settings?

  Thomas


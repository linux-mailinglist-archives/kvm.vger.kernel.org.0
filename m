Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFDE6A438D
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 14:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjB0N7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 08:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjB0N7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 08:59:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC098A5E
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 05:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677506317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Cytl4LFTyO/b3WSH3ED6g013VKfbwZbICBl6ySBlAA=;
        b=Fef75gXlcJfQ1/j+Z8GNTbOI/A8DIKyNphzmIm3g/Mfr1tGI7L/eArKcaa5rVB5myP8gCC
        Pk5NE0p8drXRx/neLC8l0pMjUTMSS4G+b1ggCbyWoNkAeOyJdSuiJwJ9sQ9hV8AmS31vQO
        LFjOIljikfEh2ezobLIAos4LZjxx0n0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-31-2rK-g-cxO5qIrhXBNelk0A-1; Mon, 27 Feb 2023 08:58:35 -0500
X-MC-Unique: 2rK-g-cxO5qIrhXBNelk0A-1
Received: by mail-wr1-f69.google.com with SMTP id k6-20020adfc706000000b002c716981a1fso863433wrg.1
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 05:58:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Cytl4LFTyO/b3WSH3ED6g013VKfbwZbICBl6ySBlAA=;
        b=D9hcbh4x4tVkqepJxhv/QYaNzAETyLGw5+TDrHT+WoLSW/Z/REuGppHurOcBEGgelJ
         krNgd0/RsCXoKrrj1wif4v6QwOXknEWQ05bL3b3AlcIF562K1/fIEQlj7b4lu46h9tNH
         XQzperzx2iSPJ67YhiwlQ36HNu1WGORM1UtlWIElhzwlI9KDxaI9mHZTiGqz2cYYfdSg
         0RvfTXDC3wMVuJKCTfz+qQXBVttw+ZN0ACLc+t+Dq5TkfYgDFyh10ye6ZHzqsV37DgeG
         X7jZ3wLy1SFR4UdAMH5XyZy7Yf960ckCFn5CLOqetH0e/msbcgmLtyRe4JAMA2COMSfq
         qk0w==
X-Gm-Message-State: AO0yUKVs7OQP/drQ7j0dc3L3zP7LX80ptcf6LiG9zADcnZtbHIXrO2y5
        wKAR6MIh/Cq0wqKvfLZxxO+JvK1cY4mkRgsV5+1RvCmrtn/gDIUpoRCjjjKzmKQIVKL6JH4Hyy1
        FhjPc4CY+37LI
X-Received: by 2002:a05:600c:3147:b0:3eb:3998:36f7 with SMTP id h7-20020a05600c314700b003eb399836f7mr4262643wmo.8.1677506314743;
        Mon, 27 Feb 2023 05:58:34 -0800 (PST)
X-Google-Smtp-Source: AK7set9O3ZIZm8j7sa8BIOu7+iVt+BHaYaSGlH4jjlUfxMA7T0EmnU/N3Agb9CDj/FtljkeCRftfuw==
X-Received: by 2002:a05:600c:3147:b0:3eb:3998:36f7 with SMTP id h7-20020a05600c314700b003eb399836f7mr4262617wmo.8.1677506314397;
        Mon, 27 Feb 2023 05:58:34 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-150.web.vodafone.de. [109.43.176.150])
        by smtp.gmail.com with ESMTPSA id f7-20020adffcc7000000b002c7163660a9sm7361995wrs.105.2023.02.27.05.58.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 05:58:33 -0800 (PST)
Message-ID: <039b5a0f-4440-324c-d5a7-54e9e1c89ea8@redhat.com>
Date:   Mon, 27 Feb 2023 14:58:32 +0100
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
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-12-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v16 11/11] docs/s390x/cpu topology: document s390x cpu
 topology
In-Reply-To: <20230222142105.84700-12-pmorel@linux.ibm.com>
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

On 22/02/2023 15.21, Pierre Morel wrote:
> Add some basic examples for the definition of cpu topology
> in s390x.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   docs/system/s390x/cpu-topology.rst | 378 +++++++++++++++++++++++++++++
>   docs/system/target-s390x.rst       |   1 +
>   2 files changed, 379 insertions(+)
>   create mode 100644 docs/system/s390x/cpu-topology.rst
> 
> diff --git a/docs/system/s390x/cpu-topology.rst b/docs/system/s390x/cpu-topology.rst
> new file mode 100644
> index 0000000000..d470e28b97
> --- /dev/null
> +++ b/docs/system/s390x/cpu-topology.rst
> @@ -0,0 +1,378 @@
> +CPU topology on s390x
> +=====================
> +
> +Since QEMU 8.0, CPU topology on s390x provides up to 3 levels of
> +topology containers: drawers, books, sockets, defining a tree shaped
> +hierarchy.
> +
> +The socket container contains one or more CPU entries consisting
> +of a bitmap of three dentical CPU attributes:

What do you mean by "dentical" here?

> +- CPU type
> +- polarization entitlement
> +- dedication
> +
> +Note also that since 7.2 threads are no longer supported in the topology
> +and the ``-smp`` command line argument accepts only ``threads=1``.
> +
> +Prerequisites
> +-------------
> +
> +To use CPU topology a Linux QEMU/KVM machine providing the CPU topology facility
> +(STFLE bit 11) is required.
> +
> +However, since this facility has been enabled by default in an early version
> +of QEMU, we use a capability, ``KVM_CAP_S390_CPU_TOPOLOGY``, to notify KVM
> +that QEMU supports CPU topology.

This still sounds like a mix of documentation for the user and documentation 
for developers. The normal user won't know what a KVM capability is and does 
not need to know that QEMU does this automatically under the hood.

If you still want to mention it, I'd maybe rather phrase it like this:

"To use the CPU topology, you need to run with KVM on a s390x host that uses 
the Linux kernel v6.0 or newer (which provide the so-called 
``KVM_CAP_S390_CPU_TOPOLOGY`` capability that allows QEMU to signal the CPU 
topology facility via the so-called STFLE bit 11 to the VM)."

... or something similar?

[...]
> +When a CPU is defined by the ``-device`` command argument, the
> +tree topology attributes must be all defined or all not defined.
> +
> +.. code-block:: bash
> +
> +    -device gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=1
> +
> +or
> +
> +.. code-block:: bash
> +
> +    -device gen16b-s390x-cpu,core-id=1,dedication=true
> +
> +If none of the tree attributes (drawer, book, sockets), are specified
> +for the ``-device`` argument, as for all CPUs defined on the ``-smp``

s/defined on/defined with/ ?

> +command argument the topology tree attributes will be set by simply
> +adding the CPUs to the topology based on the core-id starting with
> +core-0 at position 0 of socket-0, book-0, drawer-0.
> +
> +QEMU will not try to solve collisions and will report an error if the
> +CPU topology, explicitely or implicitely defined on a ``-device``

explicitly or implicitly

> +argument collides with the definition of a CPU implicitely defined

implicitly

> +on the ``-smp`` argument.
> +
> +When the topology modifier attributes are not defined for the
> +``-device`` command argument they takes following default values:
> +
> +- dedication: ``false``
> +- entitlement: ``medium``
> +
> +
> +Hot plug
> +++++++++
> +
> +New CPUs can be plugged using the device_add hmp command as in:
> +
> +.. code-block:: bash
> +
> +  (qemu) device_add gen16b-s390x-cpu,core-id=9
> +
> +The same placement of the CPU is derived from the core-id as described above.
> +
> +The topology can of course be fully defined:
> +
> +.. code-block:: bash
> +
> +    (qemu) device_add gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=1
> +
> +
> +Examples
> +++++++++
> +
> +In the following machine we define 8 sockets with 4 cores each.
> +
> +.. code-block:: bash
> +
> +  $ qemu-system-s390x -m 2G \
> +    -cpu gen16b,ctop=on \
> +    -smp cpus=5,sockets=8,cores=4,maxcpus=32 \
> +    -device host-s390x-cpu,core-id=14 \
> +
> +A new CPUs can be plugged using the device_add hmp command as before:
> +
> +.. code-block:: bash
> +
> +  (qemu) device_add gen16b-s390x-cpu,core-id=9
> +
> +The core-id defines the placement of the core in the topology by
> +starting with core 0 in socket 0 up to maxcpus.
> +
> +In the example above:
> +
> +* There are 5 CPUs provided to the guest with the ``-smp`` command line
> +  They will take the core-ids 0,1,2,3,4
> +  As we have 4 cores in a socket, we have 4 CPUs provided
> +  to the guest in socket 0, with core-ids 0,1,2,3.
> +  The last cpu, with core-id 4, will be on socket 1.
> +
> +* the core with ID 14 provided by the ``-device`` command line will
> +  be placed in socket 3, with core-id 14
> +
> +* the core with ID 9 provided by the ``device_add`` qmp command will
> +  be placed in socket 2, with core-id 9
> +
> +
> +Polarization, entitlement and dedication
> +----------------------------------------
> +
> +Polarization
> +++++++++++++
> +
> +The polarization is an indication given by the ``guest`` to the host
> +that it is able to make use of CPU provisioning information.
> +The guest indicates the polarization by using the PTF instruction.
> +
> +Polarization is define two models of CPU provisioning: horizontal
> +and vertical.
> +
> +The horizontal polarization is the default model on boot and after
> +subsystem reset in which the guest considers all vCPUs being having
> +an equal provisioning of CPUs by the host.
> +
> +In the vertical polarization model the guest can make use of the
> +vCPU entitlement information provided by the host to optimize
> +kernel thread scheduling.
> +
> +A subsystem reset puts all vCPU of the configuration into the
> +horizontal polarization.
> +
> +Entitlement
> ++++++++++++
> +
> +The vertical polarization specifies that guest's vCPU can get

"that *the* guest's vCPU" ?

> +different real CPU provisions:
> +
> +- a vCPU with vertical high entitlement specifies that this
> +  vCPU gets 100% of the real CPU provisioning.
> +
> +- a vCPU with vertical medium entitlement specifies that this
> +  vCPU shares the real CPU with other vCPUs.
> +
> +- a vCPU with vertical low entitlement specifies that this
> +  vCPU only gets real CPU provisioning when no other vCPUs needs it.
> +
> +In the case a vCPU with vertical high entitlement does not use
> +the real CPU, the unused "slack" can be dispatched to other vCPU
> +with medium or low entitlement.
> +
> +The admin specifies a vCPU as ``dedicated`` when the vCPU is fully dedicated
> +to a single real CPU.
> +
> +The dedicated bit is an indication of affinity of a vCPU for a real CPU
> +while the entitlement indicates the sharing or exclusivity of use.
> +
> +Defining the topology on command line
> +-------------------------------------
> +
> +The topology can entirely be defined using -device cpu statements,
> +with the exception of CPU 0 which must be defined with the -smp
> +argument.
> +
> +For example, here we set the position of the cores 1,2,3 to
> +drawer 1, book 1, socket 2 and cores 0,9 and 14 to drawer 0,
> +book 0, socket 0 with all horizontal polarization and not dedicated.
> +The core 4, will be set on its default position on socket 1
> +(since we have 4 core per socket) and we define it with dedication and
> +vertical high entitlement.
> +
> +.. code-block:: bash
> +
> +  $ qemu-system-s390x -m 2G \
> +    -cpu gen16b,ctop=on \
> +    -smp cpus=1,sockets=8,cores=4,maxcpus=32 \
> +    \
> +    -device gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=1 \
> +    -device gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=2 \
> +    -device gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=3 \
> +    \
> +    -device gen16b-s390x-cpu,drawer-id=0,book-id=0,socket-id=0,core-id=9 \
> +    -device gen16b-s390x-cpu,drawer-id=0,book-id=0,socket-id=0,core-id=14 \
> +    \
> +    -device gen16b-s390x-cpu,core-id=4,dedicated=on,polarization=3 \
> +
> +QAPI interface for topology
> +---------------------------
> +
> +Let's start QEMU with the following command:
> +
> +.. code-block:: bash
> +
> + qemu-system-s390x \
> +    -enable-kvm \
> +    -cpu z14,ctop=on \
> +    -smp 1,drawers=3,books=3,sockets=2,cores=2,maxcpus=36 \
> +    \
> +    -device z14-s390x-cpu,core-id=19,polarization=3 \
> +    -device z14-s390x-cpu,core-id=11,polarization=1 \
> +    -device z14-s390x-cpu,core-id=112,polarization=3 \
> +   ...
> +
> +and see the result when using the QAPI interface.
> +
> +addons to query-cpus-fast
> ++++++++++++++++++++++++++
> +
> +The command query-cpus-fast allows the admin to query the topology

I'd just say "allows to query", without "the admin".

> +tree and modifiers for all configured vCPUs.
> +
> +.. code-block:: QMP
> +
> + { "execute": "query-cpus-fast" }
> + {
> +  "return": [
> +    {
> +      "dedicated": false,
> +      "thread-id": 536993,
> +      "props": {
> +        "core-id": 0,
> +        "socket-id": 0,
> +        "drawer-id": 0,
> +        "book-id": 0
> +      },
> +      "cpu-state": "operating",
> +      "entitlement": "medium",
> +      "qom-path": "/machine/unattached/device[0]",
> +      "cpu-index": 0,
> +      "target": "s390x"
> +    },
> +    {
> +      "dedicated": false,
> +      "thread-id": 537003,
> +      "props": {
> +        "core-id": 19,
> +        "socket-id": 1,
> +        "drawer-id": 0,
> +        "book-id": 2
> +      },
> +      "cpu-state": "operating",
> +      "entitlement": "high",
> +      "qom-path": "/machine/peripheral-anon/device[0]",
> +      "cpu-index": 19,
> +      "target": "s390x"
> +    },
> +    {
> +      "dedicated": false,
> +      "thread-id": 537004,
> +      "props": {
> +        "core-id": 11,
> +        "socket-id": 1,
> +        "drawer-id": 0,
> +        "book-id": 1
> +      },
> +      "cpu-state": "operating",
> +      "entitlement": "low",
> +      "qom-path": "/machine/peripheral-anon/device[1]",
> +      "cpu-index": 11,
> +      "target": "s390x"
> +    },
> +    {
> +      "dedicated": true,
> +      "thread-id": 537005,
> +      "props": {
> +        "core-id": 112,
> +        "socket-id": 0,
> +        "drawer-id": 3,
> +        "book-id": 2
> +      },
> +      "cpu-state": "operating",
> +      "entitlement": "high",
> +      "qom-path": "/machine/peripheral-anon/device[2]",
> +      "cpu-index": 112,
> +      "target": "s390x"
> +    }
> +  ]
> + }
> +
> +
> +set-cpu-topology
> +++++++++++++++++
> +
> +The command set-cpu-topology allows the admin to modify the topology

"allows to modify"

> +tree or the topology modifiers of a vCPU in the configuration.
> +
> +.. code-block:: QMP
> +
> + -> { "execute": "set-cpu-topology",
> +      "arguments": {
> +         "core-id": 11,
> +         "socket-id": 0,
> +         "book-id": 0,
> +         "drawer-id": 0,
> +         "entitlement": low,
> +         "dedicated": false
> +      }
> +    }
> + <- {"return": {}}
> +
> +The core-id parameter is the only non optional parameter and every
> +unspecified parameter keeps its previous value.
> +
> +event CPU_POLARIZATION_CHANGE
> ++++++++++++++++++++++++++++++
> +
> +When a guest is requests a modification of the polarization,
> +QEMU sends a CPU_POLARIZATION_CHANGE event.
> +
> +When requesting the change, the guest only specifies horizontal or
> +vertical polarization.
> +It is the job of the admin to set the dedication and fine grained vertical entitlement
> +in response to this event.
> +
> +Note that a vertical polarized dedicated vCPU can only have a high
> +entitlement, this gives 6 possibilities for vCPU polarization:
> +
> +- Horizontal
> +- Horizontal dedicated
> +- Vertical low
> +- Vertical medium
> +- Vertical high
> +- Vertical high dedicated
> +
> +Example of the event received when the guest issues the CPU instruction
> +Perform Topology Function PTF(0) to request an horizontal polarization:
> +
> +.. code-block:: QMP
> +
> + <- { "event": "CPU_POLARIZATION_CHANGE",
> +      "data": { "polarization": 0 },
> +      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }

  Thomas


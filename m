Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBA1747FF4
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 10:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjGEInK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 04:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbjGEImo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 04:42:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A5ACA
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 01:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688546513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wdNrP8dfk3Kph9Hz/PClECdrtpW1/BqpQGymcbZPeJ8=;
        b=W6iHMrXE6SvxArQx6gS6Yx1ikNqtH4+3xVZGassn+8syAofGxRyi5z7kN1hrxxNFEPkx4j
        Iqz1oEKftmBSIdeR454bIwrfeDptXpf9WdY+EtlkdPPSV9Bk4iLCZQmj/3UBZuOTPxyXWl
        Di0GgsMw+hIT4kgp1HMbGrUlPBdT1eo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-X9qUQebwNbG-sxRP-1Mn-w-1; Wed, 05 Jul 2023 04:41:49 -0400
X-MC-Unique: X9qUQebwNbG-sxRP-1Mn-w-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-765de3a3404so764055585a.2
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 01:41:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688546509; x=1691138509;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wdNrP8dfk3Kph9Hz/PClECdrtpW1/BqpQGymcbZPeJ8=;
        b=ENXUfm2Bq3UgyWPnhHDg8+VZcH5cs9Q11DcQRncRwOpjJdGjc4KaVHCqs3xQqP31M6
         Y3j4RS5SJyTdDCk+YCBHxT+2vmqpDfhPoWk35jJDyi3BentlhhQgmB/Mv6NNzP4/xQBr
         J9Yd7HEtB7R6Vxd9vFTiANyvd+bhU+IJ2M+WxVxPybfCC9uJ//tZQS9XJr/367s9hCsX
         3TKxmdqwZdZNOixy3coHDsxqOCv5+nJaq+65iC9rHR4+WG2iTMmvCplMp2++R+hQBmU5
         7ct3PKesvbrLAvhJg7K2rCB1rcGfrsE1QNYrhWxrHPL9Z8dWkKKcmWDTyf2wwHdBJUzU
         bvgw==
X-Gm-Message-State: AC+VfDwQ+DNCbD9DpcswTHN0ciwgwNZrFVqDJEUuKIVvl5l3EBTAbh/J
        Gtc7CM+ksAUomS028HPS3wzTOvLn8i2D/s9seCCvcv2uf27Zm3MH6Ra9TGGYAON1nbLtvQa+Toi
        KeWcd5vYdwmoG
X-Received: by 2002:ae9:df81:0:b0:767:2bbc:fcc7 with SMTP id t123-20020ae9df81000000b007672bbcfcc7mr14631356qkf.14.1688546508916;
        Wed, 05 Jul 2023 01:41:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ71CaVCRrRR6rAohpxhb22V8YOaZAWx/3GRQchHhTTXWU9kQNAREmhAA45MAu/KGLSqmAabOA==
X-Received: by 2002:ae9:df81:0:b0:767:2bbc:fcc7 with SMTP id t123-20020ae9df81000000b007672bbcfcc7mr14631339qkf.14.1688546508543;
        Wed, 05 Jul 2023 01:41:48 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id t2-20020a05620a034200b007674f5c3fcdsm5334544qkm.23.2023.07.05.01.41.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 01:41:47 -0700 (PDT)
Message-ID: <a4fe8fe8-c71e-931b-b86b-94c8673c3236@redhat.com>
Date:   Wed, 5 Jul 2023 10:41:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
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
 <20230630091752.67190-14-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v21 13/20] docs/s390x/cpu topology: document s390x cpu
 topology
In-Reply-To: <20230630091752.67190-14-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/2023 11.17, Pierre Morel wrote:
> Add some basic examples for the definition of cpu topology
> in s390x.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   MAINTAINERS                        |   2 +
>   docs/devel/index-internals.rst     |   1 +
>   docs/devel/s390-cpu-topology.rst   | 170 ++++++++++++++++++++
>   docs/system/s390x/cpu-topology.rst | 240 +++++++++++++++++++++++++++++
>   docs/system/target-s390x.rst       |   1 +
>   5 files changed, 414 insertions(+)
>   create mode 100644 docs/devel/s390-cpu-topology.rst
>   create mode 100644 docs/system/s390x/cpu-topology.rst
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b8d3e8815c..76f236564c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1703,6 +1703,8 @@ S: Supported
>   F: include/hw/s390x/cpu-topology.h
>   F: hw/s390x/cpu-topology.c
>   F: target/s390x/kvm/stsi-topology.c
> +F: docs/devel/s390-cpu-topology.rst
> +F: docs/system/s390x/cpu-topology.rst
>   
>   X86 Machines
>   ------------
> diff --git a/docs/devel/index-internals.rst b/docs/devel/index-internals.rst
> index e1a93df263..6f81df92bc 100644
> --- a/docs/devel/index-internals.rst
> +++ b/docs/devel/index-internals.rst
> @@ -14,6 +14,7 @@ Details about QEMU's various subsystems including how to add features to them.
>      migration
>      multi-process
>      reset
> +   s390-cpu-topology
>      s390-dasd-ipl
>      tracing
>      vfio-migration
> diff --git a/docs/devel/s390-cpu-topology.rst b/docs/devel/s390-cpu-topology.rst
> new file mode 100644
> index 0000000000..cd36476011
> --- /dev/null
> +++ b/docs/devel/s390-cpu-topology.rst
> @@ -0,0 +1,170 @@
> +QAPI interface for S390 CPU topology
> +====================================
> +
> +Let's start QEMU with the following command defining 4 CPUs,

Maybe better something like this:

The following sections will explain the S390 CPU topology with the help of 
exemplary output. For this, let's assume that QEMU has been started with the 
following command, defining 4 CPUs.

?

> +CPU[0] defined by the -smp argument will have default values:
> +
> +.. code-block:: bash
> +
> + qemu-system-s390x \
> +    -enable-kvm \
> +    -cpu z14,ctop=on \
> +    -smp 1,drawers=3,books=3,sockets=2,cores=2,maxcpus=36 \
> +    \
> +    -device z14-s390x-cpu,core-id=19,entitlement=high \
> +    -device z14-s390x-cpu,core-id=11,entitlement=low \
> +    -device z14-s390x-cpu,core-id=112,entitlement=high \
> +   ...
> +
> +and see the result when using the QAPI interface.
...
> +QAPI command: set-cpu-topology
> +------------------------------
> +
> +The command set-cpu-topology allows to modify the topology tree
> +or the topology modifiers of a vCPU in the configuration.
> +
> +.. code-block:: QMP
> +
> +    { "execute": "set-cpu-topology",
> +      "arguments": {
> +         "core-id": 11,
> +         "socket-id": 0,
> +         "book-id": 0,
> +         "drawer-id": 0,
> +         "entitlement": "low",
> +         "dedicated": false
> +      }
> +    }
> +    {"return": {}}
> +
> +The core-id parameter is the only non optional parameter and every
> +unspecified parameter keeps its previous value.
> +
> +QAPI event CPU_POLARIZATION_CHANGE
> +----------------------------------
> +
> +When a guest is requests a modification of the polarization,

Scratch the word "is".

> +QEMU sends a CPU_POLARIZATION_CHANGE event.
...
> diff --git a/docs/system/s390x/cpu-topology.rst b/docs/system/s390x/cpu-topology.rst
> new file mode 100644
> index 0000000000..0535a5d883
> --- /dev/null
> +++ b/docs/system/s390x/cpu-topology.rst
> @@ -0,0 +1,240 @@
> +CPU topology on s390x
> +=====================
> +
> +Since QEMU 8.1, CPU topology on s390x provides up to 3 levels of
> +topology containers: drawers, books, sockets, defining a tree shaped
> +hierarchy.

"drawers, books and sockets. They define a tree-shaped hierarchy."

?

> +The socket container contains one or more CPU entries.

"The socket container has one or more CPU entries." ?

> +Each of these CPU entries consists of a bitmap and three CPU attributes:
> +
> +- CPU type
> +- entitlement
> +- dedication
> +
> +Each bit set in the bitmap correspond to the core-id of a vCPU with
> +matching the three attribute.
> +
> +This documentation provide general information on S390 CPU topology,
> +how to enable it and on the new CPU attributes.
> +For information on how to modify the S390 CPU topology and on how to
> +monitor the polarization change see ``Developer Information``.

It would be nicer to have a proper link here instead. See commit 
d6359e150dbdf84f67add786473fd277a9a442bb for example how to do this in our 
.rst files.

> +Prerequisites
> +-------------
> +
> +To use the CPU topology, you need to run with KVM on a s390x host that
> +uses the Linux kernel v6.0 or newer (which provide the so-called
> +``KVM_CAP_S390_CPU_TOPOLOGY`` capability that allows QEMU to signal the
> +CPU topology facility via the so-called STFLE bit 11 to the VM).
> +
> +Enabling CPU topology
> +---------------------
> +
> +Currently, CPU topology is only enabled in the host model by default.
> +
> +Enabling CPU topology in a CPU model is done by setting the CPU flag
> +``ctop`` to ``on`` like in:
> +
> +.. code-block:: bash
> +
> +   -cpu gen16b,ctop=on
> +
> +Having the topology disabled by default allows migration between
> +old and new QEMU without adding new flags.
> +
> +Default topology usage
> +----------------------
> +
> +The CPU topology can be specified on the QEMU command line
> +with the ``-smp`` or the ``-device`` QEMU command arguments.
> +
> +Note also that since 7.2 threads are no longer supported in the topology
> +and the ``-smp`` command line argument accepts only ``threads=1``.
> +
> +If none of the containers attributes (drawers, books, sockets) are
> +specified for the ``-smp`` flag, the number of these containers
> +is ``1`` .

"Thus the following two options will result in the same topology, for 
example:" ?

> +.. code-block:: bash
> +
> +    -smp cpus=5,drawer=1,books=1,sockets=8,cores=4,maxcpus=32
> +
> +or
> +
> +.. code-block:: bash
> +
> +    -smp cpus=5,sockets=8,cores=4,maxcpus=32
> +
> +When a CPU is defined by the ``-smp`` command argument, its position
> +inside the topology is calculated by adding the CPUs to the topology
> +based on the core-id starting with core-0 at position 0 of socket-0,
> +book-0, drawer-0 and filling all CPUs of socket-0 before to fill socket-1
> +of book-0 and so on up to the last socket of the last book of the last
> +drawer.
> +
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
> +    -device gen16b-s390x-cpu,core-id=1,dedicated=true
> +
> +If none of the tree attributes (drawer, book, sockets), are specified
> +for the ``-device`` argument, as for all CPUs defined with the ``-smp``
> +command argument the topology tree attributes will be set by simply
> +adding the CPUs to the topology based on the core-id starting with
> +core-0 at position 0 of socket-0, book-0, drawer-0.
> +
> +QEMU will not try to solve collisions and will report an error if the
> +CPU topology, explicitly or implicitly defined on a ``-device``
> +argument collides with the definition of a CPU implicitely defined

s/implicitely/implicitly/

> +on the ``-smp`` argument.
> +
> +When the topology modifier attributes are not defined for the
> +``-device`` command argument they takes following default values:
> +
> +- dedicated: ``false``
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

Why quoting guest, but not host? I'd remove the quotes from guest here.

> +that it is able to make use of CPU provisioning information.
> +The guest indicates the polarization by using the PTF instruction.
> +
> +Polarization is define two models of CPU provisioning: horizontal

"Polarization defines ..." ? ... or "Polarization is defined by ..." ?

> +and vertical.
> +
> +The horizontal polarization is the default model on boot and after
> +subsystem reset in which the guest considers all vCPUs being having

scratch "being" ?

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
> +The vertical polarization specifies that the guest's vCPU can get
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
> +The upper level specifies a vCPU as ``dedicated`` when the vCPU is

Using `` quotes will print "dedicated" in monotyped font ... is that what 
you wanted here? AFAIK we're mainly doing that for things that can be typed 
in the terminal, e.g. command line options. So should this use normal quotes 
instead?

> +fully dedicated to a single real CPU.
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
> +book 0, socket 0 without defining entitlement or dedication.
> +The core 4, will be set on its default position on socket 1
> +(since we have 4 core per socket) and we define it as dedicated and
> +with vertical high entitlement.
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
> +    -device gen16b-s390x-cpu,core-id=4,dedicated=on,entitlement=high
> +
> +The entitlement defined for the CPU 4, will only be used after the guest
> +successfully enables vertical polarization by using the PTF instruction.
> diff --git a/docs/system/target-s390x.rst b/docs/system/target-s390x.rst
> index f6f11433c7..94c981e732 100644
> --- a/docs/system/target-s390x.rst
> +++ b/docs/system/target-s390x.rst
> @@ -34,3 +34,4 @@ Architectural features
>   .. toctree::
>      s390x/bootdevices
>      s390x/protvirt
> +   s390x/cpu-topology

  Thomas


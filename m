Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E31750E84
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjGLQ11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbjGLQ1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:27:25 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D613199E
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:27:22 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CGHP8A003170;
        Wed, 12 Jul 2023 16:27:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pdr7lHbeaN0C+o/eXzY0JJHAKqOpaaUp7zshfivyUSE=;
 b=Iyb898CHukP0AsjaFYXwBd6Wtl/+TN4WAc0i7Jvi7F5xmK9qsKxSIhuAQqClCFLnKRgg
 hqnzFEjJhdA4Y0ccojuprZzf5xzyvJ1ODCAbW4UQld6rwMXxGpnMRPKuqjVBraewBM9v
 GmgMx1HzoK+nMxkri33cPGSSzI8dgn6Ya0zxq2TPrZuZ8eSLcIUDTn9HxoL3XEQ/1Jl+
 o+36F/raOp6Ni4yY/wbTfiM5IpkHfKOkJfXM7CeNqjFTbPv3/Bq1zD/hW5jCXFbGepFf
 ikSKjKS5elKYfCDvIy4hVspRBEBQTw4hsUo29mw4Lt90ZhEBcLRpegA0mcaA3egSSmXx gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rsyjkr9p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 16:27:14 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36CGITD8006499;
        Wed, 12 Jul 2023 16:27:14 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rsyjkr9nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 16:27:14 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36C4aiMt000620;
        Wed, 12 Jul 2023 16:27:12 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3rpye5206e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 16:27:12 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36CGR7uA24969976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 16:27:07 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2583F20043;
        Wed, 12 Jul 2023 16:27:07 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DD4520049;
        Wed, 12 Jul 2023 16:27:06 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 12 Jul 2023 16:27:06 +0000 (GMT)
Message-ID: <22b387bb-6bed-7045-5ecc-6d74e0729d7c@linux.ibm.com>
Date:   Wed, 12 Jul 2023 18:27:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v21 13/20] docs/s390x/cpu topology: document s390x cpu
 topology
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-14-pmorel@linux.ibm.com>
 <a4fe8fe8-c71e-931b-b86b-94c8673c3236@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <a4fe8fe8-c71e-931b-b86b-94c8673c3236@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SQFL8aTu8HOFZJ25_YPR2c_5JK8_Wgs_
X-Proofpoint-ORIG-GUID: B0JnH8SZ9QVisYG6EkQloPkEDyDR5rO8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_11,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 clxscore=1015 adultscore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307120144
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/5/23 10:41, Thomas Huth wrote:
> On 30/06/2023 11.17, Pierre Morel wrote:
>> Add some basic examples for the definition of cpu topology
>> in s390x.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   MAINTAINERS                        |   2 +
>>   docs/devel/index-internals.rst     |   1 +
>>   docs/devel/s390-cpu-topology.rst   | 170 ++++++++++++++++++++
>>   docs/system/s390x/cpu-topology.rst | 240 +++++++++++++++++++++++++++++
>>   docs/system/target-s390x.rst       |   1 +
>>   5 files changed, 414 insertions(+)
>>   create mode 100644 docs/devel/s390-cpu-topology.rst
>>   create mode 100644 docs/system/s390x/cpu-topology.rst
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index b8d3e8815c..76f236564c 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1703,6 +1703,8 @@ S: Supported
>>   F: include/hw/s390x/cpu-topology.h
>>   F: hw/s390x/cpu-topology.c
>>   F: target/s390x/kvm/stsi-topology.c
>> +F: docs/devel/s390-cpu-topology.rst
>> +F: docs/system/s390x/cpu-topology.rst
>>     X86 Machines
>>   ------------
>> diff --git a/docs/devel/index-internals.rst 
>> b/docs/devel/index-internals.rst
>> index e1a93df263..6f81df92bc 100644
>> --- a/docs/devel/index-internals.rst
>> +++ b/docs/devel/index-internals.rst
>> @@ -14,6 +14,7 @@ Details about QEMU's various subsystems including 
>> how to add features to them.
>>      migration
>>      multi-process
>>      reset
>> +   s390-cpu-topology
>>      s390-dasd-ipl
>>      tracing
>>      vfio-migration
>> diff --git a/docs/devel/s390-cpu-topology.rst 
>> b/docs/devel/s390-cpu-topology.rst
>> new file mode 100644
>> index 0000000000..cd36476011
>> --- /dev/null
>> +++ b/docs/devel/s390-cpu-topology.rst
>> @@ -0,0 +1,170 @@
>> +QAPI interface for S390 CPU topology
>> +====================================
>> +
>> +Let's start QEMU with the following command defining 4 CPUs,
>
> Maybe better something like this:
>
> The following sections will explain the S390 CPU topology with the 
> help of exemplary output. For this, let's assume that QEMU has been 
> started with the following command, defining 4 CPUs.
>
> ?

Absolutely better.

Thanks


>
>> +CPU[0] defined by the -smp argument will have default values:
>> +
>> +.. code-block:: bash
>> +
>> + qemu-system-s390x \
>> +    -enable-kvm \
>> +    -cpu z14,ctop=on \
>> +    -smp 1,drawers=3,books=3,sockets=2,cores=2,maxcpus=36 \
>> +    \
>> +    -device z14-s390x-cpu,core-id=19,entitlement=high \
>> +    -device z14-s390x-cpu,core-id=11,entitlement=low \
>> +    -device z14-s390x-cpu,core-id=112,entitlement=high \
>> +   ...
>> +
>> +and see the result when using the QAPI interface.
> ...
>> +QAPI command: set-cpu-topology
>> +------------------------------
>> +
>> +The command set-cpu-topology allows to modify the topology tree
>> +or the topology modifiers of a vCPU in the configuration.
>> +
>> +.. code-block:: QMP
>> +
>> +    { "execute": "set-cpu-topology",
>> +      "arguments": {
>> +         "core-id": 11,
>> +         "socket-id": 0,
>> +         "book-id": 0,
>> +         "drawer-id": 0,
>> +         "entitlement": "low",
>> +         "dedicated": false
>> +      }
>> +    }
>> +    {"return": {}}
>> +
>> +The core-id parameter is the only non optional parameter and every
>> +unspecified parameter keeps its previous value.
>> +
>> +QAPI event CPU_POLARIZATION_CHANGE
>> +----------------------------------
>> +
>> +When a guest is requests a modification of the polarization,
>
> Scratch the word "is".


yes


>
>> +QEMU sends a CPU_POLARIZATION_CHANGE event.
> ...
>> diff --git a/docs/system/s390x/cpu-topology.rst 
>> b/docs/system/s390x/cpu-topology.rst
>> new file mode 100644
>> index 0000000000..0535a5d883
>> --- /dev/null
>> +++ b/docs/system/s390x/cpu-topology.rst
>> @@ -0,0 +1,240 @@
>> +CPU topology on s390x
>> +=====================
>> +
>> +Since QEMU 8.1, CPU topology on s390x provides up to 3 levels of
>> +topology containers: drawers, books, sockets, defining a tree shaped
>> +hierarchy.
>
> "drawers, books and sockets. They define a tree-shaped hierarchy."
>
> ?
>
yes, thx


>> +The socket container contains one or more CPU entries.
>
> "The socket container has one or more CPU entries." ?


yes thx


>
>> +Each of these CPU entries consists of a bitmap and three CPU 
>> attributes:
>> +
>> +- CPU type
>> +- entitlement
>> +- dedication
>> +
>> +Each bit set in the bitmap correspond to the core-id of a vCPU with
>> +matching the three attribute.
>> +
>> +This documentation provide general information on S390 CPU topology,
>> +how to enable it and on the new CPU attributes.
>> +For information on how to modify the S390 CPU topology and on how to
>> +monitor the polarization change see ``Developer Information``.
>
> It would be nicer to have a proper link here instead. See commit 
> d6359e150dbdf84f67add786473fd277a9a442bb for example how to do this in 
> our .rst files.
>
>> +Prerequisites
>> +-------------
>> +
>> +To use the CPU topology, you need to run with KVM on a s390x host that
>> +uses the Linux kernel v6.0 or newer (which provide the so-called
>> +``KVM_CAP_S390_CPU_TOPOLOGY`` capability that allows QEMU to signal the
>> +CPU topology facility via the so-called STFLE bit 11 to the VM).
>> +
>> +Enabling CPU topology
>> +---------------------
>> +
>> +Currently, CPU topology is only enabled in the host model by default.
>> +
>> +Enabling CPU topology in a CPU model is done by setting the CPU flag
>> +``ctop`` to ``on`` like in:
>> +
>> +.. code-block:: bash
>> +
>> +   -cpu gen16b,ctop=on
>> +
>> +Having the topology disabled by default allows migration between
>> +old and new QEMU without adding new flags.
>> +
>> +Default topology usage
>> +----------------------
>> +
>> +The CPU topology can be specified on the QEMU command line
>> +with the ``-smp`` or the ``-device`` QEMU command arguments.
>> +
>> +Note also that since 7.2 threads are no longer supported in the 
>> topology
>> +and the ``-smp`` command line argument accepts only ``threads=1``.
>> +
>> +If none of the containers attributes (drawers, books, sockets) are
>> +specified for the ``-smp`` flag, the number of these containers
>> +is ``1`` .
>
> "Thus the following two options will result in the same topology, for 
> example:" ?


Yes thanks


>
>> +.. code-block:: bash
>> +
>> +    -smp cpus=5,drawer=1,books=1,sockets=8,cores=4,maxcpus=32
>> +
>> +or
>> +
>> +.. code-block:: bash
>> +
>> +    -smp cpus=5,sockets=8,cores=4,maxcpus=32
>> +
>> +When a CPU is defined by the ``-smp`` command argument, its position
>> +inside the topology is calculated by adding the CPUs to the topology
>> +based on the core-id starting with core-0 at position 0 of socket-0,
>> +book-0, drawer-0 and filling all CPUs of socket-0 before to fill 
>> socket-1
>> +of book-0 and so on up to the last socket of the last book of the last
>> +drawer.
>> +
>> +When a CPU is defined by the ``-device`` command argument, the
>> +tree topology attributes must be all defined or all not defined.
>> +
>> +.. code-block:: bash
>> +
>> +    -device 
>> gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=1
>> +
>> +or
>> +
>> +.. code-block:: bash
>> +
>> +    -device gen16b-s390x-cpu,core-id=1,dedicated=true
>> +
>> +If none of the tree attributes (drawer, book, sockets), are specified
>> +for the ``-device`` argument, as for all CPUs defined with the ``-smp``
>> +command argument the topology tree attributes will be set by simply
>> +adding the CPUs to the topology based on the core-id starting with
>> +core-0 at position 0 of socket-0, book-0, drawer-0.
>> +
>> +QEMU will not try to solve collisions and will report an error if the
>> +CPU topology, explicitly or implicitly defined on a ``-device``
>> +argument collides with the definition of a CPU implicitely defined
>
> s/implicitely/implicitly/


thx


>
>> +on the ``-smp`` argument.
>> +
>> +When the topology modifier attributes are not defined for the
>> +``-device`` command argument they takes following default values:
>> +
>> +- dedicated: ``false``
>> +- entitlement: ``medium``
>> +
>> +
>> +Hot plug
>> +++++++++
>> +
>> +New CPUs can be plugged using the device_add hmp command as in:
>> +
>> +.. code-block:: bash
>> +
>> +  (qemu) device_add gen16b-s390x-cpu,core-id=9
>> +
>> +The same placement of the CPU is derived from the core-id as 
>> described above.
>> +
>> +The topology can of course be fully defined:
>> +
>> +.. code-block:: bash
>> +
>> +    (qemu) device_add 
>> gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=1
>> +
>> +
>> +Examples
>> +++++++++
>> +
>> +In the following machine we define 8 sockets with 4 cores each.
>> +
>> +.. code-block:: bash
>> +
>> +  $ qemu-system-s390x -m 2G \
>> +    -cpu gen16b,ctop=on \
>> +    -smp cpus=5,sockets=8,cores=4,maxcpus=32 \
>> +    -device host-s390x-cpu,core-id=14 \
>> +
>> +A new CPUs can be plugged using the device_add hmp command as before:
>> +
>> +.. code-block:: bash
>> +
>> +  (qemu) device_add gen16b-s390x-cpu,core-id=9
>> +
>> +The core-id defines the placement of the core in the topology by
>> +starting with core 0 in socket 0 up to maxcpus.
>> +
>> +In the example above:
>> +
>> +* There are 5 CPUs provided to the guest with the ``-smp`` command line
>> +  They will take the core-ids 0,1,2,3,4
>> +  As we have 4 cores in a socket, we have 4 CPUs provided
>> +  to the guest in socket 0, with core-ids 0,1,2,3.
>> +  The last cpu, with core-id 4, will be on socket 1.
>> +
>> +* the core with ID 14 provided by the ``-device`` command line will
>> +  be placed in socket 3, with core-id 14
>> +
>> +* the core with ID 9 provided by the ``device_add`` qmp command will
>> +  be placed in socket 2, with core-id 9
>> +
>> +
>> +Polarization, entitlement and dedication
>> +----------------------------------------
>> +
>> +Polarization
>> +++++++++++++
>> +
>> +The polarization is an indication given by the ``guest`` to the host
>
> Why quoting guest, but not host? I'd remove the quotes from guest here.


OK


>
>> +that it is able to make use of CPU provisioning information.
>> +The guest indicates the polarization by using the PTF instruction.
>> +
>> +Polarization is define two models of CPU provisioning: horizontal
>
> "Polarization defines ..." ? ... or "Polarization is defined by ..." ?


thx


>
>> +and vertical.
>> +
>> +The horizontal polarization is the default model on boot and after
>> +subsystem reset in which the guest considers all vCPUs being having
>
> scratch "being" ?

Thx


>
>> +an equal provisioning of CPUs by the host.
>> +
>> +In the vertical polarization model the guest can make use of the
>> +vCPU entitlement information provided by the host to optimize
>> +kernel thread scheduling.
>> +
>> +A subsystem reset puts all vCPU of the configuration into the
>> +horizontal polarization.
>> +
>> +Entitlement
>> ++++++++++++
>> +
>> +The vertical polarization specifies that the guest's vCPU can get
>> +different real CPU provisions:
>> +
>> +- a vCPU with vertical high entitlement specifies that this
>> +  vCPU gets 100% of the real CPU provisioning.
>> +
>> +- a vCPU with vertical medium entitlement specifies that this
>> +  vCPU shares the real CPU with other vCPUs.
>> +
>> +- a vCPU with vertical low entitlement specifies that this
>> +  vCPU only gets real CPU provisioning when no other vCPUs needs it.
>> +
>> +In the case a vCPU with vertical high entitlement does not use
>> +the real CPU, the unused "slack" can be dispatched to other vCPU
>> +with medium or low entitlement.
>> +
>> +The upper level specifies a vCPU as ``dedicated`` when the vCPU is
>
> Using `` quotes will print "dedicated" in monotyped font ... is that 
> what you wanted here? AFAIK we're mainly doing that for things that 
> can be typed in the terminal, e.g. command line options. So should 
> this use normal quotes instead?


No, I think we do not need quotes here.

Thanks

regards,

Pierre



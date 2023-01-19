Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0572D673CC4
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 15:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjASOt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 09:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbjASOs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 09:48:57 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7AC127
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 06:48:54 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JEiSMs022809;
        Thu, 19 Jan 2023 14:48:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=B8csQPDTMmla7ukaD0sT1KKIvwDjWK/QtXo5k+sSjJk=;
 b=kC3Y3sFhzJ85pBz3n28La9pAsCLld/sCnZ0IXrNcHvtWj02rn44dG84fTiixF2KCRKFR
 AbAY1IebpBcqcwzKj8OrhJjy3eZGdyrFyca1GTt0+swaHSXGiASLIQJrJKPHYvW2oKCp
 K8hJNADkGQUhmB2O6y9hIxrxJ9z+uoDl8gm1UASr0wfIQZw684cFRjx5owEpybnfpsU7
 b/Pnb1u+z2GKERujdLtRriiTX6J0FUNRegISuDN3dnMlNsvxQ5FDZYVTJaWH8vFPnfhL
 7ZQr1aI03F1gzQizJdh4EccasB7kYOnnSbQ3sIMCHJDTbgZTF0aR0ARSeUvso+1MaerG dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n77vwr3b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 14:48:48 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30JEjMoQ025112;
        Thu, 19 Jan 2023 14:48:47 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n77vwr3a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 14:48:47 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30JA1hcv013361;
        Thu, 19 Jan 2023 14:48:45 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3n3m16cypk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 14:48:45 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30JEmgED21168802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 14:48:42 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E1DC20040;
        Thu, 19 Jan 2023 14:48:42 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5340220043;
        Thu, 19 Jan 2023 14:48:41 +0000 (GMT)
Received: from [9.152.224.248] (unknown [9.152.224.248])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Jan 2023 14:48:41 +0000 (GMT)
Message-ID: <6c9887b4-c018-5281-3bca-244c0d7d18cc@linux.ibm.com>
Date:   Thu, 19 Jan 2023 15:48:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 11/11] docs/s390x/cpu topology: document s390x cpu
 topology
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-12-pmorel@linux.ibm.com>
 <df7b8bc3-7731-6af0-e4ca-426cbfc2c074@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <df7b8bc3-7731-6af0-e4ca-426cbfc2c074@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FEyosT5gVUgwnMEnCahuTkQ0Gd49otOy
X-Proofpoint-ORIG-GUID: qtjRy8CemX7ZLsQNW3P8ayAkcPMrcRbX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_09,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301190116
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/12/23 12:46, Thomas Huth wrote:
> On 05/01/2023 15.53, Pierre Morel wrote:
>> Add some basic examples for the definition of cpu topology
>> in s390x.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   docs/system/s390x/cpu-topology.rst | 292 +++++++++++++++++++++++++++++
>>   docs/system/target-s390x.rst       |   1 +
>>   2 files changed, 293 insertions(+)
>>   create mode 100644 docs/system/s390x/cpu-topology.rst
>>
>> diff --git a/docs/system/s390x/cpu-topology.rst 
>> b/docs/system/s390x/cpu-topology.rst
>> new file mode 100644
>> index 0000000000..0020b70b50
>> --- /dev/null
>> +++ b/docs/system/s390x/cpu-topology.rst
>> @@ -0,0 +1,292 @@
>> +CPU Topology on s390x
>> +=====================
>> +
>> +CPU Topology on S390x provides up to 5 levels of topology containers:
> 
> You sometimes write "Topology" with a capital T, sometimes lower case 
> ... I'd suggest to write it lower case consistently everywhere.

OK

> 
>> +nodes, drawers, books, sockets and CPUs.
> 
> Hmm, so here you mention that "nodes" are usable on s390x, too? ... in 
> another spot below, you don't mention these anymore...

No, no nodes needed here, I remove that.

> 
>> +While the higher level containers, Containers Topology List Entries,
>> +(Containers TLE) define a tree hierarchy, the lowest level of topology
>> +definition, the CPU Topology List Entry (CPU TLE), provides the 
>> placement
>> +of the CPUs inside the parent container.
>> +
>> +Currently QEMU CPU topology uses a single level of container: the 
>> sockets.
>> +
>> +For backward compatibility, threads can be declared on the ``-smp`` 
>> command
>> +line. They will be seen as CPUs by the guest as long as multithreading
>> +is not really supported by QEMU for S390.
> 
> Maybe mention that threads are not allowed with machine types >= 7.2 
> anymore?

yes

> 
>> +Beside the topological tree, S390x provides 3 CPU attributes:
>> +- CPU type
>> +- polarity entitlement
>> +- dedication
>> +
>> +Prerequisites
>> +-------------
>> +
>> +To use CPU Topology a Linux QEMU/KVM machine providing the CPU 
>> Topology facility
>> +(STFLE bit 11) is required.
>> +
>> +However, since this facility has been enabled by default in an early 
>> version
>> +of QEMU, we use a capability, ``KVM_CAP_S390_CPU_TOPOLOGY``, to 
>> notify KVM
>> +QEMU use of the CPU Topology.
> 
> Has it? I thought bit 11 was not enabled by default in the past?

bit 11 enabled by default in QEMU, not in KVM.
However no code has been provided to support the STSI(15) and the PTF 
instruction which are enabled by facility 11.

So if we had enabled facility 11 in KVM without precaution a guest 
seeing facility 11 will use the PTF instruction and get a program interrupt.

Therefore we need a KVM capability to enable bit 11 in KVM


> 
>> +Enabling CPU topology
>> +---------------------
>> +
>> +Currently, CPU topology is only enabled in the host model.
> 
> add a "by default if support is available in the host kernel" at the end 
> of the sentence?

yes, thx

> 
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
>> +The CPU Topology, can be specified on the QEMU command line
>> +with the ``-smp`` or the ``-device`` QEMU command arguments
>> +without using any new attributes.
>> +In this case, the topology will be calculated by simply adding
>> +to the topology the cores based on the core-id starting with
>> +core-0 at position 0 of socket-0, book-0, drawer-0 with default
> 
> ... here you don't mention "nodes" anymore (which you still mentioned at 
> the beginning of the doc).

I removed it

> 
>> +modifier attributes: horizontal polarity and no dedication.
>> +
>> +In the following machine we define 8 sockets with 4 cores each.
>> +Note that S390 QEMU machines do not implement multithreading.
> 
> I'd use s390x instead of S390 to avoid confusion with 31-bit machines.

OK

> 
>> +.. code-block:: bash
>> +
>> +  $ qemu-system-s390x -m 2G \
>> +    -cpu gen16b,ctop=on \
>> +    -smp cpus=5,sockets=8,cores=4,maxcpus=32 \
>> +    -device host-s390x-cpu,core-id=14 \
>> +
>> +New CPUs can be plugged using the device_add hmp command like in:
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
>> +Note that the core ID is machine wide and the CPU TLE masks provided
>> +by the STSI instruction will be written in a big endian mask:
>> +
>> +* in socket 0: 0xf000000000000000 (core id 0,1,2,3)
>> +* in socket 1: 0x0800000000000000 (core id 4)
>> +* in socket 2: 0x0040000000000000 (core id 9)
>> +* in socket 3: 0x0002000000000000 (core id 14)
> 
> Hmm, who's supposed to be the audience of this documentation? Users? 
> Developers? For a doc in docs/system/ I'd expect this to be a 
> documentation for users, so this seems to be way too much of 
> implementation detail here already. If this is supposed to be a doc for 
> developers instead, the file should likely rather go into doc/devel/ 
> instead. Or maybe you want both? ... then you should split the 
> information in here in two files, I think, one in docs/system/ and one 
> in docs/devel/ .

I am not sure in devel there is all doc on QAPI interface not on commands.
On the other hand the QAPI seems to have its own way to document the 
commands.

So what I write here is more detailed than in the QAPI documentation.
May be I better write these details there and suppress them here,
just naming the command, info and event without details.


> 
>> +Defining the topology on command line
>> +-------------------------------------
>> +
>> +The topology can be defined entirely during the CPU definition,
>> +with the exception of CPU 0 which must be defined with the -smp
>> +argument.
>> +
>> +For example, here we set the position of the cores 1,2,3 on
>> +drawer 1, book 1, socket 2 and cores 0,9 and 14 on drawer 0,
>> +book 0, socket 0 with all horizontal polarity and not dedicated.
>> +The core 4, will be set on its default position on socket 1
>> +(since we have 4 core per socket) and we define it with dedication and
>> +vertical high entitlement.
>> +
>> +.. code-block:: bash
>> +
>> +  $ qemu-system-s390x -m 2G \
>> +    -cpu gen16b,ctop=on \
>> +    -smp cpus=1,sockets=8,cores=4,maxcpus=32 \
>> +    \
>> +    -device 
>> gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=1 \
>> +    -device 
>> gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=2 \
>> +    -device 
>> gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=3 \
>> +    \
>> +    -device 
>> gen16b-s390x-cpu,drawer-id=0,book-id=0,socket-id=0,core-id=9 \
>> +    -device 
>> gen16b-s390x-cpu,drawer-id=0,book-id=0,socket-id=0,core-id=14 \
>> +    \
>> +    -device gen16b-s390x-cpu,core-id=4,dedicated=on,polarity=3 \
>> +
>> +Polarity and dedication
>> +-----------------------
> 
> Since you are using the terms "polarity" and "dedication" in the 
> previous paragraphs already, it might make sense to move this section 
> here earlier in the document to teach the users about this first, before 
> using the terms in the other paragraphs?

yes

> 
>> +Polarity can be of two types: horizontal or vertical.
>> +
>> +The horizontal polarization specifies that all guest's vCPUs get
>> +almost the same amount of provisioning of real CPU by the host.
>> +
>> +The vertical polarization specifies that guest's vCPU can get
>> +different  real CPU provisions:
> 
> Please remove one space between "different" and "real".

OK

> 
>> +- a vCPU with Vertical high entitlement specifies that this
>> +  vCPU gets 100% of the real CPU provisioning.
>> +
>> +- a vCPU with Vertical medium entitlement specifies that this
>> +  vCPU shares the real CPU with other vCPU.
> 
> "with *one* other vCPU" or rather "with other vCPU*s*" ?

thx, vCPUs

> 
>> +
>> +- a vCPU with Vertical low entitlement specifies that this
>> +  vCPU only get real CPU provisioning when no other vCPU need it.
>> +
>> +In the case a vCPU with vertical high entitlement does not use
>> +the real CPU, the unused "slack" can be dispatched to other vCPU
>> +with medium or low entitlement.
>> +
>> +The host indicates to the guest how the real CPU resources are
>> +provided to the vCPUs through the SYSIB with two polarity bits
>> +inside the CPU TLE.
>> +
>> +Bits d - Polarization
>> +0 0      Horizontal
>> +0 1      Vertical low entitlement
>> +1 0      Vertical medium entitlement
>> +1 1      Vertical high entitlement
> 
> That SYSIB stuff looks like details for developers again ... I think you 
> should either add more explanations here (I assume the average user does 
> not know the term SYSIB), move it to a separate developers file or drop it.
> 

OK, I drop it

>> +A subsystem reset puts all vCPU of the configuration into the
>> +horizontal polarization.
>> +
>> +The admin specifies the dedicated bit when the vCPU is dedicated
>> +to a single real CPU.
>> +
>> +As for the Linux admin, the dedicated bit is an indication on the
>> +affinity of a vCPU for a real CPU while the entitlement indicates the
>> +sharing or exclusivity of use.
>> +
>> +QAPI interface for topology
>> +---------------------------
> 
> A "grep -r QAPI docs/system/" shows hardly any entries there. I think 
> QAPI documentation should go into docs/devel instead.

discussion above.
I enhance the QAPI internal doc or I move it into devel.


> 
>> +Let's start QEMU with the following command:
>> +
>> +.. code-block:: bash
>> +
>> + sudo /usr/local/bin/qemu-system-s390x \
>> +    -enable-kvm \
>> +    -cpu z14,ctop=on \
>> +    -smp 1,drawers=3,books=3,sockets=2,cores=2,maxcpus=36 \
>> +    \
>> +    -device z14-s390x-cpu,core-id=19,polarity=3 \
>> +    -device z14-s390x-cpu,core-id=11,polarity=1 \
>> +    -device z14-s390x-cpu,core-id=12,polarity=3 \
>> +   ...
>> +
>> +and see the result when using of the QAPI interface.
>> +
>> +query-topology
>> ++++++++++++++++
>> +
>> +The command cpu-topology allows the admin to query the topology
> 
> Not sure if the average admin runs QMP directly ... maybe rather talk 
> about the "upper layers like libvirt" here or something similar.
> 
>> +tree and modifier for all configured vCPU.
>> +
>> +.. code-block:: QMP
>> +
>> + -> { "execute": "query-topology" }
>> +    {"return":
>> +        [
>> +            {
>> +            "origin": 0,
>> +            "dedicated": false,
>> +            "book": 0,
>> +            "socket": 0,
>> +            "drawer": 0,
>> +            "polarity": 0,
>> +            "mask": "0x8000000000000000"
>> +            },
>> +            {
>> +                "origin": 0,
>> +                "dedicated": false,
>> +                "book": 2,
>> +                "socket": 1,
>> +                "drawer": 0,
>> +                "polarity": 1,
>> +                "mask": "0x0010000000000000"
>> +            },
>> +            {
>> +                "origin": 0,
>> +                "dedicated": false,
>> +                "book": 0,
>> +                "socket": 0,
>> +                "drawer": 1,
>> +                "polarity": 3,
>> +                "mask": "0x0008000000000000"
>> +            },
>> +            {
>> +                "origin": 0,
>> +                "dedicated": false,
>> +                "book": 1,
>> +                "socket": 1,
>> +                "drawer": 1,
>> +                "polarity": 3,
>> +                "mask": "0x0000100000000000"
>> +            }
>> +        ]
>> +    }
>> +
>> +change-topology
>> ++++++++++++++++
>> +
>> +The command change-topology allows the admin to modify the topology
>> +tree or the topology modifiers of a vCPU in the configuration.
>> +
>> +.. code-block:: QMP
>> +
>> + -> { "execute": "change-topology",
>> +      "arguments": {
>> +         "core": 11,
>> +         "socket": 0,
>> +         "book": 0,
>> +         "drawer": 0,
>> +         "polarity": 0,
>> +         "dedicated": false
>> +      }
>> +    }
>> + <- {"return": {}}
>> +
>> +
>> +event POLARITY_CHANGE
>> ++++++++++++++++++++++
>> +
>> +When a guest is requesting a modification of the polarity,
>> +QEMU sends a POLARITY_CHANGE event.
>> +
>> +When requesting the change, the guest only specifies horizontal or
>> +vertical polarity.
>> +The dedication and fine grain vertical entitlement depends on admin
>> +to set according to its response to this event.
>> +
>> +Note that a vertical polarized dedicated vCPU can only have a high
>> +entitlement, this gives 6 possibilities for a vCPU polarity:
>> +
>> +- Horizontal
>> +- Horizontal dedicated
>> +- Vertical low
>> +- Vertical medium
>> +- Vertical high
>> +- Vertical high dedicated
>> +
>> +Example of the event received when the guest issues PTF(0) to request
> 
> Please mention that PTF is a CPU instruction (and provide the full name).

Yes, thanks.

regards,
Pierre


> 
>   Thomas
> 

-- 
Pierre Morel
IBM Lab Boeblingen

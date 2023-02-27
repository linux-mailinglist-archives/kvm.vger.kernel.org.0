Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A8D6A4439
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 15:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjB0OVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 09:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjB0OV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 09:21:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953B21EBCD
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 06:21:20 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RDML3s016855;
        Mon, 27 Feb 2023 14:21:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RsAxUUz0zgh9BKP41wSzsi47XFekGI2SIWw/XcnFn40=;
 b=M75HUxY0jp6leEOBFv6jcnHyTuVa3TzKbOqfO04ruFzf5w+cL67A87RlQuyjsRQJ4C8F
 VJZnaLNR4tizvTGufxiUcfSd30BCZ3JKtrk96b4swqBwO/XZDRALb2R+WzFRQ9jSFiXO
 CvTYGTRfDI0xGDhz3HkpHCxu0vBTRdBaOeg0WUinzN5MYmPiaG7JyzmpqwfkX+/18G4F
 HHGZ2WE+IcuqxS0LUXJodM8hvN6J+Q6QVBu5WbdUH+IGAJS62TzkAxXYM+LagcBHAX0V
 95729ZfeD+dkzqLavvA8UuSN9/+lv7zJ2XEnJb3JLJZjV9TW+2FTgSb5+C5PvFi0Muse HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0ufs4m6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:21:09 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31RE0jVs029359;
        Mon, 27 Feb 2023 14:21:08 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0ufs4m5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:21:08 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31RBBH8n024312;
        Mon, 27 Feb 2023 14:21:06 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3nybab1g5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:21:06 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31REL2wD27853246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 14:21:03 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3D9420040;
        Mon, 27 Feb 2023 14:21:02 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8D6320049;
        Mon, 27 Feb 2023 14:21:00 +0000 (GMT)
Received: from [9.171.14.212] (unknown [9.171.14.212])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 27 Feb 2023 14:21:00 +0000 (GMT)
Message-ID: <7cd54252-3d58-10c8-6aae-f620ff83c8cb@linux.ibm.com>
Date:   Mon, 27 Feb 2023 15:20:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v16 00/11] s390x: CPU Topology
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <c41ca0c4-3e38-1afa-f113-9f5cb5313995@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <c41ca0c4-3e38-1afa-f113-9f5cb5313995@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GoE_EGAFSkKCWQeCNjyNXqWk9g1ypZ6g
X-Proofpoint-ORIG-GUID: i4pQyrZNKhvxlUzgxorBVMmB1tYrNHdq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_10,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 lowpriorityscore=0
 adultscore=0 spamscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302270109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/27/23 15:00, Thomas Huth wrote:
> On 22/02/2023 15.20, Pierre Morel wrote:
>> Hi,
>>
>> No big changes here, some bug corrections and comments modifications
>> following Thomas and Nina comments and Daniel and Markus reommandations.
>>
>> Implementation discussions
>> ==========================
>>
>> CPU models
>> ----------
>>
>> Since the facility 11, S390_FEAT_CONFIGURATION_TOPOLOGY is already
>> in the CPU model for old QEMU we could not activate it as usual from
>> KVM but needed a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>> Checking and enabling this capability enables facility 11,
>> S390_FEAT_CONFIGURATION_TOPOLOGY.
>>
>> It is the responsibility of the admin to ensure the same CPU
>> model for source and target host in a migration.
>>
>> Migration
>> ---------
>>
>> When the target guest is started, the Multi-processor Topology Change
>> Report (MTCR) bit is set during the creation of the vCPU by KVM.
>> We do not need to migrate its state, in the worst case, the target
>> guest will see the MTCR and actualize its view of the topology
>> without necessity, but this will be done only one time.
>>
>> Reset
>> -----
>>
>> Reseting the topology is done during subsystem reset, the
>> polarization is reset to horizontal polarization.
>>
>> Topology attributes
>> -------------------
>>
>> The topology attributes are carried by the CPU object and defined
>> on object creation.
>> In the case the new attributes, socket, book, drawer, dedicated,
>> polarity are not provided QEMU provides defaults values.
>>
>> - Geometry defaults
>>    The geometry default are based on the core-id of the core to
>>    fill the geometry in a monotone way starting with drawer 0,
>>    book 0, and filling socket 0 with the number of cores per socket,
>>    then filling socket 1, socket 2 ... etc until the book is complete
>>    and all books until the first drawer is complete before starting with
>>    the next drawer.
>>
>>    This allows to keep existing start scripts and Libvirt existing
>>    interface until it is extended.
>>
>> - Modifiers defaults
>>    Default polarization is horizontal
>>    Default dedication is not dedicated.
>>
>> Dynamic topology modification
>> -----------------------------
>>
>> QAPI interface is extended with:
>> - a command: 'x-set-cpu-topology'
>> - a query: extension of 'query-cpus-fast'
>> - an event: 'CPU_POLARITY_CHANGE'
>>
>> The admin may use query-cpus-fast to verify the topology provided
>> to the guest and x-set-cpu-topology to modify it.
>>
>> The event CPU_POLARITY_CHANGE is sent when the guest successfuly
>> uses the PTF(2) instruction to request a polarization change.
>> In that case, the admin is supposed to modify the CPU provisioning
>> accordingly.
>>
>> Testing
>> =======
>>
>> To use the QEMU patches, you will need Linux V6-rc1 or newer,
>> or use the following Linux mainline patches:
>>
>> f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report
>> 24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function
>> 0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF 
>> fac..
>>
>> Currently this code is for KVM only, I have no idea if it is interesting
>> to provide a TCG patch. If ever it will be done in another series.
>>
>> Documentation
>> =============
>>
>> To have a better understanding of the S390x CPU Topology and its
>> implementation in QEMU you can have a look at the documentation in the
>> last patch of this series.
>>
>> The admin will want to match the host and the guest topology, taking
>> into account that the guest does not recognize multithreading.
>> Consequently, two vCPU assigned to threads of the same real CPU should
>> preferably be assigned to the same socket of the guest machine.
>>
>>
>> Regards,
>> Pierre
>>
>> Pierre Morel (11):
>>    s390x/cpu topology: add s390 specifics to CPU topology
>>    s390x/cpu topology: add topology entries on CPU hotplug
>>    target/s390x/cpu topology: handle STSI(15) and build the SYSIB
>>    s390x/sclp: reporting the maximum nested topology entries
>>    s390x/cpu topology: resetting the Topology-Change-Report
>>    s390x/cpu topology: interception of PTF instruction
>>    target/s390x/cpu topology: activating CPU topology
>>    qapi/s390x/cpu topology: set-cpu-topology monitor command
>>    machine: adding s390 topology to query-cpu-fast
>>    qapi/s390x/cpu topology: CPU_POLARIZATION_CHANGE qapi event
>>    docs/s390x/cpu topology: document s390x cpu topology
>>
>>   docs/system/s390x/cpu-topology.rst | 378 ++++++++++++++++++++
>>   docs/system/target-s390x.rst       |   1 +
>>   qapi/machine-target.json           |  81 +++++
>>   qapi/machine.json                  |  37 +-
>>   include/hw/boards.h                |  10 +-
>>   include/hw/s390x/cpu-topology.h    |  78 +++++
>>   include/hw/s390x/s390-virtio-ccw.h |   6 +
>>   include/hw/s390x/sclp.h            |   4 +-
>>   include/monitor/hmp.h              |   1 +
>>   target/s390x/cpu.h                 |  78 +++++
>>   target/s390x/kvm/kvm_s390x.h       |   1 +
>>   hw/core/machine-qmp-cmds.c         |   2 +
>>   hw/core/machine-smp.c              |  48 ++-
>>   hw/core/machine.c                  |   4 +
>>   hw/s390x/cpu-topology.c            | 534 +++++++++++++++++++++++++++++
>>   hw/s390x/s390-virtio-ccw.c         |  27 +-
>>   hw/s390x/sclp.c                    |   5 +
>>   softmmu/vl.c                       |   6 +
>>   target/s390x/cpu-sysemu.c          |  13 +
>>   target/s390x/cpu.c                 |   7 +
>>   target/s390x/cpu_models.c          |   1 +
>>   target/s390x/kvm/cpu_topology.c    | 312 +++++++++++++++++
>>   target/s390x/kvm/kvm.c             |  42 ++-
>>   hmp-commands.hx                    |  17 +
>>   hw/s390x/meson.build               |   1 +
>>   qemu-options.hx                    |   7 +-
>>   target/s390x/kvm/meson.build       |   3 +-
>>   27 files changed, 1685 insertions(+), 19 deletions(-)
>>   create mode 100644 docs/system/s390x/cpu-topology.rst
>>   create mode 100644 include/hw/s390x/cpu-topology.h
>>   create mode 100644 hw/s390x/cpu-topology.c
>>   create mode 100644 target/s390x/kvm/cpu_topology.c
>
> Any chance that you could also add some qtests for checking that the 
> topology works as expected? I.e. set some topology via the command 
> line, then use QMP to check whether all CPUs got the right settings?
>
>  Thomas
>
Yes I intend to develop some tests but it will take some time to develop 
it I need to do change of polarization from inside the guest and qmp 
from the host.

Regards,

Pierre




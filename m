Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464CD6D4DB1
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbjDCQ3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbjDCQ3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:29:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDE31722
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:29:31 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 333GJB1u001666;
        Mon, 3 Apr 2023 16:29:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=fAjwq9CT45lLTlFaFQvIm1BqcJ7aWx3fPh7t6Jmx3Qs=;
 b=QGOMlh1T6VQB2Aq5ZZw8s4qlUxSf81af/yHKONzHI4Fei6ks/CZ2CQP3tCLmurL/aaV+
 hAhYrs1im5EpeHH2hwkiumaHIisCQl7iyA35k3tTTJ8pYiXpvGreZJDmT2tHQas9Xm6L
 KR3tAV3n37vSqZWhGlLuZWOj6fHvO3tAhMg9qJSl7/gk3/MHqFoTHPjpHoEck7GXLQF+
 Lb4cAzf3zIduJFciKztn+qpsy1K/ZW6nAYTngzPyJSbk05v+WY7KsCuoCu3r2JjRgVPb
 2QH4QRv6YLvxrRdHLli2s5tqZuvng6Gh1R9uuBkaS3jvGbYRQidw8c4F9juDjBrfHwGA KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr0cruu21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:23 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 333GSTIX010127;
        Mon, 3 Apr 2023 16:29:22 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr0cruu11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:22 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3332eJOs010580;
        Mon, 3 Apr 2023 16:29:20 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ppc879vbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:20 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 333GTGlY26084060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Apr 2023 16:29:17 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D010520040;
        Mon,  3 Apr 2023 16:29:16 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE2F92004D;
        Mon,  3 Apr 2023 16:29:15 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.179.22.128])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Apr 2023 16:29:15 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v19 00/21] s390x: CPU Topology
Date:   Mon,  3 Apr 2023 18:28:44 +0200
Message-Id: <20230403162905.17703-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jYbkWFYs9YoNo3B45T4Erzj4DTXPCJ4P
X-Proofpoint-ORIG-GUID: Ypjs2he8I8lManr4CYP-mg_jTtDOnv-y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_13,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304030118
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

What is new:

- The polarization type is definitively a machine property.
  So add it to S390CcwMachineState

- The entitlement is only valid for vertical machine polarization
  but is indicated whatever the machine polarization is kept over
  polarization change and the administration entity does not need
  to set it again after a polarization change event.

- a new query, query-cpu-polarization, allows to check for the
  polarization

- modified avocado according to the changes and added new tests

Implementation discussions
==========================

CPU models
----------

Since the facility 11, S390_FEAT_CONFIGURATION_TOPOLOGY is already
in the CPU model for old QEMU we could not activate it as usual from
KVM but needed a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
Checking and enabling this capability enables facility 11,
S390_FEAT_CONFIGURATION_TOPOLOGY.

It is the responsibility of the admin to ensure the same CPU
model for source and target host in a migration.

Migration
---------

When the target guest is started, the Multi-processor Topology Change
Report (MTCR) bit is set during the creation of the vCPU by KVM.
We do not need to migrate its state, in the worst case, the target
guest will see the MTCR and actualize its view of the topology
without necessity, but this will be done only one time.

Reset
-----

Reseting the topology is done during subsystem reset, the
polarization is reset to horizontal polarization.

Topology attributes
-------------------

The topology attributes are carried by the CPU object and defined
on object creation.
In the case the new attributes, socket, book, drawer, dedicated,
entitlement are not provided QEMU provides defaults values.

- Geometry defaults
  The geometry default are based on the core-id of the core to 
  fill the geometry in a monotone way starting with drawer 0,
  book 0, and filling socket 0 with the number of cores per socket,
  then filling socket 1, socket 2 ... etc until the book is complete
  and all books until the first drawer is complete before starting with
  the next drawer.

  This allows to keep existing start scripts and Libvirt existing
  interface until it is extended.

- Modifiers defaults
  Default entitlement is medium
  Default dedication is not dedicated.

- Machine polarization default to horizontal

Dynamic topology modification
-----------------------------

QAPI interface is extended with:
- a command: 'set-cpu-topology'
- a query: 'query-cpu-polarization'
- a query: extension of qmp 'query-cpus-fast'
- a query: extension of hmp 'hotpluggable-cpus'
- an event: 'CPU_POLARITY_CHANGE'

New command and interface are specified as unstable.

The admin may use query-cpus-fast to verify the topology provided
to the guest and set-cpu-topology to modify it.

The event CPU_POLARITY_CHANGE is sent when the guest successfuly 
uses the PTF(2) instruction to request a polarization change.
In that case, the admin is supposed to modify the CPU provisioning
accordingly.

Testing
=======

To use the QEMU patches, you will need Linux V6-rc1 or newer,
or use the following Linux mainline patches:

f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report    
24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function     
0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF fac.. 

Currently this code is for KVM only, I have no idea if it is interesting
to provide a TCG patch. If ever it will be done in another series.

This series provide 12 avocado tests using Fedora-35 kernel and initrd
image.

Documentation
=============

To have a better understanding of the S390x CPU Topology and its
implementation in QEMU you can have a look at the documentation in the
last patch of this series.

The admin will want to match the host and the guest topology, taking
into account that the guest does not recognize multithreading.
Consequently, two vCPU assigned to threads of the same real CPU should
preferably be assigned to the same socket of the guest machine.


Regards,
Pierre

Pierre Morel (21):
  s390x/cpu topology: add s390 specifics to CPU topology
  s390x/cpu topology: add topology entries on CPU hotplug
  target/s390x/cpu topology: handle STSI(15) and build the SYSIB
  s390x/sclp: reporting the maximum nested topology entries
  s390x/cpu topology: resetting the Topology-Change-Report
  s390x/cpu topology: interception of PTF instruction
  target/s390x/cpu topology: activate CPU topology
  qapi/s390x/cpu topology: set-cpu-topology qmp command
  machine: adding s390 topology to query-cpu-fast
  machine: adding s390 topology to info hotpluggable-cpus
  qapi/s390x/cpu topology: CPU_POLARIZATION_CHANGE qapi event
  qapi/s390x/cpu topology: query-cpu-polarization qmp command
  docs/s390x/cpu topology: document s390x cpu topology
  tests/avocado: s390x cpu topology core
  tests/avocado: s390x cpu topology polarisation
  tests/avocado: s390x cpu topology entitlement tests
  tests/avocado: s390x cpu topology test dedicated CPU
  tests/avocado: s390x cpu topology test socket full
  tests/avocado: s390x cpu topology dedicated errors
  tests/avocado: s390x cpu topology bad move
  tests/avocado: s390x cpu topology query-cpu-polarization

 MAINTAINERS                        |  10 +
 docs/devel/index-internals.rst     |   1 +
 docs/devel/s390-cpu-topology.rst   | 161 +++++++++
 docs/system/s390x/cpu-topology.rst | 238 ++++++++++++++
 docs/system/target-s390x.rst       |   1 +
 qapi/machine-common.json           |  22 ++
 qapi/machine-target.json           | 112 +++++++
 qapi/machine.json                  |  26 +-
 include/hw/boards.h                |  10 +-
 include/hw/s390x/cpu-topology.h    |  81 +++++
 include/hw/s390x/s390-virtio-ccw.h |   7 +
 include/hw/s390x/sclp.h            |   4 +-
 target/s390x/cpu.h                 |  78 +++++
 target/s390x/kvm/kvm_s390x.h       |   1 +
 hw/core/machine-hmp-cmds.c         |   6 +
 hw/core/machine-qmp-cmds.c         |   2 +
 hw/core/machine-smp.c              |  53 ++-
 hw/core/machine.c                  |   4 +
 hw/s390x/cpu-topology.c            | 504 +++++++++++++++++++++++++++++
 hw/s390x/s390-virtio-ccw.c         |  27 +-
 hw/s390x/sclp.c                    |   5 +
 softmmu/vl.c                       |   6 +
 target/s390x/cpu-sysemu.c          |  13 +
 target/s390x/cpu.c                 |   7 +
 target/s390x/cpu_models.c          |   1 +
 target/s390x/kvm/cpu_topology.c    | 311 ++++++++++++++++++
 target/s390x/kvm/kvm.c             |  42 ++-
 hw/s390x/meson.build               |   1 +
 qapi/meson.build                   |   1 +
 qemu-options.hx                    |   7 +-
 target/s390x/kvm/meson.build       |   3 +-
 tests/avocado/s390_topology.py     | 468 +++++++++++++++++++++++++++
 32 files changed, 2193 insertions(+), 20 deletions(-)
 create mode 100644 docs/devel/s390-cpu-topology.rst
 create mode 100644 docs/system/s390x/cpu-topology.rst
 create mode 100644 qapi/machine-common.json
 create mode 100644 include/hw/s390x/cpu-topology.h
 create mode 100644 hw/s390x/cpu-topology.c
 create mode 100644 target/s390x/kvm/cpu_topology.c
 create mode 100644 tests/avocado/s390_topology.py

-- 
2.31.1

Since v18:

- Changed default entitlement to S390_CPU_ENTITLEMENT__MAX
  because no default can be correct.

- added polarization entry to the S390CcwMachineState
  which allow to suppress shadow entitlement

- Suppress shadow entitlement
  (Nina)

- Added query-cpu-polarization

- Added more avocado tests

- modified cpu_hierarchy_to_string to look better
  (Nina)

Since v17:

- bug correction in handling PTF

- added avocado tests
  (Thomas)

- Change comments on QEMU machine to 8.1

Since v16:

- documentation, split, bug correction and rephrasing
  (Nina, Thomas)

- create machine-common.json

- use of entitlement_shadow to keep track of the entitlement

- adding drawers and books to query-hotpluggable-cpus

- keep hmp interface for set-cpu-topology for a future series

Since v15:

- Use Enum for polarity and entitlement
  (Nina)

- move kvm_vm_enable_cap(KVM_CAP_S390_CPU_TOPOLOGY) to
  kvm_arch_init()
  (Thomas)

- Make all CPU attributes optional for set-cpu-topology monitor
  command
  (Thomas, Nina)

- Change use of the prefix "x-" to the use of feature unstable
  to declare set-cpu-topology as unstable.
  (Nina)

- Make CPU_POLARITY_CHANGE even as unstable
  (Nina)

- Documentation update
  (Thomas, Nina)

Since v14:

- move the ordering of TLE to just before filling the SYSIB,
  optimize TLE ordering to be done on need only.
  (Cedric in previous series)

- remove 'query-topology' and instead extend 'query-cpus-fast'
  (Daniel)

- rename POLARITY_CHANGE to CPU_POLARITY_CHANGE
  (Thomas)

- Divers bugs correction and doc changes
  (Thomas, Nina)

- Separate topology and entitlement, simplify pft handling
  (Nina)

- add the resetting of all CPU to horizontal polarity
  once implementing PTF interpretation

Since v13:

- Suppress the topology device to simplify the code
  (Cedric)

- moved reset of MTCR from device reset into subsystem
  reset and removed previous reviewed-by from Nico and
  Janis

- No need for Migration

- No need for machine dependencies
  (Christian, Thomas)

- Adding all features, drawer/book and dynamic
  (Cedric)


- since v12

- suppress new CPU flag "disable-topology" just use ctop

- no use of special fields in CCW machine or in CPU

- modifications in documentation

- insert documentation in tree
  (Cedric)

- moved cpu-topology.c from target/s390 to target/s390/kvm
  to compile smoothly (without topology) for TCG
  (Cedric)

- since v11

- new CPU flag "disable-topology"
  I would have take "topology" if I was able to have
  it false on default.
  (Christian, Thomas)

- Build the topology during the interception of the
  STSI instruction.
  (Cedric)

- return CC3 in case the calculated SYSIB length is
  greater than 4096.
  (Janis)

- minor corections on documentation

- since v10

- change machine attribute "topology-disable" to "topology"
  (Cedric)
- Add preliminary patch for machine properties
  (Cedric)
- Use next machine as 7.2
  (Cedric / Connie)
- Remove unecessary mutex
  (Thomas)
- use ENOTSUP return value for kvm_s390_topology_set_mtcr()
  (Cedric)
- Add explanation on container and cpu TLEs
  (Thomas)
- use again cpu and socket count in topology structure
  (Cedric)
- Suppress the S390TopoTLE structure and integrate
  the TLE masks to the socket structure.
  (-)
- the STSI instruction now finds the topology from the machine
  (Cedric)

- since v9

- remove books and drawers

- remove thread denying and replace with a merge
  of cores * threads to specify the CPUs available
  to the guest

- add a class option to avoid topology on older
  machines
  (Cedric)

- Allocate a SYSIB buffer of the maximal length to
  avoid overflow.
  (Nico, Janis)

- suppress redundancy of smp parameters in topology
  and use directly the machine smp structure

- Early check for topology support
  (Cedric)

- since v8

- Linux patches are now mainline

- simplification of the implementation
  (Janis)

- Migration, new machine definition
  (Thomas)

- Documentation

- since v7

- Coherence with the Linux patch series changes for MTCR get
  (Pierre)

- check return values during new CPU creation
  (Thomas)

- Improving codding style and argument usages
  (Thomas)

- since v6

- Changes on smp args in qemu-options
  (Daniel)
  
- changed comments in machine.jason
  (Daniel)
 
- Added reset
  (Janosch)

- since v5

- rebasing on newer QEMU version

- reworked most lines above 80 characters.

- since v4

- Added drawer and books to topology

- Added numa topology

- Added documentation

- since v3

- Added migration
  (Thomas)

- Separated STSI instruction from KVM to prepare TCG
  (Thomas)

- Take care of endianess to prepare TCG
  (Thomas)

- Added comments on STSI CPU container and PFT instruction
  (Thomas)

- Moved enabling the instructions as the last patch
  (Thomas)


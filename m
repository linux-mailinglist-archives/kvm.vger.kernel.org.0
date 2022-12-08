Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECDB646C26
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 10:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiLHJpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 04:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiLHJo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 04:44:58 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C9A70625
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 01:44:55 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B89hfL9012423;
        Thu, 8 Dec 2022 09:44:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=uxlIQPsQP0RGjYFBzDgpKPqjVIxu9Ece2BY0Lae3DHQ=;
 b=Bok1JCpCtVuSnifzQNSdTtR4/QqJFrHue3ruyEjf2Ta2H0wTcibWUkqD1gvESiiE/1p+
 0Oahi8pyWzhO+Z64X/jYIIijphTDPRdwLbZTPmSiAfsJEL2Q12Ym8ZCI2sRoq3gj6/ex
 zmxTaOlPe6KogWTY4UTi8ZTrqflACzkHF7uFDVyH60pjsDOqQs8pTTGUvhDhpqg1PII7
 kN6sSH1LDFzHgSPaeTSEugYO7hSO7dshUk0CkheKWjDpvTHa9Ddc5b7UY5DZrdXf8G31
 HPpPCUV53uDK1H3peBDou9aNURljJ+aASNCr66O+hH71fC2OxVMsmmgxjvmv2t5LQrc4 xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbdhr80fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 09:44:43 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B89ih6D014950;
        Thu, 8 Dec 2022 09:44:43 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbdhr80f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 09:44:43 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B88wP3t027356;
        Thu, 8 Dec 2022 09:44:40 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3m9ks4470v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 09:44:40 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B89iX9w44695820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Dec 2022 09:44:33 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6545820049;
        Thu,  8 Dec 2022 09:44:33 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F059520040;
        Thu,  8 Dec 2022 09:44:32 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.245])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  8 Dec 2022 09:44:32 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v13 0/7] s390x: CPU Topology
Date:   Thu,  8 Dec 2022 10:44:25 +0100
Message-Id: <20221208094432.9732-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SVHdD_9jTrhGcIMdWy096iXT5w5_Dtkb
X-Proofpoint-GUID: SdJvzC27VF5-Fflk4pgYGzZwxVRokHQ-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_04,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 spamscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 mlxlogscore=999
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212080077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Implementation discussions
==========================

CPU models
----------

Since the S390_FEAT_CONFIGURATION_TOPOLOGY is already in the CPU model
for old QEMU we could not activate it as usual from KVM but needed
a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
Checking and enabling this capability enables
S390_FEAT_CONFIGURATION_TOPOLOGY.

Migration
---------

Once the S390_FEAT_CONFIGURATION_TOPOLOGY is enabled in the source
host the STFL(11) is provided to the guest.
Since the feature is already in the CPU model of older QEMU,
a migration from a new QEMU enabling the topology to an old QEMU
will keep STFL(11) enabled making the guest get an exception for
illegal operation as soon as it uses the PTF instruction.

A VMState keeping track of the S390_FEAT_CONFIGURATION_TOPOLOGY
allows to forbid the migration in such a case.

Note that the VMState will be used to hold information on the
topology once we implement topology change for a running guest. 

Topology
--------

Until we introduce bookss and drawers, polarization and dedication
the topology is kept very simple and is specified uniquely by
the core_id of the vCPU which is also the vCPU address.

Testing
=======

To use the QEMU patches, you will need Linux V6-rc1 or newer,
or use the following Linux mainline patches:

f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report    
24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function     
0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF fac.. 

Currently this code is for KVM only, I have no idea if it is interesting
to provide a TCG patch. If ever it will be done in another series.

Documentation
=============

To have a better understanding of the S390x CPU Topology and its
implementation in QEMU you can have a look at the documentation in the
last patch of this series.

The admin will want to match the host and the guest topology, taking
into account that the guest does not recognize multithreading.
Consequently, two vCPU assigned to threads of the same real CPU should
preferably be assigned to the same socket of the guest machine.

Future developments
===================

Two series are actively prepared:
- Adding drawers, book, polarization and dedication to the vCPU.
- changing the topology with a running guest

Regards,
Pierre

Pierre Morel (7):
  s390x/cpu topology: Creating CPU topology device
  s390x/cpu topology: reporting the CPU topology to the guest
  s390x/cpu_topology: resetting the Topology-Change-Report
  s390x/cpu_topology: CPU topology migration
  s390x/cpu_topology: interception of PTF instruction
  s390x/cpu_topology: activating CPU topology
  docs/s390x: document s390x cpu topology

 docs/system/s390x/cpu-topology.rst |  87 ++++++++++
 docs/system/target-s390x.rst       |   1 +
 include/hw/s390x/cpu-topology.h    |  52 ++++++
 include/hw/s390x/s390-virtio-ccw.h |   6 +
 target/s390x/cpu.h                 |  78 +++++++++
 target/s390x/kvm/kvm_s390x.h       |   1 +
 hw/s390x/cpu-topology.c            | 261 +++++++++++++++++++++++++++++
 hw/s390x/s390-virtio-ccw.c         |   7 +
 target/s390x/cpu-sysemu.c          |  21 +++
 target/s390x/cpu_models.c          |   1 +
 target/s390x/kvm/cpu_topology.c    | 186 ++++++++++++++++++++
 target/s390x/kvm/kvm.c             |  46 ++++-
 hw/s390x/meson.build               |   1 +
 target/s390x/kvm/meson.build       |   3 +-
 14 files changed, 749 insertions(+), 2 deletions(-)
 create mode 100644 docs/system/s390x/cpu-topology.rst
 create mode 100644 include/hw/s390x/cpu-topology.h
 create mode 100644 hw/s390x/cpu-topology.c
 create mode 100644 target/s390x/kvm/cpu_topology.c

-- 
2.31.1

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

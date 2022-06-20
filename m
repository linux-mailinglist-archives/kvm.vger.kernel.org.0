Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E32551F29
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 16:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345553AbiFTOk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 10:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244991AbiFTOj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 10:39:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668A710C1
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 06:59:44 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KC1WqJ022761;
        Mon, 20 Jun 2022 13:59:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=bmenbTYJ6WB5+vz9UX+ZDF22ncPFbEcH14Ns/0O6ofQ=;
 b=LQTYG48HOYZKscfuWmlbqunIzsnVuNMWlZ9nYnu7tI/n5BZuxb91a8DVyuvm+G+psngs
 COCdWYp08MiVsAzeYhC2WU24RNRZwQ6/AHnwgQqmL/UsGV2OA17xs/H56BSznIxVCKli
 WGVMAc8ftJWFr2G14BJ/oC6hv9cF+85UAQ4B9UtjKGsL4JFZsWVitGeNWsu0sLMPiLx9
 vVm/CaunYYIr1RqME5x4ey6si/LUGRdp3Wh4/qx4T1bpPwiOFZvXVskEBFzgiKZwavqA
 aSN3KPGhJUkrK4NTg1IixFXtDgUcDgE2vdknKKEoNP+JRCYrpsCsEX9N2ddqzlN0x7kk VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrs7js00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:36 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25KD8K47018488;
        Mon, 20 Jun 2022 13:59:36 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrs7jry7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:35 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25KDpOas023579;
        Mon, 20 Jun 2022 13:59:33 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3gs6b8tknb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:33 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25KDxUrv11862290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 13:59:30 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF3B511C04C;
        Mon, 20 Jun 2022 13:59:30 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01CC911C04A;
        Mon, 20 Jun 2022 13:59:30 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.62.140])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jun 2022 13:59:29 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v8 00/12] s390x: CPU Topology
Date:   Mon, 20 Jun 2022 16:03:40 +0200
Message-Id: <20220620140352.39398-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xPy_00iAN4dMYkg_gszr0VhKN9vc3QXt
X-Proofpoint-ORIG-GUID: 5vbjkoyhU6xgFKtxqKxm8r-eV-ky6a2O
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 bulkscore=0 impostorscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This new spin is essentially for coherence with the last Linux CPU
Topology patch, function testing and coding style modifications.

Forword
=======

The goal of this series is to implement CPU topology for S390, it
improves the preceeding series with the implementation of books and
drawers, of non uniform CPU topology and with documentation.

To use these patches, you will need the Linux series version 10.
You find it there:
https://lkml.org/lkml/2022/6/20/590

Currently this code is for KVM only, I have no idea if it is interesting
to provide a TCG patch. If ever it will be done in another series.

To have a better understanding of the S390x CPU Topology and its
implementation in QEMU you can have a look at the documentation in the
last patch or follow the introduction here under.

A short introduction
====================

CPU Topology is described in the S390 POP with essentially the description
of two instructions:

PTF Perform Topology function used to poll for topology change
    and used to set the polarization but this part is not part of this item.

STSI Store System Information and the SYSIB 15.1.x providing the Topology
    configuration.

S390 Topology is a 6 levels hierarchical topology with up to 5 level
    of containers. The last topology level, specifying the CPU cores.

    This patch series only uses the two lower levels sockets and cores.
    
    To get the information on the topology, S390 provides the STSI
    instruction, which stores a structures providing the list of the
    containers used in the Machine topology: the SYSIB.
    A selector within the STSI instruction allow to chose how many topology
    levels will be provide in the SYSIB.

    Using the Topology List Entries (TLE) provided inside the SYSIB we
    the Linux kernel is able to compute the information about the cache
    distance between two cores and can use this information to take
    scheduling decisions.

The design
==========

1) To be ready for hotplug, I chose an Object oriented design
of the topology containers:
- A node is a bridge on the SYSBUS and defines a "node bus"
- A drawer is hotplug on the "node bus"
- A book on the "drawer bus"
- A socket on the "book bus"
- And the CPU Topology List Entry (CPU-TLE)sits on the socket bus.
These objects will be enhanced with the cache information when
NUMA is implemented.

This also allows for easy retrieval when building the different SYSIB
for Store Topology System Information (STSI)

2) Perform Topology Function (PTF) instruction is made available to the
guest with a new KVM capability and intercepted in QEMU, allowing the
guest to pool for topology changes.


Features
========

- There is no direct match between IDs shown by:
    - lscpu (unrelated numbered list),
    - SYSIB 15.1.x (topology ID)

- The CPU number, left column of lscpu, is used to reference a CPU
    by Linux tools
    While the CPU address is used by QEMU for hotplug.

- Effect of -smp parsing on the topology with an example:
    -smp 9,sockets=4,cores=4,maxcpus=16

    We have 4 socket each holding 4 cores so that we have a maximum 
    of 16 CPU, 9 of them are active on boot. (Should be obvious)

# lscpu -e
CPU NODE DRAWER BOOK SOCKET CORE L1d:L1i:L2d:L2i ONLINE CONFIGURED POLARIZATION ADDRESS
  0    0      0    0      0    0 0:0:0:0            yes yes        horizontal   0
  1    0      0    0      0    1 1:1:1:1            yes yes        horizontal   1
  2    0      0    0      0    2 2:2:2:2            yes yes        horizontal   2
  3    0      0    0      0    3 3:3:3:3            yes yes        horizontal   3
  4    0      0    0      1    4 4:4:4:4            yes yes        horizontal   4
  5    0      0    0      1    5 5:5:5:5            yes yes        horizontal   5
  6    0      0    0      1    6 6:6:6:6            yes yes        horizontal   6
  7    0      0    0      1    7 7:7:7:7            yes yes        horizontal   7
  8    0      0    0      2    8 8:8:8:8            yes yes        horizontal   8
# 


- To plug a new CPU inside the topology one can simply use the CPU
    address like in:
  
(qemu) device_add host-s390x-cpu,core-id=12
# lscpu -e
CPU NODE DRAWER BOOK SOCKET CORE L1d:L1i:L2d:L2i ONLINE CONFIGURED POLARIZATION ADDRESS
  0    0      0    0      0    0 0:0:0:0            yes yes        horizontal   0
  1    0      0    0      0    1 1:1:1:1            yes yes        horizontal   1
  2    0      0    0      0    2 2:2:2:2            yes yes        horizontal   2
  3    0      0    0      0    3 3:3:3:3            yes yes        horizontal   3
  4    0      0    0      1    4 4:4:4:4            yes yes        horizontal   4
  5    0      0    0      1    5 5:5:5:5            yes yes        horizontal   5
  6    0      0    0      1    6 6:6:6:6            yes yes        horizontal   6
  7    0      0    0      1    7 7:7:7:7            yes yes        horizontal   7
  8    0      0    0      2    8 8:8:8:8            yes yes        horizontal   8
  9    -      -    -      -    - :::                 no yes        horizontal   12
# chcpu -e 9
CPU 9 enabled
# lscpu -e
CPU NODE DRAWER BOOK SOCKET CORE L1d:L1i:L2d:L2i ONLINE CONFIGURED POLARIZATION ADDRESS
  0    0      0    0      0    0 0:0:0:0            yes yes        horizontal   0
  1    0      0    0      0    1 1:1:1:1            yes yes        horizontal   1
  2    0      0    0      0    2 2:2:2:2            yes yes        horizontal   2
  3    0      0    0      0    3 3:3:3:3            yes yes        horizontal   3
  4    0      0    0      1    4 4:4:4:4            yes yes        horizontal   4
  5    0      0    0      1    5 5:5:5:5            yes yes        horizontal   5
  6    0      0    0      1    6 6:6:6:6            yes yes        horizontal   6
  7    0      0    0      1    7 7:7:7:7            yes yes        horizontal   7
  8    0      0    0      2    8 8:8:8:8            yes yes        horizontal   8
  9    0      0    0      3    9 9:9:9:9            yes yes        horizontal   12
#

It is up to the admin level, Libvirt for example, to pin the righ CPU to the right
vCPU, but as we can see without NUMA, chosing separate sockets for CPUs is not easy
without hotplug because without information the code will assign the vCPU and fill
the sockets one after the other.
Note that this is also the default behavior on the LPAR.

Conclusion
==========

This patch, together with the associated KVM patch allows to provide CPU topology
information to the guest.
Currently, only dedicated vCPU and CPU are supported and a NUMA topology can only
be handled using CPU hotplug inside the guest.

Regards,
Pierre

Pierre Morel (12):
  Update Linux Headers
  s390x/cpu_topology: CPU topology objects and structures
  s390x/cpu_topology: implementating Store Topology System Information
  s390x/cpu_topology: Adding books to CPU topology
  s390x/cpu_topology: Adding books to STSI
  s390x/cpu_topology: Adding drawers to CPU topology
  s390x/cpu_topology: Adding drawers to STSI
  s390x/cpu_topology: implementing numa for the s390x topology
  target/s390x: interception of PTF instruction
  s390x/cpu_topology: resetting the Topology-Change-Report
  s390x/cpu_topology: CPU topology migration
  s390x/cpu_topology: activating CPU topology

 hw/core/machine-smp.c              |  48 +-
 hw/core/machine.c                  |  22 +
 hw/s390x/cpu-topology.c            | 754 +++++++++++++++++++++++++++++
 hw/s390x/meson.build               |   1 +
 hw/s390x/s390-virtio-ccw.c         |  77 ++-
 include/hw/boards.h                |   8 +
 include/hw/s390x/cpu-topology.h    |  99 ++++
 include/hw/s390x/s390-virtio-ccw.h |   6 +
 include/hw/s390x/sclp.h            |   1 +
 linux-headers/asm-s390/kvm.h       |   9 +
 linux-headers/linux/kvm.h          |   1 +
 qapi/machine.json                  |  14 +-
 qemu-options.hx                    |   6 +-
 softmmu/vl.c                       |   6 +
 target/s390x/cpu-sysemu.c          |   7 +
 target/s390x/cpu.h                 |  52 ++
 target/s390x/cpu_models.c          |   1 +
 target/s390x/cpu_topology.c        | 169 +++++++
 target/s390x/kvm/kvm.c             |  93 ++++
 target/s390x/kvm/kvm_s390x.h       |   2 +
 target/s390x/meson.build           |   1 +
 21 files changed, 1359 insertions(+), 18 deletions(-)
 create mode 100644 hw/s390x/cpu-topology.c
 create mode 100644 include/hw/s390x/cpu-topology.h
 create mode 100644 target/s390x/cpu_topology.c

-- 
2.31.1

Changelog:

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

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BB74BA171
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 14:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241015AbiBQNjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 08:39:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241004AbiBQNjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 08:39:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D752AF916
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 05:39:25 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HCgP01037457;
        Thu, 17 Feb 2022 13:39:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=OfhSZ218kMmIFXeFDf7x8MHceNBKb89iR8fLU7xXd3c=;
 b=f79VYD/U8h8QnTf+vRb2a5njUbmS7ZLwnUT9FjKCRpUbqfBMuHDLZPBb+5j0w+z6T9+J
 jUAKpWSx/zDiBAH2XF7zE6VUrBh8fc3GAIbz1PWWhhUCuWmY1Pnb9VQsXm2AufGqDuDj
 yS99pLhqsKKIf5aOeYE0QYflu8ExXCBZJruh/B5oB9pMPjM6VYwKlb1pzgw9wjNLPd0l
 UNCiZMzkqVX1989O9O216faNnlRXD8T3q/GXmT8q6a3MHj4L4UR1z2LjvS1BtmFg8HhV
 MNZGIHaplk+Tuu5lPOeAOSnYwwhLnq4dhHgBvMbsGH4yeQSWLYr3+f9Fd1sPQeBzS4RC eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9pkjsdfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:20 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HDMDTK028778;
        Thu, 17 Feb 2022 13:39:19 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9pkjsde2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:19 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HDbQLQ007613;
        Thu, 17 Feb 2022 13:39:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3e645kasu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HDdCSa40239602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 13:39:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7B174C05E;
        Thu, 17 Feb 2022 13:39:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2518C4C040;
        Thu, 17 Feb 2022 13:39:11 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.42.121])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 13:39:11 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v6 00/11] s390x: CPU Topology
Date:   Thu, 17 Feb 2022 14:41:14 +0100
Message-Id: <20220217134125.132150-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vhyGP4RGclw5gvUueYoM4cr16ny1V56I
X-Proofpoint-GUID: r3mrb4DMPGa_tqBkul7ggCfQeWzY31uB
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

The goal of this series is to implement CPU topology for S390, it
improves the preceeding series with the implementation of books and
drawers, of non uniform CPU topology and with documentation.

To use these patches, you will need the Linux series version 5.
You find it there:
https://lkml.org/lkml/2022/2/17/253

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

Pierre Morel (11):
  s390x: SCLP: reporting the maximum nested topology entries
  s390x: topology: CPU topology objects and structures
  s390x: topology: implementating Store Topology System Information
  s390x: CPU topology: CPU topology migration
  s390x: kvm: topology: interception of PTF instruction
  s390x: topology: Adding books to CPU topology
  s390x: topology: Adding books to STSI
  s390x: topology: Adding drawers to CPU topology
  s390x: topology: Adding drawers to STSI
  s390x: topology: implementing numa for the s390x topology
  s390x: topology: documentation

 docs/system/s390x/numa-cpu-topology.rst | 273 +++++++++++
 hw/core/machine-smp.c                   |  48 +-
 hw/core/machine.c                       |  22 +
 hw/s390x/cpu-topology.c                 | 599 ++++++++++++++++++++++++
 hw/s390x/meson.build                    |   1 +
 hw/s390x/s390-virtio-ccw.c              | 124 ++++-
 hw/s390x/sclp.c                         |   1 +
 include/hw/boards.h                     |   8 +
 include/hw/s390x/cpu-topology.h         |  97 ++++
 include/hw/s390x/s390-virtio-ccw.h      |   6 +
 include/hw/s390x/sclp.h                 |   4 +-
 qapi/machine.json                       |  12 +-
 softmmu/vl.c                            |   6 +
 target/s390x/cpu.h                      |  50 ++
 target/s390x/cpu_features_def.h.inc     |   1 +
 target/s390x/cpu_models.c               |   2 +
 target/s390x/cpu_topology.c             | 169 +++++++
 target/s390x/gen-features.c             |   3 +
 target/s390x/kvm/kvm.c                  |  26 +
 target/s390x/machine.c                  |  48 ++
 target/s390x/meson.build                |   1 +
 21 files changed, 1485 insertions(+), 16 deletions(-)
 create mode 100644 docs/system/s390x/numa-cpu-topology.rst
 create mode 100644 hw/s390x/cpu-topology.c
 create mode 100644 include/hw/s390x/cpu-topology.h
 create mode 100644 target/s390x/cpu_topology.c

-- 
2.27.0

Changelog:

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

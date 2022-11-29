Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF8C63C68C
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 18:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbiK2Rmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 12:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236664AbiK2Rm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 12:42:29 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529504E430
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:42:28 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATHAiFH013720;
        Tue, 29 Nov 2022 17:42:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=LycQ7E6Kop+OwiW2S9A7qpVx9OFYcIskXPbumyn79AI=;
 b=hGc05+uQTKB3OO1uadGh/psetv0Xqs4rNUd2LNrDA1QrfvYDN1PF4UAjHB5LI62pBknM
 XgkDZ2hl82sHMDkrgd7s9TQkJPgtaVyAo4SeQrMTg+K9OfijCxciDw27z8FbLMLT/NZJ
 gI/SklTsjx8++67mSmo6fK8Wk4OUz0cK5ssUo7APcU/L082mnPNrFDdMr1MNh6iW4WOu
 XvgZQrMLxg/go/aUJgIq+dZ9LHoBlc/IjyRYtTnnGhnrm4I+0UxFOKFBqDsKJsBORYdj
 bApnx1+r/lIZ/JA9HIee5DmWmprK0aS1UmOLHEmLle5V9KUE7Lwc7/sLZ3anfMT/VLfj wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5p8c0v2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 17:42:14 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ATHBh4L015896;
        Tue, 29 Nov 2022 17:42:14 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5p8c0v1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 17:42:13 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ATHZHF2018972;
        Tue, 29 Nov 2022 17:42:11 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3m3ae9cfer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 17:42:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ATHg8BF5309040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 17:42:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 934FCA404D;
        Tue, 29 Nov 2022 17:42:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 806DFA4040;
        Tue, 29 Nov 2022 17:42:07 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.89.107])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Nov 2022 17:42:07 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v12 0/7] s390x: CPU Topology
Date:   Tue, 29 Nov 2022 18:41:59 +0100
Message-Id: <20221129174206.84882-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lfSv0Ph4HyJId--xGbXrYg73i9FKV2S2
X-Proofpoint-ORIG-GUID: _F7otccRdf85unCYkGwTo5g_BjJJlYLQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_10,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 phishscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

The implementation of the CPU Topology in QEMU has been modified
since the last patch series.

- The two preliminary patches have been accepted and are no longer
  part of this series.

- The topology machine property has been abandoned

- the topology_capable QEMU capability has been abandoned

- both where replaced with a new CPU feature, topology-disable
  to fence per default the ctop topology information feature.

To use the QEMU patches, you will need Linux V6-rc1 or newer,
or use the following Linux mainline patches:

f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report    
24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function     
0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF fac.. 

Currently this code is for KVM only, I have no idea if it is interesting
to provide a TCG patch. If ever it will be done in another series.

To have a better understanding of the S390x CPU Topology and its
implementation in QEMU you can have a look at the documentation in the
last patch of this series.

The admin will want to match the host and the guest topology, taking
into account that the guest does not recognize multithreading.
Consequently, two vCPU assigned to threads of the same real CPU should
preferably be assigned to the same socket of the guest machine.

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

 docs/system/s390x/cpu-topology.rst  |  80 +++++++++++
 include/hw/s390x/cpu-topology.h     |  41 ++++++
 include/hw/s390x/s390-virtio-ccw.h  |   7 +
 target/s390x/cpu.h                  |  79 +++++++++++
 target/s390x/kvm/kvm_s390x.h        |   1 +
 target/s390x/cpu_features_def.h.inc |   1 +
 hw/s390x/cpu-topology.c             | 200 ++++++++++++++++++++++++++++
 hw/s390x/s390-virtio-ccw.c          |  38 +++++-
 target/s390x/cpu-sysemu.c           |  21 +++
 target/s390x/cpu_models.c           |  17 +++
 target/s390x/cpu_topology.c         | 191 ++++++++++++++++++++++++++
 target/s390x/gen-features.c         |   3 +
 target/s390x/kvm/kvm.c              |  48 ++++++-
 hw/s390x/meson.build                |   1 +
 target/s390x/meson.build            |   1 +
 15 files changed, 721 insertions(+), 8 deletions(-)
 create mode 100644 docs/system/s390x/cpu-topology.rst
 create mode 100644 include/hw/s390x/cpu-topology.h
 create mode 100644 hw/s390x/cpu-topology.c
 create mode 100644 target/s390x/cpu_topology.c

-- 
2.31.1

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

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAC25AA933
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 09:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbiIBH4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 03:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235486AbiIBH4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 03:56:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C9C237CE
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 00:55:52 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2827qerH011375;
        Fri, 2 Sep 2022 07:55:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=mH1GousYQPr1eGwZbOe/8RkpErFwUaKyJZGtCu725PU=;
 b=D9vMwB3I3vHPauVsrYZXNswZM1xnhRaoMzOENrErmtjLUcq2VRKM8xnIFPVyJWTVgrQ1
 hSzPxs1Fy9chy+07YLNi8gr5QH4QhdMpbmdoA3v8mSyxul5iVIML6KRBXNDqw12SPvUq
 th0ddY9r4CzCDTXmAgjwixUiYiQpGYCJAcf0AFnyzyjLILxpbNBCXwgrcuw6+6tXHOby
 FpJCtLpdOCOC/FjoUTawP5PMSYSNXBJVLiw0tBGZgFmMLV9N3vrygWxQsVDQXw+2e5+/
 oTIOrYf3p0ri0+YeKwf7tDFAY16C3QY5KVfN8GoN2e0RZ2hw6pPHP1HkIGxzbwCqxih5 iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbdu1048c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:38 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2827qfEH011450;
        Fri, 2 Sep 2022 07:55:38 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbdu1047w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:38 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2827oSxH025069;
        Fri, 2 Sep 2022 07:55:36 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3j7aw97tka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2827tXQY44171588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Sep 2022 07:55:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33CBA11C04C;
        Fri,  2 Sep 2022 07:55:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F89511C04A;
        Fri,  2 Sep 2022 07:55:32 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.69.137])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Sep 2022 07:55:32 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v9 00/10] s390x: CPU Topology
Date:   Fri,  2 Sep 2022 09:55:21 +0200
Message-Id: <20220902075531.188916-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qgSaz6UYoalKQYp452jFbcb2nQ_bVB6H
X-Proofpoint-ORIG-GUID: rFGWz2qtNeu6VkYS_oi6TRz_Ri_SxKmV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_12,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209020034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

The implementation of the CPU Topology in QEMU has been drastically
modified since the last patch series and the number of LOCs has been
greatly reduced.

Unnecessary objects have been removed, only a single S390Topology object
is created to support migration and reset.

Also a documentation has been added to the series.


To use these patches, you will need Linux V6-rc1 or newer.

Mainline patches needed are:

f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report    
24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function     
0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF fac.. 

Currently this code is for KVM only, I have no idea if it is interesting
to provide a TCG patch. If ever it will be done in another series.

To have a better understanding of the S390x CPU Topology and its
implementation in QEMU you can have a look at the documentation in the
last patch.

New in this series
==================

  s390x/cpus: Make absence of multithreading clear

This patch makes clear that CPU-multithreading is not supported in
the guest.

  s390x/cpu topology: core_id sets s390x CPU topology

This patch uses the core_id to build the container topology
and the placement of the CPU inside the container.

  s390x/cpu topology: reporting the CPU topology to the guest

This patch is based on the fact that the CPU type for guests
is always IFL, CPUs are always dedicated and the polarity is
always horizontal.
This may change in the future.

  hw/core: introducing drawer and books for s390x
  s390x/cpu: reporting drawers and books topology to the guest

These two patches extend the topology handling to add two
new containers levels above sockets: books and drawers.

The subject of the last patches is clear enough (I hope).

Regards,
Pierre

Pierre Morel (10):
  s390x/cpus: Make absence of multithreading clear
  s390x/cpu topology: core_id sets s390x CPU topology
  s390x/cpu topology: reporting the CPU topology to the guest
  hw/core: introducing drawer and books for s390x
  s390x/cpu: reporting drawers and books topology to the guest
  s390x/cpu_topology: resetting the Topology-Change-Report
  s390x/cpu_topology: CPU topology migration
  target/s390x: interception of PTF instruction
  s390x/cpu_topology: activating CPU topology
  docs/s390x: document s390x cpu topology

 docs/system/s390x/cpu_topology.rst |  88 +++++++++
 hw/core/machine-smp.c              |  48 ++++-
 hw/core/machine.c                  |   9 +
 hw/s390x/cpu-topology.c            | 293 +++++++++++++++++++++++++++++
 hw/s390x/meson.build               |   1 +
 hw/s390x/s390-virtio-ccw.c         |  61 +++++-
 include/hw/boards.h                |  11 ++
 include/hw/s390x/cpu-topology.h    |  53 ++++++
 include/hw/s390x/s390-virtio-ccw.h |   7 +
 qapi/machine.json                  |  14 +-
 qemu-options.hx                    |   6 +-
 softmmu/vl.c                       |   6 +
 target/s390x/cpu-sysemu.c          |  15 ++
 target/s390x/cpu.h                 |  51 +++++
 target/s390x/cpu_topology.c        | 150 +++++++++++++++
 target/s390x/kvm/kvm.c             |  56 +++++-
 target/s390x/kvm/kvm_s390x.h       |   1 +
 target/s390x/meson.build           |   1 +
 18 files changed, 858 insertions(+), 13 deletions(-)
 create mode 100644 docs/system/s390x/cpu_topology.rst
 create mode 100644 hw/s390x/cpu-topology.c
 create mode 100644 include/hw/s390x/cpu-topology.h
 create mode 100644 target/s390x/cpu_topology.c

-- 
2.31.1

Changelog:

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

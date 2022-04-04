Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE3E4F1BA8
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380820AbiDDVWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379617AbiDDRp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 13:45:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A95CDFAE;
        Mon,  4 Apr 2022 10:44:02 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234HGoqZ022632;
        Mon, 4 Apr 2022 17:44:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=26DzA4aFqds7fgbERdV4ExmyHxLRuGQQwohfv296qkc=;
 b=q1ccYrLH0kReQTyGCVdp1vJGUbcx578VOvyFA9Za8Ld1Cs+mWSJtWoKLjxyrkv7Tl4JQ
 IiQmB1XWj95uM/KYbft8vt9ImZf2SSTHluApprbNEMRttKyCZWsMcIBrg+bTgvkTc5xe
 /qj40nVaSCDx7rymPTrDlzAoscu9J4gZuP4aGG5esp/l6eNjMmi+xiv2tdXwauPzv+rO
 BWA+TeJULvtFFFvIepE0Polz9EP81k9yN7kicMmcTanUy7e4D4K+exLsoLCmx5sEoZUB
 c6V8E3AMBegmdJ65eJWseGZJ61oNHuKbJV/j+yORijdQbl18mVjCxbPVEApWdp56jKOC 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f84xcrvyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:00 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234HdJEX012471;
        Mon, 4 Apr 2022 17:43:59 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f84xcrvyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:43:59 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234HgsK2013878;
        Mon, 4 Apr 2022 17:43:59 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02wdc.us.ibm.com with ESMTP id 3f6e49980r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:43:59 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234HhwLn6816232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 17:43:58 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E561C136059;
        Mon,  4 Apr 2022 17:43:57 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5301136051;
        Mon,  4 Apr 2022 17:43:55 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.125])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 17:43:55 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v5 00/21] KVM: s390: enable zPCI for interpretive execution
Date:   Mon,  4 Apr 2022 13:43:28 -0400
Message-Id: <20220404174349.58530-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: potVyKhCtF10a60WuRE1wKDAkAB_0aej
X-Proofpoint-ORIG-GUID: tADtqZcx0f4mxrrj70xb3oiOthZS4PFb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_06,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=1 priorityscore=1501
 adultscore=0 mlxlogscore=200 malwarescore=0 spamscore=1 impostorscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=1
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Note: in this version, all IOMMU changes have been removed to be pursued
as a follow-on / in conjunction with IOMMUFD.  This series proposes to
add only exploitation of the interpretive execution facilities.

Enable interpretive execution of zPCI instructions + adapter interruption
forwarding for s390x KVM vfio-pci.  This is done by triggering a routine
when the VFIO group is associated with the KVM guest, transmitting to
firmware a special token (GISA designation) to enable that specific guest
for interpretive execution on that zPCI device.  Load/store interpreation
enablement is then controlled by userspace (based upon whether or not a
SHM bit is placed in the virtual function handle).  Adapter Event
Notification interpretation is controlled from userspace via a new KVM
ioctl.

By allowing intepretation of zPCI instructions and firmware delivery of
interrupts to guests, we can reduce the frequency of guest SIE exits for
zPCI.  

From the perspective of guest configuration, you passthrough zPCI devices
in the same manner as before, with intepretation support being used by
default if available in kernel+qemu.

Will reply with a link to the associated QEMU series.

Changelog v4->v5:
- Remove all IOMMU changes - this series will continue to use vfio type1
  for mapping; RPCIT enhancements will be pursued as a follow-on in
  coordination with the IOMMUFD project
- Remove most of the ops from the proposed KVM ioctl -- combine the notion
  of 'start' and 'enable interpretation' into a single operation that
  occurs in response to assigning a KVM association to the VFIO group
- a new kvm ioctl is still being used to register/unregister for adapter
  event notification forwarding.  But teach it to use pin_user_pages
  instead of gfn_to_page and perform accounting.
- Because we now attempt to enable interpretation for all devices (even
  if the virtual PCI device has a SHM bit on) avoid setting the GISA for
  the device and the ECB bits for the guest on hardware without SHM.
- found a bug with "s390/pci: stash associated GISA designation", namely
  that CLP SET PCI FN (disable) expects the gisa designation to always be
  0.  Now that we set the gisa earlier, vfio-pci can trip this when
  triggering restore for ISM.
- Add a single routine to determine if interpretation support is usable
  on this host, to be used in multiple spots.
- eliminated arch/s390/include/asm/kvm_pci.h, moving most elements into
  arch/s390/kvm/pci.h with one exception to asm/kvm_host.h

Matthew Rosato (21):
  s390/sclp: detect the zPCI load/store interpretation facility
  s390/sclp: detect the AISII facility
  s390/sclp: detect the AENI facility
  s390/sclp: detect the AISI facility
  s390/airq: pass more TPI info to airq handlers
  s390/airq: allow for airq structure that uses an input vector
  s390/pci: externalize the SIC operation controls and routine
  s390/pci: stash associated GISA designation
  s390/pci: stash dtsm and maxstbl
  KVM: s390: pci: add basic kvm_zdev structure
  KVM: s390: pci: do initial setup for AEN interpretation
  KVM: s390: pci: enable host forwarding of Adapter Event Notifications
  KVM: s390: mechanism to enable guest zPCI Interpretation
  KVM: s390: pci: provide routines for enabling/disabling interrupt
    forwarding
  KVM: s390: pci: add routines to start/stop interpretive execution
  KVM: vfio: add s390x hook to register KVM guest designation
  vfio-pci/zdev: add function handle to clp base capability
  vfio-pci/zdev: different maxstbl for interpreted devices
  KVM: s390: add KVM_S390_ZPCI_OP to manage guest zPCI devices
  KVM: s390: introduce CPU feature for zPCI Interpretation
  MAINTAINERS: additional files related kvm s390 pci passthrough

 Documentation/virt/kvm/api.rst   |  45 +++
 MAINTAINERS                      |   1 +
 arch/s390/include/asm/airq.h     |   7 +-
 arch/s390/include/asm/kvm_host.h |  16 +
 arch/s390/include/asm/pci.h      |  10 +
 arch/s390/include/asm/pci_clp.h  |   9 +-
 arch/s390/include/asm/pci_insn.h |  29 +-
 arch/s390/include/asm/sclp.h     |   4 +
 arch/s390/include/asm/tpi.h      |  13 +
 arch/s390/include/uapi/asm/kvm.h |   1 +
 arch/s390/kvm/Makefile           |   1 +
 arch/s390/kvm/interrupt.c        |  95 ++++-
 arch/s390/kvm/kvm-s390.c         |  81 +++-
 arch/s390/kvm/kvm-s390.h         |  10 +
 arch/s390/kvm/pci.c              | 666 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h              |  86 ++++
 arch/s390/pci/pci.c              |  15 +
 arch/s390/pci/pci_clp.c          |   7 +
 arch/s390/pci/pci_insn.c         |   4 +-
 arch/s390/pci/pci_irq.c          |  48 ++-
 drivers/s390/char/sclp_early.c   |   4 +
 drivers/s390/cio/airq.c          |  12 +-
 drivers/s390/cio/qdio_thinint.c  |   6 +-
 drivers/s390/crypto/ap_bus.c     |   9 +-
 drivers/s390/virtio/virtio_ccw.c |   6 +-
 drivers/vfio/pci/vfio_pci_zdev.c |  11 +-
 include/uapi/linux/kvm.h         |  31 ++
 include/uapi/linux/vfio_zdev.h   |   7 +
 virt/kvm/vfio.c                  |  35 +-
 29 files changed, 1216 insertions(+), 53 deletions(-)
 create mode 100644 arch/s390/kvm/pci.c
 create mode 100644 arch/s390/kvm/pci.h

-- 
2.27.0


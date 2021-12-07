Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2983D46C54F
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 21:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhLGVBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:01:30 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60776 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230161AbhLGVB2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:01:28 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Jgfe2023895;
        Tue, 7 Dec 2021 20:57:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=kg4uLEJd3+lEykEsCemBOG4V43UpS7k2um+hywvI2jE=;
 b=s36vDDI9Zvd656mU0S8sR4gwDXzYJJytkjjW3pPaM8vUnGyL8zCnZdwyHFj3NEmX3oVY
 iRNB07vIZRMuGN+AnkHt7udhadAnm0fQRKiiR3u6HBLihD8PtAa8GeEoDihnyl3bzG0O
 sb4f4osgaeeYws0rbhb07kQlGjXJIHv4A5TO/HI4ouZFTgGE19w2hWpl2l5kbIBjnfQi
 uNPecDQKg0CMOIiJF5qkUkzffhStI97OrC63vh54qIdHpM8Y08LDHEk+n2M7Md5kd/LL
 ka8x9zQTb4IYfBuPHiVk4aCwIBDs/xNh93jFQKrMu6bWYoZZfMK1SYFQo9EJUBR18DTs pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctbgt4swx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:57:56 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KuLGC015629;
        Tue, 7 Dec 2021 20:57:56 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctbgt4swu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:57:56 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KRBXA016416;
        Tue, 7 Dec 2021 20:57:55 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 3cqyyb32wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:57:55 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7KvrO950921850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 20:57:53 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B8C3AE068;
        Tue,  7 Dec 2021 20:57:53 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D4FEAE067;
        Tue,  7 Dec 2021 20:57:48 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 20:57:48 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/32] KVM: s390: enable zPCI for interpretive execution
Date:   Tue,  7 Dec 2021 15:57:11 -0500
Message-Id: <20211207205743.150299-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b-vGlaLIF0oXeQGM3Qr8pk54VHl5gHxV
X-Proofpoint-ORIG-GUID: HtH2eLKhiuVb5t83nJI37QA-TGQXrFiM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 malwarescore=0 phishscore=0 mlxlogscore=610 bulkscore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable interpretive execution of zPCI instructions + adapter interruption
forwarding for s390x KVM vfio-pci.  This is done by introducing a series
of new vfio-pci feature ioctls that are unique vfio-pci-zdev (s390x) and
are used to negotiate the various aspects of zPCI interpretation setup.
By allowing intepretation of zPCI instructions and firmware delivery of
interrupts to guests, we can significantly reduce the frequency of guest
SIE exits for zPCI.  We then see additional gains by handling a hot-path
instruction that can still intercept to the hypervisor (RPCIT) directly
in kvm.

From the perspective of guest configuration, you passthrough zPCI devices
in the same manner as before, with intepretation support being used by
default if available in kernel+qemu.

Will reply with a link to the associated QEMU series.

Matthew Rosato (32):
  s390/sclp: detect the zPCI interpretation facility
  s390/sclp: detect the AISII facility
  s390/sclp: detect the AENI facility
  s390/sclp: detect the AISI facility
  s390/airq: pass more TPI info to airq handlers
  s390/airq: allow for airq structure that uses an input vector
  s390/pci: externalize the SIC operation controls and routine
  s390/pci: stash associated GISA designation
  s390/pci: export some routines related to RPCIT processing
  s390/pci: stash dtsm and maxstbl
  s390/pci: add helper function to find device by handle
  s390/pci: get SHM information from list pci
  KVM: s390: pci: add basic kvm_zdev structure
  KVM: s390: pci: do initial setup for AEN interpretation
  KVM: s390: pci: enable host forwarding of Adapter Event Notifications
  KVM: s390: expose the guest zPCI interpretation facility
  KVM: s390: expose the guest Adapter Interruption Source ID facility
  KVM: s390: expose guest Adapter Event Notification Interpretation
    facility
  KVM: s390: mechanism to enable guest zPCI Interpretation
  KVM: s390: pci: provide routines for enabling/disabling interpretation
  KVM: s390: pci: provide routines for enabling/disabling interrupt
    forwarding
  KVM: s390: pci: provide routines for enabling/disabling IOAT assist
  KVM: s390: pci: handle refresh of PCI translations
  KVM: s390: intercept the rpcit instruction
  vfio/pci: re-introduce CONFIG_VFIO_PCI_ZDEV
  vfio-pci/zdev: wire up group notifier
  vfio-pci/zdev: wire up zPCI interpretive execution support
  vfio-pci/zdev: wire up zPCI adapter interrupt forwarding support
  vfio-pci/zdev: wire up zPCI IOAT assist support
  vfio-pci/zdev: add DTSM to clp group capability
  KVM: s390: introduce CPU feature for zPCI Interpretation
  MAINTAINERS: additional files related kvm s390 pci passthrough

 MAINTAINERS                      |   2 +
 arch/s390/include/asm/airq.h     |   7 +-
 arch/s390/include/asm/kvm_host.h |   5 +
 arch/s390/include/asm/kvm_pci.h  |  62 +++
 arch/s390/include/asm/pci.h      |  13 +
 arch/s390/include/asm/pci_clp.h  |  11 +-
 arch/s390/include/asm/pci_dma.h  |   3 +
 arch/s390/include/asm/pci_insn.h |  29 +-
 arch/s390/include/asm/sclp.h     |   4 +
 arch/s390/include/asm/tpi.h      |  14 +
 arch/s390/include/uapi/asm/kvm.h |   1 +
 arch/s390/kvm/Makefile           |   2 +-
 arch/s390/kvm/interrupt.c        |  97 +++-
 arch/s390/kvm/kvm-s390.c         |  65 ++-
 arch/s390/kvm/kvm-s390.h         |  10 +
 arch/s390/kvm/pci.c              | 784 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h              |  59 +++
 arch/s390/kvm/priv.c             |  41 ++
 arch/s390/pci/pci.c              |  47 ++
 arch/s390/pci/pci_clp.c          |  19 +-
 arch/s390/pci/pci_dma.c          |   1 +
 arch/s390/pci/pci_insn.c         |   5 +-
 arch/s390/pci/pci_irq.c          |  50 +-
 drivers/s390/char/sclp_early.c   |   4 +
 drivers/s390/cio/airq.c          |  12 +-
 drivers/s390/cio/qdio_thinint.c  |   6 +-
 drivers/s390/crypto/ap_bus.c     |   9 +-
 drivers/s390/virtio/virtio_ccw.c |   6 +-
 drivers/vfio/pci/Kconfig         |  11 +
 drivers/vfio/pci/Makefile        |   2 +-
 drivers/vfio/pci/vfio_pci_core.c |   8 +
 drivers/vfio/pci/vfio_pci_zdev.c | 292 +++++++++++-
 include/linux/vfio_pci_core.h    |  44 +-
 include/uapi/linux/vfio.h        |  22 +
 include/uapi/linux/vfio_zdev.h   |  51 ++
 35 files changed, 1738 insertions(+), 60 deletions(-)
 create mode 100644 arch/s390/include/asm/kvm_pci.h
 create mode 100644 arch/s390/kvm/pci.c
 create mode 100644 arch/s390/kvm/pci.h

-- 
2.27.0


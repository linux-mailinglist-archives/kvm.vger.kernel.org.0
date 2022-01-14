Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D057F48F111
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244200AbiANUb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:31:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52448 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233330AbiANUb4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:31:56 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EHvi5m003797;
        Fri, 14 Jan 2022 20:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=k96QRqNH5ttim3Ip76hmL2cbu2Yohpd0Rx1ZBxZe6X4=;
 b=r2fiSvaBOd7+95/fYpC6utMSnhsfd12gatQetbonxeKv7Ku94eYXfK5sDgTQ8uBXIpv2
 PpxJddUGGOp02FLGzlRbYhWD/TMBIWfsPB1fSOV0cOWbmmK5mImHQXYlvI1KDngmu4t4
 fj4dERe8SN0pdwN0Wl/17nozdiYqudUSI7Xyh91iwyMGCeEqNDo3Bkcgy6fN7LmrhdVj
 7G+NUVpXuWGNbJf1X+ZeyY0S8FmFkr9/ybZSH23wv+nMQD0metpIwsXJNV76OlGmm09x
 Jt2HSJwIwBnZHcy1sv3B1lYZ6WsOUZqISKHEEqiRmRZuZPBzKJYpRYXLydBLdhd6x3J1 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dke1naqqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:31:55 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKRxKX000748;
        Fri, 14 Jan 2022 20:31:54 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dke1naqqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:31:54 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKMWrT032713;
        Fri, 14 Jan 2022 20:31:53 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3df28ddykk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:31:53 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKVpdW29163864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:31:51 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C380C6061;
        Fri, 14 Jan 2022 20:31:51 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E13C6C6057;
        Fri, 14 Jan 2022 20:31:49 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:31:49 +0000 (GMT)
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
Subject: [PATCH v2 00/30] KVM: s390: enable zPCI for interpretive execution
Date:   Fri, 14 Jan 2022 15:31:15 -0500
Message-Id: <20220114203145.242984-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IBOrBn8c_o5OUwLGwkPjbNBCTlwqM5c0
X-Proofpoint-ORIG-GUID: LWsb4t7na6IgGzE7m7FaKrtBzUdL8_FG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 phishscore=0 adultscore=0 mlxlogscore=877
 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 clxscore=1011 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
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

Changes v1->v2:
- s/has_zpci_interp/has_zpci_lsi/ (Christian)
- Added many R-bs / ACKs (Thanks!)
- Re-work zpci_set_irq_ctrl (Niklas)
- Simplify changes made for zpci_get_mdd (Niklas, Christian)
- 'KVM: s390: pci: add basic kvm_zdev structure' changes (Pierre)
- only build s390/kvm/pci.o when CONFIG_PCI
- Related to the above, add some more checks for
  IS_ENABLED(CONFIG_PCI) (Pierre)
- Drop set_kvm_facility until VSIE support (Christian)
- Use sclp check instead of stfle when setting ECB (Christian)
- remove unnecessary externs from header (Pierre)
- macro for checkling if shadow ioat is initialized (Pierre)
- Fix interrupt case where we have both AEN and alert list (Christian)
- Re-work AEN setup to satisfy firmware requirements on all supported
  platforms
- V!=R changes (Niklas)
- vifo_pci_zdev_feat_* - check argz against data size (Pierre, Alex)
- vfio_pci_zdev_{open,release} switch to return void (Alex)
- Related to the above, make kvm_s390_pci_*_probe functions return error
  if KVM is not registered for the device (Alex)
- Fix my probe implementation to ignore GET|SET, as these don't change
  the result of the probe.  I was erroneously performing the GET or SET
  operation if specified along with PROBE.
- A few additional fixes regarding ioctl implementation.  Return EINVAL
  if none of PROBE|GET|SET are specified.  Return EINVAL if both GET
  and SET are specified (without PROBE).
- New patch to return status from zpci_refresh_trans (Pierre, Niklas)
- And use that status when possible for KVM rpcit intercept (Pierre)

Matthew Rosato (30):
  s390/sclp: detect the zPCI load/store interpretation facility
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
  s390/pci: return status from zpci_refresh_trans
  KVM: s390: pci: add basic kvm_zdev structure
  KVM: s390: pci: do initial setup for AEN interpretation
  KVM: s390: pci: enable host forwarding of Adapter Event Notifications
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
 arch/s390/include/asm/pci.h      |  12 +
 arch/s390/include/asm/pci_clp.h  |  11 +-
 arch/s390/include/asm/pci_dma.h  |   3 +
 arch/s390/include/asm/pci_insn.h |  31 +-
 arch/s390/include/asm/sclp.h     |   4 +
 arch/s390/include/asm/tpi.h      |  13 +
 arch/s390/include/uapi/asm/kvm.h |   1 +
 arch/s390/kvm/Makefile           |   2 +-
 arch/s390/kvm/interrupt.c        |  94 +++-
 arch/s390/kvm/kvm-s390.c         |  56 ++-
 arch/s390/kvm/kvm-s390.h         |  10 +
 arch/s390/kvm/pci.c              | 837 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h              |  59 +++
 arch/s390/kvm/priv.c             |  46 ++
 arch/s390/pci/pci.c              |  31 ++
 arch/s390/pci/pci_clp.c          |  31 +-
 arch/s390/pci/pci_dma.c          |   7 +-
 arch/s390/pci/pci_insn.c         |  15 +-
 arch/s390/pci/pci_irq.c          |  48 +-
 drivers/iommu/s390-iommu.c       |   4 +-
 drivers/s390/char/sclp_early.c   |   4 +
 drivers/s390/cio/airq.c          |  12 +-
 drivers/s390/cio/qdio_thinint.c  |   6 +-
 drivers/s390/crypto/ap_bus.c     |   9 +-
 drivers/s390/virtio/virtio_ccw.c |   6 +-
 drivers/vfio/pci/Kconfig         |  11 +
 drivers/vfio/pci/Makefile        |   2 +-
 drivers/vfio/pci/vfio_pci_core.c |   8 +
 drivers/vfio/pci/vfio_pci_zdev.c | 290 ++++++++++-
 include/linux/vfio_pci_core.h    |  42 +-
 include/uapi/linux/vfio.h        |  22 +
 include/uapi/linux/vfio_zdev.h   |  51 ++
 36 files changed, 1788 insertions(+), 66 deletions(-)
 create mode 100644 arch/s390/include/asm/kvm_pci.h
 create mode 100644 arch/s390/kvm/pci.c
 create mode 100644 arch/s390/kvm/pci.h

-- 
2.27.0


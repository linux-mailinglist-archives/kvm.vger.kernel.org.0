Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D384AA1AE
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241048AbiBDVPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:15:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8954 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240876AbiBDVPu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:15:50 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214KckLO010586;
        Fri, 4 Feb 2022 21:15:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=0uaGQR6uIlvL7ojX7/vjbZz/VTo1riAHgil/dWRqh20=;
 b=hKMOGGqGq17yD1u26ozdVQ96k4MPz7I+HhDY1vfy73bBpkGsYzEgeWRX9hh3QSizbLpX
 bRLekRvdEd5efJrwLz0b+tpEhnkR4pBhn2G4kYhW6PwBaW1S6MKPL9bOR24il6yXuZIF
 7XxoOFfpuabDsMl1W4LSBQy1IKJ4sMzcLmibbuQ5tAnXU7r443S16UA1W817VRfeLSAp
 jhp+8/i8eS69TgWT3MJp7ucoBxaECjnNdTP7U6wPXgRDVBqKKNJFupPpC8RsA3/lUOv3
 Bpd/tWmmL6ORbg42CgWNRwnHZ7R2yfsCWJB+SKEbuwIwfyBSAs/mc+BgEoXl/ODOe1c1 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e109f6web-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:15:49 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214LFmgC021917;
        Fri, 4 Feb 2022 21:15:48 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e109f6wdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:15:48 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LD5UE009663;
        Fri, 4 Feb 2022 21:15:46 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3e0r0syedp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:15:46 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LFhSU35389770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:15:43 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AF7A136051;
        Fri,  4 Feb 2022 21:15:43 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55A6E136060;
        Fri,  4 Feb 2022 21:15:41 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:15:41 +0000 (GMT)
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
Subject: [PATCH v3 00/30] KVM: s390: enable zPCI for interpretive execution
Date:   Fri,  4 Feb 2022 16:15:06 -0500
Message-Id: <20220204211536.321475-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JfBQr8BWTaghYdXW7w8XH0lVcxiK1aQ6
X-Proofpoint-ORIG-GUID: NpXLKrd1AhkWyYf6MdbgMfx_9YPmS1dC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 phishscore=0 impostorscore=0 malwarescore=0 mlxscore=0 adultscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
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

Changelog v2->v3:
- More R-bs / ACKs (Thanks!)
- Re-word patch 6 commit message (Claudio)
- Patch 8 + some later patches: s/gd/gisa/ (Pierre)
- Patch 12: remove !mdd check (Pierre)
- some more virt/phys conversions (Pierre)
- Patch 18: check more sclp bits & facilities during interp probe (Pierre)
- Patch 21: fix fabricated status for some RPCIT intercept errors
- Patch 25-27: remove get/set checks from feature ioctl handlers as they
  are already done in vfio core (Pierre)
- Patch 26: s/aif/aif_float/ and s/fhost/aif_fhost/
- remove kvm_s390_pci_attach_kvm and just do the work inline (Pierre)
- Use CONFIG_VFIO_PCI_ZDEV instead of CONFIG_PCI in Makefile and other
  code locations (Pierre)
- Due to the above, re-arrange series order so CONFIG_VFIO_PCI_ZDEV is
  introduced earlier
- s/aift->lock/aift->aift_lock/ (Pierre)
- Break some AEN init code into local functions zpci_setup_aipb() and
  zpci_reset_aipb() (Pierre)
- check for errors on kvm_s390_gisc_register (Pierre)
- handle airq clear errors differently when we know the device is being
  removed vs any other reason aif is being disabled (Pierre)
- s/ioat->lock/ioat->ioat_lock/ (Pierre)
- Fix backout case in kvm_s390_pci_ioat_enable, re-arrange rc settings
  slightly (Pierre)
- Add a CONFIG_VFIO_PCI_ZDEV check when determining if its safe to allow
  KVM_S390_VM_CPU_FEAT_ZPCI_INTERP (need both the facilities and the 
  kvm/pci.o pieces to allow intepretation)

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
  vfio/pci: re-introduce CONFIG_VFIO_PCI_ZDEV
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
 arch/s390/include/asm/kvm_pci.h  |  60 +++
 arch/s390/include/asm/pci.h      |  12 +
 arch/s390/include/asm/pci_clp.h  |  11 +-
 arch/s390/include/asm/pci_dma.h  |   3 +
 arch/s390/include/asm/pci_insn.h |  31 +-
 arch/s390/include/asm/sclp.h     |   4 +
 arch/s390/include/asm/tpi.h      |  13 +
 arch/s390/include/uapi/asm/kvm.h |   1 +
 arch/s390/kvm/Makefile           |   1 +
 arch/s390/kvm/interrupt.c        |  95 +++-
 arch/s390/kvm/kvm-s390.c         |  57 ++-
 arch/s390/kvm/kvm-s390.h         |  10 +
 arch/s390/kvm/pci.c              | 850 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h              |  60 +++
 arch/s390/kvm/priv.c             |  49 ++
 arch/s390/pci/pci.c              |  31 ++
 arch/s390/pci/pci_clp.c          |  28 +-
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
 drivers/vfio/pci/vfio_pci_zdev.c | 275 +++++++++-
 include/linux/vfio_pci_core.h    |  42 +-
 include/uapi/linux/vfio.h        |  22 +
 include/uapi/linux/vfio_zdev.h   |  51 ++
 36 files changed, 1787 insertions(+), 65 deletions(-)
 create mode 100644 arch/s390/include/asm/kvm_pci.h
 create mode 100644 arch/s390/kvm/pci.c
 create mode 100644 arch/s390/kvm/pci.h

-- 
2.27.0


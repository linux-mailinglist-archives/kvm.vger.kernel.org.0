Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B910F5330CC
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 20:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240532AbiEXS7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 14:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240524AbiEXS7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 14:59:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C775BD3D;
        Tue, 24 May 2022 11:59:21 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OIebXe006353;
        Tue, 24 May 2022 18:59:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=bpiP7NsTBZVUMNg5kWMsnCx1uMxRVeES8SFoFrfSGtY=;
 b=F/UzZ9ak5qxxtMFgA0Uk/ArFGdlRXvN0mCV+t2yTV5uIDBGgRRlCB0YWuEFcQjYTTL7c
 dbCfkTQjuRgKyNNvRAbGnkh4nqcC1IStUFcboqv8Cf66owIO6IFTJb2MZYKhqtyB1mMw
 ZRlVWoVYnvfuxmo9EUH7fu36BZmqWpncbW/dx0K0Oa/H0pBZzd9MX0lgo65hjZc1l/s+
 EW+lAnuEHQ2/LPKIrqpA7NIhl1CIG80j0nI39zPHeD/uKAK7AbXKv2Sb0mL5xCRI31df
 uLEchUOUY6gBbR5Ra+ACTY1Mm5zqiTLZ8lDEABbpNCf/9lcnCE7NA6nJorxFu/M04Jc3 +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g93vcsgnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:17 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OIgT0Q018127;
        Tue, 24 May 2022 18:59:17 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g93vcsgng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:16 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OIs7BD011479;
        Tue, 24 May 2022 18:59:16 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 3g93utrnua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:16 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OIxEbG14418514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:59:14 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EBB7BE04F;
        Tue, 24 May 2022 18:59:14 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A3E0BE053;
        Tue, 24 May 2022 18:59:12 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.3.233])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 18:59:12 +0000 (GMT)
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
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v8 00/22] KVM: s390: enable zPCI for interpretive execution
Date:   Tue, 24 May 2022 14:58:45 -0400
Message-Id: <20220524185907.140285-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6Vb2mFBDMqjEdg1QXwrBJMUcB8eZCMbW
X-Proofpoint-ORIG-GUID: _eg9s0IbW3434w2HzOEBiD1AQIb82Eej
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 mlxscore=0 mlxlogscore=751
 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Note: this version of the series is built on top of vfio -next:
https://github.com/awilliam/linux-vfio/tree/next
As it now depends on 'vfio: remove VFIO_GROUP_NOTIFY_SET_KVM' and its
prereqs.
Additionally, if you care to try testing this series on top of vfio -next
you'll also want to pick up this fix:
https://lore.kernel.org/kvm/20220519182929.581898-1-mjrosato@linux.ibm.com/

---

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

Will follow up with a link an updated QEMU series.

Changelog v7->v8:
- Fix ioctl documentation (Thomas)
- remove copy_to_user from ioctl, was from old version (Thomas)
- KVM_S390_ZPCIOP_REG_AEN: fail on undefined flags (Thomas)
- kvm_s390_pci_zpci_reg_aen: cleanup hostflag setting (Thomas) and
  also fix an accidental bit inversion while at it
- CONFIG_VFIO_PCI_ZDEV_KVM: add the 'say Y' that was accidentally left
  out of the help text (Jason)
- Restructure the vfio-pci-zdev pieces on top of 'vfio: remove
  VFIO_GROUP_NOTIFY_SET_KVM' (Jason) - open_device/close_device will now
  call the kvm registration routines directly.  Move the open_device call
  to vfio_pci_core_enable so that errors can be propogated.  For parity,
  move the close_device call to vfio_pci_core_disable.

Matthew Rosato (22):
  s390/sclp: detect the zPCI load/store interpretation facility
  s390/sclp: detect the AISII facility
  s390/sclp: detect the AENI facility
  s390/sclp: detect the AISI facility
  s390/airq: pass more TPI info to airq handlers
  s390/airq: allow for airq structure that uses an input vector
  s390/pci: externalize the SIC operation controls and routine
  s390/pci: stash associated GISA designation
  s390/pci: stash dtsm and maxstbl
  vfio/pci: introduce CONFIG_VFIO_PCI_ZDEV_KVM
  KVM: s390: pci: add basic kvm_zdev structure
  KVM: s390: pci: do initial setup for AEN interpretation
  KVM: s390: pci: enable host forwarding of Adapter Event Notifications
  KVM: s390: mechanism to enable guest zPCI Interpretation
  KVM: s390: pci: provide routines for enabling/disabling interrupt
    forwarding
  KVM: s390: pci: add routines to start/stop interpretive execution
  vfio-pci/zdev: add open/close device hooks
  vfio-pci/zdev: add function handle to clp base capability
  vfio-pci/zdev: different maxstbl for interpreted devices
  KVM: s390: add KVM_S390_ZPCI_OP to manage guest zPCI devices
  KVM: s390: introduce CPU feature for zPCI Interpretation
  MAINTAINERS: additional files related kvm s390 pci passthrough

 Documentation/virt/kvm/api.rst   |  46 ++
 MAINTAINERS                      |   1 +
 arch/s390/include/asm/airq.h     |   7 +-
 arch/s390/include/asm/kvm_host.h |  26 ++
 arch/s390/include/asm/pci.h      |  13 +
 arch/s390/include/asm/pci_clp.h  |   9 +-
 arch/s390/include/asm/pci_insn.h |  29 +-
 arch/s390/include/asm/sclp.h     |   4 +
 arch/s390/include/asm/tpi.h      |  13 +
 arch/s390/include/uapi/asm/kvm.h |   1 +
 arch/s390/kvm/Makefile           |   1 +
 arch/s390/kvm/interrupt.c        |  96 ++++-
 arch/s390/kvm/kvm-s390.c         |  87 +++-
 arch/s390/kvm/kvm-s390.h         |  10 +
 arch/s390/kvm/pci.c              | 695 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h              |  88 ++++
 arch/s390/pci/pci.c              |  16 +
 arch/s390/pci/pci_clp.c          |   7 +
 arch/s390/pci/pci_insn.c         |   4 +-
 arch/s390/pci/pci_irq.c          |  48 ++-
 drivers/s390/char/sclp_early.c   |   4 +
 drivers/s390/cio/airq.c          |  12 +-
 drivers/s390/cio/qdio_thinint.c  |   6 +-
 drivers/s390/crypto/ap_bus.c     |   9 +-
 drivers/s390/virtio/virtio_ccw.c |   6 +-
 drivers/vfio/pci/Kconfig         |  11 +
 drivers/vfio/pci/Makefile        |   2 +-
 drivers/vfio/pci/vfio_pci_core.c |  11 +-
 drivers/vfio/pci/vfio_pci_zdev.c |  38 +-
 include/linux/sched/user.h       |   3 +-
 include/linux/vfio_pci_core.h    |  14 +-
 include/uapi/linux/kvm.h         |  32 ++
 include/uapi/linux/vfio_zdev.h   |   7 +
 33 files changed, 1300 insertions(+), 56 deletions(-)
 create mode 100644 arch/s390/kvm/pci.c
 create mode 100644 arch/s390/kvm/pci.h

-- 
2.27.0


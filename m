Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E6B53EFA0
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 22:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbiFFUd4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 16:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiFFUds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 16:33:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881557DE23;
        Mon,  6 Jun 2022 13:33:43 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256KUxx4005372;
        Mon, 6 Jun 2022 20:33:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=0nbv7Dw2PWXTPm4cBe+X9QuVta4ICgQiUQAAASm9yCI=;
 b=rRYfSgAP2owsryPWhXkniIYc++jIRWYtYZ6Kopw5ItvRa04XGNrpjiiFWf5IGQ7aUOCg
 KRXivRLfHUaJgIKJ2LX66S2IPvyZitOFxW9D6VlYiVhOUZlBwSIww+iaSbHHnNjEpnQK
 H2LKVX2EnAN5/uUniOh9YwM9blVjEH0ypzfCdXW5uKHO5ukvHVNBaWZKLPwvVTfGs10y
 8OLmuqRsSPilp4UDnF6XTNqIZqqpm0bFfsEjC/Z4zrvs8+LvARk9urS0YjsLAk540BXq
 7wi3rV402FfG6DKqxOZfiPg4++BgO57CSX7xxodb4XEEqYtPxmqmAkKzqVEW9JeUf5O2 Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqpegyhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:33:39 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 256KV1t7005647;
        Mon, 6 Jun 2022 20:33:39 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqpegyh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:33:39 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 256KKZ9h024218;
        Mon, 6 Jun 2022 20:33:38 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 3gfy19utn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:33:38 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 256KXbDW8847666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jun 2022 20:33:37 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21EBF2805A;
        Mon,  6 Jun 2022 20:33:37 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68E422805C;
        Mon,  6 Jun 2022 20:33:30 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.20.188])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jun 2022 20:33:30 +0000 (GMT)
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
Subject: [PATCH v9 00/21] KVM: s390: enable zPCI for interpretive execution
Date:   Mon,  6 Jun 2022 16:33:04 -0400
Message-Id: <20220606203325.110625-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: omq43zn8Fvpd3iFHsPjZqZEbFgnkl7K6
X-Proofpoint-ORIG-GUID: sMVQ8GBkz46JvGw-FcCj701Z55cO68El
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 adultscore=0 impostorscore=0 malwarescore=0 phishscore=0 mlxlogscore=711
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Will follow up with a link the most recent QEMU series.

Changelog v8->v9:
- Rebase on top of 5.19-rc1, adjust ioctl and capability defines
- s/kzdev = 0/kzdev = NULL/ (Alex)
- rename vfio_pci_zdev_open to vfio_pci_zdev_open_device (Jason)
- rename vfio_pci_zdev_release to vfio_pci_zdev_close_device (Jason)
- make vfio_pci_zdev_close_device return void, instead WARN_ON or ignore
  errors in lower level function (kvm_s390_pci_unregister_kvm) (Jason)
- remove notifier accidentally left in struct zpci_dev + associated
  include statment (Jason)
- Remove patch 'KVM: s390: introduce CPU feature for zPCI Interpretation'
  based on discussion in QEMU thread.

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
  MAINTAINERS: additional files related kvm s390 pci passthrough

 Documentation/virt/kvm/api.rst   |  47 +++
 MAINTAINERS                      |   1 +
 arch/s390/include/asm/airq.h     |   7 +-
 arch/s390/include/asm/kvm_host.h |  23 ++
 arch/s390/include/asm/pci.h      |  11 +
 arch/s390/include/asm/pci_clp.h  |   9 +-
 arch/s390/include/asm/pci_insn.h |  29 +-
 arch/s390/include/asm/sclp.h     |   4 +
 arch/s390/include/asm/tpi.h      |  13 +
 arch/s390/kvm/Makefile           |   1 +
 arch/s390/kvm/interrupt.c        |  96 ++++-
 arch/s390/kvm/kvm-s390.c         |  83 +++-
 arch/s390/kvm/kvm-s390.h         |  10 +
 arch/s390/kvm/pci.c              | 690 +++++++++++++++++++++++++++++++
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
 drivers/vfio/pci/vfio_pci_core.c |  10 +-
 drivers/vfio/pci/vfio_pci_zdev.c |  35 +-
 include/linux/sched/user.h       |   3 +-
 include/linux/vfio_pci_core.h    |  12 +-
 include/uapi/linux/kvm.h         |  31 ++
 include/uapi/linux/vfio_zdev.h   |   7 +
 32 files changed, 1279 insertions(+), 56 deletions(-)
 create mode 100644 arch/s390/kvm/pci.c
 create mode 100644 arch/s390/kvm/pci.h

-- 
2.27.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE7F5269F5
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 21:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238846AbiEMTPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 15:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiEMTPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 15:15:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C15E71;
        Fri, 13 May 2022 12:15:29 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24DJ3dKq011432;
        Fri, 13 May 2022 19:15:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=a+q0Yc0vSrC/CepGQfWNyFLtWyth8iIiCutvd6E9MJU=;
 b=Z0ZIs7jqsisJQ9xG/WXpQ+PmAZiw41Qj/C2gNlPwOAEHKvaqdKQ7sMcMzh9hfOpewvVg
 0kP5fvS1RqGK+W6IMdRBtKegG1RxIeomTtJsu27SsamvA457pJbiW6Y9lNp1HlZO3ju+
 nLHHr1vfnA0R3Ulphac46GtlcpbBhqrm0vPtL1itoK0sgq1Il+xkDCP7BJW+ai8NHOAs
 ytcBGLSm4tvbZBUnAVROhQ/NyauF3cDFG5+sVUXukY6eMJHmL4YKRg+Taquk1pv60vs3
 pYLcNKYIV79BrspD2WFW/uqYdT915XeMuFHASdN7t2tlIhZe6RMM+NSCCkymPqnq8f/3 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1ut5sr29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:15:26 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24DIwn1W030459;
        Fri, 13 May 2022 19:15:25 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1ut5sr1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:15:25 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24DJDIPF003015;
        Fri, 13 May 2022 19:15:24 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 3fwgdbfcx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:15:24 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24DJFN7P7864700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 19:15:23 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABEF8124054;
        Fri, 13 May 2022 19:15:23 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECA7C124053;
        Fri, 13 May 2022 19:15:17 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.49.28])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 19:15:17 +0000 (GMT)
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
Subject: [PATCH v7 00/22] KVM: s390: enable zPCI for interpretive execution
Date:   Fri, 13 May 2022 15:14:47 -0400
Message-Id: <20220513191509.272897-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zr6hOfC12glqr5dKjIOblrxn0FpbKwrI
X-Proofpoint-ORIG-GUID: 6AWnWFPhgXz0tUykJdwm2rpYn2kX2YZw
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_11,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=811 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130076
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

Some minor changes are already suggested for the QEMU series, but for
now the v5 one is still compatible (with one exception: in
linux-headers/linux/kvm.h KVM_CAP_S390_ZPCI_OP is now changed to 216)

https://lore.kernel.org/kvm/20220404181726.60291-1-mjrosato@linux.ibm.com/

Changelog v6->v7:
- Add some more R-b tags
- Mark a few routines static (kernel bot)
- Add a few lockdep_assert_held calls (Christian)
- Add a new condition under which locked_vm is defined (Christian)
- After discussions with Jason, let's go back to using a Kconfig option
  to control vfio-pci-zdev inclusion so we can avoid some symbol_get
  messiness.  The name was chosen so that we can re-introduce zdev
  for non-KVM environments in the future, should it be needed.
- Since we re-introduce a Kconfig option, we can go back to using this in
  various places instead of CONFIG_VFIO_PCI.
- Expose separate interfaces for register and unregister of kvm (Jason)
- Cleanup KVM association during zdev device_close; if the device fd is
  closed before we receive the kvm notifier, we will never see the
  notification because we unregister it, but cleanup must still be done.
  Conversely, if the kvm fd closes before the device is closed, we
  should get the NULL notifier from kvm_destroy_devices since the notifier
  has not yet been unregistered.
- As a result of the above, we no longer need to clear the pci list during
  vm exit.  But to be safe let's WARN_ON_ONCE if it's found to be non-empty
  during free_vm.
- Add kzdev_lock to protect the kzdev
- uapi KVM_CAP_S390_ZPCI_OP moved to 216 (previously 214)

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

 Documentation/virt/kvm/api.rst   |  45 ++
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
 arch/s390/kvm/kvm-s390.c         |  94 ++++-
 arch/s390/kvm/kvm-s390.h         |  10 +
 arch/s390/kvm/pci.c              | 686 +++++++++++++++++++++++++++++++
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
 drivers/vfio/pci/vfio_pci_core.c |   2 +
 drivers/vfio/pci/vfio_pci_zdev.c |  65 ++-
 include/linux/sched/user.h       |   3 +-
 include/linux/vfio_pci_core.h    |  12 +-
 include/uapi/linux/kvm.h         |  31 ++
 include/uapi/linux/vfio_zdev.h   |   7 +
 33 files changed, 1313 insertions(+), 55 deletions(-)
 create mode 100644 arch/s390/kvm/pci.c
 create mode 100644 arch/s390/kvm/pci.h

-- 
2.27.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F31C51099B
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 22:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354479AbiDZUMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 16:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242266AbiDZUMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 16:12:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10AE160943;
        Tue, 26 Apr 2022 13:08:56 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QK4D2G029497;
        Tue, 26 Apr 2022 20:08:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=r/oHDfb3wqttXyg8WD8ijMXIoEJZISLmGztuIXE0le0=;
 b=fP7z4UlWNIHnAJ9icdi6zqdtj/VckLThw2IFRBEdNkxi8Fi9Iv1Pf/1u52c3VeNpDlxg
 cZpiw6G/GOwQL16NHiqtbt/bPKsxpkLd3F2mqEHGtzTT0BdOJbfhZBMvpRc+z+I8Zeb3
 yn8c65Au2ZX8+DOMxbG3ClJMFjvB6Kzd+Myo2gTVZnWv1Rx9kR2yPXDYK6NtHphAiHLH
 ZYUKCXyrr6XnhzlBzaitEq1wutZSEWAlwqrwvxI4UPF86QiYwy1bDjqGAUVQk71eUdvb
 1PdzAN2Sha8ac2qozYklu3XWwBafWILV/2s3q6pgxw2lbgFSc66sYI9NNlyXmbQF1s9w Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpnhujcmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:08:53 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23QK8rLT016112;
        Tue, 26 Apr 2022 20:08:53 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpnhujcks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:08:53 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23QK8S4W031147;
        Tue, 26 Apr 2022 20:08:51 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03wdc.us.ibm.com with ESMTP id 3fm939ffwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:08:51 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23QK8oYF4391870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 20:08:50 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A79ABB205F;
        Tue, 26 Apr 2022 20:08:50 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EF24B2065;
        Tue, 26 Apr 2022 20:08:46 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.73.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 26 Apr 2022 20:08:46 +0000 (GMT)
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
Subject: [PATCH v6 00/21] KVM: s390: enable zPCI for interpretive execution
Date:   Tue, 26 Apr 2022 16:08:21 -0400
Message-Id: <20220426200842.98655-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HnmVcpyemUPJRHFYY5PwyNGyjz7i7l2o
X-Proofpoint-ORIG-GUID: lgOIAYejhg4PYviO-ZqHaWpamvi2iK6B
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_06,2022-04-26_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 mlxlogscore=672 adultscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
now the v5 one is still compatible:

https://lore.kernel.org/kvm/20220404181726.60291-1-mjrosato@linux.ibm.com/

Changelog v5->v6:                                                               
- Add more R-b tags                                                             
- Address a leak of aift during rmmod kvm (Christian) also destroy the          
  associated mutex at this time                                                 
- only need to check nisc match during 2nd insmod of kvm (Pierre)               
- Register for kvm notifier in vfio_pci_zdev open_device, use this to           
  trigger GISA (un)registration instead of via iommu_group_for_each_dev         
  from virt/kvm/vfio.c (Jason)                                                  
- Since we now always enable the interpretation facilities once a               
  passthrough PCI device is detected, let's just set the ECB during             
  init vm -- SHM bits will always be used to override load/store                
  interpretation                                                                
- Still using KVM_S390_ZPCI_OP for AEN setup/teardown; we can continue          
  to discuss alternatives if it makes sense, but wanted to update the           
  rest of the series so review can continue.   

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
  vfio-pci/zdev: add open/close device hooks
  vfio-pci/zdev: add function handle to clp base capability
  vfio-pci/zdev: different maxstbl for interpreted devices
  KVM: s390: add KVM_S390_ZPCI_OP to manage guest zPCI devices
  KVM: s390: introduce CPU feature for zPCI Interpretation
  MAINTAINERS: additional files related kvm s390 pci passthrough

 Documentation/virt/kvm/api.rst   |  45 +++
 MAINTAINERS                      |   1 +
 arch/s390/include/asm/airq.h     |   7 +-
 arch/s390/include/asm/kvm_host.h |  18 +
 arch/s390/include/asm/pci.h      |  12 +
 arch/s390/include/asm/pci_clp.h  |   9 +-
 arch/s390/include/asm/pci_insn.h |  29 +-
 arch/s390/include/asm/sclp.h     |   4 +
 arch/s390/include/asm/tpi.h      |  13 +
 arch/s390/include/uapi/asm/kvm.h |   1 +
 arch/s390/kvm/Makefile           |   1 +
 arch/s390/kvm/interrupt.c        |  95 ++++-
 arch/s390/kvm/kvm-s390.c         |  87 +++-
 arch/s390/kvm/kvm-s390.h         |  10 +
 arch/s390/kvm/pci.c              | 667 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h              |  87 ++++
 arch/s390/pci/pci.c              |  15 +
 arch/s390/pci/pci_clp.c          |   7 +
 arch/s390/pci/pci_insn.c         |   4 +-
 arch/s390/pci/pci_irq.c          |  48 ++-
 drivers/s390/char/sclp_early.c   |   4 +
 drivers/s390/cio/airq.c          |  12 +-
 drivers/s390/cio/qdio_thinint.c  |   6 +-
 drivers/s390/crypto/ap_bus.c     |   9 +-
 drivers/s390/virtio/virtio_ccw.c |   6 +-
 drivers/vfio/pci/vfio_pci_core.c |   2 +
 drivers/vfio/pci/vfio_pci_zdev.c |  61 ++-
 include/linux/vfio_pci_core.h    |  10 +
 include/uapi/linux/kvm.h         |  31 ++
 include/uapi/linux/vfio_zdev.h   |   7 +
 30 files changed, 1256 insertions(+), 52 deletions(-)
 create mode 100644 arch/s390/kvm/pci.c
 create mode 100644 arch/s390/kvm/pci.h

-- 
2.27.0


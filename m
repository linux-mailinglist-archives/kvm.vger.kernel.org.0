Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3642E4D8CA5
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244163AbiCNTqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbiCNTqa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:46:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A781A3DA72;
        Mon, 14 Mar 2022 12:45:19 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EHBvKn019697;
        Mon, 14 Mar 2022 19:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=/hwSAR5BVdkOZcTPJCAaO1IuJhMp7jzA5H4sI9cz9Dg=;
 b=lzvtlic/VOxPKZRCAzdWFFXk7lFwssV9etyTQSfdgO//yxP5zB7WLqxuIuJpddgBNOLs
 r6jBWIdTvtiYFP/VI+L//67Y28b7Ym+a48OrdV4sZQAtz/zzFyx8w4V7Gc478UldLkJn
 N38/PLDjJ6BNsnvgenjrHn1cNYtAm3Elp0rgdbzJYEprQc77nR9gu510JiTDSvYJzfr4
 0CcHMKkvqoIYs9/9jeJwgLQEDiOPHUmzNyRus4xr2ieda1rdH7K/2WnKPNOJFZ7KA7u6
 8SZBGHo9i+Wu5qpL5I59uQ0srJFdsAetUzCa9ZHZ0Ezqei8xHbGTTDWi6CTKaCRKzWrK Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6ab8yfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:45:09 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJfAhX031377;
        Mon, 14 Mar 2022 19:45:09 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6ab8yf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:45:09 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJNAKS001522;
        Mon, 14 Mar 2022 19:45:08 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 3erk59cbee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:45:08 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJj63O49283414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:45:06 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C7D0112061;
        Mon, 14 Mar 2022 19:45:06 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EC07112072;
        Mon, 14 Mar 2022 19:44:57 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:44:57 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-doc@vger.kernel.org
Subject: [PATCH v4 00/32] KVM: s390: enable zPCI for interpretive execution
Date:   Mon, 14 Mar 2022 15:44:19 -0400
Message-Id: <20220314194451.58266-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xa1l7CbMIgcdBMFuE7HMwzZnD9IU14hk
X-Proofpoint-ORIG-GUID: EbTFTILbPBM9yQ4FL-RDUedLcPPSP-Fi
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=14 lowpriorityscore=14 mlxlogscore=339 adultscore=0
 suspectscore=0 mlxscore=0 clxscore=1011 phishscore=0 impostorscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Note: A few patches in this series are dependent on Baolu's IOMMU domain ops    
split, which is currently in the next branch of linux-iommu. This series        
applies on top:                                                                 
https://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git     

Enable interpretive execution of zPCI instructions + adapter interruption
forwarding for s390x KVM vfio-pci.  This is done by introducing a new IOMMU
domain for s390x (KVM-managed), indicating via vfio that this IOMMU domain
should be used instead of the default, with subsequent management of the
hardware assists being handled via a new KVM ioctl for zPCI management.

By allowing intepretation of zPCI instructions and firmware delivery of         
interrupts to guests, we can significantly reduce the frequency of guest        
SIE exits for zPCI.  We then see additional gains by handling a hot-path        
instruction that can still intercept to the hypervisor (RPCIT) directly         
in kvm via the new IOMMU domain, whose map operations update the host           
DMA table with pinned guest entries over the specified range.

From the perspective of guest configuration, you passthrough zPCI devices
in the same manner as before, with intepretation support being used by
default if available in kernel+qemu.

Will reply with a link to the associated QEMU series.

Changelog v3->v4:
v3: https://lore.kernel.org/kvm/20220204211536.321475-1-mjrosato@linux.ibm.com/ 
- Significant overhaul of the userspace API.  Remove all vfio device
  feature ioctls.  Remove CONFIG_VFIO_PCI_ZDEV, this is once again always
  built with vfio-pci for s390; IS_ENABLED checks can instead look at
  CONFIG_VFIO_PCI.  Most earlier patches in the series could maintain
  their reviews, but some needed to be removed due to required code
  changes.
- Instead use a KVM ioctl for zPCI management.  The API is very similar
  to the feature ioctls used in the prior series, with an additional step
  to create an association between an iommu domain + KVM + zPCI device.
- Introduce a new iommu domain ops type for s390-iommu, to be used when         
  KVM manages the IOMMU instead of in response to VFIO mapping ioctls 
- Add a iommu method for specifying the type of domain to allocate
- Add a new type to vfio_iommu_type1 (KVM-owned) to trigger the allocation
  of the KVM-owned IOMMU domain when zPCI interpretation is requested.
  In this case, the KVM-owned type is specified on VFIO_SET_IOMMU. 
- Wire the RPCIT intercepts into the new IOMMU domain via the kernel
  IOMMU API 
- Remove a bunch of unnecessary symbol externs, make the associated
  functions static
- Now that we keep a list of zPCI associated with a given KVM, we can do
  fh lookup on this list vs the list of all zPCI on the host.  We only
  need to do a host-wide fh lookup during the initial device<->KVM
  association.


Matthew Rosato (32):
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
  iommu: introduce iommu_domain_alloc_type and the KVM type
  vfio: introduce KVM-owned IOMMU type
  vfio-pci/zdev: add function handle to clp base capability
  KVM: s390: pci: add basic kvm_zdev structure
  iommu/s390: add support for IOMMU_DOMAIN_KVM
  KVM: s390: pci: do initial setup for AEN interpretation
  KVM: s390: pci: enable host forwarding of Adapter Event Notifications
  KVM: s390: mechanism to enable guest zPCI Interpretation
  KVM: s390: pci: routines for (dis)associating zPCI devices with a KVM
  KVM: s390: pci: provide routines for enabling/disabling interpretation
  KVM: s390: pci: provide routines for enabling/disabling interrupt
    forwarding
  KVM: s390: pci: provide routines for enabling/disabling IOAT assist
  KVM: s390: pci: handle refresh of PCI translations
  KVM: s390: intercept the rpcit instruction
  KVM: s390: add KVM_S390_ZPCI_OP to manage guest zPCI devices
  vfio-pci/zdev: add DTSM to clp group capability
  KVM: s390: introduce CPU feature for zPCI Interpretation
  MAINTAINERS: additional files related kvm s390 pci passthrough
  MAINTAINERS: update s390 IOMMU entry

 Documentation/virt/kvm/api.rst   |  60 +++
 MAINTAINERS                      |   4 +-
 arch/s390/include/asm/airq.h     |   7 +-
 arch/s390/include/asm/kvm_host.h |   7 +
 arch/s390/include/asm/kvm_pci.h  |  40 ++
 arch/s390/include/asm/pci.h      |  12 +
 arch/s390/include/asm/pci_clp.h  |  11 +-
 arch/s390/include/asm/pci_dma.h  |   3 +
 arch/s390/include/asm/pci_insn.h |  31 +-
 arch/s390/include/asm/sclp.h     |   4 +
 arch/s390/include/asm/tpi.h      |  13 +
 arch/s390/include/uapi/asm/kvm.h |   1 +
 arch/s390/kvm/Makefile           |   1 +
 arch/s390/kvm/interrupt.c        |  95 +++-
 arch/s390/kvm/kvm-s390.c         |  90 +++-
 arch/s390/kvm/kvm-s390.h         |  10 +
 arch/s390/kvm/pci.c              | 833 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h              |  63 +++
 arch/s390/kvm/priv.c             |  46 ++
 arch/s390/pci/pci.c              |  31 ++
 arch/s390/pci/pci_clp.c          |  28 +-
 arch/s390/pci/pci_dma.c          |   7 +-
 arch/s390/pci/pci_insn.c         |  15 +-
 arch/s390/pci/pci_irq.c          |  48 +-
 drivers/iommu/Kconfig            |   8 +
 drivers/iommu/Makefile           |   1 +
 drivers/iommu/iommu.c            |   7 +
 drivers/iommu/s390-iommu.c       |  53 +-
 drivers/iommu/s390-iommu.h       |  53 ++
 drivers/iommu/s390-kvm-iommu.c   | 469 +++++++++++++++++
 drivers/s390/char/sclp_early.c   |   4 +
 drivers/s390/cio/airq.c          |  12 +-
 drivers/s390/cio/qdio_thinint.c  |   6 +-
 drivers/s390/crypto/ap_bus.c     |   9 +-
 drivers/s390/virtio/virtio_ccw.c |   6 +-
 drivers/vfio/pci/vfio_pci_zdev.c |  17 +-
 drivers/vfio/vfio_iommu_type1.c  |  12 +-
 include/linux/iommu.h            |  12 +
 include/uapi/linux/kvm.h         |  43 ++
 include/uapi/linux/vfio.h        |   6 +
 include/uapi/linux/vfio_zdev.h   |   6 +
 41 files changed, 2090 insertions(+), 94 deletions(-)
 create mode 100644 arch/s390/include/asm/kvm_pci.h
 create mode 100644 arch/s390/kvm/pci.c
 create mode 100644 arch/s390/kvm/pci.h
 create mode 100644 drivers/iommu/s390-iommu.h
 create mode 100644 drivers/iommu/s390-kvm-iommu.c

-- 
2.27.0


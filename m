Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3194299116
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 16:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783965AbgJZPfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 11:35:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32562 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1783962AbgJZPfA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 11:35:00 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09QFXfOS159479;
        Mon, 26 Oct 2020 11:34:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=MPOOUrolEsOl3/XJNifqjJs1FTGO61oGzLzV+vkgnVI=;
 b=jEVzicKB4L2L0OhVktpVEPPBzejl/E0w/dpo6OsWI+ICw4C7cewr6CXhFR3xycyKdZxS
 P83ufex40y4L6vrZJMdZkZcO/xonWYOh51ad2M1zQtrn4Ijm8BmQuzvMOQZkKImmACP/
 wJWzVLEZfhGck17yLRvxYLj3iHf9Yqk3o6Hw0k6//NocMfseJdw2CyGdRlMyvQMqnsGb
 qvoTstGZKPeoeciV9tuO4dR8GzngX6sSjCfdG10Tcd+gLGqM/GKkQeCZy1US8EPI6dFM
 Le7CmsYDJcxVh37IF1XcgdS6zMMC8IaBtzFbIfWuuL/TeVD73WpvOrOgcwWgw03zgWHn 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34duwd2bw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 11:34:51 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09QFXqBu159980;
        Mon, 26 Oct 2020 11:34:51 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34duwd2bvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 11:34:51 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09QFIEjA028487;
        Mon, 26 Oct 2020 15:34:50 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 34cbw8vrn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 15:34:50 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09QFYn8L1704660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 15:34:49 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92638112063;
        Mon, 26 Oct 2020 15:34:49 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A5F7112061;
        Mon, 26 Oct 2020 15:34:45 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.49.29])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 26 Oct 2020 15:34:45 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        philmd@redhat.com, qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH 00/13] s390x/pci: s390-pci updates for kernel 5.10-rc1 
Date:   Mon, 26 Oct 2020 11:34:28 -0400
Message-Id: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-26_08:2020-10-26,2020-10-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=831 bulkscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Combined set of patches that exploit vfio/s390-pci features available in
kernel 5.10-rc1.  This patch set is a combination of 

[PATCH v4 0/5] s390x/pci: Accomodate vfio DMA limiting

and

[PATCH v3 00/10] Retrieve zPCI hardware information from VFIO

with duplicate patches removed and a single header sync.  All patches have
prior maintainer reviews except for:

- Patch 1 (update-linux-headers change to add new file) 
- Patch 2 (header sync against 5.10-rc1)
- Patch 13 - contains a functional (debug) change; I switched from using
  DPRINTFs to using trace events per Connie's request.



Matthew Rosato (10):
  update-linux-headers: Add vfio_zdev.h
  linux-headers: update against 5.10-rc1
  s390x/pci: Move header files to include/hw/s390x
  vfio: Create shared routine for scanning info capabilities
  vfio: Find DMA available capability
  s390x/pci: Add routine to get the vfio dma available count
  s390x/pci: Honor DMA limits set by vfio
  s390x/pci: clean up s390 PCI groups
  vfio: Add routine for finding VFIO_DEVICE_GET_INFO capabilities
  s390x/pci: get zPCI function info from host

Pierre Morel (3):
  s390x/pci: create a header dedicated to PCI CLP
  s390x/pci: use a PCI Group structure
  s390x/pci: use a PCI Function structure

 MAINTAINERS                                        |   1 +
 hw/s390x/meson.build                               |   1 +
 hw/s390x/s390-pci-bus.c                            |  91 ++++++-
 hw/s390x/s390-pci-inst.c                           |  78 ++++--
 hw/s390x/s390-pci-vfio.c                           | 276 +++++++++++++++++++++
 hw/s390x/s390-virtio-ccw.c                         |   2 +-
 hw/s390x/trace-events                              |   6 +
 hw/vfio/common.c                                   |  62 ++++-
 {hw => include/hw}/s390x/s390-pci-bus.h            |  22 ++
 .../hw/s390x/s390-pci-clp.h                        | 123 +--------
 include/hw/s390x/s390-pci-inst.h                   | 119 +++++++++
 include/hw/s390x/s390-pci-vfio.h                   |  23 ++
 include/hw/vfio/vfio-common.h                      |   4 +
 .../drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h |  14 +-
 .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.h        |   2 +-
 include/standard-headers/linux/ethtool.h           |   2 +
 include/standard-headers/linux/fuse.h              |  50 +++-
 include/standard-headers/linux/input-event-codes.h |   4 +
 include/standard-headers/linux/pci_regs.h          |   6 +-
 include/standard-headers/linux/virtio_fs.h         |   3 +
 include/standard-headers/linux/virtio_gpu.h        |  19 ++
 include/standard-headers/linux/virtio_mmio.h       |  11 +
 include/standard-headers/linux/virtio_pci.h        |  11 +-
 linux-headers/asm-arm64/kvm.h                      |  25 ++
 linux-headers/asm-arm64/mman.h                     |   1 +
 linux-headers/asm-generic/hugetlb_encode.h         |   1 +
 linux-headers/asm-generic/unistd.h                 |  18 +-
 linux-headers/asm-mips/unistd_n32.h                |   1 +
 linux-headers/asm-mips/unistd_n64.h                |   1 +
 linux-headers/asm-mips/unistd_o32.h                |   1 +
 linux-headers/asm-powerpc/unistd_32.h              |   1 +
 linux-headers/asm-powerpc/unistd_64.h              |   1 +
 linux-headers/asm-s390/unistd_32.h                 |   1 +
 linux-headers/asm-s390/unistd_64.h                 |   1 +
 linux-headers/asm-x86/kvm.h                        |  20 ++
 linux-headers/asm-x86/unistd_32.h                  |   1 +
 linux-headers/asm-x86/unistd_64.h                  |   1 +
 linux-headers/asm-x86/unistd_x32.h                 |   1 +
 linux-headers/linux/kvm.h                          |  19 ++
 linux-headers/linux/mman.h                         |   1 +
 linux-headers/linux/vfio.h                         |  29 ++-
 linux-headers/linux/vfio_zdev.h                    |  78 ++++++
 scripts/update-linux-headers.sh                    |   2 +-
 43 files changed, 961 insertions(+), 173 deletions(-)
 create mode 100644 hw/s390x/s390-pci-vfio.c
 rename {hw => include/hw}/s390x/s390-pci-bus.h (94%)
 rename hw/s390x/s390-pci-inst.h => include/hw/s390x/s390-pci-clp.h (59%)
 create mode 100644 include/hw/s390x/s390-pci-inst.h
 create mode 100644 include/hw/s390x/s390-pci-vfio.h
 create mode 100644 linux-headers/linux/vfio_zdev.h

-- 
1.8.3.1


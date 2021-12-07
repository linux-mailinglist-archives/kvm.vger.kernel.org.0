Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842EC46C5FA
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhLGVIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:08:16 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30270 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231906AbhLGVIQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:08:16 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Jbgqs029315;
        Tue, 7 Dec 2021 21:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=tjlx2QL8QDf3WULmluLGfbug9LASpTBKRRHOHO55agk=;
 b=KLfyTrfG+3l4mvPhKRve1QEg0r9/89Pdb1zNTg4yq57qHogJJidVyv5rsnX9OktEXjwL
 dzQpph34sUEXkcp3k16vSjt8EYBlc3hzTyIRPM1X1781gvFP2ntRytHVu7JIq6Q5XAQT
 1ebTYzR9fVQmTbIWnaylxJLFRY8z2qqWWAkXRBP6DC70OF26QXIY4r4WedaClBm8CAgI
 yKi0fNHH5zKETwffYL96Wt2803PB4dpVR1YmED/0gVK0exp/9L5PdCIqHRVDYPGf805u
 E2NcRR+bgF4vyneOCcbdw7LQMCWWRWIMFhdI3fA49yBKqLuCdP+ebq57xslE+PQRQYiu tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctcd8uryn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:04:37 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7Kmnwd005598;
        Tue, 7 Dec 2021 21:04:37 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctcd8uryc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:04:37 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KvrlG031498;
        Tue, 7 Dec 2021 21:04:36 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 3cqyyamrfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:04:36 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7L4Yoq50987312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 21:04:34 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B109AE067;
        Tue,  7 Dec 2021 21:04:34 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E71DEAE05F;
        Tue,  7 Dec 2021 21:04:30 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 21:04:30 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH 00/12] s390x/pci: zPCI interpretation support
Date:   Tue,  7 Dec 2021 16:04:13 -0500
Message-Id: <20211207210425.150923-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: le1yMdh-O8A2NX2mfSiAP1_rU_KhfBBY
X-Proofpoint-ORIG-GUID: 2yCBLZpkF1SQ44RGWb9kBy4Hgc1bFtz3
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 impostorscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Note:  The first 3 patches of this series are included as pre-reqs, but
should be pulled via a separate series.  Also, patch 5 is needed to
support 5.16+ linux header-sync and was already done by Paolo but not
merged yet so is thus included here as well. 

For QEMU, the majority of the work in enabling instruction interpretation
is handled via new VFIO ioctls to SET the appropriate interpretation and
interrupt forwarding modes, and to GET the function handle to use for
interpretive execution.  

This series implements these new ioctls, as well as adding a new, optional
'intercept' parameter to zpci to request interpretation support not be used
as well as an 'intassist' parameter to determine whether or not the
firmware assist will be used for interrupt delivery or whether the host
will be responsible for delivering all interrupts.

The ZPCI_INTERP CPU feature is added beginning with the z14 model to
enable this support.

As a consequence of implementing zPCI interpretation, ISM devices now
become eligible for passthrough (but only when zPCI interpretation is
available).

From the perspective of guest configuration, you passthrough zPCI devices
in the same manner as before, with intepretation support being used by
default if available in kernel+qemu.

Associated kernel series:
https://lkml.org/lkml/2021/12/7/1179

Matthew Rosato (11):
  s390x/pci: use a reserved ID for the default PCI group
  s390x/pci: don't use hard-coded dma range in reg_ioat
  s390x/pci: add supported DT information to clp response
  Update linux headers
  target/s390x: add zpci-interp to cpu models
  s390x/pci: enable for load/store intepretation
  s390x/pci: don't fence interpreted devices without MSI-X
  s390x/pci: enable adapter event notification for interpreted devices
  s390x/pci: use I/O Address Translation assist when interpreting
  s390x/pci: use dtsm provided from vfio capabilities for interpreted
    devices
  s390x/pci: let intercept devices have separate PCI groups

Paolo Bonzini (1):
  virtio-gpu: do not byteswap padding

 hw/s390x/s390-pci-bus.c                       | 121 +++++++++-
 hw/s390x/s390-pci-inst.c                      | 178 +++++++++++++-
 hw/s390x/s390-pci-vfio.c                      | 221 +++++++++++++++++-
 include/hw/s390x/s390-pci-bus.h               |  11 +-
 include/hw/s390x/s390-pci-clp.h               |   3 +-
 include/hw/s390x/s390-pci-inst.h              |   2 +-
 include/hw/s390x/s390-pci-vfio.h              |  45 ++++
 include/hw/virtio/virtio-gpu-bswap.h          |   1 -
 include/standard-headers/asm-x86/kvm_para.h   |   1 +
 include/standard-headers/drm/drm_fourcc.h     | 121 +++++++++-
 include/standard-headers/linux/ethtool.h      |  31 +++
 include/standard-headers/linux/fuse.h         |  15 +-
 include/standard-headers/linux/pci_regs.h     |   6 +
 include/standard-headers/linux/virtio_gpu.h   |  18 +-
 include/standard-headers/linux/virtio_ids.h   |  24 ++
 include/standard-headers/linux/virtio_mem.h   |   9 +-
 include/standard-headers/linux/virtio_vsock.h |   3 +-
 linux-headers/asm-arm64/unistd.h              |   1 +
 linux-headers/asm-generic/unistd.h            |  22 +-
 linux-headers/asm-mips/unistd_n32.h           |   2 +
 linux-headers/asm-mips/unistd_n64.h           |   2 +
 linux-headers/asm-mips/unistd_o32.h           |   2 +
 linux-headers/asm-powerpc/unistd_32.h         |   2 +
 linux-headers/asm-powerpc/unistd_64.h         |   2 +
 linux-headers/asm-s390/kvm.h                  |   1 +
 linux-headers/asm-s390/unistd_32.h            |   2 +
 linux-headers/asm-s390/unistd_64.h            |   2 +
 linux-headers/asm-x86/kvm.h                   |   5 +
 linux-headers/asm-x86/unistd_32.h             |   3 +
 linux-headers/asm-x86/unistd_64.h             |   3 +
 linux-headers/asm-x86/unistd_x32.h            |   3 +
 linux-headers/linux/kvm.h                     |  41 +++-
 linux-headers/linux/vfio.h                    |  22 ++
 linux-headers/linux/vfio_zdev.h               |  51 ++++
 target/s390x/cpu_features_def.h.inc           |   1 +
 target/s390x/gen-features.c                   |   2 +
 target/s390x/kvm/kvm.c                        |   1 +
 37 files changed, 928 insertions(+), 52 deletions(-)

-- 
2.27.0


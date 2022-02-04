Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE334AA230
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242267AbiBDVTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:19:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29324 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242992AbiBDVTg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:19:36 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214JSaWW019296;
        Fri, 4 Feb 2022 21:19:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=dgVDnvUJrTz/FvdX5h5KH5SD4KUiomO17kOOhbX76pY=;
 b=P3+/3EsGSM2lPRyD02PY6h05ZI6GdnOXt/sLyfNN6KjFeXu40YCuXEl9rYTw/ANb3sX+
 yP3wrDyZ09UI2k9+zrnR0zBYg7nYmeo0bNp/d0iiNsMvohOlD/l50khPqf3tvnXDVkq9
 OPoIXST4F404qjTkyOKYzeKKQTA5zopj6Oxx1zHnajnEGkSWVuwBh0sDHZ8oNYQsJ//u
 5mvIrmahPVtuXg/c+/nrRIDTdUYaiPkFkd3oD9pjw/dWe2Y0FjIhzNQqg4IgP96EVo7+
 jXsA4CVC+v1T9Tgbsl3KlRj0w2N6TcA0/LeEuaL2K3f8VR7sfrmGkaig5HqguD1IW1US MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx1ps8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:19:29 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214LJShs015390;
        Fri, 4 Feb 2022 21:19:28 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx1ps7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:19:28 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LCxNN000697;
        Fri, 4 Feb 2022 21:19:27 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 3e0r0rygxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:19:27 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LJPMO26411408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:19:25 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DD35C6057;
        Fri,  4 Feb 2022 21:19:25 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBDEFC6055;
        Fri,  4 Feb 2022 21:19:23 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:19:23 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v3 0/8] s390x/pci: zPCI interpretation support
Date:   Fri,  4 Feb 2022 16:19:10 -0500
Message-Id: <20220204211918.321924-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: p86XPgi9QeMLfWX4PDxKy6lmDH7G6VDB
X-Proofpoint-GUID: gWWFXYaW7yoHhKZYB2aZtKhzp9RoneeH
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For QEMU, the majority of the work in enabling instruction interpretation
is handled via new VFIO ioctls to SET the appropriate interpretation and
interrupt forwarding modes, and to GET the function handle to use for
interpretive execution.  

This series implements these new ioctls, as well as adding a new, optional
'interpret' parameter to zpci which can be used to disable interpretation
support (interpret=off) as well as an 'forwarding_assist' parameter to
determine whether or not the firmware assist will be used for interrupt
delivery (default when interpretation is in use) or whether the host will
be responsible for delivering all interrupts (forwarding_assist=off).

The ZPCI_INTERP CPU feature is added beginning with the z14 model to
enable this support.

As a consequence of implementing zPCI interpretation, ISM devices now
become eligible for passthrough (but only when zPCI interpretation is
available).

From the perspective of guest configuration, you passthrough zPCI devices
in the same manner as before, with intepretation support being used by
default if available in kernel+qemu.

Associated kernel series:
https://lore.kernel.org/kvm/20220204211536.321475-1-mjrosato@linux.ibm.com/

Changelog v2->v3:
- Update kernel headers sync
- Add some R-bs (Thanks!)
- squash the fixup patch erroneously included in v2
- Re-word plug error message (Thomas)
- Change zpci option from interp to interpret (Thomas)
- Fix missing static inline (Pierre)
- Change zpci option from intassist to forwarding_assist (Pierre)
- Re-word s390_pci_get_aif comments and variables to better-explain
  what we are doing (Pierre)
- Note: no docs/system/s390x/zpci.rst with this series but this is not
  forgotten -- creating as a follow-on (Thomas)

Matthew Rosato (8):
  Update linux headers
  target/s390x: add zpci-interp to cpu models
  s390x/pci: enable for load/store intepretation
  s390x/pci: don't fence interpreted devices without MSI-X
  s390x/pci: enable adapter event notification for interpreted devices
  s390x/pci: use I/O Address Translation assist when interpreting
  s390x/pci: use dtsm provided from vfio capabilities for interpreted
    devices
  s390x/pci: let intercept devices have separate PCI groups

 hw/s390x/s390-pci-bus.c                       | 124 ++++++++++-
 hw/s390x/s390-pci-inst.c                      | 168 +++++++++++++-
 hw/s390x/s390-pci-vfio.c                      | 206 +++++++++++++++++-
 hw/s390x/s390-virtio-ccw.c                    |   1 +
 include/hw/s390x/s390-pci-bus.h               |   8 +-
 include/hw/s390x/s390-pci-inst.h              |   2 +-
 include/hw/s390x/s390-pci-vfio.h              |  46 ++++
 include/standard-headers/asm-x86/kvm_para.h   |   1 +
 include/standard-headers/drm/drm_fourcc.h     |  11 +
 include/standard-headers/linux/ethtool.h      |   1 +
 include/standard-headers/linux/fuse.h         |  60 ++++-
 include/standard-headers/linux/pci_regs.h     | 142 ++++++------
 include/standard-headers/linux/virtio_iommu.h |   8 +-
 linux-headers/asm-generic/unistd.h            |   5 +-
 linux-headers/asm-mips/unistd_n32.h           |   2 +
 linux-headers/asm-mips/unistd_n64.h           |   2 +
 linux-headers/asm-mips/unistd_o32.h           |   2 +
 linux-headers/asm-powerpc/unistd_32.h         |   2 +
 linux-headers/asm-powerpc/unistd_64.h         |   2 +
 linux-headers/asm-s390/kvm.h                  |   1 +
 linux-headers/asm-s390/unistd_32.h            |   2 +
 linux-headers/asm-s390/unistd_64.h            |   2 +
 linux-headers/asm-x86/kvm.h                   |  19 +-
 linux-headers/asm-x86/unistd_32.h             |   1 +
 linux-headers/asm-x86/unistd_64.h             |   1 +
 linux-headers/asm-x86/unistd_x32.h            |   1 +
 linux-headers/linux/kvm.h                     |  18 ++
 linux-headers/linux/vfio.h                    |  22 ++
 linux-headers/linux/vfio_zdev.h               |  51 +++++
 target/s390x/cpu_features_def.h.inc           |   1 +
 target/s390x/gen-features.c                   |   2 +
 target/s390x/kvm/kvm.c                        |   1 +
 32 files changed, 817 insertions(+), 98 deletions(-)

-- 
2.27.0


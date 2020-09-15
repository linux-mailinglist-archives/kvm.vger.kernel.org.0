Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6514826AD9F
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 21:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgIOTaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 15:30:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31576 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727755AbgIOTPN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 15:15:13 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FJ2j49135732;
        Tue, 15 Sep 2020 15:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=20j6JrlEXmgHFapWnNr7/wYljvTENuSaVZCZUOeT8vQ=;
 b=jlF6v3ymvM000XPqoimQKJ/i7TVHjI/Y9vrq/RyjseBIYlY07urZBp1vtJwe0AZz2Khf
 0qJSl1oeLwnjQQubpMtm3cwb1ZQHk/mCojQqwKP/THh+8roJ8UCEUsiQuLrTDOpO43SS
 dsKfW5zGyXGFFhFfU5P0bKvcrrGpTFUXOJZSO6b8cQYtCdXtFizUAlY3PEFJ4nau31Vj
 VBBZtBdvo0ayDN7QY1Jm8lRdRoYsh8Q1O2Qx9IgK7GjsJ5E0DYMgy8RxUcJFEkCImpsh
 kqQG9yq1phYCr4P4KCXk2qC6iNqfL9oL7k5B4ex8QVFDoHI5EalPMsxp33XCMy+kL7Po aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33k2pp1ewx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 15:14:52 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08FJ2peZ136533;
        Tue, 15 Sep 2020 15:14:52 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33k2pp1ewn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 15:14:52 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08FJ7mXs002872;
        Tue, 15 Sep 2020 19:14:51 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04wdc.us.ibm.com with ESMTP id 33jgrgxv2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 19:14:51 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08FJEpwp28246444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 19:14:51 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EA4D112064;
        Tue, 15 Sep 2020 19:14:51 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41AE2112061;
        Tue, 15 Sep 2020 19:14:47 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.85.51])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Sep 2020 19:14:46 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, thuth@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v3 0/5] s390x/pci: Accomodate vfio DMA limiting
Date:   Tue, 15 Sep 2020 15:14:38 -0400
Message-Id: <1600197283-25274-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_12:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009150147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kernel commit 492855939bdb added a limit to the number of outstanding DMA
requests for a type1 vfio container.  However, lazy unmapping in s390 can 
in fact cause quite a large number of outstanding DMA requests to build up
prior to being purged, potentially the entire guest DMA space.  This
results in unexpected 'VFIO_MAP_DMA failed: No space left on device'
conditions seen in QEMU.

This patchset adds support to qemu to retrieve the number of allowable DMA
requests via the VFIO_IOMMU_GET_INFO ioctl.  The patches are separated into
vfio hits which add support for reading in VFIO_IOMMU_GET_INFO capability
chains and getting the per-container dma_avail value, and s390 hits to 
track DMA usage on a per-container basis.

Associated kernel patch:
https://marc.info/?l=kvm&m=160019703922812&w=2

Changes from v2:
- Patch 1 (new): Added a placeholder linux-headers sync
- Patch 2: Re-arranged so that this patch that adds a shared routine for
  finding info capabilities is first
- Patch 3: Adjusted vfio_get_info_dma_avail() logic to be able to return
  true when the capability exists but the caller did not provide a buffer
  on input.
- Patch 4 (new): Introduce hw/s390x/s390-pci-vfio.* to better-separate PCI
  emulation code from code that interfaces with vfio
- Patch 4: s/s390_sync_dma_avail/s390_pci_update_dma_avail/ - Since it's
  now moved into a different file it can't be static so I added '_pci'.
- Patch 4: Use g_autofree as suggested - drop the goto/out as a result
- Patch 4+5: Added asserts() in a few locations per suggestion
- Patch 5: lowercase inline function names
- Patch 5: fix dma_avail initialization in rpcit_service_call() and ensure
  we still allow unmaps to call s390_pci_update_iotlb when dma_avail == 0

Matthew Rosato (5):
  linux-headers: update against 5.9-rc5
  vfio: Create shared routine for scanning info capabilities
  vfio: Find DMA available capability
  s390x/pci: Add routine to get the vfio dma available count
  s390x/pci: Honor DMA limits set by vfio

 hw/s390x/meson.build                               |   1 +
 hw/s390x/s390-pci-bus.c                            |  56 ++++++++-
 hw/s390x/s390-pci-bus.h                            |   9 ++
 hw/s390x/s390-pci-inst.c                           |  34 ++++-
 hw/s390x/s390-pci-inst.h                           |   3 +
 hw/s390x/s390-pci-vfio.c                           |  54 ++++++++
 hw/s390x/s390-pci-vfio.h                           |  17 +++
 hw/vfio/common.c                                   |  52 ++++++--
 include/hw/vfio/vfio-common.h                      |   2 +
 include/standard-headers/drm/drm_fourcc.h          | 140 +++++++++++++++++++++
 include/standard-headers/linux/ethtool.h           |  87 +++++++++++++
 include/standard-headers/linux/input-event-codes.h |   3 +-
 include/standard-headers/linux/vhost_types.h       |  11 ++
 include/standard-headers/linux/virtio_9p.h         |   4 +-
 include/standard-headers/linux/virtio_blk.h        |  26 ++--
 include/standard-headers/linux/virtio_config.h     |   8 +-
 include/standard-headers/linux/virtio_console.h    |   8 +-
 include/standard-headers/linux/virtio_net.h        |   6 +-
 include/standard-headers/linux/virtio_scsi.h       |  20 +--
 linux-headers/asm-generic/unistd.h                 |   6 +-
 linux-headers/asm-mips/unistd_n32.h                |   1 +
 linux-headers/asm-mips/unistd_n64.h                |   1 +
 linux-headers/asm-mips/unistd_o32.h                |   1 +
 linux-headers/asm-powerpc/kvm.h                    |   5 +
 linux-headers/asm-powerpc/unistd_32.h              |   1 +
 linux-headers/asm-powerpc/unistd_64.h              |   1 +
 linux-headers/asm-s390/kvm.h                       |   7 +-
 linux-headers/asm-s390/unistd_32.h                 |   1 +
 linux-headers/asm-s390/unistd_64.h                 |   1 +
 linux-headers/asm-x86/unistd_32.h                  |   1 +
 linux-headers/asm-x86/unistd_64.h                  |   1 +
 linux-headers/asm-x86/unistd_x32.h                 |   1 +
 linux-headers/linux/kvm.h                          |  10 +-
 linux-headers/linux/vfio.h                         |  18 ++-
 linux-headers/linux/vhost.h                        |   2 +
 35 files changed, 537 insertions(+), 62 deletions(-)
 create mode 100644 hw/s390x/s390-pci-vfio.c
 create mode 100644 hw/s390x/s390-pci-vfio.h

-- 
1.8.3.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD67281C92
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbgJBUHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:07:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46902 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgJBUHN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 16:07:13 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092K2IgL045958;
        Fri, 2 Oct 2020 16:06:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=6ZW/41ftrmBxNwLC6nTaLXjFv/PX4Uzy6FoZPgJfKHM=;
 b=r5/u56vL99nbO4nlM6wFd31SkxYBj/SIaWgy09D7zwJ+QQVrx8E/eL4/gjK8hhvZfYRE
 nCAUH6TnJ4hmSW9SYEIoRCmMsqH6MNqGnqG05kqSxRV2DxmBHmo4dI2YJf7gfXLKJKaV
 sR8POSqiMTRQ6uXktERB1TyvzJ85QCv1jEgsZD74vEc/SG3rMWIhwaseRVX409fqS8pJ
 2Atf6R1wHLlEZyQddxR2fqMMXk+xwbh39LvhHv83KoeXwJhUyrYsHbx0EhE5NS514kS5
 sE8HW1MeWsTScWW1K/A58nmig+gz+oJgaueyRd/hPDJ22XOD/pQyfUbbbbR52oIyUkxr zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33xaks8hc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:06:40 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092K305K048436;
        Fri, 2 Oct 2020 16:06:39 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33xaks8hb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:06:39 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092JmDHq007928;
        Fri, 2 Oct 2020 20:06:38 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 33sw9a0996-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 20:06:38 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092K6UC72753254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 20:06:30 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D81B9BE051;
        Fri,  2 Oct 2020 20:06:36 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69AC7BE04F;
        Fri,  2 Oct 2020 20:06:35 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.4.25])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 20:06:35 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v2 1/9] s390x/pci: Move header files to include/hw/s390x
Date:   Fri,  2 Oct 2020 16:06:23 -0400
Message-Id: <1601669191-6731-2-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
References: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=2 impostorscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020142
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Seems a more appropriate location for them.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-bus.c          |   4 +-
 hw/s390x/s390-pci-bus.h          | 372 ---------------------------------------
 hw/s390x/s390-pci-inst.c         |   4 +-
 hw/s390x/s390-pci-inst.h         | 312 --------------------------------
 hw/s390x/s390-virtio-ccw.c       |   2 +-
 include/hw/s390x/s390-pci-bus.h  | 372 +++++++++++++++++++++++++++++++++++++++
 include/hw/s390x/s390-pci-inst.h | 312 ++++++++++++++++++++++++++++++++
 7 files changed, 689 insertions(+), 689 deletions(-)
 delete mode 100644 hw/s390x/s390-pci-bus.h
 delete mode 100644 hw/s390x/s390-pci-inst.h
 create mode 100644 include/hw/s390x/s390-pci-bus.h
 create mode 100644 include/hw/s390x/s390-pci-inst.h

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index fb4cee8..a929340 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -15,8 +15,8 @@
 #include "qapi/error.h"
 #include "qapi/visitor.h"
 #include "cpu.h"
-#include "s390-pci-bus.h"
-#include "s390-pci-inst.h"
+#include "hw/s390x/s390-pci-bus.h"
+#include "hw/s390x/s390-pci-inst.h"
 #include "hw/pci/pci_bus.h"
 #include "hw/qdev-properties.h"
 #include "hw/pci/pci_bridge.h"
diff --git a/hw/s390x/s390-pci-bus.h b/hw/s390x/s390-pci-bus.h
deleted file mode 100644
index 97464d0..0000000
--- a/hw/s390x/s390-pci-bus.h
+++ /dev/null
@@ -1,372 +0,0 @@
-/*
- * s390 PCI BUS definitions
- *
- * Copyright 2014 IBM Corp.
- * Author(s): Frank Blaschka <frank.blaschka@de.ibm.com>
- *            Hong Bo Li <lihbbj@cn.ibm.com>
- *            Yi Min Zhao <zyimin@cn.ibm.com>
- *
- * This work is licensed under the terms of the GNU GPL, version 2 or (at
- * your option) any later version. See the COPYING file in the top-level
- * directory.
- */
-
-#ifndef HW_S390_PCI_BUS_H
-#define HW_S390_PCI_BUS_H
-
-#include "hw/pci/pci.h"
-#include "hw/pci/pci_host.h"
-#include "hw/s390x/sclp.h"
-#include "hw/s390x/s390_flic.h"
-#include "hw/s390x/css.h"
-#include "qom/object.h"
-
-#define TYPE_S390_PCI_HOST_BRIDGE "s390-pcihost"
-#define TYPE_S390_PCI_BUS "s390-pcibus"
-#define TYPE_S390_PCI_DEVICE "zpci"
-#define TYPE_S390_PCI_IOMMU "s390-pci-iommu"
-#define TYPE_S390_IOMMU_MEMORY_REGION "s390-iommu-memory-region"
-#define FH_MASK_ENABLE   0x80000000
-#define FH_MASK_INSTANCE 0x7f000000
-#define FH_MASK_SHM      0x00ff0000
-#define FH_MASK_INDEX    0x0000ffff
-#define FH_SHM_VFIO      0x00010000
-#define FH_SHM_EMUL      0x00020000
-#define ZPCI_MAX_FID 0xffffffff
-#define ZPCI_MAX_UID 0xffff
-#define UID_UNDEFINED 0
-#define UID_CHECKING_ENABLED 0x01
-
-OBJECT_DECLARE_SIMPLE_TYPE(S390pciState, S390_PCI_HOST_BRIDGE)
-OBJECT_DECLARE_SIMPLE_TYPE(S390PCIBus, S390_PCI_BUS)
-OBJECT_DECLARE_SIMPLE_TYPE(S390PCIBusDevice, S390_PCI_DEVICE)
-OBJECT_DECLARE_SIMPLE_TYPE(S390PCIIOMMU, S390_PCI_IOMMU)
-
-#define HP_EVENT_TO_CONFIGURED        0x0301
-#define HP_EVENT_RESERVED_TO_STANDBY  0x0302
-#define HP_EVENT_DECONFIGURE_REQUEST  0x0303
-#define HP_EVENT_CONFIGURED_TO_STBRES 0x0304
-#define HP_EVENT_STANDBY_TO_RESERVED  0x0308
-
-#define ERR_EVENT_INVALAS 0x1
-#define ERR_EVENT_OORANGE 0x2
-#define ERR_EVENT_INVALTF 0x3
-#define ERR_EVENT_TPROTE  0x4
-#define ERR_EVENT_APROTE  0x5
-#define ERR_EVENT_KEYE    0x6
-#define ERR_EVENT_INVALTE 0x7
-#define ERR_EVENT_INVALTL 0x8
-#define ERR_EVENT_TT      0x9
-#define ERR_EVENT_INVALMS 0xa
-#define ERR_EVENT_SERR    0xb
-#define ERR_EVENT_NOMSI   0x10
-#define ERR_EVENT_INVALBV 0x11
-#define ERR_EVENT_AIBV    0x12
-#define ERR_EVENT_AIRERR  0x13
-#define ERR_EVENT_FMBA    0x2a
-#define ERR_EVENT_FMBUP   0x2b
-#define ERR_EVENT_FMBPRO  0x2c
-#define ERR_EVENT_CCONF   0x30
-#define ERR_EVENT_SERVAC  0x3a
-#define ERR_EVENT_PERMERR 0x3b
-
-#define ERR_EVENT_Q_BIT 0x2
-#define ERR_EVENT_MVN_OFFSET 16
-
-#define ZPCI_MSI_VEC_BITS 11
-#define ZPCI_MSI_VEC_MASK 0x7ff
-
-#define ZPCI_MSI_ADDR  0xfe00000000000000ULL
-#define ZPCI_SDMA_ADDR 0x100000000ULL
-#define ZPCI_EDMA_ADDR 0x1ffffffffffffffULL
-
-#define PAGE_SHIFT      12
-#define PAGE_SIZE       (1 << PAGE_SHIFT)
-#define PAGE_MASK       (~(PAGE_SIZE-1))
-#define PAGE_DEFAULT_ACC        0
-#define PAGE_DEFAULT_KEY        (PAGE_DEFAULT_ACC << 4)
-
-/* I/O Translation Anchor (IOTA) */
-enum ZpciIoatDtype {
-    ZPCI_IOTA_STO = 0,
-    ZPCI_IOTA_RTTO = 1,
-    ZPCI_IOTA_RSTO = 2,
-    ZPCI_IOTA_RFTO = 3,
-    ZPCI_IOTA_PFAA = 4,
-    ZPCI_IOTA_IOPFAA = 5,
-    ZPCI_IOTA_IOPTO = 7
-};
-
-#define ZPCI_IOTA_IOT_ENABLED           0x800ULL
-#define ZPCI_IOTA_DT_ST                 (ZPCI_IOTA_STO  << 2)
-#define ZPCI_IOTA_DT_RT                 (ZPCI_IOTA_RTTO << 2)
-#define ZPCI_IOTA_DT_RS                 (ZPCI_IOTA_RSTO << 2)
-#define ZPCI_IOTA_DT_RF                 (ZPCI_IOTA_RFTO << 2)
-#define ZPCI_IOTA_DT_PF                 (ZPCI_IOTA_PFAA << 2)
-#define ZPCI_IOTA_FS_4K                 0
-#define ZPCI_IOTA_FS_1M                 1
-#define ZPCI_IOTA_FS_2G                 2
-#define ZPCI_KEY                        (PAGE_DEFAULT_KEY << 5)
-
-#define ZPCI_IOTA_STO_FLAG  (ZPCI_IOTA_IOT_ENABLED | ZPCI_KEY | ZPCI_IOTA_DT_ST)
-#define ZPCI_IOTA_RTTO_FLAG (ZPCI_IOTA_IOT_ENABLED | ZPCI_KEY | ZPCI_IOTA_DT_RT)
-#define ZPCI_IOTA_RSTO_FLAG (ZPCI_IOTA_IOT_ENABLED | ZPCI_KEY | ZPCI_IOTA_DT_RS)
-#define ZPCI_IOTA_RFTO_FLAG (ZPCI_IOTA_IOT_ENABLED | ZPCI_KEY | ZPCI_IOTA_DT_RF)
-#define ZPCI_IOTA_RFAA_FLAG (ZPCI_IOTA_IOT_ENABLED | ZPCI_KEY |\
-                             ZPCI_IOTA_DT_PF | ZPCI_IOTA_FS_2G)
-
-/* I/O Region and segment tables */
-#define ZPCI_INDEX_MASK         0x7ffULL
-
-#define ZPCI_TABLE_TYPE_MASK    0xc
-#define ZPCI_TABLE_TYPE_RFX     0xc
-#define ZPCI_TABLE_TYPE_RSX     0x8
-#define ZPCI_TABLE_TYPE_RTX     0x4
-#define ZPCI_TABLE_TYPE_SX      0x0
-
-#define ZPCI_TABLE_LEN_RFX      0x3
-#define ZPCI_TABLE_LEN_RSX      0x3
-#define ZPCI_TABLE_LEN_RTX      0x3
-
-#define ZPCI_TABLE_OFFSET_MASK  0xc0
-#define ZPCI_TABLE_SIZE         0x4000
-#define ZPCI_TABLE_ALIGN        ZPCI_TABLE_SIZE
-#define ZPCI_TABLE_ENTRY_SIZE   (sizeof(unsigned long))
-#define ZPCI_TABLE_ENTRIES      (ZPCI_TABLE_SIZE / ZPCI_TABLE_ENTRY_SIZE)
-
-#define ZPCI_TABLE_BITS         11
-#define ZPCI_PT_BITS            8
-#define ZPCI_ST_SHIFT           (ZPCI_PT_BITS + PAGE_SHIFT)
-#define ZPCI_RT_SHIFT           (ZPCI_ST_SHIFT + ZPCI_TABLE_BITS)
-
-#define ZPCI_RTE_FLAG_MASK      0x3fffULL
-#define ZPCI_RTE_ADDR_MASK      (~ZPCI_RTE_FLAG_MASK)
-#define ZPCI_STE_FLAG_MASK      0x7ffULL
-#define ZPCI_STE_ADDR_MASK      (~ZPCI_STE_FLAG_MASK)
-
-#define ZPCI_SFAA_MASK          (~((1ULL << 20) - 1))
-
-/* I/O Page tables */
-#define ZPCI_PTE_VALID_MASK             0x400
-#define ZPCI_PTE_INVALID                0x400
-#define ZPCI_PTE_VALID                  0x000
-#define ZPCI_PT_SIZE                    0x800
-#define ZPCI_PT_ALIGN                   ZPCI_PT_SIZE
-#define ZPCI_PT_ENTRIES                 (ZPCI_PT_SIZE / ZPCI_TABLE_ENTRY_SIZE)
-#define ZPCI_PT_MASK                    (ZPCI_PT_ENTRIES - 1)
-
-#define ZPCI_PTE_FLAG_MASK              0xfffULL
-#define ZPCI_PTE_ADDR_MASK              (~ZPCI_PTE_FLAG_MASK)
-
-/* Shared bits */
-#define ZPCI_TABLE_VALID                0x00
-#define ZPCI_TABLE_INVALID              0x20
-#define ZPCI_TABLE_PROTECTED            0x200
-#define ZPCI_TABLE_UNPROTECTED          0x000
-#define ZPCI_TABLE_FC                   0x400
-
-#define ZPCI_TABLE_VALID_MASK           0x20
-#define ZPCI_TABLE_PROT_MASK            0x200
-
-#define ZPCI_ETT_RT 1
-#define ZPCI_ETT_ST 0
-#define ZPCI_ETT_PT -1
-
-/* PCI Function States
- *
- * reserved: default; device has just been plugged or is in progress of being
- *           unplugged
- * standby: device is present but not configured; transition from any
- *          configured state/to this state via sclp configure/deconfigure
- *
- * The following states make up the "configured" meta-state:
- * disabled: device is configured but not enabled; transition between this
- *           state and enabled via clp enable/disable
- * enbaled: device is ready for use; transition to disabled via clp disable;
- *          may enter an error state
- * blocked: ignore all DMA and interrupts; transition back to enabled or from
- *          error state via mpcifc
- * error: an error occurred; transition back to enabled via mpcifc
- * permanent error: an unrecoverable error occurred; transition to standby via
- *                  sclp deconfigure
- */
-typedef enum {
-    ZPCI_FS_RESERVED,
-    ZPCI_FS_STANDBY,
-    ZPCI_FS_DISABLED,
-    ZPCI_FS_ENABLED,
-    ZPCI_FS_BLOCKED,
-    ZPCI_FS_ERROR,
-    ZPCI_FS_PERMANENT_ERROR,
-} ZpciState;
-
-typedef struct SeiContainer {
-    QTAILQ_ENTRY(SeiContainer) link;
-    uint32_t fid;
-    uint32_t fh;
-    uint8_t cc;
-    uint16_t pec;
-    uint64_t faddr;
-    uint32_t e;
-} SeiContainer;
-
-typedef struct PciCcdfErr {
-    uint32_t reserved1;
-    uint32_t fh;
-    uint32_t fid;
-    uint32_t e;
-    uint64_t faddr;
-    uint32_t reserved3;
-    uint16_t reserved4;
-    uint16_t pec;
-} QEMU_PACKED PciCcdfErr;
-
-typedef struct PciCcdfAvail {
-    uint32_t reserved1;
-    uint32_t fh;
-    uint32_t fid;
-    uint32_t reserved2;
-    uint32_t reserved3;
-    uint32_t reserved4;
-    uint32_t reserved5;
-    uint16_t reserved6;
-    uint16_t pec;
-} QEMU_PACKED PciCcdfAvail;
-
-typedef struct ChscSeiNt2Res {
-    uint16_t length;
-    uint16_t code;
-    uint16_t reserved1;
-    uint8_t reserved2;
-    uint8_t nt;
-    uint8_t flags;
-    uint8_t reserved3;
-    uint8_t reserved4;
-    uint8_t cc;
-    uint32_t reserved5[13];
-    uint8_t ccdf[4016];
-} QEMU_PACKED ChscSeiNt2Res;
-
-typedef struct S390MsixInfo {
-    uint8_t table_bar;
-    uint8_t pba_bar;
-    uint16_t entries;
-    uint32_t table_offset;
-    uint32_t pba_offset;
-} S390MsixInfo;
-
-typedef struct S390IOTLBEntry {
-    uint64_t iova;
-    uint64_t translated_addr;
-    uint64_t len;
-    uint64_t perm;
-} S390IOTLBEntry;
-
-struct S390PCIIOMMU {
-    Object parent_obj;
-    S390PCIBusDevice *pbdev;
-    AddressSpace as;
-    MemoryRegion mr;
-    IOMMUMemoryRegion iommu_mr;
-    bool enabled;
-    uint64_t g_iota;
-    uint64_t pba;
-    uint64_t pal;
-    GHashTable *iotlb;
-};
-
-typedef struct S390PCIIOMMUTable {
-    uint64_t key;
-    S390PCIIOMMU *iommu[PCI_SLOT_MAX];
-} S390PCIIOMMUTable;
-
-/* Function Measurement Block */
-#define DEFAULT_MUI 4000
-#define UPDATE_U_BIT 0x1ULL
-#define FMBK_MASK 0xfULL
-
-typedef struct ZpciFmbFmt0 {
-    uint64_t dma_rbytes;
-    uint64_t dma_wbytes;
-} ZpciFmbFmt0;
-
-#define ZPCI_FMB_CNT_LD    0
-#define ZPCI_FMB_CNT_ST    1
-#define ZPCI_FMB_CNT_STB   2
-#define ZPCI_FMB_CNT_RPCIT 3
-#define ZPCI_FMB_CNT_MAX   4
-
-#define ZPCI_FMB_FORMAT    0
-
-typedef struct ZpciFmb {
-    uint32_t format;
-    uint32_t sample;
-    uint64_t last_update;
-    uint64_t counter[ZPCI_FMB_CNT_MAX];
-    ZpciFmbFmt0 fmt0;
-} ZpciFmb;
-QEMU_BUILD_BUG_MSG(offsetof(ZpciFmb, fmt0) != 48, "padding in ZpciFmb");
-
-struct S390PCIBusDevice {
-    DeviceState qdev;
-    PCIDevice *pdev;
-    ZpciState state;
-    char *target;
-    uint16_t uid;
-    uint32_t idx;
-    uint32_t fh;
-    uint32_t fid;
-    bool fid_defined;
-    uint64_t fmb_addr;
-    ZpciFmb fmb;
-    QEMUTimer *fmb_timer;
-    uint8_t isc;
-    uint16_t noi;
-    uint16_t maxstbl;
-    uint8_t sum;
-    S390MsixInfo msix;
-    AdapterRoutes routes;
-    S390PCIIOMMU *iommu;
-    MemoryRegion msix_notify_mr;
-    IndAddr *summary_ind;
-    IndAddr *indicator;
-    bool pci_unplug_request_processed;
-    bool unplug_requested;
-    QTAILQ_ENTRY(S390PCIBusDevice) link;
-};
-
-struct S390PCIBus {
-    BusState qbus;
-};
-
-struct S390pciState {
-    PCIHostState parent_obj;
-    uint32_t next_idx;
-    int bus_no;
-    S390PCIBus *bus;
-    GHashTable *iommu_table;
-    GHashTable *zpci_table;
-    QTAILQ_HEAD(, SeiContainer) pending_sei;
-    QTAILQ_HEAD(, S390PCIBusDevice) zpci_devs;
-};
-
-S390pciState *s390_get_phb(void);
-int pci_chsc_sei_nt2_get_event(void *res);
-int pci_chsc_sei_nt2_have_event(void);
-void s390_pci_sclp_configure(SCCB *sccb);
-void s390_pci_sclp_deconfigure(SCCB *sccb);
-void s390_pci_iommu_enable(S390PCIIOMMU *iommu);
-void s390_pci_iommu_disable(S390PCIIOMMU *iommu);
-void s390_pci_generate_error_event(uint16_t pec, uint32_t fh, uint32_t fid,
-                                   uint64_t faddr, uint32_t e);
-uint16_t s390_guest_io_table_walk(uint64_t g_iota, hwaddr addr,
-                                  S390IOTLBEntry *entry);
-S390PCIBusDevice *s390_pci_find_dev_by_idx(S390pciState *s, uint32_t idx);
-S390PCIBusDevice *s390_pci_find_dev_by_fh(S390pciState *s, uint32_t fh);
-S390PCIBusDevice *s390_pci_find_dev_by_fid(S390pciState *s, uint32_t fid);
-S390PCIBusDevice *s390_pci_find_dev_by_target(S390pciState *s,
-                                              const char *target);
-S390PCIBusDevice *s390_pci_find_next_avail_dev(S390pciState *s,
-                                               S390PCIBusDevice *pbdev);
-
-#endif
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index 2f7a7d7..639b13c 100644
--- a/hw/s390x/s390-pci-inst.c
+++ b/hw/s390x/s390-pci-inst.c
@@ -13,12 +13,12 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "s390-pci-inst.h"
-#include "s390-pci-bus.h"
 #include "exec/memop.h"
 #include "exec/memory-internal.h"
 #include "qemu/error-report.h"
 #include "sysemu/hw_accel.h"
+#include "hw/s390x/s390-pci-inst.h"
+#include "hw/s390x/s390-pci-bus.h"
 #include "hw/s390x/tod.h"
 
 #ifndef DEBUG_S390PCI_INST
diff --git a/hw/s390x/s390-pci-inst.h b/hw/s390x/s390-pci-inst.h
deleted file mode 100644
index fa3bf8b..0000000
--- a/hw/s390x/s390-pci-inst.h
+++ /dev/null
@@ -1,312 +0,0 @@
-/*
- * s390 PCI instruction definitions
- *
- * Copyright 2014 IBM Corp.
- * Author(s): Frank Blaschka <frank.blaschka@de.ibm.com>
- *            Hong Bo Li <lihbbj@cn.ibm.com>
- *            Yi Min Zhao <zyimin@cn.ibm.com>
- *
- * This work is licensed under the terms of the GNU GPL, version 2 or (at
- * your option) any later version. See the COPYING file in the top-level
- * directory.
- */
-
-#ifndef HW_S390_PCI_INST_H
-#define HW_S390_PCI_INST_H
-
-#include "s390-pci-bus.h"
-#include "sysemu/dma.h"
-
-/* CLP common request & response block size */
-#define CLP_BLK_SIZE 4096
-#define PCI_BAR_COUNT 6
-#define PCI_MAX_FUNCTIONS 4096
-
-typedef struct ClpReqHdr {
-    uint16_t len;
-    uint16_t cmd;
-} QEMU_PACKED ClpReqHdr;
-
-typedef struct ClpRspHdr {
-    uint16_t len;
-    uint16_t rsp;
-} QEMU_PACKED ClpRspHdr;
-
-/* CLP Response Codes */
-#define CLP_RC_OK         0x0010  /* Command request successfully */
-#define CLP_RC_CMD        0x0020  /* Command code not recognized */
-#define CLP_RC_PERM       0x0030  /* Command not authorized */
-#define CLP_RC_FMT        0x0040  /* Invalid command request format */
-#define CLP_RC_LEN        0x0050  /* Invalid command request length */
-#define CLP_RC_8K         0x0060  /* Command requires 8K LPCB */
-#define CLP_RC_RESNOT0    0x0070  /* Reserved field not zero */
-#define CLP_RC_NODATA     0x0080  /* No data available */
-#define CLP_RC_FC_UNKNOWN 0x0100  /* Function code not recognized */
-
-/*
- * Call Logical Processor - Command Codes
- */
-#define CLP_LIST_PCI            0x0002
-#define CLP_QUERY_PCI_FN        0x0003
-#define CLP_QUERY_PCI_FNGRP     0x0004
-#define CLP_SET_PCI_FN          0x0005
-
-/* PCI function handle list entry */
-typedef struct ClpFhListEntry {
-    uint16_t device_id;
-    uint16_t vendor_id;
-#define CLP_FHLIST_MASK_CONFIG 0x80000000
-    uint32_t config;
-    uint32_t fid;
-    uint32_t fh;
-} QEMU_PACKED ClpFhListEntry;
-
-#define CLP_RC_SETPCIFN_FH      0x0101 /* Invalid PCI fn handle */
-#define CLP_RC_SETPCIFN_FHOP    0x0102 /* Fn handle not valid for op */
-#define CLP_RC_SETPCIFN_DMAAS   0x0103 /* Invalid DMA addr space */
-#define CLP_RC_SETPCIFN_RES     0x0104 /* Insufficient resources */
-#define CLP_RC_SETPCIFN_ALRDY   0x0105 /* Fn already in requested state */
-#define CLP_RC_SETPCIFN_ERR     0x0106 /* Fn in permanent error state */
-#define CLP_RC_SETPCIFN_RECPND  0x0107 /* Error recovery pending */
-#define CLP_RC_SETPCIFN_BUSY    0x0108 /* Fn busy */
-#define CLP_RC_LISTPCI_BADRT    0x010a /* Resume token not recognized */
-#define CLP_RC_QUERYPCIFG_PFGID 0x010b /* Unrecognized PFGID */
-
-/* request or response block header length */
-#define LIST_PCI_HDR_LEN 32
-
-/* Number of function handles fitting in response block */
-#define CLP_FH_LIST_NR_ENTRIES \
-    ((CLP_BLK_SIZE - 2 * LIST_PCI_HDR_LEN) \
-        / sizeof(ClpFhListEntry))
-
-#define CLP_SET_ENABLE_PCI_FN  0 /* Yes, 0 enables it */
-#define CLP_SET_DISABLE_PCI_FN 1 /* Yes, 1 disables it */
-
-#define CLP_UTIL_STR_LEN 64
-
-#define CLP_MASK_FMT 0xf0000000
-
-/* List PCI functions request */
-typedef struct ClpReqListPci {
-    ClpReqHdr hdr;
-    uint32_t fmt;
-    uint64_t reserved1;
-    uint64_t resume_token;
-    uint64_t reserved2;
-} QEMU_PACKED ClpReqListPci;
-
-/* List PCI functions response */
-typedef struct ClpRspListPci {
-    ClpRspHdr hdr;
-    uint32_t fmt;
-    uint64_t reserved1;
-    uint64_t resume_token;
-    uint32_t mdd;
-    uint16_t max_fn;
-    uint8_t flags;
-    uint8_t entry_size;
-    ClpFhListEntry fh_list[CLP_FH_LIST_NR_ENTRIES];
-} QEMU_PACKED ClpRspListPci;
-
-/* Query PCI function request */
-typedef struct ClpReqQueryPci {
-    ClpReqHdr hdr;
-    uint32_t fmt;
-    uint64_t reserved1;
-    uint32_t fh; /* function handle */
-    uint32_t reserved2;
-    uint64_t reserved3;
-} QEMU_PACKED ClpReqQueryPci;
-
-/* Query PCI function response */
-typedef struct ClpRspQueryPci {
-    ClpRspHdr hdr;
-    uint32_t fmt;
-    uint64_t reserved1;
-    uint16_t vfn; /* virtual fn number */
-#define CLP_RSP_QPCI_MASK_UTIL  0x100
-#define CLP_RSP_QPCI_MASK_PFGID 0xff
-    uint16_t ug;
-    uint32_t fid; /* pci function id */
-    uint8_t bar_size[PCI_BAR_COUNT];
-    uint16_t pchid;
-    uint32_t bar[PCI_BAR_COUNT];
-    uint64_t reserved2;
-    uint64_t sdma; /* start dma as */
-    uint64_t edma; /* end dma as */
-    uint32_t reserved3[11];
-    uint32_t uid;
-    uint8_t util_str[CLP_UTIL_STR_LEN]; /* utility string */
-} QEMU_PACKED ClpRspQueryPci;
-
-/* Query PCI function group request */
-typedef struct ClpReqQueryPciGrp {
-    ClpReqHdr hdr;
-    uint32_t fmt;
-    uint64_t reserved1;
-#define CLP_REQ_QPCIG_MASK_PFGID 0xff
-    uint32_t g;
-    uint32_t reserved2;
-    uint64_t reserved3;
-} QEMU_PACKED ClpReqQueryPciGrp;
-
-/* Query PCI function group response */
-typedef struct ClpRspQueryPciGrp {
-    ClpRspHdr hdr;
-    uint32_t fmt;
-    uint64_t reserved1;
-#define CLP_RSP_QPCIG_MASK_NOI 0xfff
-    uint16_t i;
-    uint8_t version;
-#define CLP_RSP_QPCIG_MASK_FRAME   0x2
-#define CLP_RSP_QPCIG_MASK_REFRESH 0x1
-    uint8_t fr;
-    uint16_t maxstbl;
-    uint16_t mui;
-    uint64_t reserved3;
-    uint64_t dasm; /* dma address space mask */
-    uint64_t msia; /* MSI address */
-    uint64_t reserved4;
-    uint64_t reserved5;
-} QEMU_PACKED ClpRspQueryPciGrp;
-
-/* Set PCI function request */
-typedef struct ClpReqSetPci {
-    ClpReqHdr hdr;
-    uint32_t fmt;
-    uint64_t reserved1;
-    uint32_t fh; /* function handle */
-    uint16_t reserved2;
-    uint8_t oc; /* operation controls */
-    uint8_t ndas; /* number of dma spaces */
-    uint64_t reserved3;
-} QEMU_PACKED ClpReqSetPci;
-
-/* Set PCI function response */
-typedef struct ClpRspSetPci {
-    ClpRspHdr hdr;
-    uint32_t fmt;
-    uint64_t reserved1;
-    uint32_t fh; /* function handle */
-    uint32_t reserved3;
-    uint64_t reserved4;
-} QEMU_PACKED ClpRspSetPci;
-
-typedef struct ClpReqRspListPci {
-    ClpReqListPci request;
-    ClpRspListPci response;
-} QEMU_PACKED ClpReqRspListPci;
-
-typedef struct ClpReqRspSetPci {
-    ClpReqSetPci request;
-    ClpRspSetPci response;
-} QEMU_PACKED ClpReqRspSetPci;
-
-typedef struct ClpReqRspQueryPci {
-    ClpReqQueryPci request;
-    ClpRspQueryPci response;
-} QEMU_PACKED ClpReqRspQueryPci;
-
-typedef struct ClpReqRspQueryPciGrp {
-    ClpReqQueryPciGrp request;
-    ClpRspQueryPciGrp response;
-} QEMU_PACKED ClpReqRspQueryPciGrp;
-
-/* Load/Store status codes */
-#define ZPCI_PCI_ST_FUNC_NOT_ENABLED        4
-#define ZPCI_PCI_ST_FUNC_IN_ERR             8
-#define ZPCI_PCI_ST_BLOCKED                 12
-#define ZPCI_PCI_ST_INSUF_RES               16
-#define ZPCI_PCI_ST_INVAL_AS                20
-#define ZPCI_PCI_ST_FUNC_ALREADY_ENABLED    24
-#define ZPCI_PCI_ST_DMA_AS_NOT_ENABLED      28
-#define ZPCI_PCI_ST_2ND_OP_IN_INV_AS        36
-#define ZPCI_PCI_ST_FUNC_NOT_AVAIL          40
-#define ZPCI_PCI_ST_ALREADY_IN_RQ_STATE     44
-
-/* Load/Store return codes */
-#define ZPCI_PCI_LS_OK              0
-#define ZPCI_PCI_LS_ERR             1
-#define ZPCI_PCI_LS_BUSY            2
-#define ZPCI_PCI_LS_INVAL_HANDLE    3
-
-/* Modify PCI status codes */
-#define ZPCI_MOD_ST_RES_NOT_AVAIL 4
-#define ZPCI_MOD_ST_INSUF_RES     16
-#define ZPCI_MOD_ST_SEQUENCE      24
-#define ZPCI_MOD_ST_DMAAS_INVAL   28
-#define ZPCI_MOD_ST_FRAME_INVAL   32
-#define ZPCI_MOD_ST_ERROR_RECOVER 40
-
-/* Modify PCI Function Controls */
-#define ZPCI_MOD_FC_REG_INT     2
-#define ZPCI_MOD_FC_DEREG_INT   3
-#define ZPCI_MOD_FC_REG_IOAT    4
-#define ZPCI_MOD_FC_DEREG_IOAT  5
-#define ZPCI_MOD_FC_REREG_IOAT  6
-#define ZPCI_MOD_FC_RESET_ERROR 7
-#define ZPCI_MOD_FC_RESET_BLOCK 9
-#define ZPCI_MOD_FC_SET_MEASURE 10
-
-/* Store PCI Function Controls status codes */
-#define ZPCI_STPCIFC_ST_PERM_ERROR    8
-#define ZPCI_STPCIFC_ST_INVAL_DMAAS   28
-#define ZPCI_STPCIFC_ST_ERROR_RECOVER 40
-
-/* FIB function controls */
-#define ZPCI_FIB_FC_ENABLED     0x80
-#define ZPCI_FIB_FC_ERROR       0x40
-#define ZPCI_FIB_FC_LS_BLOCKED  0x20
-#define ZPCI_FIB_FC_DMAAS_REG   0x10
-
-/* FIB function controls */
-#define ZPCI_FIB_FC_ENABLED     0x80
-#define ZPCI_FIB_FC_ERROR       0x40
-#define ZPCI_FIB_FC_LS_BLOCKED  0x20
-#define ZPCI_FIB_FC_DMAAS_REG   0x10
-
-/* Function Information Block */
-typedef struct ZpciFib {
-    uint8_t fmt;   /* format */
-    uint8_t reserved1[7];
-    uint8_t fc;                  /* function controls */
-    uint8_t reserved2;
-    uint16_t reserved3;
-    uint32_t reserved4;
-    uint64_t pba;                /* PCI base address */
-    uint64_t pal;                /* PCI address limit */
-    uint64_t iota;               /* I/O Translation Anchor */
-#define FIB_DATA_ISC(x)    (((x) >> 28) & 0x7)
-#define FIB_DATA_NOI(x)    (((x) >> 16) & 0xfff)
-#define FIB_DATA_AIBVO(x) (((x) >> 8) & 0x3f)
-#define FIB_DATA_SUM(x)    (((x) >> 7) & 0x1)
-#define FIB_DATA_AISBO(x)  ((x) & 0x3f)
-    uint32_t data;
-    uint32_t reserved5;
-    uint64_t aibv;               /* Adapter int bit vector address */
-    uint64_t aisb;               /* Adapter int summary bit address */
-    uint64_t fmb_addr;           /* Function measurement address and key */
-    uint32_t reserved6;
-    uint32_t gd;
-} QEMU_PACKED ZpciFib;
-
-int pci_dereg_irqs(S390PCIBusDevice *pbdev);
-void pci_dereg_ioat(S390PCIIOMMU *iommu);
-int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra);
-int pcilg_service_call(S390CPU *cpu, uint8_t r1, uint8_t r2, uintptr_t ra);
-int pcistg_service_call(S390CPU *cpu, uint8_t r1, uint8_t r2, uintptr_t ra);
-int rpcit_service_call(S390CPU *cpu, uint8_t r1, uint8_t r2, uintptr_t ra);
-int pcistb_service_call(S390CPU *cpu, uint8_t r1, uint8_t r3, uint64_t gaddr,
-                        uint8_t ar, uintptr_t ra);
-int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
-                        uintptr_t ra);
-int stpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
-                         uintptr_t ra);
-void fmb_timer_free(S390PCIBusDevice *pbdev);
-
-#define ZPCI_IO_BAR_MIN 0
-#define ZPCI_IO_BAR_MAX 5
-#define ZPCI_CONFIG_BAR 15
-
-#endif
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 28266a3..f31ae2e 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -28,7 +28,7 @@
 #include "qemu/error-report.h"
 #include "qemu/option.h"
 #include "qemu/qemu-print.h"
-#include "s390-pci-bus.h"
+#include "hw/s390x/s390-pci-bus.h"
 #include "sysemu/reset.h"
 #include "hw/s390x/storage-keys.h"
 #include "hw/s390x/storage-attributes.h"
diff --git a/include/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
new file mode 100644
index 0000000..97464d0
--- /dev/null
+++ b/include/hw/s390x/s390-pci-bus.h
@@ -0,0 +1,372 @@
+/*
+ * s390 PCI BUS definitions
+ *
+ * Copyright 2014 IBM Corp.
+ * Author(s): Frank Blaschka <frank.blaschka@de.ibm.com>
+ *            Hong Bo Li <lihbbj@cn.ibm.com>
+ *            Yi Min Zhao <zyimin@cn.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#ifndef HW_S390_PCI_BUS_H
+#define HW_S390_PCI_BUS_H
+
+#include "hw/pci/pci.h"
+#include "hw/pci/pci_host.h"
+#include "hw/s390x/sclp.h"
+#include "hw/s390x/s390_flic.h"
+#include "hw/s390x/css.h"
+#include "qom/object.h"
+
+#define TYPE_S390_PCI_HOST_BRIDGE "s390-pcihost"
+#define TYPE_S390_PCI_BUS "s390-pcibus"
+#define TYPE_S390_PCI_DEVICE "zpci"
+#define TYPE_S390_PCI_IOMMU "s390-pci-iommu"
+#define TYPE_S390_IOMMU_MEMORY_REGION "s390-iommu-memory-region"
+#define FH_MASK_ENABLE   0x80000000
+#define FH_MASK_INSTANCE 0x7f000000
+#define FH_MASK_SHM      0x00ff0000
+#define FH_MASK_INDEX    0x0000ffff
+#define FH_SHM_VFIO      0x00010000
+#define FH_SHM_EMUL      0x00020000
+#define ZPCI_MAX_FID 0xffffffff
+#define ZPCI_MAX_UID 0xffff
+#define UID_UNDEFINED 0
+#define UID_CHECKING_ENABLED 0x01
+
+OBJECT_DECLARE_SIMPLE_TYPE(S390pciState, S390_PCI_HOST_BRIDGE)
+OBJECT_DECLARE_SIMPLE_TYPE(S390PCIBus, S390_PCI_BUS)
+OBJECT_DECLARE_SIMPLE_TYPE(S390PCIBusDevice, S390_PCI_DEVICE)
+OBJECT_DECLARE_SIMPLE_TYPE(S390PCIIOMMU, S390_PCI_IOMMU)
+
+#define HP_EVENT_TO_CONFIGURED        0x0301
+#define HP_EVENT_RESERVED_TO_STANDBY  0x0302
+#define HP_EVENT_DECONFIGURE_REQUEST  0x0303
+#define HP_EVENT_CONFIGURED_TO_STBRES 0x0304
+#define HP_EVENT_STANDBY_TO_RESERVED  0x0308
+
+#define ERR_EVENT_INVALAS 0x1
+#define ERR_EVENT_OORANGE 0x2
+#define ERR_EVENT_INVALTF 0x3
+#define ERR_EVENT_TPROTE  0x4
+#define ERR_EVENT_APROTE  0x5
+#define ERR_EVENT_KEYE    0x6
+#define ERR_EVENT_INVALTE 0x7
+#define ERR_EVENT_INVALTL 0x8
+#define ERR_EVENT_TT      0x9
+#define ERR_EVENT_INVALMS 0xa
+#define ERR_EVENT_SERR    0xb
+#define ERR_EVENT_NOMSI   0x10
+#define ERR_EVENT_INVALBV 0x11
+#define ERR_EVENT_AIBV    0x12
+#define ERR_EVENT_AIRERR  0x13
+#define ERR_EVENT_FMBA    0x2a
+#define ERR_EVENT_FMBUP   0x2b
+#define ERR_EVENT_FMBPRO  0x2c
+#define ERR_EVENT_CCONF   0x30
+#define ERR_EVENT_SERVAC  0x3a
+#define ERR_EVENT_PERMERR 0x3b
+
+#define ERR_EVENT_Q_BIT 0x2
+#define ERR_EVENT_MVN_OFFSET 16
+
+#define ZPCI_MSI_VEC_BITS 11
+#define ZPCI_MSI_VEC_MASK 0x7ff
+
+#define ZPCI_MSI_ADDR  0xfe00000000000000ULL
+#define ZPCI_SDMA_ADDR 0x100000000ULL
+#define ZPCI_EDMA_ADDR 0x1ffffffffffffffULL
+
+#define PAGE_SHIFT      12
+#define PAGE_SIZE       (1 << PAGE_SHIFT)
+#define PAGE_MASK       (~(PAGE_SIZE-1))
+#define PAGE_DEFAULT_ACC        0
+#define PAGE_DEFAULT_KEY        (PAGE_DEFAULT_ACC << 4)
+
+/* I/O Translation Anchor (IOTA) */
+enum ZpciIoatDtype {
+    ZPCI_IOTA_STO = 0,
+    ZPCI_IOTA_RTTO = 1,
+    ZPCI_IOTA_RSTO = 2,
+    ZPCI_IOTA_RFTO = 3,
+    ZPCI_IOTA_PFAA = 4,
+    ZPCI_IOTA_IOPFAA = 5,
+    ZPCI_IOTA_IOPTO = 7
+};
+
+#define ZPCI_IOTA_IOT_ENABLED           0x800ULL
+#define ZPCI_IOTA_DT_ST                 (ZPCI_IOTA_STO  << 2)
+#define ZPCI_IOTA_DT_RT                 (ZPCI_IOTA_RTTO << 2)
+#define ZPCI_IOTA_DT_RS                 (ZPCI_IOTA_RSTO << 2)
+#define ZPCI_IOTA_DT_RF                 (ZPCI_IOTA_RFTO << 2)
+#define ZPCI_IOTA_DT_PF                 (ZPCI_IOTA_PFAA << 2)
+#define ZPCI_IOTA_FS_4K                 0
+#define ZPCI_IOTA_FS_1M                 1
+#define ZPCI_IOTA_FS_2G                 2
+#define ZPCI_KEY                        (PAGE_DEFAULT_KEY << 5)
+
+#define ZPCI_IOTA_STO_FLAG  (ZPCI_IOTA_IOT_ENABLED | ZPCI_KEY | ZPCI_IOTA_DT_ST)
+#define ZPCI_IOTA_RTTO_FLAG (ZPCI_IOTA_IOT_ENABLED | ZPCI_KEY | ZPCI_IOTA_DT_RT)
+#define ZPCI_IOTA_RSTO_FLAG (ZPCI_IOTA_IOT_ENABLED | ZPCI_KEY | ZPCI_IOTA_DT_RS)
+#define ZPCI_IOTA_RFTO_FLAG (ZPCI_IOTA_IOT_ENABLED | ZPCI_KEY | ZPCI_IOTA_DT_RF)
+#define ZPCI_IOTA_RFAA_FLAG (ZPCI_IOTA_IOT_ENABLED | ZPCI_KEY |\
+                             ZPCI_IOTA_DT_PF | ZPCI_IOTA_FS_2G)
+
+/* I/O Region and segment tables */
+#define ZPCI_INDEX_MASK         0x7ffULL
+
+#define ZPCI_TABLE_TYPE_MASK    0xc
+#define ZPCI_TABLE_TYPE_RFX     0xc
+#define ZPCI_TABLE_TYPE_RSX     0x8
+#define ZPCI_TABLE_TYPE_RTX     0x4
+#define ZPCI_TABLE_TYPE_SX      0x0
+
+#define ZPCI_TABLE_LEN_RFX      0x3
+#define ZPCI_TABLE_LEN_RSX      0x3
+#define ZPCI_TABLE_LEN_RTX      0x3
+
+#define ZPCI_TABLE_OFFSET_MASK  0xc0
+#define ZPCI_TABLE_SIZE         0x4000
+#define ZPCI_TABLE_ALIGN        ZPCI_TABLE_SIZE
+#define ZPCI_TABLE_ENTRY_SIZE   (sizeof(unsigned long))
+#define ZPCI_TABLE_ENTRIES      (ZPCI_TABLE_SIZE / ZPCI_TABLE_ENTRY_SIZE)
+
+#define ZPCI_TABLE_BITS         11
+#define ZPCI_PT_BITS            8
+#define ZPCI_ST_SHIFT           (ZPCI_PT_BITS + PAGE_SHIFT)
+#define ZPCI_RT_SHIFT           (ZPCI_ST_SHIFT + ZPCI_TABLE_BITS)
+
+#define ZPCI_RTE_FLAG_MASK      0x3fffULL
+#define ZPCI_RTE_ADDR_MASK      (~ZPCI_RTE_FLAG_MASK)
+#define ZPCI_STE_FLAG_MASK      0x7ffULL
+#define ZPCI_STE_ADDR_MASK      (~ZPCI_STE_FLAG_MASK)
+
+#define ZPCI_SFAA_MASK          (~((1ULL << 20) - 1))
+
+/* I/O Page tables */
+#define ZPCI_PTE_VALID_MASK             0x400
+#define ZPCI_PTE_INVALID                0x400
+#define ZPCI_PTE_VALID                  0x000
+#define ZPCI_PT_SIZE                    0x800
+#define ZPCI_PT_ALIGN                   ZPCI_PT_SIZE
+#define ZPCI_PT_ENTRIES                 (ZPCI_PT_SIZE / ZPCI_TABLE_ENTRY_SIZE)
+#define ZPCI_PT_MASK                    (ZPCI_PT_ENTRIES - 1)
+
+#define ZPCI_PTE_FLAG_MASK              0xfffULL
+#define ZPCI_PTE_ADDR_MASK              (~ZPCI_PTE_FLAG_MASK)
+
+/* Shared bits */
+#define ZPCI_TABLE_VALID                0x00
+#define ZPCI_TABLE_INVALID              0x20
+#define ZPCI_TABLE_PROTECTED            0x200
+#define ZPCI_TABLE_UNPROTECTED          0x000
+#define ZPCI_TABLE_FC                   0x400
+
+#define ZPCI_TABLE_VALID_MASK           0x20
+#define ZPCI_TABLE_PROT_MASK            0x200
+
+#define ZPCI_ETT_RT 1
+#define ZPCI_ETT_ST 0
+#define ZPCI_ETT_PT -1
+
+/* PCI Function States
+ *
+ * reserved: default; device has just been plugged or is in progress of being
+ *           unplugged
+ * standby: device is present but not configured; transition from any
+ *          configured state/to this state via sclp configure/deconfigure
+ *
+ * The following states make up the "configured" meta-state:
+ * disabled: device is configured but not enabled; transition between this
+ *           state and enabled via clp enable/disable
+ * enbaled: device is ready for use; transition to disabled via clp disable;
+ *          may enter an error state
+ * blocked: ignore all DMA and interrupts; transition back to enabled or from
+ *          error state via mpcifc
+ * error: an error occurred; transition back to enabled via mpcifc
+ * permanent error: an unrecoverable error occurred; transition to standby via
+ *                  sclp deconfigure
+ */
+typedef enum {
+    ZPCI_FS_RESERVED,
+    ZPCI_FS_STANDBY,
+    ZPCI_FS_DISABLED,
+    ZPCI_FS_ENABLED,
+    ZPCI_FS_BLOCKED,
+    ZPCI_FS_ERROR,
+    ZPCI_FS_PERMANENT_ERROR,
+} ZpciState;
+
+typedef struct SeiContainer {
+    QTAILQ_ENTRY(SeiContainer) link;
+    uint32_t fid;
+    uint32_t fh;
+    uint8_t cc;
+    uint16_t pec;
+    uint64_t faddr;
+    uint32_t e;
+} SeiContainer;
+
+typedef struct PciCcdfErr {
+    uint32_t reserved1;
+    uint32_t fh;
+    uint32_t fid;
+    uint32_t e;
+    uint64_t faddr;
+    uint32_t reserved3;
+    uint16_t reserved4;
+    uint16_t pec;
+} QEMU_PACKED PciCcdfErr;
+
+typedef struct PciCcdfAvail {
+    uint32_t reserved1;
+    uint32_t fh;
+    uint32_t fid;
+    uint32_t reserved2;
+    uint32_t reserved3;
+    uint32_t reserved4;
+    uint32_t reserved5;
+    uint16_t reserved6;
+    uint16_t pec;
+} QEMU_PACKED PciCcdfAvail;
+
+typedef struct ChscSeiNt2Res {
+    uint16_t length;
+    uint16_t code;
+    uint16_t reserved1;
+    uint8_t reserved2;
+    uint8_t nt;
+    uint8_t flags;
+    uint8_t reserved3;
+    uint8_t reserved4;
+    uint8_t cc;
+    uint32_t reserved5[13];
+    uint8_t ccdf[4016];
+} QEMU_PACKED ChscSeiNt2Res;
+
+typedef struct S390MsixInfo {
+    uint8_t table_bar;
+    uint8_t pba_bar;
+    uint16_t entries;
+    uint32_t table_offset;
+    uint32_t pba_offset;
+} S390MsixInfo;
+
+typedef struct S390IOTLBEntry {
+    uint64_t iova;
+    uint64_t translated_addr;
+    uint64_t len;
+    uint64_t perm;
+} S390IOTLBEntry;
+
+struct S390PCIIOMMU {
+    Object parent_obj;
+    S390PCIBusDevice *pbdev;
+    AddressSpace as;
+    MemoryRegion mr;
+    IOMMUMemoryRegion iommu_mr;
+    bool enabled;
+    uint64_t g_iota;
+    uint64_t pba;
+    uint64_t pal;
+    GHashTable *iotlb;
+};
+
+typedef struct S390PCIIOMMUTable {
+    uint64_t key;
+    S390PCIIOMMU *iommu[PCI_SLOT_MAX];
+} S390PCIIOMMUTable;
+
+/* Function Measurement Block */
+#define DEFAULT_MUI 4000
+#define UPDATE_U_BIT 0x1ULL
+#define FMBK_MASK 0xfULL
+
+typedef struct ZpciFmbFmt0 {
+    uint64_t dma_rbytes;
+    uint64_t dma_wbytes;
+} ZpciFmbFmt0;
+
+#define ZPCI_FMB_CNT_LD    0
+#define ZPCI_FMB_CNT_ST    1
+#define ZPCI_FMB_CNT_STB   2
+#define ZPCI_FMB_CNT_RPCIT 3
+#define ZPCI_FMB_CNT_MAX   4
+
+#define ZPCI_FMB_FORMAT    0
+
+typedef struct ZpciFmb {
+    uint32_t format;
+    uint32_t sample;
+    uint64_t last_update;
+    uint64_t counter[ZPCI_FMB_CNT_MAX];
+    ZpciFmbFmt0 fmt0;
+} ZpciFmb;
+QEMU_BUILD_BUG_MSG(offsetof(ZpciFmb, fmt0) != 48, "padding in ZpciFmb");
+
+struct S390PCIBusDevice {
+    DeviceState qdev;
+    PCIDevice *pdev;
+    ZpciState state;
+    char *target;
+    uint16_t uid;
+    uint32_t idx;
+    uint32_t fh;
+    uint32_t fid;
+    bool fid_defined;
+    uint64_t fmb_addr;
+    ZpciFmb fmb;
+    QEMUTimer *fmb_timer;
+    uint8_t isc;
+    uint16_t noi;
+    uint16_t maxstbl;
+    uint8_t sum;
+    S390MsixInfo msix;
+    AdapterRoutes routes;
+    S390PCIIOMMU *iommu;
+    MemoryRegion msix_notify_mr;
+    IndAddr *summary_ind;
+    IndAddr *indicator;
+    bool pci_unplug_request_processed;
+    bool unplug_requested;
+    QTAILQ_ENTRY(S390PCIBusDevice) link;
+};
+
+struct S390PCIBus {
+    BusState qbus;
+};
+
+struct S390pciState {
+    PCIHostState parent_obj;
+    uint32_t next_idx;
+    int bus_no;
+    S390PCIBus *bus;
+    GHashTable *iommu_table;
+    GHashTable *zpci_table;
+    QTAILQ_HEAD(, SeiContainer) pending_sei;
+    QTAILQ_HEAD(, S390PCIBusDevice) zpci_devs;
+};
+
+S390pciState *s390_get_phb(void);
+int pci_chsc_sei_nt2_get_event(void *res);
+int pci_chsc_sei_nt2_have_event(void);
+void s390_pci_sclp_configure(SCCB *sccb);
+void s390_pci_sclp_deconfigure(SCCB *sccb);
+void s390_pci_iommu_enable(S390PCIIOMMU *iommu);
+void s390_pci_iommu_disable(S390PCIIOMMU *iommu);
+void s390_pci_generate_error_event(uint16_t pec, uint32_t fh, uint32_t fid,
+                                   uint64_t faddr, uint32_t e);
+uint16_t s390_guest_io_table_walk(uint64_t g_iota, hwaddr addr,
+                                  S390IOTLBEntry *entry);
+S390PCIBusDevice *s390_pci_find_dev_by_idx(S390pciState *s, uint32_t idx);
+S390PCIBusDevice *s390_pci_find_dev_by_fh(S390pciState *s, uint32_t fh);
+S390PCIBusDevice *s390_pci_find_dev_by_fid(S390pciState *s, uint32_t fid);
+S390PCIBusDevice *s390_pci_find_dev_by_target(S390pciState *s,
+                                              const char *target);
+S390PCIBusDevice *s390_pci_find_next_avail_dev(S390pciState *s,
+                                               S390PCIBusDevice *pbdev);
+
+#endif
diff --git a/include/hw/s390x/s390-pci-inst.h b/include/hw/s390x/s390-pci-inst.h
new file mode 100644
index 0000000..fa3bf8b
--- /dev/null
+++ b/include/hw/s390x/s390-pci-inst.h
@@ -0,0 +1,312 @@
+/*
+ * s390 PCI instruction definitions
+ *
+ * Copyright 2014 IBM Corp.
+ * Author(s): Frank Blaschka <frank.blaschka@de.ibm.com>
+ *            Hong Bo Li <lihbbj@cn.ibm.com>
+ *            Yi Min Zhao <zyimin@cn.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#ifndef HW_S390_PCI_INST_H
+#define HW_S390_PCI_INST_H
+
+#include "s390-pci-bus.h"
+#include "sysemu/dma.h"
+
+/* CLP common request & response block size */
+#define CLP_BLK_SIZE 4096
+#define PCI_BAR_COUNT 6
+#define PCI_MAX_FUNCTIONS 4096
+
+typedef struct ClpReqHdr {
+    uint16_t len;
+    uint16_t cmd;
+} QEMU_PACKED ClpReqHdr;
+
+typedef struct ClpRspHdr {
+    uint16_t len;
+    uint16_t rsp;
+} QEMU_PACKED ClpRspHdr;
+
+/* CLP Response Codes */
+#define CLP_RC_OK         0x0010  /* Command request successfully */
+#define CLP_RC_CMD        0x0020  /* Command code not recognized */
+#define CLP_RC_PERM       0x0030  /* Command not authorized */
+#define CLP_RC_FMT        0x0040  /* Invalid command request format */
+#define CLP_RC_LEN        0x0050  /* Invalid command request length */
+#define CLP_RC_8K         0x0060  /* Command requires 8K LPCB */
+#define CLP_RC_RESNOT0    0x0070  /* Reserved field not zero */
+#define CLP_RC_NODATA     0x0080  /* No data available */
+#define CLP_RC_FC_UNKNOWN 0x0100  /* Function code not recognized */
+
+/*
+ * Call Logical Processor - Command Codes
+ */
+#define CLP_LIST_PCI            0x0002
+#define CLP_QUERY_PCI_FN        0x0003
+#define CLP_QUERY_PCI_FNGRP     0x0004
+#define CLP_SET_PCI_FN          0x0005
+
+/* PCI function handle list entry */
+typedef struct ClpFhListEntry {
+    uint16_t device_id;
+    uint16_t vendor_id;
+#define CLP_FHLIST_MASK_CONFIG 0x80000000
+    uint32_t config;
+    uint32_t fid;
+    uint32_t fh;
+} QEMU_PACKED ClpFhListEntry;
+
+#define CLP_RC_SETPCIFN_FH      0x0101 /* Invalid PCI fn handle */
+#define CLP_RC_SETPCIFN_FHOP    0x0102 /* Fn handle not valid for op */
+#define CLP_RC_SETPCIFN_DMAAS   0x0103 /* Invalid DMA addr space */
+#define CLP_RC_SETPCIFN_RES     0x0104 /* Insufficient resources */
+#define CLP_RC_SETPCIFN_ALRDY   0x0105 /* Fn already in requested state */
+#define CLP_RC_SETPCIFN_ERR     0x0106 /* Fn in permanent error state */
+#define CLP_RC_SETPCIFN_RECPND  0x0107 /* Error recovery pending */
+#define CLP_RC_SETPCIFN_BUSY    0x0108 /* Fn busy */
+#define CLP_RC_LISTPCI_BADRT    0x010a /* Resume token not recognized */
+#define CLP_RC_QUERYPCIFG_PFGID 0x010b /* Unrecognized PFGID */
+
+/* request or response block header length */
+#define LIST_PCI_HDR_LEN 32
+
+/* Number of function handles fitting in response block */
+#define CLP_FH_LIST_NR_ENTRIES \
+    ((CLP_BLK_SIZE - 2 * LIST_PCI_HDR_LEN) \
+        / sizeof(ClpFhListEntry))
+
+#define CLP_SET_ENABLE_PCI_FN  0 /* Yes, 0 enables it */
+#define CLP_SET_DISABLE_PCI_FN 1 /* Yes, 1 disables it */
+
+#define CLP_UTIL_STR_LEN 64
+
+#define CLP_MASK_FMT 0xf0000000
+
+/* List PCI functions request */
+typedef struct ClpReqListPci {
+    ClpReqHdr hdr;
+    uint32_t fmt;
+    uint64_t reserved1;
+    uint64_t resume_token;
+    uint64_t reserved2;
+} QEMU_PACKED ClpReqListPci;
+
+/* List PCI functions response */
+typedef struct ClpRspListPci {
+    ClpRspHdr hdr;
+    uint32_t fmt;
+    uint64_t reserved1;
+    uint64_t resume_token;
+    uint32_t mdd;
+    uint16_t max_fn;
+    uint8_t flags;
+    uint8_t entry_size;
+    ClpFhListEntry fh_list[CLP_FH_LIST_NR_ENTRIES];
+} QEMU_PACKED ClpRspListPci;
+
+/* Query PCI function request */
+typedef struct ClpReqQueryPci {
+    ClpReqHdr hdr;
+    uint32_t fmt;
+    uint64_t reserved1;
+    uint32_t fh; /* function handle */
+    uint32_t reserved2;
+    uint64_t reserved3;
+} QEMU_PACKED ClpReqQueryPci;
+
+/* Query PCI function response */
+typedef struct ClpRspQueryPci {
+    ClpRspHdr hdr;
+    uint32_t fmt;
+    uint64_t reserved1;
+    uint16_t vfn; /* virtual fn number */
+#define CLP_RSP_QPCI_MASK_UTIL  0x100
+#define CLP_RSP_QPCI_MASK_PFGID 0xff
+    uint16_t ug;
+    uint32_t fid; /* pci function id */
+    uint8_t bar_size[PCI_BAR_COUNT];
+    uint16_t pchid;
+    uint32_t bar[PCI_BAR_COUNT];
+    uint64_t reserved2;
+    uint64_t sdma; /* start dma as */
+    uint64_t edma; /* end dma as */
+    uint32_t reserved3[11];
+    uint32_t uid;
+    uint8_t util_str[CLP_UTIL_STR_LEN]; /* utility string */
+} QEMU_PACKED ClpRspQueryPci;
+
+/* Query PCI function group request */
+typedef struct ClpReqQueryPciGrp {
+    ClpReqHdr hdr;
+    uint32_t fmt;
+    uint64_t reserved1;
+#define CLP_REQ_QPCIG_MASK_PFGID 0xff
+    uint32_t g;
+    uint32_t reserved2;
+    uint64_t reserved3;
+} QEMU_PACKED ClpReqQueryPciGrp;
+
+/* Query PCI function group response */
+typedef struct ClpRspQueryPciGrp {
+    ClpRspHdr hdr;
+    uint32_t fmt;
+    uint64_t reserved1;
+#define CLP_RSP_QPCIG_MASK_NOI 0xfff
+    uint16_t i;
+    uint8_t version;
+#define CLP_RSP_QPCIG_MASK_FRAME   0x2
+#define CLP_RSP_QPCIG_MASK_REFRESH 0x1
+    uint8_t fr;
+    uint16_t maxstbl;
+    uint16_t mui;
+    uint64_t reserved3;
+    uint64_t dasm; /* dma address space mask */
+    uint64_t msia; /* MSI address */
+    uint64_t reserved4;
+    uint64_t reserved5;
+} QEMU_PACKED ClpRspQueryPciGrp;
+
+/* Set PCI function request */
+typedef struct ClpReqSetPci {
+    ClpReqHdr hdr;
+    uint32_t fmt;
+    uint64_t reserved1;
+    uint32_t fh; /* function handle */
+    uint16_t reserved2;
+    uint8_t oc; /* operation controls */
+    uint8_t ndas; /* number of dma spaces */
+    uint64_t reserved3;
+} QEMU_PACKED ClpReqSetPci;
+
+/* Set PCI function response */
+typedef struct ClpRspSetPci {
+    ClpRspHdr hdr;
+    uint32_t fmt;
+    uint64_t reserved1;
+    uint32_t fh; /* function handle */
+    uint32_t reserved3;
+    uint64_t reserved4;
+} QEMU_PACKED ClpRspSetPci;
+
+typedef struct ClpReqRspListPci {
+    ClpReqListPci request;
+    ClpRspListPci response;
+} QEMU_PACKED ClpReqRspListPci;
+
+typedef struct ClpReqRspSetPci {
+    ClpReqSetPci request;
+    ClpRspSetPci response;
+} QEMU_PACKED ClpReqRspSetPci;
+
+typedef struct ClpReqRspQueryPci {
+    ClpReqQueryPci request;
+    ClpRspQueryPci response;
+} QEMU_PACKED ClpReqRspQueryPci;
+
+typedef struct ClpReqRspQueryPciGrp {
+    ClpReqQueryPciGrp request;
+    ClpRspQueryPciGrp response;
+} QEMU_PACKED ClpReqRspQueryPciGrp;
+
+/* Load/Store status codes */
+#define ZPCI_PCI_ST_FUNC_NOT_ENABLED        4
+#define ZPCI_PCI_ST_FUNC_IN_ERR             8
+#define ZPCI_PCI_ST_BLOCKED                 12
+#define ZPCI_PCI_ST_INSUF_RES               16
+#define ZPCI_PCI_ST_INVAL_AS                20
+#define ZPCI_PCI_ST_FUNC_ALREADY_ENABLED    24
+#define ZPCI_PCI_ST_DMA_AS_NOT_ENABLED      28
+#define ZPCI_PCI_ST_2ND_OP_IN_INV_AS        36
+#define ZPCI_PCI_ST_FUNC_NOT_AVAIL          40
+#define ZPCI_PCI_ST_ALREADY_IN_RQ_STATE     44
+
+/* Load/Store return codes */
+#define ZPCI_PCI_LS_OK              0
+#define ZPCI_PCI_LS_ERR             1
+#define ZPCI_PCI_LS_BUSY            2
+#define ZPCI_PCI_LS_INVAL_HANDLE    3
+
+/* Modify PCI status codes */
+#define ZPCI_MOD_ST_RES_NOT_AVAIL 4
+#define ZPCI_MOD_ST_INSUF_RES     16
+#define ZPCI_MOD_ST_SEQUENCE      24
+#define ZPCI_MOD_ST_DMAAS_INVAL   28
+#define ZPCI_MOD_ST_FRAME_INVAL   32
+#define ZPCI_MOD_ST_ERROR_RECOVER 40
+
+/* Modify PCI Function Controls */
+#define ZPCI_MOD_FC_REG_INT     2
+#define ZPCI_MOD_FC_DEREG_INT   3
+#define ZPCI_MOD_FC_REG_IOAT    4
+#define ZPCI_MOD_FC_DEREG_IOAT  5
+#define ZPCI_MOD_FC_REREG_IOAT  6
+#define ZPCI_MOD_FC_RESET_ERROR 7
+#define ZPCI_MOD_FC_RESET_BLOCK 9
+#define ZPCI_MOD_FC_SET_MEASURE 10
+
+/* Store PCI Function Controls status codes */
+#define ZPCI_STPCIFC_ST_PERM_ERROR    8
+#define ZPCI_STPCIFC_ST_INVAL_DMAAS   28
+#define ZPCI_STPCIFC_ST_ERROR_RECOVER 40
+
+/* FIB function controls */
+#define ZPCI_FIB_FC_ENABLED     0x80
+#define ZPCI_FIB_FC_ERROR       0x40
+#define ZPCI_FIB_FC_LS_BLOCKED  0x20
+#define ZPCI_FIB_FC_DMAAS_REG   0x10
+
+/* FIB function controls */
+#define ZPCI_FIB_FC_ENABLED     0x80
+#define ZPCI_FIB_FC_ERROR       0x40
+#define ZPCI_FIB_FC_LS_BLOCKED  0x20
+#define ZPCI_FIB_FC_DMAAS_REG   0x10
+
+/* Function Information Block */
+typedef struct ZpciFib {
+    uint8_t fmt;   /* format */
+    uint8_t reserved1[7];
+    uint8_t fc;                  /* function controls */
+    uint8_t reserved2;
+    uint16_t reserved3;
+    uint32_t reserved4;
+    uint64_t pba;                /* PCI base address */
+    uint64_t pal;                /* PCI address limit */
+    uint64_t iota;               /* I/O Translation Anchor */
+#define FIB_DATA_ISC(x)    (((x) >> 28) & 0x7)
+#define FIB_DATA_NOI(x)    (((x) >> 16) & 0xfff)
+#define FIB_DATA_AIBVO(x) (((x) >> 8) & 0x3f)
+#define FIB_DATA_SUM(x)    (((x) >> 7) & 0x1)
+#define FIB_DATA_AISBO(x)  ((x) & 0x3f)
+    uint32_t data;
+    uint32_t reserved5;
+    uint64_t aibv;               /* Adapter int bit vector address */
+    uint64_t aisb;               /* Adapter int summary bit address */
+    uint64_t fmb_addr;           /* Function measurement address and key */
+    uint32_t reserved6;
+    uint32_t gd;
+} QEMU_PACKED ZpciFib;
+
+int pci_dereg_irqs(S390PCIBusDevice *pbdev);
+void pci_dereg_ioat(S390PCIIOMMU *iommu);
+int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra);
+int pcilg_service_call(S390CPU *cpu, uint8_t r1, uint8_t r2, uintptr_t ra);
+int pcistg_service_call(S390CPU *cpu, uint8_t r1, uint8_t r2, uintptr_t ra);
+int rpcit_service_call(S390CPU *cpu, uint8_t r1, uint8_t r2, uintptr_t ra);
+int pcistb_service_call(S390CPU *cpu, uint8_t r1, uint8_t r3, uint64_t gaddr,
+                        uint8_t ar, uintptr_t ra);
+int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
+                        uintptr_t ra);
+int stpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
+                         uintptr_t ra);
+void fmb_timer_free(S390PCIBusDevice *pbdev);
+
+#define ZPCI_IO_BAR_MIN 0
+#define ZPCI_IO_BAR_MAX 5
+#define ZPCI_CONFIG_BAR 15
+
+#endif
-- 
1.8.3.1


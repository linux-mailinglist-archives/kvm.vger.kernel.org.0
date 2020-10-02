Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725E3281C94
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgJBUHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:07:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26368 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725554AbgJBUHP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 16:07:15 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092K26h2129853;
        Fri, 2 Oct 2020 16:06:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=/c4aQd29M1auT0/CyDwBkm84KfpaCpql/9dOy4nQC0E=;
 b=eALEgxmdc+44lD6T0bcXOupKuv9yscmfYbSHfNOq/97FttwmItdOhq1oRjOInhDjoHEN
 39zZ+zsiKWb4ZnRSwiDYwAJhLSbXtjLQ+lbKtSjDtO8d3an9yqjkAfXb19MRqCh/7hfo
 YbH3ioQ67lL4rVwEjg8DIfO0felfvfhedGOGmh/NVNiRcUiIMtlFyTu45P/ZOplvofsy
 UHi8luMb62JciJ2LeBdHQrz1+NTynV9KYAAVEdZIqBlQBrGbK2cmG0PXa2YzvOuJDSRr
 /s0bHtFHQ3FEUoA5a6VtVPYPI1zqAjTqO4IH8HSZgl+H2GqN9T4OUVVeTXZfYMJDTYe7 PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33xaq1rcbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:06:46 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092K2T4e131655;
        Fri, 2 Oct 2020 16:06:46 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33xaq1rcbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:06:46 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092JmV0c013682;
        Fri, 2 Oct 2020 20:06:45 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04wdc.us.ibm.com with ESMTP id 33sw9a0aqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 20:06:45 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092K6eva34341184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 20:06:40 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 397F5BE051;
        Fri,  2 Oct 2020 20:06:44 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4C48BE04F;
        Fri,  2 Oct 2020 20:06:42 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.4.25])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 20:06:42 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v2 6/9] s390x/pci: use a PCI Group structure
Date:   Fri,  2 Oct 2020 16:06:28 -0400
Message-Id: <1601669191-6731-7-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
References: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 mlxscore=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=2 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020142
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

We use a S390PCIGroup structure to hold the information related to a
zPCI Function group.

This allows us to be ready to support multiple groups and to retrieve
the group information from the host.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-bus.c         | 42 +++++++++++++++++++++++++++++++++++++++++
 hw/s390x/s390-pci-inst.c        | 23 +++++++++++++---------
 include/hw/s390x/s390-pci-bus.h | 10 ++++++++++
 3 files changed, 66 insertions(+), 9 deletions(-)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index a929340..c99f2f0 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -737,6 +737,46 @@ static void s390_pci_iommu_free(S390pciState *s, PCIBus *bus, int32_t devfn)
     object_unref(OBJECT(iommu));
 }
 
+static S390PCIGroup *s390_group_create(int id)
+{
+    S390PCIGroup *group;
+    S390pciState *s = s390_get_phb();
+
+    group = g_new0(S390PCIGroup, 1);
+    group->id = id;
+    QTAILQ_INSERT_TAIL(&s->zpci_groups, group, link);
+    return group;
+}
+
+S390PCIGroup *s390_group_find(int id)
+{
+    S390PCIGroup *group;
+    S390pciState *s = s390_get_phb();
+
+    QTAILQ_FOREACH(group, &s->zpci_groups, link) {
+        if (group->id == id) {
+            return group;
+        }
+    }
+    return NULL;
+}
+
+static void s390_pci_init_default_group(void)
+{
+    S390PCIGroup *group;
+    ClpRspQueryPciGrp *resgrp;
+
+    group = s390_group_create(ZPCI_DEFAULT_FN_GRP);
+    resgrp = &group->zpci_group;
+    resgrp->fr = 1;
+    stq_p(&resgrp->dasm, 0);
+    stq_p(&resgrp->msia, ZPCI_MSI_ADDR);
+    stw_p(&resgrp->mui, DEFAULT_MUI);
+    stw_p(&resgrp->i, 128);
+    stw_p(&resgrp->maxstbl, 128);
+    resgrp->version = 0;
+}
+
 static void s390_pcihost_realize(DeviceState *dev, Error **errp)
 {
     PCIBus *b;
@@ -764,7 +804,9 @@ static void s390_pcihost_realize(DeviceState *dev, Error **errp)
     s->bus_no = 0;
     QTAILQ_INIT(&s->pending_sei);
     QTAILQ_INIT(&s->zpci_devs);
+    QTAILQ_INIT(&s->zpci_groups);
 
+    s390_pci_init_default_group();
     css_register_io_adapters(CSS_IO_ADAPTER_PCI, true, false,
                              S390_ADAPTER_SUPPRESSIBLE, errp);
 }
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index 639b13c..aeb8b5f 100644
--- a/hw/s390x/s390-pci-inst.c
+++ b/hw/s390x/s390-pci-inst.c
@@ -284,21 +284,25 @@ int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra)
         stq_p(&resquery->edma, ZPCI_EDMA_ADDR);
         stl_p(&resquery->fid, pbdev->fid);
         stw_p(&resquery->pchid, 0);
-        stw_p(&resquery->ug, 1);
+        stw_p(&resquery->ug, ZPCI_DEFAULT_FN_GRP);
         stl_p(&resquery->uid, pbdev->uid);
         stw_p(&resquery->hdr.rsp, CLP_RC_OK);
         break;
     }
     case CLP_QUERY_PCI_FNGRP: {
         ClpRspQueryPciGrp *resgrp = (ClpRspQueryPciGrp *)resh;
-        resgrp->fr = 1;
-        stq_p(&resgrp->dasm, 0);
-        stq_p(&resgrp->msia, ZPCI_MSI_ADDR);
-        stw_p(&resgrp->mui, DEFAULT_MUI);
-        stw_p(&resgrp->i, 128);
-        stw_p(&resgrp->maxstbl, 128);
-        resgrp->version = 0;
 
+        ClpReqQueryPciGrp *reqgrp = (ClpReqQueryPciGrp *)reqh;
+        S390PCIGroup *group;
+
+        group = s390_group_find(reqgrp->g);
+        if (!group) {
+            /* We do not allow access to unknown groups */
+            /* The group must have been obtained with a vfio device */
+            stw_p(&resgrp->hdr.rsp, CLP_RC_QUERYPCIFG_PFGID);
+            goto out;
+        }
+        memcpy(resgrp, &group->zpci_group, sizeof(ClpRspQueryPciGrp));
         stw_p(&resgrp->hdr.rsp, CLP_RC_OK);
         break;
     }
@@ -754,7 +758,8 @@ int pcistb_service_call(S390CPU *cpu, uint8_t r1, uint8_t r3, uint64_t gaddr,
     }
     /* Length must be greater than 8, a multiple of 8 */
     /* and not greater than maxstbl */
-    if ((len <= 8) || (len % 8) || (len > pbdev->maxstbl)) {
+    if ((len <= 8) || (len % 8) ||
+        (len > pbdev->pci_group->zpci_group.maxstbl)) {
         goto specification_error;
     }
     /* Do not cross a 4K-byte boundary */
diff --git a/include/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
index 04e7cb6..52f6e7b 100644
--- a/include/hw/s390x/s390-pci-bus.h
+++ b/include/hw/s390x/s390-pci-bus.h
@@ -308,6 +308,14 @@ typedef struct ZpciFmb {
 } ZpciFmb;
 QEMU_BUILD_BUG_MSG(offsetof(ZpciFmb, fmt0) != 48, "padding in ZpciFmb");
 
+#define ZPCI_DEFAULT_FN_GRP 0x20
+typedef struct S390PCIGroup {
+    ClpRspQueryPciGrp zpci_group;
+    int id;
+    QTAILQ_ENTRY(S390PCIGroup) link;
+} S390PCIGroup;
+S390PCIGroup *s390_group_find(int id);
+
 struct S390PCIBusDevice {
     DeviceState qdev;
     PCIDevice *pdev;
@@ -325,6 +333,7 @@ struct S390PCIBusDevice {
     uint16_t noi;
     uint16_t maxstbl;
     uint8_t sum;
+    S390PCIGroup *pci_group;
     S390MsixInfo msix;
     AdapterRoutes routes;
     S390PCIIOMMU *iommu;
@@ -349,6 +358,7 @@ struct S390pciState {
     GHashTable *zpci_table;
     QTAILQ_HEAD(, SeiContainer) pending_sei;
     QTAILQ_HEAD(, S390PCIBusDevice) zpci_devs;
+    QTAILQ_HEAD(, S390PCIGroup) zpci_groups;
 };
 
 S390pciState *s390_get_phb(void);
-- 
1.8.3.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F7A5AB782
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 19:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236336AbiIBR2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 13:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbiIBR15 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 13:27:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB687C52E
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 10:27:55 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 282HDiPr005315;
        Fri, 2 Sep 2022 17:27:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jgveCAnwhqDUN07hL/AAS+Yc71Ib7lo3A1M9LGI+6AE=;
 b=r1biScS9Uw+gM0T+2WhBW9RP6na3IDUXYghlMwtyHPOrdnl9Ms9MqP0Z/XcQRwW+gn9p
 2bvFaLi8MG9+SDZvpnFAN3eVNjaGk9SExnQjY2pCCCZiQtjJuiWsd65aj+6MkAzHAPPM
 bvDNupYZ0Iy1n7L1Bq5ZEDW57KGVSgRl0vTDioC0mNkc0ICAR7AVfm2TOKpe/0qfOVoC
 EmZfzWvnAEUD8kZmg+dcNvU/tWS7mhoZqTa4XbguExeYCSxqPvZSpCKXCHEmVjVvoBNK
 mu80L9QjpUMTM00UabPZ+d5ufs5ECoI0tvOirBSrOHMPeoiDTWG9fA1MPXf99heoxxB6 +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbp218ab4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 17:27:51 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 282HEM3n009099;
        Fri, 2 Sep 2022 17:27:51 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbp218aah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 17:27:51 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 282HLAYo019245;
        Fri, 2 Sep 2022 17:27:50 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3j7awakkmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 17:27:49 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 282HRmGS10945182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Sep 2022 17:27:48 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C6206E04E;
        Fri,  2 Sep 2022 17:27:48 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A0386E053;
        Fri,  2 Sep 2022 17:27:47 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com.com (unknown [9.160.86.252])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  2 Sep 2022 17:27:47 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v8 6/8] s390x/pci: let intercept devices have separate PCI groups
Date:   Fri,  2 Sep 2022 13:27:35 -0400
Message-Id: <20220902172737.170349-7-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220902172737.170349-1-mjrosato@linux.ibm.com>
References: <20220902172737.170349-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kIEcGySR52GBxcngnKXJ5LQJeq6UzE4D
X-Proofpoint-GUID: wKPUZvtmGvCIyUHjhrXPazeULZjsqr99
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-02_04,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 bulkscore=0 clxscore=1015 impostorscore=0 mlxscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209020080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's use the reserved pool of simulated PCI groups to allow intercept
devices to have separate groups from interpreted devices as some group
values may be different. If we run out of simulated PCI groups, subsequent
intercept devices just get the default group.
Furthermore, if we encounter any PCI groups from hostdevs that are marked
as simulated, let's just assign them to the default group to avoid
conflicts between host simulated groups and our own simulated groups.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-bus.c         | 19 ++++++++++++++--
 hw/s390x/s390-pci-vfio.c        | 40 ++++++++++++++++++++++++++++++---
 include/hw/s390x/s390-pci-bus.h |  6 ++++-
 3 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index e66a0dfbef..5342f7899f 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -748,13 +748,14 @@ static void s390_pci_iommu_free(S390pciState *s, PCIBus *bus, int32_t devfn)
     object_unref(OBJECT(iommu));
 }
 
-S390PCIGroup *s390_group_create(int id)
+S390PCIGroup *s390_group_create(int id, int host_id)
 {
     S390PCIGroup *group;
     S390pciState *s = s390_get_phb();
 
     group = g_new0(S390PCIGroup, 1);
     group->id = id;
+    group->host_id = host_id;
     QTAILQ_INSERT_TAIL(&s->zpci_groups, group, link);
     return group;
 }
@@ -772,12 +773,25 @@ S390PCIGroup *s390_group_find(int id)
     return NULL;
 }
 
+S390PCIGroup *s390_group_find_host_sim(int host_id)
+{
+    S390PCIGroup *group;
+    S390pciState *s = s390_get_phb();
+
+    QTAILQ_FOREACH(group, &s->zpci_groups, link) {
+        if (group->id >= ZPCI_SIM_GRP_START && group->host_id == host_id) {
+            return group;
+        }
+    }
+    return NULL;
+}
+
 static void s390_pci_init_default_group(void)
 {
     S390PCIGroup *group;
     ClpRspQueryPciGrp *resgrp;
 
-    group = s390_group_create(ZPCI_DEFAULT_FN_GRP);
+    group = s390_group_create(ZPCI_DEFAULT_FN_GRP, ZPCI_DEFAULT_FN_GRP);
     resgrp = &group->zpci_group;
     resgrp->fr = 1;
     resgrp->dasm = 0;
@@ -825,6 +839,7 @@ static void s390_pcihost_realize(DeviceState *dev, Error **errp)
                                            NULL, g_free);
     s->zpci_table = g_hash_table_new_full(g_int_hash, g_int_equal, NULL, NULL);
     s->bus_no = 0;
+    s->next_sim_grp = ZPCI_SIM_GRP_START;
     QTAILQ_INIT(&s->pending_sei);
     QTAILQ_INIT(&s->zpci_devs);
     QTAILQ_INIT(&s->zpci_dma_limit);
diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
index 4bf0a7e22d..985980f021 100644
--- a/hw/s390x/s390-pci-vfio.c
+++ b/hw/s390x/s390-pci-vfio.c
@@ -150,13 +150,18 @@ static void s390_pci_read_group(S390PCIBusDevice *pbdev,
 {
     struct vfio_info_cap_header *hdr;
     struct vfio_device_info_cap_zpci_group *cap;
+    S390pciState *s = s390_get_phb();
     ClpRspQueryPciGrp *resgrp;
     VFIOPCIDevice *vpci =  container_of(pbdev->pdev, VFIOPCIDevice, pdev);
+    uint8_t start_gid = pbdev->zpci_fn.pfgid;
 
     hdr = vfio_get_device_info_cap(info, VFIO_DEVICE_INFO_CAP_ZPCI_GROUP);
 
-    /* If capability not provided, just use the default group */
-    if (hdr == NULL) {
+    /*
+     * If capability not provided or the underlying hostdev is simulated, just
+     * use the default group.
+     */
+    if (hdr == NULL || pbdev->zpci_fn.pfgid >= ZPCI_SIM_GRP_START) {
         trace_s390_pci_clp_cap(vpci->vbasedev.name,
                                VFIO_DEVICE_INFO_CAP_ZPCI_GROUP);
         pbdev->zpci_fn.pfgid = ZPCI_DEFAULT_FN_GRP;
@@ -165,11 +170,40 @@ static void s390_pci_read_group(S390PCIBusDevice *pbdev,
     }
     cap = (void *) hdr;
 
+    /*
+     * For an intercept device, let's use an existing simulated group if one
+     * one was already created for other intercept devices in this group.
+     * If not, create a new simulated group if any are still available.
+     * If all else fails, just fall back on the default group.
+     */
+    if (!pbdev->interp) {
+        pbdev->pci_group = s390_group_find_host_sim(pbdev->zpci_fn.pfgid);
+        if (pbdev->pci_group) {
+            /* Use existing simulated group */
+            pbdev->zpci_fn.pfgid = pbdev->pci_group->id;
+            return;
+        } else {
+            if (s->next_sim_grp == ZPCI_DEFAULT_FN_GRP) {
+                /* All out of simulated groups, use default */
+                trace_s390_pci_clp_cap(vpci->vbasedev.name,
+                                       VFIO_DEVICE_INFO_CAP_ZPCI_GROUP);
+                pbdev->zpci_fn.pfgid = ZPCI_DEFAULT_FN_GRP;
+                pbdev->pci_group = s390_group_find(ZPCI_DEFAULT_FN_GRP);
+                return;
+            } else {
+                /* We can assign a new simulated group */
+                pbdev->zpci_fn.pfgid = s->next_sim_grp;
+                s->next_sim_grp++;
+                /* Fall through to create the new sim group using CLP info */
+            }
+        }
+    }
+
     /* See if the PCI group is already defined, create if not */
     pbdev->pci_group = s390_group_find(pbdev->zpci_fn.pfgid);
 
     if (!pbdev->pci_group) {
-        pbdev->pci_group = s390_group_create(pbdev->zpci_fn.pfgid);
+        pbdev->pci_group = s390_group_create(pbdev->zpci_fn.pfgid, start_gid);
 
         resgrp = &pbdev->pci_group->zpci_group;
         if (cap->flags & VFIO_DEVICE_INFO_ZPCI_FLAG_REFRESH) {
diff --git a/include/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
index 5b09f0cf2f..0605fcea24 100644
--- a/include/hw/s390x/s390-pci-bus.h
+++ b/include/hw/s390x/s390-pci-bus.h
@@ -315,13 +315,16 @@ typedef struct ZpciFmb {
 QEMU_BUILD_BUG_MSG(offsetof(ZpciFmb, fmt0) != 48, "padding in ZpciFmb");
 
 #define ZPCI_DEFAULT_FN_GRP 0xFF
+#define ZPCI_SIM_GRP_START 0xF0
 typedef struct S390PCIGroup {
     ClpRspQueryPciGrp zpci_group;
     int id;
+    int host_id;
     QTAILQ_ENTRY(S390PCIGroup) link;
 } S390PCIGroup;
-S390PCIGroup *s390_group_create(int id);
+S390PCIGroup *s390_group_create(int id, int host_id);
 S390PCIGroup *s390_group_find(int id);
+S390PCIGroup *s390_group_find_host_sim(int host_id);
 
 struct S390PCIBusDevice {
     DeviceState qdev;
@@ -370,6 +373,7 @@ struct S390pciState {
     QTAILQ_HEAD(, S390PCIBusDevice) zpci_devs;
     QTAILQ_HEAD(, S390PCIDMACount) zpci_dma_limit;
     QTAILQ_HEAD(, S390PCIGroup) zpci_groups;
+    uint8_t next_sim_grp;
 };
 
 S390pciState *s390_get_phb(void);
-- 
2.37.2


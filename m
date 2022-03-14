Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29994D8D40
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244612AbiCNTvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244594AbiCNTvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:51:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4625A3ED17
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:50:20 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlZEC024364;
        Mon, 14 Mar 2022 19:49:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=a9WjLZ7JkjFEqlZdkUhc6FVsxBFAWxOYRQ8qrBaiaPU=;
 b=pPnk190qlviYVya89kRbnV+Sgl4eurLRft5N023eGrRW1LevUnCtNqfqHZBPkwwnfAhc
 bMZEHpiofaa7Eo8hIB9GKFxftMWrKpRYEO3lTmoTC286DqRoeaCm7xl048EtMkzBdFE8
 lOyjnCkJuESoOPPUASvTAkERwv61psBGypDsS62Y+t5LWmgjhgEqkp+0QJ7v71hXx7dZ
 H0ooousd+/j0riMiBW+cb+iY10lLJ35llkIX5uiAo0nj+pR8NHCP/jPy+61FehQuJGQE
 ONb90ETEymqlJ9aBdQijmGQJGbbVHYd1FGlaqhi1hgvqaGBz1AXAKC+RunYSu+CNgHuS zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6ab91ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:41 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJmj3Y030942;
        Mon, 14 Mar 2022 19:49:41 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6ab91nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:40 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJl6CF005336;
        Mon, 14 Mar 2022 19:49:39 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 3erk5989gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:39 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJnc7o13631814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:49:38 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC11F112071;
        Mon, 14 Mar 2022 19:49:37 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACFA311206D;
        Mon, 14 Mar 2022 19:49:32 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:49:32 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v4 02/11] vfio: handle KVM-owned IOMMU requests
Date:   Mon, 14 Mar 2022 15:49:11 -0400
Message-Id: <20220314194920.58888-3-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194920.58888-1-mjrosato@linux.ibm.com>
References: <20220314194920.58888-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ARIVp70G1NptRZdBDwvv-2ycrmDWUY4M
X-Proofpoint-ORIG-GUID: EkWs5pdD0m8fPFsYOqS_lgphhENrkBTX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 mlxscore=0 clxscore=1015 phishscore=0 impostorscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

s390x PCI devices need to use a special KVM-managed IOMMU domain as part
of zPCI interpretation.  To facilitate this, let a vfio device indicate
that it wishes to use a KVM-managed IOMMU so that it can be reflected by
the group and, ultimately, trigger a KVM-managed argument for the
VFIO_SET_IOMMU ioctl.

This patch sets up the framework to allow a device to trigger the
VFIO_SET_IOMMU with the new KVM-owend type.  A subsequent patch will add
exploitation by s390x PCI.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/vfio/ap.c                  |  2 +-
 hw/vfio/ccw.c                 |  2 +-
 hw/vfio/common.c              | 26 +++++++++++++++++++++-----
 hw/vfio/pci.c                 |  3 ++-
 hw/vfio/pci.h                 |  1 +
 hw/vfio/platform.c            |  2 +-
 include/hw/vfio/vfio-common.h |  4 +++-
 7 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/hw/vfio/ap.c b/hw/vfio/ap.c
index e0dd561e85..22c402771a 100644
--- a/hw/vfio/ap.c
+++ b/hw/vfio/ap.c
@@ -81,7 +81,7 @@ static VFIOGroup *vfio_ap_get_group(VFIOAPDevice *vapdev, Error **errp)
 
     g_free(group_path);
 
-    return vfio_get_group(groupid, &address_space_memory, errp);
+    return vfio_get_group(groupid, &address_space_memory, false, errp);
 }
 
 static void vfio_ap_realize(DeviceState *dev, Error **errp)
diff --git a/hw/vfio/ccw.c b/hw/vfio/ccw.c
index 0354737666..08b0af5897 100644
--- a/hw/vfio/ccw.c
+++ b/hw/vfio/ccw.c
@@ -650,7 +650,7 @@ static VFIOGroup *vfio_ccw_get_group(S390CCWDevice *cdev, Error **errp)
         return NULL;
     }
 
-    return vfio_get_group(groupid, &address_space_memory, errp);
+    return vfio_get_group(groupid, &address_space_memory, false, errp);
 }
 
 static void vfio_ccw_realize(DeviceState *dev, Error **errp)
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 080046e3f5..227880bf84 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1873,7 +1873,7 @@ static int vfio_get_iommu_type(VFIOContainer *container,
     return -EINVAL;
 }
 
-static int vfio_init_container(VFIOContainer *container, int group_fd,
+static int vfio_init_container(VFIOContainer *container, VFIOGroup *group,
                                Error **errp)
 {
     int iommu_type, ret;
@@ -1883,12 +1883,20 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
         return iommu_type;
     }
 
-    ret = ioctl(group_fd, VFIO_GROUP_SET_CONTAINER, &container->fd);
+    ret = ioctl(group->fd, VFIO_GROUP_SET_CONTAINER, &container->fd);
     if (ret) {
         error_setg_errno(errp, errno, "Failed to set group container");
         return -errno;
     }
 
+    /*
+     * In the case where KVM will manage the IOMMU, we must instruct the host
+     * IOMMU to use the appropriate domain ops
+     */
+    if (group->kvm_managed_iommu) {
+        iommu_type = VFIO_KVM_IOMMU;
+    }
+
     while (ioctl(container->fd, VFIO_SET_IOMMU, iommu_type)) {
         if (iommu_type == VFIO_SPAPR_TCE_v2_IOMMU) {
             /*
@@ -2062,7 +2070,7 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
     QLIST_INIT(&container->hostwin_list);
     QLIST_INIT(&container->vrdl_list);
 
-    ret = vfio_init_container(container, group->fd, errp);
+    ret = vfio_init_container(container, group, errp);
     if (ret) {
         goto free_container_exit;
     }
@@ -2265,7 +2273,8 @@ static void vfio_disconnect_container(VFIOGroup *group)
     }
 }
 
-VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
+VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, bool kvm_managed_iommu,
+                          Error **errp)
 {
     VFIOGroup *group;
     char path[32];
@@ -2273,7 +2282,13 @@ VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
 
     QLIST_FOREACH(group, &vfio_group_list, next) {
         if (group->groupid == groupid) {
-            /* Found it.  Now is it already in the right context? */
+            /* Found it.  Ensure using same IOMMU type */
+            if (group->kvm_managed_iommu != kvm_managed_iommu) {
+                error_setg(errp, "group %d using conflicting iommu ops",
+                           group->groupid);
+                return NULL;
+            }
+            /* Is it already in the right context? */
             if (group->container->space->as == as) {
                 return group;
             } else {
@@ -2307,6 +2322,7 @@ VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
     }
 
     group->groupid = groupid;
+    group->kvm_managed_iommu = kvm_managed_iommu;
     QLIST_INIT(&group->device_list);
 
     if (vfio_connect_container(group, as, errp)) {
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 7b45353ce2..80f7e2880a 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2855,7 +2855,8 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
 
     trace_vfio_realize(vdev->vbasedev.name, groupid);
 
-    group = vfio_get_group(groupid, pci_device_iommu_address_space(pdev), errp);
+    group = vfio_get_group(groupid, pci_device_iommu_address_space(pdev),
+                           vdev->kvm_managed_iommu, errp);
     if (!group) {
         goto error;
     }
diff --git a/hw/vfio/pci.h b/hw/vfio/pci.h
index 64777516d1..f74524384c 100644
--- a/hw/vfio/pci.h
+++ b/hw/vfio/pci.h
@@ -171,6 +171,7 @@ struct VFIOPCIDevice {
     bool no_kvm_ioeventfd;
     bool no_vfio_ioeventfd;
     bool enable_ramfb;
+    bool kvm_managed_iommu;
     VFIODisplay *dpy;
     Notifier irqchip_change_notifier;
 };
diff --git a/hw/vfio/platform.c b/hw/vfio/platform.c
index f8f08a0f36..08793401dd 100644
--- a/hw/vfio/platform.c
+++ b/hw/vfio/platform.c
@@ -577,7 +577,7 @@ static int vfio_base_device_init(VFIODevice *vbasedev, Error **errp)
 
     trace_vfio_platform_base_device_init(vbasedev->name, groupid);
 
-    group = vfio_get_group(groupid, &address_space_memory, errp);
+    group = vfio_get_group(groupid, &address_space_memory, false, errp);
     if (!group) {
         return -ENOENT;
     }
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 8af11b0a76..37aa6ca162 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -162,6 +162,7 @@ typedef struct VFIOGroup {
     QLIST_ENTRY(VFIOGroup) next;
     QLIST_ENTRY(VFIOGroup) container_next;
     bool ram_block_discard_allowed;
+    bool kvm_managed_iommu;
 } VFIOGroup;
 
 typedef struct VFIODMABuf {
@@ -208,7 +209,8 @@ void vfio_region_unmap(VFIORegion *region);
 void vfio_region_exit(VFIORegion *region);
 void vfio_region_finalize(VFIORegion *region);
 void vfio_reset_handler(void *opaque);
-VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp);
+VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, bool kvm_managed_iommu,
+                          Error **errp);
 void vfio_put_group(VFIOGroup *group);
 int vfio_get_device(VFIOGroup *group, const char *name,
                     VFIODevice *vbasedev, Error **errp);
-- 
2.27.0


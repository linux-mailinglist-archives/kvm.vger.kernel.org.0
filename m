Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5324F1BB0
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380921AbiDDVWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379871AbiDDSTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 14:19:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD50C3EA95
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 11:17:47 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234GVnAK007186;
        Mon, 4 Apr 2022 18:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=K98ROeBUgGP1C5opDw71Y7FJ+ZPPUocmL+qKSqUy5T8=;
 b=bXhtBGwNiCv+EIASen60UZRHusvhAddriveh60uvu5lgzJ+k1d3TLUFq6g7hsJyLD7K6
 r2dB34/pgnB2dEc/riwL6HVxYoCzNGW9NCKzCavgRmVCzo42hqB+CDKbWqfhlX8rMVsT
 2zi9UnCoO6Qe1CM0NAYD66nAH2hK2r3UrhzR+vTQqqaEZeW9L4CsZutRI1+MUxteRSjA
 aLsoUfLTq+NEuLHzog8bVMKb6Kvk5vi8tj2jovspGzhq4a8KMG488GBwB4UbFv4AdncX
 U/FXGrp2RdS49uOeMkzEiPBiwB+pJ9iLSYcGB5tITyUpuRTAqv6irpFHW/Uk3ebejpkg cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6yupdwbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 18:17:44 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234HKmR4006671;
        Mon, 4 Apr 2022 18:17:43 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6yupdwbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 18:17:43 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234IGv5X029328;
        Mon, 4 Apr 2022 18:17:42 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 3f6e49dpwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 18:17:42 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234IHfUZ56885616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 18:17:41 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C77DBAE066;
        Mon,  4 Apr 2022 18:17:41 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A601AE05F;
        Mon,  4 Apr 2022 18:17:39 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.125])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 18:17:38 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v5 2/9] vfio: tolerate migration protocol v1 uapi renames
Date:   Mon,  4 Apr 2022 14:17:19 -0400
Message-Id: <20220404181726.60291-3-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220404181726.60291-1-mjrosato@linux.ibm.com>
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ioOMX-iz1SKRc0VmjWgQFYq-AllvTkeB
X-Proofpoint-ORIG-GUID: SMEZkbRAUTN0t7GnLVn0VuL3BSnVpvN0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_06,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 phishscore=0 adultscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204040103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The v1 uapi is deprecated and will be replaced by v2 at some point;
this patch just tolerates the renaming of uapi fields to reflect
v1 / deprecated status.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/vfio/common.c    |  2 +-
 hw/vfio/migration.c | 19 +++++++++++--------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 080046e3f5..7b1e12fb69 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -380,7 +380,7 @@ static bool vfio_devices_all_running_and_saving(VFIOContainer *container)
                 return false;
             }
 
-            if ((migration->device_state & VFIO_DEVICE_STATE_SAVING) &&
+            if ((migration->device_state & VFIO_DEVICE_STATE_V1_SAVING) &&
                 (migration->device_state & VFIO_DEVICE_STATE_RUNNING)) {
                 continue;
             } else {
diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
index ff6b45de6b..e109cee551 100644
--- a/hw/vfio/migration.c
+++ b/hw/vfio/migration.c
@@ -432,7 +432,7 @@ static int vfio_save_setup(QEMUFile *f, void *opaque)
     }
 
     ret = vfio_migration_set_state(vbasedev, VFIO_DEVICE_STATE_MASK,
-                                   VFIO_DEVICE_STATE_SAVING);
+                                   VFIO_DEVICE_STATE_V1_SAVING);
     if (ret) {
         error_report("%s: Failed to set state SAVING", vbasedev->name);
         return ret;
@@ -532,7 +532,7 @@ static int vfio_save_complete_precopy(QEMUFile *f, void *opaque)
     int ret;
 
     ret = vfio_migration_set_state(vbasedev, ~VFIO_DEVICE_STATE_RUNNING,
-                                   VFIO_DEVICE_STATE_SAVING);
+                                   VFIO_DEVICE_STATE_V1_SAVING);
     if (ret) {
         error_report("%s: Failed to set state STOP and SAVING",
                      vbasedev->name);
@@ -569,7 +569,7 @@ static int vfio_save_complete_precopy(QEMUFile *f, void *opaque)
         return ret;
     }
 
-    ret = vfio_migration_set_state(vbasedev, ~VFIO_DEVICE_STATE_SAVING, 0);
+    ret = vfio_migration_set_state(vbasedev, ~VFIO_DEVICE_STATE_V1_SAVING, 0);
     if (ret) {
         error_report("%s: Failed to set state STOPPED", vbasedev->name);
         return ret;
@@ -730,7 +730,7 @@ static void vfio_vmstate_change(void *opaque, bool running, RunState state)
          * start saving data.
          */
         if (state == RUN_STATE_SAVE_VM) {
-            value = VFIO_DEVICE_STATE_SAVING;
+            value = VFIO_DEVICE_STATE_V1_SAVING;
         } else {
             value = 0;
         }
@@ -768,8 +768,9 @@ static void vfio_migration_state_notifier(Notifier *notifier, void *data)
     case MIGRATION_STATUS_FAILED:
         bytes_transferred = 0;
         ret = vfio_migration_set_state(vbasedev,
-                      ~(VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RESUMING),
-                      VFIO_DEVICE_STATE_RUNNING);
+                                       ~(VFIO_DEVICE_STATE_V1_SAVING |
+                                         VFIO_DEVICE_STATE_RESUMING),
+                                       VFIO_DEVICE_STATE_RUNNING);
         if (ret) {
             error_report("%s: Failed to set state RUNNING", vbasedev->name);
         }
@@ -864,8 +865,10 @@ int vfio_migration_probe(VFIODevice *vbasedev, Error **errp)
         goto add_blocker;
     }
 
-    ret = vfio_get_dev_region_info(vbasedev, VFIO_REGION_TYPE_MIGRATION,
-                                   VFIO_REGION_SUBTYPE_MIGRATION, &info);
+    ret = vfio_get_dev_region_info(vbasedev,
+                                   VFIO_REGION_TYPE_MIGRATION_DEPRECATED,
+                                   VFIO_REGION_SUBTYPE_MIGRATION_DEPRECATED,
+                                   &info);
     if (ret) {
         goto add_blocker;
     }
-- 
2.27.0


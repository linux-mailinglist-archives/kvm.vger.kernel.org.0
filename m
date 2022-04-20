Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87BAE508774
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 13:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378332AbiDTL5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 07:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377967AbiDTL52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 07:57:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4B13E5D8
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 04:54:42 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KBMcol002256;
        Wed, 20 Apr 2022 11:54:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dE1PLpyFPw/r+RAtALKG4CjUEDjg0riUjPhpN1pRopQ=;
 b=Oxeji9GFPhNKfIEGRwge9Lw2sXV8kqVE9Igbia/Ovse7Ifitr/X9Ysu1xAMigj8+GjXQ
 INp4+EvL5iqJ8a6jB3kuVRS45sk/iOpvELv/Ov+IUDdBEyi2WGkeMGpwZKZfzS7fzHOc
 GoGChP+Y06kkyG5y1xZ1wsybqZfYMfDhEYEmV39H3GyzQa5AFV+N8tQDhNYhQkHOjeQ2
 5pSvqsK1DrwJ0uUcdQEP+ZmPsNAkqpGXfW6jCvQxW1Rd0pohSlW5M0b4aI3Bu+EaweHC
 VgmqwIVj7fF3AMqRWMoSRshciGwKHfuQyEGbyvp/yiN+rP9RtrmdVZ032u5pBe2GGrOI +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg79xx4f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:37 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KBgw0n023425;
        Wed, 20 Apr 2022 11:54:37 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg79xx4ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:37 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KBrCUl020449;
        Wed, 20 Apr 2022 11:54:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3ffne94x1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KBfhDM14352818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 11:41:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 442B7AE045;
        Wed, 20 Apr 2022 11:54:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58F18AE058;
        Wed, 20 Apr 2022 11:54:30 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.58.217])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 11:54:30 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com
Subject: [PATCH v7 02/13] vfio: tolerate migration protocol v1 uapi renames
Date:   Wed, 20 Apr 2022 13:57:34 +0200
Message-Id: <20220420115745.13696-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220420115745.13696-1-pmorel@linux.ibm.com>
References: <20220420115745.13696-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _BLIR7wCjAIFT6y9keDIEXFpB2-0RHfN
X-Proofpoint-ORIG-GUID: ZCKwxgbCTOCbKmeH8b5utY1tNuFaj0IR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_02,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

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


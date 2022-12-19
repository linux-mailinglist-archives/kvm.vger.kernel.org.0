Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DED6508C1
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 09:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbiLSIr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 03:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbiLSIrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 03:47:43 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0E8A1BD
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 00:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671439662; x=1702975662;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I8tWVihrLhPjxASgfqdwDpZFSIfGHKH3+NkfCVEDmvQ=;
  b=kEk4QMLJ9ApKukZ8Iq8BtOJwE/RQkxOVe91+k1sClu0eSDADxvEt4+Te
   /OqDha+Hq1LGS7VXDJOVZS7c2AFGML28WBKUmTNvhRG2nEqJQKarRJGle
   bdq8BC4BUcI3aSLeRJTwHII7Fa60pAt4HhGy9csCfqYMtQmtPftfU23Jv
   tPyxA9M/um0BirC0ynwYUxyChx3ip4NPkbs8HsoortISv5MMzsCaLVNXB
   7ynsodEiM8+STMRR8gyNF17q6M0tKwOR6M6A3BdmScG4Jd/GC08y3z1z/
   yRuG3v8AD4uIaVnhSsxPG5OnxIuZU/Rh5FWlVa1aZEDT7JuTuocc/souF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="381528461"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="381528461"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 00:47:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="628233767"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="628233767"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 19 Dec 2022 00:47:41 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com
Subject: [RFC 05/12] kvm/vfio: Accept vfio device file from userspace
Date:   Mon, 19 Dec 2022 00:47:11 -0800
Message-Id: <20221219084718.9342-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221219084718.9342-1-yi.l.liu@intel.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This defines KVM_DEV_VFIO_FILE* and make alias with KVM_DEV_VFIO_GROUP*.
Old userspace uses KVM_DEV_VFIO_GROUP* works as well.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 Documentation/virt/kvm/devices/vfio.rst | 32 ++++++++++++-------------
 include/uapi/linux/kvm.h                | 23 +++++++++++++-----
 virt/kvm/vfio.c                         | 18 +++++++-------
 3 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vfio.rst b/Documentation/virt/kvm/devices/vfio.rst
index 2d20dc561069..ac4300ded398 100644
--- a/Documentation/virt/kvm/devices/vfio.rst
+++ b/Documentation/virt/kvm/devices/vfio.rst
@@ -9,23 +9,23 @@ Device types supported:
   - KVM_DEV_TYPE_VFIO
 
 Only one VFIO instance may be created per VM.  The created device
-tracks VFIO groups in use by the VM and features of those groups
-important to the correctness and acceleration of the VM.  As groups
-are enabled and disabled for use by the VM, KVM should be updated
-about their presence.  When registered with KVM, a reference to the
-VFIO-group is held by KVM.
-
-Groups:
-  KVM_DEV_VFIO_GROUP
-
-KVM_DEV_VFIO_GROUP attributes:
-  KVM_DEV_VFIO_GROUP_ADD: Add a VFIO group to VFIO-KVM device tracking
-	kvm_device_attr.addr points to an int32_t file descriptor
+tracks VFIO files (group or device) in use by the VM and features
+of those groups/devices important to the correctness and acceleration
+of the VM.  As groups/device are enabled and disabled for use by the
+VM, KVM should be updated about their presence.  When registered with
+KVM, a reference to the VFIO file is held by KVM.
+
+VFIO Files:
+  KVM_DEV_VFIO_FILE
+
+KVM_DEV_VFIO_FILE attributes:
+  KVM_DEV_VFIO_FILE_ADD: Add a VFIO file (group/device) to VFIO-KVM device
+	tracking kvm_device_attr.addr points to an int32_t file descriptor
+	for the VFIO file.
+  KVM_DEV_VFIO_FILE_DEL: Remove a VFIO file (group/device) from VFIO-KVM device
+	tracking kvm_device_attr.addr points to an int32_t file descriptor
 	for the VFIO group.
-  KVM_DEV_VFIO_GROUP_DEL: Remove a VFIO group from VFIO-KVM device tracking
-	kvm_device_attr.addr points to an int32_t file descriptor
-	for the VFIO group.
-  KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE: attaches a guest visible TCE table
+  KVM_DEV_VFIO_FILE_SET_SPAPR_TCE: attaches a guest visible TCE table
 	allocated by sPAPR KVM.
 	kvm_device_attr.addr points to a struct::
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0d5d4419139a..77bd6bb409d2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1398,15 +1398,26 @@ struct kvm_create_device {
 
 struct kvm_device_attr {
 	__u32	flags;		/* no flags currently defined */
-	__u32	group;		/* device-defined */
-	__u64	attr;		/* group-defined */
+	union {
+		__u32	group;
+		__u32	file;
+	}; /* device-defined */
+	__u64	attr;		/* VFIO-file-defined or group-defined */
 	__u64	addr;		/* userspace address of attr data */
 };
 
-#define  KVM_DEV_VFIO_GROUP			1
-#define   KVM_DEV_VFIO_GROUP_ADD			1
-#define   KVM_DEV_VFIO_GROUP_DEL			2
-#define   KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE		3
+#define  KVM_DEV_VFIO_FILE	1
+
+#define   KVM_DEV_VFIO_FILE_ADD			1
+#define   KVM_DEV_VFIO_FILE_DEL			2
+#define   KVM_DEV_VFIO_FILE_SET_SPAPR_TCE	3
+
+/* Group aliases are for compile time uapi compatibility */
+#define  KVM_DEV_VFIO_GROUP	KVM_DEV_VFIO_FILE
+
+#define   KVM_DEV_VFIO_GROUP_ADD	KVM_DEV_VFIO_FILE_ADD
+#define   KVM_DEV_VFIO_GROUP_DEL	KVM_DEV_VFIO_FILE_DEL
+#define   KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE	KVM_DEV_VFIO_FILE_SET_SPAPR_TCE
 
 enum kvm_device_type {
 	KVM_DEV_TYPE_FSL_MPIC_20	= 1,
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 0f54b9d308d7..f41705d509d2 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -286,18 +286,18 @@ static int kvm_vfio_set_file(struct kvm_device *dev, long attr,
 	int32_t fd;
 
 	switch (attr) {
-	case KVM_DEV_VFIO_GROUP_ADD:
+	case KVM_DEV_VFIO_FILE_ADD:
 		if (get_user(fd, argp))
 			return -EFAULT;
 		return kvm_vfio_file_add(dev, fd);
 
-	case KVM_DEV_VFIO_GROUP_DEL:
+	case KVM_DEV_VFIO_FILE_DEL:
 		if (get_user(fd, argp))
 			return -EFAULT;
 		return kvm_vfio_file_del(dev, fd);
 
 #ifdef CONFIG_SPAPR_TCE_IOMMU
-	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
+	case KVM_DEV_VFIO_FILE_SET_SPAPR_TCE:
 		return kvm_vfio_file_set_spapr_tce(dev, arg);
 #endif
 	}
@@ -309,7 +309,7 @@ static int kvm_vfio_set_attr(struct kvm_device *dev,
 			     struct kvm_device_attr *attr)
 {
 	switch (attr->group) {
-	case KVM_DEV_VFIO_GROUP:
+	case KVM_DEV_VFIO_FILE:
 		return kvm_vfio_set_file(dev, attr->attr,
 					 u64_to_user_ptr(attr->addr));
 	}
@@ -320,13 +320,13 @@ static int kvm_vfio_set_attr(struct kvm_device *dev,
 static int kvm_vfio_has_attr(struct kvm_device *dev,
 			     struct kvm_device_attr *attr)
 {
-	switch (attr->group) {
-	case KVM_DEV_VFIO_GROUP:
+	switch (attr->file) {
+	case KVM_DEV_VFIO_FILE:
 		switch (attr->attr) {
-		case KVM_DEV_VFIO_GROUP_ADD:
-		case KVM_DEV_VFIO_GROUP_DEL:
+		case KVM_DEV_VFIO_FILE_ADD:
+		case KVM_DEV_VFIO_FILE_DEL:
 #ifdef CONFIG_SPAPR_TCE_IOMMU
-		case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
+		case KVM_DEV_VFIO_FILE_SET_SPAPR_TCE:
 #endif
 			return 0;
 		}
-- 
2.34.1


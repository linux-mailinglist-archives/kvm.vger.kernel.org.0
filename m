Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487D169D9BA
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 04:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbjBUDtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 22:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbjBUDtL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 22:49:11 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE62B1BE9;
        Mon, 20 Feb 2023 19:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676951337; x=1708487337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y8DPY5S868JEbRpn1B/fXQEqfkIAhwKvbhC9dKwz6lw=;
  b=YjVyHMQn6qvTA85FMzkftnR6iO8F10oGAdIvRKkt++s/Zt59u7izTG7v
   721n+I7LSuJRoG1pv9MNlp0Yyo+5N/ARWnVs5T8xH5zLGSrXz8o7LvZkR
   L21cGf26PLTJoKI/C/py8gjckT5kC8cMFo+wLG+4FIVHqaeWpz2U/50Eb
   GHuKL9MnpEtM3uJhsryhDJFj21jE1QPinmSZUmqSpvKKBGhdPF+iG7x7O
   rcbVWwiPXwrX9TPd95OJziVZ4hF9gCeCFTWeo348Pq0YRuN8JIx51+1jm
   hIb5k+ioF4e0m5/jXSOaqE85Dqkrhs568oLpx0tr1MgYEoXq/O/53pATB
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="397218423"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="397218423"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 19:48:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="664822157"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="664822157"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 20 Feb 2023 19:48:17 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        yan.y.zhao@intel.com, xudong.hao@intel.com, terrence.xu@intel.com
Subject: [PATCH v4 05/19] kvm/vfio: Accept vfio device file from userspace
Date:   Mon, 20 Feb 2023 19:47:58 -0800
Message-Id: <20230221034812.138051-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230221034812.138051-1-yi.l.liu@intel.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
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
 Documentation/virt/kvm/devices/vfio.rst | 50 ++++++++++++++++---------
 include/uapi/linux/kvm.h                | 16 ++++++--
 virt/kvm/vfio.c                         | 16 ++++----
 3 files changed, 53 insertions(+), 29 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vfio.rst b/Documentation/virt/kvm/devices/vfio.rst
index 5722e283f1b5..50bf76fc24e5 100644
--- a/Documentation/virt/kvm/devices/vfio.rst
+++ b/Documentation/virt/kvm/devices/vfio.rst
@@ -9,24 +9,37 @@ Device types supported:
   - KVM_DEV_TYPE_VFIO
 
 Only one VFIO instance may be created per VM.  The created device
-tracks VFIO groups in use by the VM and features of those groups
-important to the correctness and acceleration of the VM.  As groups
-are enabled and disabled for use by the VM, KVM should be updated
-about their presence.  When registered with KVM, a reference to the
-VFIO-group is held by KVM.
+tracks VFIO files (group or device) in use by the VM and features
+of those groups/devices important to the correctness and acceleration
+of the VM.  As groups/devices are enabled and disabled for use by the
+VM, KVM should be updated about their presence.  When registered with
+KVM, a reference to the VFIO file is held by KVM.
 
 Groups:
-  KVM_DEV_VFIO_GROUP
-
-KVM_DEV_VFIO_GROUP attributes:
-  KVM_DEV_VFIO_GROUP_ADD: Add a VFIO group to VFIO-KVM device tracking
-	kvm_device_attr.addr points to an int32_t file descriptor
-	for the VFIO group.
-  KVM_DEV_VFIO_GROUP_DEL: Remove a VFIO group from VFIO-KVM device tracking
-	kvm_device_attr.addr points to an int32_t file descriptor
-	for the VFIO group.
-  KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE: attaches a guest visible TCE table
+  KVM_DEV_VFIO_FILE
+	alias: KVM_DEV_VFIO_GROUP
+
+KVM_DEV_VFIO_FILE attributes:
+  KVM_DEV_VFIO_FILE_ADD: Add a VFIO file (group/device) to VFIO-KVM device
+	tracking
+
+	alias: KVM_DEV_VFIO_GROUP_ADD
+
+	kvm_device_attr.addr points to an int32_t file descriptor for the
+	VFIO file.
+  KVM_DEV_VFIO_FILE_DEL: Remove a VFIO file (group/device) from VFIO-KVM
+	device tracking
+
+	alias: KVM_DEV_VFIO_GROUP_DEL
+
+	kvm_device_attr.addr points to an int32_t file descriptor for the
+	VFIO file.
+
+  KVM_DEV_VFIO_FILE_SET_SPAPR_TCE: attaches a guest visible TCE table
 	allocated by sPAPR KVM.
+
+	alias: KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE
+
 	kvm_device_attr.addr points to a struct::
 
 		struct kvm_vfio_spapr_tce {
@@ -40,7 +53,10 @@ KVM_DEV_VFIO_GROUP attributes:
 	- @tablefd is a file descriptor for a TCE table allocated via
 	  KVM_CREATE_SPAPR_TCE.
 
+	only accepts vfio group file as SPAPR has no iommufd support
+
 ::
 
-The GROUP_ADD operation above should be invoked before vfio_device's
-open_device op which is called in the ioctl VFIO_GROUP_GET_DEVICE_FD.
+The FILE/GROUP_ADD operation above should be invoked before vfio_device's
+open_device op which is called in the ioctl VFIO_GROUP_GET_DEVICE_FD
+or VFIO_DEVICE_BIND_IOMMUFD.
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 55155e262646..484a8133bc69 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1401,10 +1401,18 @@ struct kvm_device_attr {
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
+/* KVM_DEV_VFIO_GROUP aliases are for compile time uapi compatibility */
+#define  KVM_DEV_VFIO_GROUP	KVM_DEV_VFIO_FILE
+
+#define   KVM_DEV_VFIO_GROUP_ADD	KVM_DEV_VFIO_FILE_ADD
+#define   KVM_DEV_VFIO_GROUP_DEL	KVM_DEV_VFIO_FILE_DEL
+#define   KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE	KVM_DEV_VFIO_FILE_SET_SPAPR_TCE
 
 enum kvm_device_type {
 	KVM_DEV_TYPE_FSL_MPIC_20	= 1,
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 857d6ba349e1..d869913baafd 100644
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
@@ -321,12 +321,12 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
 			     struct kvm_device_attr *attr)
 {
 	switch (attr->group) {
-	case KVM_DEV_VFIO_GROUP:
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


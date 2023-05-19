Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8982E70A1F8
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 23:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbjESVsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 17:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbjESVsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 17:48:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB6710F
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 14:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684532882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=C9UIYQ0roparrpAkenEQbXkxd1bQCXoJbjl1UvbMjDQ=;
        b=Sqg3sF3eSCbk8oJD7PyVRqwieo9UX9WKMQIlY72jOeBT3Z7etXME2DePby8flFVq0wHBV7
        HxGjJ5FkkXF1wpU2fw+5GyJP2l4PnbEacw1x73oubE2TS0p+aRwSyQZrDhlP4pTU+ABqpI
        BYGMaw/WJEyBdbDxKpngd+SO7ZUoWLk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-K8DmDakeOL-F9_jzromLRQ-1; Fri, 19 May 2023 17:48:01 -0400
X-MC-Unique: K8DmDakeOL-F9_jzromLRQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA0CA38035AC;
        Fri, 19 May 2023 21:48:00 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.10.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64B3840D1B61;
        Fri, 19 May 2023 21:48:00 +0000 (UTC)
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>, robin@streamhpc.com
Subject: [PATCH] vfio/pci-core: Add capability for AtomicOp copleter support
Date:   Fri, 19 May 2023 15:47:48 -0600
Message-Id: <20230519214748.402003-1-alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test and enable PCIe AtomicOp completer support of various widths and
report via device-info capability to userspace.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 38 ++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h        | 14 ++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a5ab416cf476..a21ab726c9d4 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -882,6 +882,37 @@ int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_register_dev_region);
 
+static int vfio_pci_info_atomic_cap(struct vfio_pci_core_device *vdev,
+				    struct vfio_info_cap *caps)
+{
+	struct vfio_device_info_cap_pci_atomic_comp cap = {
+		.header.id = VFIO_DEVICE_INFO_CAP_PCI_ATOMIC_COMP,
+		.header.version = 1
+	};
+	struct pci_dev *pdev = pci_physfn(vdev->pdev);
+	u32 devcap2;
+
+	pcie_capability_read_dword(pdev, PCI_EXP_DEVCAP2, &devcap2);
+
+	if ((devcap2 & PCI_EXP_DEVCAP2_ATOMIC_COMP32) &&
+	    !pci_enable_atomic_ops_to_root(pdev, PCI_EXP_DEVCAP2_ATOMIC_COMP32))
+		cap.flags |= VFIO_PCI_ATOMIC_COMP32;
+
+	if ((devcap2 & PCI_EXP_DEVCAP2_ATOMIC_COMP64) &&
+	    !pci_enable_atomic_ops_to_root(pdev, PCI_EXP_DEVCAP2_ATOMIC_COMP64))
+		cap.flags |= VFIO_PCI_ATOMIC_COMP64;
+
+	if ((devcap2 & PCI_EXP_DEVCAP2_ATOMIC_COMP128) &&
+	    !pci_enable_atomic_ops_to_root(pdev,
+					   PCI_EXP_DEVCAP2_ATOMIC_COMP128))
+		cap.flags |= VFIO_PCI_ATOMIC_COMP128;
+
+	if (!cap.flags)
+		return -ENODEV;
+
+	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
+}
+
 static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
 				   struct vfio_device_info __user *arg)
 {
@@ -920,6 +951,13 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
 		return ret;
 	}
 
+	ret = vfio_pci_info_atomic_cap(vdev, &caps);
+	if (ret && ret != -ENODEV) {
+		pci_warn(vdev->pdev,
+			 "Failed to setup AtomicOps info capability\n");
+		return ret;
+	}
+
 	if (caps.size) {
 		info.flags |= VFIO_DEVICE_FLAGS_CAPS;
 		if (info.argsz < sizeof(info) + caps.size) {
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0552e8dcf0cb..07988d62b33c 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -240,6 +240,20 @@ struct vfio_device_info {
 #define VFIO_DEVICE_INFO_CAP_ZPCI_UTIL		3
 #define VFIO_DEVICE_INFO_CAP_ZPCI_PFIP		4
 
+/*
+ * The following VFIO_DEVICE_INFO capability reports support for PCIe AtomicOp
+ * completion to the root bus with supported widths provided via flags.
+ */
+#define VFIO_DEVICE_INFO_CAP_PCI_ATOMIC_COMP	5
+struct vfio_device_info_cap_pci_atomic_comp {
+	struct vfio_info_cap_header header;
+	__u32 flags;
+#define VFIO_PCI_ATOMIC_COMP32	(1 << 0)
+#define VFIO_PCI_ATOMIC_COMP64	(1 << 1)
+#define VFIO_PCI_ATOMIC_COMP128	(1 << 2)
+	__u32 reserved;
+};
+
 /**
  * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
  *				       struct vfio_region_info)
-- 
2.39.2


Return-Path: <kvm+bounces-44463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E87B8A9DD41
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 23:28:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3893E1741E0
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 21:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 112F41FA859;
	Sat, 26 Apr 2025 21:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WmRvBFHS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20961DF963;
	Sat, 26 Apr 2025 21:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745702903; cv=none; b=NhuXlN7mwKCtzecaN50Gi5kwJ8JpvJobsH0kP3l/Dixi0di+LFWEeMs1emzUp2cRGHTGbZCGRtchHfGXaSfLfIryoEn9en6wtstrSY0PtdEMPLeVRLZZ9udO59UCzktVxiOC/WECUuNCqGfdQShS2vfEav0C6EYV94SN0U5GBpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745702903; c=relaxed/simple;
	bh=KS6IxRQOo53L6l7MBOMdtjRUdNTRenmkZtpkH+eCvT4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DaIk3gUwfbax8N+z0Yupk8UXKIoh95crjPawjsyY2iBO6NTqggSnXFE6UAvJB7+Debs2pEtDiEVXzNV2H/QNLwfGkarlGvyrAgJG9qP3Ut5REbwvCd/THxtKtysZRf7skNWlp3UuIs9akdFw7Bn9E56UXSoptf7ezFc9g09Te8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WmRvBFHS; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d589ed2b47so10012215ab.2;
        Sat, 26 Apr 2025 14:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745702900; x=1746307700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cYvI4jQPOlvT7mZsy2WDSn1H0pl95kjlr5q63pD49S8=;
        b=WmRvBFHSRun0WpXX8qc5BGkDk/kjLbTxWeVKVbjvxpOFw5I4nmrpW0QwmeXT4GXgBf
         RCUBLlyEZYx1j48ieV+TSMFXdtljOKahSnC3R0z0LHIQ2PP6ZiOxbS/RPXE3+N8gDrcx
         JXWAIxfpjE0JobGAKVIdz1ZaGlbvK0YW10pfyByg8ZebOiUEX6pngGIsfVSkyDs7EBMz
         lAXirkAXREZTasex+r7kYzosVREMdd8CSQzigxfYu0FvN3dC8t41TBr4A6Eg2LMlkHsA
         9HfszZkkkD7a/y68k7ncLYQOkVx4rjy8GX9NjF0EgPRIhUp3S2pCp5li0CFaDmXvHgN/
         iSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745702900; x=1746307700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cYvI4jQPOlvT7mZsy2WDSn1H0pl95kjlr5q63pD49S8=;
        b=cm1xeCJE6uqcgBvcAWBJUCO3YvA5rqe2u28aGkQCjeRSNQ4kVUIpP3zn5W5T6d0I76
         PRq//lCHrS9uncg9GnlHOcdZdfgqkpDqZd75YCBsTMzW3kW7IxbZm8f3czFyG9WbE4Dg
         0xH5E3NleIlaaFB3ZwEX+Me48c8TON/G4wY8sCJI+vkjXFSMUsfcyE+t3YRxhxS2AEyV
         Opxs0VoT9uITnpvxgJq7dyklJb1C1V1LxVGm1Po38YZWv0sub4Jz0j1JX5onwIZ+TcBy
         sWp+3ZOascpL9erXzzmtWzjl6TVQhP7yhdQ1kuYK6NP9nLXYztrUvqC9zGDMctwBImUi
         81lQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbNYSolQMK7bSL1m7y1HuCkO0fK1JJBdtAVbmOe2FPl0iEG7tsaMtGKDcSm0ICud4si6LV1w==@vger.kernel.org, AJvYcCW9GbAKCv5b1x7tehVtaEfP1Qe80RZjLChHE0sQdMP6qLgPJfpW0WGgDiIqekfOSaEM1pamwflFq7rzq6E3@vger.kernel.org
X-Gm-Message-State: AOJu0YwSjwiNbgyUJCjjhcpAslOJOxlUw6VPDMqIOsmty/WCPDjIaKaC
	dMmG0D9OmIUa/XFcSjjn/B4HkN4dUFwUCIi0tcuNCrRVyJcIYIfIi8VJZ3mh
X-Gm-Gg: ASbGnctJisDfLeLCQY+kiuKQUZ3FByQLNG8C54QY+57hqwU3QwuSQkKHgk148ldLkeV
	J73MR0FLF0hr//JTEV8yeYyoexm3acBzszyW2+8AH2oX77Aon5MwV6ucH8Lh4iPB50evSX1XZa9
	qIV2o+U9Vc4I/1c3RHkLf7PpiKd0Uh+FLiP34m+6B0bjc07Q4CbSoT3DNLOXZDoksQLQ0m9hpaD
	B1dH1S7xmPhuvnsnNsVzU7XRX75RgOMWRS7F4/iKAXpjPCpZf5Q9L/x3rIUzxHCcqjidFQzx1rf
	wWt+zgZnWzADNsB9zab0prKwQ4Znu589SnZut1ejRJrm3+zb/3D+1R6ILSbVDiqFd5EqxgtC6J9
	1ZobsGnxoZGtBBVt+s5FKZJPCluSlyHBp/onb8vZ1izkvhdzu
X-Google-Smtp-Source: AGHT+IECLxryZVKrPnvFtvzexD7loHDqTcwBsRIfhNKLF5nKIC/s1ftfJKlrS9cIQohTFPwQ8u9izA==
X-Received: by 2002:a05:6e02:180f:b0:3d8:2023:d048 with SMTP id e9e14a558f8ab-3d93b615afemr73072015ab.22.1745702900572;
        Sat, 26 Apr 2025 14:28:20 -0700 (PDT)
Received: from master.chath-253561.iommu-security-pg0.wisc.cloudlab.us (sm220u-10s10539.wisc.cloudlab.us. [128.105.146.46])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f824ba34c1sm1454482173.126.2025.04.26.14.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 14:28:20 -0700 (PDT)
From: Chathura Rajapaksha <chathura.abeyrathne.lk@gmail.com>
X-Google-Original-From: Chathura Rajapaksha <chath@bu.edu>
To: kvm@vger.kernel.org
Cc: Chathura Rajapaksha <chath@bu.edu>,
	William Wang <xwill@bu.edu>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	Xin Zeng <xin.zeng@intel.com>,
	Yahui Cao <yahui.cao@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Dongdong Zhang <zhangdongdong@eswincomputing.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Avihai Horon <avihaih@nvidia.com>,
	linux-kernel@vger.kernel.org,
	audit@vger.kernel.org
Subject: [RFC PATCH 1/2] block accesses to unassigned PCI config regions
Date: Sat, 26 Apr 2025 21:22:48 +0000
Message-Id: <20250426212253.40473-2-chath@bu.edu>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250426212253.40473-1-chath@bu.edu>
References: <20250426212253.40473-1-chath@bu.edu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some PCIe devices trigger PCI bus errors when accesses are made to
unassigned regions within their PCI configuration space. On certain
platforms, this can lead to host system hangs or reboots.

The current vfio-pci driver allows guests to access unassigned regions
in the PCI configuration space. Therefore, when such a device is passed
through to a guest, the guest can induce a host system hang or reboot
through crafted configuration space accesses, posing a threat to
system availability.

This patch introduces support for blocking guest accesses to unassigned
PCI configuration space, and the ability to bypass this access control
for specific devices. The patch introduces three module parameters:

   block_pci_unassigned_write:
   Blocks write accesses to unassigned config space regions.

   block_pci_unassigned_read:
   Blocks read accesses to unassigned config space regions.

   uaccess_allow_ids:
   Specifies the devices for which the above access control is bypassed.
   The value is a comma-separated list of device IDs in
   <vendor_id>:<device_id> format.

   Example usage:
   To block guest write accesses to unassigned config regions for all
   passed through devices except for the device with vendor ID 0x1234 and
   device ID 0x5678:

   block_pci_unassigned_write=1 uaccess_allow_ids=1234:5678

Co-developed by: William Wang <xwill@bu.edu>
Signed-off-by: William Wang <xwill@bu.edu>
Signed-off-by: Chathura Rajapaksha <chath@bu.edu>
---
 drivers/vfio/pci/vfio_pci_config.c | 122 ++++++++++++++++++++++++++++-
 1 file changed, 121 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 8f02f236b5b4..cb4d11aa5598 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -120,6 +120,106 @@ struct perm_bits {
 #define	NO_WRITE	0
 #define	ALL_WRITE	0xFFFFFFFFU
 
+static bool block_pci_unassigned_write;
+module_param(block_pci_unassigned_write, bool, 0644);
+MODULE_PARM_DESC(block_pci_unassigned_write,
+		 "Block write accesses to unassigned PCI config regions.");
+
+static bool block_pci_unassigned_read;
+module_param(block_pci_unassigned_read, bool, 0644);
+MODULE_PARM_DESC(block_pci_unassigned_read,
+		 "Block read accesses from unassigned PCI config regions.");
+
+static char *uaccess_allow_ids;
+module_param(uaccess_allow_ids, charp, 0444);
+MODULE_PARM_DESC(uaccess_allow_ids, "PCI IDs to allow access to unassigned PCI config regions, format is \"vendor:device\" and multiple comma separated entries can be specified");
+
+static LIST_HEAD(allowed_device_ids);
+static DEFINE_SPINLOCK(device_ids_lock);
+
+struct uaccess_device_id {
+	struct list_head slot_list;
+	unsigned short vendor;
+	unsigned short device;
+};
+
+static void pci_uaccess_add_device(struct uaccess_device_id *new,
+				   int vendor, int device)
+{
+	struct uaccess_device_id *pci_dev_id;
+	unsigned long flags;
+	int found = 0;
+
+	spin_lock_irqsave(&device_ids_lock, flags);
+
+	list_for_each_entry(pci_dev_id, &allowed_device_ids, slot_list) {
+		if (pci_dev_id->vendor == vendor &&
+		    pci_dev_id->device == device) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found) {
+		new->vendor = vendor;
+		new->device = device;
+		list_add_tail(&new->slot_list, &allowed_device_ids);
+	}
+
+	spin_unlock_irqrestore(&device_ids_lock, flags);
+
+	if (found)
+		kfree(new);
+}
+
+static bool pci_uaccess_lookup(struct pci_dev *dev)
+{
+	struct uaccess_device_id *pdev_id;
+	unsigned long flags;
+	bool found = false;
+
+	spin_lock_irqsave(&device_ids_lock, flags);
+	list_for_each_entry(pdev_id, &allowed_device_ids, slot_list) {
+		if (pdev_id->vendor == dev->vendor &&
+		    pdev_id->device == dev->device) {
+			found = true;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&device_ids_lock, flags);
+
+	return found;
+}
+
+static int __init pci_uaccess_init(void)
+{
+	char *p, *id;
+	int fields;
+	int vendor, device;
+	struct uaccess_device_id *pci_dev_id;
+
+	/* add ids specified in the module parameter */
+	p = uaccess_allow_ids;
+	while ((id = strsep(&p, ","))) {
+		if (!strlen(id))
+			continue;
+
+		fields = sscanf(id, "%x:%x", &vendor, &device);
+
+		if (fields != 2) {
+			pr_warn("Invalid id string \"%s\"\n", id);
+			continue;
+		}
+
+		pci_dev_id = kmalloc(sizeof(*pci_dev_id), GFP_KERNEL);
+		if (!pci_dev_id)
+			return -ENOMEM;
+
+		pci_uaccess_add_device(pci_dev_id, vendor, device);
+	}
+	return 0;
+}
+
 static int vfio_user_config_read(struct pci_dev *pdev, int offset,
 				 __le32 *val, int count)
 {
@@ -335,6 +435,18 @@ static struct perm_bits unassigned_perms = {
 	.writefn = vfio_raw_config_write
 };
 
+/*
+ * Read/write access to PCI unassigned config regions can be blocked
+ * using the block_pci_unassigned_read and block_pci_unassigned_write
+ * module parameters. The uaccess_allow_ids module parameter can be used
+ * to whitelist devices (i.e., bypass the block) when either of the
+ * above parameters is specified.
+ */
+static struct perm_bits block_unassigned_perms = {
+	.readfn = NULL,
+	.writefn = NULL
+};
+
 static struct perm_bits virt_perms = {
 	.readfn = vfio_virt_config_read,
 	.writefn = vfio_virt_config_write
@@ -1108,6 +1220,9 @@ int __init vfio_pci_init_perm_bits(void)
 	ecap_perms[PCI_EXT_CAP_ID_VNDR].writefn = vfio_raw_config_write;
 	ecap_perms[PCI_EXT_CAP_ID_DVSEC].writefn = vfio_raw_config_write;
 
+	/* Device list allowed to access unassigned PCI regions */
+	ret |= pci_uaccess_init();
+
 	if (ret)
 		vfio_pci_uninit_perm_bits();
 
@@ -1896,7 +2011,12 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
 	cap_id = vdev->pci_config_map[*ppos];
 
 	if (cap_id == PCI_CAP_ID_INVALID) {
-		perm = &unassigned_perms;
+		if (((iswrite && block_pci_unassigned_write) ||
+		     (!iswrite && block_pci_unassigned_read)) &&
+		    !pci_uaccess_lookup(pdev))
+			perm = &block_unassigned_perms;
+		else
+			perm = &unassigned_perms;
 		cap_start = *ppos;
 	} else if (cap_id == PCI_CAP_ID_INVALID_VIRT) {
 		perm = &virt_perms;
-- 
2.34.1



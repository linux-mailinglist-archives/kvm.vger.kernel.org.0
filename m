Return-Path: <kvm+bounces-44464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 44FB5A9DD43
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 23:28:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71614189B56D
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 21:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672341FAC4E;
	Sat, 26 Apr 2025 21:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C1KLpmg9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051D21F5619;
	Sat, 26 Apr 2025 21:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745702924; cv=none; b=ZxsMThBlx+NzUk6ApfenVs2TRgMZM9W4Wov0cpYAIhDFqBpeuLoo8VPkWBTFnJ0dGwyeV6CGwMqBBKbt4Z/R6ZtijoTnLFQ1mT2hw+7/FpbqY8P5xv+EUaYtHMs0DJ3bSP+/H+W6oRyo5s5xvRhC9i3S1l39pAOq4hbuz4sbus0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745702924; c=relaxed/simple;
	bh=4qDv12GpymzV9cqm+5wc+FH3p/oXtI26viWEferrXSk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aY5DEDVadHqnRcNedPTS8sj7sG/FAjc4uTq9JQiJgOG77TAgx7VAtGrP25QcJpntJLEf1/hRIQ8cVA0204JMirntkwwH3YOZimngivo+bW4PeBRO4s7XKp1kBq54WfhkW7QYK/KuQ1KceTcz/jhzuHVhnxxjTiKMguXFDRSWibc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C1KLpmg9; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d813c1c39eso32089405ab.0;
        Sat, 26 Apr 2025 14:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745702922; x=1746307722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=in3Jc9pC1jNw19VgvSAZdkrPc3LvG10mRUdoc1WL8qI=;
        b=C1KLpmg9kXxweCLjSFkM0u7RuqaZ+IO+NSl/DmdWrNlYXU53kp6lxlmhP2CJSQHbi2
         FpbTnBTpHC1k5xUxJkvoC7h1R0akrkLTkFgVNnFs2HgL0sFQNNayxXbJx7schJAHCarE
         XtmJmPaWsheEKXasasMog4AXWPljE8ypTIQNcU7qAUZbde1a43PVJ3TUPFIpHhAWqwRb
         9QMF5c3r3Q3XCc4YvUoqCZFoDSzpf83iNlQyxuYcOZ3VRf0OraEgVx8RX5wwHjXhvNVg
         0wDHCGHuZXwh3HHKt9tqsuBfq4ji7pnSef5jzfZXI+3YXHNqBj3qIDcZCHH21jzz8BAc
         5MOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745702922; x=1746307722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=in3Jc9pC1jNw19VgvSAZdkrPc3LvG10mRUdoc1WL8qI=;
        b=QyYX8rGCJTRz/LZZVzzZlCWgZhGHntJbR4Pn+HL1kWbJ1smlRJBDTNOotzRm5tOliO
         DiyTF+7MMYw0ZkV1VTOsiI3H6YVcyRu90taEXKBZRcRE8CpY6Yz29jI4r/R4eivDo36b
         WxVizVv+1aMPDwj+/irtX8h8NxIp5NwAaxwDlwwFi0yETb3yEgPPlwrnHRpH2ajwenqq
         0RvIBgmsfVhbtpuNLQYNf7v6aq3aoFhi5F5FEKffn4u1kNSuBl0cjSu6LXjdkXlEjfan
         bbYRUIfZAMlWp+T3VfILfaEAzgQBpXz+DQfD8oSsMat5sKMDTa1zQjf90ovmP0wuGmw1
         Ss4w==
X-Forwarded-Encrypted: i=1; AJvYcCXdNnn+sN2+kk26T/z/AJKVr1yxfbywRkh04F1igA24rjSMPCXqpmN/gdYGxfeOb+aW8EGrMg==@vger.kernel.org, AJvYcCXwPbZQ3/DhClp5N+BZoYlK58Wek1ZOyVMHLzZHgJMVqaVRjxC/S8n8XwDBHkAdLB7qiTbfUcK5SdSe5bLG@vger.kernel.org
X-Gm-Message-State: AOJu0YxPqgZ7rwxrzUuV27P6Eg0LdBBTHI9hA0+yjsEsDHdscZYU4EsM
	I5kxOIKypHRzBWiWs8TnjqBh49cguNyHC/OFQQ4Cwqk3AkmaRUq7po7ocC/s
X-Gm-Gg: ASbGncuMwB6o4NwQVW3hLQMFstLDaVSY1OKtKnjwrDxbCNWyzil8Q9CwqiravURdKMQ
	BjoPQ0uZSj/JqXnu7oDhRJFH5ZDOfP3rpCyJaRTczjCInUeK4d/4xx7bIyNdvaNlJl5Vexaz/7L
	E6oa258U6bTMIGEh7csFBPFs4dJh7V9c6IhTx8QRijuK8dvyE0C3+8jtm5byNk+C7pkM29IEaTk
	u3Ub3w5PfFBlXqwzrr0q3YSXSpV6lw57lB39evMT3bE/ous/AhVpNUJ+TRzKNCG2fIngHyX18zu
	jjnt6Eq6X112BMRma/w1bu+F7eCquiCockcemnMpRJkrhoPKCZoq8yrV2MFmOymQrbLYsDTEnao
	/tlR0OJLabV2Gks8pz9yvEpwVhFkVNn9NP5Gqjta9ywGHlTPB
X-Google-Smtp-Source: AGHT+IEBsK1Ip7zewga42fow2XKfAMr6aAeFPtYTe8aj7FYt3FMb9QHjB7XcLkdoWDnjTaV1NaN4+g==
X-Received: by 2002:a05:6e02:12e8:b0:3d0:1fc4:edf0 with SMTP id e9e14a558f8ab-3d942e12849mr42783385ab.15.1745702921897;
        Sat, 26 Apr 2025 14:28:41 -0700 (PDT)
Received: from master.chath-253561.iommu-security-pg0.wisc.cloudlab.us (sm220u-10s10539.wisc.cloudlab.us. [128.105.146.46])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f824ba34c1sm1454482173.126.2025.04.26.14.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 14:28:41 -0700 (PDT)
From: Chathura Rajapaksha <chathura.abeyrathne.lk@gmail.com>
X-Google-Original-From: Chathura Rajapaksha <chath@bu.edu>
To: kvm@vger.kernel.org
Cc: Chathura Rajapaksha <chath@bu.edu>,
	William Wang <xwill@bu.edu>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Xin Zeng <xin.zeng@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Yahui Cao <yahui.cao@intel.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Dongdong Zhang <zhangdongdong@eswincomputing.com>,
	Avihai Horon <avihaih@nvidia.com>,
	linux-kernel@vger.kernel.org,
	audit@vger.kernel.org
Subject: [RFC PATCH 2/2] audit accesses to unassigned PCI config regions
Date: Sat, 26 Apr 2025 21:22:49 +0000
Message-Id: <20250426212253.40473-3-chath@bu.edu>
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

This patch introduces auditing support for config space accesses to
unassigned regions. When enabled, this logs such accesses for all
passthrough devices. 
This feature is controlled via a new Kconfig option:

  CONFIG_VFIO_PCI_UNASSIGNED_ACCESS_AUDIT

A new audit event type, AUDIT_VFIO, has been introduced to support
this, allowing administrators to monitor and investigate suspicious
behavior by guests.

Co-developed by: William Wang <xwill@bu.edu>
Signed-off-by: William Wang <xwill@bu.edu>
Signed-off-by: Chathura Rajapaksha <chath@bu.edu>
---
 drivers/vfio/pci/Kconfig           | 12 ++++++++
 drivers/vfio/pci/vfio_pci_config.c | 46 ++++++++++++++++++++++++++++--
 include/uapi/linux/audit.h         |  1 +
 3 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index c3bcb6911c53..7f9f16262b90 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -42,6 +42,18 @@ config VFIO_PCI_IGD
 	  and LPC bridge config space.
 
 	  To enable Intel IGD assignment through vfio-pci, say Y.
+
+config VFIO_PCI_UNASSIGNED_ACCESS_AUDIT
+	bool "Audit accesses to unassigned PCI configuration regions"
+	depends on AUDIT && VFIO_PCI_CORE
+	help
+	  Some PCIe devices are known to cause bus errors when accessing
+	  unassigned PCI configuration space, potentially leading to host
+	  system hangs on certain platforms. When enabled, this option
+	  audits accesses to unassigned PCI configuration regions.
+
+	  If you don't know what to do here, say N.
+
 endif
 
 config VFIO_PCI_ZDEV_KVM
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index cb4d11aa5598..ddd10904d60f 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -25,6 +25,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/slab.h>
+#include <linux/audit.h>
 
 #include "vfio_pci_priv.h"
 
@@ -1980,6 +1981,37 @@ static size_t vfio_pci_cap_remaining_dword(struct vfio_pci_core_device *vdev,
 	return i;
 }
 
+enum vfio_audit {
+	VFIO_AUDIT_READ,
+	VFIO_AUDIT_WRITE,
+	VFIO_AUDIT_MAX,
+};
+
+static const char * const vfio_audit_str[VFIO_AUDIT_MAX] = {
+	[VFIO_AUDIT_READ]  = "READ",
+	[VFIO_AUDIT_WRITE] = "WRITE",
+};
+
+static void vfio_audit_access(const struct pci_dev *pdev,
+			      size_t count, loff_t *ppos, bool blocked, unsigned int op)
+{
+	struct audit_buffer *ab;
+
+	if (WARN_ON_ONCE(op >= VFIO_AUDIT_MAX))
+		return;
+	if (audit_enabled == AUDIT_OFF)
+		return;
+	ab = audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_VFIO);
+	if (unlikely(!ab))
+		return;
+	audit_log_format(ab,
+			 "device=%04x:%02x:%02x.%d access=%s offset=0x%llx size=%ld blocked=%u\n",
+			 pci_domain_nr(pdev->bus), pdev->bus->number,
+			 PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn),
+			 vfio_audit_str[op], *ppos, count, blocked);
+	audit_log_end(ab);
+}
+
 static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 				 size_t count, loff_t *ppos, bool iswrite)
 {
@@ -1989,6 +2021,7 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
 	int cap_start = 0, offset;
 	u8 cap_id;
 	ssize_t ret;
+	bool blocked;
 
 	if (*ppos < 0 || *ppos >= pdev->cfg_size ||
 	    *ppos + count > pdev->cfg_size)
@@ -2011,13 +2044,22 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
 	cap_id = vdev->pci_config_map[*ppos];
 
 	if (cap_id == PCI_CAP_ID_INVALID) {
-		if (((iswrite && block_pci_unassigned_write) ||
+		blocked = (((iswrite && block_pci_unassigned_write) ||
 		     (!iswrite && block_pci_unassigned_read)) &&
-		    !pci_uaccess_lookup(pdev))
+		    !pci_uaccess_lookup(pdev));
+		if (blocked)
 			perm = &block_unassigned_perms;
 		else
 			perm = &unassigned_perms;
 		cap_start = *ppos;
+		if (IS_ENABLED(CONFIG_VFIO_PCI_UNASSIGNED_ACCESS_AUDIT)) {
+			if (iswrite)
+				vfio_audit_access(pdev, count, ppos, blocked,
+						  VFIO_AUDIT_WRITE);
+			else
+				vfio_audit_access(pdev, count, ppos, blocked,
+						  VFIO_AUDIT_READ);
+		}
 	} else if (cap_id == PCI_CAP_ID_INVALID_VIRT) {
 		perm = &virt_perms;
 		cap_start = *ppos;
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 9a4ecc9f6dc5..c0aace7384f3 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -122,6 +122,7 @@
 #define AUDIT_OPENAT2		1337	/* Record showing openat2 how args */
 #define AUDIT_DM_CTRL		1338	/* Device Mapper target control */
 #define AUDIT_DM_EVENT		1339	/* Device Mapper events */
+#define AUDIT_VFIO		1340	/* VFIO events */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
-- 
2.34.1



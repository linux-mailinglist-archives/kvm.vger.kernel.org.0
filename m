Return-Path: <kvm+bounces-69610-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4D/PH/bQe2m0IgIAu9opvQ
	(envelope-from <kvm+bounces-69610-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:28:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D66A5B4AA7
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:28:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2641D3063B5D
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6BED35FF6D;
	Thu, 29 Jan 2026 21:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SKeL3oCc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B9235E548
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 21:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769721946; cv=none; b=AvvUNFbLeOFdVinPOr3HYhASxmYqSTlIPcy9Yu2ObB7TYVU41H3GHMLMx3qty+pv5MsgJtezKkECbpE2hjpyIJSnkwDW5PbRvGOlroMedCc74BFsFKgkUJHRLeRMd/QLDWbVymhnrM3EtnB8W7gz9q8G8jw+oH3d5NrvSDVQiSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769721946; c=relaxed/simple;
	bh=gIPoK/blCm65riWNC9nZMXYVtHTirbCm9IWwozauu7g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pXyESI3DFt0+qtA65F+qSj2lY7kMenk4yO8eh9PaH9Rhowp7YCujeFlEOAEafcbfunvXum2NvctwaZk4dn7qcpkm7KbSqA9kZ0RiXl47ISuX0HLO7UThEDQavMWUSZcgQ2ytdy7TICLJIQTJQV1aSEIgCxeQ4jegTHQiLta85a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SKeL3oCc; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a79164b686so15014985ad.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 13:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721944; x=1770326744; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2DumsOMxgbS0OIrY6jatWasSBK4J7y0u52rkK5iohgQ=;
        b=SKeL3oCcS3IiB61sYeJWkChzrZzJJDq/CISPenmYSjYZMH5XEGfUultWr4Aa/pAUum
         l4EKHtWjaigdMcCSSHMmQSLu1CoijEU/0Ni1rdG/iHkYjWiV05WNjD3AnFcUMTQ56mXd
         tR2jfrrIGOblh3qE5YF14bqqOywvMxIkDA48ywMSwMOoHo3ozD3RvGweJULJcyeN8yYx
         JwThM/hRcDCLkoRYbtO5GBjwKvME6guWADfqlL2rCXFUK7xvzG+bPaYukIBjO7koOTK4
         lxw+ELvUk/TK7/rh94UeNua2UNEDGqBwc+Kd0Iu7M9t9IuJGTfsf08tte5DYktBCILe4
         RzYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721944; x=1770326744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2DumsOMxgbS0OIrY6jatWasSBK4J7y0u52rkK5iohgQ=;
        b=Pi0yHY0hcMgZ2vTmekYCOQSPDlSFmHPSjATwO8n3BnpOb96cP+ahYlOiNcNjaX/boX
         xtuikydc/+a23/aGuO6ACJz8h36VAuPp4M8YCNx0rF69Ugpm9jTo1Vgs1UP/jUmqvBm9
         srGCZIU8bTFyxt6K2Rp+TO5N31aDn3WCke5XqgfeSZsPzjY/QLUfhXhFeclMHA+6jIJC
         6er8CqyqgQlE46GOb7z18/TzruWdGYRD4KxYn5jJD+ZvVUfHuze0FbeVKhr16t9RcMXw
         NoDQeJS4ViJ2YTsCMe9QU7gNH6FcHOPGg/oiJ6xmeBlqh3oaCplBcY7lzjnjf58dDHPl
         b3Zg==
X-Forwarded-Encrypted: i=1; AJvYcCVShyfjjBV+wwQ0MqtblPFCGVLvL1Q+aj6a8UxddGRJO1NOamHOJL1wScwCLyCk9O9r4Qo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvNmy/wTcUDqr3u2g5l5+WB1vAyrUrxy8G6MtW8B2oq2mv+pb9
	36ua2G72c+fmPezrcSkNiutIlEfZRYJSyFLY/GCKwyQGgaW7XiItM+JMlTtxS9D8WbB3CAkKUz7
	x4JKiN+EaeYr+fw==
X-Received: from plxd5.prod.google.com ([2002:a17:902:ef05:b0:2a7:5199:9c34])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:41c1:b0:2a0:d074:e9f4 with SMTP id d9443c01a7336-2a8d9a55422mr4900435ad.59.1769721944173;
 Thu, 29 Jan 2026 13:25:44 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:51 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-5-dmatlack@google.com>
Subject: [PATCH v2 04/22] vfio/pci: Register a file handler with Live Update Orchestrator
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69610-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D66A5B4AA7
X-Rspamd-Action: no action

From: Vipin Sharma <vipinsh@google.com>

Register a live update file handler for vfio-pci device files. Add stub
implementations of all required callbacks so that registration does not
fail (i.e. to avoid breaking git-bisect).

This file handler will be extended in subsequent commits to enable a
device bound to vfio-pci to run without interruption while the host is
going through a kexec Live Update.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 MAINTAINERS                            |  1 +
 drivers/vfio/pci/Makefile              |  1 +
 drivers/vfio/pci/vfio_pci.c            |  9 +++-
 drivers/vfio/pci/vfio_pci_liveupdate.c | 69 ++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h       | 14 ++++++
 include/linux/kho/abi/vfio_pci.h       | 28 +++++++++++
 6 files changed, 121 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
 create mode 100644 include/linux/kho/abi/vfio_pci.h

diff --git a/MAINTAINERS b/MAINTAINERS
index a671e3d4e8be..7d6cdecedb05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27520,6 +27520,7 @@ F:	Documentation/ABI/testing/debugfs-vfio
 F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
 F:	Documentation/driver-api/vfio.rst
 F:	drivers/vfio/
+F:	include/linux/kho/abi/vfio_pci.h
 F:	include/linux/vfio.h
 F:	include/linux/vfio_pci_core.h
 F:	include/uapi/linux/vfio.h
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index e0a0757dd1d2..23305ebc418b 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 
 vfio-pci-y := vfio_pci.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
+vfio-pci-$(CONFIG_LIVEUPDATE) += vfio_pci_liveupdate.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 
 obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 0c771064c0b8..19e88322af2c 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -258,6 +258,10 @@ static int __init vfio_pci_init(void)
 	int ret;
 	bool is_disable_vga = true;
 
+	ret = vfio_pci_liveupdate_init();
+	if (ret)
+		return ret;
+
 #ifdef CONFIG_VFIO_PCI_VGA
 	is_disable_vga = disable_vga;
 #endif
@@ -266,8 +270,10 @@ static int __init vfio_pci_init(void)
 
 	/* Register and scan for devices */
 	ret = pci_register_driver(&vfio_pci_driver);
-	if (ret)
+	if (ret) {
+		vfio_pci_liveupdate_cleanup();
 		return ret;
+	}
 
 	vfio_pci_fill_ids();
 
@@ -281,6 +287,7 @@ module_init(vfio_pci_init);
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
+	vfio_pci_liveupdate_cleanup();
 }
 module_exit(vfio_pci_cleanup);
 
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
new file mode 100644
index 000000000000..b84e63c0357b
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Vipin Sharma <vipinsh@google.com>
+ * David Matlack <dmatlack@google.com>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kho/abi/vfio_pci.h>
+#include <linux/liveupdate.h>
+#include <linux/errno.h>
+
+#include "vfio_pci_priv.h"
+
+static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *handler,
+					     struct file *file)
+{
+	return false;
+}
+
+static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
+{
+	return -EOPNOTSUPP;
+}
+
+static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
+{
+}
+
+static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
+{
+	return -EOPNOTSUPP;
+}
+
+static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
+{
+}
+
+static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
+	.can_preserve = vfio_pci_liveupdate_can_preserve,
+	.preserve = vfio_pci_liveupdate_preserve,
+	.unpreserve = vfio_pci_liveupdate_unpreserve,
+	.retrieve = vfio_pci_liveupdate_retrieve,
+	.finish = vfio_pci_liveupdate_finish,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
+	.ops = &vfio_pci_liveupdate_file_ops,
+	.compatible = VFIO_PCI_LUO_FH_COMPATIBLE,
+};
+
+int __init vfio_pci_liveupdate_init(void)
+{
+	if (!liveupdate_enabled())
+		return 0;
+
+	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
+}
+
+void vfio_pci_liveupdate_cleanup(void)
+{
+	if (!liveupdate_enabled())
+		return;
+
+	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
+}
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 27ac280f00b9..68966ec64e51 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -133,4 +133,18 @@ static inline void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev,
 }
 #endif
 
+#ifdef CONFIG_LIVEUPDATE
+int __init vfio_pci_liveupdate_init(void);
+void vfio_pci_liveupdate_cleanup(void);
+#else
+static inline int vfio_pci_liveupdate_init(void)
+{
+	return 0;
+}
+
+static inline void vfio_pci_liveupdate_cleanup(void)
+{
+}
+#endif /* CONFIG_LIVEUPDATE */
+
 #endif
diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
new file mode 100644
index 000000000000..37a845eed972
--- /dev/null
+++ b/include/linux/kho/abi/vfio_pci.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Vipin Sharma <vipinsh@google.com>
+ * David Matlack <dmatlack@google.com>
+ */
+
+#ifndef _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
+#define _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
+
+/**
+ * DOC: VFIO PCI Live Update ABI
+ *
+ * This header defines the ABI for preserving the state of a VFIO PCI device
+ * files across a kexec reboot using LUO.
+ *
+ * Device metadata is serialized into memory which is then handed to the next
+ * kernel via KHO.
+ *
+ * This interface is a contract. Any modification to any of the serialization
+ * structs defined here constitutes a breaking change. Such changes require
+ * incrementing the version number in the VFIO_PCI_LUO_FH_COMPATIBLE string.
+ */
+
+#define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v1"
+
+#endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
-- 
2.53.0.rc1.225.gd81095ad13-goog



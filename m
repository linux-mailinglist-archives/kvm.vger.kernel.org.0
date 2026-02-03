Return-Path: <kvm+bounces-70094-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qHNOMVhygmnBUgMAu9opvQ
	(envelope-from <kvm+bounces-70094-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:10:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 46D74DF194
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:10:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0B152305BA43
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BE3837419D;
	Tue,  3 Feb 2026 22:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ADowE2in"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99A936A00E
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 22:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770156594; cv=none; b=ahzvcHgd9eGt3eeGirkbZ3ZALVCdTsC/EiZEEVPz3FrIlZTbgM1hJvPCkETzePOLEGGJuj2ClUrNqP0s+jo07UQAL+Djp1ZfQ1seiYdOxJgD59Em0fD3RZDTnAxXjul2Y2gv46FLmboFJEZiBUme0FvHSA5t/0LUyAlSS3W8j14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770156594; c=relaxed/simple;
	bh=foh5Qr5xp1j1ngJ9RXLNwUIMLFRxhtltxVjGHDfXeik=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R0u6bKaO+ATvVxrCmTupwiU97kFQW1VBMyiEICMP4A6ATMgd6bLoy6KKBanGzMRV+VdP3bmC8B02sNKG0G/o8s8v3znyEEYVs4cj1/FVWUJqegznBIxqrUenXt5do+P4zB/6DafNNGnpW/t07FX2dx57GxfKiUbxNqDwBs7lyFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ADowE2in; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c67e92aad79so2204023a12.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 14:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770156592; x=1770761392; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5eZO2KOvcnbxY94D0A6rezfq3j04mJBbysFnKRo/qQM=;
        b=ADowE2inC7ehLoLlW+hPIeFIdcqhvtoQ7nrdxKitGd4OtCz02I0ip2Al/5hWAUMzVv
         MwcEOsliYO3jq/j8BjveNXE/KvlK107pbdTcjfSprax39FSndV9M/fZfggohzCrwzYiA
         vEyjGSTsrWg5pYF0mYuvDOA2fjJikdo2xcClIqkD4TMjDx7hrumesEmfyXyR47iq+V1q
         /SOLqx4+z6cWqeWhFr9QVuntoUBl0pNgbJo1K08OOHphO6bDHcyi3jAOzT/WDw7R2/NE
         uVV4BSC0QhCfTW7eK0VyXbuyJIm1t84HqKQ+VpDDt2O5Pg1cyOy5lHgRbImZVYTUZ5Ul
         MnYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770156592; x=1770761392;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5eZO2KOvcnbxY94D0A6rezfq3j04mJBbysFnKRo/qQM=;
        b=oPt8+B64up3ZgfaoAJJqdjnTzS4coLHpqlu9xff4+CXgYHYiQSjuGHGLgiI5VUkH29
         bnwgM/47uOgnTGBswmzdqyAoUXx2GQ3iPXR8vXt1RX5Oi6PHhaiI1dWzrfou8XN3k+jp
         KkKMh9j/+9LYpQo4zBTHknkL+v6EnMH09QP4JVHqnMv1Qh2n504XGIvKE3qlQu9q4+ej
         eUbTgxk4d35kGPMkXCfSw5aTW0WxNg3Z5nsx6ooOlF5gjGBDKepWM5AoAtK7rtKUC3RH
         mI4PdmV9GI/bYZ/GIGzGmwrKlmdIJamAgFnGlVm5PZL5KvzpHso7PMANkBl1FKlpG45m
         PJvA==
X-Forwarded-Encrypted: i=1; AJvYcCWMfEIYfmd4zSC8W9jxG5t0txCs9XLA2z9rVNS2BOWHeJyHhxagkG9inEX5xN6nYFjLNcA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzW5MfNho8fyKp5obSdtDji15KYkbxvW/MClT1BQWNj4Lsl4Efl
	+glvDohcplX9/dyXAbQqeOxBio6IBC+0eA/HkTTQ8bwu0NE2C3u/14sPhf+nlYMf82hjPFKFoOt
	XsvtudsMW1kT37g==
X-Received: from pfbdw20.prod.google.com ([2002:a05:6a00:3694:b0:822:4e8c:2c9e])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2d97:b0:81f:3fbd:ccf with SMTP id d2e1a72fcca58-8241c1e0874mr788987b3a.23.1770156592036;
 Tue, 03 Feb 2026 14:09:52 -0800 (PST)
Date: Tue,  3 Feb 2026 22:09:35 +0000
In-Reply-To: <20260203220948.2176157-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203220948.2176157-1-skhawaja@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203220948.2176157-2-skhawaja@google.com>
Subject: [PATCH 01/14] iommu: Implement IOMMU LU FLB callbacks
From: Samiullah Khawaja <skhawaja@google.com>
To: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Robin Murphy <robin.murphy@arm.com>, 
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>, 
	YiFei Zhu <zhuyifei@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70094-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[26];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 46D74DF194
X-Rspamd-Action: no action

Add liveupdate FLB for IOMMU state preservation. Use KHO preserve memory
alloc/free helper functions to allocate memory for the IOMMU LU FLB
object and the serialization structs for device, domain and iommu.

During retrieve, walk through the preserved objs nodes and restore each
folio. Also recreate the FLB obj.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 drivers/iommu/Kconfig         |  11 +++
 drivers/iommu/Makefile        |   1 +
 drivers/iommu/liveupdate.c    | 177 ++++++++++++++++++++++++++++++++++
 include/linux/iommu-lu.h      |  17 ++++
 include/linux/kho/abi/iommu.h | 119 +++++++++++++++++++++++
 5 files changed, 325 insertions(+)
 create mode 100644 drivers/iommu/liveupdate.c
 create mode 100644 include/linux/iommu-lu.h
 create mode 100644 include/linux/kho/abi/iommu.h

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index f86262b11416..fdcfbedee5ed 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -11,6 +11,17 @@ config IOMMUFD_DRIVER
 	bool
 	default n
 
+config IOMMU_LIVEUPDATE
+	bool "IOMMU live update state preservation support"
+	depends on LIVEUPDATE && IOMMUFD
+	help
+	  Enable support for preserving IOMMU state across a kexec live update.
+
+	  This allows devices managed by iommufd to maintain their DMA mappings
+	  during kexec base kernel update.
+
+	  If unsure, say N.
+
 menuconfig IOMMU_SUPPORT
 	bool "IOMMU Hardware Support"
 	depends on MMU
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 0275821f4ef9..b3715c5a6b97 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_IOMMU_IO_PGTABLE_ARMV7S) += io-pgtable-arm-v7s.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE_KUNIT_TEST) += io-pgtable-arm-selftests.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_DART) += io-pgtable-dart.o
+obj-$(CONFIG_IOMMU_LIVEUPDATE) += liveupdate.o
 obj-$(CONFIG_IOMMU_IOVA) += iova.o
 obj-$(CONFIG_OF_IOMMU)	+= of_iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o
diff --git a/drivers/iommu/liveupdate.c b/drivers/iommu/liveupdate.c
new file mode 100644
index 000000000000..6189ba32ff2c
--- /dev/null
+++ b/drivers/iommu/liveupdate.c
@@ -0,0 +1,177 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (C) 2025, Google LLC
+ * Author: Samiullah Khawaja <skhawaja@google.com>
+ */
+
+#define pr_fmt(fmt)    "iommu: liveupdate: " fmt
+
+#include <linux/kexec_handover.h>
+#include <linux/liveupdate.h>
+#include <linux/iommu-lu.h>
+#include <linux/iommu.h>
+#include <linux/errno.h>
+
+static void iommu_liveupdate_restore_objs(u64 next)
+{
+	struct iommu_objs_ser *objs;
+
+	while (next) {
+		BUG_ON(!kho_restore_folio(next));
+		objs = __va(next);
+		next = objs->next_objs;
+	}
+}
+
+static void iommu_liveupdate_free_objs(u64 next, bool incoming)
+{
+	struct iommu_objs_ser *objs;
+
+	while (next) {
+		objs = __va(next);
+		next = objs->next_objs;
+
+		if (!incoming)
+			kho_unpreserve_free(objs);
+		else
+			folio_put(virt_to_folio(objs));
+	}
+}
+
+static void iommu_liveupdate_flb_free(struct iommu_lu_flb_obj *obj)
+{
+	if (obj->iommu_domains)
+		iommu_liveupdate_free_objs(obj->ser->iommu_domains_phys, false);
+
+	if (obj->devices)
+		iommu_liveupdate_free_objs(obj->ser->devices_phys, false);
+
+	if (obj->iommus)
+		iommu_liveupdate_free_objs(obj->ser->iommus_phys, false);
+
+	kho_unpreserve_free(obj->ser);
+	kfree(obj);
+}
+
+static int iommu_liveupdate_flb_preserve(struct liveupdate_flb_op_args *argp)
+{
+	struct iommu_lu_flb_obj *obj;
+	struct iommu_lu_flb_ser *ser;
+	void *mem;
+
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+
+	mutex_init(&obj->lock);
+	mem = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(mem))
+		goto err_free;
+
+	ser = mem;
+	obj->ser = ser;
+
+	mem = kho_alloc_preserve(PAGE_SIZE);
+	if (IS_ERR(mem))
+		goto err_free;
+
+	obj->iommu_domains = mem;
+	ser->iommu_domains_phys = virt_to_phys(obj->iommu_domains);
+
+	mem = kho_alloc_preserve(PAGE_SIZE);
+	if (IS_ERR(mem))
+		goto err_free;
+
+	obj->devices = mem;
+	ser->devices_phys = virt_to_phys(obj->devices);
+
+	mem = kho_alloc_preserve(PAGE_SIZE);
+	if (IS_ERR(mem))
+		goto err_free;
+
+	obj->iommus = mem;
+	ser->iommus_phys = virt_to_phys(obj->iommus);
+
+	argp->obj = obj;
+	argp->data = virt_to_phys(ser);
+	return 0;
+
+err_free:
+	iommu_liveupdate_flb_free(obj);
+	return PTR_ERR(mem);
+}
+
+static void iommu_liveupdate_flb_unpreserve(struct liveupdate_flb_op_args *argp)
+{
+	iommu_liveupdate_flb_free(argp->obj);
+}
+
+static void iommu_liveupdate_flb_finish(struct liveupdate_flb_op_args *argp)
+{
+	struct iommu_lu_flb_obj *obj = argp->obj;
+
+	if (obj->iommu_domains)
+		iommu_liveupdate_free_objs(obj->ser->iommu_domains_phys, true);
+
+	if (obj->devices)
+		iommu_liveupdate_free_objs(obj->ser->devices_phys, true);
+
+	if (obj->iommus)
+		iommu_liveupdate_free_objs(obj->ser->iommus_phys, true);
+
+	folio_put(virt_to_folio(obj->ser));
+	kfree(obj);
+}
+
+static int iommu_liveupdate_flb_retrieve(struct liveupdate_flb_op_args *argp)
+{
+	struct iommu_lu_flb_obj *obj;
+	struct iommu_lu_flb_ser *ser;
+
+	obj = kzalloc(sizeof(*obj), GFP_ATOMIC);
+	if (!obj)
+		return -ENOMEM;
+
+	mutex_init(&obj->lock);
+	BUG_ON(!kho_restore_folio(argp->data));
+	ser = phys_to_virt(argp->data);
+	obj->ser = ser;
+
+	iommu_liveupdate_restore_objs(ser->iommu_domains_phys);
+	obj->iommu_domains = phys_to_virt(ser->iommu_domains_phys);
+
+	iommu_liveupdate_restore_objs(ser->devices_phys);
+	obj->devices = phys_to_virt(ser->devices_phys);
+
+	iommu_liveupdate_restore_objs(ser->iommus_phys);
+	obj->iommus = phys_to_virt(ser->iommus_phys);
+
+	argp->obj = obj;
+
+	return 0;
+}
+
+static struct liveupdate_flb_ops iommu_flb_ops = {
+	.preserve = iommu_liveupdate_flb_preserve,
+	.unpreserve = iommu_liveupdate_flb_unpreserve,
+	.finish = iommu_liveupdate_flb_finish,
+	.retrieve = iommu_liveupdate_flb_retrieve,
+};
+
+static struct liveupdate_flb iommu_flb = {
+	.compatible = IOMMU_LUO_FLB_COMPATIBLE,
+	.ops = &iommu_flb_ops,
+};
+
+int iommu_liveupdate_register_flb(struct liveupdate_file_handler *handler)
+{
+	return liveupdate_register_flb(handler, &iommu_flb);
+}
+EXPORT_SYMBOL(iommu_liveupdate_register_flb);
+
+int iommu_liveupdate_unregister_flb(struct liveupdate_file_handler *handler)
+{
+	return liveupdate_unregister_flb(handler, &iommu_flb);
+}
+EXPORT_SYMBOL(iommu_liveupdate_unregister_flb);
diff --git a/include/linux/iommu-lu.h b/include/linux/iommu-lu.h
new file mode 100644
index 000000000000..59095d2f1bb2
--- /dev/null
+++ b/include/linux/iommu-lu.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (C) 2025, Google LLC
+ * Author: Samiullah Khawaja <skhawaja@google.com>
+ */
+
+#ifndef _LINUX_IOMMU_LU_H
+#define _LINUX_IOMMU_LU_H
+
+#include <linux/liveupdate.h>
+#include <linux/kho/abi/iommu.h>
+
+int iommu_liveupdate_register_flb(struct liveupdate_file_handler *handler);
+int iommu_liveupdate_unregister_flb(struct liveupdate_file_handler *handler);
+
+#endif /* _LINUX_IOMMU_LU_H */
diff --git a/include/linux/kho/abi/iommu.h b/include/linux/kho/abi/iommu.h
new file mode 100644
index 000000000000..8e1c05cfe7bb
--- /dev/null
+++ b/include/linux/kho/abi/iommu.h
@@ -0,0 +1,119 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (C) 2025, Google LLC
+ * Author: Samiullah Khawaja <skhawaja@google.com>
+ */
+
+#ifndef _LINUX_KHO_ABI_IOMMU_H
+#define _LINUX_KHO_ABI_IOMMU_H
+
+#include <linux/mutex_types.h>
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+/**
+ * DOC: IOMMU File-Lifecycle Bound (FLB) Live Update ABI
+ *
+ * This header defines the ABI for preserving IOMMU state across kexec using
+ * Live Update File-Lifecycle Bound (FLB) data.
+ *
+ * This interface is a contract. Any modification to any of the serialization
+ * structs defined here constitutes a breaking change. Such changes require
+ * incrementing the version number in the IOMMU_LUO_FLB_COMPATIBLE string.
+ */
+
+#define IOMMU_LUO_FLB_COMPATIBLE "iommu-v1"
+
+enum iommu_lu_type {
+	IOMMU_INVALID,
+	IOMMU_INTEL,
+};
+
+struct iommu_obj_ser {
+	u32 idx;
+	u32 ref_count;
+	u32 deleted:1;
+	u32 incoming:1;
+} __packed;
+
+struct iommu_domain_ser {
+	struct iommu_obj_ser obj;
+	u64 top_table;
+	u64 top_level;
+	struct iommu_domain *restored_domain;
+} __packed;
+
+struct device_domain_iommu_ser {
+	u32 did;
+	u64 domain_phys;
+	u64 iommu_phys;
+} __packed;
+
+struct device_ser {
+	struct iommu_obj_ser obj;
+	u64 token;
+	u32 devid;
+	u32 pci_domain;
+	struct device_domain_iommu_ser domain_iommu_ser;
+	enum iommu_lu_type type;
+} __packed;
+
+struct iommu_intel_ser {
+	u64 phys_addr;
+	u64 root_table;
+} __packed;
+
+struct iommu_ser {
+	struct iommu_obj_ser obj;
+	u64 token;
+	enum iommu_lu_type type;
+	union {
+		struct iommu_intel_ser intel;
+	};
+} __packed;
+
+struct iommu_objs_ser {
+	u64 next_objs;
+	u64 nr_objs;
+} __packed;
+
+struct iommus_ser {
+	struct iommu_objs_ser objs;
+	struct iommu_ser iommus[];
+} __packed;
+
+struct iommu_domains_ser {
+	struct iommu_objs_ser objs;
+	struct iommu_domain_ser iommu_domains[];
+} __packed;
+
+struct devices_ser {
+	struct iommu_objs_ser objs;
+	struct device_ser devices[];
+} __packed;
+
+#define MAX_IOMMU_SERS ((PAGE_SIZE - sizeof(struct iommus_ser)) / sizeof(struct iommu_ser))
+#define MAX_IOMMU_DOMAIN_SERS \
+		((PAGE_SIZE - sizeof(struct iommu_domains_ser)) / sizeof(struct iommu_domain_ser))
+#define MAX_DEVICE_SERS ((PAGE_SIZE - sizeof(struct devices_ser)) / sizeof(struct device_ser))
+
+struct iommu_lu_flb_ser {
+	u64 iommus_phys;
+	u64 nr_iommus;
+	u64 iommu_domains_phys;
+	u64 nr_domains;
+	u64 devices_phys;
+	u64 nr_devices;
+} __packed;
+
+struct iommu_lu_flb_obj {
+	struct mutex lock;
+	struct iommu_lu_flb_ser *ser;
+
+	struct iommu_domains_ser *iommu_domains;
+	struct iommus_ser *iommus;
+	struct devices_ser *devices;
+} __packed;
+
+#endif /* _LINUX_KHO_ABI_IOMMU_H */
-- 
2.53.0.rc2.204.g2597b5adb4-goog



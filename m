Return-Path: <kvm+bounces-69608-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KOslF6fQe2m0IgIAu9opvQ
	(envelope-from <kvm+bounces-69608-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:27:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AF4BAB4A1B
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:27:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 184DB30488D6
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB8F35CBD8;
	Thu, 29 Jan 2026 21:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3TvWTVNF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD02B35CBD6
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 21:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769721943; cv=none; b=gFklA3QWvLgCCOWANuXj3pMNGGdUJWYJMeioL+4UmkG+MG6qcvCdBx6teMLIin0KkRcSn4jKZwariFVv4cyp1264SW0nvLGG01kWdr4VxHz2glZwHR90NDfmkVIViuAOsLdPsX4JL104cu3kJgAM2pLpqy0zgoCEYCJQg8LbQWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769721943; c=relaxed/simple;
	bh=aa5qSxMMVDUDlKQtjTotswW5ZPNNWuohp9tvJB5cNUU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D8+smzgYrpTTxR8I5+mAaNuZ+WOmNJjNNCuTBYJDdFGJJNgEfherkcfAXMEppi8FTXeNLDqD5n21tUzblphMxN0lQyRiZ29IAnD6QJ9UDi3MAMIDOaJYFlqvlHhi35K/1k4IpfRX0yBKmklveuiInlTzhwB7BnrlXrY26rKZDtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3TvWTVNF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c93f0849dso1506001a91.1
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 13:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721941; x=1770326741; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FgSWc2a8f762WhttrAnnu8Gpn5PakSPoQMEwyGUxMj4=;
        b=3TvWTVNFMZSWsn9Vsp9r1HhqjChTu4BqptHdvrpmUTFibjjg2wVMW2gE56UxkZLIdn
         dF1GvnuYGAuSj0EArvmtq/c6hEGS04CZNWJfck7yvIqNvMd+RE7dip5k5eEPWXrsDx/f
         nO3+Pr/zfn8QSVZER3MOrCe/RYGkB79CsgXtomwDu506EhYT2I+sn/hN4fZj4DRvOshV
         iqI7L6MbdK/hTQOWWAZLtqR07N5VtMa4r7SRCJTJ4flHxw/JXOwfSgQjRx/KK0QQU+z/
         XDspk6pyWV1lgPekufRSKZKlEqLxwN4m34QuW7b9m7Yq/OArDd8yKRN5Ha1FrNpz/iWL
         mhBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721941; x=1770326741;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FgSWc2a8f762WhttrAnnu8Gpn5PakSPoQMEwyGUxMj4=;
        b=B4i/WYIZFoisAnSi5VDXbNJSDW/dgdIYpxMdBUSnbH6Ix6B/UbFTM8vmueBdsHxalH
         On/MgR9nIvR8IszlE+xyK8ADmCCE1IF8iT3GRa9MjDmf/iMlgZicZgFIqtUX659MLyOl
         GxWWVWK30Wu1/7y29/ouIaC0l2hosPbjMgsKRleMRcWIm2sUbWR1a5OrQQF4YkY9xoml
         kdE3jbT9Ezg5xQI9nHXETYTs85IH+hWDYTrE4KGRc/0Sp+H9GqNAVxAiDMc6MatK3jpL
         IRi4b6MqyuQsv5+BvWI8+U9IZvcR6H94sJJjsBmMCOkQIync1OQFBeGeB3e8JsuIHZa9
         2V6A==
X-Forwarded-Encrypted: i=1; AJvYcCV985lf+toVuEL9HSLVVTQGg/1Ka1RLj/aqRj68v889F2j7nst0pl4OdHlYve5fIyDMAHQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNOFXzWVi+chx5VMpkziOhILqlBUfNzQhB0kpuH6xFfIXYEgQf
	t8rkpcOOYjmQ6ns5+3Ynaww5yXhWsHLY3eqCUN5aRR9ICYEy1gkP0l/XUX9OV0h6ENPcPCkBU1Q
	P9QAAndeAUwGUMg==
X-Received: from pjbha8.prod.google.com ([2002:a17:90a:f3c8:b0:34c:34ab:8fd9])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4a82:b0:34f:6312:f225 with SMTP id 98e67ed59e1d1-35429b0007emr3496453a91.14.1769721940932;
 Thu, 29 Jan 2026 13:25:40 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:49 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-3-dmatlack@google.com>
Subject: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved across
 Live Update
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69608-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: AF4BAB4A1B
X-Rspamd-Action: no action

Add an API to enable the PCI subsystem to track all devices that are
preserved across a Live Update, including both incoming devices (passed
from the previous kernel) and outgoing devices (passed to the next
kernel).

Use PCI segment number and BDF to keep track of devices across Live
Update. This means the kernel must keep both identifiers constant across
a Live Update for any preserved device. VFs are not supported for now,
since that requires preserving SR-IOV state on the device to ensure the
same number of VFs appear after kexec and with the same BDFs.

Drivers that preserve devices across Live Update can now register their
struct liveupdate_file_handler with the PCI subsystem so that the PCI
subsystem can allocate and manage File-Lifecycle-Bound (FLB) global data
to track the list of incoming and outgoing preserved devices.

  pci_liveupdate_register_fh(driver_fh)
  pci_liveupdate_unregister_fh(driver_fh)

Drivers can notify the PCI subsystem whenever a device is preserved and
unpreserved with the following APIs:

  pci_liveupdate_outgoing_preserve(pci_dev)
  pci_liveupdate_outgoing_unpreserve(pci_dev)

After a Live Update, the PCI subsystem fetches its FLB global data
from the previous kernel from the Live Update Orchestrator (LUO) during
device initialization to determine which devices were preserved.

Drivers can check if a device was preserved before userspace retrieves
the file for it via pci_dev->liveupdate_incoming.

Once a driver has finished restoring an incoming preserved device, it
can notify the PCI subsystem with the following call, which clears
pci_dev->liveupdate_incoming.

  pci_liveupdate_incoming_finish(pci_dev)

This API will be used in subsequent commits by the vfio-pci driver to
preserve VFIO devices across Live Update and by the PCI subsystem.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/Makefile        |   1 +
 drivers/pci/liveupdate.c    | 212 ++++++++++++++++++++++++++++++++++++
 drivers/pci/probe.c         |   2 +
 include/linux/kho/abi/pci.h |  55 ++++++++++
 include/linux/pci.h         |  47 ++++++++
 5 files changed, 317 insertions(+)
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 include/linux/kho/abi/pci.h

diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 8c259a9a8796..a32f7658b9e5 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_PROC_FS)		+= proc.o
 obj-$(CONFIG_SYSFS)		+= pci-sysfs.o slot.o
 obj-$(CONFIG_ACPI)		+= pci-acpi.o
 obj-$(CONFIG_GENERIC_PCI_IOMAP) += iomap.o
+obj-$(CONFIG_LIVEUPDATE)	+= liveupdate.o
 endif
 
 obj-$(CONFIG_OF)		+= of.o
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
new file mode 100644
index 000000000000..182cfc793b80
--- /dev/null
+++ b/drivers/pci/liveupdate.c
@@ -0,0 +1,212 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * David Matlack <dmatlack@google.com>
+ */
+
+#include <linux/bsearch.h>
+#include <linux/io.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/pci.h>
+#include <linux/liveupdate.h>
+#include <linux/mutex.h>
+#include <linux/mm.h>
+#include <linux/pci.h>
+#include <linux/sort.h>
+
+static DEFINE_MUTEX(pci_flb_outgoing_lock);
+
+static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
+{
+	struct pci_dev *dev = NULL;
+	int max_nr_devices = 0;
+	struct pci_ser *ser;
+	unsigned long size;
+
+	for_each_pci_dev(dev)
+		max_nr_devices++;
+
+	size = struct_size_t(struct pci_ser, devices, max_nr_devices);
+
+	ser = kho_alloc_preserve(size);
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	ser->max_nr_devices = max_nr_devices;
+
+	args->obj = ser;
+	args->data = virt_to_phys(ser);
+	return 0;
+}
+
+static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
+{
+	struct pci_ser *ser = args->obj;
+
+	WARN_ON_ONCE(ser->nr_devices);
+	kho_unpreserve_free(ser);
+}
+
+static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
+{
+	args->obj = phys_to_virt(args->data);
+	return 0;
+}
+
+static void pci_flb_finish(struct liveupdate_flb_op_args *args)
+{
+	kho_restore_free(args->obj);
+}
+
+static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
+	.preserve = pci_flb_preserve,
+	.unpreserve = pci_flb_unpreserve,
+	.retrieve = pci_flb_retrieve,
+	.finish = pci_flb_finish,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_flb pci_liveupdate_flb = {
+	.ops = &pci_liveupdate_flb_ops,
+	.compatible = PCI_LUO_FLB_COMPATIBLE,
+};
+
+#define INIT_PCI_DEV_SER(_dev) {		\
+	.domain = pci_domain_nr((_dev)->bus),	\
+	.bdf = pci_dev_id(_dev),		\
+}
+
+static int pci_dev_ser_cmp(const void *__a, const void *__b)
+{
+	const struct pci_dev_ser *a = __a, *b = __b;
+
+	return cmp_int(a->domain << 16 | a->bdf, b->domain << 16 | b->bdf);
+}
+
+static struct pci_dev_ser *pci_ser_find(struct pci_ser *ser,
+					struct pci_dev *dev)
+{
+	const struct pci_dev_ser key = INIT_PCI_DEV_SER(dev);
+
+	return bsearch(&key, ser->devices, ser->nr_devices,
+		       sizeof(key), pci_dev_ser_cmp);
+}
+
+static int pci_ser_delete(struct pci_ser *ser, struct pci_dev *dev)
+{
+	struct pci_dev_ser *dev_ser;
+	int i;
+
+	dev_ser = pci_ser_find(ser, dev);
+	if (!dev_ser)
+		return -ENOENT;
+
+	for (i = dev_ser - ser->devices; i < ser->nr_devices - 1; i++)
+		ser->devices[i] = ser->devices[i + 1];
+
+	ser->nr_devices--;
+	return 0;
+}
+
+int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
+{
+	struct pci_dev_ser new = INIT_PCI_DEV_SER(dev);
+	struct pci_ser *ser;
+	int i, ret;
+
+	/* Preserving VFs is not supported yet. */
+	if (dev->is_virtfn)
+		return -EINVAL;
+
+	guard(mutex)(&pci_flb_outgoing_lock);
+
+	if (dev->liveupdate_outgoing)
+		return -EBUSY;
+
+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
+	if (ret)
+		return ret;
+
+	if (ser->nr_devices == ser->max_nr_devices)
+		return -E2BIG;
+
+	for (i = ser->nr_devices; i > 0; i--) {
+		struct pci_dev_ser *prev = &ser->devices[i - 1];
+		int cmp = pci_dev_ser_cmp(&new, prev);
+
+		if (WARN_ON_ONCE(!cmp))
+			return -EBUSY;
+
+		if (cmp > 0)
+			break;
+
+		ser->devices[i] = *prev;
+	}
+
+	ser->devices[i] = new;
+	ser->nr_devices++;
+	dev->liveupdate_outgoing = true;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_outgoing_preserve);
+
+void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev)
+{
+	struct pci_ser *ser;
+	int ret;
+
+	guard(mutex)(&pci_flb_outgoing_lock);
+
+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
+	if (WARN_ON_ONCE(ret))
+		return;
+
+	WARN_ON_ONCE(pci_ser_delete(ser, dev));
+	dev->liveupdate_outgoing = false;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_outgoing_unpreserve);
+
+u32 pci_liveupdate_incoming_nr_devices(void)
+{
+	struct pci_ser *ser;
+	int ret;
+
+	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
+	if (ret)
+		return 0;
+
+	return ser->nr_devices;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_incoming_nr_devices);
+
+void pci_liveupdate_setup_device(struct pci_dev *dev)
+{
+	struct pci_ser *ser;
+	int ret;
+
+	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
+	if (ret)
+		return;
+
+	dev->liveupdate_incoming = !!pci_ser_find(ser, dev);
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_setup_device);
+
+void pci_liveupdate_incoming_finish(struct pci_dev *dev)
+{
+	dev->liveupdate_incoming = false;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_incoming_finish);
+
+int pci_liveupdate_register_fh(struct liveupdate_file_handler *fh)
+{
+	return liveupdate_register_flb(fh, &pci_liveupdate_flb);
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_register_fh);
+
+int pci_liveupdate_unregister_fh(struct liveupdate_file_handler *fh)
+{
+	return liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_fh);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 37329095e5fe..af6356c5a156 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2060,6 +2060,8 @@ int pci_setup_device(struct pci_dev *dev)
 	if (pci_early_dump)
 		early_dump_pci_device(dev);
 
+	pci_liveupdate_setup_device(dev);
+
 	/* Need to have dev->class ready */
 	dev->cfg_size = pci_cfg_space_size(dev);
 
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
new file mode 100644
index 000000000000..6577767f8da6
--- /dev/null
+++ b/include/linux/kho/abi/pci.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * David Matlack <dmatlack@google.com>
+ */
+
+#ifndef _LINUX_KHO_ABI_PCI_H
+#define _LINUX_KHO_ABI_PCI_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+/**
+ * DOC: PCI File-Lifecycle Bound (FLB) Live Update ABI
+ *
+ * This header defines the ABI for preserving core PCI state across kexec using
+ * Live Update File-Lifecycle Bound (FLB) data.
+ *
+ * This interface is a contract. Any modification to any of the serialization
+ * structs defined here constitutes a breaking change. Such changes require
+ * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
+ */
+
+#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
+
+/**
+ * struct pci_dev_ser - Serialized state about a single PCI device.
+ *
+ * @domain: The device's PCI domain number (segment).
+ * @bdf: The device's PCI bus, device, and function number.
+ */
+struct pci_dev_ser {
+	u16 domain;
+	u16 bdf;
+} __packed;
+
+/**
+ * struct pci_ser - PCI Subsystem Live Update State
+ *
+ * This struct tracks state about all devices that are being preserved across
+ * a Live Update for the next kernel.
+ *
+ * @max_nr_devices: The length of the devices[] flexible array.
+ * @nr_devices: The number of devices that were preserved.
+ * @devices: Flexible array of pci_dev_ser structs for each device. Guaranteed
+ *           to be sorted ascending by domain and bdf.
+ */
+struct pci_ser {
+	u64 max_nr_devices;
+	u64 nr_devices;
+	struct pci_dev_ser devices[];
+} __packed;
+
+#endif /* _LINUX_KHO_ABI_PCI_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7e36936bb37a..9ead6d84aef6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -40,6 +40,7 @@
 #include <linux/resource_ext.h>
 #include <linux/msi_api.h>
 #include <uapi/linux/pci.h>
+#include <linux/liveupdate.h>
 
 #include <linux/pci_ids.h>
 
@@ -582,6 +583,10 @@ struct pci_dev {
 	u8		tph_mode;	/* TPH mode */
 	u8		tph_req_type;	/* TPH requester type */
 #endif
+#ifdef CONFIG_LIVEUPDATE
+	unsigned int	liveupdate_incoming:1;	/* Preserved by previous kernel */
+	unsigned int	liveupdate_outgoing:1;	/* Preserved for next kernel */
+#endif
 };
 
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
@@ -2854,4 +2859,46 @@ void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
 	WARN_ONCE(condition, "%s %s: " fmt, \
 		  dev_driver_string(&(pdev)->dev), pci_name(pdev), ##arg)
 
+#ifdef CONFIG_LIVEUPDATE
+int pci_liveupdate_outgoing_preserve(struct pci_dev *dev);
+void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev);
+void pci_liveupdate_setup_device(struct pci_dev *dev);
+u32 pci_liveupdate_incoming_nr_devices(void);
+void pci_liveupdate_incoming_finish(struct pci_dev *dev);
+int pci_liveupdate_register_fh(struct liveupdate_file_handler *fh);
+int pci_liveupdate_unregister_fh(struct liveupdate_file_handler *fh);
+#else /* !CONFIG_LIVEUPDATE */
+static inline int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev)
+{
+}
+
+static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
+{
+}
+
+static inline u32 pci_liveupdate_incoming_nr_devices(void)
+{
+	return 0;
+}
+
+static inline void pci_liveupdate_incoming_finish(struct pci_dev *dev)
+{
+}
+
+static inline int pci_liveupdate_register_fh(struct liveupdate_file_handler *fh)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int pci_liveupdate_unregister_fh(struct liveupdate_file_handler *fh)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* !CONFIG_LIVEUPDATE */
+
 #endif /* LINUX_PCI_H */
-- 
2.53.0.rc1.225.gd81095ad13-goog



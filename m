Return-Path: <kvm+bounces-27083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 218A397BE96
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 17:28:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCDD42839B6
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 15:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E911C8FDE;
	Wed, 18 Sep 2024 15:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="dfMqR+zz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA1018B470
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 15:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726673301; cv=none; b=EC5B1t32MDn/vZYajv8V6xs1jLzixGDP79WqknUAz0z0d6DYvo1/81JMhAJMj3iohPEQaoD5lMJWfPdlOBVJljYT2bOhxeviqsoRQZXavTXsOPOvonSd6BKogCopzPJ8nJkt8e/P/mOyIVMQPxvT+LGDquF4T9vkO8QTEPJve7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726673301; c=relaxed/simple;
	bh=ItAa8fO3kkj4DyZk3TKrr+9iURCiwBGC9y6QfuRBEkw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FXC853vqnSBo9WVCND7ySFSKNOuiZK2iDjFlInX/K/aKncA6CG4FLklLn9wcgSZtG4iQCTEpPNkOIeUoKDID3abnwaPnscNsYUynox8hEFQA6xMy7s2DdzZYhMmPnb0Iu4zK2O3YrsqZhWkCW0uhCRSP44b9GcLveh1mJKJd6WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=dfMqR+zz; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726673300; x=1758209300;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=R+cb/dbFY2OXe13tFaBYjWlfNZRYT3F0Ag124qVSVDc=;
  b=dfMqR+zzTPI4atsx39cdmx53aC/bmMHEqYw6lr90iTsGWm5Z/XQna7Ji
   2gsoG1V2krbjI5s1o8WIO2gxrILM/fCYsFh8IqdSQw7Bn3/2dt7R6ll3K
   MVGZGZtaUPHc2GwP/aelT/F+9lkna1g1j0FahRLOin/izmxUsg8Ae6Qhp
   8=;
X-IronPort-AV: E=Sophos;i="6.10,239,1719878400"; 
   d="scan'208";a="232771159"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 15:28:17 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:18849]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.17.12:2525] with esmtp (Farcaster)
 id e7d64bef-93c6-4e89-8986-8a05a3aaf0da; Wed, 18 Sep 2024 15:28:15 +0000 (UTC)
X-Farcaster-Flow-ID: e7d64bef-93c6-4e89-8986-8a05a3aaf0da
Received: from EX19D018EUC003.ant.amazon.com (10.252.51.231) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:15 +0000
Received: from EX19MTAUWC001.ant.amazon.com (10.250.64.145) by
 EX19D018EUC003.ant.amazon.com (10.252.51.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:15 +0000
Received: from email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com
 (10.25.36.210) by mail-relay.amazon.com (10.250.64.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Wed, 18 Sep 2024 15:28:14 +0000
Received: from dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com (dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com [172.19.104.233])
	by email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com (Postfix) with ESMTPS id 5BA1E40421;
	Wed, 18 Sep 2024 15:28:13 +0000 (UTC)
From: Lilit Janpoladyan <lilitj@amazon.com>
To: <kvm@vger.kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<nh-open-source@amazon.com>, <lilitj@amazon.com>
Subject: [PATCH 1/8] arm64: add an interface for stage-2 page tracking
Date: Wed, 18 Sep 2024 15:28:00 +0000
Message-ID: <20240918152807.25135-2-lilitj@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240918152807.25135-1-lilitj@amazon.com>
References: <20240918152807.25135-1-lilitj@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Add an interface for tracking stage-2 page accesses. The interface
can be implemented by a driver for a device that has the capabilities
e.g. AWS Graviton Page Tracking Agent accelerator. When a device
implementing page_tracking_device interface is available, KVM will
use it to accelerate dirty logging. The initial version of the
interface supports dirty logging only, but the interface can be
extended to other use cases, such as a WSS calculation.

page_tracking_device supports tracking stage-2 translations by VMID
and by CPU ID. While VMID filter is required, CPU ID is optional.
CPU ID == -1 denotes any CPU. Similarly, page_tracking_device allows
getting pages logged for either a particular CPU or for all. KVM
can use CPU ID of -1 to populate dirty bitmaps and a specific
CPU ID for per vCPU dirty rings.

Signed-off-by: Lilit Janpoladyan <lilitj@amazon.com>
---
 arch/arm64/include/asm/page_tracking.h |  79 +++++++++++++
 arch/arm64/kvm/Kconfig                 |  12 ++
 arch/arm64/kvm/Makefile                |   1 +
 arch/arm64/kvm/page_tracking.c         | 158 +++++++++++++++++++++++++
 4 files changed, 250 insertions(+)
 create mode 100644 arch/arm64/include/asm/page_tracking.h
 create mode 100644 arch/arm64/kvm/page_tracking.c

diff --git a/arch/arm64/include/asm/page_tracking.h b/arch/arm64/include/asm/page_tracking.h
new file mode 100644
index 000000000000..5162fb5b648e
--- /dev/null
+++ b/arch/arm64/include/asm/page_tracking.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ARM64_PAGE_TRACKING_DEVICE_H
+#define _ARM64_PAGE_TRACKING_DEVICE_H
+
+#include <linux/types.h>
+#include <linux/kvm_types.h>
+
+/* Page tracking mode */
+enum pt_mode {
+	dirty_pages,
+};
+
+/* Configuration of a per-VM page tracker */
+struct pt_config {
+	enum pt_mode mode; /* Tracking mode */
+	u32 vmid;	/* VMID to track */
+};
+
+/* Interface provided by the page tracking device */
+struct page_tracking_device {
+
+	/* Allocates a per-VM tracker, returns tracking context */
+	void* (*allocate_tracker)(struct pt_config config);
+
+	/* Releases a per-VM tracker */
+	int (*release_tracker)(void *ctx);
+
+	/*
+	 * Enables tracking for the specified @ctx and the specified @cpu,
+	 * @cpu = -1 enables tracking for all cpus
+	 *
+	 * The function may be called for the same @ctx and @cpu multiple
+	 * times and the implementation has to do reference counting to
+	 * correctly disable the tracking.
+	 * @returns 0 on success, negative errno in case of a failure
+	 */
+	int (*enable_tracking)(void *ctx, int cpu);
+
+	/*
+	 * Disables tracking for the @ctx
+	 *
+	 * Does actually disable the tracking of the @ctx and the @cpu only
+	 * when the number of disable and enable calls matches, i.e. when the
+	 * reference counter is at 0. @returns 0 in this case, -EBUSY while
+	 * reference counter > 0 and negative errno in case of a failure
+	 */
+	int (*disable_tracking)(void *ctx, int cpu);
+
+	/*
+	 * Flushes any tracking data available for the @ctx,
+	 * @returns 0 on success, negative errno in case of a failure
+	 */
+	int (*flush)(void *ctx);
+
+	/*
+	 * Reads up to @max dirty pages available for the @ctx
+	 * In case @cpu id is not -1, reads only pages dirtied by the specified cpu
+	 * @returns number of read pages and -errno in case of a failure
+	 */
+	int (*read_dirty_pages)(void *ctx,
+				int cpu,
+				gpa_t *pages,
+				u32 max);
+};
+
+/* Page tracking device tear-down, bring-up and existence checks */
+void page_tracking_device_unregister(struct page_tracking_device *pt_dev);
+int page_tracking_device_register(struct page_tracking_device *pt_dev);
+int page_tracking_device_registered(void);
+
+/* Page tracking device wrappers */
+void *page_tracking_allocate(struct pt_config config);
+int page_tracking_release(void *ctx);
+int page_tracking_enable(void *ctx, int cpu);
+int page_tracking_disable(void *ctx, int cpu);
+int page_tracking_flush(void *ctx);
+int page_tracking_read_dirty_pages(void *ctx, int cpu, gpa_t *pages, u32 max);
+
+#endif /*_ARM64_PAGE_TRACKNG_DEVICE_H */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 8304eb342be9..33844658279b 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -66,4 +66,16 @@ config PROTECTED_NVHE_STACKTRACE
 
 	  If unsure, or not using protected nVHE (pKVM), say N.
 
+config HAVE_KVM_PAGE_TRACKING_DEVICE
+	bool "Support for hardware accelerated dirty tracking"
+	default n
+	help
+	  Say Y to enable hardware accelerated dirty tracking
+
+	  Adds support for hardware accelerated dirty tracking during live
+	  migration of a virtual machine. Requires a hardware accelerator.
+
+	  If there is no required hardware, say N.
+
+
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 86a629aaf0a1..4e4f5c63baf2 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -18,6 +18,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
 	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
 	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o \
+	 page_tracking.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
diff --git a/arch/arm64/kvm/page_tracking.c b/arch/arm64/kvm/page_tracking.c
new file mode 100644
index 000000000000..a81c917d4faa
--- /dev/null
+++ b/arch/arm64/kvm/page_tracking.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <asm/page_tracking.h>
+#include <linux/mutex.h>
+#include <linux/rcupdate.h>
+
+#ifndef CONFIG_HAVE_KVM_PAGE_TRACKING_DEVICE
+
+int page_tracking_device_register(struct page_tracking_device *dev) { return 0; }
+void page_tracking_device_unregister(struct page_tracking_device *dev) {}
+int page_tracking_device_registered(void) { return 0; }
+void *page_tracking_allocate(struct pt_config config) { return NULL; }
+int page_tracking_release(void *ctx) { return 0; }
+int page_tracking_enable(void *ctx, int cpu) { return 0; }
+int page_tracking_disable(void *ctx, int cpu) { return 0; }
+int page_tracking_flush(void *ctx) { return 0; }
+int page_tracking_read_dirty_pages(void *ctx, int cpu, gpa_t *pages, u32 max) { return 0; }
+
+#else
+
+static DEFINE_MUTEX(page_tracking_device_mutex);
+static struct page_tracking_device __rcu *pt_dev __read_mostly;
+
+int page_tracking_device_register(struct page_tracking_device *dev)
+{
+	int rc = 0;
+
+	mutex_lock(&page_tracking_device_mutex);
+
+	if (rcu_dereference_protected(pt_dev, lockdep_is_held(&page_tracking_device_mutex))) {
+		rc = -EBUSY;
+		goto out;
+	}
+	rcu_assign_pointer(pt_dev, dev);
+out:
+	mutex_unlock(&page_tracking_device_mutex);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(page_tracking_device_register);
+
+void page_tracking_device_unregister(struct page_tracking_device *dev)
+{
+	mutex_lock(&page_tracking_device_mutex);
+
+	if (dev == rcu_dereference_protected(pt_dev,
+					     lockdep_is_held(&page_tracking_device_mutex))) {
+		/* Disable page tracking device */
+		RCU_INIT_POINTER(pt_dev, NULL);
+		synchronize_rcu();
+	}
+	mutex_unlock(&page_tracking_device_mutex);
+}
+EXPORT_SYMBOL_GPL(page_tracking_device_unregister);
+
+int page_tracking_device_registered(void)
+{
+	bool registered;
+
+	rcu_read_lock();
+	registered = (rcu_dereference(pt_dev) != NULL);
+	rcu_read_unlock();
+	return registered;
+}
+EXPORT_SYMBOL_GPL(page_tracking_device_registered);
+
+/* Allocates a per-VM tracker, returns tracking context */
+void *page_tracking_allocate(struct pt_config config)
+{
+	struct page_tracking_device *dev;
+	void *ctx = NULL;
+
+	rcu_read_lock();
+	dev = rcu_dereference(pt_dev);
+	if (likely(dev))
+		ctx = dev->allocate_tracker(config);
+	rcu_read_unlock();
+	return ctx;
+}
+EXPORT_SYMBOL_GPL(page_tracking_allocate);
+
+/* Releases a per-VM tracker */
+int page_tracking_release(void *ctx)
+{
+	int r;
+	struct page_tracking_device *dev;
+
+	rcu_read_lock();
+	dev = rcu_dereference(pt_dev);
+	if (likely(dev))
+		r = dev->release_tracker(ctx);
+	rcu_read_unlock();
+	return r;
+}
+EXPORT_SYMBOL_GPL(page_tracking_release);
+
+/* Enables tracking for the specified @ctx and @cpu (-1 for all cpus) */
+int page_tracking_enable(void *ctx, int cpu)
+{
+	int r;
+	struct page_tracking_device *dev;
+
+	rcu_read_lock();
+	dev = rcu_dereference(pt_dev);
+	if (likely(dev))
+		r = dev->enable_tracking(ctx, cpu);
+	rcu_read_unlock();
+	return r;
+}
+EXPORT_SYMBOL_GPL(page_tracking_enable);
+
+/* Disables tracking for the @ctx and @cpu */
+int page_tracking_disable(void *ctx, int cpu)
+{
+	int r;
+	struct page_tracking_device *dev;
+
+	rcu_read_lock();
+	dev = rcu_dereference(pt_dev);
+	if (likely(dev))
+		r = dev->disable_tracking(ctx, cpu);
+	rcu_read_unlock();
+	return r;
+}
+EXPORT_SYMBOL_GPL(page_tracking_disable);
+
+/* Flushes any available data */
+int page_tracking_flush(void *ctx)
+{
+	int r;
+	struct page_tracking_device *dev;
+
+	rcu_read_lock();
+	dev = rcu_dereference(pt_dev);
+	if (likely(dev))
+		r = dev->flush(ctx);
+	rcu_read_unlock();
+	return r;
+}
+EXPORT_SYMBOL_GPL(page_tracking_flush);
+
+/*
+ * Reads up to @max dirty pages available for the @ctx and @cpu (-1 for all cpus)
+ * @returns number of read pages and -errno in case of error
+ */
+int page_tracking_read_dirty_pages(void *ctx, int cpu, gpa_t *pages, u32 max)
+{
+	int r;
+	struct page_tracking_device *dev;
+
+	rcu_read_lock();
+	dev = rcu_dereference(pt_dev);
+	if (likely(dev))
+		r = dev->read_dirty_pages(ctx, cpu, pages, max);
+	rcu_read_unlock();
+	return r;
+}
+EXPORT_SYMBOL_GPL(page_tracking_read_dirty_pages);
+
+#endif
-- 
2.40.1



Return-Path: <kvm+bounces-7899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F6D984849D
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:01:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2D2128BEEC
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B64225D903;
	Sat,  3 Feb 2024 09:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h1oR1Mcs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5246A5D8F5;
	Sat,  3 Feb 2024 09:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950804; cv=none; b=STAyRVGOBBeVvB4GxXdsjC6/yhdyqda5k3z+2tLRhBPP79UUBazfX6r0eie+dHPx0w9srCtbWiWlLpsUTqvSyXaL69fhV6pDa0jvs/3miFc0PrzjSnTuU99v5Yui2aVEM/FZ4cQ5nROGrZ6RIs+ZN3CuF1K8Bj8hFy+1gPO63q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950804; c=relaxed/simple;
	bh=L+ZWKNEEcAmsWFGnKg8TWtGGaRb+SV6m6dlf0/X0V/c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XR2rz5d1LAm19XXbD1cl1wvb6pQ7V1lcqm7ECNq6WYEIistQUTOWoYgXVbK6/Xo2Jm01eJIm9g5uLf1jzgi/vQapeylN4sJ6kMhEJSc5AQzsobQT4U0IK/5gcuDqi3Ocsd8fB7KPaiVIZI4sLOwJr6cc1XIH3uJzVuDET5CEjZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h1oR1Mcs; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950804; x=1738486804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L+ZWKNEEcAmsWFGnKg8TWtGGaRb+SV6m6dlf0/X0V/c=;
  b=h1oR1McsXko4tLa3NPZ1gpqBnP360P4GpCFQXJk5tT/wAqoy6D9RutCm
   hEKOVM71npXHfQidOClNFBk3YlHbMGlrj9kNxxfKs+YJWVdp+2MmRZzOn
   vHSSD1zu1VJ0xJrzAQjlc11IbKi7R2OgZaOhrXLzZFKecHV0+nhF5ZaDM
   /5quFqilAeR8xWPEhhQZRj6UISZYpzm5myG6mYBZYyDzURavvJkam6OHX
   6Ket3LFio9rqETS6mMEigl+dOSug133e9dp7VhcYrEk6q10NPAzrH3i5+
   P/sUzYgMNRkU3bZtwH4B6EJn6VANb5y44iLfLBEjioTA2nQ4yHuvt7ctQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4131874"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4131874"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:00:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291215"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 00:59:57 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	David Dai <davidai@google.com>,
	Saravana Kannan <saravanak@google.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 03/26] thermal: intel: hfi: Add HFI notifier helpers to notify HFI update
Date: Sat,  3 Feb 2024 17:11:51 +0800
Message-Id: <20240203091214.411862-4-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
References: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhuocheng Ding <zhuocheng.ding@intel.com>

KVM builds virtual HFI tables for virtual machines, which also needs to
sync Host's HFI table update in time.

Add notifier_chain in HFI instance to notify other modules about HFI
table updates, and provide 2 helpers to register/unregister notifier
hook in HFI driver.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/include/asm/hfi.h        |  8 ++++
 drivers/thermal/intel/intel_hfi.c | 63 ++++++++++++++++++++++++++++---
 2 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/hfi.h b/arch/x86/include/asm/hfi.h
index e0fe5b30fb53..19e3e5a7fb77 100644
--- a/arch/x86/include/asm/hfi.h
+++ b/arch/x86/include/asm/hfi.h
@@ -90,6 +90,10 @@ int intel_hfi_build_virt_table(struct hfi_table *table, struct hfi_features *fea
 			       unsigned int nr_classes, unsigned int hfi_index,
 			       unsigned int cpu);
 static inline bool intel_hfi_enabled(void) { return intel_hfi_max_instances() > 0; }
+int intel_hfi_notifier_register(struct notifier_block *notifier,
+				unsigned int cpu);
+int intel_hfi_notifier_unregister(struct notifier_block *notifier,
+				  unsigned int cpu);
 #else
 static inline int intel_hfi_max_instances(void) { return 0; }
 static inline int intel_hfi_build_virt_features(struct hfi_features *features,
@@ -100,6 +104,10 @@ static inline int intel_hfi_build_virt_table(struct hfi_table *table,
 					     unsigned int nr_classes, unsigned int hfi_index,
 					     unsigned int cpu) { return 0; }
 static inline bool intel_hfi_enabled(void) { return false; }
+static inline int intel_hfi_notifier_register(struct notifier_block *notifier,
+					      unsigned int cpu) { return -ENODEV; }
+static inline int intel_hfi_notifier_unregister(struct notifier_block *notifier,
+						unsigned int cpu) { return -ENODEV; }
 #endif
 
 #endif /* _ASM_X86_HFI_H */
diff --git a/drivers/thermal/intel/intel_hfi.c b/drivers/thermal/intel/intel_hfi.c
index 139ce2d4b26b..330b264ca23d 100644
--- a/drivers/thermal/intel/intel_hfi.c
+++ b/drivers/thermal/intel/intel_hfi.c
@@ -72,18 +72,20 @@ struct hfi_cpu_data {
  * @cpus:		CPUs represented in this HFI table instance
  * @hw_table:		Pointer to the HFI table of this instance
  * @update_work:	Delayed work to process HFI updates
+ * @notifier_chain:	Notification chain dedicated to this instance
  * @table_lock:		Lock to protect acceses to the table of this instance
  * @event_lock:		Lock to process HFI interrupts
  *
  * A set of parameters to parse and navigate a specific HFI table.
  */
 struct hfi_instance {
-	struct hfi_table	local_table;
-	cpumask_var_t		cpus;
-	void			*hw_table;
-	struct delayed_work	update_work;
-	raw_spinlock_t		table_lock;
-	raw_spinlock_t		event_lock;
+	struct hfi_table		local_table;
+	cpumask_var_t			cpus;
+	void				*hw_table;
+	struct delayed_work		update_work;
+	struct raw_notifier_head	notifier_chain;
+	raw_spinlock_t			table_lock;
+	raw_spinlock_t			event_lock;
 };
 
 /**
@@ -189,6 +191,7 @@ static void hfi_update_work_fn(struct work_struct *work)
 				    update_work);
 
 	update_capabilities(hfi_instance);
+	raw_notifier_call_chain(&hfi_instance->notifier_chain, 0, NULL);
 }
 
 void intel_hfi_process_event(__u64 pkg_therm_status_msr_val)
@@ -448,6 +451,7 @@ void intel_hfi_online(unsigned int cpu)
 	init_hfi_instance(hfi_instance);
 
 	INIT_DELAYED_WORK(&hfi_instance->update_work, hfi_update_work_fn);
+	RAW_INIT_NOTIFIER_HEAD(&hfi_instance->notifier_chain);
 	raw_spin_lock_init(&hfi_instance->table_lock);
 	raw_spin_lock_init(&hfi_instance->event_lock);
 
@@ -791,3 +795,50 @@ int intel_hfi_build_virt_table(struct hfi_table *table,
 	return table_changed;
 }
 EXPORT_SYMBOL_GPL(intel_hfi_build_virt_table);
+
+/**
+ * intel_hfi_notifier_register() - Register @notifier hook at @hfi_instance.
+ *
+ * @notifier:		HFI notifier hook to be registered
+ * @cpu:		CPU whose HFI instance the notifier is register at
+ *
+ * When the HFI instance of @cpu receives HFI interrupt and updates its local
+ * HFI table, the registered HFI notifier will be called.
+ *
+ * Return: 0 if successful, otherwise error.
+ */
+int intel_hfi_notifier_register(struct notifier_block *notifier,
+				unsigned int cpu)
+{
+	struct hfi_instance *hfi_instance;
+
+	if (!notifier || cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	hfi_instance = per_cpu(hfi_cpu_info, cpu).hfi_instance;
+	return raw_notifier_chain_register(&hfi_instance->notifier_chain,
+					   notifier);
+}
+EXPORT_SYMBOL_GPL(intel_hfi_notifier_register);
+
+/**
+ * intel_hfi_notifier_unregister() - Unregister @notifier hook at @hfi_instance
+ *
+ * @notifier:		HFI notifier hook to be unregistered
+ * @cpu:		CPU whose HFI instance the notifier is unregister from
+ *
+ * Return: 0 if successful, otherwise error.
+ */
+int intel_hfi_notifier_unregister(struct notifier_block *notifier,
+				  unsigned int cpu)
+{
+	struct hfi_instance *hfi_instance;
+
+	if (!notifier || cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	hfi_instance = per_cpu(hfi_cpu_info, cpu).hfi_instance;
+	return raw_notifier_chain_unregister(&hfi_instance->notifier_chain,
+					     notifier);
+}
+EXPORT_SYMBOL_GPL(intel_hfi_notifier_unregister);
-- 
2.34.1



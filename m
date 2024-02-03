Return-Path: <kvm+bounces-7898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE73984849B
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:00:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2CC6AB25290
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DA5C5D758;
	Sat,  3 Feb 2024 09:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ik5CkECQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775EF5CDD3;
	Sat,  3 Feb 2024 08:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950799; cv=none; b=dazohyMkcihe4bt1gHPK8CZ0UjCC1uObQHm4u4pnc7jXYF/yu2Iek0mIU1ZoQrw1m9J6Xklfg9Txpxf4Wu64Tklajc5idKwMcPihntBmzowmozjAK0hnml99CoGlqUrgxgq2GsXNVBMIHELUmobHVDytBaNcJOcJZabREThoHeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950799; c=relaxed/simple;
	bh=ji6khLPdPc2d+wRmATkf+HZE1RiFEEWfxK/r4PNR6xw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KS73vLTeQv8zORXs0KqQjyTa4Mxv70TmZWQUxNB8WZP8lDVHIkQcFuPQJOvCafNar6vIBAb3kdT28vFwC/Ysiz7df8DWkZaO1i808ualjHiRIFnGHNnuxX+3Nl7oD+sWPY5EE8FLf03b7g+j30z9aK1ntmE94XDqAbgVh3JVijw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ik5CkECQ; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950798; x=1738486798;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ji6khLPdPc2d+wRmATkf+HZE1RiFEEWfxK/r4PNR6xw=;
  b=Ik5CkECQeyg67nr3+/tIk7xw8go43rgzgtt0eQVg2PNmHtmWvyWjOEOq
   W7GhIaS50HEo12MZ2eXYxbzMQQ0UptG83yTEiofp3GFukW7BZjDevxPBe
   d08/mHOfvQKUyaXRxn0ZDEqnScslaeVCVNbPzTwNKTvsi1r8McZOG3IrZ
   bfE6Lp4fsIfjmo6duPDLTE6RVpfDBpN5SCzd7aZZ95llU4sihjHBsJ1Zx
   bapVe7q4+SCWsJamxD0DEmiU/dwmpmrzf4cAZc4T6H3/7gC+P6QbJPI0h
   lRsUmcnqO/m0F8lDs9RcBjDieIXbkvT9h+HutRCE3luxSDfXW6CFRp2UY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4131863"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4131863"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 00:59:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291159"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 00:59:51 -0800
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
Subject: [RFC 02/26] thermal: intel: hfi: Add helpers to build HFI/ITD structures
Date: Sat,  3 Feb 2024 17:11:50 +0800
Message-Id: <20240203091214.411862-3-zhao1.liu@linux.intel.com>
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

Virtual machines need to compose their own HFI tables. Provide helper
functions that collect the relevant features and data from the host
machine.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/include/asm/hfi.h        |  20 ++++
 drivers/thermal/intel/intel_hfi.c | 149 ++++++++++++++++++++++++++++++
 2 files changed, 169 insertions(+)

diff --git a/arch/x86/include/asm/hfi.h b/arch/x86/include/asm/hfi.h
index b7fda3e0e8c8..e0fe5b30fb53 100644
--- a/arch/x86/include/asm/hfi.h
+++ b/arch/x86/include/asm/hfi.h
@@ -82,4 +82,24 @@ struct hfi_features {
 	unsigned int	hdr_size;
 };
 
+#if defined(CONFIG_INTEL_HFI_THERMAL)
+int intel_hfi_max_instances(void);
+int intel_hfi_build_virt_features(struct hfi_features *features, unsigned int nr_classes,
+				  unsigned int nr_entries);
+int intel_hfi_build_virt_table(struct hfi_table *table, struct hfi_features *features,
+			       unsigned int nr_classes, unsigned int hfi_index,
+			       unsigned int cpu);
+static inline bool intel_hfi_enabled(void) { return intel_hfi_max_instances() > 0; }
+#else
+static inline int intel_hfi_max_instances(void) { return 0; }
+static inline int intel_hfi_build_virt_features(struct hfi_features *features,
+						unsigned int nr_classes,
+						unsigned int nr_entries) { return 0; }
+static inline int intel_hfi_build_virt_table(struct hfi_table *table,
+					     struct hfi_features *features,
+					     unsigned int nr_classes, unsigned int hfi_index,
+					     unsigned int cpu) { return 0; }
+static inline bool intel_hfi_enabled(void) { return false; }
+#endif
+
 #endif /* _ASM_X86_HFI_H */
diff --git a/drivers/thermal/intel/intel_hfi.c b/drivers/thermal/intel/intel_hfi.c
index b69fa234b317..139ce2d4b26b 100644
--- a/drivers/thermal/intel/intel_hfi.c
+++ b/drivers/thermal/intel/intel_hfi.c
@@ -29,6 +29,7 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/math.h>
+#include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/percpu-defs.h>
 #include <linux/printk.h>
@@ -642,3 +643,151 @@ void __init intel_hfi_init(void)
 	kfree(hfi_instances);
 	hfi_instances = NULL;
 }
+
+/**
+ * intel_hfi_max_instances() - Get the maximum number of hfi instances.
+ *
+ * Return: the maximum number of hfi instances.
+ */
+int intel_hfi_max_instances(void)
+{
+	return max_hfi_instances;
+}
+EXPORT_SYMBOL_GPL(intel_hfi_max_instances);
+
+/**
+ * intel_hfi_build_virt_features() - Build a virtual hfi_features structure.
+ *
+ * @features:		Feature structure need to be filled
+ * @nr_classes:		Maximum number of classes supported. 1 class indicates
+ *			only HFI feature is configured and 4 classes indicates
+ *			both HFI and ITD features.
+ * @nr_entries:		Number of HFI entries in HFI table.
+ *
+ * Fill a virtual hfi_features structure which is used for HFI/ITD virtualization.
+ * HFI and ITD have different feature information, and the virtual feature
+ * structure is based on the corresponding configured number of classes (in Guest
+ * CPUID) to be built.
+ *
+ * Return: -EINVAL if there's the error for the parameters, otherwise 0.
+ */
+int intel_hfi_build_virt_features(struct hfi_features *features,
+				  unsigned int nr_classes,
+				  unsigned int nr_entries)
+{
+	unsigned int data_size;
+
+	if (!features || !nr_classes || !nr_entries)
+		return -EINVAL;
+
+	/*
+	 * The virtual feature must be based on the Host's feature; when Host
+	 * enables both HFI and ITD, it is allowed for Guest to create only the
+	 * HFI feature structure which has fewer classes than ITD.
+	 */
+	if (nr_classes > hfi_features.nr_classes)
+		return -EINVAL;
+
+	features->nr_classes = nr_classes;
+	features->class_stride = hfi_features.class_stride;
+	/*
+	 * For the meaning of these two calculations, please refer to the comments
+	 * in hfi_parse_features().
+	 */
+	features->hdr_size = DIV_ROUND_UP(features->class_stride *
+					  features->nr_classes, 8) * 8;
+	features->cpu_stride = DIV_ROUND_UP(features->class_stride *
+					    features->nr_classes, 8) * 8;
+
+	data_size = features->hdr_size + nr_entries * features->cpu_stride;
+	features->nr_table_pages = PAGE_ALIGN(data_size) >> PAGE_SHIFT;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(intel_hfi_build_virt_features);
+
+/**
+ * intel_hfi_build_virt_table() - Fill the data of @hfi_index in virtual HFI table.
+ *
+ * @table:		HFI table to be filled
+ * @features:		Configured feature information of the HFI table
+ * @nr_classes:		Number of classes to be updated for @table. This field is
+ *			based on the enabled feature, which may be different with
+ *			the feature information configured in @features.
+ * @hfi_index:		Index of the HFI data in HFI table to be filled
+ * @cpu:		CPU whose real HFI data is used to fill the @hfi_index
+ *
+ * Fill the row data of hfi_index in a virtual HFI table which is used for HFI/ITD
+ * virtualization. The size of the virtual HFI table is decided by the configured
+ * feature information in @features, and the filled HFI data range is decided by
+ * specified number of classes @nr_classes.
+ *
+ * Virtual machine may disable ITD at runtime through MSR_IA32_HW_FEEDBACK_CONFIG,
+ * in this case, only 1 class data (class 0) can be dynamically updated in virtual
+ * HFI table (class 0).
+ *
+ * Return: 1 if the @table is changed, 0 if the @table isn't changed, and
+ * -EINVAL/-ENOMEM if there's the error for the parameters.
+ */
+int intel_hfi_build_virt_table(struct hfi_table *table,
+			       struct hfi_features *features,
+			       unsigned int nr_classes,
+			       unsigned int hfi_index,
+			       unsigned int cpu)
+{
+	struct hfi_instance *hfi_instance;
+	struct hfi_hdr *hfi_hdr = table->hdr;
+	s16 host_hfi_index;
+	void *src_ptr, *dst_ptr;
+	int table_changed = 0;
+
+	if (!table || !features || !nr_classes)
+		return -EINVAL;
+
+	if (nr_classes > features->nr_classes ||
+	    nr_classes > hfi_features.nr_classes)
+		return -EINVAL;
+
+	/*
+	 * Make sure that this raw that will be filled doesn't cause overflow.
+	 * features->nr_classes indicates the maximum number of possible
+	 * classes.
+	 */
+	if (features->hdr_size + (hfi_index + 1) * features->cpu_stride >
+	    features->nr_table_pages << PAGE_SHIFT)
+		return -ENOMEM;
+
+	if (cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	if (features->class_stride != hfi_features.class_stride)
+		return -EINVAL;
+
+	hfi_instance = per_cpu(hfi_cpu_info, cpu).hfi_instance;
+	host_hfi_index = per_cpu(hfi_cpu_info, cpu).index;
+
+	src_ptr = hfi_instance->local_table.data +
+		  host_hfi_index * hfi_features.cpu_stride;
+	dst_ptr = table->data + hfi_index * features->cpu_stride;
+
+	raw_spin_lock_irq(&hfi_instance->table_lock);
+	for (int i = 0; i < nr_classes; i++) {
+		struct hfi_cpu_data *src = src_ptr + i * hfi_features.class_stride;
+		struct hfi_cpu_data *dst = dst_ptr + i * features->class_stride;
+
+		if (dst->perf_cap != src->perf_cap) {
+			dst->perf_cap = src->perf_cap;
+			hfi_hdr->perf_updated = 1;
+		}
+		if (dst->ee_cap != src->ee_cap) {
+			dst->ee_cap = src->ee_cap;
+			hfi_hdr->ee_updated = 1;
+		}
+		if (hfi_hdr->perf_updated || hfi_hdr->ee_updated)
+			table_changed = 1;
+		hfi_hdr++;
+	}
+	raw_spin_unlock_irq(&hfi_instance->table_lock);
+
+	return table_changed;
+}
+EXPORT_SYMBOL_GPL(intel_hfi_build_virt_table);
-- 
2.34.1



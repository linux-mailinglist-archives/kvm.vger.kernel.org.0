Return-Path: <kvm+bounces-7907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84CBD8484B7
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:03:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AEA928F3F6
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB675FB9A;
	Sat,  3 Feb 2024 09:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lv0ZZ78y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761195FB83;
	Sat,  3 Feb 2024 09:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950851; cv=none; b=fHeZwbKTNjarx3IS7Q92Jc/QS/tfcmvw7IufGPcZseUYfbXuPtmFIi+W/PsSCuz9HcubKbV8mOMSvez1HknofAK9oI+actTdbSnjj77aN7hfiLeCMJQj0YYO1Fwo974pWt0vTjaym5a/pWevofei4m433kAT4gZcOJLGn+f6+bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950851; c=relaxed/simple;
	bh=uBmYyQNd4eTBcQAihNRXZaPJbPctc/7AfMfj011jqn8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m/qxnLW42ehZVz9dRh7gW7n9o3iby0j3df2/Vo7wiIHc/np/7gTtcCpQMyFs5fOowzuz72bFHlUe69d7xDRx5rc0fwGdiLRo636gJLOP+64zGojyGwxNgvf40nFN6VB4h8EzbdxYX4QyXyFPYfFuVYjx9Ztr5KNQ3O1DgfU/05w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lv0ZZ78y; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950850; x=1738486850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uBmYyQNd4eTBcQAihNRXZaPJbPctc/7AfMfj011jqn8=;
  b=lv0ZZ78yF8yFPdKFWxEszGiWsvN8JWMHvxW+p3Doa4poWzjH1xQ5+oRH
   7RKfIboBvBDzDt3nb0wvlXGDRDCc97eiD/ZZ8geGWEuv8EavfqtRIOK28
   8RyXaSLG2Vfk0V9rZjqbQGDqm+Q8DjRoQY4QWA/74p/pu4pN4HzcD03qa
   npUDM39/H8X96v3CzS1rCL+lm7awhwy6y2y6wU+8Puo5UHlrMBwZJahNp
   CQi82saLLiWq0UFH8G3vlcyJjFd5EpcyN+QV+F1etiVP8nGw9+XaV4zUS
   4f10dYPdrjL/7Y6WfDulrtsQfzRHairNyt0SdTUKQqgIaY1F74uALP8xv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4131993"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4131993"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:00:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291356"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:00:43 -0800
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
Subject: [RFC 11/26] KVM: VMX: Introduce HFI description structure
Date: Sat,  3 Feb 2024 17:11:59 +0800
Message-Id: <20240203091214.411862-12-zhao1.liu@linux.intel.com>
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

From: Zhao Liu <zhao1.liu@intel.com>

HFI/ITD virtualization needs to maintain the virtual HFI table in KVM.

This virtual HFI table is used to sync the update of Host's HFI table,
and then KVM will write this virtual table into Guest's HFI table
address.

Along with the sync process, the KVM also needs to know the status of
the Guest HFI.

Therefore, provide the hfi_desc structure to store the following things:
* The state flags of Guest HFI.
* The basic information of Guest HFI.
* The local virtual HFI table.

The PTS feature is emulated at VM level, so also support hfi_desc at VM
level.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c |  2 ++
 arch/x86/kvm/vmx/vmx.h | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 45b40a47b448..48f304683d6f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8386,7 +8386,9 @@ static void vmx_hardware_unsetup(void)
 static void vmx_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
+	struct hfi_desc *kvm_vmx_hfi = &kvm_vmx->pkg_therm.hfi_desc;
 
+	kfree(kvm_vmx_hfi->hfi_table.base_addr);
 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 5723780da180..4bf4ca6ac1c0 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -7,6 +7,7 @@
 #include <asm/kvm.h>
 #include <asm/intel_pt.h>
 #include <asm/perf_event.h>
+#include <asm/hfi.h>
 
 #include "capabilities.h"
 #include "../kvm_cache_regs.h"
@@ -369,9 +370,49 @@ struct vcpu_vmx {
 	} shadow_msr_intercept;
 };
 
+/**
+ * struct hfi_desc - Representation of an HFI instance (i.e., a table)
+ * @hfi_enabled:	Flag to indicate whether HFI is enabled at runtime.
+ *			Parsed from the Guest's MSR_IA32_HW_FEEDBACK_CONFIG.
+ * @hfi_int_enabled:	Flag to indicate whether HFI is enabled at runtime.
+ *			Parsed from Guest's MSR_IA32_PACKAGE_THERM_INTERRUPT[bit 25].
+ * @table_ptr_valid:	Flag to indicate whether the memory of Guest HFI table is ready.
+ *			Parsed from the valid bit of Guest's MSR_IA32_HW_FEEDBACK_PTR.
+ * @hfi_update_status:	Flag to indicate whether Guest has handled the virtual HFI table
+ *			update.
+ *			Parsed from Guest's MSR_IA32_PACKAGE_THERM_STATUS[bit 26].
+ * @hfi_update_pending:	Flag to indicate whether there's any update on Host that is not
+ *			synced to Guest.
+ *			KVM should update the Guest's HFI table and inject the notification
+ *			until Guest has cleared hfi_update_status.
+ * @table_base:		GPA of Guest's HFI table, which is parsed from Guest's
+ *			MSR_IA32_HW_FEEDBACK_PTR.
+ * @hfi_features:	Feature information based on Guest's HFI/ITD CPUID.
+ * @hfi_table:		Local virtual HFI table based on the HFI data of the pCPU that
+ *			the vCPU is running on.
+ *			When KVM updates the Guest's HFI table, it writes the local
+ *			virtual HFI table to the Guest HFI table memory in @table_base.
+ *
+ * A set of status flags and feature information, used to maintain local virtual HFI table
+ * and sync updates to Guest HFI table.
+ */
+
+struct hfi_desc {
+	bool			hfi_enabled;
+	bool			hfi_int_enabled;
+	bool			table_ptr_valid;
+	bool			hfi_update_status;
+	bool			hfi_update_pending;
+	gpa_t			table_base;
+	struct			hfi_features hfi_features;
+	struct hfi_table	hfi_table;
+};
+
 struct pkg_therm_desc {
 	u64			msr_pkg_therm_int;
 	u64			msr_pkg_therm_status;
+	/* Currently HFI is only supported at package level. */
+	struct hfi_desc		hfi_desc;
 	/* All members before "struct mutex pkg_therm_lock" are protected by the lock. */
 	struct mutex		pkg_therm_lock;
 };
-- 
2.34.1



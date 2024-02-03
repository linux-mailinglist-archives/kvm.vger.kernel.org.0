Return-Path: <kvm+bounces-7909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E23E68484BC
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:04:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 126DC1C28329
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE115FDD7;
	Sat,  3 Feb 2024 09:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JYdl/2He"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5185FDB7;
	Sat,  3 Feb 2024 09:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950862; cv=none; b=khSBATT0lVndlQBILkMyrdEy1saxLdkVadGwReSyn8Aw+u3XU8PUsYyahW1MPhTwhH0ju538heY/EW8ANDmAbN1pf4IebmTTHISP899PTypOFEzho1RxEqQgrhzl+cAdBuPZ2y8onpS8rtFbAMFD+9Z83LaPjIDghtfbD2gBc2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950862; c=relaxed/simple;
	bh=SIIfDj0zX5GYY4IEtDgxTxiCH4JC5qldRU/UOzkQNm0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VjN9MZAPmylvYZzs1RC8YCREskD9bb3Sf+t885xnuWWRuzByUCGMKT8eJfHgcqT1gUvhzg2fb55RZ6EhIsefMS8UbHedIsqxWNC06tYOS2iFrNxu1uDTe3wveiwewRj7TapsH4YbLT5pq+o60LUp3V6vOK63CJE3q4CgcLLhsfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JYdl/2He; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950861; x=1738486861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SIIfDj0zX5GYY4IEtDgxTxiCH4JC5qldRU/UOzkQNm0=;
  b=JYdl/2HeBi52H//58wlbNOnv/kE3XYETHRw0Nr8pWcqgD7jfTIxrHgKf
   /+mN/JKcCJ1d70yJFajX5hpBxnO2XutWkkNlWkpobbELwLXMeTMA0AoQx
   5Mwt+TUj3djuxynDkjLhrg7FwuzWIYUm6UM3VP2TBqVOXNc0GFtg3xNwP
   0XatsHBv/WQe83v60OTIixBPjlG21kEI+01vzyfx7SbgGbiUoOlf9TOTW
   YfQHVVN2TslvCRvQmuXBYMLPl8T16YUrPLFTNfseyWrpJiZ/1fZnPGv8E
   autM435WmNrIjsyT8b8FNWMYLyaWRo3cdiM/dL6WUm7sJNoRjIaM/TZB/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4132017"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4132017"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:01:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291390"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:00:54 -0800
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
Subject: [RFC 13/26] KVM: VMX: Support virtual HFI table for VM
Date: Sat,  3 Feb 2024 17:12:01 +0800
Message-Id: <20240203091214.411862-14-zhao1.liu@linux.intel.com>
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

The Hardware Feedback Interface (HFI) is a feature that allows hardware
to provide guidance to the operating system scheduler through a hardware
feedback interface structure (HFI table) in memory [1], so that the
scheduler can perform optimal workload scheduling.

ITD (Intel Thread Director) and HFI features both depend on the HFI
table, but their HFI tables are slightly different. The HFI table
provided by the ITD feature has 4 classes (in terms of more columns
in the table) and the native HFI feature supports 1 class [2].

In fact, the size of the HFI table is determined by the feature bit that
the processor supports, but the range of data updates in the table
is determined by the feature actually enabled (HFI or ITD) [3], which is
controlled by MSR_IA32_HW_FEEDBACK_CONFIG.

To benefit the scheduling in VM with HFI/ITD, we need to maintain
virtual HFI tables in KVM. The virtual HFI table is based on the real
HFI table. We extract the HFI entries corresponding to the pCPU that the
vCPU is running on, and reorganize these actual entries into a new
virtual HFI table with the vCPU's HFI index.

Also, to simplify the logic, before the emulation of ITD is supported,
we build virtual HFI table based on HFI feature by default (i.e. only 1
class is supported, based on class 0 of real hardware).

Add the interfaces to initialize and build the virtual HFI table, and to
inject the thermal interrupt into the VM to notify about HFI updates.

[1]: SDM, vol. 3B, section 15.6 HARDWARE FEEDBACK INTERFACE AND INTEL
     THREAD DIRECTOR
[2]: SDM, vol. 3B, section 15.6.2 Intel Thread Director Table Structure
[3]: SDM, vol. 3B, section 15.6.5 Hardware Feedback Interface
     Configuration, Table 15-10. IA32_HW_FEEDBACK_CONFIG Control Option

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 119 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 96f0f768939d..7881f6b51daa 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1532,6 +1532,125 @@ static void vmx_inject_therm_interrupt(struct kvm_vcpu *vcpu)
 		kvm_apic_therm_deliver(vcpu);
 }
 
+static inline bool vmx_hfi_initialized(struct kvm_vmx *kvm_vmx)
+{
+	return kvm_vmx->pkg_therm.hfi_desc.hfi_enabled &&
+	       kvm_vmx->pkg_therm.hfi_desc.table_ptr_valid;
+}
+
+static inline bool vmx_hfi_int_enabled(struct kvm_vmx *kvm_vmx)
+{
+	return kvm_vmx->pkg_therm.hfi_desc.hfi_int_enabled;
+}
+
+static int vmx_init_hfi_table(struct kvm *kvm)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
+	struct hfi_desc *kvm_vmx_hfi = &kvm_vmx->pkg_therm.hfi_desc;
+	struct hfi_features *hfi_features = &kvm_vmx_hfi->hfi_features;
+	struct hfi_table *hfi_table = &kvm_vmx_hfi->hfi_table;
+	int nr_classes, ret = 0;
+
+	/*
+	 * Currently we haven't supported ITD. HFI is the default feature
+	 * with 1 class.
+	 */
+	nr_classes = 1;
+	ret = intel_hfi_build_virt_features(hfi_features,
+					    nr_classes,
+					    kvm->created_vcpus);
+	if (unlikely(ret))
+		return ret;
+
+	hfi_table->base_addr = kzalloc(hfi_features->nr_table_pages <<
+				       PAGE_SHIFT, GFP_KERNEL);
+	if (!hfi_table->base_addr)
+		return -ENOMEM;
+
+	hfi_table->hdr = hfi_table->base_addr + sizeof(*hfi_table->timestamp);
+	hfi_table->data = hfi_table->hdr + hfi_features->hdr_size;
+	return 0;
+}
+
+static int vmx_build_hfi_table(struct kvm *kvm)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
+	struct hfi_desc *kvm_vmx_hfi = &kvm_vmx->pkg_therm.hfi_desc;
+	struct hfi_features *hfi_features = &kvm_vmx_hfi->hfi_features;
+	struct hfi_table *hfi_table = &kvm_vmx_hfi->hfi_table;
+	struct hfi_hdr *hfi_hdr = hfi_table->hdr;
+	int nr_classes, ret = 0, updated = 0;
+	struct kvm_vcpu *v;
+	unsigned long i;
+
+	/*
+	 * Currently we haven't supported ITD. HFI is the default feature
+	 * with 1 class.
+	 */
+	nr_classes = 1;
+	for (int j = 0; j < nr_classes; j++) {
+		hfi_hdr->perf_updated = 0;
+		hfi_hdr->ee_updated = 0;
+		hfi_hdr++;
+	}
+
+	kvm_for_each_vcpu(i, v, kvm) {
+		ret = intel_hfi_build_virt_table(hfi_table, hfi_features,
+						 nr_classes,
+						 to_vmx(v)->hfi_table_idx,
+						 v->cpu);
+		if (unlikely(ret < 0))
+			return ret;
+		updated |= ret;
+	}
+
+	if (!updated)
+		return updated;
+
+	/* Timestamp must be monotonic. */
+	(*kvm_vmx_hfi->hfi_table.timestamp)++;
+
+	/* Update the HFI table, whether the HFI interrupt is enabled or not. */
+	kvm_write_guest(kvm, kvm_vmx_hfi->table_base, hfi_table->base_addr,
+			hfi_features->nr_table_pages << PAGE_SHIFT);
+	return 1;
+}
+
+static void vmx_update_hfi_table(struct kvm *kvm)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
+	struct hfi_desc *kvm_vmx_hfi = &kvm_vmx->pkg_therm.hfi_desc;
+	int ret = 0;
+
+	if (!intel_hfi_enabled())
+		return;
+
+	if (!vmx_hfi_initialized(kvm_vmx))
+		return;
+
+	if (!kvm_vmx_hfi->hfi_table.base_addr) {
+		ret = vmx_init_hfi_table(kvm);
+		if (unlikely(ret))
+			return;
+	}
+
+	ret = vmx_build_hfi_table(kvm);
+	if (ret <= 0)
+		return;
+
+	kvm_vmx_hfi->hfi_update_status = true;
+	kvm_vmx_hfi->hfi_update_pending = false;
+
+	/*
+	 * Since HFI is shared for all vCPUs of the same VM, we
+	 * actually support only 1 package topology VMs, so when
+	 * emulating package level interrupt, we only inject an
+	 * interrupt into one vCPU to reduce the overhead.
+	 */
+	if (vmx_hfi_int_enabled(kvm_vmx))
+		vmx_inject_therm_interrupt(kvm_get_vcpu(kvm, 0));
+}
+
 /*
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
-- 
2.34.1



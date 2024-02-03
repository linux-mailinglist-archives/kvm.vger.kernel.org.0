Return-Path: <kvm+bounces-7911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF01D8484C3
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:05:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 210D3B2A2E9
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8152C60277;
	Sat,  3 Feb 2024 09:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PTSqnYHo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B81A60270;
	Sat,  3 Feb 2024 09:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950873; cv=none; b=MZwWisrT+LS4zOuUH96ZCS5yIOHV783Qhado8YJqi0Bk0jlLhNoVEwhDnzAjTVBqB+K4buhRAEl+1Fm96xjHwJh0KS9v797I27uEAZl1UOYLdzFOOACZU/v+Fei1g9uCNSMmKd6KHu0XcjAGtHEPnGkLd5Jgsdb/aB7iJDXRxlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950873; c=relaxed/simple;
	bh=6sr4GCiFFLTfE8DEtWSDum9V0+zRPamVMwEHqH2SYw0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d19L3x5MNiskiHTsaP5Yq+/4wfbs+yjn1eCLjJHBGjLi/V8HRel0UoW0/9Brgbw/N0rSvq6PzP+Ya95PqJ2F4kFQBlGmVMn/DBiVWNuhGVn7Spouvv7hpVnfniwasT43hJS7j4qzPvR3r/P8PPglN32UwL4MNHRpamWbPaRY9+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PTSqnYHo; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950872; x=1738486872;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6sr4GCiFFLTfE8DEtWSDum9V0+zRPamVMwEHqH2SYw0=;
  b=PTSqnYHo/xv1pvxEecK9sDeuLcw+ho3TsV0PnIVw1auIeJQ0WTXDXRxI
   NgyMdDJmeXTEbTT059lbzeIYoncdb+c6JXrargq2uCWMtasuNnth6PeKz
   PJH0cwRkcz2FtzUnnVIam49bWwKg+bqEMlgP9iHCvJYHiBbgydmBD5kbL
   lUAcXYxSMjO8kzO2fOrHeUu4w4qPLBLccQ5VeNeaPa+DTU1yWjCSGfd0/
   SOAfgu+xhTAej0dDFiU+WNh9+//hIp4R3qLPZoEGTIuQSWXSZwk1smvIm
   rDcySKvtm4xQSA9HgUhyrpSVkT8jRmlfprkQBJWv6i+FULw72gA2EfKrk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4132041"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4132041"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:01:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291438"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:01:06 -0800
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
Subject: [RFC 15/26] KVM: VMX: Sync update of Host HFI table to Guest
Date: Sat,  3 Feb 2024 17:12:03 +0800
Message-Id: <20240203091214.411862-16-zhao1.liu@linux.intel.com>
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

The HFI table could be updated via thermal interrupt as the actual
operating conditions of the processor change during runtime [1], so it
is required to synchronize hardware hint changes to Guest's HFI table in
time.

Provide the interfaces to register/unregister the Host's HFI update,
and in the callback of the notification, make HFI update request to
update Guest's HFI table before entering Guest.

[1]: SDM, vol. 3B, section 15.6.7 Hardware Feedback Interface and Intel
     Thread Director Structure Dynamic Update

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 59 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  8 ++++++
 2 files changed, 67 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 93c47ba0817b..0ad5e3473a28 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1651,6 +1651,61 @@ static void vmx_update_hfi_table(struct kvm *kvm)
 		vmx_inject_therm_interrupt(kvm_get_vcpu(kvm, 0));
 }
 
+static void vmx_hfi_notifier_register(struct kvm *kvm)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
+	struct hfi_desc *kvm_vmx_hfi = &kvm_vmx->pkg_therm.hfi_desc;
+
+	if (!intel_hfi_enabled())
+		return;
+
+	if (!vmx_hfi_initialized(kvm_vmx))
+		return;
+
+	if (kvm_vmx_hfi->has_hfi_instance)
+		return;
+
+	/*
+	 * HFI/ITD virtualization is supported on the platforms with only
+	 * 1 HFI instance. Just register notifier for vCPU 0.
+	 */
+	kvm_vmx_hfi->has_hfi_instance =
+		!intel_hfi_notifier_register(&kvm_vmx_hfi->hfi_nb,
+					     kvm_get_vcpu(kvm, 0)->cpu);
+}
+
+static void vmx_hfi_notifier_unregister(struct kvm *kvm)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
+	struct hfi_desc *kvm_vmx_hfi = &kvm_vmx->pkg_therm.hfi_desc;
+
+	if (!kvm_vmx_hfi->has_hfi_instance)
+		return;
+
+	intel_hfi_notifier_unregister(&kvm_vmx_hfi->hfi_nb,
+				      kvm_get_vcpu(kvm, 0)->cpu);
+	kvm_vmx_hfi->has_hfi_instance = false;
+}
+
+static int vmx_hfi_update_notify(struct notifier_block *nb,
+				 unsigned long code, void *data)
+{
+	struct hfi_desc *kvm_vmx_hfi;
+	struct kvm *kvm;
+
+	kvm_vmx_hfi = container_of(nb, struct hfi_desc, hfi_nb);
+	kvm = &kvm_vmx_hfi->vmx->kvm;
+
+	/*
+	 * Don't need to check if vcpu 0 belongs to
+	 * kvm_vmx_hfi->host_hfi_instance since currently ITD/HFI
+	 * virtualization is only supported for client platforms
+	 * (with only one HFI instance).
+	 */
+	kvm_make_request(KVM_REQ_HFI_UPDATE, kvm_get_vcpu(kvm, 0));
+	return NOTIFY_OK;
+}
+
 static void vmx_dynamic_update_hfi_table(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
@@ -7871,8 +7926,11 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 static int vmx_vm_init_pkg_therm(struct kvm *kvm)
 {
 	struct pkg_therm_desc *pkg_therm = &to_kvm_vmx(kvm)->pkg_therm;
+	struct hfi_desc *kvm_vmx_hfi = &pkg_therm->hfi_desc;
 
 	mutex_init(&pkg_therm->pkg_therm_lock);
+	kvm_vmx_hfi->hfi_nb.notifier_call = vmx_hfi_update_notify;
+	kvm_vmx_hfi->vmx = to_kvm_vmx(kvm);
 	return 0;
 }
 
@@ -8542,6 +8600,7 @@ static void vmx_vm_destroy(struct kvm *kvm)
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 	struct hfi_desc *kvm_vmx_hfi = &kvm_vmx->pkg_therm.hfi_desc;
 
+	vmx_hfi_notifier_unregister(kvm);
 	kfree(kvm_vmx_hfi->hfi_table.base_addr);
 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 63874aad7ae3..ff205bc0e99a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -395,6 +395,11 @@ struct vcpu_vmx {
  *			the vCPU is running on.
  *			When KVM updates the Guest's HFI table, it writes the local
  *			virtual HFI table to the Guest HFI table memory in @table_base.
+ * @has_hfi_instance:	Flag indicates if VM registers @hfi_nb on Host's HFI instance.
+ * @hfi_nb:		Notifier block to be registered in Host HFI instance.
+ * @vmx:		Points to the kvm_vmx where the current nb is located.
+ *			Used to get the corresponding kvm_vmx of the nb when it
+ *			is executed.
  *
  * A set of status flags and feature information, used to maintain local virtual HFI table
  * and sync updates to Guest HFI table.
@@ -409,6 +414,9 @@ struct hfi_desc {
 	gpa_t			table_base;
 	struct			hfi_features hfi_features;
 	struct hfi_table	hfi_table;
+	bool			has_hfi_instance;
+	struct notifier_block	hfi_nb;
+	struct kvm_vmx		*vmx;
 };
 
 struct pkg_therm_desc {
-- 
2.34.1



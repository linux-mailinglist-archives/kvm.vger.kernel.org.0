Return-Path: <kvm+bounces-36834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 748B0A21AA1
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 11:01:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B34073A546A
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 10:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF30517C68;
	Wed, 29 Jan 2025 10:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FZvHnlrt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98971D8DE1;
	Wed, 29 Jan 2025 10:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738144818; cv=none; b=FFfQEg36QwHtbgOn5NqIKfbeNlcI2nvLvMi4BnFvsQtlmjBc88heM7xI8Yce9pFxu3aB4ItIewikXD5ClquwdfOv/MSYVZNrsWagQJXt+VfpEY/3gS/BYtEa3KrgyeosCY9hFoob+EyUD7VAlnk26T0cS/vjKWdycjC7rFog5KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738144818; c=relaxed/simple;
	bh=hdpIBn+tieTlQleqs77ck9auMv6P1U0+XxdcR00jtGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=en3EyeBoHWWeLCEV1LZ1Aa3ZC6gn3k6nWugMhjUNzILoUr+aiBGoIlRJmDGW9+rFPFkIyxU4kWgj7R87nuxpcN8qMhvE+WO0nUFw9mPaxcGaiYvx6Tj5VDsND+TTg+gsJeubThWXvQINzy2PF7I/BQBJ4WP/JoGjmBJAP2Ptl44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FZvHnlrt; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738144817; x=1769680817;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hdpIBn+tieTlQleqs77ck9auMv6P1U0+XxdcR00jtGc=;
  b=FZvHnlrtCegSgFKWMB7CUNJDzbBNBabSSz1O1vSXnhX1R/X8zamSKbdO
   OR0o4Q4TmK+3bN8IEkBmB1xx2y84AE3Nwnfa2hhvd1ItHN9mLjGT8lpQE
   ljKRBmvsnHjw23JKhyVBFo37wNmuwxvTgz1xfHfoYzDm8cXq1rVRZQ0TO
   E29cNT30tMQ/QoOhPF5yRAEfjWN0WnfnbWGmq9vYIB/dan5E832jbErLN
   6vcky/QJdnt+0NBD/3erFyif+B/qKz7THzguBuU+/7lvD44yz6qtaEDJF
   ZE6J5hNB0tEWmVzpPul7Ros4iVgoK6bXvCqN0t1jm3RVTsN5Leb1pswQe
   A==;
X-CSE-ConnectionGUID: kgI+RWeQQWqR6LYs9pBGZA==
X-CSE-MsgGUID: OhsimM8tQBWO9MF0IiYeiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11329"; a="50036029"
X-IronPort-AV: E=Sophos;i="6.13,243,1732608000"; 
   d="scan'208";a="50036029"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 01:59:48 -0800
X-CSE-ConnectionGUID: CuwF7LN0R9WFQe0xlP0/aQ==
X-CSE-MsgGUID: 3mc4e47wTaul4J3Sl8PlIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="132262689"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.0.178])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 01:59:44 -0800
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH V2 06/12] KVM: TDX: vcpu_run: save/restore host state(host kernel gs)
Date: Wed, 29 Jan 2025 11:58:55 +0200
Message-ID: <20250129095902.16391-7-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250129095902.16391-1-adrian.hunter@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

On entering/exiting TDX vcpu, preserved or clobbered CPU state is different
from the VMX case. Add TDX hooks to save/restore host/guest CPU state.
Save/restore kernel GS base MSR.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TD vcpu enter/exit v2:
 - Use 1 variable named 'guest_state_loaded' to track host state
   save/restore (Sean)
 - Rebased due to moving guest_state_loaded/msr_host_kernel_gs_base
   to struct vcpu_vt.

TD vcpu enter/exit v1:
 - Clarify comment (Binbin)
 - Use lower case preserved and add the for VMX in log (Tony)
 - Fix bisectability issue with includes (Kai)
---
 arch/x86/kvm/vmx/main.c    | 24 +++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 40 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  4 ++++
 3 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 301c1a26606f..341aa537ca72 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -133,6 +133,26 @@ static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vmx_vcpu_load(vcpu, cpu);
 }
 
+static void vt_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_prepare_switch_to_guest(vcpu);
+		return;
+	}
+
+	vmx_prepare_switch_to_guest(vcpu);
+}
+
+static void vt_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_vcpu_put(vcpu);
+		return;
+	}
+
+	vmx_vcpu_put(vcpu);
+}
+
 static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -253,9 +273,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_free = vt_vcpu_free,
 	.vcpu_reset = vt_vcpu_reset,
 
-	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
+	.prepare_switch_to_guest = vt_prepare_switch_to_guest,
 	.vcpu_load = vt_vcpu_load,
-	.vcpu_put = vmx_vcpu_put,
+	.vcpu_put = vt_vcpu_put,
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
 	.get_feature_msr = vmx_get_feature_msr,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 95420ffd0022..3f3d61935a58 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2,6 +2,7 @@
 #include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <asm/cpufeature.h>
+#include <linux/mmu_context.h>
 #include <asm/tdx.h>
 #include "capabilities.h"
 #include "mmu.h"
@@ -11,6 +12,7 @@
 #include "vmx.h"
 #include "mmu/spte.h"
 #include "common.h"
+#include "posted_intr.h"
 #include <trace/events/kvm.h>
 #include "trace.h"
 
@@ -642,6 +644,44 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	local_irq_enable();
 }
 
+/*
+ * Compared to vmx_prepare_switch_to_guest(), there is not much to do
+ * as SEAMCALL/SEAMRET calls take care of most of save and restore.
+ */
+void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vt *vt = to_vt(vcpu);
+
+	if (vt->guest_state_loaded)
+		return;
+
+	if (likely(is_64bit_mm(current->mm)))
+		vt->msr_host_kernel_gs_base = current->thread.gsbase;
+	else
+		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
+
+	vt->guest_state_loaded = true;
+}
+
+static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vt *vt = to_vt(vcpu);
+
+	if (!vt->guest_state_loaded)
+		return;
+
+	++vcpu->stat.host_state_reload;
+	wrmsrl(MSR_KERNEL_GS_BASE, vt->msr_host_kernel_gs_base);
+
+	vt->guest_state_loaded = false;
+}
+
+void tdx_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	vmx_vcpu_pi_put(vcpu);
+	tdx_prepare_switch_to_host(vcpu);
+}
+
 void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 83aac44b779b..f856eac8f1e8 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -133,6 +133,8 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
+void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
+void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -165,6 +167,8 @@ static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediat
 {
 	return EXIT_FASTPATH_NONE;
 }
+static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
+static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.43.0



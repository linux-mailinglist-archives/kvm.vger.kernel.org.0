Return-Path: <kvm+bounces-7910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08FE28484BF
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:05:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3980290357
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C635FF13;
	Sat,  3 Feb 2024 09:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WUvoFJal"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7325FEF8;
	Sat,  3 Feb 2024 09:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950868; cv=none; b=uqTvmk30TqcNMYNXiY2DDSVk4NyEZwa6C+JymrqDwGkLcUVk9NIgfXa5N6nAVTvQmkZG1ejlgWirgsHFZadqQ0MyYBxJKQJw0rSQm/S1ATf7bviHX2uUfwdpPBcg+udqLOI8tGjFgIanm1v3OFJN4xmYHdGXDqyM3XIrUki6a94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950868; c=relaxed/simple;
	bh=jaSpkN47fYUzN6obTA+Fv5SVXL8pgNQFR+mSAgkAyoY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g1+bRW+MUyYl0Bf8xOvOTxbkWj/bm/qosPckRRpIL7zUqs5qiuwQ8ntutdEBbo+bdkjNEkfexsiz7CkTkWe+/4i1Vz9T8Eqr3vflqqkULYh1mOtbUER9ae810DlFqqccK52Fac9Qd8x+FphyQzg7cC7e7MPhqt/TwT6iuZkqG6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WUvoFJal; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950867; x=1738486867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jaSpkN47fYUzN6obTA+Fv5SVXL8pgNQFR+mSAgkAyoY=;
  b=WUvoFJal5haVfkyljBUyamGtlIUZ1MjP3iQsB8q/hgYQqgp8U9zg9sRY
   VnpoaGiT4v0tOzA2joZnFdBocnopNyXILz1plYCCx8AA/wygz+WrleDeF
   cK1j/8vwYsA9x/8hvw+YhACGGSreULeRyZbA+1SpXrhw8BWiGWqbsEm0e
   dRreTo35TxaG0h78FReEKOWO5zhfgZ1/LMjUXI0aITik3bFIDIN504c/Y
   hhR9xqnnFX3/2YTPKIWVU/zVgnhmMDPvR7xOA6v5gaCpZMpCwdkWVszBh
   J2F6dlfoNrl4EaRMLxrOs9T5oDMItXfRxPK1UQUMGvkwqlfeAX6yZner3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4132038"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4132038"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:01:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291420"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:01:00 -0800
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
Subject: [RFC 14/26] KVM: x86: Introduce the HFI dynamic update request and kvm_x86_ops
Date: Sat,  3 Feb 2024 17:12:02 +0800
Message-Id: <20240203091214.411862-15-zhao1.liu@linux.intel.com>
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

There're 2 cases that we need to update Guest HFI table dynamically:

1. When Host's HFI table has update, we need to sync the change to
   Guest.

2. When vCPU thread migrates to another pCPU, we need rebuild the new
   Guest HFI table based the HFI data of the pCPU that the vCPU is
   running on.

So add the updating mechanism with a new request and a new op to prepare
for the above 2 cases:

- New KVM request type to perform HFI updating at vcpu_enter_guest().
  Updating the VM's HFI table will result in writing to the VM's memory.
  This requires vCPU context, so we pend HFI updates via kvm request
  until vCPU is running. Here we only make request for one vCPU per VM
  because all vCPUs of the same VM share the same HFI table. This allows
  one vCPU to update the HFI table for the entire VM.

- New kvm_x86_op (optional for x86).
  When KVM processes KVM_REQ_HFI_UPDATE, this ops is called to update
  the corresponding HFI table raw for the specified vCPU.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  3 ++-
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/vmx/vmx.c             | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                 |  2 ++
 4 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 378ed944b849..1b16de7a03eb 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -136,8 +136,9 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
-KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons)
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
+KVM_X86_OP_OPTIONAL(update_hfi)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b5b2d0fde579..e476a86b0766 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -121,6 +121,7 @@
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_HFI_UPDATE		KVM_ARCH_REQ(33)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1794,6 +1795,7 @@ struct kvm_x86_ops {
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
 
 	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
+	void (*update_hfi)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7881f6b51daa..93c47ba0817b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1651,6 +1651,35 @@ static void vmx_update_hfi_table(struct kvm *kvm)
 		vmx_inject_therm_interrupt(kvm_get_vcpu(kvm, 0));
 }
 
+static void vmx_dynamic_update_hfi_table(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
+	struct hfi_desc *kvm_vmx_hfi = &kvm_vmx->pkg_therm.hfi_desc;
+
+	if (!intel_hfi_enabled())
+		return;
+
+	mutex_lock(&kvm_vmx->pkg_therm.pkg_therm_lock);
+
+	/*
+	 * If Guest hasn't handled the previous update, just mark a pending
+	 * flag to indicate that Host has more updates that KVM needs to sync.
+	 */
+	if (kvm_vmx_hfi->hfi_update_status) {
+		kvm_vmx_hfi->hfi_update_pending = true;
+		mutex_unlock(&kvm_vmx->pkg_therm.pkg_therm_lock);
+		return;
+	}
+
+	/*
+	 * The virtual HFI table is maintained at VM level so that vCPUs
+	 * of the same VM are sharing the one HFI table. Therefore, one
+	 * vCPU can update the HFI table for the whole VM.
+	 */
+	vmx_update_hfi_table(vcpu->kvm);
+	mutex_unlock(&kvm_vmx->pkg_therm.pkg_therm_lock);
+}
+
 /*
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
@@ -8703,6 +8732,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
 	.get_untagged_addr = vmx_get_untagged_addr,
+	.update_hfi = vmx_dynamic_update_hfi_table,
 };
 
 static unsigned int vmx_handle_intel_pt_intr(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7d787ced513f..bea3def6a4b1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10850,6 +10850,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+		if (kvm_check_request(KVM_REQ_HFI_UPDATE, vcpu))
+			static_call(kvm_x86_update_hfi)(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
-- 
2.34.1



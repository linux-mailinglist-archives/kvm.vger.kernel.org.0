Return-Path: <kvm+bounces-31570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3707F9C4FA1
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:40:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5CD5283141
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E530120C014;
	Tue, 12 Nov 2024 07:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mHM5Lsao"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736241C1AD1;
	Tue, 12 Nov 2024 07:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397115; cv=none; b=Bxsm2l8kxOYDku8bm1X85eqccDFN+QMMf1U2f14exH6QzVMfyjq8w8DkZC3Yl5kCMt+HTuPmRiPpdlPRGBTXjAecYl1iIOPZZKCldqw11LuBs+Un7i+OJ1+BpZSQLjPM6bm1wDVaPhL6Jn+P3lLmEyrxarw3aFPhJDewmusD2Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397115; c=relaxed/simple;
	bh=sN9nijE9CbITTXnFl8o4aImSrCwVmYnOzQ3JNw75nO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u08xkqlIyJPT/B5qXW2/0eeN62uG9j0bO+mcDUM55/4O7/7jrUgU0i+j/4m8NcTuYfP9TETt4VciTlUWWkYo5z1t8P+Ig0g5kn+ALB6MH+8JTDfUgmULXZsFaC0ag5d2jpwfrImk/nSRPRlW20ouf7di1cW9HwJ/16Gb+doYrps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mHM5Lsao; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397113; x=1762933113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sN9nijE9CbITTXnFl8o4aImSrCwVmYnOzQ3JNw75nO0=;
  b=mHM5Lsaogo2egUOEtqZHUGQMXbV5slEF6r4m4tT7h7oJud+ioC14RLyR
   IzpyulcfRqyJv+8OB82reuN5cZHIfEifnaWNoGTPcIEpjWVMWSZrUNT9C
   tQRB8wCnp3/q/d9RvQUDmNZVCF3zl6YJyDBcmL9bCvD+NZVOZNoS99FJ/
   xdEZ3/q2Juxtt7hSAppYwKoJXJ6uQbc7noMaXojUTnEDdfZAmUCkR1x6F
   leitfpsGenpMk37XTtbAkc1svLGaTutEc5YRn73uP+Dx0DQFdBa7x4PUa
   wv0EhDcvFpyVUBSkH/zKf0znUthahCPOiIEln8d5n/GYwspvLWppiN5iw
   A==;
X-CSE-ConnectionGUID: tUwHEn1NQ+O9//LFyUbpSQ==
X-CSE-MsgGUID: 4kdYjOz4Q72UoSlcRZsNmg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31389325"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31389325"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:38:33 -0800
X-CSE-ConnectionGUID: v947A+FzS7yrcfp0f4V+Fw==
X-CSE-MsgGUID: APiAnDlnTGCyF4dRgxMmAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="87736007"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:38:28 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 07/24] KVM: TDX: Add load_mmu_pgd method for TDX
Date: Tue, 12 Nov 2024 15:36:01 +0800
Message-ID: <20241112073601.22084-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX uses two EPT pointers, one for the private half of the GPA space and
one for the shared half. The private half uses the normal EPT_POINTER vmcs
field, which is managed in a special way by the TDX module. For TDX, KVM is
not allowed to operate on it directly. The shared half uses a new
SHARED_EPT_POINTER field and will be managed by the conventional MMU
management operations that operate directly on the EPT root. This means for
TDX the .load_mmu_pgd() operation will need to know to use the
SHARED_EPT_POINTER field instead of the normal one. Add a new wrapper in
x86 ops for load_mmu_pgd() that either directs the write to the existing
vmx implementation or a TDX one.

tdx_load_mmu_pgd() is so much simpler than vmx_load_mmu_pgd() since for the
TDX mode of operation, EPT will always be used and KVM does not need to be
involved in virtualization of CR3 behavior. So tdx_load_mmu_pgd() can
simply write to SHARED_EPT_POINTER.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX MMU part 2 v2:
-Check shared EPT level matches to direct bits mask in tdx_load_mmu_pgd()
 (Chao Gao)

TDX MMU part 2 v1:
- update the commit msg with the version rephrased by Rick.
  https://lore.kernel.org/all/78b1024ec3f5868e228baf797c6be98c5397bd49.camel@intel.com/

v19:
- Add WARN_ON_ONCE() to tdx_load_mmu_pgd() and drop unconditional mask
---
 arch/x86/include/asm/vmx.h |  1 +
 arch/x86/kvm/vmx/main.c    | 13 ++++++++++++-
 arch/x86/kvm/vmx/tdx.c     | 15 +++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  4 ++++
 4 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index f7fd4369b821..9298fb9d4bb3 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -256,6 +256,7 @@ enum vmcs_field {
 	TSC_MULTIPLIER_HIGH             = 0x00002033,
 	TERTIARY_VM_EXEC_CONTROL	= 0x00002034,
 	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
+	SHARED_EPT_POINTER		= 0x0000203C,
 	PID_POINTER_TABLE		= 0x00002042,
 	PID_POINTER_TABLE_HIGH		= 0x00002043,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d28ffddd766f..3c292b4a063a 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -98,6 +98,17 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx_vcpu_reset(vcpu, init_event);
 }
 
+static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
+			    int pgd_level)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
+		return;
+	}
+
+	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -229,7 +240,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.write_tsc_offset = vmx_write_tsc_offset,
 	.write_tsc_multiplier = vmx_write_tsc_multiplier,
 
-	.load_mmu_pgd = vmx_load_mmu_pgd,
+	.load_mmu_pgd = vt_load_mmu_pgd,
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ed4473d0c2cd..785ee9f95504 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -28,6 +28,9 @@
 bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
 
+#define TDX_SHARED_BIT_PWL_5 gpa_to_gfn(BIT_ULL(51))
+#define TDX_SHARED_BIT_PWL_4 gpa_to_gfn(BIT_ULL(47))
+
 static enum cpuhp_state tdx_cpuhp_state;
 
 static const struct tdx_sys_info *tdx_sysinfo;
@@ -495,6 +498,18 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
 }
 
+
+void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
+{
+	u64 shared_bit = (pgd_level == 5) ? TDX_SHARED_BIT_PWL_5 :
+			  TDX_SHARED_BIT_PWL_4;
+
+	if (KVM_BUG_ON(shared_bit != kvm_gfn_direct_bits(vcpu->kvm), vcpu->kvm))
+		return;
+
+	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 4739891858ea..f49135094c94 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -129,6 +129,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
+
+void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
@@ -140,6 +142,8 @@ static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
+
+static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.43.2



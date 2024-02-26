Return-Path: <kvm+bounces-9689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21FB4866CEA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:48:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EA9D1C216D9
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F33A562A13;
	Mon, 26 Feb 2024 08:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aIcQMgsv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4843D612E9;
	Mon, 26 Feb 2024 08:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936107; cv=none; b=dmVpCdUd9iZg9MoLK6YvHsgVEj0HAnzs4lwXEK+a+uU+gBzonhwM4xhkEY07tGyNFr3O+u+lVGhXT1OHze9KjEsZdVt0MmqBOAiC5Cb8YP9UHLw3G2RdAoIYf7Pvl3+oeXyFGm5mU60U9EYgFLCoWcpZvWa89QQTiUQRLd9dXLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936107; c=relaxed/simple;
	bh=wWbhRZCirvnTpoR7lG5s4eITsW63C8P/4FabG1p/CFY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vA9DtJmiF3Btqgxb5A0x0HAHaMG1V6EtFrsObdPKeLabL6r7PFgs+hIAG2tKdYbmouChRD8XM7OZN4upQQ/Lfq0S2kCno+NNctbrNX+8i2y8CfaoHGsrI+XuwD5yGlZFOWP+/HTTFdEKiaTMBI2bjhajCnICynjYmxjBZpyFJCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aIcQMgsv; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936106; x=1740472106;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wWbhRZCirvnTpoR7lG5s4eITsW63C8P/4FabG1p/CFY=;
  b=aIcQMgsvBi0xaOZk6Q8j+bmyuRUUHtNOiGzlDxQC05zUoik7puaubR/G
   aZOjJSJOcmwfJrXBNhnBHPeIKLTB1qcBgfslfKTIoexJiTCJJMzOuyeU9
   2OwZblamdyzE5BC35qErdsHabqWbvI2WoNniaABZuUFKdejtSd/s2X59t
   QaxXEn6H4S1WNt/2jChBHIO5Ep5cliM12529Ap45RWup9AAgfJh482r+m
   hjd08H6MCRo/FTtPwZVheCQD3ha7LoFIe4gttONSXvKSt7XeB/HeKiPqA
   aRZFe1ZuQxqLaDAoijaq8S0fnH2kUEDxy9rIvBh/viUk/ugQwuffrrQIK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069454"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069454"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272356"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:25 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v19 067/130] KVM: TDX: Add load_mmu_pgd method for TDX
Date: Mon, 26 Feb 2024 00:26:09 -0800
Message-Id: <bef7033b687e75c5436c0aee07691327d36734ea.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <sean.j.christopherson@intel.com>

For virtual IO, the guest TD shares guest pages with VMM without
encryption.  Shared EPT is used to map guest pages in unprotected way.

Add the VMCS field encoding for the shared EPTP, which will be used by
TDX to have separate EPT walks for private GPAs (existing EPTP) versus
shared GPAs (new shared EPTP).

Set shared EPT pointer value for the TDX guest to initialize TDX MMU.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
v19:
- Add WARN_ON_ONCE() to tdx_load_mmu_pgd() and drop unconditional mask
---
 arch/x86/include/asm/vmx.h |  1 +
 arch/x86/kvm/vmx/main.c    | 13 ++++++++++++-
 arch/x86/kvm/vmx/tdx.c     |  6 ++++++
 arch/x86/kvm/vmx/x86_ops.h |  4 ++++
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index f703bae0c4ac..9deb663a42e3 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -236,6 +236,7 @@ enum vmcs_field {
 	TSC_MULTIPLIER_HIGH             = 0x00002033,
 	TERTIARY_VM_EXEC_CONTROL	= 0x00002034,
 	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
+	SHARED_EPT_POINTER		= 0x0000203C,
 	PID_POINTER_TABLE		= 0x00002042,
 	PID_POINTER_TABLE_HIGH		= 0x00002043,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d0f75020579f..076a471d9aea 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -123,6 +123,17 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx_vcpu_reset(vcpu, init_event);
 }
 
+static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
+			int pgd_level)
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
@@ -256,7 +267,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.write_tsc_offset = vmx_write_tsc_offset,
 	.write_tsc_multiplier = vmx_write_tsc_multiplier,
 
-	.load_mmu_pgd = vmx_load_mmu_pgd,
+	.load_mmu_pgd = vt_load_mmu_pgd,
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 54e0d4efa2bd..143a3c2a16bc 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -453,6 +453,12 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 */
 }
 
+void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
+{
+	WARN_ON_ONCE(root_hpa & ~PAGE_MASK);
+	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f5820f617b2e..24161fa404aa 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -152,6 +152,8 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
+
+void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
 static inline void tdx_hardware_unsetup(void) {}
@@ -173,6 +175,8 @@ static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
+
+static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1



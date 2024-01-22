Return-Path: <kvm+bounces-6637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BEBF383780B
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:05:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F18951C23655
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3AE4634EF;
	Mon, 22 Jan 2024 23:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QIdut9Bj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83494627E0;
	Mon, 22 Jan 2024 23:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967748; cv=none; b=darUoWdvYLtpyRxodZgmvICWMVZK2/LAKmeAQUTEwou81cYnTIibO2q/B/a3dfqsyUNdxV/PiLEpxEFXNRB/pC6Kr0rvLDMdj03eWiCf0fAQ3NhEkr8AbYd2RtRLhAGnO5sTEWIfYkousNfnxcnP0vxlGel6EtI8IWSPzqGU0tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967748; c=relaxed/simple;
	bh=zKaBGbGH7e4OllCsWw3QTSDrQE1Me/woj15J6Xjwq5U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c7KuZdXR7GsLWWsoxFe5CpxKp/tZ9Q7zsqUsU3vqJISfCo3x5Ul/zSkAcjlZmYt3fplLZV0vXFHVNS6bbFK34bMy5XSPekKm5JN+d1P0Vyhk3dQqeGUtxfhAZW+ixQcRtDDo3O3/Nnq3nYT4uaavvGeybfXADjc6Aww1DyQky1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QIdut9Bj; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967747; x=1737503747;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zKaBGbGH7e4OllCsWw3QTSDrQE1Me/woj15J6Xjwq5U=;
  b=QIdut9BjugATXUp/YpWqAkaAuVnXtoLeCDh7bdV9o8BAYK6EGGfoO4IT
   T+DQkhUKtOmEFCe+7x8+LRQX5WIs9QAGPrYaWWKlzL08YWhrsq1+2J+lq
   gJVmLhZlhCxNsdYLCiXQ9/K2JvAYlAy4x1bEn7jo97KdQhGxPXVSMzkWL
   gemBIb0aZUNJG/EMwIAc2J25PtPJpHLlUp1LnZhdNmxuroQ+ySPngfdZg
   WQ70G3oHgBfmgYzFgRFfaR4vbCIqv92UmFXWIcxmW8hb5zLmUAUBdf1wN
   s0oyqXZudfqEqFmjH5UhYCKoBoxH8BnujT9N8+wkOzTL6PrnyIsAGDUTh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016429"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016429"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468176"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:34 -0800
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
Subject: [PATCH v18 057/121] KVM: TDX: Add load_mmu_pgd method for TDX
Date: Mon, 22 Jan 2024 15:53:33 -0800
Message-Id: <bd5256f2f58c36c6e8712e8137525815eede3bc8.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
 arch/x86/include/asm/vmx.h |  1 +
 arch/x86/kvm/vmx/main.c    | 13 ++++++++++++-
 arch/x86/kvm/vmx/tdx.c     |  5 +++++
 arch/x86/kvm/vmx/x86_ops.h |  4 ++++
 4 files changed, 22 insertions(+), 1 deletion(-)

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
index 8059b44ed159..f55ac09edc60 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -147,6 +147,17 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
@@ -279,7 +290,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.write_tsc_offset = vmx_write_tsc_offset,
 	.write_tsc_multiplier = vmx_write_tsc_multiplier,
 
-	.load_mmu_pgd = vmx_load_mmu_pgd,
+	.load_mmu_pgd = vt_load_mmu_pgd,
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 59d170709f82..25510b6740a3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -501,6 +501,11 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 */
 }
 
+void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
+{
+	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 5f8ee1c93cd1..a9e5caf880dd 100644
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



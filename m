Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B8A367E53
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 12:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235776AbhDVKGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 06:06:08 -0400
Received: from mga04.intel.com ([192.55.52.120]:61845 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230365AbhDVKGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 06:06:08 -0400
IronPort-SDR: Ra5cdHO+EnC+jI8TotVuI/Y38d+56wCkQxNG7HGyZIB/tmdZGNvknwi5wAkrEQszL+OYJbgz2C
 BGCL26cWg7jQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="193741594"
X-IronPort-AV: E=Sophos;i="5.82,242,1613462400"; 
   d="scan'208";a="193741594"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 03:05:34 -0700
IronPort-SDR: 1dY0dZtYItqsDBSd4QVe4rceXdSVeWHvuwKWlec2TwK7z2K0Oks+alxsCUmH009Xf8uUwP534R
 29RFLsMB8HXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,242,1613462400"; 
   d="scan'208";a="421317119"
Received: from icx-2s.bj.intel.com ([10.240.192.119])
  by fmsmga008.fm.intel.com with ESMTP; 22 Apr 2021 03:05:32 -0700
From:   Yang Zhong <yang.zhong@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yang.zhong@intel.com
Subject: [PATCH 1/2] KVM: VMX: Keep registers read/write consistent with definition
Date:   Thu, 22 Apr 2021 17:34:35 +0800
Message-Id: <20210422093436.78683-2-yang.zhong@intel.com>
X-Mailer: git-send-email 2.29.2.334.gfaefdd61ec
In-Reply-To: <20210422093436.78683-1-yang.zhong@intel.com>
References: <20210422093436.78683-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_cache_regs.h file has defined inline functions for those general
purpose registers and pointer register read/write operations, we need keep
those related registers operations consistent with header file definition
in the VMX side.

Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 29b40e092d13..d56505fc7a71 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2266,10 +2266,10 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 
 	switch (reg) {
 	case VCPU_REGS_RSP:
-		vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
+		kvm_rsp_write(vcpu, vmcs_readl(GUEST_RSP));
 		break;
 	case VCPU_REGS_RIP:
-		vcpu->arch.regs[VCPU_REGS_RIP] = vmcs_readl(GUEST_RIP);
+		kvm_rip_write(vcpu, vmcs_readl(GUEST_RIP));
 		break;
 	case VCPU_EXREG_PDPTR:
 		if (enable_ept)
@@ -4432,7 +4432,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmx->msr_ia32_umwait_control = 0;
 
-	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
+	kvm_rdx_write(&vmx->vcpu, get_rdx_init_val());
 	vmx->hv_deadline_tsc = -1;
 	kvm_set_cr8(vcpu, 0);
 
@@ -6725,9 +6725,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	WARN_ON_ONCE(vmx->nested.need_vmcs12_to_shadow_sync);
 
 	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RSP))
-		vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
+		vmcs_writel(GUEST_RSP, kvm_rsp_read(vcpu));
+
 	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RIP))
-		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
+		vmcs_writel(GUEST_RIP, kvm_rip_read(vcpu));
 
 	cr3 = __get_current_cr3_fast();
 	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
-- 
2.29.2.334.gfaefdd61ec


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B857142F1
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbjE2E0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbjE2EZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:25:57 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF932E4A;
        Sun, 28 May 2023 21:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334222; x=1716870222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gnAqpLfxkwFpfcIMhCyVawhSkuUR7G1heaRIChIx9b8=;
  b=leykFKDQw87607e10Gl91zv3RTURE0FUueVRJsJeOuDU0DQpi+KfmQt3
   EjDmbqo+U813xnqrb3dsz9maIA3oH5gyvSa1KZAgXM8oGYLKvcoDyDBwO
   WD1jF+nE8jKoDQTdsA2UADJdY6ttC34gnWyEPYanwdcGCBowxRrixdqm5
   78f73jm+NXOgBThZeOxf2HM6CtoEjFXGVarM5J7K071r4IOmfxOVGV3oh
   C/d3vYMb0CaLQY/MIHlUJAPFrNmczRRIfAVJjSwnr5Xs75ZDgXBBJ8zzh
   WTHE2LC8FENW763OT8ixxS4htPvfhFFlJ7ubGl25hdVRM87ewbnqbA501
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334966033"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334966033"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784342"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784342"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:18 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v14 052/113] KVM: TDX: Add load_mmu_pgd method for TDX
Date:   Sun, 28 May 2023 21:19:34 -0700
Message-Id: <c768b8294a2037e6f299a0e46341dfbe8868b388.1685333728.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
index 56e192797742..cba8c9690abb 100644
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
index 87003343627b..f3dc052346db 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -143,6 +143,17 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
@@ -276,7 +287,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.write_tsc_offset = vmx_write_tsc_offset,
 	.write_tsc_multiplier = vmx_write_tsc_multiplier,
 
-	.load_mmu_pgd = vmx_load_mmu_pgd,
+	.load_mmu_pgd = vt_load_mmu_pgd,
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 59b5eb8b41b4..7400869c9b60 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -400,6 +400,11 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
index 1245fea67de9..dd54bc869b98 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -153,6 +153,8 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
+
+void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
 static inline void tdx_hardware_unsetup(void) {}
@@ -171,6 +173,8 @@ static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
+
+static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1


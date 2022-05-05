Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A735351C705
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383512AbiEESUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383129AbiEESTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:30 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74386193CD;
        Thu,  5 May 2022 11:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774549; x=1683310549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f1ODjRHohSp8LErDG1PBYRtvrWL3MuC/3/bcDQB5tmY=;
  b=Oxm/0tjpg/pL+3fr8ZKz6Nfj+x9ayfSDgLj8QsDog17djswqhXV7oYzw
   6lz5yVfXUjQ9yIh6V9vLI/TpcqpUNirpvHnSwwb2s+emR0nlyVhy/efiN
   lmeKpvB50f/anOEBaHyXmHx8G5nwzvhPuRVrUJ642VTGJfUA4Ep8bhFvg
   sCe+ixnp8jtjsf1efbFTdnHXTv2gCP0v8OP2eMf2A/9Rpj8l0PbccTifB
   AEH/bqLNqL9vmCqeIiuRb1Z6ACSzAbpM8YVqUFiQ3ewmyAe8oLfqxSCBm
   5kIUN1x7ChPxRlo397L9MXAT9ZgHKYww8lhJ0axx6UZKVJWVFyntK8em7
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="293409460"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="293409460"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:48 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083329"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:48 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 053/104] KVM: TDX: Add load_mmu_pgd method for TDX
Date:   Thu,  5 May 2022 11:14:47 -0700
Message-Id: <88270097c7bb87253223959cd8d71c78bb119468.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/main.c    | 11 ++++++++++-
 arch/x86/kvm/vmx/tdx.c     |  5 +++++
 arch/x86/kvm/vmx/x86_ops.h |  4 ++++
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index d3c8abcaa35e..257bc8e86f47 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -233,6 +233,7 @@ enum vmcs_field {
 	TSC_MULTIPLIER_HIGH             = 0x00002033,
 	TERTIARY_VM_EXEC_CONTROL	= 0x00002034,
 	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
+	SHARED_EPT_POINTER		= 0x0000203C,
 	PID_POINTER_TABLE		= 0x00002042,
 	PID_POINTER_TABLE_HIGH		= 0x00002043,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 9f4c3a0bcc12..252b7298b230 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -110,6 +110,15 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	return vmx_vcpu_reset(vcpu, init_event);
 }
 
+static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
+			int pgd_level)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
+
+	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -228,7 +237,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.write_tsc_offset = vmx_write_tsc_offset,
 	.write_tsc_multiplier = vmx_write_tsc_multiplier,
 
-	.load_mmu_pgd = vmx_load_mmu_pgd,
+	.load_mmu_pgd = vt_load_mmu_pgd,
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 54573537e2b8..dd8553d9f31b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -530,6 +530,11 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->kvm->vm_bugged = true;
 }
 
+void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
+{
+	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
+}
+
 int tdx_dev_ioctl(void __user *argp)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index ab94f95bb915..b59dbc1f9906 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -144,6 +144,8 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
+
+void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
@@ -161,6 +163,8 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
+
+static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFD26D7C78
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388338AbfJOQzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:55:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:46844 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfJOQza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:55:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 09:55:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,300,1566889200"; 
   d="scan'208";a="201811351"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.57])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Oct 2019 09:55:28 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] KVM: VMX: rename {vmx,nested_vmx}_vcpu_setup functions
Date:   Wed, 16 Oct 2019 00:40:30 +0800
Message-Id: <20191015164033.87276-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20191015164033.87276-1-xiaoyao.li@intel.com>
References: <20191015164033.87276-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename {vmx,nested_vmx}_vcpu_setup to {vmx,nested_vmx}_vmcs_setup,
to match what they really do.

No functional change.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 arch/x86/kvm/vmx/nested.h | 2 +-
 arch/x86/kvm/vmx/vmx.c    | 9 +++------
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 5e231da00310..7935422d311f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5768,7 +5768,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-void nested_vmx_vcpu_setup(void)
+void nested_vmx_vmcs_setup(void)
 {
 	if (enable_shadow_vmcs) {
 		vmcs_write64(VMREAD_BITMAP, __pa(vmx_vmread_bitmap));
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 187d39bf0bf1..2be1ba7482c9 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -11,7 +11,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
 				bool apicv);
 void nested_vmx_hardware_unsetup(void);
 __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
-void nested_vmx_vcpu_setup(void);
+void nested_vmx_vmcs_setup(void);
 void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
 int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry);
 bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e660e28e9ae0..58b77a882426 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4161,15 +4161,12 @@ static void ept_set_mmio_spte_mask(void)
 
 #define VMX_XSS_EXIT_BITMAP 0
 
-/*
- * Sets up the vmcs for emulated real mode.
- */
-static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
+static void vmx_vmcs_setup(struct vcpu_vmx *vmx)
 {
 	int i;
 
 	if (nested)
-		nested_vmx_vcpu_setup();
+		nested_vmx_vmcs_setup();
 
 	if (cpu_has_vmx_msr_bitmap())
 		vmcs_write64(MSR_BITMAP, __pa(vmx->vmcs01.msr_bitmap));
@@ -6777,7 +6774,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	cpu = get_cpu();
 	vmx_vcpu_load(&vmx->vcpu, cpu);
 	vmx->vcpu.cpu = cpu;
-	vmx_vcpu_setup(vmx);
+	vmx_vmcs_setup(vmx);
 	vmx_vcpu_put(&vmx->vcpu);
 	put_cpu();
 	if (cpu_need_virtualize_apic_accesses(&vmx->vcpu)) {
-- 
2.19.1


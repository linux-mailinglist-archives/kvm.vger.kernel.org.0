Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1AA0DDD7B
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2019 11:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfJTJ0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Oct 2019 05:26:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:39083 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfJTJ0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Oct 2019 05:26:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Oct 2019 02:26:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,319,1566889200"; 
   d="scan'208";a="348494041"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.57])
  by orsmga004.jf.intel.com with ESMTP; 20 Oct 2019 02:26:08 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] KVM: VMX: Initialize vmx->guest_msrs[] right after allocation
Date:   Sun, 20 Oct 2019 17:11:00 +0800
Message-Id: <20191020091101.125516-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20191020091101.125516-1-xiaoyao.li@intel.com>
References: <20191020091101.125516-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the initialization of vmx->guest_msrs[] from vmx_vcpu_setup() to
vmx_create_vcpu(), and put it right after its allocation.

This also is the preperation for next patch.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ec7c42f57b65..84c32395d887 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4166,8 +4166,6 @@ static void ept_set_mmio_spte_mask(void)
  */
 static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 {
-	int i;
-
 	if (nested)
 		nested_vmx_vcpu_setup();
 
@@ -4226,21 +4224,6 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT)
 		vmcs_write64(GUEST_IA32_PAT, vmx->vcpu.arch.pat);
 
-	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
-		u32 index = vmx_msr_index[i];
-		u32 data_low, data_high;
-		int j = vmx->nmsrs;
-
-		if (rdmsr_safe(index, &data_low, &data_high) < 0)
-			continue;
-		if (wrmsr_safe(index, data_low, data_high) < 0)
-			continue;
-		vmx->guest_msrs[j].index = i;
-		vmx->guest_msrs[j].data = 0;
-		vmx->guest_msrs[j].mask = -1ull;
-		++vmx->nmsrs;
-	}
-
 	vm_exit_controls_set(vmx, vmx_vmexit_ctrl());
 
 	/* 22.2.1, 20.8.1 */
@@ -6700,7 +6683,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	int err;
 	struct vcpu_vmx *vmx;
 	unsigned long *msr_bitmap;
-	int cpu;
+	int i, cpu;
 
 	BUILD_BUG_ON_MSG(offsetof(struct vcpu_vmx, vcpu) != 0,
 		"struct kvm_vcpu must be at offset 0 for arch usercopy region");
@@ -6752,6 +6735,21 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (!vmx->guest_msrs)
 		goto free_pml;
 
+	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
+		u32 index = vmx_msr_index[i];
+		u32 data_low, data_high;
+		int j = vmx->nmsrs;
+
+		if (rdmsr_safe(index, &data_low, &data_high) < 0)
+			continue;
+		if (wrmsr_safe(index, data_low, data_high) < 0)
+			continue;
+		vmx->guest_msrs[j].index = i;
+		vmx->guest_msrs[j].data = 0;
+		vmx->guest_msrs[j].mask = -1ull;
+		++vmx->nmsrs;
+	}
+
 	err = alloc_loaded_vmcs(&vmx->vmcs01);
 	if (err < 0)
 		goto free_msrs;
-- 
2.19.1


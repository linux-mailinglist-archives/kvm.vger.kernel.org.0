Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CF12B4F63
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388434AbgKPS2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:48454 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388320AbgKPS2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:22 -0500
IronPort-SDR: SRRvIOYy8jzW3cnPpnIcvCTOB3vJvLp6QjLOfrQrbUR7q1oeTAmrvhCp7ai8imYa9c8tffcG7s
 pnyKz+O3Quyw==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="157819203"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="157819203"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:20 -0800
IronPort-SDR: 6fZ+HPVnHsswxLy/JLzT3ch5u1zP0wpolP1FBu27+bi37mjPfgZHykXx4Ig8MZnBPxnj5Gh6et
 q6/ZbSH6Y23A==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528361"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:20 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 60/67] KVM: VMX: MOVE GDT and IDT accessors to common code
Date:   Mon, 16 Nov 2020 10:26:45 -0800
Message-Id: <d9c6fbfe32c64f5c72cbe20a858f70c13452a1fd.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/main.c |  6 ++++--
 arch/x86/kvm/vmx/vmx.c  | 12 ------------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 30b1815fd5a7..53e1ea8df861 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -317,7 +317,8 @@ static int vt_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 static void vt_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
-	vmx_get_idt(vcpu, dt);
+	dt->size = vmread32(vcpu, GUEST_IDTR_LIMIT);
+	dt->address = vmreadl(vcpu, GUEST_IDTR_BASE);
 }
 
 static void vt_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
@@ -327,7 +328,8 @@ static void vt_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 
 static void vt_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
-	vmx_get_gdt(vcpu, dt);
+	dt->size = vmread32(vcpu, GUEST_GDTR_LIMIT);
+	dt->address = vmreadl(vcpu, GUEST_GDTR_BASE);
 }
 
 static void vt_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8bd71b91c6f0..93b319eacdfa 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3217,24 +3217,12 @@ static void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
 	*l = (ar >> 13) & 1;
 }
 
-static void vmx_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
-{
-	dt->size = vmcs_read32(GUEST_IDTR_LIMIT);
-	dt->address = vmcs_readl(GUEST_IDTR_BASE);
-}
-
 static void vmx_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
 	vmcs_write32(GUEST_IDTR_LIMIT, dt->size);
 	vmcs_writel(GUEST_IDTR_BASE, dt->address);
 }
 
-static void vmx_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
-{
-	dt->size = vmcs_read32(GUEST_GDTR_LIMIT);
-	dt->address = vmcs_readl(GUEST_GDTR_BASE);
-}
-
 static void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
 	vmcs_write32(GUEST_GDTR_LIMIT, dt->size);
-- 
2.17.1


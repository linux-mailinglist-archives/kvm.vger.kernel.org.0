Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775B63BA5AD
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbhGBWJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:09:19 -0400
Received: from mga17.intel.com ([192.55.52.151]:15304 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233975AbhGBWIn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:08:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="189168409"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="189168409"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:31 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814887"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:31 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 62/69] KVM: VMX: MOVE GDT and IDT accessors to common code
Date:   Fri,  2 Jul 2021 15:05:08 -0700
Message-Id: <461baaa98c6b8c324ee297b76717d623d92bc510.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c |  6 ++++--
 arch/x86/kvm/vmx/vmx.c  | 12 ------------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index b619615f77de..8e03cb72b910 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -311,7 +311,8 @@ static int vt_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 static void vt_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
-	vmx_get_idt(vcpu, dt);
+	dt->size = vmread32(vcpu, GUEST_IDTR_LIMIT);
+	dt->address = vmreadl(vcpu, GUEST_IDTR_BASE);
 }
 
 static void vt_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
@@ -321,7 +322,8 @@ static void vt_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 
 static void vt_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
-	vmx_get_gdt(vcpu, dt);
+	dt->size = vmread32(vcpu, GUEST_GDTR_LIMIT);
+	dt->address = vmreadl(vcpu, GUEST_GDTR_BASE);
 }
 
 static void vt_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40843ca2fb33..d69d4dc7c071 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3302,24 +3302,12 @@ static void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
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
2.25.1


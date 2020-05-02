Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3AC1C2303
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 06:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgEBEdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 May 2020 00:33:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:55789 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgEBEci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 00:32:38 -0400
IronPort-SDR: 2dSyjpuev4NHOnYfXYwzlj942eApvlbQMYoWcDH9QJFQ68+VPuK+s00EHWVNawkiUVjHjI1S0x
 kK2PLW7vSHGQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 21:32:37 -0700
IronPort-SDR: lWUA5Fb1CHqS/CzeMRdFFjJat7n8GOmxhUXWKDuJsoql4LOYgSDp2pxIpEeMldZ0Fa0ZV0tqyy
 vv59G8X1XOHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,342,1583222400"; 
   d="scan'208";a="433516123"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 01 May 2020 21:32:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] KVM: x86: Split guts of kvm_update_dr7() to separate helper
Date:   Fri,  1 May 2020 21:32:28 -0700
Message-Id: <20200502043234.12481-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200502043234.12481-1-sean.j.christopherson@intel.com>
References: <20200502043234.12481-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the calculation of the effective DR7 into a separate helper,
__kvm_update_dr7(), and make the helper visible to vendor code.  It will
be used in a future patch to avoid the retpoline associated with
kvm_x86_ops.set_dr7() when stuffing DR7 during nested VMX transitions.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 11 +----------
 arch/x86/kvm/x86.h | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eccbfcb6a4e5..8893c42eac9e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1076,16 +1076,7 @@ static void kvm_update_dr6(struct kvm_vcpu *vcpu)
 
 static void kvm_update_dr7(struct kvm_vcpu *vcpu)
 {
-	unsigned long dr7;
-
-	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
-		dr7 = vcpu->arch.guest_debug_dr7;
-	else
-		dr7 = vcpu->arch.dr7;
-	kvm_x86_ops.set_dr7(vcpu, dr7);
-	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_BP_ENABLED;
-	if (dr7 & DR7_BP_EN_MASK)
-		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_BP_ENABLED;
+	kvm_x86_ops.set_dr7(vcpu, __kvm_update_dr7(vcpu));
 }
 
 static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7b5ed8ed628e..75010b22e379 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -236,6 +236,20 @@ static inline void kvm_register_writel(struct kvm_vcpu *vcpu,
 	return kvm_register_write(vcpu, reg, val);
 }
 
+static inline unsigned long __kvm_update_dr7(struct kvm_vcpu *vcpu)
+{
+	unsigned long dr7;
+
+	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
+		dr7 = vcpu->arch.guest_debug_dr7;
+	else
+		dr7 = vcpu->arch.dr7;
+	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_BP_ENABLED;
+	if (dr7 & DR7_BP_EN_MASK)
+		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_BP_ENABLED;
+	return dr7;
+}
+
 static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
 {
 	return !(kvm->arch.disabled_quirks & quirk);
-- 
2.26.0


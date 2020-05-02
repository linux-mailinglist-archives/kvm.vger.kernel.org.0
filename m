Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55A51C22F1
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 06:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgEBEck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 May 2020 00:32:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:55787 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgEBEci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 00:32:38 -0400
IronPort-SDR: WgN3tQ+UWPlmfD6XevRqz1dS3mSVZM26auH+rO6HZ2beM33ZU/jrUpBA3BWnK+2ZUhwKmvyy84
 I8CMOPbmsJ8Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 21:32:37 -0700
IronPort-SDR: Jq4hYXhJD6UfsEAjZz3DJkieTU+JnDgsrt1soCpK+scxwxCCKRYsGZrpLf7VbJ0vI5Bkr829JX
 nME8xDpLABUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,342,1583222400"; 
   d="scan'208";a="433516120"
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
Subject: [PATCH 03/10] KVM: x86: Make kvm_x86_ops' {g,s}et_dr6() hooks optional
Date:   Fri,  1 May 2020 21:32:27 -0700
Message-Id: <20200502043234.12481-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200502043234.12481-1-sean.j.christopherson@intel.com>
References: <20200502043234.12481-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make get_dr6() and set_dr6() optional and drop the VMX implementations,
which are for all intents and purposes nops.  This avoids a retpoline on
VMX when reading/writing DR6, at minimal cost (~1 uop) to SVM.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 -----------
 arch/x86/kvm/x86.c     |  6 ++++--
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index de18cd386bb1..e157bdc218ea 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5008,15 +5008,6 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-static u64 vmx_get_dr6(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.dr6;
-}
-
-static void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
-{
-}
-
 static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
 	get_debugreg(vcpu->arch.db[0], 0);
@@ -7799,8 +7790,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_idt = vmx_set_idt,
 	.get_gdt = vmx_get_gdt,
 	.set_gdt = vmx_set_gdt,
-	.get_dr6 = vmx_get_dr6,
-	.set_dr6 = vmx_set_dr6,
 	.set_dr7 = vmx_set_dr7,
 	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
 	.cache_reg = vmx_cache_reg,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ec356ac1e6e..eccbfcb6a4e5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1069,7 +1069,8 @@ static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
 
 static void kvm_update_dr6(struct kvm_vcpu *vcpu)
 {
-	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
+	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
+	    kvm_x86_ops.set_dr6)
 		kvm_x86_ops.set_dr6(vcpu, vcpu->arch.dr6);
 }
 
@@ -1148,7 +1149,8 @@ int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
 	case 4:
 		/* fall through */
 	case 6:
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
+		if ((vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) ||
+		    !kvm_x86_ops.get_dr6)
 			*val = vcpu->arch.dr6;
 		else
 			*val = kvm_x86_ops.get_dr6(vcpu);
-- 
2.26.0


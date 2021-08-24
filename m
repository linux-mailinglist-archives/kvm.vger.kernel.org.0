Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB79C3F5946
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 09:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhHXHnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 03:43:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:63749 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235462AbhHXHnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 03:43:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="217260201"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="217260201"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 00:41:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="473402215"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by orsmga008.jf.intel.com with ESMTP; 24 Aug 2021 00:41:15 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 14/15] KVM: x86/vmx: Flip Arch LBREn bit on guest state change
Date:   Tue, 24 Aug 2021 15:56:16 +0800
Message-Id: <1629791777-16430-15-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
References: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per spec:"IA32_LBR_CTL.LBREn is saved and cleared on #SMI, and restored
on RSM. On a warm reset, all LBR MSRs, including IA32_LBR_DEPTH, have their
values preserved. However, IA32_LBR_CTL.LBREn is cleared to 0, disabling LBRs."
So clear Arch LBREn bit on #SMI and restore it on RSM manully, also clear the
bit when guest does warm reset.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 316403cb4038..ea1efb48d1d6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4519,8 +4519,10 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx_update_exception_bitmap(vcpu);
 
 	vpid_sync_context(vmx->vpid);
-	if (init_event)
+	if (init_event) {
 		vmx_clear_hlt(vcpu);
+		flip_arch_lbr_ctl(vcpu, false);
+	}
 }
 
 static void vmx_enable_irq_window(struct kvm_vcpu *vcpu)
@@ -7523,6 +7525,7 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	vmx->nested.smm.vmxon = vmx->nested.vmxon;
 	vmx->nested.vmxon = false;
 	vmx_clear_hlt(vcpu);
+	flip_arch_lbr_ctl(vcpu, false);
 	return 0;
 }
 
@@ -7543,6 +7546,7 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 
 		vmx->nested.smm.guest_mode = false;
 	}
+	flip_arch_lbr_ctl(vcpu, true);
 	return 0;
 }
 
-- 
2.25.1


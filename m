Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5C93E2420
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 09:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243732AbhHFHar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 03:30:47 -0400
Received: from mga05.intel.com ([192.55.52.43]:16373 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243847AbhHFHab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 03:30:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="299913828"
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="299913828"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 00:29:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="513102544"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Aug 2021 00:29:52 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v7 14/15] KVM: x86/vmx: Flip Arch LBREn bit on guest state change
Date:   Fri,  6 Aug 2021 15:42:24 +0800
Message-Id: <1628235745-26566-15-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1628235745-26566-1-git-send-email-weijiang.yang@intel.com>
References: <1628235745-26566-1-git-send-email-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clear Arch LBREn bit on #SMI and restore it on RSM per ISA spec.,
also clear the bit when guest does warm reset.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 31b9c06c9b3b..31969221db8c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4513,8 +4513,10 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx_update_exception_bitmap(vcpu);
 
 	vpid_sync_context(vmx->vpid);
-	if (init_event)
+	if (init_event) {
 		vmx_clear_hlt(vcpu);
+		flip_arch_lbr_ctl(vcpu, false);
+	}
 }
 
 static void vmx_enable_irq_window(struct kvm_vcpu *vcpu)
@@ -7513,6 +7515,7 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	vmx->nested.smm.vmxon = vmx->nested.vmxon;
 	vmx->nested.vmxon = false;
 	vmx_clear_hlt(vcpu);
+	flip_arch_lbr_ctl(vcpu, false);
 	return 0;
 }
 
@@ -7533,6 +7536,7 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 
 		vmx->nested.smm.guest_mode = false;
 	}
+	flip_arch_lbr_ctl(vcpu, true);
 	return 0;
 }
 
-- 
2.25.1


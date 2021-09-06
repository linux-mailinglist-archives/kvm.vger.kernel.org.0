Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F66F4014D4
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 03:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239752AbhIFBqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 21:46:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:5032 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243721AbhIFBoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 21:44:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10098"; a="283568062"
X-IronPort-AV: E=Sophos;i="5.85,271,1624345200"; 
   d="scan'208";a="283568062"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 18:43:00 -0700
X-IronPort-AV: E=Sophos;i="5.85,271,1624345200"; 
   d="scan'208";a="536343328"
Received: from duan-client-optiplex-7080.bj.intel.com ([10.238.156.101])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 18:42:58 -0700
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Zhenzhong Duan <zhenzhong.duan@intel.com>
Subject: [PATCH] KVM: VMX: Fix a TSX_CTRL_CPUID_CLEAR field mask issue
Date:   Mon,  6 Sep 2021 09:43:23 +0800
Message-Id: <20210906014323.170235-1-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Host value of TSX_CTRL_CPUID_CLEAR field should be unchangable by guest,
but the mask for this purpose is set to a wrong value. So it doesn't
take effect.

Fixes: 8ea8b8d6f869 ("KVM: VMX: Use common x86's uret MSR list as the one true list")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 927a552393b9..36588b5feee6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6812,7 +6812,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 		 */
 		tsx_ctrl = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
 		if (tsx_ctrl)
-			vmx->guest_uret_msrs[i].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+			tsx_ctrl->mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
 	}
 
 	err = alloc_loaded_vmcs(&vmx->vmcs01);
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92AB3154EAD
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 23:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgBFWIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 17:08:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:30021 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727571AbgBFWIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 17:08:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 14:08:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,411,1574150400"; 
   d="scan'208";a="404625100"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 06 Feb 2020 14:08:37 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] KVM: nVMX: Drop unnecessary check on ept caps for execute-only
Date:   Thu,  6 Feb 2020 14:08:36 -0800
Message-Id: <20200206220836.22743-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206220836.22743-1-sean.j.christopherson@intel.com>
References: <20200206220836.22743-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the call to cpu_has_vmx_ept_execute_only() when calculating which
EPT capabilities will be exposed to L1 for nested EPT.  The resulting
configuration is immediately sanitized by the passed in @ept_caps, and
except for the call from vmx_check_processor_compat(), @ept_caps is the
capabilities that are queried by cpu_has_vmx_ept_execute_only().  For
vmx_check_processor_compat(), KVM *wants* to ignore vmx_capability.ept
so that a divergence in EPT capabilities between CPUs is detected.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8cab6f21f356..68e524824136 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6070,10 +6070,9 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
 			VMX_EPT_PAGE_WALK_4_BIT |
 			VMX_EPT_PAGE_WALK_5_BIT |
 			VMX_EPTP_WB_BIT |
-			VMX_EPT_INVEPT_BIT;
-		if (cpu_has_vmx_ept_execute_only())
-			msrs->ept_caps |=
-				VMX_EPT_EXECUTE_ONLY_BIT;
+			VMX_EPT_INVEPT_BIT |
+			VMX_EPT_EXECUTE_ONLY_BIT;
+
 		msrs->ept_caps &= ept_caps;
 		msrs->ept_caps |= VMX_EPT_EXTENT_GLOBAL_BIT |
 			VMX_EPT_EXTENT_CONTEXT_BIT | VMX_EPT_2MB_PAGE_BIT |
-- 
2.24.1


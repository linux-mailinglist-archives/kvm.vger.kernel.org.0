Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320FD3689BC
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 02:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239918AbhDWAZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 20:25:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:7405 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235569AbhDWAZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 20:25:11 -0400
IronPort-SDR: 2A4duPhjG5MLKH5i8Xrp90Y7zsglru3FHlfQ5NMuXd5ZYO3KkKKfS7ZJMLUconstkOlwqnKPM4
 J2DBfX1Wlwaw==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="183125090"
X-IronPort-AV: E=Sophos;i="5.82,244,1613462400"; 
   d="scan'208";a="183125090"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 17:24:35 -0700
IronPort-SDR: fJZ8e6UdDzJpDNR+R6q2UUyN8U/dVGRTqPLIRlZjT0mt4WURHD3qu/VfZhG2+qVKsK3qeyGBAs
 GYwYyu+ieVLA==
X-IronPort-AV: E=Sophos;i="5.82,244,1613462400"; 
   d="scan'208";a="421573241"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 17:24:35 -0700
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@gmail.com,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Yao Yuan <yuan.yao@intel.com>
Subject: [PATCH] KVM: VMX: use EPT_VIOLATION_GVA_TRANSLATED instead of 0x100
Date:   Thu, 22 Apr 2021 17:22:29 -0700
Message-Id: <724e8271ea301aece3eb2afe286a9e2e92a70b18.1619136576.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use symbolic value, EPT_VIOLATION_GVA_TRANSLATED, instead of 0x100
in handle_ept_violation().

Signed-off-by: Yao Yuan <yuan.yao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6501d66167b8..2791c2b4c917 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5398,7 +5398,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 			EPT_VIOLATION_EXECUTABLE))
 		      ? PFERR_PRESENT_MASK : 0;
 
-	error_code |= (exit_qualification & 0x100) != 0 ?
+	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
 	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
 	vcpu->arch.exit_qualification = exit_qualification;
-- 
2.25.1


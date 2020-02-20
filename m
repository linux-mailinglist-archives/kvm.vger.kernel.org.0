Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D3E1668B7
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 21:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgBTUoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 15:44:00 -0500
Received: from mga12.intel.com ([192.55.52.136]:13654 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728582AbgBTUn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 15:43:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 12:43:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="349237101"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2020 12:43:59 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] KVM: VMX: Fold vpid_sync_vcpu_{single,global}() into vpid_sync_context()
Date:   Thu, 20 Feb 2020 12:43:50 -0800
Message-Id: <20200220204356.8837-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220204356.8837-1-sean.j.christopherson@intel.com>
References: <20200220204356.8837-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fold vpid_sync_vcpu_global() and vpid_sync_vcpu_single() into their sole
caller.  KVM should always prefer the single variant, i.e. the only
reason to use the global variant is if the CPU doesn't support
invalidating a single VPID, which is the entire purpose of wrapping the
calls with vpid_sync_context().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/ops.h | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
index 612df1bdb26b..eb6adc77a55d 100644
--- a/arch/x86/kvm/vmx/ops.h
+++ b/arch/x86/kvm/vmx/ops.h
@@ -253,29 +253,17 @@ static inline void __invept(unsigned long ext, u64 eptp, gpa_t gpa)
 	vmx_asm2(invept, "r"(ext), "m"(operand), ext, eptp, gpa);
 }
 
-static inline void vpid_sync_vcpu_single(int vpid)
+static inline void vpid_sync_context(int vpid)
 {
 	if (vpid == 0)
 		return;
 
 	if (cpu_has_vmx_invvpid_single())
 		__invvpid(VMX_VPID_EXTENT_SINGLE_CONTEXT, vpid, 0);
-}
-
-static inline void vpid_sync_vcpu_global(void)
-{
-	if (cpu_has_vmx_invvpid_global())
+	else
 		__invvpid(VMX_VPID_EXTENT_ALL_CONTEXT, 0, 0);
 }
 
-static inline void vpid_sync_context(int vpid)
-{
-	if (cpu_has_vmx_invvpid_single())
-		vpid_sync_vcpu_single(vpid);
-	else
-		vpid_sync_vcpu_global();
-}
-
 static inline void vpid_sync_vcpu_addr(int vpid, gva_t addr)
 {
 	if (vpid == 0)
-- 
2.24.1


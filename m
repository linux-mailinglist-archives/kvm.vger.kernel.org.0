Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB25C1668BC
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 21:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgBTUn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 15:43:59 -0500
Received: from mga12.intel.com ([192.55.52.136]:13654 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728582AbgBTUn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 15:43:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 12:43:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="349237095"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2020 12:43:58 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] KVM: VMX: Move vpid_sync_vcpu_addr() down a few lines
Date:   Thu, 20 Feb 2020 12:43:48 -0800
Message-Id: <20200220204356.8837-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220204356.8837-1-sean.j.christopherson@intel.com>
References: <20200220204356.8837-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move vpid_sync_vcpu_addr() below vpid_sync_context() so that it can be
refactored in a future patch to call vpid_sync_context() directly when
the "individual address" INVVPID variant isn't supported.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/ops.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
index 45eaedee2ac0..a2b0689e65e3 100644
--- a/arch/x86/kvm/vmx/ops.h
+++ b/arch/x86/kvm/vmx/ops.h
@@ -253,19 +253,6 @@ static inline void __invept(unsigned long ext, u64 eptp, gpa_t gpa)
 	vmx_asm2(invept, "r"(ext), "m"(operand), ext, eptp, gpa);
 }
 
-static inline bool vpid_sync_vcpu_addr(int vpid, gva_t addr)
-{
-	if (vpid == 0)
-		return true;
-
-	if (cpu_has_vmx_invvpid_individual_addr()) {
-		__invvpid(VMX_VPID_EXTENT_INDIVIDUAL_ADDR, vpid, addr);
-		return true;
-	}
-
-	return false;
-}
-
 static inline void vpid_sync_vcpu_single(int vpid)
 {
 	if (vpid == 0)
@@ -289,6 +276,19 @@ static inline void vpid_sync_context(int vpid)
 		vpid_sync_vcpu_global();
 }
 
+static inline bool vpid_sync_vcpu_addr(int vpid, gva_t addr)
+{
+	if (vpid == 0)
+		return true;
+
+	if (cpu_has_vmx_invvpid_individual_addr()) {
+		__invvpid(VMX_VPID_EXTENT_INDIVIDUAL_ADDR, vpid, addr);
+		return true;
+	}
+
+	return false;
+}
+
 static inline void ept_sync_global(void)
 {
 	__invept(VMX_EPT_EXTENT_GLOBAL, 0, 0);
-- 
2.24.1


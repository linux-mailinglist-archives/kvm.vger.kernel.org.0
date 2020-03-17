Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B451878A0
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgCQExP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:53:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:34106 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgCQExO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:14 -0400
IronPort-SDR: 5WrDfbI6Du9Zep2f3XKn1YdgmzXcYpFkwy24G4JW/lpy1ypug0QAHBGdEyuia/z7ypp0IpPPq+
 7HSxSklDOEWA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:14 -0700
IronPort-SDR: RPpGg3ym74bdXXhnwoPipDbjkkMG+CoHyovkvRRhq8WujEgKQTohxv5NSyq7dt1B6yug/WKyTU
 ooS8P4TYlqjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252764"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v2 10/32] KVM: VMX: Move vpid_sync_vcpu_addr() down a few lines
Date:   Mon, 16 Mar 2020 21:52:16 -0700
Message-Id: <20200317045238.30434-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
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

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/ops.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
index 33645a8e5463..dd7ab61bfcc1 100644
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


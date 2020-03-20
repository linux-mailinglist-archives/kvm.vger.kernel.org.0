Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEF218DA60
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgCTVbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:31:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:59221 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727145AbgCTV2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:49 -0400
IronPort-SDR: zPCPELPKXmFVlvkstmYBj2SRAzVIkv0dOgMXKMTaZeDsrdicYHBnY2wBGAHBUk5ZyVjY9V8Kr2
 PbMQqcxKsm8w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:48 -0700
IronPort-SDR: Af6XVy8nzlbck59JhnjlGYth+I2ic1HSEB9EV2wxQBf4HNGg6MNjHe3eP3NQG+/KBjjAh64Qbz
 A+xOoBOMuUEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224430"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:46 -0700
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
Subject: [PATCH v3 10/37] KVM: VMX: Move vpid_sync_vcpu_addr() down a few lines
Date:   Fri, 20 Mar 2020 14:28:06 -0700
Message-Id: <20200320212833.3507-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
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


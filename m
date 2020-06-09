Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF83D1F3215
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 03:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgFIBpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 21:45:20 -0400
Received: from mga04.intel.com ([192.55.52.120]:54511 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbgFIBpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 21:45:19 -0400
IronPort-SDR: xRMh9Wg0VFmghwz9T2LkQQfCG/Wf3uKhrsi+QjdGJwX3jv+Lw4gvbzroIjUrYnJMkPhmeeg3RU
 XhVGVEIak5ig==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 18:45:19 -0700
IronPort-SDR: 6auMffpAHogoNZdLl96kRkubZyKX4oa5v+nSnAF+pPNwWyX+wnId7tR9InfHw38JwO2kjvDYu0
 ZI5vPhlTbXyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,490,1583222400"; 
   d="scan'208";a="472909050"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 08 Jun 2020 18:45:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: Add helpers to identify interrupt type from intr_info
Date:   Mon,  8 Jun 2020 18:45:18 -0700
Message-Id: <20200609014518.26756-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add is_intr_type() and is_intr_type_n() to consolidate the boilerplate
code for querying a specific type of interrupt given an encoded value
from VMCS.VM_{ENTER,EXIT}_INTR_INFO, with and without an associated
vector respectively.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

I wrote and proposed a version of this patch a while back[*], but AFAICT
never posted it as a formal patch.

[*] https://lkml.kernel.org/r/20190819233537.GG1916@linux.intel.com

 arch/x86/kvm/vmx/vmcs.h | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 5c0ff80b85c0..7a3675fddec2 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -72,11 +72,24 @@ struct loaded_vmcs {
 	struct vmcs_controls_shadow controls_shadow;
 };
 
+static inline bool is_intr_type(u32 intr_info, u32 type)
+{
+	const u32 mask = INTR_INFO_VALID_MASK | INTR_INFO_INTR_TYPE_MASK;
+
+	return (intr_info & mask) == (INTR_INFO_VALID_MASK | type);
+}
+
+static inline bool is_intr_type_n(u32 intr_info, u32 type, u8 vector)
+{
+	const u32 mask = INTR_INFO_VALID_MASK | INTR_INFO_INTR_TYPE_MASK |
+			 INTR_INFO_VECTOR_MASK;
+
+	return (intr_info & mask) == (INTR_INFO_VALID_MASK | type | vector);
+}
+
 static inline bool is_exception_n(u32 intr_info, u8 vector)
 {
-	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
-			     INTR_INFO_VALID_MASK)) ==
-		(INTR_TYPE_HARD_EXCEPTION | vector | INTR_INFO_VALID_MASK);
+	return is_intr_type_n(intr_info, INTR_TYPE_HARD_EXCEPTION, vector);
 }
 
 static inline bool is_debug(u32 intr_info)
@@ -106,28 +119,23 @@ static inline bool is_gp_fault(u32 intr_info)
 
 static inline bool is_machine_check(u32 intr_info)
 {
-	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
-			     INTR_INFO_VALID_MASK)) ==
-		(INTR_TYPE_HARD_EXCEPTION | MC_VECTOR | INTR_INFO_VALID_MASK);
+	return is_exception_n(intr_info, MC_VECTOR);
 }
 
 /* Undocumented: icebp/int1 */
 static inline bool is_icebp(u32 intr_info)
 {
-	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
-		== (INTR_TYPE_PRIV_SW_EXCEPTION | INTR_INFO_VALID_MASK);
+	return is_intr_type(intr_info, INTR_TYPE_PRIV_SW_EXCEPTION);
 }
 
 static inline bool is_nmi(u32 intr_info)
 {
-	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
-		== (INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK);
+	return is_intr_type(intr_info, INTR_TYPE_NMI_INTR);
 }
 
 static inline bool is_external_intr(u32 intr_info)
 {
-	return (intr_info & (INTR_INFO_VALID_MASK | INTR_INFO_INTR_TYPE_MASK))
-		== (INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR);
+	return is_intr_type(intr_info, INTR_TYPE_EXT_INTR);
 }
 
 enum vmcs_field_width {
-- 
2.26.0


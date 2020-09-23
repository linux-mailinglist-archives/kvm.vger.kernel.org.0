Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4AF2761BA
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 22:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgIWUNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 16:13:53 -0400
Received: from mga12.intel.com ([192.55.52.136]:49297 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgIWUNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 16:13:51 -0400
IronPort-SDR: +89lq/b9Hv2OjHct+Qk1bu52pyE7o6tPDxKrLUL1bahSHPHc3ftecg1zmz0Cj08Xgy9v/Nbo7w
 p6yUZz9/JYRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="140472235"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="140472235"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 13:13:50 -0700
IronPort-SDR: v/QwJbFb23+1sBeLiIehZoL5qt4L5ipnQKwWDgxz/QtoaDsFGPjQeFDaG9y9Sv3ExPRNjg2cyx
 78Ls1pLr2XIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="349004941"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 23 Sep 2020 13:13:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/7] KVM: VMX: Add a helper to test for a valid error code given an intr info
Date:   Wed, 23 Sep 2020 13:13:45 -0700
Message-Id: <20200923201349.16097-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923201349.16097-1-sean.j.christopherson@intel.com>
References: <20200923201349.16097-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper, is_exception_with_error_code(), to provide the simple but
difficult to read code of checking for a valid exception with an error
code given a vmcs.VM_EXIT_INTR_INFO value.  The helper will gain another
user, vmx_get_exit_info(), in a future patch.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 4 +---
 arch/x86/kvm/vmx/vmcs.h   | 7 +++++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4c84380ffd88..6f04df1bbf87 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5940,9 +5940,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	 * need to be synthesized by querying the in-kernel LAPIC, but external
 	 * interrupts are never reflected to L1 so it's a non-issue.
 	 */
-	if ((exit_intr_info &
-	     (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) ==
-	    (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) {
+	if (is_exception_with_error_code(exit_intr_info)) {
 		struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
 		vmcs12->vm_exit_intr_error_code =
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 7a3675fddec2..1472c6c376f7 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -138,6 +138,13 @@ static inline bool is_external_intr(u32 intr_info)
 	return is_intr_type(intr_info, INTR_TYPE_EXT_INTR);
 }
 
+static inline bool is_exception_with_error_code(u32 intr_info)
+{
+	const u32 mask = INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK;
+
+	return (intr_info & mask) == mask;
+}
+
 enum vmcs_field_width {
 	VMCS_FIELD_WIDTH_U16 = 0,
 	VMCS_FIELD_WIDTH_U64 = 1,
-- 
2.28.0


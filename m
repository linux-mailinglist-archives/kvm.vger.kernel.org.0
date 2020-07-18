Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71645224943
	for <lists+kvm@lfdr.de>; Sat, 18 Jul 2020 08:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgGRGjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jul 2020 02:39:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:30319 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728506AbgGRGjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jul 2020 02:39:01 -0400
IronPort-SDR: IKeC2cswCgh59Aowcvu5Rk5czzELqeIa0DZCqmogZ5c3i5g+RWbFGM0HBNS02/+fIdrYdHBCKQ
 ECS4PAFSzyYw==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="151079555"
X-IronPort-AV: E=Sophos;i="5.75,366,1589266800"; 
   d="scan'208";a="151079555"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 23:39:00 -0700
IronPort-SDR: UzIsVVoq+ZrMut9wraWzRDxZelCQpt67gwPVdF1Rn1KSWmBr/u91AGRHNGnVwK5BPhVlz8Yh7Q
 EC26xKINAlRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,366,1589266800"; 
   d="scan'208";a="486690959"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jul 2020 23:39:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] KVM: VMX: Add a helper to test for a valid error code given an intr info
Date:   Fri, 17 Jul 2020 23:38:50 -0700
Message-Id: <20200718063854.16017-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200718063854.16017-1-sean.j.christopherson@intel.com>
References: <20200718063854.16017-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 6f81097cbc794..fc70644b916ca 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5931,9 +5931,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
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
index 7a3675fddec20..1472c6c376f74 100644
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
2.26.0


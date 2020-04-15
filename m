Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0EA1AB01E
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 19:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416561AbgDORz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 13:55:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:30605 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441043AbgDORza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 13:55:30 -0400
IronPort-SDR: NT7lSdxatT+pnvQsElTnFJ/T7OMdT+bWYJJ7NrMYxCJJ1Bv7k2NQ+1bKCkp6yRHgtq1+7/hjsV
 87wiQHVH7DCg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 10:55:25 -0700
IronPort-SDR: HadAltaKaCXpKmv5CCI4vXWQtczgmOVALR1kw6J80C0qDJ4Lf7gZbfX/UxI3aM6BinYONDnE76
 FZigFZ7JhkMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,387,1580803200"; 
   d="scan'208";a="332567354"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 15 Apr 2020 10:55:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 06/10] KVM: nVMX: Drop a superfluous WARN on reflecting EXTERNAL_INTERRUPT
Date:   Wed, 15 Apr 2020 10:55:15 -0700
Message-Id: <20200415175519.14230-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415175519.14230-1-sean.j.christopherson@intel.com>
References: <20200415175519.14230-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the WARN in nested_vmx_reflect_vmexit() that fires if KVM attempts
to reflect an external interrupt.  The WARN is blatantly impossible to
hit now that nested_vmx_l0_wants_exit() is called from
nested_vmx_reflect_vmexit() unconditionally returns true for
EXTERNAL_INTERRUPT.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c2745cd9e022..e8db560ee3eb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5863,12 +5863,11 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason)
 		return false;
 
 	/*
-	 * At this point, the exit interruption info in exit_intr_info
-	 * is only valid for EXCEPTION_NMI exits.  For EXTERNAL_INTERRUPT
-	 * we need to query the in-kernel LAPIC.
+	 * vmcs.VM_EXIT_INTR_INFO is only valid for EXCEPTION_NMI exits.  For
+	 * EXTERNAL_INTERRUPT, the value for vmcs12->vm_exit_intr_info would
+	 * need to be synthesized by querying the in-kernel LAPIC, but external
+	 * interrupts are never reflected to L1 so it's a non-issue.
 	 */
-	WARN_ON(exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT);
-
 	if ((exit_intr_info &
 	     (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) ==
 	    (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) {
-- 
2.26.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCCF714D3F5
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgA2Xqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:46:44 -0500
Received: from mga06.intel.com ([134.134.136.31]:46688 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbgA2Xqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551709"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 29 Jan 2020 15:46:43 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/26] KVM: x86: Move MSR_IA32_BNDCFGS existence checks into vendor code
Date:   Wed, 29 Jan 2020 15:46:20 -0800
Message-Id: <20200129234640.8147-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the MSR_IA32_BNDCFGS existence check into vendor code by way of
->has_virtualized_msr().  AMD does not support MPX, and given that Intel
is in the process of removing MPX, it's extremely unlikely AMD will ever
support MPX.

Note, invoking ->has_virtualized_msr() requires an extra retpoline, but
kvm_init_msr_list() is not a hot path.  As alluded to above, the
motivation is to quarantine MPX as much as possible.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c     | 2 ++
 arch/x86/kvm/vmx/vmx.c | 2 ++
 arch/x86/kvm/x86.c     | 4 ----
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4c8427f57b71..504118c49f46 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5990,6 +5990,8 @@ static bool svm_has_virtualized_msr(u32 index)
 	switch (index) {
 	case MSR_TSC_AUX:
 		return boot_cpu_has(X86_FEATURE_RDTSCP);
+	case MSR_IA32_BNDCFGS:
+		return false;
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9588914e941e..dbeef64f7409 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6279,6 +6279,8 @@ static bool vmx_has_virtualized_msr(u32 index)
 	switch (index) {
 	case MSR_TSC_AUX:
 		return cpu_has_vmx_rdtscp();
+	case MSR_IA32_BNDCFGS:
+		return kvm_mpx_supported();
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a8619c52ea86..70cbb9164088 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5237,10 +5237,6 @@ static void kvm_init_msr_list(void)
 		 * to the guests in some cases.
 		 */
 		switch (msr_index) {
-		case MSR_IA32_BNDCFGS:
-			if (!kvm_mpx_supported())
-				continue;
-			break;
 		case MSR_IA32_RTIT_CTL:
 		case MSR_IA32_RTIT_STATUS:
 			if (!kvm_x86_ops->pt_supported())
-- 
2.24.1


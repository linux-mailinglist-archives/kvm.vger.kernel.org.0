Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD31176472
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 20:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgCBT5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 14:57:38 -0500
Received: from mga05.intel.com ([192.55.52.43]:30422 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbgCBT5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 14:57:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 11:57:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="438404973"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 02 Mar 2020 11:57:37 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 1/6] KVM: x86: Fix tracing of CPUID.function when function is out-of-range
Date:   Mon,  2 Mar 2020 11:57:31 -0800
Message-Id: <20200302195736.24777-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302195736.24777-1-sean.j.christopherson@intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework kvm_cpuid() to query entry->function when adjusting the output
values so that the original function (in the aptly named "function") is
preserved for tracing.  This fixes a bug where trace_kvm_cpuid() will
trace the max function for a range instead of the requested function if
the requested function is out-of-range and an entry for the max function
exists.

Fixes: 43561123ab37 ("kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH")
Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1c469446b07..6be012937eba 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -997,12 +997,12 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
 	return max && function <= max->eax;
 }
 
+/* Returns true if the requested leaf/function exists in guest CPUID. */
 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	       u32 *ecx, u32 *edx, bool check_limit)
 {
-	u32 function = *eax, index = *ecx;
+	const u32 function = *eax, index = *ecx;
 	struct kvm_cpuid_entry2 *entry;
-	struct kvm_cpuid_entry2 *max;
 	bool found;
 
 	entry = kvm_find_cpuid_entry(vcpu, function, index);
@@ -1015,18 +1015,17 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	 */
 	if (!entry && check_limit && !guest_cpuid_is_amd(vcpu) &&
 	    !cpuid_function_in_range(vcpu, function)) {
-		max = kvm_find_cpuid_entry(vcpu, 0, 0);
-		if (max) {
-			function = max->eax;
-			entry = kvm_find_cpuid_entry(vcpu, function, index);
-		}
+		entry = kvm_find_cpuid_entry(vcpu, 0, 0);
+		if (entry)
+			entry = kvm_find_cpuid_entry(vcpu, entry->eax, index);
 	}
 	if (entry) {
 		*eax = entry->eax;
 		*ebx = entry->ebx;
 		*ecx = entry->ecx;
 		*edx = entry->edx;
-		if (function == 7 && index == 0) {
+
+		if (entry->function == 7 && index == 0) {
 			u64 data;
 		        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
 			    (data & TSX_CTRL_CPUID_CLEAR))
-- 
2.24.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E5E179D6F
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 02:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgCEBfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 20:35:16 -0500
Received: from mga06.intel.com ([134.134.136.31]:44313 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgCEBel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 20:34:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 17:34:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,516,1574150400"; 
   d="scan'208";a="234301760"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 04 Mar 2020 17:34:40 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pu Wen <puwen@hygon.cn>
Subject: [PATCH v2 6/7] KVM: x86: Refactor out-of-range logic to contain the madness
Date:   Wed,  4 Mar 2020 17:34:36 -0800
Message-Id: <20200305013437.8578-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305013437.8578-1-sean.j.christopherson@intel.com>
References: <20200305013437.8578-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move all of the out-of-range logic into a single helper,
get_out_of_range_cpuid_entry(), to avoid an extra lookup of CPUID.0.0
and to provide a single location for documenting the out-of-range
behavior.

No functional change intended.

Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 47 +++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index dd3c91ffae11..e4f104c7ace8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1020,13 +1020,19 @@ EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
  *  - Extended:   0x80000000 - 0xbfffffff, 0xd0000000 - 0xffffffff
  *  - Centaur:    0xc0000000 - 0xcfffffff
  */
-static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
+static struct kvm_cpuid_entry2 *
+get_out_of_range_cpuid_entry(struct kvm_vcpu *vcpu, u32 *fn_ptr, u32 index)
 {
 	struct kvm_cpuid_entry2 *basic, *class;
+	u32 function = *fn_ptr;
 
 	basic = kvm_find_cpuid_entry(vcpu, 0, 0);
 	if (!basic)
-		return true;
+		return NULL;
+
+	if (is_guest_vendor_amd(basic->ebx, basic->ecx, basic->edx) ||
+	    is_guest_vendor_hygon(basic->ebx, basic->ecx, basic->edx))
+		return NULL;
 
 	if (function >= 0x40000000 && function <= 0x4fffffff)
 		class = kvm_find_cpuid_entry(vcpu, function & 0xffffff00, 0);
@@ -1036,7 +1042,23 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
 	else
 		class = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
 
-	return class && function <= class->eax;
+	if (class && function <= class->eax)
+		return NULL;
+
+	/*
+	 * Leaf specific adjustments are also applied when redirecting to the
+	 * max basic entry, e.g. if the max basic leaf is 0xb but there is no
+	 * entry for CPUID.0xb.index (see below), then the output value for EDX
+	 * needs to be pulled from CPUID.0xb.1.
+	 */
+	*fn_ptr = basic->eax;
+
+	/*
+	 * The class does not exist or the requested function is out of range;
+	 * the effective CPUID entry is the max basic leaf.  Note, the index of
+	 * the original requested leaf is observed!
+	 */
+	return kvm_find_cpuid_entry(vcpu, basic->eax, index);
 }
 
 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
@@ -1044,25 +1066,14 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 {
 	u32 orig_function = *eax, function = *eax, index = *ecx;
 	struct kvm_cpuid_entry2 *entry;
-	struct kvm_cpuid_entry2 *max;
 	bool found;
 
 	entry = kvm_find_cpuid_entry(vcpu, function, index);
 	found = entry;
-	/*
-	 * Intel CPUID semantics treats any query for an out-of-range
-	 * leaf as if the highest basic leaf (i.e. CPUID.0H:EAX) were
-	 * requested. AMD CPUID semantics returns all zeroes for any
-	 * undefined leaf, whether or not the leaf is in range.
-	 */
-	if (!entry && check_limit && !guest_cpuid_is_amd_or_hygon(vcpu) &&
-	    !cpuid_function_in_range(vcpu, function)) {
-		max = kvm_find_cpuid_entry(vcpu, 0, 0);
-		if (max) {
-			function = max->eax;
-			entry = kvm_find_cpuid_entry(vcpu, function, index);
-		}
-	}
+
+	if (!entry && check_limit)
+		entry = get_out_of_range_cpuid_entry(vcpu, &function, index);
+
 	if (entry) {
 		*eax = entry->eax;
 		*ebx = entry->ebx;
-- 
2.24.1


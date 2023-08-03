Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C99D76E1B0
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 09:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjHCHhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 03:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjHCHgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:06 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3484249D4;
        Thu,  3 Aug 2023 00:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691047937; x=1722583937;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IVhHfi1eWY88vEuzBQ7T04hxto/MpvhMpx9t9R3UaJI=;
  b=FL3yqIDhm7iZRznFs/SmjEeSmfRy9ViQ0GgjsnYa/sWfRlut/gxTrJwL
   80eEys8Fl0f/Lup0c/laHY3jYFTJi0a4CvGPrtaa73AoJ8xn/V72II2mJ
   Rk47Gngs1r3gUMXbeSo/fcqjV060b7x8KIWXZfo7CXoV2RX6jtsf27feG
   6lB5WSjDOjhTKWWl1YZt+oVEKEegoyq+Npfr+xoQ2+JwrLpJyDRwpcWUz
   gTJE3hbQTid8NXOIwkWPFQxPQ9/dPkaqHX5KgiHWztSniZLNHiSgelo1t
   mjSnbqkXjc+hmGipSC4RjdM2dhb/Nee20JbGt4CsAg44749ryDEyFMMbb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="354708099"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="354708099"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="794888475"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="794888475"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:15 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: [PATCH v5 04/19] KVM:x86: Refresh CPUID on write to guest MSR_IA32_XSS
Date:   Thu,  3 Aug 2023 00:27:17 -0400
Message-Id: <20230803042732.88515-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230803042732.88515-1-weijiang.yang@intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update CPUID(EAX=0DH,ECX=1) when the guest's XSS is modified.
CPUID(EAX=0DH,ECX=1).EBX reports required storage size of
all enabled xstate features in XCR0 | XSS. Guest can allocate
sufficient xsave buffer based on the info.

Note, KVM does not yet support any XSS based features, i.e.
supported_xss is guaranteed to be zero at this time.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 20 ++++++++++++++++++--
 arch/x86/kvm/x86.c              |  8 +++++---
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 28bd38303d70..20bbcd95511f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -804,6 +804,7 @@ struct kvm_vcpu_arch {
 
 	u64 xcr0;
 	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
 
 	struct kvm_pio_request pio;
 	void *pio_data;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7f4d13383cf2..0338316b827c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -249,6 +249,17 @@ static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
 	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
 }
 
+static u64 cpuid_get_supported_xss(struct kvm_cpuid_entry2 *entries, int nent)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = cpuid_entry2_find(entries, nent, 0xd, 1);
+	if (!best)
+		return 0;
+
+	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
+}
+
 static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
 				       int nent)
 {
@@ -276,8 +287,11 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 
 	best = cpuid_entry2_find(entries, nent, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
-		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+		     cpuid_entry_has(best, X86_FEATURE_XSAVEC))) {
+		u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
+
+		best->ebx = xstate_required_size(xstate, true);
+	}
 
 	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
@@ -325,6 +339,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.guest_supported_xcr0 =
 		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
+	vcpu->arch.guest_supported_xss =
+		cpuid_get_supported_xss(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
 
 	/*
 	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b9033551d8c..5d6d6fa33e5b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3780,10 +3780,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
 		 * XSAVES/XRSTORS to save/restore PT MSRs.
 		 */
-		if (data & ~kvm_caps.supported_xss)
+		if (data & ~vcpu->arch.guest_supported_xss)
 			return 1;
-		vcpu->arch.ia32_xss = data;
-		kvm_update_cpuid_runtime(vcpu);
+		if (vcpu->arch.ia32_xss != data) {
+			vcpu->arch.ia32_xss = data;
+			kvm_update_cpuid_runtime(vcpu);
+		}
 		break;
 	case MSR_SMI_COUNT:
 		if (!msr_info->host_initiated)
-- 
2.27.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8027A005B
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237573AbjINJil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbjINJiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:38:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BA81FC0;
        Thu, 14 Sep 2023 02:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694684300; x=1726220300;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SgNlcd5ktSWMn2hdoXAHgtutH/xRPayw7k0UwTE2UoM=;
  b=R0jpc+kkwyUnD4vj0n5qK1M8z37Rw40Dnf/udaVAiWOsWK2eCysg7rtK
   vUIi4OqMn97Ilru9fx4+2O1OslChFVM6/KWyU9MDo3TzRyl/lw6/GQiAs
   Ey0T9JZ8+EzRuXIg93xvOSk4d3BsA8Jhp/Z8PACdNcrqoC65c5oIeFxtA
   KgUuvw7FfrMEimuF1I0Di3HOGQkruxeLtIdjBgSAOSWcfJPjpK/KhuB8F
   cMz213jdlLgC3sFBP7nSlx2Lg5EEpTX1IczxGvu09MmeqIuE3xQOZiM9t
   z343GFk2jLxEhAV0kmYynjlFSmQiOwOMiqZZOhbBR5nQMTBcUAEkh0ALZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="409857365"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="409857365"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="747656249"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="747656249"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:19 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: [PATCH v6 12/25] KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
Date:   Thu, 14 Sep 2023 02:33:12 -0400
Message-Id: <20230914063325.85503-13-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914063325.85503-1-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update CPUID.(EAX=0DH,ECX=1).EBX to reflect current required xstate size
due to XSS MSR modification.
CPUID(EAX=0DH,ECX=1).EBX reports the required storage size of all enabled
xstate features in (XCR0 | IA32_XSS). The CPUID value can be used by guest
before allocate sufficient xsave buffer.

Note, KVM does not yet support any XSS based features, i.e. supported_xss
is guaranteed to be zero at this time.

Opportunistically modify XSS write access logic as: if !guest_cpuid_has(),
write initiated from host is allowed iff the write is reset operaiton,
i.e., data == 0, reject host_initiated non-reset write and any guest write.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 15 ++++++++++++++-
 arch/x86/kvm/x86.c              | 13 +++++++++----
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0fc5e6312e93..d77b030e996c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -803,6 +803,7 @@ struct kvm_vcpu_arch {
 
 	u64 xcr0;
 	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
 
 	struct kvm_pio_request pio;
 	void *pio_data;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1f206caec559..4e7a820cba62 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -275,7 +275,8 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 	best = cpuid_entry2_find(entries, nent, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
+						 vcpu->arch.ia32_xss, true);
 
 	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
@@ -312,6 +313,17 @@ static u64 vcpu_get_supported_xcr0(struct kvm_vcpu *vcpu)
 	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
 }
 
+static u64 vcpu_get_supported_xss(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 1);
+	if (!best)
+		return 0;
+
+	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
+}
+
 static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
 {
 	struct kvm_cpuid_entry2 *entry;
@@ -358,6 +370,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	}
 
 	vcpu->arch.guest_supported_xcr0 = vcpu_get_supported_xcr0(vcpu);
+	vcpu->arch.guest_supported_xss = vcpu_get_supported_xss(vcpu);
 
 	/*
 	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1258d1d6dd52..9a616d84bd39 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3795,20 +3795,25 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vcpu->arch.ia32_tsc_adjust_msr += adj;
 		}
 		break;
-	case MSR_IA32_XSS:
-		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
+	case MSR_IA32_XSS: {
+		bool host_msr_reset = msr_info->host_initiated && data == 0;
+
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
+		    (!host_msr_reset || !msr_info->host_initiated))
 			return 1;
 		/*
 		 * KVM supports exposing PT to the guest, but does not support
 		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
 		 * XSAVES/XRSTORS to save/restore PT MSRs.
 		 */
-		if (data & ~kvm_caps.supported_xss)
+		if (data & ~vcpu->arch.guest_supported_xss)
 			return 1;
+		if (vcpu->arch.ia32_xss == data)
+			break;
 		vcpu->arch.ia32_xss = data;
 		kvm_update_cpuid_runtime(vcpu);
 		break;
+	}
 	case MSR_SMI_COUNT:
 		if (!msr_info->host_initiated)
 			return 1;
-- 
2.27.0


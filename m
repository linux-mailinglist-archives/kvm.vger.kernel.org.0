Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638386383CA
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 07:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiKYGKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 01:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiKYGKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 01:10:07 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7DB1FFA5;
        Thu, 24 Nov 2022 22:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669356606; x=1700892606;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t9/hSW5oDqnsrlg6NZnVpU7UNXqQTtylzvwk+12qEN4=;
  b=PBouoJNfTi5QCMPrrGbC3zgErXj4D7ytTQuTyq3ibcbFDlk7g3oEEEuy
   v1nUta9rYp3lmA01Jm+pzuZAPY7S4GWw1w6u2PWai/jJlpHGsbMUR4jOf
   wgrB3e30o7VExz6zabbZ6GgiZT2axSTWlmwuVowS7Cu0uYu9Ry3W1rXsI
   F9fhplwK4JEFz3MsCfdNcyb08nm3CQforX6APYH0Uu6vtfzRhg01NzW+e
   Xde8DCr0CKEvT4aN9Z/cQq/AseM9eyst7bYGRcjW3f+GBhiEmtbVThnBV
   3nAMWJ2QCe2IIuGY/+hlQ6HIGGdBjHwRdF8XSFU6qheSZBEH12igkILGm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="313116802"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="313116802"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:03 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="784838459"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="784838459"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:02 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, weijiang.yang@intel.com,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: [PATCH v2 03/15] KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
Date:   Thu, 24 Nov 2022 23:05:52 -0500
Message-Id: <20221125040604.5051-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221125040604.5051-1-weijiang.yang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Updated CPUID.0xD.0x1, which reports the current required storage size
of all features enabled via XCR0 | XSS, when the guest's XSS is modified.

Note, KVM does not yet support any XSS based features, i.e. supported_xss
is guaranteed to be zero at this time.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/cpuid.c | 16 +++++++++++++---
 arch/x86/kvm/x86.c   |  6 ++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6b5912578edd..85e3df6217af 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -272,9 +272,19 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
 
 	best = cpuid_entry2_find(entries, nent, 0xD, 1);
-	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
-		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+	if (best) {
+		if (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
+		    cpuid_entry_has(best, X86_FEATURE_XSAVEC))  {
+			u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
+
+			best->ebx = xstate_required_size(xstate, true);
+		}
+
+		if (!cpuid_entry_has(best, X86_FEATURE_XSAVES)) {
+			best->ecx = 0;
+			best->edx = 0;
+		}
+	}
 
 	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 16726b44061b..888a153e32bc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3685,8 +3685,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 */
 		if (data & ~kvm_caps.supported_xss)
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


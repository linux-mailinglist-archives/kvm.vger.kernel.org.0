Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D195A8AE7
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 03:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiIABhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 21:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiIABhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 21:37:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC39515C379;
        Wed, 31 Aug 2022 18:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661996222; x=1693532222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A8cSJfD6phET24cDsO35U4HPGEFSMDkBaLc3qK9pReM=;
  b=Yt6NiUjU8fAJnk4FJ7kSaJL8IbkzSmXiT/I5z7JCSATLIYKHDt3QD9aL
   Uzq6j8VT04uYlh9ZfFq5pBRfWmBJTTKuwtRop8waublSejAIxm3eWS65J
   76CnSBQ/+QzPvYzHSwI7Moo2qm67gB0MsX6rhsXGR099YyaNY4VXyRcbx
   QErKcIbOxhVM4DFPxBUhfkD0Uqm90BwJT7oM1BOVeptPsfoBPsTZQ7Pwg
   4GLlx/SVqVzRJ8B8NZC9Mneeb467dZIMpmm55fdz4JlVYUu2i1u+XMM4P
   PYY2+qKpdieP7oICj1KJncV5jXnHD4lG6c85WEz0Yy0ZJlIK6wLIGvkIG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321735077"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="321735077"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="754625976"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:00 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 03/15] KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
Date:   Wed, 31 Aug 2022 18:34:26 -0400
Message-Id: <20220831223438.413090-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220831223438.413090-1-weijiang.yang@intel.com>
References: <20220831223438.413090-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Message-Id: <20220517154100.29983-5-weijiang.yang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 16 +++++++++++++---
 arch/x86/kvm/x86.c   |  6 ++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 75dcf7a72605..9ca592e969e3 100644
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
index 17663cade3fa..92ff5f7d944b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3647,8 +3647,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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


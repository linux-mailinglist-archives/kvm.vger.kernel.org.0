Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC67D6FEC75
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbjEKHNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237174AbjEKHNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:13:40 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC0D2D6A;
        Thu, 11 May 2023 00:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683789212; x=1715325212;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7J0BAjKpZeee0YTws2bhg1lRumDrGh+SHYT9zVcLiQI=;
  b=ZXxOZbgg6h0AcatxizMAgzefIy8sFAe70lc+skijsFs03JCXvTFYHpJk
   aNSk99IPDb6H5rC7DW/X+zjairDBnxqmi+l0a9M4GROUw/gSXxqx5HjhV
   uHSxBhnXZW5Wblo+pL5j8K8sGFBHmt2V1yz0mWSgJ9XGLfkT5fQoRlpHa
   VV4OohyJkxImzYEy89uTt6w+Dt34gZ6P1JsY8+C3U7uRBq9e9fWMJVbIB
   1gBm04D+2uZkKNVm1v8Rp2wFiIWgDHn0kuOCqFF0l9Ee2Rgdvo0ZbKR1K
   Zr0cM9bldTFMgATKvvLRSNj+o5OojdWGiBVHLiwsy7ORArutN/jFMlpxr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334896562"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="334896562"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="1029512362"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="1029512362"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:23 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: [PATCH v3 07/21] KVM:x86: Refresh CPUID on write to guest MSR_IA32_XSS
Date:   Thu, 11 May 2023 00:08:43 -0400
Message-Id: <20230511040857.6094-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230511040857.6094-1-weijiang.yang@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
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
CPUID(EAX=0DH,ECX=1).EBX reports current required storage size for all
features enabled via XCR0 | XSS so that guest can allocate correct xsave
buffer.

Note, KVM does not yet support any XSS based features, i.e. supported_xss
is guaranteed to be zero at this time.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/cpuid.c | 7 +++++--
 arch/x86/kvm/x86.c   | 6 ++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 123bf8b97a4b..cbb1b8a65502 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -277,8 +277,11 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 
 	best = cpuid_entry2_find(entries, nent, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
-		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+		cpuid_entry_has(best, X86_FEATURE_XSAVEC))) {
+		u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
+
+		best->ebx = xstate_required_size(xstate, true);
+	}
 
 	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33a780fe820b..ab3360a10933 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3776,8 +3776,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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


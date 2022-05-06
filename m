Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE9951CFBA
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 05:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388730AbiEFDhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 23:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388654AbiEFDhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 23:37:14 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0B66353E;
        Thu,  5 May 2022 20:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651808012; x=1683344012;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JFJbGDq0BqPr+Hi672VC+GF6n69N+MMpNeStcAVDDGE=;
  b=Y3Cvn9Fm5R4bwPCZIw638F19Jhi5Ji4jKbjnmNvWahF2kdT+R5T73Iqa
   qo1h/fV0MCIbUWzJf9ankUTL/pKmh2NmbsXhIrE8tBY8H/EUkftiUxDPj
   thG4OziqD5K0+y5hXvHG+v6oJ2Rp2KcIJn8IBh+Z4cN1DFAt9DgeBDibA
   FLR+ipCEX4GxEAc47H6WLqdyvAZNd0zYwlZpcnMV0zKjPRfMZ4JtWUpKz
   iDaAUK89HoxeiQQD9NwngpwhXzKywiP2CQGkcFlHR1ZDZzSbs2N7373LO
   EOwFvwhSWxm/gG0tCPFHR9VeBHVJyqxos6XTsBI6aAegR9nKCPuHR2/AY
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248241426"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248241426"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:32 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="632745164"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:31 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kan.liang@linux.intel.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: [PATCH v11 04/16] KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
Date:   Thu,  5 May 2022 23:32:53 -0400
Message-Id: <20220506033305.5135-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220506033305.5135-1-weijiang.yang@intel.com>
References: <20220506033305.5135-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 598334ed5fbc..63870f78ed16 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -239,9 +239,19 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
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
index 396b576f8c42..f78fc014aed3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3576,8 +3576,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 */
 		if (data & ~supported_xss)
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


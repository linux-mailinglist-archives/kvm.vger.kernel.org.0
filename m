Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68366EAFA3
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 18:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbjDUQu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 12:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbjDUQut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:50:49 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032D415452;
        Fri, 21 Apr 2023 09:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682095849; x=1713631849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0HohTrrONEVXrEezJcMjXtrqkHjWsRbeQkNIfNIXJGw=;
  b=lqT4+yqpnwwmHRfMNHUIodLs2mZEhBCocYbFClHyuWjiRsFBqRzy2Ilr
   wrvvQCZt6LPn+Ig/a554lPrCntcUY3fKP7QqX6GvrLHLRuawGBksf5Nk5
   biXNz+fQ4L6P7hu/fZNyLqdhYoP5wGiPhNYE47QXV129xAMeeT2tJd4Ky
   lB65uJAB37zg/nDXmwJ7d1tKQtLP1yPoo5KIDHDkcn2LUlIFli3hxio5B
   NRfS7MS1aj8nYXD6BsVJy94XQUXwMN98nnoiA/qVYPdd1d2IZDCLGQLcR
   DZDz1ZOg2/sWKkX9VfT+2Jib5oEpqkH07iPspOybw0Q1twDnfeY2REpkS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="344786999"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="344786999"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="722817382"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722817382"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:43 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: [PATCH v2 07/21] KVM:x86: Refresh CPUID on write to guest MSR_IA32_XSS
Date:   Fri, 21 Apr 2023 09:46:01 -0400
Message-Id: <20230421134615.62539-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230421134615.62539-1-weijiang.yang@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/cpuid.c | 11 ++++++++---
 arch/x86/kvm/x86.c   |  6 ++++--
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 123bf8b97a4b..dd6d5150d86a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -276,9 +276,14 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
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


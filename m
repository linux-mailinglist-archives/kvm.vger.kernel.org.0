Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15EB6EAF98
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 18:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbjDUQvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 12:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233265AbjDUQuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:50:54 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A091547D;
        Fri, 21 Apr 2023 09:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682095850; x=1713631850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kdtxCZOCZoQNX/+WpLCxNOJBN/TLPN+8TDwmQk9drd4=;
  b=ZVUuQ5ystcjDUggtPTZ0YnCJvNLNE0xmeub0gWLWOIG08jnFO/uQkfGH
   oGJdOig1sq0+1we6tgXo4wiegsnRTJFFg39azdUtWBdvwPvyLrCsYHyVI
   X00/FfMl27nJUdWnv/p8380yI5NPj5SGEX3jC8sXBcrFaItyNU5k5cHwV
   5yHLUgsXBsMQp05Uxr5tWuIXxI0UFLxQzkszXEbcOuDCtJv2fQg4zxLHD
   FnuDH95oo/MhXGCZMfDjGZqhOYywhPP/NpqJfxbcKWfAy3j9fLS/spz5E
   9c79+NsbmmWAdP/pSkeK2cvQuBtIbkU98KtxxzwAcr7gu+4F5bS6NZ63W
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="344787038"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="344787038"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="722817405"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722817405"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:44 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 14/21] KVM:VMX: Add a synthetic MSR to allow userspace VMM to access GUEST_SSP
Date:   Fri, 21 Apr 2023 09:46:08 -0400
Message-Id: <20230421134615.62539-15-weijiang.yang@intel.com>
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

Introduce a host-only synthetic MSR, MSR_KVM_GUEST_SSP, so that the VMM
can read/write the guest's SSP, e.g. to migrate CET state.  Use a synthetic
MSR, e.g. as opposed to a VCPU_REG_, as GUEST_SSP is subject to the same
consistency checks as the PL*_SSP MSRs, i.e. can share code.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/uapi/asm/kvm_para.h |  1 +
 arch/x86/kvm/vmx/vmx.c               | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 6e64b27b2c1e..7af465e4e0bd 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -58,6 +58,7 @@
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
 #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
+#define MSR_KVM_GUEST_SSP	0x4b564d09
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ae816c1c7367..42211ae40650 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1968,7 +1968,8 @@ static bool cet_is_msr_accessible(struct kvm_vcpu *vcpu,
 	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
 		return false;
 
-	if (msr->index == MSR_IA32_PL3_SSP &&
+	if ((msr->index == MSR_IA32_PL3_SSP ||
+	     msr->index == MSR_KVM_GUEST_SSP) &&
 	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
 		return false;
 
@@ -2115,9 +2116,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_U_CET:
 	case MSR_IA32_PL3_SSP:
+	case MSR_KVM_GUEST_SSP:
 		if (!cet_is_msr_accessible(vcpu, msr_info))
 			return 1;
-		kvm_get_xsave_msr(msr_info);
+		if (msr_info->index == MSR_KVM_GUEST_SSP)
+			msr_info->data = vmcs_readl(GUEST_SSP);
+		else
+			kvm_get_xsave_msr(msr_info);
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
@@ -2440,12 +2445,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		kvm_set_xsave_msr(msr_info);
 		break;
 	case MSR_IA32_PL3_SSP:
+	case MSR_KVM_GUEST_SSP:
 		if (!cet_is_msr_accessible(vcpu, msr_info))
 			return 1;
 		if ((data & GENMASK(2, 0)) ||
 		    is_noncanonical_address(data, vcpu))
 			return 1;
-		kvm_set_xsave_msr(msr_info);
+		if (msr_index == MSR_KVM_GUEST_SSP)
+			vmcs_writel(GUEST_SSP, data);
+		else
+			kvm_set_xsave_msr(msr_info);
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data && !vcpu_to_pmu(vcpu)->version)
-- 
2.27.0


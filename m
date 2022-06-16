Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA4354DD6F
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 10:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359865AbiFPIt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 04:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376354AbiFPIsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 04:48:52 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626551A80F;
        Thu, 16 Jun 2022 01:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655369264; x=1686905264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wMy9QLp1MqvMyYPb5VEt2CgYty+Gh8hHunwvtTY1ADI=;
  b=SFiyhX1TSpeiikyvDfN4djnFzygwVy/Z3vEO8v1EEVRgpvkGsXfzdU2j
   7Dikzay2mjhLnEhDAMilrTnMoyTB324/VN/in4wBPVyPapJuw/QZeTAiq
   Q/lGJVF9LzS6OO3AFZfcAOUM7EJhY0s22OwdwX/bpd/fCO2RCQ1HghnG8
   udefnEoH0V5eq1Mr31QlmistxOwUVncirD37Xi730Qm+Lr6p4lKYOCApV
   mehrI1IMCTqjDoMOtgU0vUF3zwnXXK9N12GdNcT5PP9n+fRxXtP5FeI2h
   rbvwiQCvJ2CShKFfTUZi2XLp8WsXggmASaM68lnDyGEhT/5BZ1uvY7hz7
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259055231"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="259055231"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="613083165"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Cc:     weijiang.yang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 13/19] KVM: VMX: Add a synthetic MSR to allow userspace VMM to access GUEST_SSP
Date:   Thu, 16 Jun 2022 04:46:37 -0400
Message-Id: <20220616084643.19564-14-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220616084643.19564-1-weijiang.yang@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
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

Introduce a host-only synthetic MSR, MSR_KVM_GUEST_SSP so that the VMM
can read/write the guest's SSP, e.g. to migrate CET state.  Use a
synthetic MSR, e.g. as opposed to a VCPU_REG_, as GUEST_SSP is subject
to the same consistency checks as the PL*_SSP MSRs, i.e. can share code.

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
index d1f2ffa07576..fc1229f23987 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1780,7 +1780,8 @@ static bool cet_is_msr_accessible(struct kvm_vcpu *vcpu,
 	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
 		return false;
 
-	if (msr->index == MSR_IA32_PL3_SSP &&
+	if ((msr->index == MSR_IA32_PL3_SSP ||
+	     msr->index == MSR_KVM_GUEST_SSP) &&
 	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
 		return false;
 
@@ -1928,9 +1929,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -2273,12 +2278,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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


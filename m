Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817F5648FBC
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 17:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiLJQTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Dec 2022 11:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiLJQTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Dec 2022 11:19:12 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE641A075;
        Sat, 10 Dec 2022 08:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670689148; x=1702225148;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X/JigODFLszBFp5OhaLGZi3lCZqCPVYtRW8l71cFStg=;
  b=m+wq2cJfPKSy5TK/dqaMQFRz+LrH5kl8Z5jMCg4DvcYoJ/d7XvPivV8/
   vCkJ+jPoROnPFuxPEaYLqFeCGsqvfyNS0f9fYfakSyaWTdxNcE/bcaoON
   X57O7QIBSnJ8cUoqTDA+t958QgQuM2QQ8qxOBOruVHAwdELOleWVvh/SY
   mHFMxEa06emRudXFKguY9EXDCjAzuUzCcMoJyMUiQX+1cd9hY+oVtlQff
   1jJOpG7hE7NsofxOaRDPKwq/6XsmI1PfE81ew1EWx1JCfdvcUgjA6n5Rp
   msWrqXJP1kxiQLSlkEizamqHUZ1ZKYrXRmhLy4IqDAJLNs6zPDRsTgv09
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="318780473"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="318780473"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:19:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="711208674"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="711208674"
Received: from unknown (HELO localhost.localdomain) ([10.239.161.133])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:19:04 -0800
From:   Zhang Chen <chen.zhang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Zhang Chen <chen.zhang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 6/9] kvm/x86: Add ARCH_CAP_VIRTUAL_ENUM for guest MSR_IA32_ARCH_CAPABILITIES
Date:   Sun, 11 Dec 2022 00:00:43 +0800
Message-Id: <20221210160046.2608762-7-chen.zhang@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221210160046.2608762-1-chen.zhang@intel.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the 63 bit in MSR_IA32_ARCH_CAPABILITIES for enable the virtual MSRs.
Virtual MSRs can allow guests to notify VMM whether or not
they are using specific software mitigation, allowing a VMM
to enable there hardware control only where necessary.
As Intel spec defination, expose virtual MSR for guest.
Make guest have ability to check virtual MSR 0x50000000.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 15 +++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  1 +
 arch/x86/kvm/x86.c     | 16 +++++++++++++++-
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 407061b369b4..6ed6b743be0e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2001,6 +2001,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
+	case MSR_VIRTUAL_ENUMERATION:
+		if (!msr_info->host_initiated &&
+		    !(vcpu->arch.arch_capabilities & ARCH_CAP_VIRTUAL_ENUM))
+			return 1;
+		msr_info->data = vmx->msr_virtual_enumeration;
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2375,6 +2381,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
+	case MSR_VIRTUAL_ENUMERATION:
+		if (msr_info->host_initiated &&
+		    !(vcpu->arch.arch_capabilities & ARCH_CAP_VIRTUAL_ENUM))
+			return 1;
+		if (data & ~VIRT_ENUM_MITIGATION_CTRL_SUPPORT)
+			return 1;
+		vmx->msr_virtual_enumeration = data &
+						VIRT_ENUM_MITIGATION_CTRL_SUPPORT;
+		break;
 
 	default:
 	find_uret_msr:
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c5a41ae14237..fc873cf45f70 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -298,6 +298,7 @@ struct vcpu_vmx {
 	 * IA32_SPEC_CTRL_MSR.
 	 */
 	u64		      spec_ctrl_mask;
+	u64		      msr_virtual_enumeration;
 	u32		      msr_ia32_umwait_control;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2835bd796639..6be0a3f1281f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1532,6 +1532,8 @@ static const u32 emulated_msrs_all[] = {
 	MSR_IA32_VMX_EPT_VPID_CAP,
 	MSR_IA32_VMX_VMFUNC,
 
+	MSR_VIRTUAL_ENUMERATION,
+
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
 };
@@ -1567,6 +1569,7 @@ static const u32 msr_based_features_all[] = {
 	MSR_IA32_UCODE_REV,
 	MSR_IA32_ARCH_CAPABILITIES,
 	MSR_IA32_PERF_CAPABILITIES,
+	MSR_VIRTUAL_ENUMERATION,
 };
 
 static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
@@ -1588,7 +1591,8 @@ static unsigned int num_msr_based_features;
 	 ARCH_CAP_SKIP_VMENTRY_L1DFLUSH | ARCH_CAP_SSB_NO | ARCH_CAP_MDS_NO | \
 	 ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_NO | \
 	 ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
-	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO)
+	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO | \
+	 ARCH_CAP_VIRTUAL_ENUM)
 
 static u64 kvm_get_arch_capabilities(void)
 {
@@ -1607,6 +1611,13 @@ static u64 kvm_get_arch_capabilities(void)
 	 */
 	data |= ARCH_CAP_PSCHANGE_MC_NO;
 
+	/*
+	 * Virtual MSRs can allow guests to notify VMM whether or not
+	 * they are using specific software mitigation, allowing a VMM
+	 * to enable there hardware control only where necessary.
+	 */
+	data |= ARCH_CAP_VIRTUAL_ENUM;
+
 	/*
 	 * If we're doing cache flushes (either "always" or "cond")
 	 * we will do one whenever the guest does a vmlaunch/vmresume.
@@ -1657,6 +1668,9 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 	case MSR_IA32_UCODE_REV:
 		rdmsrl_safe(msr->index, &msr->data);
 		break;
+	case MSR_VIRTUAL_ENUMERATION:
+		msr->data = VIRT_ENUM_MITIGATION_CTRL_SUPPORT;
+		break;
 	default:
 		return static_call(kvm_x86_get_msr_feature)(msr);
 	}
-- 
2.25.1


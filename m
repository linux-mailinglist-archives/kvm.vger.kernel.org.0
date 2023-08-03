Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0561176E1B7
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 09:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjHCHhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 03:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbjHCHgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:08 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3A549DA;
        Thu,  3 Aug 2023 00:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691047938; x=1722583938;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xmTaXd3FT5TTYs/Ul1AFf8YmKJY5fGFKnUZJiJYCczY=;
  b=Xpbv/LNHcAAQ6nWpDO3rVXA/ai5uQv9DAUUvrZ0zarukuZHzPPvRa+y4
   d48zbqdcZ/dJphelthE1A063VmNTVGteu/sCiqaGmgp98ugvlozDG4LSl
   qEgMjTWHHWcqVhFMc8hNLMH2c//iAwDaK4Ud15jajf0uoqs0cBOFZdMEy
   bBtbPZC98iMmo5PqoyQ3bTNpfbYcIPCKDU0WkoKfnaQ79TkD4rzvQv31D
   5WzWVFhINgz2UGfp5gxd3TlIf8XrkVAcqQhM/yk4Lo1s6rBnMFfaGY9qg
   c7t8vhpTNO1ryVLW414nR+J/P6LoOVhnte4DwtcuA3dRIGtni0qC9U0u/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="354708116"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="354708116"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="794888489"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="794888489"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:16 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v5 08/19] KVM:x86: Report KVM supported CET MSRs as to-be-saved
Date:   Thu,  3 Aug 2023 00:27:21 -0400
Message-Id: <20230803042732.88515-9-weijiang.yang@intel.com>
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

Add all CET MSRs including the synthesized GUEST_SSP to report list.
PL{0,1,2}_SSP are independent to host XSAVE management with later
patches. MSR_IA32_U_CET and MSR_IA32_PL3_SSP are XSAVE-managed on
host side. MSR_IA32_S_CET/MSR_IA32_INT_SSP_TAB/MSR_KVM_GUEST_SSP
are not XSAVE-managed.

When CET IBT/SHSTK are enumerated to guest, both user and supervisor
modes should be supported for architechtural integrity, i.e., two
modes are supported as both or neither.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/uapi/asm/kvm_para.h |  1 +
 arch/x86/kvm/x86.c                   | 10 ++++++++++
 arch/x86/kvm/x86.h                   | 10 ++++++++++
 3 files changed, 21 insertions(+)

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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 82b9f14990da..d68ef87fe007 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1463,6 +1463,9 @@ static const u32 msrs_to_save_base[] = {
 
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 	MSR_IA32_XSS,
+	MSR_IA32_U_CET, MSR_IA32_S_CET,
+	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
+	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB, MSR_KVM_GUEST_SSP,
 };
 
 static const u32 msrs_to_save_pmu[] = {
@@ -7214,6 +7217,13 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		if (!kvm_caps.supported_xss)
 			return;
 		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+	case MSR_KVM_GUEST_SSP:
+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+		if (!kvm_is_cet_supported())
+			return;
+		break;
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 82e3dafc5453..6e6292915f8c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -362,6 +362,16 @@ static inline bool kvm_mpx_supported(void)
 		== (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
 }
 
+#define CET_XSTATE_MASK (XFEATURE_MASK_CET_USER)
+/*
+ * Shadow Stack and Indirect Branch Tracking feature enabling depends on
+ * whether host side CET user xstate bit is supported or not.
+ */
+static inline bool kvm_is_cet_supported(void)
+{
+	return (kvm_caps.supported_xss & CET_XSTATE_MASK) == CET_XSTATE_MASK;
+}
+
 extern unsigned int min_timer_period_us;
 
 extern bool enable_vmware_backdoor;
-- 
2.27.0


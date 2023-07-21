Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA0D75BE60
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 08:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjGUGJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 02:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjGUGI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 02:08:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D731711;
        Thu, 20 Jul 2023 23:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689919736; x=1721455736;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cPRAjBh+JcqfxChi1axz7cYPe9M4lTZa+vuA83lyP04=;
  b=EF11m+fMI/p4oBXPIw6WsuhgCp9/zt5bKLnaYLS3NKzbLw66hA/TJC7C
   V+vkvFhJ2dTJg6OF92oDmuLqXsERPg7R/kxXSAW6OQgVwKEHs4GqZ89H9
   BCvA3/vB+Q7Ee3xqN6PKG9nx6Pajze57oWxtbe6xVLGFt5kyAMgcZ9Uo5
   nvMxjYU/LdBC4ja3SMdJmGHRgUaToCGCjK902D2X3uZO3kLKF7OQibCRA
   STBB084UA+y9nlU9MSwceq+8AY1uoGsRXT+ljp8MQzSN+Q8qQ5o+NuCxO
   3wwK2lXwm6Bm6/05JNdB8QewV1jFrtwtVC53PJKo0NhpcBUbAKPiwWqON
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="370547554"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="370547554"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="848721966"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="848721966"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:41 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v4 08/20] KVM:x86: Report KVM supported CET MSRs as to-be-saved
Date:   Thu, 20 Jul 2023 23:03:40 -0400
Message-Id: <20230721030352.72414-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230721030352.72414-1-weijiang.yang@intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
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
index be76ac6bbb21..59e961a88b75 100644
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
@@ -7215,6 +7218,13 @@ static void kvm_probe_msr_to_save(u32 msr_index)
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


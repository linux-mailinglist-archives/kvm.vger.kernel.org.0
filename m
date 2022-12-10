Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07159648FB3
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 17:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiLJQTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Dec 2022 11:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiLJQTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Dec 2022 11:19:03 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3661193F0;
        Sat, 10 Dec 2022 08:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670689138; x=1702225138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sSdYThVrddLtjTse/5AQd2MpfOega7QZ/yPiX4mvGVs=;
  b=ibIpHy57kBOjhYGb/FTX1tuNxG/GYy8/JmXOpBqvWpL8iSNftS8YEHMP
   FnQ/NKuodRm1FF0sCrlBnl/teFyPVwk8swnbNSAVuj618WQXwASYIoyP5
   JK/06cWXem+Nud4yirh3YpqvHpI6UKBW/ATmZ+mPp+Rb9A0EnDdQDAwup
   z7VWFC0/m6NNnAkkpSyGr754wRLWssVuSTua4Hs6VRO+Mn/VpUGSSwOuu
   U+2b/cGfFmd5ac7d6wEbtPkvd0JlS4LRmuGCJ8sfFi5f+W+ntV7wxIMcF
   VdR7Bm4k1+bGikIdokQn91vHrcRK+3DROu0QbOMHhKHVGeo5e9VipZdMi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="318780447"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="318780447"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:18:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="711208638"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="711208638"
Received: from unknown (HELO localhost.localdomain) ([10.239.161.133])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:18:55 -0800
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
Subject: [RFC PATCH 3/9] KVM: x86: Add a kvm-only leaf for BHI_CTRL
Date:   Sun, 11 Dec 2022 00:00:40 +0800
Message-Id: <20221210160046.2608762-4-chen.zhang@intel.com>
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

KVM needs to check if guests can see BHI_CTRL. If a guest is using
BHB-clearing sequence and cannot see BHI_CTRL and the host enumerates BHI,
KVM is responsible for setting BHI_DIS_S for the guest.

This allows VM migration from parts doesn't enumerate BHI to those
that enumerate BHI.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
---
 arch/x86/kvm/cpuid.c         | 2 +-
 arch/x86/kvm/reverse_cpuid.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8d45bc0b4b7c..91af27cc57e5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -669,7 +669,7 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_init_scattered(CPUID_7_2_EDX,
-		SF(RRSBA_CTRL)
+		SF(RRSBA_CTRL) | F(BHI_CTRL)
 	);
 
 	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 4c38ed61c505..cf4e209ce2f6 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -27,6 +27,8 @@ enum kvm_only_cpuid_leafs {
 
 /* Intel-defined sub-features, CPUID level 0x00000007:2 (EDX)*/
 #define KVM_X86_FEATURE_RRSBA_CTRL	KVM_X86_FEATURE(CPUID_7_2_EDX, 2)
+/* X86_FEATURE_BHI_CTRL only used by KVM */
+#define X86_FEATURE_BHI_CTRL		KVM_X86_FEATURE(CPUID_7_2_EDX, 4)
 
 struct cpuid_reg {
 	u32 function;
-- 
2.25.1


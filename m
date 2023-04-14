Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C496E1C94
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 08:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjDNG0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 02:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjDNG0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 02:26:18 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435C16A42;
        Thu, 13 Apr 2023 23:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681453577; x=1712989577;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3v96gRV+sEhmeJkt6bLopXdOVIbOcXfn+M8hUk0aLec=;
  b=a16edSFrIgSJnGu0rB6WQQoEpFaIdU3Dbi8O3EOEM1AzOhL3WX19EXDL
   MPolO9O5tK6yq6rEgEdw8EuGAEzdz3MkamWeQiiF562ZAzMpO1bcDICsa
   U8Uk099+EXKRUiGuyTtL9jTS6KkO25Uq8ydU1ltU8WmJqeP90C9GiCWzO
   qAf70liVPIUSSpvj+pz8s4rJkfRCO1PiSoIZw7W/UYguc+PNZ9Hf2K9ZH
   4NxfkrTYFPgmeZhFc1fxClLgXifGjv4pxm5zFLRW413Bu2kNekcftoWEI
   V2Qs8zxl1H9t1hvL5xQw4Aafj6g1jeYZIG8kqg2BE9xfUtKqD7AzV8WA8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="341892723"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="341892723"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 23:26:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="935885827"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="935885827"
Received: from spr.sh.intel.com ([10.239.53.106])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 23:26:13 -0700
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jiaan Lu <jiaan.lu@intel.com>, Zhang Chen <chen.zhang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 03/11] KVM: x86: Advertise BHI_CTRL support
Date:   Fri, 14 Apr 2023 14:25:24 +0800
Message-Id: <20230414062545.270178-4-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230414062545.270178-1-chao.gao@intel.com>
References: <20230414062545.270178-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhang Chen <chen.zhang@intel.com>

Add 100% kvm-only feature for BHI_CTRL because the kernel doesn't use it
at all.

BHI_CTRL is enumerated by CPUID.7.2.EDX[4]. If supported, BHI_DIS_S (bit
10) of IA32_SPEC_CTRL MSR can be used to enable BHI_DIS_S behavior.

Note that KVM does not intercept guests' IA32_SPEC_CTRL MSR accesses
after a non-zero is written to the MSR. Therefore, guests can already
toggle the BHI_DIS_S bit if the host supports BHI_CTRL, and no extra
code is needed to allow guests to toggle the bit.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Jiaan Lu <jiaan.lu@intel.com>
---
 arch/x86/kvm/cpuid.c         | 2 +-
 arch/x86/kvm/reverse_cpuid.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f024c3ac2203..7cdd859d09a2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -686,7 +686,7 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
-		SF(RRSBA_CTRL)
+		SF(RRSBA_CTRL) | F(BHI_CTRL)
 	);
 
 	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 72bad8314a9c..e7e70c9aa384 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -50,6 +50,7 @@ enum kvm_only_cpuid_leafs {
 
 /* Intel-defined sub-features, CPUID level 0x00000007:2 (EDX) */
 #define KVM_X86_FEATURE_RRSBA_CTRL	KVM_X86_FEATURE(CPUID_7_2_EDX, 2)
+#define X86_FEATURE_BHI_CTRL		KVM_X86_FEATURE(CPUID_7_2_EDX, 4)
 
 struct cpuid_reg {
 	u32 function;
-- 
2.40.0


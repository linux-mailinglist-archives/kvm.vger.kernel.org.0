Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086CD6FD67D
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 08:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbjEJGGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 02:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjEJGGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 02:06:44 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF934216;
        Tue,  9 May 2023 23:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683698803; x=1715234803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B5CZz+QYjND/DHIB64ZI8na4RUqGCax9TgBfXTkwN5g=;
  b=L4X5XtYVb6+WvRq1KndVaYxP49/zsJW9y1ojS0klIqF2FuKSi1SxHixn
   EujZ9ApZ86JJvNTT9FI5VfTZ4DZzdFDTC42A+3o4Ij5+qDD8SQWPPRMN/
   UXJAd9MDEMm5p72YegEHvvMSQc/tFwjLhizc983eMyX8X41DLYLpBYNVF
   Yh0gXWmq2Ag9eT592+YX75bjW3hnnuSJmgRn+ivU5a3U+JZURS+sd0yt5
   FsNX5nXd9+LFMTcY8e2ZAC+jrkKLhCH3XWuua6rHI2QWV48cCWu599FIZ
   rlSqf1FhxAFp9Ybjq5KoQSi6xaF1VAReo2icenoLIbN3lzZdkyq1NY4X3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="348969254"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="348969254"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 23:06:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="768803076"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="768803076"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.8.90])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 23:06:41 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hu@linux.intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v8 2/6] KVM: x86: Virtualize CR4.LAM_SUP
Date:   Wed, 10 May 2023 14:06:07 +0800
Message-Id: <20230510060611.12950-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230510060611.12950-1-binbin.wu@linux.intel.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

Add support to allow guests to set the new CR4 control bit for guests to enable
the new Intel CPU feature Linear Address Masking (LAM) on supervisor pointers.

LAM modifies the checking that is applied to 64-bit linear addresses, allowing
software to use of the untranslated address bits for metadata and masks the
metadata bits before using them as linear addresses to access memory. LAM uses
CR4.LAM_SUP (bit 28) to configure LAM for supervisor pointers. LAM also changes
VMENTER to allow the bit to be set in VMCS's HOST_CR4 and GUEST_CR4 for
virtualization.

Move CR4.LAM_SUP out of CR4_RESERVED_BITS and its reservation depends on vcpu
supporting LAM feature or not. Leave the bit intercepted to avoid vmread every
time when KVM fetches its value, with the expectation that guest won't toggle
the bit frequently.

Set CR4.LAM_SUP bit in the emulated IA32_VMX_CR4_FIXED1 MSR for guests to allow
guests to enable LAM for supervisor pointers in nested VMX operation.

Hardware is not required to do TLB flush when CR4.LAM_SUP toggled, KVM doesn't
need to emulate TLB flush based on it.
There's no other features/vmx_exec_controls connection, no other code needed in
{kvm,vmx}_set_cr4().

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/vmx/vmx.c          | 3 +++
 arch/x86/kvm/x86.h              | 2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fb9d1f2d6136..c6f03d151c31 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -125,7 +125,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_LAM_SUP))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..362b2dce7661 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7603,6 +7603,9 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
 
+	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
+	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
+
 #undef cr4_fixed1_update
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c544602d07a3..fe67b641cce4 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -529,6 +529,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
+		__reserved_bits |= X86_CR4_LAM_SUP;     \
 	__reserved_bits;                                \
 })
 
-- 
2.25.1


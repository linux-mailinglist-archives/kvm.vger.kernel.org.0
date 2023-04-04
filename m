Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A476D6238
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 15:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbjDDNJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 09:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235068AbjDDNJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 09:09:36 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A201BCB
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 06:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680613773; x=1712149773;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VgKorZEIo2q2LdcEZ2+a0FhiC5U5ASocrDIOqvCsoxg=;
  b=XfqsoQgcSaBhrI2bcvemIX8189N5rkZ92dbrX5Ca4iJROKYkv5/FOvTl
   v4T7qjuh7fWANc3k0R1zPhy5PXvHH2W7EQq/XxALhiow0RMXBV+8FZPfx
   0hc1BtauycPoVpDhK4njeYmIPZ1tcbYc4hpC4APZYzaU5WBOMuacbxIfn
   /Jh3J9PkPlDysShLJXynueMhVVoHRnnm0+ei10ap3WDo+gB5UA701sqsw
   xE4YuAPBDTKtbKaS/Kb1XwoOXS3cSXBI0vGTinzzlO9WzrmYlA6CQZd5P
   u/rrD4iyugOqBgX0aYs2XRDmegUSQEmfwT9a3O9/3MH1qHlmGYGmEKCt3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="326193398"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="326193398"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 06:09:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="750902076"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="750902076"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.215.140])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 06:09:30 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     binbin.wu@linux.intel.com, kai.huang@intel.com, chao.gao@intel.com,
        xuelian.guo@intel.com, robert.hu@linux.intel.com
Subject: [PATCH v7 1/5] KVM: x86: Virtualize CR4.LAM_SUP
Date:   Tue,  4 Apr 2023 21:09:19 +0800
Message-Id: <20230404130923.27749-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230404130923.27749-1-binbin.wu@linux.intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

Allow setting of CR4.LAM_SUP (bit 28) by guest if vCPU supports LAM,
and intercept the bit (as it already is).

LAM uses CR4.LAM_SUP to configure LAM masking on supervisor mode address.
To virtualize that, move CR4.LAM_SUP out of CR4_RESERVED_BITS and its
reservation depends on vCPU has LAM feature or not.
CR4.LAM_SUP is allowed to be set even not in 64-bit mode, but it will not
take effect since LAM only applies to 64-bit linear address.

Leave the bit intercepted to avoid vmread every time when KVM fetches its
value, with the expectation that guest won't toggle the bit frequently.

Hardware is not required to do TLB flush when CR4.LAM_SUP toggled, so KVM
doesn't need to emulate TLB flush based on it.
There's no other features/vmx_exec_controls connection, therefore no code
need to be complemented in kvm/vmx_set_cr4().

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
index 808c292ad3f4..ba594f9ea414 100644
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
index d2d6e1b6c788..42f163862a0f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7630,6 +7630,9 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
 
+	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
+	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
+
 #undef cr4_fixed1_update
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a8167b47b8c8..3a9d97b899df 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -487,6 +487,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
+		__reserved_bits |= X86_CR4_LAM_SUP;     \
 	__reserved_bits;                                \
 })
 
-- 
2.25.1


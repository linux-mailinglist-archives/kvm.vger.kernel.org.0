Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03DE723CFF
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 11:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236436AbjFFJS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 05:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235160AbjFFJSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 05:18:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B48918E;
        Tue,  6 Jun 2023 02:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686043134; x=1717579134;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vx+dLHRNpRL2FBPV8L/ICnFVgb5+hT8yghelRXbujUk=;
  b=OwZOj8LSi+N6wulToScbpJhvTc4bkJMl6fKUfx5AxIf+n1JLDHHfHhAF
   tMxt9pYBnXVDZXP3FFl9ggecgqI9emWYc+C2LEe2kmPNfRigXc/Wn/OqD
   nifolw85KggZg4GFOWXdHF0+vBkrxemrIcZKX9j8tjKvV1574A+YxC2rq
   zm2PwR+w8CA6zOvHYlbShtqWs7zGtt/BoC5GITNkyQLrQSVfY98mCmdtG
   uin/vpwMl5Po2+cXpgNV3Uhwhpp/JfbUXxHXVQiWomfItR9+xceHokI31
   gcOC9rxz/1e47Sa50Ef+XpQCwpkzejWzeusLgmVADBZl/v9u82O9Wdjf8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="341252822"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="341252822"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:18:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="883263633"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="883263633"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.249.170.159])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:18:50 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, binbin.wu@linux.intel.com
Subject: [PATCH v9 2/6] KVM: x86: Virtualize CR4.LAM_SUP
Date:   Tue,  6 Jun 2023 17:18:38 +0800
Message-Id: <20230606091842.13123-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230606091842.13123-1-binbin.wu@linux.intel.com>
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
virtualization. Note CR4.LAM_SUP is allowed to be set even not in 64-bit mode,
but it will not take effect since LAM only applies to 64-bit linear addresses.

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
index 2d9d155691a7..0dd2970ba5c8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7600,6 +7600,9 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
 
+	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
+	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
+
 #undef cr4_fixed1_update
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 82e3dafc5453..24e2b56356b8 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -528,6 +528,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
+		__reserved_bits |= X86_CR4_LAM_SUP;     \
 	__reserved_bits;                                \
 })
 
-- 
2.25.1


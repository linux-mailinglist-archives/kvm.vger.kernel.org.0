Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12706A3D8B
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbjB0Izv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbjB0IzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:55:05 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0B524CA5
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 00:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677487644; x=1709023644;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NMP70Ag3PPZSxGE2TJyEUxCricXuuRSM5JR0FCqODZM=;
  b=Uv803NNg8QQJZEraqzgLjdw7Uuhk5aE4imPHOtysv2nwKgVEfCTvG/SQ
   IViK29kudb65pX3R0ntDGcRApvDY4lgoyJ8q9yapSZQNnvVjrOInsPCpa
   buX/9kT7didc25MtxbgCoezc6lxjvTP4DtESDUq7BoWXEyunu/pYDltbA
   6mhP7ggDmrJ344lvVHzx0OLvhUINJSXAvDop7/fcX7Tp1BCDTdtEEHGBM
   MKrynNWMBp0C8D7KRwXsPHHD779fyHBV6l/4smScum6XV22uhnAq9dMqQ
   eu5g6p7RfMGNgQLLH57zWCxPxKB/4ypJzpAkXLVDAdZUOPZL3iBW0yRqW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="322057679"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="322057679"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:46:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="651127072"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="651127072"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 27 Feb 2023 00:46:11 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v5 1/5] KVM: x86: Virtualize CR4.LAM_SUP
Date:   Mon, 27 Feb 2023 16:45:43 +0800
Message-Id: <20230227084547.404871-2-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230227084547.404871-1-robert.hu@linux.intel.com>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

LAM feature uses CR4 bit[28] (LAM_SUP) to enable/config LAM masking on
supervisor mode address. To virtualize that, move CR4.LAM_SUP out of
unconditional CR4_RESERVED_BITS; its reservation now depends on vCPU has
LAM feature or not.

Not passing through to guest but intercept it, is to avoid read VMCS field
every time when KVM fetch its value, with expectation that guest won't
toggle this bit frequently.

There's no other features/vmx_exec_controls connections, therefore no code
need to be complemented in kvm/vmx_set_cr4().

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/x86.h              | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f35f1ff4427b..4684896698f4 100644
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
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 9de72586f406..8ec5cc983062 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -475,6 +475,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_LAM))		\
+		__reserved_bits |= X86_CR4_LAM_SUP;	\
 	__reserved_bits;                                \
 })
 
-- 
2.31.1


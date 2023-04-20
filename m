Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794786E96D1
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 16:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbjDTOQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 10:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbjDTOQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 10:16:18 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C355540DB;
        Thu, 20 Apr 2023 07:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682000177; x=1713536177;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=DAVFBOgJwmbdVgPRUhLaouaTcJcJ1MnxKOkOedpXi1U=;
  b=hvxPxf42OVYIY39GpTsSGfjw3rEsjqU8OSQGrVMBo+TS7Zr5FBUgnRSH
   x9/1/I+C81J//Z8BwPYFAMiNfk7lmvCspzcL9GHPdqqvzLaLklDtJJJDb
   IlPOeKRc4cb/knbAOYa8Pl23xS/KeAHt2qmNqD/ENAhkb2n8YvTUtFrsf
   +de6EuiBVkd4ItdWjNYjrBVpooQM+tX3rVooeiq/sL0Udriz73HbfqMgp
   v32cRjiNYQDxs509N7Tqe3Xa2oof77Xx8KqBxrQlSMRej9lqKk2XmO5RT
   k64Nxa+Hni1IT+W5Y4CSHfWeUDqNilUBNVD0fU7tBcW90mhaUxRmeQw0E
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343217826"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="343217826"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 07:16:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="816028858"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="816028858"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.53])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 07:16:06 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH 3/6] KVM: x86: Add emulator helper for LASS violation check
Date:   Thu, 20 Apr 2023 21:37:21 +0800
Message-Id: <20230420133724.11398-4-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230420133724.11398-1-guang.zeng@intel.com>
References: <20230420133724.11398-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When LASS is enabled, KVM need apply LASS violation check to instruction
emulations. Add helper for the usage of x86 emulator to perform LASS
protection.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/kvm_emulate.h | 1 +
 arch/x86/kvm/x86.c         | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 2d9662be8333..1c55247d52d7 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -224,6 +224,7 @@ struct x86_emulate_ops {
 	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
+	bool (*check_lass)(struct x86_emulate_ctxt *ctxt, u64 access, u64 la, u64 flags);
 };
 
 /* Type, address-of, and value of an instruction's operand. */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 87feb1249ad6..704c5e4b9e76 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8193,6 +8193,14 @@ static void emulator_vm_bugged(struct x86_emulate_ctxt *ctxt)
 		kvm_vm_bugged(kvm);
 }
 
+static bool emulator_check_lass(struct x86_emulate_ctxt *ctxt,
+				u64 access, u64 la, u64 flags)
+{
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+
+	return static_call(kvm_x86_check_lass)(vcpu, access, la, flags);
+}
+
 static const struct x86_emulate_ops emulate_ops = {
 	.vm_bugged           = emulator_vm_bugged,
 	.read_gpr            = emulator_read_gpr,
@@ -8237,6 +8245,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.leave_smm           = emulator_leave_smm,
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
+	.check_lass          = emulator_check_lass,
 };
 
 static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
-- 
2.27.0


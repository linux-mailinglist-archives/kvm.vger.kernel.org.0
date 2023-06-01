Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DED271A208
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 17:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbjFAPF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 11:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbjFAPFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 11:05:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2EA1A8;
        Thu,  1 Jun 2023 08:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685631851; x=1717167851;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Zmsunkuwxh88Hrkvr7oFtCCzvzM6LSfleDwmcLdBVmk=;
  b=JhTE1yv2UJB5Fhx+TWtrhodjF1CBniJDd/XOVkgqQmvPQnznlNmXTEZg
   mAVrkKZ7qsepfVLqcAdSZj90ZN5BBwJf7suxuCXS+HDMlyFkIKMqNi6df
   yA5NcWBUZPtwq77QaJYcC08i0VCSaMibT99htR/M4NfXIoPmz9tj/Sbch
   qxKSmjS9wcdIh+hoXBGkA+9a9tf5Y3mlbYV1ZpZTrGAHNSMFj67sMhFMT
   3sE6IAK2O6T5Gp9MyLuozmzBHRvB9hy8CyHj2fdjoDnRowxYeMwnlEpLn
   DUZSI1dDhl6+IetuXby3woXxBZphj/5SOrOQHwb/Sg3vdP9Fcir7fGa8A
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="383853441"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="383853441"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 08:02:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="657828231"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="657828231"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 08:02:48 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v1 4/6] KVM: x86: Add emulator helper for LASS violation check
Date:   Thu,  1 Jun 2023 22:23:07 +0800
Message-Id: <20230601142309.6307-5-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230601142309.6307-1-guang.zeng@intel.com>
References: <20230601142309.6307-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When LASS is enabled, KVM need apply LASS violation check to instruction
emulations. Add helper for the usage of x86 emulator to perform LASS
protection.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/kvm_emulate.h |  1 +
 arch/x86/kvm/x86.c         | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index f1439ab7c14b..fd1c2b22867e 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -230,6 +230,7 @@ struct x86_emulate_ops {
 	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
+	bool (*check_lass)(struct x86_emulate_ctxt *ctxt, u64 access, u64 la, u32 flags);
 };
 
 /* Type, address-of, and value of an instruction's operand. */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c0778ca39650..faf01fecc4ca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8287,6 +8287,17 @@ static void emulator_vm_bugged(struct x86_emulate_ctxt *ctxt)
 		kvm_vm_bugged(kvm);
 }
 
+static bool emulator_check_lass(struct x86_emulate_ctxt *ctxt,
+				u64 access, u64 la, u32 flags)
+{
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+
+	if (!is_long_mode(vcpu))
+		return false;
+
+	return static_call(kvm_x86_check_lass)(vcpu, access, la, flags);
+}
+
 static const struct x86_emulate_ops emulate_ops = {
 	.vm_bugged           = emulator_vm_bugged,
 	.read_gpr            = emulator_read_gpr,
@@ -8332,6 +8343,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.leave_smm           = emulator_leave_smm,
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
+	.check_lass          = emulator_check_lass,
 };
 
 static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
-- 
2.27.0


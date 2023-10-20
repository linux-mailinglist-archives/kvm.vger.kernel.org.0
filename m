Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE3A7D174F
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 22:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjJTUp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 16:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjJTUpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 16:45:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264701717;
        Fri, 20 Oct 2023 13:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697834732; x=1729370732;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=efcm4OHP2Uz572Un+YAEz/A+CIucgALlZ4w/Rew7Rqg=;
  b=F/rxuNemKnaWdJ9lk7HdzRn0wZJOjnk0pEjMJE2qTWjQYYbfxpO9ni6z
   stLc0qUV/lcjFfZubfAZirqtcbolK1gCJ8aVvhfqHc+A5z1QzGruG6RFr
   B7HWY9JJSzKbDI36O7KjjwaFlg7zp5X6IFNnks6c24/xD9z34v6HrdH6R
   FK01NAw09dGSJp1dEZut39X7CGRJDRdMaDc4v4YzoOM9XqrNEOUSYqshw
   ZECUt0iyK9UUuLd2E0WsRiSziaKCYsdIqdZpOlUVuybAkmVETWrUetOR8
   ZxnpYG0JqA57GH6bnBV5i4cvBDdMpQ0KKot8/tyjr3OgyP/uzKWVJSgVl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="365909446"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="365909446"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 13:45:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="848201802"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="848201802"
Received: from hkchanda-mobl.amr.corp.intel.com (HELO desk) ([10.209.90.113])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 13:45:30 -0700
Date:   Fri, 20 Oct 2023 13:45:29 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com
Cc:     linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH  6/6] KVM: VMX: Move VERW closer to VMentry for MDS mitigation
Message-ID: <20231020-delay-verw-v1-6-cff54096326d@linux.intel.com>
X-Mailer: b4 0.12.3
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During VMentry VERW is executed to mitigate MDS. After VERW, any memory
access like register push onto stack may put host data in MDS affected
CPU buffers. A guest can then use MDS to sample host data.

Although likelihood of secrets surviving in registers at current VERW
callsite is less, but it can't be ruled out. Harden the MDS mitigation
by moving the VERW mitigation late in VMentry path.

Note that VERW for MMIO Stale Data mitigation is unchanged because of
the complexity of per-guest conditional VERW which is not easy to handle
that late in asm with no GPRs available. If the CPU is also affected by
MDS, VERW is unconditionally executed late in asm regardless of guest
having MMIO access.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/kvm/vmx/vmenter.S |  9 +++++++++
 arch/x86/kvm/vmx/vmx.c     | 10 +++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index be275a0410a8..efa716cf4727 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/linkage.h>
 #include <asm/asm.h>
+#include <asm/segment.h>
 #include <asm/bitsperlong.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/nospec-branch.h>
@@ -31,6 +32,8 @@
 #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
 #endif
 
+#define GUEST_CLEAR_CPU_BUFFERS		USER_CLEAR_CPU_BUFFERS
+
 .macro VMX_DO_EVENT_IRQOFF call_insn call_target
 	/*
 	 * Unconditionally create a stack frame, getting the correct RSP on the
@@ -177,10 +180,16 @@ SYM_FUNC_START(__vmx_vcpu_run)
  * the 'vmx_vmexit' label below.
  */
 .Lvmresume:
+	/* Mitigate CPU data sampling attacks .e.g. MDS */
+	GUEST_CLEAR_CPU_BUFFERS
+
 	vmresume
 	jmp .Lvmfail
 
 .Lvmlaunch:
+	/* Mitigate CPU data sampling attacks .e.g. MDS */
+	GUEST_CLEAR_CPU_BUFFERS
+
 	vmlaunch
 	jmp .Lvmfail
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c16297a49e4d..e3d0eda292c3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7226,13 +7226,17 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	guest_state_enter_irqoff();
 
-	/* L1D Flush includes CPU buffer clear to mitigate MDS */
+	/*
+	 * L1D Flush includes CPU buffer clear to mitigate MDS, but VERW
+	 * mitigation for MDS is done late in VMentry and is still executed
+	 * inspite of L1D Flush. This is because an extra VERW should not matter
+	 * much after the big hammer L1D Flush.
+	 */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
-	else if (cpu_feature_enabled(X86_FEATURE_USER_CLEAR_CPU_BUF))
-		mds_clear_cpu_buffers();
 	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
 		 kvm_arch_has_assigned_device(vcpu->kvm))
+		/* MMIO mitigation is mutually exclusive to MDS mitigation later in asm */
 		mds_clear_cpu_buffers();
 
 	vmx_disable_fb_clear(vmx);

-- 
2.34.1



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0738D7D9BA3
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 16:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346089AbjJ0Oj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 10:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346132AbjJ0OjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 10:39:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3195610DB;
        Fri, 27 Oct 2023 07:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698417555; x=1729953555;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mjKmJXB8oVMEQJ55YBl9y3vDRhOMcEONKyySoTTCMIQ=;
  b=RBWjJBXCODCf+1lv6IFxLpNKiOi0W249ivbKQlHK2/AL30xAd3AzvK3N
   LmE+gJNT20pwF1y2G0kPQ8yRr7npy3fqqKEK8JspS7AchJI0e3DsFklDg
   nudiPdPXRc/PSktFDkRKtCC1kqVgW+Rna6xtk12fp4s4RbVnB0Gx/47s9
   2aXPq0G180BDJPAZTRTWuERI+CbM9NvNhbRzznIl40LPPDew52YbMh1ut
   LRX+E0w8DQpHhwO3leAl2lOZoAJeY+LKotw9zGJwNi1t5gD3KNvIBjBki
   reXRi/gQLDwyR9PVNUyP6W9LUmyPht3gNXBeNSnUBSZXJQ+ZFYa9ZGdL7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="606760"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="606760"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 07:39:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="736094456"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="736094456"
Received: from dmnassar-mobl.amr.corp.intel.com (HELO desk) ([10.212.203.39])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 07:39:12 -0700
Date:   Fri, 27 Oct 2023 07:39:12 -0700
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
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Nikolay Borisov <nik.borisov@suse.com>
Cc:     linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH  v4 6/6] KVM: VMX: Move VERW closer to VMentry for MDS
 mitigation
Message-ID: <20231027-delay-verw-v4-6-9a3622d4bcf7@linux.intel.com>
X-Mailer: b4 0.12.3
References: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/vmenter.S |  3 +++
 arch/x86/kvm/vmx/vmx.c     | 19 ++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index b3b13ec04bac..139960deb736 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -161,6 +161,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Load guest RAX.  This kills the @regs pointer! */
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
+	/* Clobbers EFLAGS.ZF */
+	CLEAR_CPU_BUFFERS
+
 	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
 	jnc .Lvmlaunch
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 24e8694b83fc..a05c6b80b06c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7226,16 +7226,24 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	guest_state_enter_irqoff();
 
-	/* L1D Flush includes CPU buffer clear to mitigate MDS */
+	/*
+	 * L1D Flush includes CPU buffer clear to mitigate MDS, but VERW
+	 * mitigation for MDS is done late in VMentry and is still
+	 * executed in spite of L1D Flush. This is because an extra VERW
+	 * should not matter much after the big hammer L1D Flush.
+	 */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
-	else if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF))
-		mds_clear_cpu_buffers();
 	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
 		 kvm_arch_has_assigned_device(vcpu->kvm))
 		mds_clear_cpu_buffers();
 
-	vmx_disable_fb_clear(vmx);
+	/*
+	 * Optimize the latency of VERW in guests for MMIO mitigation. Skip
+	 * the optimization when MDS mitigation(later in asm) is enabled.
+	 */
+	if (!cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF))
+		vmx_disable_fb_clear(vmx);
 
 	if (vcpu->arch.cr2 != native_read_cr2())
 		native_write_cr2(vcpu->arch.cr2);
@@ -7248,7 +7256,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	vmx->idt_vectoring_info = 0;
 
-	vmx_enable_fb_clear(vmx);
+	if (!cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF))
+		vmx_enable_fb_clear(vmx);
 
 	if (unlikely(vmx->fail)) {
 		vmx->exit_reason.full = 0xdead;

-- 
2.34.1



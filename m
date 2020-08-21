Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7B224CB07
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 04:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgHUCvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 22:51:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:54690 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726975AbgHUCvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 22:51:04 -0400
IronPort-SDR: 9Uc10Ob7R9FsPpKarIjdIuuxfXhNp6CcWtxjfaaXzEHFeHjjwvB8begXQv/CE/vbVBwQk1z/NP
 /kjA59XcBG9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="153051709"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="153051709"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2020 19:51:04 -0700
IronPort-SDR: QaK6LNpXa1ocVtIBAx1I+9UT+UaUgCzWAQaqs+chC4eT3+5mLHuK46MVaPy6psrJhb4UpnanRb
 f21Mov7iOfLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="278797794"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga007.fm.intel.com with ESMTP; 20 Aug 2020 19:51:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] x86/entry/64: Disallow RDPID in paranoid entry if KVM is enabled
Date:   Thu, 20 Aug 2020 19:50:50 -0700
Message-Id: <20200821025050.32573-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't use RDPID in the paranoid entry flow if KVM is enabled as doing so
can consume a KVM guest's MSR_TSC_AUX value if an NMI arrives in KVM's
run loop.

As a performance optimization, KVM loads the guest's TSC_AUX when a CPU
first enters its run loop, and on AMD's SVM doesn't restore the host's
value until the CPU exits the run loop.  VMX is even more aggressive and
defers restoring the host's value until the CPU returns to userspace.
This optimization obviously relies on the kernel not consuming TSC_AUX,
which falls apart if an NMI arrives in the run loop.

Removing KVM's optimizaton would be painful, as both SVM and VMX would
need to context switch the MSR on every VM-Enter (2x WRMSR + 1x RDMSR),
whereas using LSL instead RDPID is a minor blip.

Fixes: eaad981291ee3 ("x86/entry/64: Introduce the FIND_PERCPU_BASE macro")
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Chang Seok Bae <chang.seok.bae@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
Debugged-by: Tom Lendacky <thomas.lendacky@amd.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Andy, I know you said "unconditionally", but it felt weird adding a
comment way down in GET_PERCPU_BASE without plumbing a param in to help
provide context.  But, paranoid_entry is the only user so adding a param
that is unconditional also felt weird.  That being said, I definitely
don't have a strong opinion one way or the other.

 arch/x86/entry/calling.h  | 10 +++++++---
 arch/x86/entry/entry_64.S |  7 ++++++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 98e4d8886f11c..a925c0cf89c1a 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -342,9 +342,9 @@ For 32-bit we have the following conventions - kernel is built with
 #endif
 .endm
 
-.macro SAVE_AND_SET_GSBASE scratch_reg:req save_reg:req
+.macro SAVE_AND_SET_GSBASE scratch_reg:req save_reg:req no_rdpid=0
 	rdgsbase \save_reg
-	GET_PERCPU_BASE \scratch_reg
+	GET_PERCPU_BASE \scratch_reg \no_rdpid
 	wrgsbase \scratch_reg
 .endm
 
@@ -375,11 +375,15 @@ For 32-bit we have the following conventions - kernel is built with
  * We normally use %gs for accessing per-CPU data, but we are setting up
  * %gs here and obviously can not use %gs itself to access per-CPU data.
  */
-.macro GET_PERCPU_BASE reg:req
+.macro GET_PERCPU_BASE reg:req no_rdpid=0
+	.if \no_rdpid
+	LOAD_CPU_AND_NODE_SEG_LIMIT \reg
+	.else
 	ALTERNATIVE \
 		"LOAD_CPU_AND_NODE_SEG_LIMIT \reg", \
 		"RDPID	\reg", \
 		X86_FEATURE_RDPID
+	.endif
 	andq	$VDSO_CPUNODE_MASK, \reg
 	movq	__per_cpu_offset(, \reg, 8), \reg
 .endm
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 70dea93378162..fd915c46297c5 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -842,8 +842,13 @@ SYM_CODE_START_LOCAL(paranoid_entry)
 	 *
 	 * The MSR write ensures that no subsequent load is based on a
 	 * mispredicted GSBASE. No extra FENCE required.
+	 *
+	 * Disallow RDPID if KVM is enabled as it may consume a guest's TSC_AUX
+	 * if an NMI arrives in KVM's run loop.  KVM loads guest's TSC_AUX on
+	 * VM-Enter and may not restore the host's value until the CPU returns
+	 * to userspace, i.e. KVM depends on the kernel not using TSC_AUX.
 	 */
-	SAVE_AND_SET_GSBASE scratch_reg=%rax save_reg=%rbx
+	SAVE_AND_SET_GSBASE scratch_reg=%rax save_reg=%rbx no_rdpid=IS_ENABLED(CONFIG_KVM)
 	ret
 
 .Lparanoid_entry_checkgs:
-- 
2.28.0


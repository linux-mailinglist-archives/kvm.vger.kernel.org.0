Return-Path: <kvm+bounces-42501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 71DA7A79505
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 20:22:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B570D189102D
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 18:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06BB91F0E4F;
	Wed,  2 Apr 2025 18:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPKNpfsC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E891EFFA6;
	Wed,  2 Apr 2025 18:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743618002; cv=none; b=mQXUD2yvem1ljzgF9n5dR7PdVsRmBcM6DHmqW+fojiezSqS3wjTg/hAupOBxufKypZ+7bZacktprEi3tkfjIDuNM/+HbkMJbktBLrVf11MWRjQOkpWrL3NyAZctPO2xu3kH0pg3Pqettpy6n7iIqQYCtyiolB5mCY4D2C71S8/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743618002; c=relaxed/simple;
	bh=S/yW0WljGBGazJK8E2H09ljwQ3dxrafbW7SAjZXkxOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3sVGjR1ICW0NHJxD/rnopDZV+bzlPxENbXsJ4yanYVMisAddNpiQIJGO/VyKUEhx6anlTOv8IOHnJ1S5TXrBlW5bri3mLRGPPjjdHxUFyeUr7nYZLWhnX9oW9MHzSjF1GdwoBYUzqeoL93PnUzRUjGJX777WxiPgilmjmaYNOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPKNpfsC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244B7C4CEEA;
	Wed,  2 Apr 2025 18:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743618002;
	bh=S/yW0WljGBGazJK8E2H09ljwQ3dxrafbW7SAjZXkxOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPKNpfsC17IoFFmJXDWyXqtNKeoy6nqG6n9EOcVx9jveQeiZ+7cEs11t89of/10m6
	 RJAuG6bjRkR6fA1/8XoVS9B54a1HB1mPPxlcbiJKXNQx+mmpMbuDiIK9R/Wvs4Jyli
	 zfwupFEb6TjL7a+Pwpom+LSPEsreB+NU6EzAJ1JdOxWx11C50qHkYPzI0GFwPxC6D+
	 3lAQv46qhUteGM8LsK4cMRTvYn7UdAfAu2AhJw1zdvt+n/jMEqwxioI4hgs6yh21//
	 WH8oj0mDt81N5vFdfmhZkYDktPL7iBsOKsnZt1C8O4WHm+OMEhSjwJzUYqJSkGTRsc
	 U3POoY4wgLAeg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	amit@kernel.org,
	kvm@vger.kernel.org,
	amit.shah@amd.com,
	thomas.lendacky@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com,
	corbet@lwn.net,
	mingo@redhat.com,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com,
	kai.huang@intel.com,
	sandipan.das@amd.com,
	boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com,
	david.kaplan@amd.com,
	dwmw@amazon.co.uk,
	andrew.cooper3@citrix.com
Subject: [PATCH v3 6/6] x86/bugs: Add RSB mitigation document
Date: Wed,  2 Apr 2025 11:19:23 -0700
Message-ID: <d6c07c8ae337525cbb5d926d692e8969c2cf698d.1743617897.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743617897.git.jpoimboe@kernel.org>
References: <cover.1743617897.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create a document to summarize hard-earned knowledge about RSB-related
mitigations, with references, and replace the overly verbose yet
incomplete comments with a reference to the document.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 Documentation/admin-guide/hw-vuln/index.rst |   1 +
 Documentation/admin-guide/hw-vuln/rsb.rst   | 241 ++++++++++++++++++++
 arch/x86/kernel/cpu/bugs.c                  |  64 ++----
 3 files changed, 255 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/admin-guide/hw-vuln/rsb.rst

diff --git a/Documentation/admin-guide/hw-vuln/index.rst b/Documentation/admin-guide/hw-vuln/index.rst
index ff0b440ef2dc..451874b8135d 100644
--- a/Documentation/admin-guide/hw-vuln/index.rst
+++ b/Documentation/admin-guide/hw-vuln/index.rst
@@ -22,3 +22,4 @@ are configurable at compile, boot or run time.
    srso
    gather_data_sampling
    reg-file-data-sampling
+   rsb
diff --git a/Documentation/admin-guide/hw-vuln/rsb.rst b/Documentation/admin-guide/hw-vuln/rsb.rst
new file mode 100644
index 000000000000..97bf75993d5d
--- /dev/null
+++ b/Documentation/admin-guide/hw-vuln/rsb.rst
@@ -0,0 +1,241 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======================
+RSB-related mitigations
+=======================
+
+.. warning::
+   Please keep this document up-to-date, otherwise you will be
+   volunteered to update it and convert it to a very long comment in
+   bugs.c!
+
+Since 2018 there have been many Spectre CVEs related to the Return Stack
+Buffer (RSB).  Information about these CVEs and how to mitigate them is
+scattered amongst a myriad of microarchitecture-specific documents.
+
+This document attempts to consolidate all the relevant information in
+once place and clarify the reasoning behind the current RSB-related
+mitigations.
+
+At a high level, there are two classes of RSB attacks: RSB poisoning
+(Intel and AMD) and RSB underflow (Intel only).  They must each be
+considered individually for each attack vector (and microarchitecture
+where applicable).
+
+----
+
+RSB poisoning (Intel and AMD)
+=============================
+
+SpectreRSB
+~~~~~~~~~~
+
+RSB poisoning is a technique used by Spectre-RSB [#spectre-rsb]_ where
+an attacker poisons an RSB entry to cause a victim's return instruction
+to speculate to an attacker-controlled address.  This can happen when
+there are unbalanced CALLs/RETs after a context switch or VMEXIT.
+
+* All attack vectors can potentially be mitigated by flushing out any
+  poisoned RSB entries using an RSB filling sequence
+  [#intel-rsb-filling]_ [#amd-rsb-filling]_ when transitioning between
+  untrusted and trusted domains.  But this has a performance impact and
+  should be avoided whenever possible.
+
+* On context switch, the user->user mitigation requires ensuring the
+  RSB gets filled or cleared whenever IBPB gets written [#cond-ibpb]_
+  during a context switch:
+
+  * AMD:
+	IBPB (or SBPB [#amd-sbpb]_ if used) automatically clears the RSB
+	if IBPB_RET is set in CPUID [#amd-ibpb-rsb]_.  Otherwise the RSB
+	filling sequence [#amd-rsb-filling]_ must be always be done in
+	addition to IBPB.
+
+  * Intel:
+	IBPB automatically clears the RSB:
+
+	"Software that executed before the IBPB command cannot control
+	the predicted targets of indirect branches executed after the
+	command on the same logical processor. The term indirect branch
+	in this context includes near return instructions, so these
+	predicted targets may come from the RSB." [#intel-ibpb-rsb]_
+
+* On context switch, user->kernel attacks are mitigated by SMEP, as user
+  space can only insert its own return addresses into the RSB:
+
+  * AMD:
+	"Finally, branches that are predicted as 'ret' instructions get
+	their predicted targets from the Return Address Predictor (RAP).
+	AMD recommends software use a RAP stuffing sequence (mitigation
+	V2-3 in [2]) and/or Supervisor Mode Execution Protection (SMEP)
+	to ensure that the addresses in the RAP are safe for
+	speculation. Collectively, we refer to these mitigations as "RAP
+	Protection"." [#amd-smep-rsb]_
+
+  * Intel:
+	"On processors with enhanced IBRS, an RSB overwrite sequence may
+	not suffice to prevent the predicted target of a near return
+	from using an RSB entry created in a less privileged predictor
+	mode.  Software can prevent this by enabling SMEP (for
+	transitions from user mode to supervisor mode) and by having
+	IA32_SPEC_CTRL.IBRS set during VM exits." [#intel-smep-rsb]_
+
+* On VMEXIT, guest->host attacks are mitigated by eIBRS (and PBRSB
+  mitigation if needed):
+
+  * AMD:
+	"When Automatic IBRS is enabled, the internal return address
+	stack used for return address predictions is cleared on VMEXIT."
+	[#amd-eibrs-vmexit]_
+
+  * Intel:
+	"On processors with enhanced IBRS, an RSB overwrite sequence may
+	not suffice to prevent the predicted target of a near return
+	from using an RSB entry created in a less privileged predictor
+	mode.  Software can prevent this by enabling SMEP (for
+	transitions from user mode to supervisor mode) and by having
+	IA32_SPEC_CTRL.IBRS set during VM exits. Processors with
+	enhanced IBRS still support the usage model where IBRS is set
+	only in the OS/VMM for OSes that enable SMEP. To do this, such
+	processors will ensure that guest behavior cannot control the
+	RSB after a VM exit once IBRS is set, even if IBRS was not set
+	at the time of the VM exit." [#intel-eibrs-vmexit]_
+
+    Note that some Intel CPUs are susceptible to Post-barrier Return
+    Stack Buffer Predictions (PBRSB)[#intel-pbrsb]_, where the last CALL
+    from the guest can be used to predict the first unbalanced RET.  In
+    this case the PBRSB mitigation is needed in addition to eIBRS.
+
+AMD Retbleed / SRSO / Branch Type Confusion
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+On AMD, poisoned RSB entries can also be created by the AMD Retbleed
+variant [#retbleed-paper]_ and/or Speculative Return Stack Overflow
+[#amd-srso]_ (Inception [#inception-paper]_).  These attacks are made
+possible by Branch Type Confusion [#amd-btc]_.  The kernel protects
+itself by replacing every RET in the kernel with a branch to a single
+safe RET.
+
+----
+
+RSB underflow (Intel only)
+==========================
+
+Intel Retbleed
+~~~~~~~~~~~~~~
+
+Some Intel Skylake-generation CPUs are susceptible to the Intel variant
+of Retbleed [#retbleed-paper]_ (Return Stack Buffer Underflow
+[#intel-rsbu]_).  If a RET is executed when the RSB buffer is empty due
+to mismatched CALLs/RETs or returning from a deep call stack, the branch
+predictor can fall back to using the Branch Target Buffer (BTB).  If a
+user forces a BTB collision then the RET can speculatively branch to a
+user-controlled address.
+
+* Note that RSB filling doesn't fully mitigate this issue.  If there
+  are enough unbalanced RETs, the RSB may still underflow and fall back
+  to using a poisoned BTB entry.
+
+* On context switch, user->user underflow attacks are mitigated by the
+  conditional IBPB [#cond-ibpb]_ on context switch which clears the BTB:
+
+  * "The indirect branch predictor barrier (IBPB) is an indirect branch
+    control mechanism that establishes a barrier, preventing software
+    that executed before the barrier from controlling the predicted
+    targets of indirect branches executed after the barrier on the same
+    logical processor." [#intel-ibpb-btb]_
+
+    .. note::
+       I wasn't able to find any offical documentation from Intel
+       explicitly stating that IBPB clears the BTB.  However, it's
+       broadly known to be true and relied upon in several mitigations.
+
+* On context switch and VMEXIT, user->kernel and guest->host underflows
+  are mitigated by IBRS or eIBRS:
+
+  * "Enabling IBRS (including enhanced IBRS) will mitigate the "RSBU"
+    attack demonstrated by the researchers. As previously documented,
+    Intel recommends the use of enhanced IBRS, where supported. This
+    includes any processor that enumerates RRSBA but not RRSBA_DIS_S."
+    [#intel-rsbu]_
+
+  As an alternative to classic IBRS, call depth tracking can be used to
+  track kernel returns and fill the RSB when it gets close to being
+  empty.
+
+Restricted RSB Alternate (RRSBA)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Some newer Intel CPUs have Restricted RSB Alternate (RRSBA) behavior,
+which, similar to the Intel variant of Retbleed described above, also
+falls back to using the BTB on RSB underflow.  The only difference is
+that the predicted targets are restricted to the current domain.
+
+* "Restricted RSB Alternate (RRSBA) behavior allows alternate branch
+  predictors to be used by near RET instructions when the RSB is
+  empty.  When eIBRS is enabled, the predicted targets of these
+  alternate predictors are restricted to those belonging to the
+  indirect branch predictor entries of the current prediction domain.
+  [#intel-eibrs-rrsba]_
+
+When a CPU with RRSBA is vulnerable to Branch History Injection
+[#bhi-paper]_ [#intel-bhi]_, an RSB underflow could be used for an
+intra-mode BTI attack.  This is mitigated by clearing the BHB on
+kernel entry.
+
+However if the kernel uses retpolines instead of eIBRS, it needs to
+disable RRSBA:
+
+* "Where software is using retpoline as a mitigation for BHI or
+  intra-mode BTI, and the processor both enumerates RRSBA and
+  enumerates RRSBA_DIS controls, it should disable this behavior. "
+  [#intel-retpoline-rrsba]_
+
+----
+
+References
+==========
+
+.. [#spectre-rsb] `Spectre Returns! Speculation Attacks using the Return Stack Buffer <https://arxiv.org/pdf/1807.07940.pdf>`_
+
+.. [#intel-rsb-filling] "Empty RSB Mitigation on Skylake-generation" in `Retpoline: A Branch Target Injection Mitigation <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/retpoline-branch-target-injection-mitigation.html#inpage-nav-5-1>`_
+
+.. [#amd-rsb-filling] "Mitigation V2-3" in `Software Techniques for Managing Speculation <https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/software-techniques-for-managing-speculation.pdf>`_
+
+.. [#cond-ibpb] Whether IBPB is written depends on whether the prev and/or next task is protected from Spectre attacks.  It typically requires opting in per task or system-wide.  For more details see the documentation for the ``spectre_v2_user`` cmdline option in Documentation/admin-guide/kernel-parameters.txt.
+
+.. [#amd-sbpb] IBPB without flushing of branch type predictions.  Only exists for AMD.
+
+.. [#amd-ibpb-rsb] "Function 8000_0008h -- Processor Capacity Parameters and Extended Feature Identification" in `AMD64 Architecture Programmer's Manual Volume 3: General-Purpose and System Instructions <https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/24594.pdf>`_.  SBPB behaves the same way according to `this email <https://lore.kernel.org/5175b163a3736ca5fd01cedf406735636c99a>`_.
+
+.. [#intel-ibpb-rsb] "Introduction" in `Post-barrier Return Stack Buffer Predictions / CVE-2022-26373 / INTEL-SA-00706 <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/post-barrier-return-stack-buffer-predictions.html>`_
+
+.. [#amd-smep-rsb] "Existing Mitigations" in `Technical Guidance for Mitigating Branch Type Confusion <https://www.amd.com/content/dam/amd/en/documents/resources/technical-guidance-for-mitigating-branch-type-confusion.pdf>`_
+
+.. [#intel-smep-rsb] "Enhanced IBRS" in `Indirect Branch Restricted Speculation <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/indirect-branch-restricted-speculation.html>`_
+
+.. [#amd-eibrs-vmexit] "Extended Feature Enable Register (EFER)" in `AMD64 Architecture Programmer's Manual Volume 2: System Programming <https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/24593.pdf>`_
+
+.. [#intel-eibrs-vmexit] "Enhanced IBRS" in `Indirect Branch Restricted Speculation <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/indirect-branch-restricted-speculation.html>`_
+
+.. [#intel-pbrsb] `Post-barrier Return Stack Buffer Predictions / CVE-2022-26373 / INTEL-SA-00706 <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/post-barrier-return-stack-buffer-predictions.html>`_
+
+.. [#retbleed-paper] `Retbleed: Arbitrary Speculative Code Execution with Return Instruction <https://comsec.ethz.ch/wp-content/files/retbleed_sec22.pdf>`_
+
+.. [#amd-btc] `Technical Guidance for Mitigating Branch Type Confusion <https://www.amd.com/content/dam/amd/en/documents/resources/technical-guidance-for-mitigating-branch-type-confusion.pdf>`_
+
+.. [#amd-srso] `Technical Update Regarding Speculative Return Stack Overflow <https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf>`_
+
+.. [#inception-paper] `Inception: Exposing New Attack Surfaces with Training in Transient Execution <https://comsec.ethz.ch/wp-content/files/inception_sec23.pdf>`_
+
+.. [#intel-rsbu] `Return Stack Buffer Underflow / Return Stack Buffer Underflow / CVE-2022-29901, CVE-2022-28693 / INTEL-SA-00702 <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/return-stack-buffer-underflow.html>`_
+
+.. [#intel-ibpb-btb] `Indirect Branch Predictor Barrier' <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/indirect-branch-predictor-barrier.html>`_
+
+.. [#intel-eibrs-rrsba] "Guidance for RSBU" in `Return Stack Buffer Underflow / Return Stack Buffer Underflow / CVE-2022-29901, CVE-2022-28693 / INTEL-SA-00702 <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/return-stack-buffer-underflow.html>`_
+
+.. [#bhi-paper] `Branch History Injection: On the Effectiveness of Hardware Mitigations Against Cross-Privilege Spectre-v2 Attacks <http://download.vusec.net/papers/bhi-spectre-bhb_sec22.pdf>`_
+
+.. [#intel-bhi] `Branch History Injection and Intra-mode Branch Target Injection / CVE-2022-0001, CVE-2022-0002 / INTEL-SA-00598 <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html>`_
+
+.. [#intel-retpoline-rrsba] "Retpoline" in `Branch History Injection and Intra-mode Branch Target Injection / CVE-2022-0001, CVE-2022-0002 / INTEL-SA-00598 <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html>`_
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 680c779e9711..e78bb781c091 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1594,25 +1594,25 @@ static void __init spec_ctrl_disable_kernel_rrsba(void)
 static void __init spectre_v2_select_rsb_mitigation(enum spectre_v2_mitigation mode)
 {
 	/*
-	 * Similar to context switches, there are two types of RSB attacks
-	 * after VM exit:
+	 * WARNING! There are many subtleties to consider when changing *any*
+	 * code related to RSB-related mitigations.  Before doing so, carefully
+	 * read the following document, and update if necessary:
 	 *
-	 * 1) RSB underflow
+	 *   Documentation/admin-guide/hw-vuln/rsb.rst
 	 *
-	 * 2) Poisoned RSB entry
+	 * In an overly simplified nutshell:
 	 *
-	 * When retpoline is enabled, both are mitigated by filling/clearing
-	 * the RSB.
+	 *   - User->user RSB attacks are conditionally mitigated during
+	 *     context switch by cond_mitigation -> __write_ibpb().
 	 *
-	 * When IBRS is enabled, while #1 would be mitigated by the IBRS branch
-	 * prediction isolation protections, RSB still needs to be cleared
-	 * because of #2.  Note that SMEP provides no protection here, unlike
-	 * user-space-poisoned RSB entries.
+	 *   - User->kernel and guest->host attacks are mitigated by eIBRS or
+	 *     RSB filling.
 	 *
-	 * eIBRS should protect against RSB poisoning, but if the EIBRS_PBRSB
-	 * bug is present then a LITE version of RSB protection is required,
-	 * just a single call needs to retire before a RET is executed.
+	 *     Though, depending on config, note that other alternative
+	 *     mitigations may end up getting used instead, e.g., IBPB on
+	 *     entry/vmexit, call depth tracking, or return thunks.
 	 */
+
 	switch (mode) {
 	case SPECTRE_V2_NONE:
 		break;
@@ -1832,44 +1832,6 @@ static void __init spectre_v2_select_mitigation(void)
 	spectre_v2_enabled = mode;
 	pr_info("%s\n", spectre_v2_strings[mode]);
 
-	/*
-	 * If Spectre v2 protection has been enabled, fill the RSB during a
-	 * context switch.  In general there are two types of RSB attacks
-	 * across context switches, for which the CALLs/RETs may be unbalanced.
-	 *
-	 * 1) RSB underflow
-	 *
-	 *    Some Intel parts have "bottomless RSB".  When the RSB is empty,
-	 *    speculated return targets may come from the branch predictor,
-	 *    which could have a user-poisoned BTB or BHB entry.
-	 *
-	 *    AMD has it even worse: *all* returns are speculated from the BTB,
-	 *    regardless of the state of the RSB.
-	 *
-	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack
-	 *    scenario is mitigated by the IBRS branch prediction isolation
-	 *    properties, so the RSB buffer filling wouldn't be necessary to
-	 *    protect against this type of attack.
-	 *
-	 *    The "user -> user" attack scenario is mitigated by RSB filling.
-	 *
-	 * 2) Poisoned RSB entry
-	 *
-	 *    If the 'next' in-kernel return stack is shorter than 'prev',
-	 *    'next' could be tricked into speculating with a user-poisoned RSB
-	 *    entry.
-	 *
-	 *    The "user -> kernel" attack scenario is mitigated by SMEP and
-	 *    eIBRS.
-	 *
-	 *    The "user -> user" scenario, also known as SpectreBHB, requires
-	 *    RSB clearing.
-	 *
-	 * So to mitigate all cases, unconditionally fill RSB on context
-	 * switches.
-	 *
-	 * FIXME: Is this pointless for retbleed-affected AMD?
-	 */
 	spectre_v2_select_rsb_mitigation(mode);
 
 	/*
-- 
2.48.1



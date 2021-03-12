Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC5D338D3E
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 13:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhCLMi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 07:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhCLMie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 07:38:34 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0E0C061761;
        Fri, 12 Mar 2021 04:38:34 -0800 (PST)
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 82E45412;
        Fri, 12 Mar 2021 13:38:31 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 2/8] x86/sev: Do not require Hypervisor CPUID bit for SEV guests
Date:   Fri, 12 Mar 2021 13:38:18 +0100
Message-Id: <20210312123824.306-3-joro@8bytes.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210312123824.306-1-joro@8bytes.org>
References: <20210312123824.306-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

A malicious hypervisor could disable the CPUID intercept for an SEV or
SEV-ES guest and trick it into the no-SEV boot path, where it could
potentially reveal secrets. This is not an issue for SEV-SNP guests,
as the CPUID intercept can't be disabled for those.

Remove the Hypervisor CPUID bit check from the SEV detection code to
protect against this kind of attack and add a Hypervisor bit equals
zero check to the SME detection path to prevent non-SEV guests from
trying to enable SME.

This handles the following cases:

	1) SEV(-ES) guest where CPUID intercept is disabled. The guest
	   will still see leaf 0x8000001f and the SEV bit. It can
	   retrieve the C-bit and boot normally.

	2) Non-SEV guests with intercepted CPUID will check SEV_STATUS
	   MSR and find it 0 and will try to enable SME. This will
	   fail when the guest finds MSR_K8_SYSCFG to be zero, as it
	   is emulated by KVM. But we can't rely on that, as there
	   might be other hypervisors which return this MSR with bit
	   23 set. The Hypervisor bit check will prevent that the
	   guest tries to enable SME in this case.

	3) Non-SEV guests on SEV capable hosts with CPUID intercept
	   disabled (by a malicious hypervisor) will try to boot into
	   the SME path. This will fail, but it is also not considered
	   a problem because non-encrypted guests have no protection
	   against the hypervisor anyway.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/mem_encrypt.S |  6 -----
 arch/x86/kernel/sev-es-shared.c        |  6 +----
 arch/x86/mm/mem_encrypt_identity.c     | 35 ++++++++++++++------------
 3 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/arch/x86/boot/compressed/mem_encrypt.S b/arch/x86/boot/compressed/mem_encrypt.S
index aa561795efd1..a6dea4e8a082 100644
--- a/arch/x86/boot/compressed/mem_encrypt.S
+++ b/arch/x86/boot/compressed/mem_encrypt.S
@@ -23,12 +23,6 @@ SYM_FUNC_START(get_sev_encryption_bit)
 	push	%ecx
 	push	%edx
 
-	/* Check if running under a hypervisor */
-	movl	$1, %eax
-	cpuid
-	bt	$31, %ecx		/* Check the hypervisor bit */
-	jnc	.Lno_sev
-
 	movl	$0x80000000, %eax	/* CPUID to check the highest leaf */
 	cpuid
 	cmpl	$0x8000001f, %eax	/* See if 0x8000001f is available */
diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
index cdc04d091242..387b71669818 100644
--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -186,7 +186,6 @@ void __init do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code)
 	 * make it accessible to the hypervisor.
 	 *
 	 * In particular, check for:
-	 *	- Hypervisor CPUID bit
 	 *	- Availability of CPUID leaf 0x8000001f
 	 *	- SEV CPUID bit.
 	 *
@@ -194,10 +193,7 @@ void __init do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code)
 	 * can't be checked here.
 	 */
 
-	if ((fn == 1 && !(regs->cx & BIT(31))))
-		/* Hypervisor bit */
-		goto fail;
-	else if (fn == 0x80000000 && (regs->ax < 0x8000001f))
+	if (fn == 0x80000000 && (regs->ax < 0x8000001f))
 		/* SEV leaf check */
 		goto fail;
 	else if ((fn == 0x8000001f && !(regs->ax & BIT(1))))
diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index 6c5eb6f3f14f..a19374d26101 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -503,14 +503,10 @@ void __init sme_enable(struct boot_params *bp)
 
 #define AMD_SME_BIT	BIT(0)
 #define AMD_SEV_BIT	BIT(1)
-	/*
-	 * Set the feature mask (SME or SEV) based on whether we are
-	 * running under a hypervisor.
-	 */
-	eax = 1;
-	ecx = 0;
-	native_cpuid(&eax, &ebx, &ecx, &edx);
-	feature_mask = (ecx & BIT(31)) ? AMD_SEV_BIT : AMD_SME_BIT;
+
+	/* Check the SEV MSR whether SEV or SME is enabled */
+	sev_status   = __rdmsr(MSR_AMD64_SEV);
+	feature_mask = (sev_status & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
 
 	/*
 	 * Check for the SME/SEV feature:
@@ -530,19 +526,26 @@ void __init sme_enable(struct boot_params *bp)
 
 	/* Check if memory encryption is enabled */
 	if (feature_mask == AMD_SME_BIT) {
+		/*
+		 * No SME if Hypervisor bit is set. This check is here to
+		 * prevent a guest from trying to enable SME. For running as a
+		 * KVM guest the MSR_K8_SYSCFG will be sufficient, but there
+		 * might be other hypervisors which emulate that MSR as non-zero
+		 * or even pass it through to the guest.
+		 * A malicious hypervisor can still trick a guest into this
+		 * path, but there is no way to protect against that.
+		 */
+		eax = 1;
+		ecx = 0;
+		native_cpuid(&eax, &ebx, &ecx, &edx);
+		if (ecx & BIT(31))
+			return;
+
 		/* For SME, check the SYSCFG MSR */
 		msr = __rdmsr(MSR_K8_SYSCFG);
 		if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
 			return;
 	} else {
-		/* For SEV, check the SEV MSR */
-		msr = __rdmsr(MSR_AMD64_SEV);
-		if (!(msr & MSR_AMD64_SEV_ENABLED))
-			return;
-
-		/* Save SEV_STATUS to avoid reading MSR again */
-		sev_status = msr;
-
 		/* SEV state cannot be controlled by a command line option */
 		sme_me_mask = me_mask;
 		sev_enabled = true;
-- 
2.30.1


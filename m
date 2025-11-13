Return-Path: <kvm+bounces-63108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id ED52DC5AAA7
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:44:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3454E4EE915
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C9652E6127;
	Thu, 13 Nov 2025 23:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ut3ODSdc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C157932ABE1
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763077074; cv=none; b=pNrO15Xih0PRDfzgqop28EsE4EqXQ/yFykDWTZkcYttkE/OUhtR7tg/BOZifKq8OqUwkFgEeq7Tl5jHNI/bsCmysHkypNrUdml67IBfKhm4wbLgJCn4AmoNhFc9HN045xnwaod3ZUIggk+NsZ/TqwdCpkOQO1VTg3VtlcuWrmqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763077074; c=relaxed/simple;
	bh=0rvBOQb7/KjgLAdCRV+FubR5NXzYQ6DUt4LwEzP/hw8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KF5GKPGd69WnkgLc3TFXkS4FQdddpQrTKTYuxHM/yD2V+rDucdipEhT2CobxKgu6WUxctglInP3nWmj+eGv5CIhQ2lG9oh5D0tJ5DgUpUapJawglUGVmL1D0D2sOSDVonXGYronefR3YJyWwvzhlGgAoTjxRXKrXWdTSnDzubE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ut3ODSdc; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343daf0f488so2053304a91.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763077072; x=1763681872; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=agrcyZXVeAoDNpOX3Y9kFCrU6uZpFNbMSLv5IvOZ2fY=;
        b=ut3ODSdcaarnt44PB8XxmhcCTFyM5KGtHpvLPKHMpGi82/PpdH3oQ4SLBemHXXN/pq
         ZMHK+HWs/SCoszR6NCVRaCvPZbDfmd88qDaf0AGOfbfeNxHG2vAjanfZ6QC2+nEX/IP2
         jIBu00zfqhSAltS3NFOA8hjg5xwK3XHJzzfp5m+h4IYGmp4LCHUslJaQrUtwFbxv36zT
         KFTMAJCQY3OPXFzawTT+UEXK4Lh6JiFvfGJFEbCUVi5moUZh+IjrD5PkJNrR2VFbQLPe
         SvFZRD7vOr/UxbzzmqP2ag0e/QoC/WCMXvTInOyRx3gp4LbHTGSVfzg1FX6/0SLbJ+9e
         d0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763077072; x=1763681872;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=agrcyZXVeAoDNpOX3Y9kFCrU6uZpFNbMSLv5IvOZ2fY=;
        b=fXm19fdIYYKPAOn1rXS4JyQ9ZyqgwTNSEMUP6bfY2xhh5gfFjaaGcOVLVWi+hZM5V3
         P3EKOeGusy4iI5iMDGqnfJg8vK9S9CNicWhx3+GZ1BebREZ6liyaDMHhuZEv41Mu7SPx
         fx7FQPCwlSJ5bagqigIM3yJ7eixvIe7D2vvq7VzCRI3RSC9Ke/hiSLmiwAmmuEUTQR0U
         SzwiM+HusKfpjJWo/ChfsxTb3jPt0aJ9qGVcu5jf3ywyD9qAXv1Va0kOucftsoS/Nq0q
         6bJBeB3I6LWq7oy81UGEpQ8hCreuCtzyvI0Oli1Y+Uv8joRgt1I+yBNTtcafNZQSCFsk
         tOMA==
X-Gm-Message-State: AOJu0YwzAkNM2p8oZPzf01L7lgX523fIK5CeSIRAiJizMi/Wr9DUjHWK
	T6EjD7M/KnkxHw3PNvqJVo/EhLhfVImXHegDMqKTTdBfufaxJMsMNC4blox3XXfwkQglEy8dTl4
	eZwGbjQ==
X-Google-Smtp-Source: AGHT+IGsIphPIOP+Qi59yhXJyxWnKWUiVNSnwW5PiF9bG5U2jX7YId16YUivlnVIwRZejZpt2zGOCzdWVj8=
X-Received: from pjxg3.prod.google.com ([2002:a17:90a:dac3:b0:33b:52d6:e13e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2781:b0:341:134:a962
 with SMTP id 98e67ed59e1d1-343fa638d82mr908199a91.28.1763077071969; Thu, 13
 Nov 2025 15:37:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:37:39 -0800
In-Reply-To: <20251113233746.1703361-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113233746.1703361-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113233746.1703361-3-seanjc@google.com>
Subject: [PATCH v5 2/9] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

TSA mitigation:

  d8010d4ba43e ("x86/bugs: Add a Transient Scheduler Attacks mitigation")

introduced VM_CLEAR_CPU_BUFFERS for guests on AMD CPUs. Currently on Intel
CLEAR_CPU_BUFFERS is being used for guests which has a much broader scope
(kernel->user also).

Make mitigations on Intel consistent with TSA. This would help handling the
guest-only mitigations better in future.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
[sean: make CLEAR_CPU_BUF_VM mutually exclusive with the MMIO mitigation]
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/cpu/bugs.c | 13 +++++++++----
 arch/x86/kvm/vmx/vmenter.S |  2 +-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d7fa03bf51b4..c3a26532a209 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -194,7 +194,7 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 
 /*
  * Controls CPU Fill buffer clear before VMenter. This is a subset of
- * X86_FEATURE_CLEAR_CPU_BUF, and should only be enabled when KVM-only
+ * X86_FEATURE_CLEAR_CPU_BUF_VM, and should only be enabled when KVM-only
  * mitigation is required.
  */
 DEFINE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
@@ -489,8 +489,8 @@ static enum rfds_mitigations rfds_mitigation __ro_after_init =
 	IS_ENABLED(CONFIG_MITIGATION_RFDS) ? RFDS_MITIGATION_AUTO : RFDS_MITIGATION_OFF;
 
 /*
- * Set if any of MDS/TAA/MMIO/RFDS are going to enable VERW clearing
- * through X86_FEATURE_CLEAR_CPU_BUF on kernel and guest entry.
+ * Set if any of MDS/TAA/MMIO/RFDS are going to enable VERW clearing on exit to
+ * userspace *and* on entry to KVM guests.
  */
 static bool verw_clear_cpu_buf_mitigation_selected __ro_after_init;
 
@@ -536,6 +536,7 @@ static void __init mds_apply_mitigation(void)
 	if (mds_mitigation == MDS_MITIGATION_FULL ||
 	    mds_mitigation == MDS_MITIGATION_VMWERV) {
 		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
 		if (!boot_cpu_has(X86_BUG_MSBDS_ONLY) &&
 		    (mds_nosmt || smt_mitigations == SMT_MITIGATIONS_ON))
 			cpu_smt_disable(false);
@@ -647,6 +648,7 @@ static void __init taa_apply_mitigation(void)
 		 * present on host, enable the mitigation for UCODE_NEEDED as well.
 		 */
 		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
 
 		if (taa_nosmt || smt_mitigations == SMT_MITIGATIONS_ON)
 			cpu_smt_disable(false);
@@ -748,6 +750,7 @@ static void __init mmio_apply_mitigation(void)
 	 */
 	if (verw_clear_cpu_buf_mitigation_selected) {
 		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
 		static_branch_disable(&cpu_buf_vm_clear);
 	} else {
 		static_branch_enable(&cpu_buf_vm_clear);
@@ -839,8 +842,10 @@ static void __init rfds_update_mitigation(void)
 
 static void __init rfds_apply_mitigation(void)
 {
-	if (rfds_mitigation == RFDS_MITIGATION_VERW)
+	if (rfds_mitigation == RFDS_MITIGATION_VERW) {
 		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
+	}
 }
 
 static __init int rfds_parse_cmdline(char *str)
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 93cf2ca7919a..7e7bb9b7162f 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -165,7 +165,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
 	/* Clobbers EFLAGS.ZF */
-	CLEAR_CPU_BUFFERS
+	VM_CLEAR_CPU_BUFFERS
 
 	/* Check @flags to see if vmlaunch or vmresume is needed. */
 	testl $VMX_RUN_VMRESUME, WORD_SIZE(%_ASM_SP)
-- 
2.52.0.rc1.455.g30608eb744-goog



Return-Path: <kvm+bounces-61623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 273B9C22C82
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 01:31:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18E501896B8B
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 00:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D5C51E8342;
	Fri, 31 Oct 2025 00:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HSNV1ug8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53762137C52
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 00:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761870650; cv=none; b=CgbtgQR/j/V/OGQgg7PMIgbviXn0Fd7ME7M3MFEZUojsbS0ZJJl38iVtV8LgBn5zr1qlt0+5Vq4t/qPzCAXUpkezTTOhdXLP1GoWHfKb89x7h53AK9YCdhjpVjwaQ2EdwGcO+ba/RuW92VTcojE2fQboio1+WizA+qsGlSDeg6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761870650; c=relaxed/simple;
	bh=eJ+nhqmNAya1k6+OmAJ/q7k3s5/bkxXsA9XB0DsAgRE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VfTiZo3SZ/k/2o3ZmsKj5DQA/2t2btFRxErpXwerpYfexRaPxH/HGaYhC3QbiNerTiSsK7m2S9J/KaW4uBn9UHpLUauPw7eec7rMlRAXikKcRmqtI2s7Y7gQjxmXKU3kLqZ4TSH+M9P1918Xx5yn+h+ouMkGmxwI3epEp7h/TGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HSNV1ug8; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-290b13c5877so31445415ad.0
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 17:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761870648; x=1762475448; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=S9xAWTHA8Zs5WgjY+eo7qPd3VInKr+zSYIAk+wJ4peM=;
        b=HSNV1ug8kG1UFnTQnPipaSCHMelNGBGGc5FcoaLYGduuzlLFja/qJ13vg11AKMIpqd
         fDaqcSHMSRvzEAsNQmDmiWnymE+AJ2B4AI0DKfL9ligV857OpdveGe3COiPS17JkbAen
         P+AP3tRTTj4dUtvDVd9xz4KpIccf52dsnjrMUVEumVJGHF4fh1FiOCfPL+CmVNWsQmG5
         Pzpi/LpypDjufQtFLmiUporlQyX+FtXpri8kuXn1SX696eYXWWdBlUcmecznwo+Xl4mo
         FrWnYb0koaGi+E1kwqGRKqgv8MzcPFCEq9pDK1A/Efm/4MnfToxCgti9mwl+z/yxmWVC
         8QCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761870648; x=1762475448;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S9xAWTHA8Zs5WgjY+eo7qPd3VInKr+zSYIAk+wJ4peM=;
        b=scazeClt9VTZk5JJ31mJuneafv3QHifps3HCdSX9jSvWl1ueOhZg5RHPTglhd+eN9u
         k6FJO5m7G98A8OSS+S9NmKW112GBkTbO98wJC7erhowoQMRmC9CIP7eITkjU8eLpLN/p
         zL+zBWjhl7O5qypN6R7Uc0x75Sx9pSccubHlKhZ6Z+iWC4XI/bDMGVsrJXEWdqWxvetO
         XtlJkOGFBG2b/Ve1XthYeHriCT+8+CzPL8fZ9SBQEDirmSapM1vvux4D2FjABtyRFEiW
         WQbIVyF6WbD4gtXOEhf2OSt6jY57houZhBVrqh9bEyOSeOKqSQV+4tE6m6gbu0dRU45J
         NDGw==
X-Gm-Message-State: AOJu0YyLP2IniMtVO2hBftgyACe7CeVPsUYxWUaHfO6WiiYHEFXaez92
	XZxGXBBYeQ5zydHpW7TA1EqrCRa4c+oA/f1N+8c/QQ8bL9SIa31j/c0Gqb2asnvadh3+eA1TH4x
	cwE1RNw==
X-Google-Smtp-Source: AGHT+IGW9hpj7vBjBBA6u3ERPDC8qtzD54yvG/s87+dvnFJyDmRImsTrlkZ8d1iH/SCn+j3anWxBSXjW36Y=
X-Received: from pjd14.prod.google.com ([2002:a17:90b:54ce:b0:339:ee20:f620])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d487:b0:295:656:4edf
 with SMTP id d9443c01a7336-2951a38d763mr23412465ad.6.1761870647512; Thu, 30
 Oct 2025 17:30:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 17:30:33 -0700
In-Reply-To: <20251031003040.3491385-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031003040.3491385-2-seanjc@google.com>
Subject: [PATCH v4 1/8] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/cpu/bugs.c | 9 +++++++--
 arch/x86/kvm/vmx/vmenter.S | 2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 6a526ae1fe99..723666a1357e 100644
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
index bc255d709d8a..1f99a98a16a2 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -161,7 +161,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
 	/* Clobbers EFLAGS.ZF */
-	CLEAR_CPU_BUFFERS
+	VM_CLEAR_CPU_BUFFERS
 
 	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
 	jnc .Lvmlaunch
-- 
2.51.1.930.gacf6e81ea2-goog



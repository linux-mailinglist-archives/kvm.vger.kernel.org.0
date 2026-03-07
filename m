Return-Path: <kvm+bounces-73201-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6ESLKZN8q2lUdgEAu9opvQ
	(envelope-from <kvm+bounces-73201-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:17:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E3B72294E2
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:17:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 03BB83038AEB
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D01ED2D7D27;
	Sat,  7 Mar 2026 01:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jb8W/uJW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA6D274B59;
	Sat,  7 Mar 2026 01:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772846189; cv=none; b=S0G0nWJovypPZ888d0OiFbHLS3Na6UBE55wMJognNftwkr9rGGNluPgBFX/F87X0uIH1mpm9rSOqKNhqcPE1dzZBv1Q6/k4Qijs+RI3HDtQI5iB487aDT0nVcVmio20n+tUFO1CCG1rzlxRAa9f+8OR5HLG1ZbA4ro6E0osUCjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772846189; c=relaxed/simple;
	bh=/jM89V+CWLDBymMiRseLOgVvpispDMXp3ujS8XoteeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTztVaByAcoUnGvs1ecQhM/uJdsiDIBhnMW5Tb9SHZXq0XDl2nK3MqKX0C8gLCcxsoXffH2sjJP3FXFBcW39+DvzrjwTky4VVKpYNaMR9cmtET+FG2LKXMg+smYjzbTKvCcK1JmxLrPDnmIverYtK1qNRGq63K7t/Frf3gs0k4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jb8W/uJW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C6EC2BC9E;
	Sat,  7 Mar 2026 01:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772846188;
	bh=/jM89V+CWLDBymMiRseLOgVvpispDMXp3ujS8XoteeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jb8W/uJWv+P/jM3HZM0L3apVnUqxDgV2XzXA83iBKzaH58kYseKTfglznYBSIGCFW
	 fafBuLWnn4pc2HqDQNRWu/3KaFWsEO+JWu4MPTek28ynTD6u8j/zde+XJaDtiQCMqp
	 s2NP2Ipi4R1evWz2whr2ytB8WZBgjpuCtXdJ4XyISpy74VJsGmnVzQCt/ASSuKFE7V
	 P7dB0Q/LvjE5gs9effQuFlhSvOmCfziF+LH9+QUpkdAdVECwJQB/WmvdM9zzWxxovU
	 smaqQiFN8dvbdb9IQw0VdZrghYYHapQr12+e9kx+v9Z6UWd1slbr4MjCjxebWOHNn7
	 /Sj+5L03JmFrw==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Venkatesh Srinivas <venkateshs@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v2 1/3] KVM: x86: Move some EFER bits enablement to common code
Date: Sat,  7 Mar 2026 01:16:17 +0000
Message-ID: <20260307011619.2324234-2-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260307011619.2324234-1-yosry@kernel.org>
References: <20260307011619.2324234-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2E3B72294E2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73201-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.982];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Move EFER bits enablement that only depend on CPU support to common
code, as there is no reason to do it in vendor code. Leave EFER.SVME and
EFER.LMSLE enablement in SVM code as they depend on vendor module
parameters.

Having the enablement in common code ensures that if a vendor starts
supporting an existing feature, KVM doesn't end up advertising to
userspace but not allowing the EFER bit to be set.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/svm.c |  7 -------
 arch/x86/kvm/vmx/vmx.c |  4 ----
 arch/x86/kvm/x86.c     | 14 ++++++++++++++
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3407deac90bd6..5362443f4bbce 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5556,14 +5556,10 @@ static __init int svm_hardware_setup(void)
 		pr_err_ratelimited("NX (Execute Disable) not supported\n");
 		return -EOPNOTSUPP;
 	}
-	kvm_enable_efer_bits(EFER_NX);
 
 	kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
 				     XFEATURE_MASK_BNDCSR);
 
-	if (boot_cpu_has(X86_FEATURE_FXSR_OPT))
-		kvm_enable_efer_bits(EFER_FFXSR);
-
 	if (tsc_scaling) {
 		if (!boot_cpu_has(X86_FEATURE_TSCRATEMSR)) {
 			tsc_scaling = false;
@@ -5577,9 +5573,6 @@ static __init int svm_hardware_setup(void)
 
 	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
 
-	if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
-		kvm_enable_efer_bits(EFER_AUTOIBRS);
-
 	/* Check for pause filtering support */
 	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
 		pause_filter_count = 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9302c16571cdc..2b8a7456039c7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8583,10 +8583,6 @@ __init int vmx_hardware_setup(void)
 
 	vmx_setup_user_return_msrs();
 
-
-	if (boot_cpu_has(X86_FEATURE_NX))
-		kvm_enable_efer_bits(EFER_NX);
-
 	if (boot_cpu_has(X86_FEATURE_MPX)) {
 		rdmsrq(MSR_IA32_BNDCFGS, host_bndcfgs);
 		WARN_ONCE(host_bndcfgs, "BNDCFGS in host will be lost");
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 879cdeb6adde2..1aae2bc380d1b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10025,6 +10025,18 @@ void kvm_setup_xss_caps(void)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_setup_xss_caps);
 
+static void kvm_setup_efer_caps(void)
+{
+	if (boot_cpu_has(X86_FEATURE_NX))
+		kvm_enable_efer_bits(EFER_NX);
+
+	if (boot_cpu_has(X86_FEATURE_FXSR_OPT))
+		kvm_enable_efer_bits(EFER_FFXSR);
+
+	if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
+		kvm_enable_efer_bits(EFER_AUTOIBRS);
+}
+
 static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 {
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
@@ -10161,6 +10173,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (r != 0)
 		goto out_mmu_exit;
 
+	kvm_setup_efer_caps();
+
 	enable_device_posted_irqs &= enable_apicv &&
 				     irq_remapping_cap(IRQ_POSTING_CAP);
 
-- 
2.53.0.473.g4a7958ca14-goog



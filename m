Return-Path: <kvm+bounces-45437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED1AFAA9B29
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5001D17DB55
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CFBB26F450;
	Mon,  5 May 2025 18:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LSpvN4Oa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7C534CF5
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746468185; cv=none; b=FdrGXwiADqOh+GVixnUL2/TEBA3ZbiW/MlAntWqKxuB+CmTuCsSYYijrnl4O68Iyumb21ggPxjVCe3BIIfys3XKZjWNwMOzgOC/vXWVsagUOG9O7UYWGPnMfPkvIQnNKFPgEkEyA/lhjE3XED50VcDbSSM5XgazD86GzFiYbM/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746468185; c=relaxed/simple;
	bh=VqbdyGtdiOP9xZl1obfcHNm1EmOvQxZOMzc0kDtFx70=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kbIqObrY8zeZm73wKI+onlIEKtLs4s3kXB4xbnOqd0bGgJ9S4vwCI9xhNGacxt9TTbNWaylEm9q4OyFSK9NFWH0G3PesRl1jjH8pwUxmtXv/Ddv6xj3QBsDbzEpQdYyYsh4yuwwsLKnxFBmkhioBGL7cMsKH1nS2iWYJRkl0tXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LSpvN4Oa; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff64898e2aso4211271a91.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746468183; x=1747072983; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fdHkz+qURvnP5/FWddFFQyfUC9zHcFbvyU+99/kk/A=;
        b=LSpvN4OayvIjk3ppDnc82CgqS0m8pZKAwbm4MDzV8WsRpzneGs3whxr3/S+JyZVbP6
         v9m6yC8e9i/ERJoo9RXRk0Mi1k0ku09uGkUolcYzCh2Vj5/sqqkPN52FPNwnYEMKqi15
         2fPj3HRWJS7HM9VY6WHX7fXfU0WjqWvGhaLQnbYOkCrYsHIs7F1yjnGOpbOxfed43ZcT
         WIbSmEBCXJRRojmWOask4Lg0Tz2MbIZ4vYK+cNRdzZOMsbGpwsHPx0vpVKv4gdrjtTA5
         cYyclB9sQvnr6F1XjMs/EobzzldxbPm2nRwDMenNFji7CvtVsiqcBDulTdPJiCyyvU6O
         VtQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746468183; x=1747072983;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6fdHkz+qURvnP5/FWddFFQyfUC9zHcFbvyU+99/kk/A=;
        b=bXlUvGqCVOdFc7yBRSIXEpSORdG45/R+09cr7iBFiq89I922GA+DubEzsy502O6hL9
         wdRI6FHOV0cu83j22MReJ1R3nyt0Nhdy/OpEdAYZYgq/eKXU7ux6VDaCwU8DvNVU4/m1
         1GtOFp5nk1hnW5r4EgMtO0fFLuE9vXhppW5IdUlgcspzzktdSNbPHfsyZxwd4jh5OD3h
         jrShtF9DiK/4q5AGmmYKzeejWj7qoj2MxFKWV0LoZaVuPGnRe+r5W/MYHp1W2TUjzlhn
         4Ujig4AzLb4lHdsa42MLXhfR7cgI7RCagmig88VCDmgNQqK6maO1t+JL701mx2nQkIjI
         MjfA==
X-Gm-Message-State: AOJu0YxsJwKhuD2rRN3XzhEOY20hvfXSVwHOE5ZtRtE0t6gmNEGsssZD
	Z5sz6y9Vg/VlfZYhuBoQ6IN2O1bv3JSTYOHJ8RKbt9r+tzLFpR0qb/S6I8/EUiaJH6Dup+gwOGV
	FHQ==
X-Google-Smtp-Source: AGHT+IGOOZOIsWiGySRvbESMZh0DpMg7q8RyhQryXMHIN6gDz6nOKsDfCvoZ2snN2VpuUQbAnCwg8f1EIco=
X-Received: from pjbkl6.prod.google.com ([2002:a17:90b:4986:b0:2ef:8055:93d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5643:b0:2fa:6793:e860
 with SMTP id 98e67ed59e1d1-30a7ba2404emr726549a91.0.1746468182837; Mon, 05
 May 2025 11:03:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  5 May 2025 11:03:00 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250505180300.973137-1-seanjc@google.com>
Subject: [PATCH v2] KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1 VM
 count transitions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Larabel <Michael@michaellarabel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"

Set the magic BP_SPEC_REDUCE bit to mitigate SRSO when running VMs if and
only if KVM has at least one active VM.  Leaving the bit set at all times
unfortunately degrades performance by a wee bit more than expected.

Use a dedicated spinlock and counter instead of hooking virtualization
enablement, as changing the behavior of kvm.enable_virt_at_load based on
SRSO_BP_SPEC_REDUCE is painful, and has its own drawbacks, e.g. could
result in performance issues for flows that are sensitive to VM creation
latency.

Defer setting BP_SPEC_REDUCE until VMRUN is imminent to avoid impacting
performance on CPUs that aren't running VMs, e.g. if a setup is using
housekeeping CPUs.  Setting BP_SPEC_REDUCE in task context, i.e. without
blasting IPIs to all CPUs, also helps avoid serializing 1<=>N transitions
without incurring a gross amount of complexity (see the Link for details
on how ugly coordinating via IPIs gets).

Link: https://lore.kernel.org/all/aBOnzNCngyS_pQIW@google.com
Fixes: 8442df2b49ed ("x86/bugs: KVM: Add support for SRSO_MSR_FIX")
Reported-by: Michael Larabel <Michael@michaellarabel.com>
Closes: https://www.phoronix.com/review/linux-615-amd-regression
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v2: Defer setting BP_SPEC_REDUCE until VMRUN is imminent, which in turn
    allows for eliding the lock on 0<=>1 transitions as there is no race
    with CPUs doing VMRUN before receiving the IPI to set the bit, and
    having multiple tasks take the lock during svm_srso_vm_init() is a-ok.

v1: https://lore.kernel.org/all/20250502223456.887618-1-seanjc@google.com

 arch/x86/kvm/svm/svm.c | 71 ++++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.h |  2 ++
 2 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cc1c721ba067..15f7a0703c16 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -607,9 +607,6 @@ static void svm_disable_virtualization_cpu(void)
 	kvm_cpu_svm_disable();
 
 	amd_pmu_disable_virt();
-
-	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
-		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
 }
 
 static int svm_enable_virtualization_cpu(void)
@@ -687,9 +684,6 @@ static int svm_enable_virtualization_cpu(void)
 		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
 	}
 
-	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
-		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
-
 	return 0;
 }
 
@@ -1518,6 +1512,63 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 	__free_pages(virt_to_page(svm->msrpm), get_order(MSRPM_SIZE));
 }
 
+#ifdef CONFIG_CPU_MITIGATIONS
+static DEFINE_SPINLOCK(srso_lock);
+static atomic_t srso_nr_vms;
+
+static void svm_srso_clear_bp_spec_reduce(void *ign)
+{
+	struct svm_cpu_data *sd = this_cpu_ptr(&svm_data);
+
+	if (!sd->bp_spec_reduce_set)
+		return;
+
+	msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
+	sd->bp_spec_reduce_set = false;
+}
+
+static void svm_srso_vm_destroy(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+		return;
+
+	if (atomic_dec_return(&srso_nr_vms))
+		return;
+
+	guard(spinlock)(&srso_lock);
+
+	/*
+	 * Verify a new VM didn't come along, acquire the lock, and increment
+	 * the count before this task acquired the lock.
+	 */
+	if (atomic_read(&srso_nr_vms))
+		return;
+
+	on_each_cpu(svm_srso_clear_bp_spec_reduce, NULL, 1);
+}
+
+static void svm_srso_vm_init(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+		return;
+
+	/*
+	 * Acquire the lock on 0 => 1 transitions to ensure a potential 1 => 0
+	 * transition, i.e. destroying the last VM, is fully complete, e.g. so
+	 * that a delayed IPI doesn't clear BP_SPEC_REDUCE after a vCPU runs.
+	 */
+	if (atomic_inc_not_zero(&srso_nr_vms))
+		return;
+
+	guard(spinlock)(&srso_lock);
+
+	atomic_inc(&srso_nr_vms);
+}
+#else
+static void svm_srso_vm_init(void) { }
+static void svm_srso_vm_destroy(void) { }
+#endif
+
 static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1550,6 +1601,11 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	    (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm)))
 		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
 
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE) &&
+	    !sd->bp_spec_reduce_set) {
+		sd->bp_spec_reduce_set = true;
+		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
+	}
 	svm->guest_state_loaded = true;
 }
 
@@ -5036,6 +5092,8 @@ static void svm_vm_destroy(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
 	sev_vm_destroy(kvm);
+
+	svm_srso_vm_destroy();
 }
 
 static int svm_vm_init(struct kvm *kvm)
@@ -5061,6 +5119,7 @@ static int svm_vm_init(struct kvm *kvm)
 			return ret;
 	}
 
+	svm_srso_vm_init();
 	return 0;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d4490eaed55d..f16b068c4228 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -335,6 +335,8 @@ struct svm_cpu_data {
 	u32 next_asid;
 	u32 min_asid;
 
+	bool bp_spec_reduce_set;
+
 	struct vmcb *save_area;
 	unsigned long save_area_pa;
 

base-commit: 45eb29140e68ffe8e93a5471006858a018480a45
-- 
2.49.0.967.g6a0df3ecc3-goog



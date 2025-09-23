Return-Path: <kvm+bounces-58561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EEDEB969E4
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:38:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D3BD4485EC
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 15:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 119F926B2C8;
	Tue, 23 Sep 2025 15:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yNOAllZQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853C6263F2D
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 15:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758641870; cv=none; b=Kb4dF7TQuGsHcPNZrHbesSvaHO9JCI1jhc1MxHJaJRwo37VmxejMxJZhpSS39vpWwyBiiCReSGoUiG3BB+zO0si5QLqO9/6luOoc6+eBvLd/bbB/sPxuUEYnUIpXMd9nQ5sdbRSt3cF8lXuTTGWpz/tfKUh+eISGQblMCp5Kp/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758641870; c=relaxed/simple;
	bh=B760xSwQfEWkIUiBDKXN2fQZyP0tDYOfoa377R5ElHk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l+Rc65adHeo3zjHS5uR7jgtBUdNaawQPF6uy3jQ5LQehGMlEiuH0Qa5J36yO1LtfEYMm/sfUCLnlhGjBfwT6NFm/LcbyAFFSPwLE/Q+5Q8j6ThoHnVSTathWHPfPsWGQRf1TrOVX/kEtCb4sbRIj2T7NcOvX1FGUhM8GK/wv1BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yNOAllZQ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4f8e079bc1so4018317a12.3
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 08:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758641868; x=1759246668; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eMZ5s15QgA1LUZtAao1CO2w7ujCiWNFlBED3uUB7s0I=;
        b=yNOAllZQF/f317VL46k2vqaZUIm+t1KqtKgaG2Ox57Ajk9vmWQ3Z+BnzVMnjvV9BmJ
         u1H/gBw7jiPVIJ7sn/lgGWrRp4LbBoGNP4drmHxeNKfzh45yOjMbik3vFP/10xOSAgQK
         /oNiUh2YUNrEkfPQUb36uAGSTGlvxXKbva6kpmoy56Is0Rl34KVQ4opG6XZMU8ARwXmp
         tHE8keum1ZAqt9ge/YxCLr/iKqy+j+8zHybcIuNLrP9/oB2ZQDE5bbBtfnSyBnypkTr8
         FGcyctA0oHVqZuJMztUt3EK7Is/xh0D2/AANWW9qPhsuVWP66mGfZ+DknGNwciOXntDK
         gYEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758641868; x=1759246668;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eMZ5s15QgA1LUZtAao1CO2w7ujCiWNFlBED3uUB7s0I=;
        b=iwt1o1UHKiKA07YAjePp7SVfrBZ8RI6anA78Cx+5XECu3m7hv4yLrtTmqfJeVL1Tci
         ZOS9JWRbNEvzSGf1FSxB7h6x/32llu7YvkvrJByqfldsLet7D3YpvrZptnMYSSKJRhc1
         YjE1/EdNCu7quzi1b3t9x6PQVNYCu9j3TrVtcesfBgCoPL8AVAGFlYA8wJ0rDK/SQSh1
         4x96zUJLo+Yq4HOlej05b6DQ27Xs0MwIWhWyRDxbXniqTkpb1oX0oO2Ob9zbAmBVsOI9
         5SR5NDwZch4ll0qiJ8kpeGLhIemLTajHCZifAEbIa7kqlaCc2mJNPEiPK1a2WdG23clW
         RFjQ==
X-Gm-Message-State: AOJu0YyAUniN3bgjokSi99JwjFPaw/qy9fY0oVFq8JMpHKRJbz7Ngpu6
	8L/+Z2YQD7IrED4ck+u9YHHQeerEVUSQc5OAWGzi6Go9DdNVyzWa3VkyZMqqJCmcIfEpjQvRLgN
	B7IjJoQ==
X-Google-Smtp-Source: AGHT+IFuuXk4murZS4S1kiyk93K9qAop1IuBv5IVXqIopRy+jRfRnj6nw15yHZzr1S0Afco6H/UZC3PtVj0=
X-Received: from plog5.prod.google.com ([2002:a17:902:8685:b0:269:7570:9ef0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea05:b0:24c:cca1:7cfc
 with SMTP id d9443c01a7336-27ccaae76b4mr36812845ad.59.1758641867982; Tue, 23
 Sep 2025 08:37:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 23 Sep 2025 08:37:38 -0700
In-Reply-To: <20250923153738.1875174-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250923153738.1875174-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.534.gc79095c0ca-goog
Message-ID: <20250923153738.1875174-3-seanjc@google.com>
Subject: [PATCH v3 2/2] KVM: SVM: Re-load current, not host, TSC_AUX on
 #VMEXIT from SEV-ES guest
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

Prior to running an SEV-ES guest, set TSC_AUX in the host save area to the
current value in hardware, as tracked by the user return infrastructure,
instead of always loading the host's desired value for the CPU.  If the
pCPU is also running a non-SEV-ES vCPU, loading the host's value on #VMEXIT
could clobber the other vCPU's value, e.g. if the SEV-ES vCPU preempted
the non-SEV-ES vCPU, in which case KVM expects the other vCPU's TSC_AUX
value to be resident in hardware.

Note, unlike TDX, which blindly _zeroes_ TSC_AUX on TD-Exit, SEV-ES CPUs
can load an arbitrary value.  Stuff the current value in the host save
area instead of refreshing the user return cache so that KVM doesn't need
to track whether or not the vCPU actually enterred the guest and thus
loaded TSC_AUX from the host save area.

Opportunistically tag tsc_aux_uret_slot as read-only after init to guard
against unexpected modifications, and to make it obvious that using the
variable in sev_es_prepare_switch_to_guest() is safe.

Fixes: 916e3e5f26ab ("KVM: SVM: Do not use user return MSR support for virtualized TSC_AUX")
Cc: stable@vger.kernel.org
Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
[sean: handle the SEV-ES case in sev_es_prepare_switch_to_guest()]
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 10 ++++++++++
 arch/x86/kvm/svm/svm.c | 25 ++++++-------------------
 arch/x86/kvm/svm/svm.h |  2 ++
 3 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cce48fff2e6c..887d0d6ad856 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4712,6 +4712,16 @@ void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_are
 		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
 		hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
 	}
+
+	/*
+	 * TSC_AUX is always virtualized for SEV-ES guests when the feature is
+	 * available, i.e. TSC_AUX is loaded on #VMEXIT from the host save area.
+	 * Set the save area to the current hardware value, i.e. the current
+	 * user return value, so that the correct value is restored on #VMEXIT.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_V_TSC_AUX) &&
+	    !WARN_ON_ONCE(tsc_aux_uret_slot < 0))
+		hostsa->tsc_aux = kvm_get_user_return_msr(tsc_aux_uret_slot);
 }
 
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 67f4eed01526..0df2e1a5fb77 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -195,7 +195,7 @@ static DEFINE_MUTEX(vmcb_dump_mutex);
  * RDTSCP and RDPID are not used in the kernel, specifically to allow KVM to
  * defer the restoration of TSC_AUX until the CPU returns to userspace.
  */
-static int tsc_aux_uret_slot __read_mostly = -1;
+int tsc_aux_uret_slot __ro_after_init = -1;
 
 static int get_npt_level(void)
 {
@@ -577,18 +577,6 @@ static int svm_enable_virtualization_cpu(void)
 
 	amd_pmu_enable_virt();
 
-	/*
-	 * If TSC_AUX virtualization is supported, TSC_AUX becomes a swap type
-	 * "B" field (see sev_es_prepare_switch_to_guest()) for SEV-ES guests.
-	 * Since Linux does not change the value of TSC_AUX once set, prime the
-	 * TSC_AUX field now to avoid a RDMSR on every vCPU run.
-	 */
-	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
-		u32 __maybe_unused msr_hi;
-
-		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
-	}
-
 	return 0;
 }
 
@@ -1406,10 +1394,10 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
 
 	/*
-	 * TSC_AUX is always virtualized for SEV-ES guests when the feature is
-	 * available. The user return MSR support is not required in this case
-	 * because TSC_AUX is restored on #VMEXIT from the host save area
-	 * (which has been initialized in svm_enable_virtualization_cpu()).
+	 * TSC_AUX is always virtualized (context switched by hardware) for
+	 * SEV-ES guests when the feature is available.  For non-SEV-ES guests,
+	 * context switch TSC_AUX via the user_return MSR infrastructure (not
+	 * all CPUs support TSC_AUX virtualization).
 	 */
 	if (likely(tsc_aux_uret_slot >= 0) &&
 	    (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm)))
@@ -3004,8 +2992,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * TSC_AUX is always virtualized for SEV-ES guests when the
 		 * feature is available. The user return MSR support is not
 		 * required in this case because TSC_AUX is restored on #VMEXIT
-		 * from the host save area (which has been initialized in
-		 * svm_enable_virtualization_cpu()).
+		 * from the host save area.
 		 */
 		if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) && sev_es_guest(vcpu->kvm))
 			break;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5d39c0b17988..bcbd651d04f2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -52,6 +52,8 @@ extern bool x2avic_enabled;
 extern bool vnmi;
 extern int lbrv;
 
+extern int tsc_aux_uret_slot __ro_after_init;
+
 /*
  * Clean bits in VMCB.
  * VMCB_ALL_CLEAN_MASK might also need to
-- 
2.51.0.534.gc79095c0ca-goog



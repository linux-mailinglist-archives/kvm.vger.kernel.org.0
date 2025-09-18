Return-Path: <kvm+bounces-57964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75978B82C59
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 05:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 382B2178001
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 03:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A109223C506;
	Thu, 18 Sep 2025 03:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="hf8oeq4J"
X-Original-To: kvm@vger.kernel.org
Received: from out28-3.mail.aliyun.com (out28-3.mail.aliyun.com [115.124.28.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395A934BA27;
	Thu, 18 Sep 2025 03:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758166748; cv=none; b=UbnFrG3KJr1ZStBU4aTLC352CBVOuyAC0GRyh+wICh68yNjTOI/4us2N/tX7fqXWGIiiYGoUYznrj/adE5760jTK1e0JbjrW5RRhbntMgIF4and4TEWYTWHI2LdzxpAwBLXwFSB7Jwda9T0ufuo0mJgSu+QE8zydyeApjtxA9KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758166748; c=relaxed/simple;
	bh=TS7MO6cKvbGSPWS3KqgjZ3IyhkUrhvVPT52fnJkXN3k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TKMUyCIodmbQaq1NZjxssGneK98DGK6AhxNO6ErWiVjUKGbOmIgu7eqt4M/Ceo4U3kQ+8Jo6ZwkyAnwTa8A9zTEX/o31/UW3cWrOx4kf3TFSpsjyiLHISTZscMDfSX94Ck1HS0xDz8Sf5wn93rp/SGD72gZLkggUNaOkAFhJZy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=hf8oeq4J; arc=none smtp.client-ip=115.124.28.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1758166741; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=pXRli8O2NYiHgLfJZAGJQIiMet7Pwh7g8WBZBmNQzkI=;
	b=hf8oeq4JmMy6gE/J3gd1NRQAheY2IUIxYZwDAAMfkBQqcQGqRG2yq3PFVGvUeVswpb9vRV9YHVIRb5s8xhKiKHG1AqNU68GTa5ypgFoOw2ljqbcI2ErPIonUbnVSTDWpmK/MDYyTcp5hNoqPRvyfUY6aZGCUne3S5+yxFOacPWg=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.ehjXwvy_1758166740 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 18 Sep 2025 11:39:00 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: kvm@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: SVM: Use cached value as restore value of TSC_AUX for SEV-ES guest
Date: Thu, 18 Sep 2025 11:38:51 +0800
Message-Id: <9da5eb48ccf403e1173484195d3d7d96978125b7.1758166596.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <05a018a6997407080b3b7921ba692aa69a720f07.1758166596.git.houwenlong.hwl@antgroup.com>
References: <05a018a6997407080b3b7921ba692aa69a720f07.1758166596.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit 916e3e5f26ab ("KVM: SVM: Do not use user return MSR support
for virtualized TSC_AUX") assumes that TSC_AUX is not changed by Linux
post-boot, so it always restores the initial host value on #VMEXIT.
However, this is not true in KVM, as it can be modified by user return
MSR support for normal guests. If an SEV-ES guest always restores the
initial host value on #VMEXIT, this may result in the cached value in
user return MSR being different from the hardware value if the previous
vCPU was a non-SEV-ES guest that had called kvm_set_user_return_msr().
Consequently, this may pose a problem when switching back to that vCPU,
as kvm_set_user_return_msr() would not update the hardware value because
the cached value matches the target value. Unlike the TDX case, the
SEV-ES guest has the ability to set the restore value in the host save
area, and the cached value in the user return MSR is always the current
hardware value. Therefore, the cached value could be used directly
without RDMSR in svm_prepare_switch_to_guest(), making this change
minimal.

Fixes: 916e3e5f26ab ("KVM: SVM: Do not use user return MSR support for virtualized TSC_AUX")
Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/svm/svm.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1650de78648a..1be9c65ee23b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
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
 
@@ -1408,12 +1396,19 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	/*
 	 * TSC_AUX is always virtualized for SEV-ES guests when the feature is
 	 * available. The user return MSR support is not required in this case
-	 * because TSC_AUX is restored on #VMEXIT from the host save area
-	 * (which has been initialized in svm_enable_virtualization_cpu()).
+	 * because TSC_AUX is restored on #VMEXIT from the host save area.
+	 * However, user return MSR could change the value of TSC_AUX in the
+	 * kernel. Therefore, to maintain the logic of user return MSR, set the
+	 * restore value to the cached value of user return MSR, which should
+	 * always reflect the current hardware value.
 	 */
-	if (likely(tsc_aux_uret_slot >= 0) &&
-	    (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm)))
-		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
+	if (likely(tsc_aux_uret_slot >= 0)) {
+		if (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm))
+			kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
+		else
+			sev_es_host_save_area(sd)->tsc_aux =
+				(u32)kvm_get_user_return_msr_cache(tsc_aux_uret_slot);
+	}
 
 	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE) &&
 	    !sd->bp_spec_reduce_set) {
@@ -3004,8 +2999,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * TSC_AUX is always virtualized for SEV-ES guests when the
 		 * feature is available. The user return MSR support is not
 		 * required in this case because TSC_AUX is restored on #VMEXIT
-		 * from the host save area (which has been initialized in
-		 * svm_enable_virtualization_cpu()).
+		 * from the host save area (which has been set in
+		 * svm_prepare_switch_to_guest()).
 		 */
 		if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) && sev_es_guest(vcpu->kvm))
 			break;
-- 
2.31.1



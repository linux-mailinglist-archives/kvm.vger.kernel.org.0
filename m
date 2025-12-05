Return-Path: <kvm+bounces-65329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 44E23CA6E31
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 10:24:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 87B0133F56B1
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2D78352F80;
	Fri,  5 Dec 2025 07:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pBM/zm+l";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pBM/zm+l"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A221352FAC
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 07:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764920859; cv=none; b=X2d0uYCOrygOoSvlq3Ha0dBi3vpHh8yfWYwvq7nJ4y6isoctNrfBj+gh9rY+kaBTiUWSaiTMlMEm4H1RRpHdg3D1O4bMN4B7YfALNRqMcKhqWSbuZY+e3/ljf+acGRamhPz3KpjOvHQTgKQ2xyHolR1JJ/A3KKNITks7+1mZQa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764920859; c=relaxed/simple;
	bh=kvd2kvKG0nARHeO7OY4w9aidfVsWbADFWJO7Aov4qSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDTGlWzi5xs2ymYa9QvKUFs1tuBZXBBCCTAqfIbBAk+8dlGmF3uZMbpcPqjfNCtaZdhxVQpXZBZ/Dmj0+AadrP8nDehV0Dee4ErlEVS+8fL+67MyoWuWzL8kodGaRqDXwItZLC4yzN1MBtsrqFGYLM6zTux8ED0rCx2U1EqhVOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pBM/zm+l; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pBM/zm+l; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 946EE5BD20;
	Fri,  5 Dec 2025 07:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4KP+hyS/pQcKMni0WVY3TZPBX5MznkMTeEIBurPyVJ8=;
	b=pBM/zm+l8mNQ7yFfH58JHGZ6i+O0wxNUZj9k23ZgOzqFJn2OzJRNIsirnW02cEBBAcjUK/
	PQ8YbagQcNV8Yjd0BMpLUmMMoWxm2ys1zscKLTd297bCFjwht7REFGytYMW7ZC9Ywp44R1
	0tes+zbgA1G+QM3kZDUe2CZ+0EC4E/U=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4KP+hyS/pQcKMni0WVY3TZPBX5MznkMTeEIBurPyVJ8=;
	b=pBM/zm+l8mNQ7yFfH58JHGZ6i+O0wxNUZj9k23ZgOzqFJn2OzJRNIsirnW02cEBBAcjUK/
	PQ8YbagQcNV8Yjd0BMpLUmMMoWxm2ys1zscKLTd297bCFjwht7REFGytYMW7ZC9Ywp44R1
	0tes+zbgA1G+QM3kZDUe2CZ+0EC4E/U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2D82F3EA63;
	Fri,  5 Dec 2025 07:46:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id D1WXCd6NMmmjEgAAD6G6ig
	(envelope-from <jgross@suse.com>); Fri, 05 Dec 2025 07:46:38 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>
Subject: [PATCH 10/10] KVM/x86: Use defines for common related MSR emulation
Date: Fri,  5 Dec 2025 08:45:37 +0100
Message-ID: <20251205074537.17072-11-jgross@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205074537.17072-1-jgross@suse.com>
References: <20251205074537.17072-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.988];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	R_RATELIMIT(0.00)[to_ip_from(RLfdszjqhz8kzzb9uwpzdm8png)];
	RCVD_TLS_ALL(0.00)[]

Instead of "0" and "1" use the related KVM_MSR_RET_* defines in the
common emulation code of MSR registers.

No change of functionality intended.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/kvm/mtrr.c |  12 +--
 arch/x86/kvm/pmu.c  |  12 +--
 arch/x86/kvm/x86.c  | 176 ++++++++++++++++++++++----------------------
 arch/x86/kvm/xen.c  |  14 ++--
 4 files changed, 107 insertions(+), 107 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 6f74e2b27c1e..b699cfddb0f3 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -99,13 +99,13 @@ int kvm_mtrr_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 
 	mtrr = find_mtrr(vcpu, msr);
 	if (!mtrr)
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	if (!kvm_mtrr_valid(vcpu, msr, data))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	*mtrr = data;
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
@@ -121,13 +121,13 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 		 * VCNT = KVM_NR_VAR_MTRR
 		 */
 		*pdata = 0x500 | KVM_NR_VAR_MTRR;
-		return 0;
+		return KVM_MSR_RET_OK;
 	}
 
 	mtrr = find_mtrr(vcpu, msr);
 	if (!mtrr)
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	*pdata = *mtrr;
-	return 0;
+	return KVM_MSR_RET_OK;
 }
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 487ad19a236e..17c0b0bd3ecc 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -754,7 +754,7 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		return kvm_pmu_call(get_msr)(vcpu, msr_info);
 	}
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
@@ -771,7 +771,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	switch (msr) {
 	case MSR_CORE_PERF_GLOBAL_STATUS:
 		if (!msr_info->host_initiated)
-			return 1; /* RO MSR */
+			return KVM_MSR_RET_ERR; /* RO MSR */
 		fallthrough;
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
 		/* Per PPR, Read-only MSR. Writes are ignored. */
@@ -779,7 +779,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			break;
 
 		if (data & pmu->global_status_rsvd)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		pmu->global_status = data;
 		break;
@@ -788,7 +788,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		fallthrough;
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 		if (!kvm_valid_perf_global_ctrl(pmu, data))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (pmu->global_ctrl != data) {
 			diff = pmu->global_ctrl ^ data;
@@ -802,7 +802,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * GLOBAL_STATUS, and so the set of reserved bits is the same.
 		 */
 		if (data & pmu->global_status_rsvd)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		fallthrough;
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
 		if (!msr_info->host_initiated)
@@ -817,7 +817,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		return kvm_pmu_call(set_msr)(vcpu, msr_info);
 	}
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e87963a47aa5..3105e773b02b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -541,7 +541,7 @@ static __always_inline int kvm_do_msr_access(struct kvm_vcpu *vcpu, u32 msr,
 	 * and all reads (in which case @data is zeroed on failure; see above).
 	 */
 	if (host_initiated && !*data && kvm_is_advertised_msr(msr))
-		return 0;
+		return KVM_MSR_RET_OK;
 
 	if (!ignore_msrs) {
 		kvm_debug_ratelimited("unhandled %s: 0x%x data 0x%llx\n",
@@ -552,7 +552,7 @@ static __always_inline int kvm_do_msr_access(struct kvm_vcpu *vcpu, u32 msr,
 	if (report_ignored_msrs)
 		kvm_pr_unimpl("ignored %s: 0x%x data 0x%llx\n", op, msr, *data);
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static struct kmem_cache *kvm_alloc_emulator_cache(void)
@@ -670,14 +670,14 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 
 	value = (value & mask) | (msrs->values[slot].host & ~mask);
 	if (value == msrs->values[slot].curr)
-		return 0;
+		return KVM_MSR_RET_OK;
 	err = wrmsrq_safe(kvm_uret_msrs_list[slot], value);
 	if (err)
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	msrs->values[slot].curr = value;
 	kvm_user_return_register_notifier(msrs);
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_user_return_msr);
 
@@ -1712,7 +1712,7 @@ static int kvm_get_feature_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	default:
 		return kvm_x86_call(get_feature_msr)(index, data);
 	}
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int do_get_feature_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
@@ -1855,7 +1855,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 	case MSR_CSTAR:
 	case MSR_LSTAR:
 		if (is_noncanonical_msr_address(data, vcpu))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		break;
 	case MSR_IA32_SYSENTER_EIP:
 	case MSR_IA32_SYSENTER_ESP:
@@ -1875,12 +1875,12 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		break;
 	case MSR_TSC_AUX:
 		if (!kvm_is_supported_user_return_msr(MSR_TSC_AUX))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (!host_initiated &&
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) &&
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		/*
 		 * Per Intel's SDM, bits 63:32 are reserved, but AMD's APM has
@@ -1892,7 +1892,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		 * provide consistent behavior for the guest.
 		 */
 		if (guest_cpuid_is_intel_compatible(vcpu) && (data >> 32) != 0)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		data = (u32)data;
 		break;
@@ -1902,11 +1902,11 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_IBT))
 			return KVM_MSR_RET_UNSUPPORTED;
 		if (!kvm_is_valid_u_s_cet(vcpu, data))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		break;
 	case MSR_KVM_INTERNAL_GUEST_SSP:
 		if (!host_initiated)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		fallthrough;
 		/*
 		 * Note that the MSR emulation here is flawed when a vCPU
@@ -1929,10 +1929,10 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		if (index == MSR_IA32_INT_SSP_TAB && !guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
 			return KVM_MSR_RET_UNSUPPORTED;
 		if (is_noncanonical_msr_address(data, vcpu))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		/* All SSP MSRs except MSR_IA32_INT_SSP_TAB must be 4-byte aligned */
 		if (index != MSR_IA32_INT_SSP_TAB && !IS_ALIGNED(data, 4))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		break;
 	}
 
@@ -1971,12 +1971,12 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	switch (index) {
 	case MSR_TSC_AUX:
 		if (!kvm_is_supported_user_return_msr(MSR_TSC_AUX))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (!host_initiated &&
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) &&
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		break;
 	case MSR_IA32_U_CET:
 	case MSR_IA32_S_CET:
@@ -1986,7 +1986,7 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 		break;
 	case MSR_KVM_INTERNAL_GUEST_SSP:
 		if (!host_initiated)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		fallthrough;
 	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
@@ -1998,7 +1998,7 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	msr.host_initiated = host_initiated;
 
 	ret = kvm_x86_call(get_msr)(vcpu, &msr);
-	if (!ret)
+	if (ret == KVM_MSR_RET_OK)
 		*data = msr.data;
 	return ret;
 }
@@ -2133,7 +2133,7 @@ static int __kvm_emulate_rdmsr(struct kvm_vcpu *vcpu, u32 msr, int reg,
 	/* Call MSR emulation. */
 	r = kvm_emulate_msr_read(vcpu, msr, &data);
 
-	if (!r) {
+	if (r == KVM_MSR_RET_OK) {
 		trace_kvm_msr_read(msr, data);
 
 		if (reg < 0) {
@@ -2174,7 +2174,7 @@ static int __kvm_emulate_wrmsr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 
 	/* Call MSR emulation. */
 	r = kvm_emulate_msr_write(vcpu, msr, data);
-	if (!r) {
+	if (r == KVM_MSR_RET_OK) {
 		trace_kvm_msr_write(msr, data);
 	} else {
 		/* MSR write failed? See if we should ask user space */
@@ -3975,7 +3975,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return KVM_MSR_RET_UNSUPPORTED;
 
 		if (data & ~kvm_caps.supported_perf_cap)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		/*
 		 * Note, this is not just a performance optimization!  KVM
@@ -3993,7 +3993,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		if (!msr_info->host_initiated) {
 			if ((!guest_has_pred_cmd_msr(vcpu)))
-				return 1;
+				return KVM_MSR_RET_ERR;
 
 			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
 			    !guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_IBPB))
@@ -4010,7 +4010,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			reserved_bits |= PRED_CMD_SBPB;
 
 		if (data & reserved_bits)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (!data)
 			break;
@@ -4021,10 +4021,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_FLUSH_CMD:
 		if (!msr_info->host_initiated &&
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (!boot_cpu_has(X86_FEATURE_FLUSH_L1D) || (data & ~L1D_FLUSH))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		if (!data)
 			break;
 
@@ -4044,19 +4044,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 */
 		if (data & ~(BIT_ULL(18) | BIT_ULL(24))) {
 			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
-			return 1;
+			return KVM_MSR_RET_ERR;
 		}
 		vcpu->arch.msr_hwcr = data;
 		break;
 	case MSR_FAM10H_MMIO_CONF_BASE:
 		if (data != 0) {
 			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
-			return 1;
+			return KVM_MSR_RET_ERR;
 		}
 		break;
 	case MSR_IA32_CR_PAT:
 		if (!kvm_pat_valid(data))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		vcpu->arch.pat = data;
 		break;
@@ -4089,7 +4089,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!msr_info->host_initiated) {
 			/* RO bits */
 			if ((old_val ^ data) & MSR_IA32_MISC_ENABLE_PMU_RO_MASK)
-				return 1;
+				return KVM_MSR_RET_ERR;
 
 			/* R bits, i.e. writes are ignored, but don't fault. */
 			data = data & ~MSR_IA32_MISC_ENABLE_EMON;
@@ -4099,7 +4099,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
 		    ((old_val ^ data)  & MSR_IA32_MISC_ENABLE_MWAIT)) {
 			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_XMM3))
-				return 1;
+				return KVM_MSR_RET_ERR;
 			vcpu->arch.ia32_misc_enable_msr = data;
 			vcpu->arch.cpuid_dynamic_bits_dirty = true;
 		} else {
@@ -4109,7 +4109,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	}
 	case MSR_IA32_SMBASE:
 		if (!IS_ENABLED(CONFIG_KVM_SMM) || !msr_info->host_initiated)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		vcpu->arch.smbase = data;
 		break;
 	case MSR_IA32_POWER_CTL:
@@ -4129,7 +4129,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return KVM_MSR_RET_UNSUPPORTED;
 
 		if (data & ~vcpu->arch.guest_supported_xss)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		if (vcpu->arch.ia32_xss == data)
 			break;
 		vcpu->arch.ia32_xss = data;
@@ -4137,52 +4137,52 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_SMI_COUNT:
 		if (!msr_info->host_initiated)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		vcpu->arch.smi_count = data;
 		break;
 	case MSR_KVM_WALL_CLOCK_NEW:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		vcpu->kvm->arch.wall_clock = data;
 		kvm_write_wall_clock(vcpu->kvm, data, 0);
 		break;
 	case MSR_KVM_WALL_CLOCK:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		vcpu->kvm->arch.wall_clock = data;
 		kvm_write_wall_clock(vcpu->kvm, data, 0);
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		kvm_write_system_time(vcpu, data, false, msr_info->host_initiated);
 		break;
 	case MSR_KVM_SYSTEM_TIME:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		kvm_write_system_time(vcpu, data, true,  msr_info->host_initiated);
 		break;
 	case MSR_KVM_ASYNC_PF_EN:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (kvm_pv_enable_async_pf(vcpu, data))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		break;
 	case MSR_KVM_ASYNC_PF_INT:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (kvm_pv_enable_async_pf_int(vcpu, data))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		break;
 	case MSR_KVM_ASYNC_PF_ACK:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		if (data & 0x1) {
 			vcpu->arch.apf.pageready_pending = false;
 			kvm_check_async_pf_completion(vcpu);
@@ -4190,13 +4190,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_KVM_STEAL_TIME:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (unlikely(!sched_info_on()))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (data & KVM_STEAL_RESERVED_MASK)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		vcpu->arch.st.msr_val = data;
 
@@ -4208,19 +4208,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_KVM_PV_EOI_EN:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_EOI))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (kvm_lapic_set_pv_eoi(vcpu, data, sizeof(u8)))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		break;
 
 	case MSR_KVM_POLL_CONTROL:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_POLL_CONTROL))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		/* only enable bit supported */
 		if (data & (-1ULL << 1))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
@@ -4273,44 +4273,44 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_AMD64_OSVW_ID_LENGTH:
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_OSVW))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		vcpu->arch.osvw.length = data;
 		break;
 	case MSR_AMD64_OSVW_STATUS:
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_OSVW))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		vcpu->arch.osvw.status = data;
 		break;
 	case MSR_PLATFORM_INFO:
 		if (!msr_info->host_initiated)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		vcpu->arch.msr_platform_info = data;
 		break;
 	case MSR_MISC_FEATURES_ENABLES:
 		if (data & ~MSR_MISC_FEATURES_ENABLES_CPUID_FAULT ||
 		    (data & MSR_MISC_FEATURES_ENABLES_CPUID_FAULT &&
 		     !supports_cpuid_fault(vcpu)))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		vcpu->arch.msr_misc_features_enables = data;
 		break;
 #ifdef CONFIG_X86_64
 	case MSR_IA32_XFD:
 		if (!msr_info->host_initiated &&
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (data & ~kvm_guest_supported_xfd(vcpu))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		fpu_update_guest_xfd(&vcpu->arch.guest_fpu, data);
 		break;
 	case MSR_IA32_XFD_ERR:
 		if (!msr_info->host_initiated &&
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (data & ~kvm_guest_supported_xfd(vcpu))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		vcpu->arch.guest_fpu.xfd_err = data;
 		break;
@@ -4325,7 +4325,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		return KVM_MSR_RET_UNSUPPORTED;
 	}
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_msr_common);
 
@@ -4346,7 +4346,7 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 		break;
 	case MSR_IA32_MCG_CTL:
 		if (!(mcg_cap & MCG_CTL_P) && !host)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		data = vcpu->arch.mcg_ctl;
 		break;
 	case MSR_IA32_MCG_STATUS:
@@ -4355,10 +4355,10 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
 		last_msr = MSR_IA32_MCx_CTL2(bank_num) - 1;
 		if (msr > last_msr)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (!(mcg_cap & MCG_CMCI_P) && !host)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		offset = array_index_nospec(msr - MSR_IA32_MC0_CTL2,
 					    last_msr + 1 - MSR_IA32_MC0_CTL2);
 		data = vcpu->arch.mci_ctl2_banks[offset];
@@ -4366,17 +4366,17 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
 		last_msr = MSR_IA32_MCx_CTL(bank_num) - 1;
 		if (msr > last_msr)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		offset = array_index_nospec(msr - MSR_IA32_MC0_CTL,
 					    last_msr + 1 - MSR_IA32_MC0_CTL);
 		data = vcpu->arch.mce_banks[offset];
 		break;
 	default:
-		return 1;
+		return KVM_MSR_RET_ERR;
 	}
 	*pdata = data;
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
@@ -4500,7 +4500,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_SMBASE:
 		if (!IS_ENABLED(CONFIG_KVM_SMM) || !msr_info->host_initiated)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		msr_info->data = vcpu->arch.smbase;
 		break;
 	case MSR_SMI_COUNT:
@@ -4517,61 +4517,61 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_KVM_WALL_CLOCK:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		msr_info->data = vcpu->kvm->arch.wall_clock;
 		break;
 	case MSR_KVM_WALL_CLOCK_NEW:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		msr_info->data = vcpu->kvm->arch.wall_clock;
 		break;
 	case MSR_KVM_SYSTEM_TIME:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		msr_info->data = vcpu->arch.time;
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		msr_info->data = vcpu->arch.time;
 		break;
 	case MSR_KVM_ASYNC_PF_EN:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		msr_info->data = vcpu->arch.apf.msr_en_val;
 		break;
 	case MSR_KVM_ASYNC_PF_INT:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		msr_info->data = vcpu->arch.apf.msr_int_val;
 		break;
 	case MSR_KVM_ASYNC_PF_ACK:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		msr_info->data = 0;
 		break;
 	case MSR_KVM_STEAL_TIME:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		msr_info->data = vcpu->arch.st.msr_val;
 		break;
 	case MSR_KVM_PV_EOI_EN:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_EOI))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		msr_info->data = vcpu->arch.pv_eoi.msr_val;
 		break;
 	case MSR_KVM_POLL_CONTROL:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_POLL_CONTROL))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		msr_info->data = vcpu->arch.msr_kvm_poll_control;
 		break;
@@ -4587,7 +4587,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_XSS:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		msr_info->data = vcpu->arch.ia32_xss;
 		break;
 	case MSR_K7_CLK_CTL:
@@ -4632,18 +4632,18 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_AMD64_OSVW_ID_LENGTH:
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_OSVW))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		msr_info->data = vcpu->arch.osvw.length;
 		break;
 	case MSR_AMD64_OSVW_STATUS:
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_OSVW))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		msr_info->data = vcpu->arch.osvw.status;
 		break;
 	case MSR_PLATFORM_INFO:
 		if (!msr_info->host_initiated &&
 		    !vcpu->kvm->arch.guest_can_read_msr_platform_info)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		msr_info->data = vcpu->arch.msr_platform_info;
 		break;
 	case MSR_MISC_FEATURES_ENABLES:
@@ -4656,14 +4656,14 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_XFD:
 		if (!msr_info->host_initiated &&
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		msr_info->data = vcpu->arch.guest_fpu.fpstate->xfd;
 		break;
 	case MSR_IA32_XFD_ERR:
 		if (!msr_info->host_initiated &&
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		msr_info->data = vcpu->arch.guest_fpu.xfd_err;
 		break;
@@ -4678,7 +4678,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		return KVM_MSR_RET_UNSUPPORTED;
 	}
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_get_msr_common);
 
@@ -6103,7 +6103,7 @@ static int kvm_translate_kvm_reg(struct kvm_vcpu *vcpu,
 	default:
 		return -EINVAL;
 	}
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int kvm_get_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *user_val)
@@ -6116,7 +6116,7 @@ static int kvm_get_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *user_val)
 	if (put_user(val, user_val))
 		return -EFAULT;
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int kvm_set_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *user_val)
@@ -6129,7 +6129,7 @@ static int kvm_set_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *user_val)
 	if (do_set_msr(vcpu, msr, &val))
 		return -EINVAL;
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int kvm_get_set_one_reg(struct kvm_vcpu *vcpu, unsigned int ioctl,
@@ -6153,7 +6153,7 @@ static int kvm_get_set_one_reg(struct kvm_vcpu *vcpu, unsigned int ioctl,
 
 	if (reg->type == KVM_X86_REG_TYPE_KVM) {
 		r = kvm_translate_kvm_reg(vcpu, reg);
-		if (r)
+		if (r != KVM_MSR_RET_OK)
 			return r;
 	}
 
@@ -7611,7 +7611,7 @@ static void kvm_probe_feature_msr(u32 msr_index)
 {
 	u64 data;
 
-	if (kvm_get_feature_msr(NULL, msr_index, &data, true))
+	if (kvm_get_feature_msr(NULL, msr_index, &data, true) != KVM_MSR_RET_OK)
 		return;
 
 	msr_based_features[num_msr_based_features++] = msr_index;
@@ -8709,7 +8709,7 @@ static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 	if (r < 0)
 		return X86EMUL_UNHANDLEABLE;
 
-	if (r) {
+	if (r != KVM_MSR_RET_OK) {
 		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
 				       complete_emulated_rdmsr, r))
 			return X86EMUL_IO_NEEDED;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d6b2a665b499..df456bbf792c 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1279,7 +1279,7 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 	u32 page_num = data & ~PAGE_MASK;
 	u64 page_addr = data & PAGE_MASK;
 	bool lm = is_long_mode(vcpu);
-	int r = 0;
+	int r = KVM_MSR_RET_OK;
 
 	mutex_lock(&kvm->arch.xen.xen_lock);
 	if (kvm->arch.xen.long_mode != lm) {
@@ -1291,11 +1291,11 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 		 */
 		if (kvm->arch.xen.shinfo_cache.active &&
 		    kvm_xen_shared_info_init(kvm))
-			r = 1;
+			r = KVM_MSR_RET_ERR;
 	}
 	mutex_unlock(&kvm->arch.xen.xen_lock);
 
-	if (r)
+	if (r != KVM_MSR_RET_OK)
 		return r;
 
 	/*
@@ -1328,7 +1328,7 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 			if (kvm_vcpu_write_guest(vcpu,
 						 page_addr + (i * sizeof(instructions)),
 						 instructions, sizeof(instructions)))
-				return 1;
+				return KVM_MSR_RET_ERR;
 		}
 	} else {
 		/*
@@ -1343,7 +1343,7 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 		int ret;
 
 		if (page_num >= blob_size)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		blob_addr += page_num * PAGE_SIZE;
 
@@ -1354,9 +1354,9 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 		ret = kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE);
 		kfree(page);
 		if (ret)
-			return 1;
+			return KVM_MSR_RET_ERR;
 	}
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
-- 
2.51.0



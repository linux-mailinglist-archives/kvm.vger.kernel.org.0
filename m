Return-Path: <kvm+bounces-65328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7727ACA6E16
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 10:22:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CAB7E37CB7B4
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB042350285;
	Fri,  5 Dec 2025 07:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fAEGgEEe";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sCrrYc1Y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C452303C9A
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 07:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764920847; cv=none; b=XPfut9P98EOTyDOjO+OShthAMVi6GmqSSmRefGs0bRswyzk6vmDae7FUQ4PgIdAwiP7FZN65/eczTfLkHpBLwFQt/bnzG52erA59Vf75DOfgwJUnulqqhDDU+bHoLcIWf7mxPxUHUaKtWzjFeYwA3xw+FNwUdUMZzyPc5ReyQRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764920847; c=relaxed/simple;
	bh=f38lqpvm6NgOGRKmE5kVPtTquSGePzUoVQWPh91t7Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsTIXgDcBG09mwbdYXAyXLoc8YrAXR12DEAjtkY/Fd278y3qxbCnCdJzz7l978tyIXH2pxhP0sTNajWPNe9RAuR8HHuaJj81Ex49a7c960XhH7N/B8jSIXypyJYNR6UdVUaIX3wt352sW537jwpfXPifmTcRJUVR/ybejI66Nyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fAEGgEEe; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sCrrYc1Y; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F147C336CD;
	Fri,  5 Dec 2025 07:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u05zZs16Haj3itik6vIRiuAnVq+ahPhH88fxSFm8L9g=;
	b=fAEGgEEeZs4PVqaAXQhbIzUjIjR5uJ965ozZWcsgWOzuGSGKSzy47S/82R6Jp3I3PuSxi2
	Lp+RS7ArkxDzaAd5uB5mzXibpDzzD35KNj7AFqNfdoFpr3MUFFBRNcn/Gj0sfskpPOnyPp
	+DT1pmUCpbvyVGW2Upo3wd5IRxUT2Jc=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=sCrrYc1Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920780; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u05zZs16Haj3itik6vIRiuAnVq+ahPhH88fxSFm8L9g=;
	b=sCrrYc1Y76K9bqCnx3hSlLi/nXXPfu9ID0vLqoypWXEhgaulrosBTl9MujzT1GiQ61OzYQ
	2IVaUQvaqlyB5ngFvGyFRTVcaxyrmlglCI3ry9EKvN87ymEQjTEEwkCVl1u02w1ntoLjle
	5sjAm7OHha/7W56OtbSW76onrJYzUuU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 94F9A3EA63;
	Fri,  5 Dec 2025 07:46:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4zftIsyNMmmIEgAAD6G6ig
	(envelope-from <jgross@suse.com>); Fri, 05 Dec 2025 07:46:20 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 07/10] KVM/x86: Use defines for Hyper-V related MSR emulation
Date: Fri,  5 Dec 2025 08:45:34 +0100
Message-ID: <20251205074537.17072-8-jgross@suse.com>
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
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: F147C336CD
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLkdkdrsxe9hqhhs5ask8616i6)];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

Instead of "0" and "1" use the related KVM_MSR_RET_* defines in the
emulation code of Hyper-V related MSR registers.

No change of functionality intended.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/kvm/hyperv.c | 110 +++++++++++++++++++++---------------------
 1 file changed, 55 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 38595ecb990d..7cc6d47becb5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -167,7 +167,7 @@ static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
 	 * allow zero-initing the register from host as well.
 	 */
 	if (vector < HV_SYNIC_FIRST_VALID_VECTOR && !host && !masked)
-		return 1;
+		return KVM_MSR_RET_ERR;
 	/*
 	 * Guest may configure multiple SINTs to use the same vector, so
 	 * we maintain a bitmap of vectors handled by synic, and a
@@ -184,7 +184,7 @@ static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
 
 	/* Load SynIC vectors into EOI exit bitmap */
 	kvm_make_request(KVM_REQ_SCAN_IOAPIC, hv_synic_to_vcpu(synic));
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static struct kvm_vcpu *get_vcpu_by_vpidx(struct kvm *kvm, u32 vpidx)
@@ -263,11 +263,11 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 	int ret;
 
 	if (!synic->active && (!host || data))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	trace_kvm_hv_synic_set_msr(vcpu->vcpu_id, msr, data, host);
 
-	ret = 0;
+	ret = KVM_MSR_RET_OK;
 	switch (msr) {
 	case HV_X64_MSR_SCONTROL:
 		synic->control = data;
@@ -276,7 +276,7 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 		break;
 	case HV_X64_MSR_SVERSION:
 		if (!host) {
-			ret = 1;
+			ret = KVM_MSR_RET_ERR;
 			break;
 		}
 		synic->version = data;
@@ -286,7 +286,7 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 		    !synic->dont_zero_synic_pages)
 			if (kvm_clear_guest(vcpu->kvm,
 					    data & PAGE_MASK, PAGE_SIZE)) {
-				ret = 1;
+				ret = KVM_MSR_RET_ERR;
 				break;
 			}
 		synic->evt_page = data;
@@ -298,7 +298,7 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 		    !synic->dont_zero_synic_pages)
 			if (kvm_clear_guest(vcpu->kvm,
 					    data & PAGE_MASK, PAGE_SIZE)) {
-				ret = 1;
+				ret = KVM_MSR_RET_ERR;
 				break;
 			}
 		synic->msg_page = data;
@@ -319,7 +319,7 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 		ret = synic_set_sint(synic, msr - HV_X64_MSR_SINT0, data, host);
 		break;
 	default:
-		ret = 1;
+		ret = KVM_MSR_RET_ERR;
 		break;
 	}
 	return ret;
@@ -365,7 +365,7 @@ static int syndbg_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	struct kvm_hv_syndbg *syndbg = to_hv_syndbg(vcpu);
 
 	if (!kvm_hv_is_syndbg_enabled(vcpu) && !host)
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	trace_kvm_hv_syndbg_set_msr(vcpu->vcpu_id,
 				    to_hv_vcpu(vcpu)->vp_index, msr, data);
@@ -396,7 +396,7 @@ static int syndbg_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 		break;
 	}
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
@@ -404,7 +404,7 @@ static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	struct kvm_hv_syndbg *syndbg = to_hv_syndbg(vcpu);
 
 	if (!kvm_hv_is_syndbg_enabled(vcpu) && !host)
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	switch (msr) {
 	case HV_X64_MSR_SYNDBG_CONTROL:
@@ -431,7 +431,7 @@ static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 
 	trace_kvm_hv_syndbg_get_msr(vcpu->vcpu_id, kvm_hv_get_vpindex(vcpu), msr, *pdata);
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int synic_get_msr(struct kvm_vcpu_hv_synic *synic, u32 msr, u64 *pdata,
@@ -440,9 +440,9 @@ static int synic_get_msr(struct kvm_vcpu_hv_synic *synic, u32 msr, u64 *pdata,
 	int ret;
 
 	if (!synic->active && !host)
-		return 1;
+		return KVM_MSR_RET_ERR;
 
-	ret = 0;
+	ret = KVM_MSR_RET_OK;
 	switch (msr) {
 	case HV_X64_MSR_SCONTROL:
 		*pdata = synic->control;
@@ -463,7 +463,7 @@ static int synic_get_msr(struct kvm_vcpu_hv_synic *synic, u32 msr, u64 *pdata,
 		*pdata = atomic64_read(&synic->sint[msr - HV_X64_MSR_SINT0]);
 		break;
 	default:
-		ret = 1;
+		ret = KVM_MSR_RET_ERR;
 		break;
 	}
 	return ret;
@@ -695,12 +695,12 @@ static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
 	if (!synic->active && (!host || config))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	if (unlikely(!host && hv_vcpu->enforce_cpuid && new_config.direct_mode &&
 		     !(hv_vcpu->cpuid_cache.features_edx &
 		       HV_STIMER_DIRECT_MODE_AVAILABLE)))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	trace_kvm_hv_stimer_set_config(hv_stimer_to_vcpu(stimer)->vcpu_id,
 				       stimer->index, config, host);
@@ -714,7 +714,7 @@ static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 	if (stimer->config.enable)
 		stimer_mark_pending(stimer, false);
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
@@ -724,7 +724,7 @@ static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
 	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
 	if (!synic->active && (!host || count))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	trace_kvm_hv_stimer_set_count(hv_stimer_to_vcpu(stimer)->vcpu_id,
 				      stimer->index, count, host);
@@ -741,19 +741,19 @@ static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
 	if (stimer->config.enable)
 		stimer_mark_pending(stimer, false);
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int stimer_get_config(struct kvm_vcpu_hv_stimer *stimer, u64 *pconfig)
 {
 	*pconfig = stimer->config.as_uint64;
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int stimer_get_count(struct kvm_vcpu_hv_stimer *stimer, u64 *pcount)
 {
 	*pcount = stimer->count;
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int synic_deliver_msg(struct kvm_vcpu_hv_synic *synic, u32 sint,
@@ -1042,7 +1042,7 @@ static int kvm_hv_msr_get_crash_data(struct kvm *kvm, u32 index, u64 *pdata)
 		return -EINVAL;
 
 	*pdata = hv->hv_crash_param[array_index_nospec(index, size)];
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int kvm_hv_msr_get_crash_ctl(struct kvm *kvm, u64 *pdata)
@@ -1050,7 +1050,7 @@ static int kvm_hv_msr_get_crash_ctl(struct kvm *kvm, u64 *pdata)
 	struct kvm_hv *hv = to_kvm_hv(kvm);
 
 	*pdata = hv->hv_crash_ctl;
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int kvm_hv_msr_set_crash_ctl(struct kvm *kvm, u64 data)
@@ -1059,7 +1059,7 @@ static int kvm_hv_msr_set_crash_ctl(struct kvm *kvm, u64 data)
 
 	hv->hv_crash_ctl = data & HV_CRASH_CTL_CRASH_NOTIFY;
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int kvm_hv_msr_set_crash_data(struct kvm *kvm, u32 index, u64 data)
@@ -1071,7 +1071,7 @@ static int kvm_hv_msr_set_crash_data(struct kvm *kvm, u32 index, u64 data)
 		return -EINVAL;
 
 	hv->hv_crash_param[array_index_nospec(index, size)] = data;
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 /*
@@ -1380,7 +1380,7 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 	struct kvm_hv *hv = to_kvm_hv(kvm);
 
 	if (unlikely(!host && !hv_check_msr_access(to_hv_vcpu(vcpu), msr)))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	switch (msr) {
 	case HV_X64_MSR_GUEST_OS_ID:
@@ -1426,7 +1426,7 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 
 		addr = data & HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_MASK;
 		if (kvm_vcpu_write_guest(vcpu, addr, instructions, i))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		hv->hv_hypercall = data;
 		break;
 	}
@@ -1476,23 +1476,23 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		break;
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
 		if (data && !host)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		hv->hv_tsc_emulation_status = data;
 		break;
 	case HV_X64_MSR_TIME_REF_COUNT:
 		/* read-only, but still ignore it if host-initiated */
 		if (!host)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		break;
 	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
 		/* Only bit 0 is supported */
 		if (data & ~HV_EXPOSE_INVARIANT_TSC)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		/* The feature can't be disabled from the guest */
 		if (!host && hv->hv_invtsc_control && !data)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		hv->hv_invtsc_control = data;
 		break;
@@ -1501,9 +1501,9 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		return syndbg_set_msr(vcpu, msr, data, host);
 	default:
 		kvm_pr_unimpl_wrmsr(vcpu, msr, data);
-		return 1;
+		return KVM_MSR_RET_ERR;
 	}
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 /* Calculate cpu time spent by current task in 100ns units */
@@ -1521,7 +1521,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
 	if (unlikely(!host && !hv_check_msr_access(hv_vcpu, msr)))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	switch (msr) {
 	case HV_X64_MSR_VP_INDEX: {
@@ -1529,10 +1529,10 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 		u32 new_vp_index = (u32)data;
 
 		if (!host || new_vp_index >= KVM_MAX_VCPUS)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (new_vp_index == hv_vcpu->vp_index)
-			return 0;
+			return KVM_MSR_RET_OK;
 
 		/*
 		 * The VP index is initialized to vcpu_index by
@@ -1555,13 +1555,13 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 		if (!(data & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE)) {
 			hv_vcpu->hv_vapic = data;
 			if (kvm_lapic_set_pv_eoi(vcpu, 0, 0))
-				return 1;
+				return KVM_MSR_RET_ERR;
 			break;
 		}
 		gfn = data >> HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT;
 		addr = kvm_vcpu_gfn_to_hva(vcpu, gfn);
 		if (kvm_is_error_hva(addr))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		/*
 		 * Clear apic_assist portion of struct hv_vp_assist_page
@@ -1569,13 +1569,13 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 		 * to be preserved e.g. on migration.
 		 */
 		if (__put_user(0, (u32 __user *)addr))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		hv_vcpu->hv_vapic = data;
 		kvm_vcpu_mark_page_dirty(vcpu, gfn);
 		if (kvm_lapic_set_pv_eoi(vcpu,
 					    gfn_to_gpa(gfn) | KVM_MSR_ENABLED,
 					    sizeof(struct hv_vp_assist_page)))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		break;
 	}
 	case HV_X64_MSR_EOI:
@@ -1586,7 +1586,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 		return kvm_hv_vapic_msr_write(vcpu, APIC_TASKPRI, data);
 	case HV_X64_MSR_VP_RUNTIME:
 		if (!host)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		hv_vcpu->runtime_offset = data - current_task_runtime_100ns();
 		break;
 	case HV_X64_MSR_SCONTROL:
@@ -1618,14 +1618,14 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	case HV_X64_MSR_APIC_FREQUENCY:
 		/* read-only, but still ignore it if host-initiated */
 		if (!host)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		break;
 	default:
 		kvm_pr_unimpl_wrmsr(vcpu, msr, data);
-		return 1;
+		return KVM_MSR_RET_ERR;
 	}
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
@@ -1636,7 +1636,7 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 	struct kvm_hv *hv = to_kvm_hv(kvm);
 
 	if (unlikely(!host && !hv_check_msr_access(to_hv_vcpu(vcpu), msr)))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	switch (msr) {
 	case HV_X64_MSR_GUEST_OS_ID:
@@ -1677,11 +1677,11 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		return syndbg_get_msr(vcpu, msr, pdata, host);
 	default:
 		kvm_pr_unimpl_rdmsr(vcpu, msr);
-		return 1;
+		return KVM_MSR_RET_ERR;
 	}
 
 	*pdata = data;
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
@@ -1691,7 +1691,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
 	if (unlikely(!host && !hv_check_msr_access(hv_vcpu, msr)))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	switch (msr) {
 	case HV_X64_MSR_VP_INDEX:
@@ -1743,10 +1743,10 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		break;
 	default:
 		kvm_pr_unimpl_rdmsr(vcpu, msr);
-		return 1;
+		return KVM_MSR_RET_ERR;
 	}
 	*pdata = data;
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
@@ -1754,10 +1754,10 @@ int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
 
 	if (!host && !vcpu->arch.hyperv_enabled)
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	if (kvm_hv_vcpu_init(vcpu))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	if (kvm_hv_msr_partition_wide(msr)) {
 		int r;
@@ -1775,10 +1775,10 @@ int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
 
 	if (!host && !vcpu->arch.hyperv_enabled)
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	if (kvm_hv_vcpu_init(vcpu))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	if (kvm_hv_msr_partition_wide(msr)) {
 		int r;
-- 
2.51.0



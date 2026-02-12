Return-Path: <kvm+bounces-70994-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oHuGOn/5jWnz9wAAu9opvQ
	(envelope-from <kvm+bounces-70994-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:02:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A29A12F2F2
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:02:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A9F9331822AD
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582A435D611;
	Thu, 12 Feb 2026 15:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fcdheKUJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5484B35CBB7
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770911960; cv=none; b=DsghSkhn2t4hi7Dl2IzGzo2sgOsElrnRafoqXqWU6ktsIWIOGJEnAT4Kw26qEYhaII96eGVmIX6PWEvx6BVQsOKdDrF0c+IwruizdJ3DRKDE+5bnl620qb45goxv4vVB6xx5hcYYR6LTWjtq6GOoT8ZC6pCDEYq/pr1pCWp1fHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770911960; c=relaxed/simple;
	bh=4LHE5WLYNB6gyN85lIMig0mQ2kzlCE0cLPzqj3TDstc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YMJCwwOH5tw4C2fgqOCcUPMfVpkuXUWZy1irDrTX3ctp6n3BkXVUw+erHPM39mylzE6bHOc0zLqjSZbS+duN0R3CFIuyQj1LShLyUrjpvGs0q2QnfgBDnMhxlRa5r+qZwug6ZH6tSEdMbxy/abYjSjPWtC+sx7FLHXn6CoBj2PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fcdheKUJ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c61dee98720so4300907a12.0
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 07:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770911959; x=1771516759; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xlVjUD6X+DWJ5GX5AGAVyWl05TJtGeS8hkpBTgsS/Ys=;
        b=fcdheKUJhL9Lap3mGGAKBOr+zq2hA39ls5F0YVRWa0MXSrdnvEI15eiQCi1r2Rnltt
         X3XpzCdhNIxyYR4WpECd+AlYjqInVexoaJcH8KqFGWC+pAC4KMNdbCySB97iNwuCnIjf
         6a6mMBzdKBsJyscUWEhaJGrOT5EZsqkxuyVTGKsqvxeVgJ+tYb7AsCYymNSxKPMgNLrO
         2nzod//MxHomQnBTxphDr9v3uY5MA7tWVluTCuQGCh22k9/YuDwnVFceN4XRuWdJQJV3
         EeNAX0jcQaUYHNM6zxYe8E3nc5ie9Q6AogrgF4KDzOo6G4BlI2TPH6A02N1ylzm4Wfdl
         1gTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770911959; x=1771516759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xlVjUD6X+DWJ5GX5AGAVyWl05TJtGeS8hkpBTgsS/Ys=;
        b=MQUru+CUe9CxfG43AkPl1J5NsrI7f2XEONWsMOOXygxuxI8bxVQToAcZad2dHak9cF
         AU4Gw5MS3+Kn+SuPO9uTnxV/CtPmpTfLCOA+AJ6VxQu9+6Ttkze9fNAV/LwKVGDGIZDq
         KORFDfkMd5QZ7QxOUfWy2JlJd2gl/lwHdb2YBfAaslcC4Ge57ESo77xUA7ONx7Tt8S2L
         OgdLAIRl7Gbn3+DOj4fNO5Z7CBXk8XZhh8YBJbqjqdcxjIwqnz+7GWTEa+dJmG6cMs9W
         lBgGi/BBvUnCn3KFwokqqnErPaZj2hJPKz8ur4axrQSi/+nYMjdc+gvWIQpEyD9V/A1U
         Hf7g==
X-Forwarded-Encrypted: i=1; AJvYcCXlo3BliSVLwKSYc1/8hxyz/RxfWWaXTst5gUrlTFbypn58oWYS04O6PBXy0QoTNMIjZPo=@vger.kernel.org
X-Gm-Message-State: AOJu0YygmZ6TmX6t26b9sOyu/Qw2a5ZapW5BH8wlmUx0gVBvNjIpn4xM
	TrYG2rL61WT7i962nVZrkoP00pURCPYlvnL/UJY4eWKfnAL6X+WsW5t99Z5MXKuahm6Gn85mviI
	8WgaMDTFjHPEtwg==
X-Received: from pgab127.prod.google.com ([2002:a63:3485:0:b0:c6e:2e0d:72cc])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7284:b0:392:e5eb:f0f with SMTP id adf61e73a8af0-3944897a82fmr3339452637.68.1770911958649;
 Thu, 12 Feb 2026 07:59:18 -0800 (PST)
Date: Thu, 12 Feb 2026 07:58:52 -0800
In-Reply-To: <20260212155905.3448571-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212155905.3448571-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260212155905.3448571-5-jmattson@google.com>
Subject: [PATCH v4 4/8] KVM: x86: nSVM: Redirect IA32_PAT accesses to either
 hPAT or gPAT
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_FROM(0.00)[bounces-70994-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6A29A12F2F2
X-Rspamd-Action: no action

When the vCPU is in guest mode with nested NPT enabled, guest accesses to
IA32_PAT are redirected to the gPAT register, which is stored in
svm->nested.save.g_pat.

Non-guest accesses (e.g. from userspace) to IA32_PAT are always redirected
to hPAT, which is stored in vcpu->arch.pat.

This is architected behavior. It also makes it possible to restore a new
checkpoint on an old kernel with reasonable semantics. After the restore,
gPAT will be lost, and L2 will run on L1's PAT. Note that the old kernel
would have always run L2 on L1's PAT.

Add WARN_ON_ONCE to both svm_get_msr() and svm_set_msr() to flag any
host-initiated accesses originating from KVM itself rather than userspace.

Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c |  9 ---------
 arch/x86/kvm/svm/svm.c    | 37 ++++++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.h    | 17 ++++++++++++++++-
 3 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index dc8275837120..69b577a4915c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -706,15 +706,6 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	return 0;
 }
 
-void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
-{
-	if (!svm->nested.vmcb02.ptr)
-		return;
-
-	/* FIXME: merge g_pat from vmcb01 and vmcb12.  */
-	vmcb_set_gpat(svm->nested.vmcb02.ptr, svm->vmcb01.ptr->save.g_pat);
-}
-
 static void nested_vmcb02_prepare_save(struct vcpu_svm *svm)
 {
 	struct vmcb_ctrl_area_cached *control = &svm->nested.ctl;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 529cbac57814..205bf07896ad 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2837,6 +2837,21 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_AMD64_DE_CFG:
 		msr_info->data = svm->msr_decfg;
 		break;
+	case MSR_IA32_CR_PAT:
+		/*
+		 * When nested NPT is enabled, L2 has a separate PAT from
+		 * L1.  Guest accesses to IA32_PAT while running L2 target
+		 * L2's gPAT; host-initiated accesses always target L1's
+		 * hPAT for backward and forward KVM_GET_MSRS compatibility
+		 * with older kernels.
+		 */
+		WARN_ON_ONCE(msr_info->host_initiated && vcpu->wants_to_run);
+		if (!msr_info->host_initiated && is_guest_mode(vcpu) &&
+		    nested_npt_enabled(svm))
+			msr_info->data = svm->nested.save.g_pat;
+		else
+			msr_info->data = vcpu->arch.pat;
+		break;
 	default:
 		return kvm_get_msr_common(vcpu, msr_info);
 	}
@@ -2920,13 +2935,21 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		break;
 	case MSR_IA32_CR_PAT:
-		ret = kvm_set_msr_common(vcpu, msr);
-		if (ret)
-			break;
-
-		vmcb_set_gpat(svm->vmcb01.ptr, data);
-		if (is_guest_mode(vcpu))
-			nested_vmcb02_compute_g_pat(svm);
+		if (!kvm_pat_valid(data))
+			return 1;
+		/*
+		 * When nested NPT is enabled, L2 has a separate PAT from
+		 * L1.  Guest accesses to IA32_PAT while running L2 target
+		 * L2's gPAT; host-initiated accesses always target L1's
+		 * hPAT for backward and forward KVM_SET_MSRS compatibility
+		 * with older kernels.
+		 */
+		WARN_ON_ONCE(msr->host_initiated && vcpu->wants_to_run);
+		if (!msr->host_initiated && is_guest_mode(vcpu) &&
+		    nested_npt_enabled(svm))
+			svm_set_gpat(svm, data);
+		else
+			svm_set_hpat(svm, data);
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr->host_initiated &&
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a49c48459e0b..88549705133f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -607,6 +607,22 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 	return svm->nested.ctl.misc_ctl & SVM_MISC_ENABLE_NP;
 }
 
+static inline void svm_set_gpat(struct vcpu_svm *svm, u64 data)
+{
+	svm->nested.save.g_pat = data;
+	vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
+}
+
+static inline void svm_set_hpat(struct vcpu_svm *svm, u64 data)
+{
+	svm->vcpu.arch.pat = data;
+	if (npt_enabled) {
+		vmcb_set_gpat(svm->vmcb01.ptr, data);
+		if (is_guest_mode(&svm->vcpu) && !nested_npt_enabled(svm))
+			vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
+	}
+}
+
 static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
 {
 	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_VNMI) &&
@@ -840,7 +856,6 @@ void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
 void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
 				    struct vmcb_save_area *save);
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
-void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
-- 
2.53.0.239.g8d8fc8a987-goog



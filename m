Return-Path: <kvm+bounces-70368-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eOedDHMQhWms7wMAu9opvQ
	(envelope-from <kvm+bounces-70368-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:49:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A7B0CF7E40
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:49:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 33D2530432C8
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 21:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1430B336EC6;
	Thu,  5 Feb 2026 21:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CpJIfaxZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD4E33375B
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 21:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770327824; cv=none; b=Ais1Mvyq6Lg/V7JLLStyV2p9amr9rpHYQ7eO7IMWIpJbGrOQapUK7tr854NjtWbAECAu2E5OZ38gaxjRSrzG1RpZrSYrR2CrzHWbUvMH4H7Ga9/jKi8GzML4gfY4eMp8JpaqFcNyv/7hqDvIZ7YbdpvNSK5IAcCNYXinSeu4m0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770327824; c=relaxed/simple;
	bh=1D+Rg0RzamaZWrQGwQog0TMlHq2s25Z6R2jx9QWiAkk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YtDjFsmd37pOrhLbn7aLHq4HUGQjNC+6ZFVeFcQju++QwDk75iDndy/1gtxTKwlkdFvRz3poBOqe8eD14xLZY4Sc+NSCvItyhuWKliJZVHSikehQhZneVbLvjpWkL7m11pI4rZK4ARdiPkrTxlQlC4XZ6YsaDOIq8ajGSfY/wr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CpJIfaxZ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a07fa318fdso14634235ad.0
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 13:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770327823; x=1770932623; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3S+CqfjZPLDswkTpiM7Jj+iI7z0lBAQUqin93RB1oEY=;
        b=CpJIfaxZ/QjO5cL/fD0sezoL1e2K0t8oPb/l7xJIBGsxBkSkiJOKkgkpXA401XJ2gs
         RWxVR8lMzQOF2ADHK08dRJ4aZqAaHoYg/d3YFWsXEBK3K99XaGOuUrPX+RsHlBiDfYyO
         Bw0z/9L4St6naokiO3BLcGKAAGAPCbZSUWlV6c0bD3oumrn9tVqSpYRocXLRwUzepDY3
         Hd8e8QH/A9F7Y2k8wDcixZxj5tgo5SvInAU6D0YXUiX3qCssj/CNPf9MMIYHKZXHbJPt
         VRlp8M9IrZRa04wjdpi76veYyF9Ips4HkPUNn/IjlXoFdQARAVo8ZH4ZfJKlWt0lfA9u
         Uw1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770327823; x=1770932623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3S+CqfjZPLDswkTpiM7Jj+iI7z0lBAQUqin93RB1oEY=;
        b=PPwp5Tddhp1ptyPK8+MccLfh+VNX/b3XraaryC4oKUhUsQ+ebryc/iIB/HkhKz11zH
         svJJ9Py2akmrVmAQc5haYgvjbAt3f7sBS3QU7q6NsimSDIShoQX9Bi2HQNNftEq/8EoQ
         klZ3w5ItcAbXMOTOglZBuP+AleyAh84/MuT6MZjvHHUeZLkiO1uqwfsrUgu1wPtyRylf
         LZsKgzkJ4p7ZRIzM401REUeiHahO8PNuXvRY09Srm1eCGS0DQhfv+TeKHCDo53cXdTtW
         N0RJGoMV9TjwLp3RjvR3diDa7eUrkPoLZO3v2P2rvMV5OqTe476jR9TsljeY4tXD1qyU
         swSA==
X-Forwarded-Encrypted: i=1; AJvYcCXkl/wEIgcQxV6VKct+4J2pqicIXtxNU1CzGPQUtsBA5zjFriL5gnQ87o71Ro5ilJYV4no=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjGeS6UJN8vaku53v44CFIQ2aCHlHWMkiMs5ocw3O9QBWONtZa
	Cl6OLe946iVddZGjMvduKF714i0yWw2XhY92/tplTNKn96lsC6c+Nqmi049x4dyoaZiVlIXE6wY
	G0NkBrBvDoPlfkA==
X-Received: from pgbdo4.prod.google.com ([2002:a05:6a02:e84:b0:c63:53c3:c03a])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3c8e:b0:341:d5f3:f1ac with SMTP id adf61e73a8af0-393af0c8604mr331317637.41.1770327823550;
 Thu, 05 Feb 2026 13:43:43 -0800 (PST)
Date: Thu,  5 Feb 2026 13:43:04 -0800
In-Reply-To: <20260205214326.1029278-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260205214326.1029278-5-jmattson@google.com>
Subject: [PATCH v3 4/8] KVM: x86: nSVM: Redirect IA32_PAT accesses to either
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
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70368-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A7B0CF7E40
X-Rspamd-Action: no action

When the vCPU is in guest mode with nested NPT enabled, guest accesses to
IA32_PAT are redirected to the gPAT register, which is stored in
vmcb02->save.g_pat.

Non-guest accesses (e.g. from userspace) to IA32_PAT are always redirected
to hPAT, which is stored in vcpu->arch.pat.

This is architected behavior. It also makes it possible to restore a new
checkpoint on an old kernel with reasonable semantics. After the restore,
gPAT will be lost, and L2 will run on L1's PAT. Note that the old kernel
would have always run L2 on L1's PAT.

Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c |  9 ---------
 arch/x86/kvm/svm/svm.c    | 34 ++++++++++++++++++++++++++++------
 arch/x86/kvm/svm/svm.h    | 17 ++++++++++++++++-
 3 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 1ff2ede96094..08844bc51b3c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -630,15 +630,6 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	return 0;
 }
 
-void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
-{
-	if (!svm->nested.vmcb02.ptr)
-		return;
-
-	/* FIXME: merge g_pat from vmcb01 and vmcb12.  */
-	svm_set_vmcb_gpat(svm->nested.vmcb02.ptr, svm->vmcb01.ptr->save.g_pat);
-}
-
 static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
 	bool new_vmcb12 = false;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 08f145eb9215..b62c32c3942d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2852,6 +2852,20 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_AMD64_DE_CFG:
 		msr_info->data = svm->msr_decfg;
 		break;
+	case MSR_IA32_CR_PAT:
+		/*
+		 * When nested NPT is enabled, L2 has a separate PAT from L1.
+		 * Guest accesses to IA32_PAT while running L2 target L2's gPAT;
+		 * host-initiated accesses always target L1's hPAT for backward
+		 * and forward KVM_GET_MSRS compatibility with older kernels.
+		 */
+		WARN_ON_ONCE(msr_info->host_initiated && vcpu->wants_to_run);
+		if (!msr_info->host_initiated && is_guest_mode(vcpu) &&
+		    nested_npt_enabled(svm))
+			msr_info->data = svm->nested.gpat;
+		else
+			msr_info->data = vcpu->arch.pat;
+		break;
 	default:
 		return kvm_get_msr_common(vcpu, msr_info);
 	}
@@ -2935,13 +2949,21 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		break;
 	case MSR_IA32_CR_PAT:
-		ret = kvm_set_msr_common(vcpu, msr);
-		if (ret)
-			break;
+		if (!kvm_pat_valid(data))
+			return 1;
 
-		svm_set_vmcb_gpat(svm->vmcb01.ptr, data);
-		if (is_guest_mode(vcpu))
-			nested_vmcb02_compute_g_pat(svm);
+		/*
+		 * When nested NPT is enabled, L2 has a separate PAT from L1.
+		 * Guest accesses to IA32_PAT while running L2 target L2's gPAT;
+		 * host-initiated accesses always target L1's hPAT for backward
+		 * and forward KVM_SET_MSRS compatibility with older kernels.
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
index 42a4bf83b3aa..a0e94a2c51a1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -590,6 +590,22 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
 }
 
+static inline void svm_set_gpat(struct vcpu_svm *svm, u64 data)
+{
+	svm->nested.gpat = data;
+	svm_set_vmcb_gpat(svm->nested.vmcb02.ptr, data);
+}
+
+static inline void svm_set_hpat(struct vcpu_svm *svm, u64 data)
+{
+	svm->vcpu.arch.pat = data;
+	if (npt_enabled) {
+		svm_set_vmcb_gpat(svm->vmcb01.ptr, data);
+		if (is_guest_mode(&svm->vcpu) && !nested_npt_enabled(svm))
+			svm_set_vmcb_gpat(svm->nested.vmcb02.ptr, data);
+	}
+}
+
 static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
 {
 	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_VNMI) &&
@@ -816,7 +832,6 @@ void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
 void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
 				    struct vmcb_save_area *save);
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
-void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
-- 
2.53.0.rc2.204.g2597b5adb4-goog



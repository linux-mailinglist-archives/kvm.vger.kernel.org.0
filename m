Return-Path: <kvm+bounces-70365-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wMOUI3cPhWms7wMAu9opvQ
	(envelope-from <kvm+bounces-70365-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:45:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A035F7D38
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:45:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4CE54305C884
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 21:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB08933345A;
	Thu,  5 Feb 2026 21:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1Z287AkG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24B433290A
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 21:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770327819; cv=none; b=bN9NriTlYVWkNtBuhT2xNDEa+YxWBHPohe1VWaTvMuXXYPACwcwZ494kSy/mekOk63p7vt/31HEQZE0wkLiHRhOATNYLAcqA0EXLqH0lvzRwgJjmStDYnso1aEz6y+Hfh2OeSV8TWLOwjhH5RhwnIEP1oxfgdGgjtdJta7QmgY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770327819; c=relaxed/simple;
	bh=t1FZ6K9ff28bBOACRhPauD3zpbu3dX1mvB0UDejh2tQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aa986Jw6rG1nM7BxsLUOoM1RpfO6IPjylKFLN2uf1kMI7wtXW/+co1A350imZoEupx3lUevoYBQKt18ha6SglOPRV02QFRHzJAikQub7PCHZuGEGVNxcEbqQbQ6bKdmwpGU7VmuY86dr7USa956dugVF9xQNljBNVvRIqgjm8b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1Z287AkG; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-353049e6047so985455a91.3
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 13:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770327819; x=1770932619; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e7mnOr8u/WACBhY+jlevmvNnx0GAYmKuXG5gmX/ekFE=;
        b=1Z287AkGgGNbX+gUUETm5ThLj4gN9fZrIVmciDtcRGJ7qr1zKYRnggvEad3U6eKpQg
         269Kx/rW4UYRIXzIg1URpUfWn3zYRm2vPPcEyP/b38dJ2lNq0VDY2AJmb12rBubu82hQ
         C5HiV3VGwrnpcvfK/9qgcTpMzqJ5Z4NB98cx+FjyIUTmX0yPbAnhND5IQT7JY3vN7YBI
         wl74uh2ns0SSEPkn/nNBqKkOxiadgHLTK4oBors/75mv7nEOY0YT7C5ItipwWiV3VqmC
         LBTzyYfB1o7mQ5mm2A8d2JItbHI4yXDnZ/9I5g95qEyB1FmaE1IWvfjVDHn5j3CAmtsM
         BAhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770327819; x=1770932619;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e7mnOr8u/WACBhY+jlevmvNnx0GAYmKuXG5gmX/ekFE=;
        b=RrTBB5KXf6lu8Aqx2MrKi0llCgN2qywcKEyqGUg2juIKGYRR6+1/w4aGlVK0ZfO+P3
         VuEFEQuBYQqInhH7sc7HAtDU99FhuloTYMjmmwOBRmh+lQEnGGjl+8SgpAQE/4UMCnQU
         ZqSxPBAiOIusBTYmCvptATclc22x25dNtJhM542bfjK4td+S9MGxjUZPphLqpaMAQ5bD
         MqFjLEucFgn31X5d8uMCtDDM7RoyLGPkGfvK4E/SLopFBzW2xcsS+4pPGj1wNESYh+xu
         Yr2BIFNuMkWYnV8+AGNDYQlXNFDpZfwcnav2s73OxaNlS8GnOZtE4MVAI3mntey8eWt4
         EUBg==
X-Forwarded-Encrypted: i=1; AJvYcCWF3sghQAN0Jqb60TWmVOMj4aFWcuJTSIql2lfRzTi9PvSLFDD/GtSyxe1+QYVX+hxXOZs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCTbe2mp1kiIWKG02/8Bhyg2w4lXV3pV43MZ3hfrr91UqPT+AF
	WlsTMPS6g3mr3nKxb+k0tDikeiOH1YIY1QIEvkVoori4vYmEqy31upGRcMCbv9lqFbMjOXA3jJU
	9q8Lz8kAmaR/k/A==
X-Received: from pjkk4.prod.google.com ([2002:a17:90b:57e4:b0:352:de4e:4039])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3901:b0:354:a57c:65dd with SMTP id 98e67ed59e1d1-354b3cae0d0mr362193a91.24.1770327819173;
 Thu, 05 Feb 2026 13:43:39 -0800 (PST)
Date: Thu,  5 Feb 2026 13:43:01 -0800
In-Reply-To: <20260205214326.1029278-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260205214326.1029278-2-jmattson@google.com>
Subject: [PATCH v3 1/8] KVM: x86: nSVM: Clear VMCB_NPT clean bit when updating
 g_pat in L2
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70365-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1A035F7D38
X-Rspamd-Action: no action

When running an L2 guest and writing to MSR_IA32_CR_PAT, the host PAT value
is stored in vmcb01.ptr->save.g_pat, but the clean bit was only being
cleared for svm->vmcb, which points to vmcb02 in guest mode.

Introduce the helper svm_set_vmcb_gpat() which sets vmcb->save.g_pat and
marks the VMCB dirty for VMCB_NPT. Use this helper in both svm_set_msr()
for updating vmcb01 and in nested_vmcb02_compute_g_pat() for updating
vmcb02, ensuring both VMCBs are properly marked dirty.

Fixes: 4995a3685f1b ("KVM: SVM: Use a separate vmcb for the nested L2 guest")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 arch/x86/kvm/svm/svm.c    | 3 +--
 arch/x86/kvm/svm/svm.h    | 6 ++++++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index de90b104a0dd..f72dbd10dcad 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -636,7 +636,7 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
 		return;
 
 	/* FIXME: merge g_pat from vmcb01 and vmcb12.  */
-	svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
+	svm_set_vmcb_gpat(svm->nested.vmcb02.ptr, svm->vmcb01.ptr->save.g_pat);
 }
 
 static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5f0136dbdde6..08f145eb9215 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2939,10 +2939,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (ret)
 			break;
 
-		svm->vmcb01.ptr->save.g_pat = data;
+		svm_set_vmcb_gpat(svm->vmcb01.ptr, data);
 		if (is_guest_mode(vcpu))
 			nested_vmcb02_compute_g_pat(svm);
-		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr->host_initiated &&
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ebd7b36b1ceb..986d90f2d4ca 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -420,6 +420,12 @@ static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
         return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
 }
 
+static inline void svm_set_vmcb_gpat(struct vmcb *vmcb, u64 data)
+{
+	vmcb->save.g_pat = data;
+	vmcb_mark_dirty(vmcb, VMCB_NPT);
+}
+
 static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_svm, vcpu);
-- 
2.53.0.rc2.204.g2597b5adb4-goog



Return-Path: <kvm+bounces-70992-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GC2tCBn5jWnz9wAAu9opvQ
	(envelope-from <kvm+bounces-70992-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:00:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 73C8B12F2CC
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:00:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A4760312C0F8
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D90635C18D;
	Thu, 12 Feb 2026 15:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fl/VG49g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C1633EB19
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770911957; cv=none; b=T4jHbk+0+oS9DAxBEFljOSjVLLORPMIHwIHFKx4va6bL/R6CdI49GrrEn6xkjv7+4QEEuqSY7SMYkeZn/jqdscgrIDJHujv2Jf0VCvjlWZOHRgcVHBucC4cyWkE4I1m0u8mJJLVYiVaxFOp8Cc48N6K12cYnBOMYA6AEjN1u6Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770911957; c=relaxed/simple;
	bh=0pkG637PPrMnHAp36dNXBDpeM+jikBZBFutLvS3Rhns=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rk5lyp5tHDNKDbegBIaFGtAyXIJjiFog1nUI7Zan+6slDrpkWXF7l86648Ul3S/1UhD7x/kSU5DIiEOqiVDMQe+rFM7LfhavxW/VnpbXoAM4VBCX0LGnCk4HFkjqOHPONyYAPmTOoQRS4sDPE+QDLdO7kSGFB1wfHvcrhd1Sq5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fl/VG49g; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a377e15716so175212535ad.3
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 07:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770911956; x=1771516756; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zf8WWkIBl7yhW0Oc6MyZTF76PTkFmwYWfgFxHjbq7+4=;
        b=fl/VG49gVN/F8pdVQNA06z9p8j+5wbrNAWug/wXdtGfScySTyqVCcSrRO4fzTt70B1
         n9fnId1lscpIn+0LlqtumdZ6gyslwpfX1x9wXMeeVpBe80yA90PEsMaRp1X5O3UdhPMj
         wiP4cK+3A0Q3M5seoGXc2BGCMbwEY+EUdRjYXflIAZdVayzrMAl1fLX9mdWd6d2wTDr/
         8QecPr14ztkTUu3REcITEQjP2EeOEB89XFPYRenDLgi70YM9tjFQtSBfdeHRtAuJ+nuH
         hXQNEvE7CZryMBTOz3/H6+Xcl6QsccW839SUEJ+OuQxhMpC9nS0xh+48yJHMB9zsERS4
         x81Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770911956; x=1771516756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zf8WWkIBl7yhW0Oc6MyZTF76PTkFmwYWfgFxHjbq7+4=;
        b=CqgjrCrl62JLpa1hDM34UFKa8EI/jnH1z4ODxI5ku3+MO1G77IrEaRj+ulIgCG++/s
         ADc3vHZQ38fj0Ov8fMO8sOb+3T0sPB8GhBo46GTa4wu3TsqOovjuJ2WQdQyc+mYhQ9E+
         qacboKfSxL2/y0OSz868bq1F7h7fF88Q6hXatYCRE+QmuckNK9b0dVD2y6vvXqWHaAqF
         Ds451PcvekA/uYSWePRQreZLUvet3YM/a/AyGx5y7elcS4/9W1YwwS+1uydGvysliReD
         KwmBySusN5k1fGW+gEclJm9sL2lOtbJGIHoCHP3LoOH2wIUe5Isgj+AVvMmjA1mM58VF
         40TA==
X-Forwarded-Encrypted: i=1; AJvYcCUP8cb1bzxTQYv567QHkPZnLR0f5Ke9x3w/0A0eLmyGhkEYexTPh8kkiIY0Cg0eDq4gjnI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhGP+oQE6FomkYyw5lQG/IxZ9Rb6DJSxd0nWv/9pWkSY/8i8ZU
	lOcNTfRb7Az3Y/nQoSztRVb/Uzgz63lg3wyv9L2snxF87XToIOPlwhuwlMe6scXyV+xqAnEJ9Nf
	or0q86JLIw5MWhQ==
X-Received: from plbkh12.prod.google.com ([2002:a17:903:64c:b0:2aa:d3c5:610d])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:98b:b0:295:62d:5004 with SMTP id d9443c01a7336-2ab399dd629mr35532595ad.26.1770911955652;
 Thu, 12 Feb 2026 07:59:15 -0800 (PST)
Date: Thu, 12 Feb 2026 07:58:50 -0800
In-Reply-To: <20260212155905.3448571-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212155905.3448571-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260212155905.3448571-3-jmattson@google.com>
Subject: [PATCH v4 2/8] KVM: x86: nSVM: Cache and validate vmcb12 g_pat
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
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
	TAGGED_FROM(0.00)[bounces-70992-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 73C8B12F2CC
X-Rspamd-Action: no action

Cache g_pat from vmcb12 in vmcb_save_area_cached to avoid TOCTTOU issues,
and add a validity check so that when nested paging is enabled for vmcb12,
an invalid g_pat at emulated VMRUN causes an immediate VMEXIT with exit
code VMEXIT_INVALID, as specified in the APM, volume 2: "Nested Paging and
VMRUN/VMEXIT."

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 17 +++++++++++++----
 arch/x86/kvm/svm/svm.h    |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b72a1f3c4144..91b35adb83f8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -426,7 +426,8 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 
 /* Common checks that apply to both L1 and L2 state.  */
 static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu,
-				   struct vmcb_save_area_cached *save)
+				   struct vmcb_save_area_cached *save,
+				   bool check_gpat)
 {
 	if (CC(!(save->efer & EFER_SVME)))
 		return false;
@@ -462,6 +463,9 @@ static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu,
 	if (CC(!kvm_valid_efer(vcpu, save->efer)))
 		return false;
 
+	if (check_gpat && CC(!kvm_pat_valid(save->g_pat)))
+		return false;
+
 	return true;
 }
 
@@ -573,6 +577,7 @@ static void __nested_copy_vmcb_save_to_cache(struct vmcb_save_area_cached *to,
 
 	to->rax = from->rax;
 	to->cr2 = from->cr2;
+	to->g_pat = from->g_pat;
 
 	svm_copy_lbrs(to, from);
 }
@@ -1036,7 +1041,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
 
 	enter_guest_mode(vcpu);
 
-	if (!nested_vmcb_check_save(vcpu, &svm->nested.save) ||
+	if (!nested_vmcb_check_save(vcpu, &svm->nested.save,
+				    nested_npt_enabled(svm)) ||
 	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl,
 					svm->vmcb01.ptr->save.cr0))
 		return -EINVAL;
@@ -2006,13 +2012,16 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	/*
 	 * Validate host state saved from before VMRUN (see
-	 * nested_svm_check_permissions).
+	 * nested_svm_check_permissions). Note that the g_pat field is not
+	 * validated, because (a) it may have been clobbered by SMM before
+	 * KVM_GET_NESTED_STATE, and (b) it is not loaded at emulated
+	 * #VMEXIT.
 	 */
 	__nested_copy_vmcb_save_to_cache(&save_cached, save);
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
-	    !nested_vmcb_check_save(vcpu, &save_cached))
+	    !nested_vmcb_check_save(vcpu, &save_cached, false))
 		goto out_free;
 
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9850ed01e16e..a49c48459e0b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -161,6 +161,7 @@ struct vmcb_save_area_cached {
 	u64 isst_addr;
 	u64 rax;
 	u64 cr2;
+	u64 g_pat;
 	u64 dbgctl;
 	u64 br_from;
 	u64 br_to;
-- 
2.53.0.239.g8d8fc8a987-goog



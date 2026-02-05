Return-Path: <kvm+bounces-70367-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8DtFEToQhWms7wMAu9opvQ
	(envelope-from <kvm+bounces-70367-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:48:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BDCD2F7E2A
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:48:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 69AA83040A82
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 21:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A72F3332EDB;
	Thu,  5 Feb 2026 21:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PzElm3RG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1973335074
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 21:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770327822; cv=none; b=j+ju6IpHPBZQ2G+UJEYM/nuaR2KU/dHz3hyaXkhATATfNfXDNBUlDssnlzUUZhs2GcAFv39VXCpjfNmZHceoZSS7hiTB4JQrntNK7dIKHjFGrg6/GmW9mYYaxZ1oTjm6JZtdQB78HXJ/HK6u6HKx3Mc3DkHE8kn84yj7Hq1k6eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770327822; c=relaxed/simple;
	bh=/RX4mCH35HZdkO8HyVbrveLVnRTbZa+1vh8oTPb28F8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L5Abs/VIWGXBoeJ6d73CbUcjutO9jZS9WT6smlfoUUHe7GWdfcuZlryQ74pPk0B0VZntPS5OI8Dfw9rjxQS09Nx2DecePRKiEG9CSmxYknNCHTP0RqFVMH7ozbhH8XfgWU2xPVQpqmwWU/gW8Sqz/EWSXvhz9o57GpKc29RRSHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PzElm3RG; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c634b862fcfso843523a12.2
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 13:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770327822; x=1770932622; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vzh3iLHAfWUF+ni0XgKYTYRZaX8q/MuSJjdjzVEy2HI=;
        b=PzElm3RGGIe7FaErGMIOiEXp6nZ4slLg/mnY4AHOYO2jEy4jlgRBXsBT3q6U3NQOzb
         y19GgpPmv9R93CFzhmpTmhYMvCVhRQx/FudrcbRX3a2WfR3rb763RWntTlC562t1TXNQ
         Yf9R3fbj94z4Lgi6ROTAW+jB0lXeshvyKmx9jGpJj3lluKskZX8tCm14HGiKYTJNYnCu
         uYLHL4UCoWkBD+q76gXuua3C9f7uwHkgiKcmCe4vDudOxjDvK8uphtA4+irSNpMsYOdd
         /G7rGOZ8gcpMcsoXjxTt/UGNlm1zApNTwX/ac6XUg5o/7CuK29hqAuk2FX4OClKYXK/l
         bcJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770327822; x=1770932622;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vzh3iLHAfWUF+ni0XgKYTYRZaX8q/MuSJjdjzVEy2HI=;
        b=ct4ToevahjPaCY/ySDC1wcBsNAeTzI1yKKLXgaUvY+VOyovEl7AfvK46OaKzc7K+7M
         aBNISbw32L4y90ueWERggfxO9NrrpBq9tH2RK2RBM0zpX2RtX6xq/yMB76ftrMCiFvIZ
         VsK0XvBiZxKIerGHB8aofzVruO9TqdzqGckyzIzmu4FU2WXTtlxLwijoGtLxn0p0nYw5
         XcadPclyTr2dBjDr+X3ushQFd6xtWreGMfga6dbnvvf8vcSXB9mVShc63BjsJn1oxZ4b
         5ZrlsAU5L8oeBV/dQSJi3bhDDTnzTZ4OuwmgUndUmwzSZp1J5vFZa6GeDgOEO73rP3Oz
         4hHg==
X-Forwarded-Encrypted: i=1; AJvYcCXNpqK/B6X478ZM33NwrKtK/cy37EYp+7BZLMXOm0ro4efPjiOM8i1n8gpdjLZ1MV/GXgw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZyFUrWZzwGw5/WSecMx8TlLyr4OQBDLgYIGzVHRLzOB+dxAdA
	uyTRWeLSeJ45RxSRiPBkUeB+gOWwf3nbp8HQl6QSxaZA26IgadKW/Hd7g4u0hxf0xgB9ZLGjwCv
	5JCg9FdWRHg9EkA==
X-Received: from pjq16.prod.google.com ([2002:a17:90b:5610:b0:34c:2778:11c5])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:517:b0:38b:eeb9:cbb5 with SMTP id adf61e73a8af0-393af0da032mr246446637.39.1770327822187;
 Thu, 05 Feb 2026 13:43:42 -0800 (PST)
Date: Thu,  5 Feb 2026 13:43:03 -0800
In-Reply-To: <20260205214326.1029278-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260205214326.1029278-4-jmattson@google.com>
Subject: [PATCH v3 3/8] KVM: x86: nSVM: Set vmcb02.g_pat correctly for nested NPT
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
	TAGGED_FROM(0.00)[bounces-70367-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: BDCD2F7E2A
X-Rspamd-Action: no action

When nested NPT is enabled in vmcb12, copy the (cached and validated)
vmcb12 g_pat field to the guest PAT register. Under KVM, the guest PAT
register lives in the vmcb02 g_pat field.

When NPT is enabled, but nested NPT is disabled, copy L1's IA32_PAT MSR to
the vmcb02 g_pat field, since L2 shares the IA32_PAT MSR with L1.

When NPT is disabled, the vmcb02 g_pat field is ignored by hardware.

Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 1d4ff6408b34..1ff2ede96094 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -646,9 +646,6 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	nested_vmcb02_compute_g_pat(svm);
-	vmcb_mark_dirty(vmcb02, VMCB_NPT);
-
 	/* Load the nested guest state */
 	if (svm->nested.vmcb12_gpa != svm->nested.last_vmcb12_gpa) {
 		new_vmcb12 = true;
@@ -656,6 +653,19 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		svm->nested.force_msr_bitmap_recalc = true;
 	}
 
+	if (npt_enabled) {
+		if (nested_npt_enabled(svm)) {
+			if (unlikely(new_vmcb12 ||
+				     vmcb_is_dirty(vmcb12, VMCB_NPT))) {
+				vmcb02->save.g_pat = svm->nested.gpat;
+				vmcb_mark_dirty(vmcb02, VMCB_NPT);
+			}
+		} else {
+			vmcb02->save.g_pat = vcpu->arch.pat;
+			vmcb_mark_dirty(vmcb02, VMCB_NPT);
+		}
+	}
+
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_SEG))) {
 		vmcb02->save.es = vmcb12->save.es;
 		vmcb02->save.cs = vmcb12->save.cs;
-- 
2.53.0.rc2.204.g2597b5adb4-goog



Return-Path: <kvm+bounces-70991-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8G15AOj4jWnz9wAAu9opvQ
	(envelope-from <kvm+bounces-70991-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 16:59:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CF7B12F290
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 16:59:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C20CA3069D39
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AD4D344D88;
	Thu, 12 Feb 2026 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gaLaqEal"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6C7311C22
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 15:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770911955; cv=none; b=A2d3ykUyG9t/jy8q4AeN/QXYIKH5RNfKZMN25Gj0DEj5lWQi4Qxu7McH3VEiaEJ9fx9I5B3XCqlLbHJDA3ELLlqfAEcVKF2S62QS0tqkUjFXbHVpCngZhcZy0boozYagZ8i9rYF1tS9gjxBWKVb+QfGQjexKD7Cq3ywLUNWImXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770911955; c=relaxed/simple;
	bh=mbEr3hzyszjJo46OU/qkjXN9L7/rAyLb4rEYR0jpuE8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P1XEW/I2/kAtRbhbT/myN8uTrIia4u6lsq4rbYAh7SmoG3bagpN5J0lFakW07ZhNv2/NSycNWK34IFmbGKZ8hf8399X0oXWrO0xwHYsnOSQS2tebrjoOrlapRjsqw3qXvO6zDL1TuXes2TnJE41wUPLfviNoIqBEQLbypdcTYf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gaLaqEal; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6df833e1efso7927116a12.2
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 07:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770911954; x=1771516754; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J6K8kyx9CcUqpPEEuGOr7xIDm2PG4sM2n5DYfDKzhGk=;
        b=gaLaqEalXK25FPBVCJfjG1nVXZh0QROSDjhxJ/M22T8D4S9eQw2gyRcnv5dWJ7Z7KD
         ez/cl60A9fXcypTgecR2Znf+guBnb+Ar+l+rboZ8GYn+mmL6wpRHRyM7/osi4Y4yOblF
         4QbVbbYW0VEIGs+hhV1rQXPjPD+8B+90FFAE8Zl+CTt7Xnurcq451tFoonrLXxW9nYf9
         RKfNbedQMa9bgq7LSqko/v2wys0MyQylnP1wYYVp+AI19FSJYgBa13gpJr8PxjQ0/ZCj
         vqeHO784iZ0b+mVWbJ0Yu7hKmvMpGiJko2jPG8X4J8R/Tkd+8xcG8jocyyRL/Lq+DFIs
         ENKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770911954; x=1771516754;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J6K8kyx9CcUqpPEEuGOr7xIDm2PG4sM2n5DYfDKzhGk=;
        b=hxGxrRv2IH+Fm8f+ujGWhikbqYB5u+GXcRrHrp12mC38tZrIht89cJCxR7XW6pPXNt
         XmzlSOXYWI/1BaV3JS0r17TnAvKR9B52GAi3xgU7Jpn++G7mohaWBsWgp7rPpuDTkwMX
         Q9sXvE/OZCVT7A9COAK1MJj+Tw4HopVCNc5WCUp6nmBys7zc5jQHo/vGO9NJPTh5dwkZ
         8S7EttG80WMpbHu1Fg+9B4P4P8hGjouNnbTvWIi6LCVyah51GvgTgG0R/Is+TicrT5zG
         5eBvH524r7P5gD5Ga0ZQFL312JL7qacsetC5v6hEw/8b0nuY/GNU8hmL0UKZPy4ZISVR
         i+zQ==
X-Forwarded-Encrypted: i=1; AJvYcCWynnF7Wfa5I4rFRkyOb2B5qv9zQ3QGtvT4v6U5TIrgDKZ4bTwBrM3LCh24D7mVd8NRlvw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLTYVNg7GnBCpqSDMT8xJDyVyLHI5JrjnGWE9MoiKZaZ4OOK41
	TwMSbFMb7aKWKzvu8qca0qXDjn6NPnddYedazy3I702bGOovhTzSB/nRju9oVxecBKIQ9vxMdqQ
	TEiM7/gViYsjAhw==
X-Received: from pgc7.prod.google.com ([2002:a05:6a02:2f87:b0:c6e:21b7:bfd0])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3d8d:b0:35f:cfb:1ee3 with SMTP id adf61e73a8af0-394484b2496mr3361847637.25.1770911954124;
 Thu, 12 Feb 2026 07:59:14 -0800 (PST)
Date: Thu, 12 Feb 2026 07:58:49 -0800
In-Reply-To: <20260212155905.3448571-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212155905.3448571-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260212155905.3448571-2-jmattson@google.com>
Subject: [PATCH v4 1/8] KVM: x86: nSVM: Clear VMCB_NPT clean bit when updating
 hPAT from guest mode
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
	TAGGED_FROM(0.00)[bounces-70991-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8CF7B12F290
X-Rspamd-Action: no action

When running an L2 guest and writing to MSR_IA32_CR_PAT, the host PAT value
is stored in both vmcb01's g_pat field and vmcb02's g_pat field, but the
clean bit was only being cleared for vmcb02.

Introduce the helper vmcb_set_gpat() which sets vmcb->save.g_pat and marks
the VMCB dirty for VMCB_NPT. Use this helper in both svm_set_msr() for
updating vmcb01 and in nested_vmcb02_compute_g_pat() for updating vmcb02,
ensuring both VMCBs' NPT fields are properly marked dirty.

Fixes: 4995a3685f1b ("KVM: SVM: Use a separate vmcb for the nested L2 guest")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 arch/x86/kvm/svm/svm.c    | 3 +--
 arch/x86/kvm/svm/svm.h    | 9 +++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d80b1bde6630..b72a1f3c4144 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -707,7 +707,7 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
 		return;
 
 	/* FIXME: merge g_pat from vmcb01 and vmcb12.  */
-	svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
+	vmcb_set_gpat(svm->nested.vmcb02.ptr, svm->vmcb01.ptr->save.g_pat);
 }
 
 static void nested_vmcb02_prepare_save(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 364915f42e13..529cbac57814 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2924,10 +2924,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (ret)
 			break;
 
-		svm->vmcb01.ptr->save.g_pat = data;
+		vmcb_set_gpat(svm->vmcb01.ptr, data);
 		if (is_guest_mode(vcpu))
 			nested_vmcb02_compute_g_pat(svm);
-		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr->host_initiated &&
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0bb93879abfe..9850ed01e16e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -434,14 +434,15 @@ static inline void vmcb_mark_dirty(struct vmcb *vmcb, int bit)
 	vmcb->control.clean &= ~(1 << bit);
 }
 
-static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
+static inline bool vmcb12_is_dirty(struct vmcb_ctrl_area_cached *control, int bit)
 {
-        return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
+	return !test_bit(bit, (unsigned long *)&control->clean);
 }
 
-static inline bool vmcb12_is_dirty(struct vmcb_ctrl_area_cached *control, int bit)
+static inline void vmcb_set_gpat(struct vmcb *vmcb, u64 data)
 {
-	return !test_bit(bit, (unsigned long *)&control->clean);
+	vmcb->save.g_pat = data;
+	vmcb_mark_dirty(vmcb, VMCB_NPT);
 }
 
 static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
-- 
2.53.0.239.g8d8fc8a987-goog



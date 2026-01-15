Return-Path: <kvm+bounces-68274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 73DF1D293FE
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 00:27:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DC8413097D4A
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 23:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05EEC328B52;
	Thu, 15 Jan 2026 23:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cxPsHpYF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1094330B2F
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 23:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768519355; cv=none; b=YrgZ3xP6VGJLTgEfChwATLmiGsyD5vL9N2CaPYsTC1ARDAaBVHP3PlPWhD7a11HtN3G/jOiWaOERuvNgUrS+E0/jg7m8EvnDH303vU94KvGs2vS/13KpYtSc56LF6DznaP75EDggPDahCFlLosa5AK/K/Y2zpm/SG+aQLS1R58o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768519355; c=relaxed/simple;
	bh=QGaBI2jmMXiz5Zzh8UzMEfKuZBd6orN3mlkFUEX03hI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MukfTzPOy62l6NmGPon+TbanKiMHA0aBvDXS4NL1YdZijzsOyofkwqAEDrvbRrDlQQuiJfOq2e2NHJipOHwvLu8rEUUtJex09UbQulYygEsvK0Po48iIb7xpmkjAJOTakh7OSSJZ+mPw/5kLPGyozfxOikgR80K2gLvKFL3GxoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cxPsHpYF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ab459c051so2814252a91.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 15:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768519343; x=1769124143; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X41FAJWB3N1JsaEn1Z67wfrNr3PEAApqVjSGPombTu8=;
        b=cxPsHpYFdUSeHGJ9xX3z+/Yt6qKvljuGIAInnN2I65i78DPIUmHJV6UmYqeMdVtKkd
         zr9ylpi1hpiZJURV6smmbLB7kbHcIX0sQnzLXcsVEEEUkSjo2ehvXtjIIB8TmLdB3XPC
         hzNtEoD8mEU/XyuVQm6QbOyFHbp3YCrjD7T3NX9fu6nfYDKowuaAYpjtQtD0TO3zMdpB
         jir6ay6CnKDpvSzGOEHdpupD+EKaSGeGyXctWEdQ47bcmILjWFiq32uEzUb/y/51eHNZ
         /SHXLXH+D2WYy5i1SqJJMgmobI4LqcJ3v1BVYqVmc4oq7cLwZaRdZJgmVlRWMlwgfcyw
         aGmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768519343; x=1769124143;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X41FAJWB3N1JsaEn1Z67wfrNr3PEAApqVjSGPombTu8=;
        b=YRkYZfKkjNgYbavN/PGsIX9vRM4wg97P7VqgxwwuonotuuWSUiUYiQgvXt4dTAIdeY
         KktwDztJaONwNKnBd0HdIqyt/SEuHF26YejCaR09UMKIAGtd9Z8sb9wEHUv8DTyEJn4U
         5231nfzI7kgIh8SyEdwLzw1bMVF8tkmXssluXlxwuGzVZM38HbzGK222riMGjR+OFPHU
         rPpGrwTyzq9PSIrIqYRFEMJMzOc2VRD/YUg1JSHvwE4VjEy3WphrQTxVORN5svotKfe3
         Cmx8DU0JbahDT8d6TeQIgZSw0GLAPD/i+8Uct3vvQ7Jn2dj5jZGFGvoFkd+4NuxoKq+P
         BXUg==
X-Forwarded-Encrypted: i=1; AJvYcCWx00zeF410MHhCpZ3fGaHx1Qz7Glv6eoxGkdY2TUgenDQIwYKXp3S9Y4IuoHs/+R0hqyA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv51xSa2LzimxWcqTsDVxZl8iuxtxfBjV7q7jcIIyI4E/kEo6+
	b3+zz81VU3BVShFvnrbESSpZaTq1CHNKTDB+pIekd8tcd6d2dQmFJsKBkfx641Sjc0Oim+HiKFA
	hqIeIstVwsxFgSQ==
X-Received: from pgct22.prod.google.com ([2002:a05:6a02:5296:b0:c1d:b0b3:5e63])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:7116:b0:38b:e9eb:b12c with SMTP id adf61e73a8af0-38dfe67bddemr1490481637.31.1768519342651;
 Thu, 15 Jan 2026 15:22:22 -0800 (PST)
Date: Thu, 15 Jan 2026 15:21:46 -0800
In-Reply-To: <20260115232154.3021475-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115232154.3021475-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260115232154.3021475-8-jmattson@google.com>
Subject: [PATCH v2 7/8] KVM: x86: nSVM: Handle restore of legacy nested state
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

When nested NPT is enabled and KVM_SET_NESTED_STATE is used to restore an
old checkpoint (without a valid gPAT), the current IA32_PAT value must be
copied to vmcb02->save.g_pat.

Unfortunately, the current IA32_PAT value may be restored by KVM_SET_MSRS
after KVM_SET_NESTED_STATE.

Introduce a new boolean, svm->nested.restore_gpat_from_pat. If set,
svm_vcpu_pre_run() will copy vcpu->arch.pat to vmcb02->save.g_pat and clear
the boolean.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 9 ++++++---
 arch/x86/kvm/svm/svm.c    | 8 ++++++++
 arch/x86/kvm/svm/svm.h    | 6 ++++++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c50fb7172672..61a3e7226cde 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1958,9 +1958,12 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (ret)
 		goto out_free;
 
-	if (is_guest_mode(vcpu) && nested_npt_enabled(svm) &&
-	    (kvm_state.hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT))
-		svm->vmcb->save.g_pat = save_cached.g_pat;
+	if (is_guest_mode(vcpu) && nested_npt_enabled(svm)) {
+		svm->nested.restore_gpat_from_pat =
+			!(kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT);
+		if (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT)
+			svm->vmcb->save.g_pat = save_cached.g_pat;
+	}
 
 	svm->nested.force_msr_bitmap_recalc = true;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3f8581adf0c1..5dceab9f4c3f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4217,9 +4217,17 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 
 static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	if (to_kvm_sev_info(vcpu->kvm)->need_init)
 		return -EINVAL;
 
+	if (svm->nested.restore_gpat_from_pat) {
+		svm->vmcb->save.g_pat = vcpu->arch.pat;
+		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
+		svm->nested.restore_gpat_from_pat = false;
+	}
+
 	return 1;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 39138378531e..1964ab6e45f4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -219,6 +219,12 @@ struct svm_nested_state {
 	 * on its side.
 	 */
 	bool force_msr_bitmap_recalc;
+
+	/*
+	 * Indicates that vcpu->arch.pat should be copied to
+	 * vmcb02->save.g_pat at the next vcpu_run.
+	 */
+	bool restore_gpat_from_pat;
 };
 
 struct vcpu_sev_es_state {
-- 
2.52.0.457.g6b5491de43-goog



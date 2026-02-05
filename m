Return-Path: <kvm+bounces-70371-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sOk4ClEQhWms7wMAu9opvQ
	(envelope-from <kvm+bounces-70371-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:49:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BC169F7E39
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:49:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3E8593048B37
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 21:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 536BA338932;
	Thu,  5 Feb 2026 21:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TNbVf3Vz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE4D338595
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 21:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770327828; cv=none; b=XG+Yng3DH04doGqebqcP7V7mOywaymyqIF5glj7CNXDLFSOtQMGRpfUmmdMYwAjeaWmuhOECB7Cum0BF8Cj0hQA7r6QHLByc9643W1cY6/OS52+5tSrcvjIsCJ6yhlseDd8XdsBTxtFW5FTRul4OeJ41jPNM4AQghVULHxhY6ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770327828; c=relaxed/simple;
	bh=MekaBo4sf17xgGY9W1J8mQajBnaq5uK/pQ/wy1TwC7A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YIS3HvibWxxGhDsp6pz1BUXON2MS+IKbuaCmkTLRx5mKYllKxVhnVaFyscDCN/YIKKcTS5z9Ul3ZzOK2hr0RHCDJIAhgPBDDDCyT168kAkMbEjZ+aoaLdMiJYHd9YbzmTu19qwCZPingQ9FRidiGHWS+gTtkjle7o+YsUvAIASY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TNbVf3Vz; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a943e214daso31365125ad.3
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 13:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770327828; x=1770932628; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=43/5MPyJUuLlvxAVOINMUPcXPK41vsmXFa7nB5Y5I2U=;
        b=TNbVf3Vzy4UmZYIeScvgt0I7YPk97440u/F9plyESJkWLVuhLygfR24Ic9sKd1VhWz
         844DuQWjTowOSCB2jaVOVIv1Il5Vzbap7gcY1v3WDGPFUZby2CV37fAaMotm9baaf7wU
         d+XNg9vsNAwPoRmm/2MKxZDDnURFvbYmCqZahW/EK6QLMdRFT2twyg9g/S169sgsgyoZ
         GWAC9lIeJWhIpBK6xZqAgIO2QgA1kUT1mf7QfzNEG4e9phz4k4tLD9UtVpTpLnljVu02
         +rS2/xahXdEFodUwhN2D2V5T+WGp5pRAi4CeSl0/jyLRvwKpglP+3uPIjdwrGUtVs+eN
         Y+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770327828; x=1770932628;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=43/5MPyJUuLlvxAVOINMUPcXPK41vsmXFa7nB5Y5I2U=;
        b=MFm4E/8v3VhtMiJx/ebUcFwfOIK2ITqaxtelInH+c7zMIzOMEVahUStp/w+HXGucgq
         XBhphRrBNNiz52xO0PoeK9mPb4Gu27J1NGKfQvvCTOxyZ/ZB8FRanlDcCNtYSDfs7N4Q
         GYp/lRj28VZOt3baSIgemrj99oB2IAbnrG31yhDcBukkLb3HRomQXOOaEFq4/O5IfJgj
         gHCv0d8j7saQr6P2y0yUG5oEnH7neK11KeumQEgEybhAPDeM8OHM6C7f+z2k5x4FopAw
         GgXx+edNyMGFgIvYv0kOY4LKlVhJWIJHwPPrl62IsxTEcUD2QxA111V/kyaDEQ9AaHYx
         9DbA==
X-Forwarded-Encrypted: i=1; AJvYcCWMJKVdwy793AxnigsCMSziiBYIR57+4Nyxdthi3oVNQyW405dbcADLN9P/M7KILquCEQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaGE0ioYMVfNj0fdmFemaZ6FZ2fF9sI3vIyDGftE9FQI/6+Nn+
	ptvy+FAp5m5Pc/QAeoFHvYUVt4nXhdjtIlwvTNs+sYcQVRWEp+5Ob0MEAHw6ufz62a/mgJYTtRc
	pk2vUvjdJ3bs8PA==
X-Received: from plpr14.prod.google.com ([2002:a17:903:3e2e:b0:29f:2b44:973b])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:eb14:b0:2a3:bf9d:9399 with SMTP id d9443c01a7336-2a9516d4f31mr4351265ad.35.1770327827905;
 Thu, 05 Feb 2026 13:43:47 -0800 (PST)
Date: Thu,  5 Feb 2026 13:43:07 -0800
In-Reply-To: <20260205214326.1029278-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260205214326.1029278-8-jmattson@google.com>
Subject: [PATCH v3 7/8] KVM: x86: nSVM: Handle restore of legacy nested state
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
	TAGGED_FROM(0.00)[bounces-70371-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: BC169F7E39
X-Rspamd-Action: no action

When nested NPT is enabled and KVM_SET_NESTED_STATE is used to restore an
old checkpoint (without a valid gPAT), the current IA32_PAT value must be
used as L2's gPAT.

The current IA32_PAT value may be restored by KVM_SET_MSRS after
KVM_SET_NESTED_STATE. Furthermore, there may be a KVM_GET_NESTED_STATE
before the first KVM_RUN.

Introduce a new boolean, svm->nested.legacy_gpat_semantics. When set, hPAT
updates are also applied to gPAT, preserving the old behavior where L2
shared L1's PAT. svm_vcpu_pre_run() clears this boolean at the first
KVM_RUN.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 11 ++++++++---
 arch/x86/kvm/svm/svm.c    |  2 ++
 arch/x86/kvm/svm/svm.h    |  9 +++++++++
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3f512fb630db..a7d6fc1382a7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1936,9 +1936,14 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (ret)
 		goto out_free;
 
-	if (nested_npt_enabled(svm) &&
-	    (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT))
-		svm_set_gpat(svm, kvm_state->hdr.svm.gpat);
+	if (nested_npt_enabled(svm)) {
+		if (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT) {
+			svm_set_gpat(svm, kvm_state->hdr.svm.gpat);
+		} else {
+			svm_set_gpat(svm, vcpu->arch.pat);
+			svm->nested.legacy_gpat_semantics = true;
+		}
+	}
 
 	svm->nested.force_msr_bitmap_recalc = true;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b62c32c3942d..a6a44deec82b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4239,6 +4239,8 @@ static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
 	if (to_kvm_sev_info(vcpu->kvm)->need_init)
 		return -EINVAL;
 
+	to_svm(vcpu)->nested.legacy_gpat_semantics = false;
+
 	return 1;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a0e94a2c51a1..a559cd45c8a9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -221,6 +221,13 @@ struct svm_nested_state {
 	 * on its side.
 	 */
 	bool force_msr_bitmap_recalc;
+
+	/*
+	 * Indicates that a legacy nested state was restored (without a
+	 * valid gPAT). In this mode, updates to hPAT are also applied to
+	 * gPAT, preserving the old behavior where L2 shared L1's PAT.
+	 */
+	bool legacy_gpat_semantics;
 };
 
 struct vcpu_sev_es_state {
@@ -604,6 +611,8 @@ static inline void svm_set_hpat(struct vcpu_svm *svm, u64 data)
 		if (is_guest_mode(&svm->vcpu) && !nested_npt_enabled(svm))
 			svm_set_vmcb_gpat(svm->nested.vmcb02.ptr, data);
 	}
+	if (svm->nested.legacy_gpat_semantics)
+		svm_set_gpat(svm, data);
 }
 
 static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
-- 
2.53.0.rc2.204.g2597b5adb4-goog



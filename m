Return-Path: <kvm+bounces-71559-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EI9ZETT3nGlkMQQAu9opvQ
	(envelope-from <kvm+bounces-71559-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:56:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE58180594
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:56:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6619B3136887
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D218523EA8D;
	Tue, 24 Feb 2026 00:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LljgwJk6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0968239567
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 00:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771894513; cv=none; b=Us2DHGVt89LScAAsMeE3ZFJqgBbEzZpK0keC5XKa/i2ytGH6h1Khq2qvQPBeECSvAK+ovNscIDNpyEKnkmUtruf86VyDXVhgCSboSiDgzAbt8n4tdc+LxZWi3DdUmknaSACi6byyaqMS/LfAno2i3hdBeyep4UVkxZulKOWAyfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771894513; c=relaxed/simple;
	bh=TQRcrEIl6abnDAXke8DKVdrifugyEhen44qHWS2JWko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VSQxN/D+s+1PjX51bsmTvrziC6LMm5Nzm83Kh5W5PPkgu1+CELPtFv8EqS3+xs9FbbzKaLD0rcSITkVgNsGDZMf3CyUiIbUS+NSNJUo6SYRvy0qU38vh8i/KnUWnfOVj24k4VefoVlUFTl+EpF7qfdfeYLl0PhOlBD4krlYqyj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LljgwJk6; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6dde310601so2959820a12.1
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771894511; x=1772499311; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=46KB3RR4mRrf56rBPul9rnuklFPMftSM5I4pNmsZc58=;
        b=LljgwJk6s7fQtgtV2VRhVCdo68iSoRUJeDQX3XN/Ty3re8A6yMOO9FPG1P0c06uhZB
         IbUU6QBAhAGoFyXQuwGRHR/RKdbTxCRkmdIFIaz8HLRRIuEBy4NmDlXOzSt5+reetMgk
         mQKcIO3BDa1g4OrmhIhiE+NJNVNuEvHGlvTeicrmMYBO8s70D6mf+q0Oowk4hhidUFgo
         8OK0ns9eS9ggZLFafC+JpJWOeQeRZIGqlRUvua2svE4pmD+XPLkZvnMOYrZIkU/GApZ9
         yl5f/Pmip+xPk61Th232XEMkPLN/vYMTCUT39a9nPz76wCzU7auoazorRpnZp7FSqdM4
         1JKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771894511; x=1772499311;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=46KB3RR4mRrf56rBPul9rnuklFPMftSM5I4pNmsZc58=;
        b=ns7Sh5h7tdnSGOvqc6S3mFCXcqTgTamCO1O+WvTQUaluXE52iJOgVvs+1DXOkSKIw8
         mPmkfO1v8H3zRCq8VJJ/V6EHGWoq7XbMQJ0KjpQyuajegPHXX9OrL062EUhlGSR/UR8o
         6EUfcKIYqDg32KGoxdx4LLcOBFG/DmKibjeVk5922OLonFgW/RwimCltTGr6LlScy8x4
         YKX+3POhO+2cCamRY5KykUeQQU+ogvXf5G46h/LftSz9kYyRPqZrb1yt8CRQ/gQ8g4z6
         pH3RDiZks/gmYEyaJcg7/X8xotI76ZvC9U90RulO/oyvMQbFO7QFGx/QtWnk52NwQpHj
         Ls6w==
X-Forwarded-Encrypted: i=1; AJvYcCVFbgBzlHDdWqx7VaDQApC+zatS7FrKaKpwxQ0oW72vJ/2zJLoZvHVBbx3Mm06/QqomheM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjeEU9JYnJ+rSir+8kphYOSvXPYOyRfP2MQiYc9aCE2leAVRa4
	Il2bYT/YbkShmIhPczeL42e1aULMiUOoUN8xYU9NyrDUu/1TSEQbK5adbX03osAWwTUuIgiAt3H
	gmFcvrTyz6A3YMg==
X-Received: from pgww26-n2.prod.google.com ([2002:a05:6a02:2c9a:20b0:c6d:df0e:dbb2])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6f02:b0:366:14ac:e207 with SMTP id adf61e73a8af0-39545fe3c40mr7926670637.69.1771894511049;
 Mon, 23 Feb 2026 16:55:11 -0800 (PST)
Date: Mon, 23 Feb 2026 16:54:40 -0800
In-Reply-To: <20260224005500.1471972-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
Message-ID: <20260224005500.1471972-3-jmattson@google.com>
Subject: [PATCH v5 02/10] KVM: x86: nSVM: Clear VMCB_NPT clean bit when
 updating hPAT from guest mode
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-71559-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9BE58180594
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
 arch/x86/kvm/svm/svm.h    | 6 ++++++
 3 files changed, 8 insertions(+), 3 deletions(-)

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
index be9d562fabde..6c41f2317777 100644
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
index 8f9e6a39659c..9850ed01e16e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -439,6 +439,12 @@ static inline bool vmcb12_is_dirty(struct vmcb_ctrl_area_cached *control, int bi
 	return !test_bit(bit, (unsigned long *)&control->clean);
 }
 
+static inline void vmcb_set_gpat(struct vmcb *vmcb, u64 data)
+{
+	vmcb->save.g_pat = data;
+	vmcb_mark_dirty(vmcb, VMCB_NPT);
+}
+
 static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_svm, vcpu);
-- 
2.53.0.371.g1d285c8824-goog



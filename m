Return-Path: <kvm+bounces-67816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3965FD14809
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:48:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D0D430B2917
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D60530E842;
	Mon, 12 Jan 2026 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hlbxr/0l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B66130F7F9
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239951; cv=none; b=bM3qeSOHIKVN6hxnO18SbI0I4PRMTEHBFfYTq7oPeHWlAFR2QcUYus9r6YZ1E18m/q/Gsnc1LQymlPMW3bYfnrJqJ/moOdJ/POIUZ/vZ+UxNrt74CVaBi3OFkl+fNADg0BMbKuC1JoCX8pSbmSW3csCCwzJjT6IMwEDrzqqcxY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239951; c=relaxed/simple;
	bh=SRn/8LkmaiDx4mbVxdInxzII+UnuGlGMzo2ATeYcp5o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LuKJwrotsszkDVjAHfLza0JhWw3rz+B0+eUocyrgFgttRl5Mf06T2/vZkc6euqsXYyFRXlSsqhV60qQj31w9h01y8gYGMAVG/ogscd+xwnTsCiDkFsbZaYHLSTDyQWfL2g0OKNnDlX9PNicAUqhRFYX7o2TU35K/IhX690BfgrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hlbxr/0l; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ab459c051so2755989a91.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239949; x=1768844749; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=24RTjXW0RUIu3mbeBBuCS6+SaZyDve2lWE6uRECn1KA=;
        b=hlbxr/0lTFVl0DgOiIfM25GdVIgj02xHAIkz5ckR+iawUH7LBwPrvpnhm4zpUFaIT6
         bnEMlTceM2eEQAc7VMVCORljeOWoV3OJDgbmjFkcaO6z25k8z2iOQzE2cet5Tpj+KaGl
         f4IwqErMiqfoQ+CVzDdCL5IIKRmbAeProoJ+ceqX5URbBnoM6Z2YOp0pzlCP3CbcuclI
         hFlqmiTzFtnpEOzb85PWXs0GhOwgoeq2LJeuhx43Em/KJCF49Odd7gkh8DxMulKtP14h
         yPFkIUT5pYD5jLm+ofUVviuK7URlNl41CukCmNEBmqCDUtGEK4wl7UZLR2EcYGx30Qkj
         Fsjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239949; x=1768844749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=24RTjXW0RUIu3mbeBBuCS6+SaZyDve2lWE6uRECn1KA=;
        b=caXg1kN4sP547ANBQgJEWTHGQoQNM/5zwTXvKce/k+2VajD+4ohk7MuZoh5MjdAbce
         EvJtMKl0GDRe3R2wusX++mLnJU+aGHL4bBkBS6xABZA1I6eYx13MnQky4qhsWrrXW5XA
         KuKMBFR4R+91cnN0QBmi+25+72j/kOd2F24wCFaXykYTLCw2qR68E9SN5eSkenID5A7H
         6me6xmHKrRfLcelMPtyV/K5XPo89afrPzymYbeSbeKzoFfKzfz326/qSjTubnbGcAB3p
         M489+7X/lgwc/rO+IdPwEA/G/vHbzNbbAxmeF0eMwLKmyc9oo1ffi1gsCtMEmTbksy76
         nyGQ==
X-Gm-Message-State: AOJu0YwbcCOhGHkjBNw14nTtJorqbsN7TxZ8ChxEbM7e/lWJiVjCQBO2
	vDxEZyq1T0Svyvl+8J+iYhGRtJlU81UvwwVhVDDkGP1OAkbcTsL/sKA+wU+BcO1GIEdXWGliCws
	mgKyd9Z3TO4H/EQ==
X-Google-Smtp-Source: AGHT+IHJL4gsPR2YUXI6J7F9iMrruLFSR8LmSuYPPLBbIXHlG9kM+3w07TqUZ3x+3X2RlYrnCrIw8LKbY0DrKA==
X-Received: from pjbrs15.prod.google.com ([2002:a17:90b:2b8f:b0:34a:b143:87d7])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4e:b0:330:82b1:ef76 with SMTP id 98e67ed59e1d1-34f68c62a25mr14612405a91.28.1768239948999;
 Mon, 12 Jan 2026 09:45:48 -0800 (PST)
Date: Mon, 12 Jan 2026 17:45:35 +0000
In-Reply-To: <20260112174535.3132800-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112174535.3132800-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260112174535.3132800-6-chengkev@google.com>
Subject: [PATCH V2 5/5] KVM: SVM: Raise #UD if VMMCALL instruction is not intercepted
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

The AMD APM states that if VMMCALL instruction is not intercepted, the
instruction raises a #UD exception.

Create a vmmcall exit handler that generates a #UD if a VMMCALL exit
from L2 is being handled by L0, which means that L1 did not intercept
the VMMCALL instruction.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 92a66b62cfabd..805267a5106ac 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3180,6 +3180,20 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int vmmcall_interception(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * VMMCALL #UDs if it's not intercepted, and KVM reaches this point if
+	 * and only if the VMMCALL intercept is not set in vmcb12.
+	 */
+	if (is_guest_mode(vcpu)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	return kvm_emulate_hypercall(vcpu);
+}
+
 static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -3230,7 +3244,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
 	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= vmrun_interception,
-	[SVM_EXIT_VMMCALL]			= kvm_emulate_hypercall,
+	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
 	[SVM_EXIT_VMLOAD]			= vmload_interception,
 	[SVM_EXIT_VMSAVE]			= vmsave_interception,
 	[SVM_EXIT_STGI]				= stgi_interception,
-- 
2.52.0.457.g6b5491de43-goog



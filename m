Return-Path: <kvm+bounces-15962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD0A8B2801
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:16:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71780B2311C
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1016115574B;
	Thu, 25 Apr 2024 18:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FvS8+0Sm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D731553B9
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 18:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714068881; cv=none; b=smAi5I3ZYiOnb3MxRxZfFpAxeUIwCnYckQ2n9V/jIQDWSz8GhdXmDhdDu1x3/twj6e6idaCmtvauMQwAZa42mjAnfVcU91t4WiWdm5eSP2Z5QmpaeEDiEt7fFQxuMTEhC1VEvVNaJ+LCkKnGU/qsm1WVt171wY1wcjiLHKXMOj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714068881; c=relaxed/simple;
	bh=f3EI68Y4u3S5p2Gr6qnqBE5dIZOO6y93604kqUrylvg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=On9jRuYb9WM02NTX/653VMKoYzpw54UkSvnF3vY8BfOk/08ixRjjQZlijahSEz1VADd3fZXAFL1cv7cvz6wCsTCu27mgNkZQbPe7E9RLwQs6/vuV8bAx+cEfeZNfTb/ab/7u7f5UKQiz8BAYONbLOPGZODzv5FN+G5pmGJ5VHRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FvS8+0Sm; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6ed25ed4a5fso1593343b3a.1
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 11:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714068879; x=1714673679; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1pE+NlQrWikaS0Ef4GTiz1FqV5zA81OBkfDPnBRhty0=;
        b=FvS8+0SmoLYzwsiGeENR0v0AArYVwWiqBWkMK8PMwRnH7rX8VbsplGvOKOJREIgFk0
         vGeKSK1Sey++VdAic0zhC2nqRx0aO0mTNZmn6SyRwhamGrV9ZAG56w14HK+Fug3YHNAt
         trpoJC5QeAHJRS9077CXUyo3SySFh9QBy3ZEpTNG4zTA9N/AkLKhTQggQFwjhSQsGDQ5
         3p0TZLWstppPLGcDBUsRBQ8sIystqvKGx1vJK+pwkRG+ELAcTMc1QB8KS6myqcJmgO/r
         jLXz0+Q0ceqnLESCxSEPw//oXlVXqwn77PNarj8N6nCDqW/MT7EnIi0t7wq+sS0j9B6g
         sSQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714068879; x=1714673679;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1pE+NlQrWikaS0Ef4GTiz1FqV5zA81OBkfDPnBRhty0=;
        b=VUhfy4iJbJ1zLAP4lnzY+IFBaN5PLiPXFjN3Zv9OowJ4YGXTn6ad7KMioOqbSpwg42
         AqnFZSDLjczbkDYxnYfjK1pqC1NtdNfP8gVUTZYF/eIIVe6w/brVgWErHR87geTpHboA
         VIDw3OqfW9aNebFXqw+viHiJHB6SW4bIo7lE5Amc/4IhWJ7kOlCe7tfbDBiVQ1XLbYlY
         HrhdAuBAy9sBbvAgGiHWUr+5cJyrdyxML178SBTAyrzrYmyTe39n/N5FGuAgQsMHqgto
         2hIJo3MXq2fpEH89TwQM1NLHvxei/hF2WIwDtzzWpBMGWlfR3tWWRtAqHB+UgUEB6g1Y
         JwHA==
X-Gm-Message-State: AOJu0YxZs/ZMqAIbOKP8pRxfKzROJ0m+4WhMpj4IoF+m/eWXK+emOe3J
	uXdTHKf+VyDslqawJQmXwJtSUbxQjcQPuCiJxTJCkOTKNklXWVbf4SUEdR5i7gi8FvtfZT/KgMo
	Qwg==
X-Google-Smtp-Source: AGHT+IG2E3aEmJmlQoT8edNXPRMopCObRwvdkiWT36JpsssrfVhnOfWDGtvwVqtEA/RucxPkw7Wb3EbhZ7c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3994:b0:6ea:d61b:ec8d with SMTP id
 fi20-20020a056a00399400b006ead61bec8dmr46363pfb.5.1714068879185; Thu, 25 Apr
 2024 11:14:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Apr 2024 11:14:18 -0700
In-Reply-To: <20240425181422.3250947-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425181422.3250947-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240425181422.3250947-7-seanjc@google.com>
Subject: [PATCH 06/10] KVM: x86: Refactor kvm_get_feature_msr() to avoid
 struct kvm_msr_entry
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Refactor kvm_get_feature_msr() to take the components of kvm_msr_entry as
separate parameters, along with a vCPU pointer, i.e. to give it the same
prototype as kvm_{g,s}et_msr_ignored_check().  This will allow using a
common inner helper for handling accesses to "regular" and feature MSRs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8f58181f2b6d..c0727df18e92 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1682,39 +1682,38 @@ static u64 kvm_get_arch_capabilities(void)
 	return data;
 }
 
-static int kvm_get_feature_msr(struct kvm_msr_entry *msr)
+static int kvm_get_feature_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
+			       bool host_initiated)
 {
-	switch (msr->index) {
+	WARN_ON_ONCE(!host_initiated);
+
+	switch (index) {
 	case MSR_IA32_ARCH_CAPABILITIES:
-		msr->data = kvm_get_arch_capabilities();
+		*data = kvm_get_arch_capabilities();
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
-		msr->data = kvm_caps.supported_perf_cap;
+		*data = kvm_caps.supported_perf_cap;
 		break;
 	case MSR_IA32_UCODE_REV:
-		rdmsrl_safe(msr->index, &msr->data);
+		rdmsrl_safe(index, data);
 		break;
 	default:
-		return static_call(kvm_x86_get_feature_msr)(msr->index, &msr->data);
+		return static_call(kvm_x86_get_feature_msr)(index, data);
 	}
 	return 0;
 }
 
 static int do_get_feature_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 {
-	struct kvm_msr_entry msr;
 	int r;
 
 	/* Unconditionally clear the output for simplicity */
-	msr.data = 0;
-	msr.index = index;
-	r = kvm_get_feature_msr(&msr);
+	*data = 0;
+	r = kvm_get_feature_msr(vcpu, index, data, true);
 
 	if (r == KVM_MSR_RET_UNSUPPORTED && kvm_msr_ignored_check(index, 0, false))
 		r = 0;
 
-	*data = msr.data;
-
 	return r;
 }
 
@@ -7363,11 +7362,9 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 
 static void kvm_probe_feature_msr(u32 msr_index)
 {
-	struct kvm_msr_entry msr = {
-		.index = msr_index,
-	};
+	u64 data;
 
-	if (kvm_get_feature_msr(&msr))
+	if (kvm_get_feature_msr(NULL, msr_index, &data, true))
 		return;
 
 	msr_based_features[num_msr_based_features++] = msr_index;
-- 
2.44.0.769.g3c40516874-goog



Return-Path: <kvm+bounces-39639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A065A48B7C
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 23:26:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60B3016D2FE
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 22:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AE1A280A20;
	Thu, 27 Feb 2025 22:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RCJn+y4i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB5427FE6E
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 22:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740695059; cv=none; b=Gy423NTdP4DIkEtDGYwsQswpTGsVedqy+Cbi7h7mnwZhuDO+pHzka1+FJqiPmXASIwYHxBki53MER5Af+ismg6FT26aXg9Pf8ttvnyD0xzLM0Kip2vjVsVWgzI6Z28OMJJtQT0onvWD3RhQsXmGTkNqxsP0pP3N+nJlJhB+h/50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740695059; c=relaxed/simple;
	bh=A+xW3ArMj2O0ny2rQkTwOSaqGEXJoe2ywH7RHyWWChE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RUyeFl2tmyuKIm5BxVc0oTKdQJXiNA3TKMp20MadEBSnv0zUDSqDg+awElsetFHhNJPL0XzUEGZnpakR4c9LSZQ2iotKHSc5TsxGaG0dSl5cceX9JFXjkkqlcDBoxBcevjBbJia3Z2PhE5Il1/y9fZ+rdeiZCVMTeVrjKrGfSSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RCJn+y4i; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f816a85facso3105347a91.3
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 14:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740695057; x=1741299857; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5pcq9kolZSMyw9f1FbDzVx3m1SaU12zTFrW/2ux2I3g=;
        b=RCJn+y4ib0/rZXGchCSLBIGbKENG8tmMBKn7HeuRZIpnT2AKWLohcODL/Fy409Vn3+
         iHyoDJOlTQlmZKirjh6Rv2+V+AcdCvQnIcTELfo5ofeEDdatXDIUUjewDvypIx1dTTCn
         j2g7bF+Xbx8XJIHS9r0uDcxGC/gq2ETIWFTczkXynjdhWIfmLEDlekqOKO2gpKFPwDE7
         WJaVlgqpN7C3F2MAk3O6kqH/8GrAtGG5vKmqwmfi2pTIJHiNetMB9KYTxkVCi0kBatrO
         64nVz4X+ZnKT0/ihQNJGvF8ZlXabsr4gPY/zqKndjWKL96cUYIjDDyFJXf9SEJUwZ4Ze
         2X6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740695057; x=1741299857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5pcq9kolZSMyw9f1FbDzVx3m1SaU12zTFrW/2ux2I3g=;
        b=ouM1ipTFeqUbImx6/N8m5n0vDS1Xbhb2JxPT+NDlA/K1Ee8iWbbe6P3XlHc96LNIh+
         JALjWoyIZQhcJLEA0zQiLXY/YGApnRjrSzY0TNEBnJfvZ6NS+4C4l1N+p10QI3LJQ+KO
         /VKxJhuWyivt67Fqj3pPLk8hKZRPsgX/TSBp+2OuRl5yo4MYGqGJfrp8ZvP6ELxwgtxU
         Q/+ILG7+mQ63aermDO5UGoZNbz/bYd57LxYpo3ZL2J/5XH5PicHQAuSoaXxsH2TAXqCO
         K7G2YMfZlpYO2xQoMTP/4tZn9GkA7NUcXg6wE3+BugcIpBY8cDvh0EGEj6ehzbzNCpic
         yqmA==
X-Gm-Message-State: AOJu0YzASg67ufvfX70QsTyB6sZKbVtBoQ221+hLmuI8p/tx3xM+vhBR
	WXs25go2gR9X6UaWZhMVX95L7A/MEVDfvlJ7EmxqNcvrQwzm1d5KVvOXlvnXJ6F8/pxa8raBl4z
	+uA==
X-Google-Smtp-Source: AGHT+IE/05e47U/0MoTU+fc1epyaOWAkZsyeFaOdMRg65lN/797YYJNtUm1LAMgiUsF/4RFrIxCv5qp+yow=
X-Received: from pjbpm13.prod.google.com ([2002:a17:90b:3c4d:b0:2ef:9b30:69d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3890:b0:2ee:aed2:c15c
 with SMTP id 98e67ed59e1d1-2febabf19a6mr1509906a91.28.1740695057184; Thu, 27
 Feb 2025 14:24:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 27 Feb 2025 14:24:07 -0800
In-Reply-To: <20250227222411.3490595-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227222411.3490595-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227222411.3490595-3-seanjc@google.com>
Subject: [PATCH v3 2/6] KVM: SVM: Suppress DEBUGCTL.BTF on AMD
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ravi Bangoria <ravi.bangoria@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, 
	whanos@sergal.fun
Content-Type: text/plain; charset="UTF-8"

Mark BTF as reserved in DEBUGCTL on AMD, as KVM doesn't actually support
BTF, and fully enabling BTF virtualization is non-trivial due to
interactions with the emulator, guest_debug, #DB interception, nested SVM,
etc.

Don't inject #GP if the guest attempts to set BTF, as there's no way to
communicate lack of support to the guest, and instead suppress the flag
and treat the WRMSR as (partially) unsupported.

In short, make KVM behave the same on AMD and Intel (VMX already squashes
BTF).

Note, due to other bugs in KVM's handling of DEBUGCTL, the only way BTF
has "worked" in any capacity is if the guest simultaneously enables LBRs.

Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 9 +++++++++
 arch/x86/kvm/svm/svm.h | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2280bd1d0863..b70c754686c4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3177,6 +3177,15 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 */
 		data &= ~GENMASK(5, 2);
 
+		/*
+		 * Suppress BTF as KVM doesn't virtualize BTF, but there's no
+		 * way to communicate lack of support to the guest.
+		 */
+		if (data & DEBUGCTLMSR_BTF) {
+			kvm_pr_unimpl_wrmsr(vcpu, MSR_IA32_DEBUGCTLMSR, data);
+			data &= ~DEBUGCTLMSR_BTF;
+		}
+
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f573548b7b41..798c11e755e2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -582,7 +582,7 @@ static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-#define DEBUGCTL_RESERVED_BITS (~(DEBUGCTLMSR_BTF | DEBUGCTLMSR_LBR))
+#define DEBUGCTL_RESERVED_BITS (~DEBUGCTLMSR_LBR)
 
 extern bool dump_invalid_vmcb;
 
-- 
2.48.1.711.g2feabab25a-goog



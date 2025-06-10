Return-Path: <kvm+bounces-48899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F722AD4647
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:01:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AAA927A0557
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F002D4B78;
	Tue, 10 Jun 2025 22:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JWtDkqpT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA98A2989B1
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596288; cv=none; b=IyhtkG4wf+w8IumQJn++rtLsPMnf1hG6rICp4y8ldVf+ekuyznR+S6ymV9wtNTGhnCKsZ46MLPmnYzsEgHd2uGQQXDZYIZ9qOvYdViW8KYKzddvBGZj+WWE3MrGJUrHgDxGvjdtF6ZpPsIqaLfwI1qIawp6znJmVb4s4tArpjnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596288; c=relaxed/simple;
	bh=WyvxrUW0cLAtlzKfHBSk04hVbpED9wnvZwlJrQHf/jo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FCqEyfF6jUQWjIAymLhnK9Pk3nH0eiF5+vgDFNrD08bRFz0vQn//9W75hCnPwb583sB+VjfQU6k3M+ARsae5thkmEfE7oWErAsSMmdCW3igEsGk7nQvPOeqa1dERy9EaiFrWm+FuIFtO52OS+iHxErseX2otCeXLCQSV1iLBOt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JWtDkqpT; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74834bc5d37so6009115b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596286; x=1750201086; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=L9AHHsZZFEY3JtnvHOf80Exk/6rqnszTyKb98S72dSw=;
        b=JWtDkqpTBJ7JHMLoYxdQ1/V6kAWOwHFRb/svV81P+2hiUteFa+7/yMOz2j1EtsN4F+
         PMwKw0JlQtXbrt6QXCO/5hdpZ4s8DPHUa74W5U+sacv/jVloefz5EPWIZ74iREOxJh2t
         d2Y6DigKXMa9I/6yhrYzkyZmDwhd3J3/vVkzTUEYS/Fx6hfSgO8AqhHrCrDsNpYa/Ib3
         4V3CCSJaQRQKky2DfylObE6z6rMB2UcvstfF4mbzpTarxzovYAWzrRZp1bqLNvhfTJ1W
         FddYz7WaBAu81XoYLGBBWfwIccZZSqUmHwqRYMWkN9X5djym+duREDuRAOkBKlZ6LrQa
         nw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596286; x=1750201086;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L9AHHsZZFEY3JtnvHOf80Exk/6rqnszTyKb98S72dSw=;
        b=U/Mt71J7HUFC/9gUwdbW/l74KQ3asKoLxJnWnn94zerULfoEK5DTJRlXamBt/uVMBi
         O5QuGOWRBu863VXj6FFKJGcYpIj9N/umYKraoxk/1TdpIamKpmH3lNvwJoFQYorUdqT1
         4Tr1BMDaRs6WQsn0Xvh3/TnF5cVV29Nhoeb+UmKOhjE/kIbBJ9e1QpVoi2LRx9gV/joq
         f+il5GRjc6+bNWG+EKX1V6WIz/Iud9xTgoVi3I2hqOW05vZCjTr3J/Y6Z+VkIwpwXTuF
         5PvJUM/TVKiNVihBxL5lI2+JrB9Z0zKrXyKkCBwh+SSUSXNQNCScBBVMWMh9IgUMlLnB
         rRuA==
X-Gm-Message-State: AOJu0Yx2+VeiNIs15hWhcVQqTUuF4EbgqvYlwTePX+E24XPAzpV7bDTQ
	0tWyEnzjiOYSGPoV7zP7v1yH8Q5LSEPWdaGeTHZ8/pOUCmgU8E9kGw7tjrF/b8y2ny40LMTroxG
	zEQoMWw==
X-Google-Smtp-Source: AGHT+IFia0HrIGKRFAOQayknYEgvlxifUBSRoYzh/E4Z5DYAi7waoDf+mrtMSWocIZN2sN92+TeC14KpajU=
X-Received: from pfbgq46.prod.google.com ([2002:a05:6a00:3bee:b0:747:af58:72ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:124c:b0:742:da7c:3f30
 with SMTP id d2e1a72fcca58-7486ce2a03fmr1763834b3a.19.1749596286001; Tue, 10
 Jun 2025 15:58:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:20 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-16-seanjc@google.com>
Subject: [PATCH v2 15/32] KVM: SVM: Pass through GHCB MSR if and only if VM is
 an SEV-ES guest
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Disable interception of the GHCB MSR if and only if the VM is an SEV-ES
guest.  While the exact behavior is completely undocumented in the APM,
common sense and testing on SEV-ES capable CPUs says that accesses to the
GHCB from non-SEV-ES guests will #GP.  I.e. from the guest's perspective,
no functional change intended.

Fixes: 376c6d285017 ("KVM: SVM: Provide support for SEV-ES vCPU creation/loading")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 arch/x86/kvm/svm/svm.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 74dab69fb69e..a020aa755a7e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4448,7 +4448,8 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
 
-	/* Clear intercepts on selected MSRs */
+	/* Clear intercepts on MSRs that are context switched by hardware. */
+	svm_disable_intercept_for_msr(vcpu, MSR_AMD64_SEV_ES_GHCB, MSR_TYPE_RW);
 	svm_disable_intercept_for_msr(vcpu, MSR_EFER, MSR_TYPE_RW);
 	svm_disable_intercept_for_msr(vcpu, MSR_IA32_CR_PAT, MSR_TYPE_RW);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 93d66109f495..7747f9bc3e9d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -110,7 +110,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_XSS,			.always = false },
 	{ .index = MSR_EFER,				.always = false },
 	{ .index = MSR_IA32_CR_PAT,			.always = false },
-	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = true  },
+	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = false },
 	{ .index = MSR_TSC_AUX,				.always = false },
 	{ .index = X2APIC_MSR(APIC_ID),			.always = false },
 	{ .index = X2APIC_MSR(APIC_LVR),		.always = false },
-- 
2.50.0.rc0.642.g800a2b2222-goog



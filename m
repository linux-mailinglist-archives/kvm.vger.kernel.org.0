Return-Path: <kvm+bounces-48049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8F7DAC8528
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:43:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B60CB1C00282
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52058262FD4;
	Thu, 29 May 2025 23:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ueCChZQ5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8642609E3
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562040; cv=none; b=ZIxkF/aCdSXnY41/rM46GS8LUswTkeRK66LvygHVolCkPKGAnJrDnt9m+535N27INhTc8t+uNuB6K+DnMJoH5AF/qoOcTQPIa6nE/7qXypo7Ar5NiF6O3fLFxrXHOIl+qqLc2C3U+71OyJn55fd0QNegdcmEa/WF7rnKYKX+p6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562040; c=relaxed/simple;
	bh=GnxNGrGbjnfL5nA3UyIl/gBsvF/K8aMVtAMHDs16GgU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mlTnPPSxyw3Y4nRQkSa7pv+7gbeRWuVZ7lR9b2dwpC6+ZRpoyHUTjkJpG+KhlzNomRWMACGcQX5KjPqkr5RcqfluibBuelQB4ixct1uD+sYyqU8EVknsjwFtrgHoC9E0BI533bjcHpzyVtzLkf7JEsSj+EsSTPzhp8Xaogyq3Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ueCChZQ5; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b00e4358a34so882534a12.0
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562038; x=1749166838; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/IhIB5gor13aAWenha6wShIUxZiCYleN55IHZ/J9+eU=;
        b=ueCChZQ5Z3aJx1AO2l9tNGdzGiUPOXO0eFuTCDWakpwPkWePdLMYevEoXa9IhfMo8k
         HzdpJsJNd25Vr07MkufzRgJHRcjfscc8CIY8BebAKBts1E/Eon/ImiNrqDy21/PmovcE
         eRQFw6cgtqSTGiYp7b1DMokc+SmoogCdIpFxf+9SlJV5/88v8Nt9mLjJLOzut+LVNjYZ
         +WcbtQQ9LY1KxlNPW0ErL0eBJ0XpwIL/4n796CC+ip/CkNLpbU2BE/hXureq6Z4fc1W9
         3GhlOuu3O7uOm/AS4EL1eybrLDqdZmRDdUVjYE4Myfi1omT2jLf+XdL4U/aiaPZqV+0a
         lx7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562038; x=1749166838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/IhIB5gor13aAWenha6wShIUxZiCYleN55IHZ/J9+eU=;
        b=AqFg9FmNY82XyVNFMqzo4RPSrQT5Khqx+o4waJU0dQnwT+GmmKdvQyM04Q75zZ5nzD
         tlblj+Ldj2V5SGK9ra2Wk2MlGPraXi+cQmImxs/tVvPb6GgsRx5snpYlX3pVI6Q64DR+
         UPRzxgzvHvlf/QGqe7N5DTqDne4gMiPhlM9mX8zmqmYC6MDoZRGIvfrPVqHHn1PmRS+U
         5zz+QReRWVWlTVTcfF/TrhmdElQFIf68TnQ3rScvGcnsmIan60ilQKk6+HR+QaWwwets
         Ney+VhYQXMvhH3tRB/4lFhrQot7JoNIy/jNE4SHTyYPLS2sYVj6WKIg2bzXlRTLnGw2A
         RHjQ==
X-Gm-Message-State: AOJu0YyZMCACEl1ebxb/cUnC7hoVdNt3wL23tkOyusi6tvr2ZVnGaypf
	laWBTLTLjWb9DRN4KbsYTJ60WckncY4Dvl8XvR74ZjG0qgWDOh4lYmXwEJWL0b1P5yp1D51yzn1
	m9ZO6Lg==
X-Google-Smtp-Source: AGHT+IFYE6QZgxnJog3zqb9GuS0hWNogIixhuCyNKqy3IlWubD5Z1+DlZeWI/osjf7l+9JqPdaBV7JgdcbU=
X-Received: from pjbsz6.prod.google.com ([2002:a17:90b:2d46:b0:310:f76d:7b8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3809:b0:312:18e:d930
 with SMTP id 98e67ed59e1d1-3124173be5fmr1682635a91.19.1748562038082; Thu, 29
 May 2025 16:40:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:39:58 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-14-seanjc@google.com>
Subject: [PATCH 13/28] KVM: SVM: Pass through GHCB MSR if and only if VM is an
 SEV-ES guest
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
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
index bb0ec029b3d4..694d38a2327c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4512,7 +4512,8 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
 
-	/* Clear intercepts on selected MSRs */
+	/* Clear intercepts on MSRs that are context switched by hardware. */
+	svm_disable_intercept_for_msr(vcpu, MSR_AMD64_SEV_ES_GHCB, MSR_TYPE_RW);
 	svm_disable_intercept_for_msr(vcpu, MSR_EFER, MSR_TYPE_RW);
 	svm_disable_intercept_for_msr(vcpu, MSR_IA32_CR_PAT, MSR_TYPE_RW);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 56460413eca6..fa1a1b9b2d59 100644
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
2.49.0.1204.g71687c7c1d-goog



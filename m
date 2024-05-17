Return-Path: <kvm+bounces-17654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C117F8C8B4C
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F27521C217B1
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 184A113E411;
	Fri, 17 May 2024 17:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ak8OCR8z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D867813E033
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967590; cv=none; b=fKoT1/axSxP8SEb26FIup44HA6YCHyI7SrdbQu2F3IZhReQ2bagMuLEJbvsF12NbZ1KrF8oXp1rEPXbHxUI0glnoWSH7KIgtYfojeafAGvIN4XGizR9xWDZdQaZpcELMQb32xIUx/bv9/QOpftuEHK2YHMLgdxeh8qhuGHz1VQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967590; c=relaxed/simple;
	bh=iWB5QtENwzjxwl9NGrPusJ/bteQGaP7zXO1V3IL+jq0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kS5syHoyscecH7KLNlJjkSFRg7vlPoqwFuNP+dAk1+aRba11vXG3SjGic8dxF/B8vmrilI19JG5M9gpg6lepOWxWd/3xLJu3KUF1Bhql//luL/C1o3x2VwSEIaBE5gCuzZr9zg8udvwOjTmzKBG+jMHPirZjiehwef3Y5RnYHqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ak8OCR8z; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f46acb3537so6689396b3a.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967588; x=1716572388; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OQowhrttIsi3MEiQKPEKh7tI1JSLnq5ydp67S2hRPqs=;
        b=ak8OCR8ziKeN3WV58T/5F8FUL01pZqQIgv07VHSRaU/ULPxt+f1rO2I8AGPsOJwQ+V
         yYwVbhv43qc4PGnJRE9UBh70XOftO9eRDA+/buFqsSg6ropizxD2YkYp3zE2dgevlJEq
         pOa1oM5EkKSlYWbGquZ5bhJsBYaFWam6RhA1nfQiNarRIL9T0qXSQyICT1HE06Ibk+ey
         csoujaAIMhsGmLYh8jI3jl4Kklh4jy0syHymfN4837bAZ7DYw3qCj/+zLNYSkJdUCOpY
         mpeQst5ip0YZlvEHsvv/Ap+EnvtvaQnG0dXE/oM1pRZm6JYEmJK9E9a+T4HrUrRzigrc
         CEgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967588; x=1716572388;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OQowhrttIsi3MEiQKPEKh7tI1JSLnq5ydp67S2hRPqs=;
        b=kajuhOz70AeD3d9qYTL0kqLecknJdjor44J8ZQAa+PSjZ4f0/p1OfenC61cRtRZ+QV
         9Pc+h1fh0U7Pq7KF9R3O4zJm7PyJNZyN59T0sDbvLD6uEcbKDtTwU6VD2uqd6DBTZye4
         A1JB+HD2IXtGbQoNum9wGXxcHVq3tUxfNSWzX1141qO/8gNE4VqfRnE1gBjGwxboEobi
         rIBFRjNguE8eGq1ZurE1xebGhYa3W0tgCXiwuhsEF1EfhAdZOR0tkRoKIjjPpw/Bn3Ip
         h8aGIVOaPVQ8pNoGsdgp+dzjxkmo/17LOxrExnFC5Qt+8Mm+KSe4DgYEy6RfOT1scF47
         727A==
X-Gm-Message-State: AOJu0YxGi1MNionE+0MQ/HDQpsl+tRKqFul9qlxvwryrYzoagdjgtDDm
	W2/vcdg3lLYY8xgpz8jbXhGW20MVX3BniZ/XzMIQ/2xUyryml7Tl+vmRnfUqoj544/CwZGZ2ost
	qUw==
X-Google-Smtp-Source: AGHT+IEEqCQpBHDOcsBsdckPER5qvLr8/u3pPUQwhj0LPRiks3RZPi4EtyXAYvWmxNzitzak9KlyE1dRFJs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:390d:b0:6eb:1d5:a3a with SMTP id
 d2e1a72fcca58-6f4df3b1c35mr975321b3a.1.1715967588198; Fri, 17 May 2024
 10:39:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:39 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-3-seanjc@google.com>
Subject: [PATCH v2 02/49] KVM: x86: Explicitly do runtime CPUID updates
 "after" initial setup
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly perform runtime CPUID adjustments as part of the "after set
CPUID" flow to guard against bugs where KVM consumes stale vCPU/CPUID
state during kvm_update_cpuid_runtime().  E.g. see commit 4736d85f0d18
("KVM: x86: Use actual kvm_cpuid.base for clearing KVM_FEATURE_PV_UNHALT").

Whacking each mole individually is not sustainable or robust, e.g. while
the aforemention commit fixed KVM's PV features, the same issue lurks for
Xen and Hyper-V features, Xen and Hyper-V simply don't have any runtime
features (though spoiler alert, neither should KVM).

Updating runtime features in the "full" path will also simplify adding a
snapshot of the guest's capabilities, i.e. of caching the intersection of
guest CPUID and kvm_cpu_caps (modulo a few edge cases).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2b19ff991ceb..e60ffb421e4b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -345,6 +345,8 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	bitmap_zero(vcpu->arch.governed_features.enabled,
 		    KVM_MAX_NR_GOVERNED_FEATURES);
 
+	kvm_update_cpuid_runtime(vcpu);
+
 	/*
 	 * If TDP is enabled, let the guest use GBPAGES if they're supported in
 	 * hardware.  The hardware page walker doesn't let KVM disable GBPAGES,
@@ -426,8 +428,6 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 {
 	int r;
 
-	__kvm_update_cpuid_runtime(vcpu, e2, nent);
-
 	/*
 	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
 	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
@@ -440,6 +440,15 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	 * whether the supplied CPUID data is equal to what's already set.
 	 */
 	if (kvm_vcpu_has_run(vcpu)) {
+		/*
+		 * Note, runtime CPUID updates may consume other CPUID-driven
+		 * vCPU state, e.g. KVM or Xen CPUID bases.  Updating runtime
+		 * state before full CPUID processing is functionally correct
+		 * only because any change in CPUID is disallowed, i.e. using
+		 * stale data is ok because KVM will reject the change.
+		 */
+		__kvm_update_cpuid_runtime(vcpu, e2, nent);
+
 		r = kvm_cpuid_check_equal(vcpu, e2, nent);
 		if (r)
 			return r;
-- 
2.45.0.215.g3402c0e53f-goog



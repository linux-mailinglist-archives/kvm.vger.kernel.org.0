Return-Path: <kvm+bounces-58244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4D0B8B7F6
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:38:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBA413B723D
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B372D6E4A;
	Fri, 19 Sep 2025 22:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wYW0RpDw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B77F2EAB6C
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321216; cv=none; b=VjI5mpsmzbYkofOcTTDC620WTUwz6x/5UyN0llDXVKEXZN0rXm7J+k4fARrQMp7xr+qvt3EjXGWT3PkN6JBDDfnQOe/9w6nZ39KqIdxwBEjcn2xboEdzaPZkQKntGttd0zhrUTVqo7659KgM1Rlnxsb/OZU7XjJbxwDkg9ya8eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321216; c=relaxed/simple;
	bh=3YW5ALbMTURj6Sjxs28ohmWTujGT9wqFhmPph/7ZGKQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RwCP7UkeutcLi1ixFJhSiQRv+9q0jqsuv5xCYhPo3GoUit1pZl8OSt9gY96p6sy5MLRsqYZoYqusOoxZuFY94syV+XO6c5paV6TEuPvtyosSHvuWTfb7CHXIkMYFJpwSGPds3EY7cjMS447B+lRDS/JVNN8vpmf4SyvY7Wzzkfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wYW0RpDw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee4998c50so2443191a91.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321215; x=1758926015; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HJIMM0s+CzzW0R0XC/wBPz1aR1QdnPfhwf5Eo7xoTbM=;
        b=wYW0RpDw1tXL8t9wbBmTrvgBvHnQ6ZIHDhxC1BL9SV1oTd6R8WDRLQy0CdmRhyZpZ/
         D5tNEu9XSku5IFjBfmlB3roqJitkkW3+RBgVCeIsQijch1lt6G7DGGmmIqj/5VHEu9wK
         Yn9A9mDShKLAcnf7QPpEdQcf+2z6VpRUlhBkHISxT4+Pk0nr3VbFfws37wrChQkQk3/k
         2/JsnnjkXaMrooC0JBKgwyivIyIeoVNNGWpl6C0ZX+VCG4cFgxgIYT9RZr1mOh63+6Uj
         wvUU/z3lE+/f8cZfdfipzxoJt4KjR6wDrIk2fUG43ww7R2vHNxemPck1ycC7hqO+toJ/
         9skw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321215; x=1758926015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HJIMM0s+CzzW0R0XC/wBPz1aR1QdnPfhwf5Eo7xoTbM=;
        b=VLPl2NkLz3p+6SbrzDdMTiJHhXz/pDDhuadwWYcXMZq6wYu0fHMWXAqEnewCtH7fUP
         s8hIPbVBynC/Pcf5dAjZcTVm94SOL4QuPCL/HwPBkLk9Ujdu3CpYEuUmsN4HpTPkDNmC
         Go7Ielumjs8xMGVhYFqOimF8Cf2hWbiD2v3pywxEzZAkx1Hgo3JBmvk25a4I2dW3l33n
         GBlTd4RH/8Ef7nj5ydf0X3PHbes9XqXUiZ4nbgjHSAMIntWWB6/n1vWbg7/85byNi5Br
         F5Db/eizSOfu/J2xaupuuQAtDTI7lmAho59A+Ek9iVmEDIsNqcekpEG4U9RtXYIOY/oT
         Hd9Q==
X-Gm-Message-State: AOJu0YytTD7DVMo22LdpOIoFHcasZF2KwLGfjtXPC1rj1uTl+FVEnBn/
	zY1uJ0OXqsBKIzh7ehcHJVsy2M3WvZZ7jm0MD9URZCajCJX+nG2wA4zJiINxzKz5PpT64DLOxO1
	aojgPgA==
X-Google-Smtp-Source: AGHT+IEmkGfIrnLcmS2FZ5RIyaY377eRzjxgCjRwQPOigQYkf16nzVZ88oS4j2GSL+UsWOPzsu9q0K2JV9M=
X-Received: from pjbsv5.prod.google.com ([2002:a17:90b:5385:b0:32d:a0b1:2b14])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b11:b0:32e:7270:94aa
 with SMTP id 98e67ed59e1d1-3309834e01emr6620022a91.19.1758321214681; Fri, 19
 Sep 2025 15:33:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:23 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-17-seanjc@google.com>
Subject: [PATCH v16 16/51] KVM: VMX: Set up interception for CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Disable interception for CET MSRs that can be accessed via XSAVES/XRSTORS,
and exist accordingly to CPUID, as accesses through XSTATE aren't subject
to MSR interception checks, i.e. can't be intercepted without intercepting
and emulating XSAVES/XRSTORS, and KVM doesn't support emulating
XSAVE/XRSTOR instructions.

Don't condition interception on the guest actually having XSAVES as there
is no benefit to intercepting the accesses (when the MSRs exist).  The
MSRs in question are either context switched by the CPU on VM-Enter/VM-Exit
or by KVM via XSAVES/XRSTORS (KVM requires XSAVES to virtualization SHSTK),
i.e. KVM is going to load guest values into hardware irrespective of guest
XSAVES support.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e271e3785561..5fe4a4b8efb1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4101,6 +4101,8 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 
 static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
+	bool intercept;
+
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
@@ -4146,6 +4148,23 @@ static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
 					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		intercept = !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, intercept);
+	}
+
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) || kvm_cpu_cap_has(X86_FEATURE_IBT)) {
+		intercept = !guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) &&
+			    !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, intercept);
+	}
+
 	/*
 	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
 	 * filtered by userspace.
-- 
2.51.0.470.ga7dc726c21-goog



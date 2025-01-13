Return-Path: <kvm+bounces-35322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B41CA0C250
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 21:03:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD0833A69B5
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 20:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D74EE1D5141;
	Mon, 13 Jan 2025 20:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pixZwTrs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743721CDFCE
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 20:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736798547; cv=none; b=TDCAI0gJ+CbWYNOVKqrLYWLywgTry329C9qR2tY1ZjJjoDVkrmsL91lp7dDm4hkjrpiCRgEW5uq9F+CrU8T1i71BIJJAeUApMsyUb5EnjT7o2fA2HNeREQmd3e9a+JrELbcwZSBjFDPUZWxTBf8n89P1IIlNVGLO1UoqJ5pCntM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736798547; c=relaxed/simple;
	bh=6tUCQvz9TjrZUWVa2jhKNO+tcEn/Q8cjiHQwaA3jo7E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qb45bxSFDE4Wu526a+BI0KUVYIRRoIOENQYLXEKzGyif0U/TK72z81JcQnbHEsa8Lf+E7DA+XnH4yBnsdhvEBKnm9xIoCmYDFZAbHSpY3MxzZow2R4maIwMi7BsmlCbZ1kox4m5kEnbOvkhDTG2JDNYUCnlYofGz1MTSwjM1QRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pixZwTrs; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee46799961so12207903a91.2
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 12:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736798544; x=1737403344; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yat4B4+GPlhs7xbLK2dbkAhGVvRnl7DFK3afM4k4FTA=;
        b=pixZwTrsA1WlyZUhPncDTf50t5EKC+Tm2H9/2JoUsgYJZPaNV5gh7+XswFWqkKSSEO
         5ibZHjtqZezP2CYmBm7bWIJS6Z2NbdhGbEeYJls9a24ymVd1gfVIMRTZL4fF/VcRP4vs
         74a3Vzi2n5aEoqwrBseW9wWjkXFTNOb4a8E8pRXhe/EzEZCoQBwiCn5A+CnuRwiV0wvM
         foW3XayESceU7VXuKRGxyVz9iOduzI0hBuBg9lARbPK4ROQgIEB/iPSDDBQwwImitFWE
         /n5G2jE15vERfpo2B2xWhrc7zWdepAQ9Hvi1FMPGI/PJTVQuy0HOzRnM+gSMPctRSEfQ
         /uhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736798544; x=1737403344;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yat4B4+GPlhs7xbLK2dbkAhGVvRnl7DFK3afM4k4FTA=;
        b=HPAA55J4QanVRtBrMybOZV+O+2ukEqCCPMAP4AtrwLGDFGAJmdIfPQmLplUed8w8Yo
         VVx0et/5CX8oUuEJ0gBQBJ3dhCD+5GrHnix0LS5VuOEbR0ssgJTifTD3yo61T8WhmWkh
         heb6ugci+oq+qulu9gbQ+Ww3NwksVYON7SdGWOh/XcW2INWmjawkl2bka1Bys/zastVA
         Q9odR9nHRHr6jA/MGkoHwFQKvScvow/nmeBZ2Yn784zeX9tXbqIXTfJ6Isjxrph8S15M
         B5gzAcHt3kPriGD4S0cKOXYqbW7WiJUi5qrdnZckrK+w5LnGVD3Ndu1IREUcgmgdz5Xy
         dgCA==
X-Forwarded-Encrypted: i=1; AJvYcCXUg8VV3Btp4vDYX0Cga82E0xVPZvekU20903QFNPhhlsfiHfwCb/zpVYFIkqjfUkLxw70=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmsAed7ogEJPBZFDbuI55MNx+KowDkLqwihAvdKra2JliFi0d+
	STEIqXVVsAVFy2pJKDJ761d4WkYtswd29lbtGsh5Y5o2vmdW9cIuVKxGNM83yM7ycqRMdROOpdF
	3rWZDGjJpFQ==
X-Google-Smtp-Source: AGHT+IEmWiATVThH7bgQ/hnlvDunJgeyGf7yLM6TQhUanGNHhy3W7K/gBGEus6U+L8kLklUfWVVO1PSxA30F+g==
X-Received: from pjbsg6.prod.google.com ([2002:a17:90b:5206:b0:2e9:5043:f55b])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:c2c8:b0:2ee:70cb:a500 with SMTP id 98e67ed59e1d1-2f548e9a4c9mr28634548a91.1.1736798543960;
 Mon, 13 Jan 2025 12:02:23 -0800 (PST)
Date: Mon, 13 Jan 2025 12:01:44 -0800
In-Reply-To: <20250113200150.487409-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250113200150.487409-1-jmattson@google.com>
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250113200150.487409-3-jmattson@google.com>
Subject: [PATCH 2/2] KVM: x86: Clear pv_unhalted on all transitions to KVM_MP_STATE_RUNNABLE
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, 
	Gleb Natapov <gleb@redhat.com>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, 
	Suzuki Poulose <suzuki@in.ibm.com>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

In kvm_set_mp_state(), ensure that vcpu->arch.pv.pv_unhalted is always
cleared on a transition to KVM_MP_STATE_RUNNABLE, so that the next HLT
instruction will be respected.

The "fixes" list may be incompplete.

Fixes: 6aef266c6e17 ("kvm hypervisor : Add a hypercall to KVM hypervisor to support pv-ticketlocks")
Fixes: b6b8a1451fc4 ("KVM: nVMX: Rework interception of IRQs and NMIs")
Fixes: 38c0b192bd6d ("KVM: SVM: leave halted state on vmexit")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/sev.c | 1 -
 arch/x86/kvm/x86.c     | 1 -
 arch/x86/kvm/x86.h     | 2 ++
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b4d9efd7537d..73e15e7658c2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3869,7 +3869,6 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 		svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
 
 		/* Mark the vCPU as runnable */
-		vcpu->arch.pv.pv_unhalted = false;
 		kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 
 		svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d6679df95a75..4b21ed6803c6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11207,7 +11207,6 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 	switch(vcpu->arch.mp_state) {
 	case KVM_MP_STATE_HALTED:
 	case KVM_MP_STATE_AP_RESET_HOLD:
-		vcpu->arch.pv.pv_unhalted = false;
 		kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 		fallthrough;
 	case KVM_MP_STATE_RUNNABLE:
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index bc3b5a9490c6..cc06631027bd 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -124,6 +124,8 @@ static inline bool kvm_vcpu_has_run(struct kvm_vcpu *vcpu)
 static inline void kvm_set_mp_state(struct kvm_vcpu *vcpu, int mp_state)
 {
 	vcpu->arch.mp_state = mp_state;
+	if (mp_state == KVM_MP_STATE_RUNNABLE)
+		vcpu->arch.pv.pv_unhalted = false;
 }
 
 static inline bool kvm_is_exception_pending(struct kvm_vcpu *vcpu)
-- 
2.47.1.688.g23fc6f90ad-goog



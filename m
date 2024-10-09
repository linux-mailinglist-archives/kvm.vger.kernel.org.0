Return-Path: <kvm+bounces-28300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 189B29973C7
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 918B91F26C06
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47131E230A;
	Wed,  9 Oct 2024 17:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1FjbdrPS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571A71E1C0B
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 17:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728496214; cv=none; b=qBvcr0gbsbJXILZxGyQRGed7yKfqtvBFUb7za14hCa/ikMwQUcXunr44GP8I5OHoFJLHf00hI+LpihyMV5cOTpd4Tw45TaViG+LoPc86ZyPlhAD19DkyKSOfx9dHQ1IKejxwgPFmCPz8oC/oyd0321ToCNwpqzCBukEybgYcS+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728496214; c=relaxed/simple;
	bh=MYjJ/qnOvQzH1wfa59u0Xpbj214hk83+i8Sp8cBUcZc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ETZ/u/W6Tp8Hh+VnQPEnp4p1lkc72n/N8iVT1y47wauBj1nnDKQoJKRVK9yRPA8jfYewRXD2OOyaix1/Glsq5AD2ERW/1BHoOMyzFgzz2/kASgs5VKm2ax+ztn/NhwgnxI5MZCxypwbG+wVWN4u2XQ3f9f8vD2xooIpvfJdySe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1FjbdrPS; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e22f8dc491so3281137b3.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 10:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728496212; x=1729101012; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=q5Tl19evhAY8JjScv5s5uNMaM2+262nOKyeLkvLhKQo=;
        b=1FjbdrPSsv33OnLfU0iG4wzT17yYlp1ATLd+59nfKHbCrdam3WqUkIeKABmLRLpgYb
         OCGL818jgKFSKD9JtFP6I8thtN2SMa2QLfHDSX6/xt5Qc6khKtGuvSfMKZ4Inv/nACeC
         aA4ndLMeGoOwTCHlAmWMCPlOCe1fzco/5eX1AAGB8QnXLqeKiair3FDfkYAHu1WgboBt
         1aEn3rsctbldHZy2q2f3izlukQ3fego0wJmtKB9Ud+3wK4VyjRDGcP0K3MVvAQt/nvOk
         rupNUZ4/X9SufY+ZZv1PatcpzcNUsj7x07D1Kxj0Jjx2sT/KXYAltl9PdrhHdK3CMrhj
         G+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728496212; x=1729101012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q5Tl19evhAY8JjScv5s5uNMaM2+262nOKyeLkvLhKQo=;
        b=XvxurjxydDvKO9OMDNht3V/EcN3y1j1yW9ItXjlE8UQINp6PX7+oup7lgeSQQeoAEW
         hiLSZUwRHCieBPgUifPy2HJZsC/loliimHHfZhaR8vyV4lM+nNfO/NHcSH2ffZUZvCs0
         jHLbZgfMiEmCuG5g6koxBO49dFlJIm8TOuC/YD5C8HnJFqSKHBBF7e/dCI1fWos3aiRb
         m7FMZ04PlrTN7iBvKcSuZ/U/WgGylf6gl78Abw4Ls5KL7yJ+EKrYShAz6ifgcd7HRk0S
         lPKsH5FPmGlHcjl/lM8snrw2H+Qw/wjIHnh9ihkUH2dNYR3MlPd87FHJuGfIK0wAZU+Q
         aQbA==
X-Gm-Message-State: AOJu0YxnhC0MSMHp4GL1MkzGckENpX0Oq4PdXtjJTgMt/3Ko+O1nyDpW
	4+FmM1ONhnJ5X2tYNTCtejqjRKPS+O3J+GGvSBpJvEFzNYpHL/Vjru/i1he07kWiSa69DpDr6eb
	8Cw==
X-Google-Smtp-Source: AGHT+IFMHgERYMzuO6VYoXJn+Uk/j2H+Jy1Zk5qgBHPNEHHOBCqb5nEizw0iDClpKHX0M5PlTaKe9CMJs0w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a0d:ce42:0:b0:6de:19f:34d7 with SMTP id
 00721157ae682-6e32217b753mr159347b3.2.1728496212289; Wed, 09 Oct 2024
 10:50:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 10:50:02 -0700
In-Reply-To: <20241009175002.1118178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009175002.1118178-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009175002.1118178-5-seanjc@google.com>
Subject: [PATCH v4 4/4] KVM: x86: Use '0' for guest RIP if PMI encounters
 protected guest state
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly return '0' for guest RIP when handling a PMI VM-Exit for a vCPU
with protected guest state, i.e. when KVM can't read the real RIP.  While
there is no "right" value, and profiling a protect guest is rather futile,
returning the last known RIP is worse than returning obviously "bad" data.
E.g. for SEV-ES+, the last known RIP will often point somewhere in the
guest's boot flow.

Opportunistically add WARNs to effectively assert that the in_kernel() and
get_ip() callbacks are restricted to the common PMI handler, as the return
values for the protected guest state case are largely arbitrary, i.e. only
make any sense whatsoever for PMIs, where the returned values have no
functional impact and thus don't truly matter.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 830073294640..516cf6c71567 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13213,6 +13213,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
+	WARN_ON_ONCE(!kvm_arch_pmi_in_guest(vcpu));
+
 	if (vcpu->arch.guest_state_protected)
 		return true;
 
@@ -13221,6 +13223,11 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 
 unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
 {
+	WARN_ON_ONCE(!kvm_arch_pmi_in_guest(vcpu));
+
+	if (vcpu->arch.guest_state_protected)
+		return 0;
+
 	return kvm_rip_read(vcpu);
 }
 
-- 
2.47.0.rc1.288.g06298d1525-goog



Return-Path: <kvm+bounces-32293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D349D52F8
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:58:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDCB31F23029
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 18:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C74621DF97C;
	Thu, 21 Nov 2024 18:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3Hirfohn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4B91DED59
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215210; cv=none; b=gJBzDQ8/wqlFD4/04sgzP1Poz6HrFmCGcw8xLUlolLUrJ1UQUqGDxIZqGaYe0Y//SNzQy1wvx47AP5RP8sHhwOVcbtRX8QTIRbImqQVw0sMDzLu7Rb1Oa9OaS1qj13nDvRNKIzO2EhWqDZxjX9HcoKexo5VrkAlAHFjhuykbqic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215210; c=relaxed/simple;
	bh=SxrvpTqqakO+SE1JSfeW2dZ+qSHPbHK7pKymKVP/ZXE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DkS6idNHtyNU17mEtfB5bjYXMKDx3YCRC3e7i+5r2xcbxdkDAwsK3UgDgvKJV5OMVCbDKwXcY2XVxYJZ3ldydwNtwJe2kCbpSmB/Hlu6ppQ9U1eeLw/vMcnVw2ewgAdzndNJvHvAxBabJ8ikIge7VHrEY9hwLva2zu18QLjP+f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3Hirfohn; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6eeb8aa2280so20398707b3.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215208; x=1732820008; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+b6W97BMpWzJsRkR70E8bmCkFexWmOp62HeJxz267S8=;
        b=3Hirfohnw5OR/d6y1tUuuQruToXiIzqE+NYWUoNDJQrLP2VQqsbreE68+fd9kLwfXL
         0+zqCw8gktyAgpONx00PVqaJMf5boSxD5ffnGZVDiA4/q9z6vd9vIgoEl1XItwAMIxiA
         /ZAfoQADeaal9BKGF5eqCIVJJ0FTop+qjX/LX4lqlK05SgM+YNak8KkZlSR3XYzzuKSb
         jYJ7+zU2ZVxiyMCeJiMW8z15HQceERfGfz3yWAfsAYJniFZ5J5mM5dErHDkxfPaNJ64X
         wY4tm+Cwb8kRHNKPBqX+evyLiQICl8b8eZxii43Y3ZKQ2sgNZwqxFEYxKSYMtSiRGuNK
         pb/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215208; x=1732820008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+b6W97BMpWzJsRkR70E8bmCkFexWmOp62HeJxz267S8=;
        b=MoeWh0yJKtZ7bw7ncUrMnsqW8tUdI5OMnZwL8CYyDzaJZQeYwWiWcbTsn0WnGUqyPu
         IGoQOzcWTKyPQ7PvXPkUNk+sPWfP4ZqQOv8c3GD3CTt3JUPaOdvvb9ZcKyKGIdZId+fM
         OytGiU6SFID3mA47Mqssv/NM2lTz/e4UHg5lcjbb1gzR33c1GHX4WhTi7G4dgUBGE74A
         n0/Stu6vl02GPdmzn0e1JOeOOCVEpYDaHCojylh4cD64mCsdJ55eUd8CMNYdw9qFiuRF
         Q3qigssWwJWCmDO/bouv3QWD+3CjmgbgQdJAhiUzEjiNnzfqy9rP6mzimwAqk6y4yDvP
         8Zqw==
X-Forwarded-Encrypted: i=1; AJvYcCUa8mMU5U7FuiD5OgefqEGl8KN/9rxKn1tFLdGMmLj99m0WjeQuh8ENPUIGtZbXJ4uMNiI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwPPEjVjpv9+1X0F95BfSvGWRS5tKLpLkVsH5Nee2TezNKC0/b
	xrmpd/14+4xP5rZQOV5LV/hA+O8im/ohihjZXUkFO8VbAa9rIZ1bRp7brJLoa8LAdMAg0eDI1yU
	ud9k7hg==
X-Google-Smtp-Source: AGHT+IHA/LlqfVC4cB578a8wvHBObnhD0lyB5qPv6+RAzcNl/mZXGlIBsUax3fhUb5PzQtIk0zmfwsAkpA1H
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:690c:6709:b0:6e2:1713:bdb5 with SMTP id
 00721157ae682-6eee0a39166mr21687b3.5.1732215208089; Thu, 21 Nov 2024 10:53:28
 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu, 21 Nov 2024 18:52:58 +0000
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121185315.3416855-7-mizhang@google.com>
Subject: [RFC PATCH 06/22] KVM: x86: INIT may transition from HALTED to RUNNABLE
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jim Mattson <jmattson@google.com>

When a halted vCPU is awakened by an INIT signal, it might have been
the target of a previous KVM_HC_KICK_CPU hypercall, in which case
pv_unhalted would be set. This flag should be cleared before the next
HLT instruction, as kvm_vcpu_has_events() would otherwise return true
and prevent the vCPU from entering the halt state.

Use kvm_vcpu_make_runnable() to ensure consistent handling of the
HALTED to RUNNABLE state transition.

Fixes: 6aef266c6e17 ("kvm hypervisor : Add a hypercall to KVM hypervisor to support pv-ticketlocks")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/lapic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 95c6beb8ce279..97aa634505306 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3372,9 +3372,8 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 
 	if (test_and_clear_bit(KVM_APIC_INIT, &apic->pending_events)) {
 		kvm_vcpu_reset(vcpu, true);
-		if (kvm_vcpu_is_bsp(apic->vcpu))
-			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-		else
+		kvm_vcpu_make_runnable(vcpu);
+		if (!kvm_vcpu_is_bsp(apic->vcpu))
 			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
 	}
 	if (test_and_clear_bit(KVM_APIC_SIPI, &apic->pending_events)) {
-- 
2.47.0.371.ga323438b13-goog



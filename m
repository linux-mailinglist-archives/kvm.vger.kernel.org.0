Return-Path: <kvm+bounces-21996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EADA8937E52
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 02:02:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A57C6281F19
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 00:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 844AC10A01;
	Sat, 20 Jul 2024 00:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UmX39kaO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5314C523D
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 00:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721433704; cv=none; b=faFDgKMYqmy4PVZl64A3gyAsvntFCsiYKZmdKfJMh/KScL5MP2JGYMkFf2fviQLZUpkP9KqCs6ONOQWasg52dqWLOcPlOj9dxJmcLl4nvMMH3MNEx7DlnU792ipoZ3Z+09OSvGvG+u9bG7jsFekLnSTNOegEVyYj6gBNtTaRL+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721433704; c=relaxed/simple;
	bh=oxbgJ+tn2EZ4kaxkAnXDfcMOfnefrqgznqvcIQ/o76o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O1xu0JXAakKoWZPaAiEFj3Zu19IWSWckjYKUO5W73g8wFzRLfTZoHzqHfmf72uSEO5T3xeDcaJcJZYDq7YZxwaLHQ8hqEgSe7BbmQ0YR4JG7Az3bl2Vdn4sDPbFk7PJyo2gd58Xnkknfn+x4gO6emXH3BoeDFWDyjTKQI4KEaMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UmX39kaO; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70afe6e2d7aso1204779b3a.1
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 17:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721433703; x=1722038503; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=N1R48DI4ufKXK6suvxcPHvpGEQ7ja9gHKwbShAWyxfY=;
        b=UmX39kaORfbjVF8HlImftCEHiyXdgAtlqialHc7+SsuHpc5xQegWu6mOACoFCAZbp4
         e3R3tIO37ivDAS5crWn+XtvVp2d2wPp+TbgJDp+Kus9vqfgB5NtVk57zwdNqtbbyrsKw
         a/pjhe/XSVtV2gmx7Er4RoDRXzJq1/lEa5yk2orH4LKF3nN372DPbCiHjUi4EQdb/369
         e2luLdIJRqxDg21PAkkTiw/wwFAtxJM3rPqdBIw9ksSW7M6G7CsAf4TT837QkWrNS53Y
         IhKFYX01LD2nKQRKCegBWr3QTUUseJtft2kXtL/+gCmGvpmIzy01iDn02idG9hvXHXP5
         R8bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721433703; x=1722038503;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N1R48DI4ufKXK6suvxcPHvpGEQ7ja9gHKwbShAWyxfY=;
        b=iIYzxi8Oo1k39n3T1txXhfBy9LrGW9oaLmk5u6r13OSffxWooTpEZEoNpgDC0sbaR5
         S+qAscBOF4WDWYGd1Mauj2XwjXO75bpjQhxvB3sbyk/cC+50V57E/mptT7kNddqCx+n4
         6dFKqUOa88ThqCXLBxDXEsMlkT5BeOCQkCpJtgqjDSQA+56DjQnq0E8x5Isu5LLEx3GN
         3NgkTdnSqijOlrot69Kv1ZgRsem/Wdun1kkDyhlcUu181QpHOJs0R/+Z/5vY512uC2UE
         DdPwDCgim79hXFblRMiUAuYToO349QTMhEMLuB/tD3tCydf8YDPniOJEPI3WoxHPWo9k
         ChfQ==
X-Gm-Message-State: AOJu0YwJn8yDsYgCqvE+osg+Vy+p+HtbBFuLVAFjgdlK/0OyEf3pFzlj
	SFjRfKuFqs1u2cSHXtbTW5upRimYEBchx92DaDcre8mTY4VO2cugxs1GTshHYdlv9l1qIF30t4p
	Tbg==
X-Google-Smtp-Source: AGHT+IGYGClz9nDahgh9LyCS1O0T5L/ru9OI1rUEfQwloaqtBjqd1EVZlWqGqARPLL9NMvgmBrpCxjGO+0c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2a9:b0:70b:5392:a6ef with SMTP id
 d2e1a72fcca58-70d0877dc15mr4425b3a.3.1721433702597; Fri, 19 Jul 2024 17:01:42
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 17:01:33 -0700
In-Reply-To: <20240720000138.3027780-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240720000138.3027780-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240720000138.3027780-2-seanjc@google.com>
Subject: [PATCH 1/6] KVM: nVMX: Get to-be-acknowledge IRQ for nested VM-Exit
 at injection site
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the logic to get the to-be-acknowledge IRQ for a nested VM-Exit from
nested_vmx_vmexit() to vmx_check_nested_events(), which is subtly the one
and only path where KVM invokes nested_vmx_vmexit() with
EXIT_REASON_EXTERNAL_INTERRUPT.  A future fix will perform a last-minute
check on L2's nested posted interrupt notification vector, just before
injecting a nested VM-Exit.  To handle that scenario correctly, KVM needs
to get the interrupt _before_ injecting VM-Exit, as simply querying the
highest priority interrupt, via kvm_cpu_has_interrupt(), would result in
TOCTOU bug, as a new, higher priority interrupt could arrive between
kvm_cpu_has_interrupt() and kvm_cpu_get_interrupt().

Opportunistically convert the WARN_ON() to a WARN_ON_ONCE().  If KVM has
a bug that results in a false positive from kvm_cpu_has_interrupt(),
spamming dmesg won't help the situation.

Note, nested_vmx_reflect_vmexit() can never reflect external interrupts as
they are always "wanted" by L0.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2392a7ef254d..b3e17635f7e3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4284,11 +4284,26 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	}
 
 	if (kvm_cpu_has_interrupt(vcpu) && !vmx_interrupt_blocked(vcpu)) {
+		u32 exit_intr_info;
+
 		if (block_nested_events)
 			return -EBUSY;
 		if (!nested_exit_on_intr(vcpu))
 			goto no_vmexit;
-		nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
+
+		if (nested_exit_intr_ack_set(vcpu)) {
+			int irq;
+
+			irq = kvm_cpu_get_interrupt(vcpu);
+			WARN_ON_ONCE(irq < 0);
+
+			exit_intr_info = INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR | irq;
+		} else {
+			exit_intr_info = 0;
+		}
+
+		nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT,
+				  exit_intr_info, 0);
 		return 0;
 	}
 
@@ -4969,14 +4984,6 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 	if (likely(!vmx->fail)) {
-		if ((u16)vm_exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
-		    nested_exit_intr_ack_set(vcpu)) {
-			int irq = kvm_cpu_get_interrupt(vcpu);
-			WARN_ON(irq < 0);
-			vmcs12->vm_exit_intr_info = irq |
-				INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
-		}
-
 		if (vm_exit_reason != -1)
 			trace_kvm_nested_vmexit_inject(vmcs12->vm_exit_reason,
 						       vmcs12->exit_qualification,
-- 
2.45.2.1089.g2a221341d9-goog



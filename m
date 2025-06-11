Return-Path: <kvm+bounces-49134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E63AAD618D
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF16F3ABC4A
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9767C25B2ED;
	Wed, 11 Jun 2025 21:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K23i7uht"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2257F259CA4
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677782; cv=none; b=gdMGXpbXUFC/yowJCcq7ACkNX4QzsBuaDIg3V4lYVBCxOn7SUX/+FRkfAmKHLMYwZg6wR2UW/ikG9FGwJfY+O0I0/a3MyLEHtfroGfY3Ol2ePyIcbwS4ufNHuXUUHiKpgYXtD5PPjrwOXdkaJerbu/yJ5q26TLSApQir/kbwBRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677782; c=relaxed/simple;
	bh=eMo600wYx6b04es2mg4zvb7ZJ1X3gsBg3cCmJNefs84=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZAEgCYgVRsFSmdtYPAMN4iWNPJCY0bhh/5fvUO1PlHMdVe+L0pR+gkkPFxLVeIelo8OjuhZHCUXP4VmhDqJRkqYsckedUCZtT2qvAV557mJuIB0YyXIO7atKfKRaTIvItzfdEZkZR6CMn7q2ZCTT944l33Q32rTUGDbNUxbMaqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K23i7uht; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3138e65efe2so260330a91.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677780; x=1750282580; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5FzQpJPBws5g+wsljIIo7Z5Bp6DrDU9fqIl8eG4VyGw=;
        b=K23i7uhtvUee2Hm04PJeJNl3e01MBUj+203+fGJs95Zy5MmxWKnB51IYgnV6xTBzDa
         tGVHWBLOLaKS2ClIFHffrimTQhSAi4eDkJkz4KYj4AiadjOUweqrH91RhXLWP5cKAn37
         UXK3Pfk8vTeW00G6t/8szU8I4GpjmZ8cKboBNZ41msBDnZT5QQWVzU1ytcBNrqzNzpEU
         /4ONxA8H1P2CT5vhADKLO5gvnJdIyElqWPjXaBoSj6s2tOpcBrVrl61A8QpSdeLbDYze
         1xis52dQtnjNiOYEhhfCyOSTpzq2HbBfHJ2LwFXYd7Sn/kuTIByOwAuvES6FsxdEa88x
         TjjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677780; x=1750282580;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5FzQpJPBws5g+wsljIIo7Z5Bp6DrDU9fqIl8eG4VyGw=;
        b=U6ygPvd3pdoIOrmOvj2jghYaInIrhYH3bLbWrzfx25DESwYphG4wk7nnkBrluR9Ha1
         ZcLadV3PVmQ+WOth17EoLgQa5WlOgY0o2kfFgrcMr0iN6tj+VRyHT2T9877ecBbckoOK
         /MmfZrfwlyB0HETeZdUEEoKEz69wnGZ+0qOhxPd4Jn26NtAjTtxGiB/LGV/ii0P5RPsz
         DXYrLm6+BMYZ6PSCYBO2dLNQVukE4l9FVWMDnoFl9DdHCMBiU+tSi7/ZOQXkdKu4mOOH
         wxadieQ3XN+9O4YdtCsW8vt/62XkqeQTCO2RU2I9eQbArr6due1RPDXhYd77YaxXfHyT
         WrnQ==
X-Gm-Message-State: AOJu0YzLaf8D4B3niqNLJeUfsXrShrxT86twvLG/i18GVYsJAQjx9s52
	04FRMxffSWS8QJaVeqqcdcUrYt3GjAykAOg3NNMkgB+QFVOlDw7v3RApumT0YiupBUCn6lhEGlq
	qtm2kkw==
X-Google-Smtp-Source: AGHT+IFD12JRdHUCksGhy/XcWTkonRiOG3BhyvAgj37rBTKE+EmIrEmNXmDOjjdvt8FotqXYFeSehrvQeAA=
X-Received: from pjbpl16.prod.google.com ([2002:a17:90b:2690:b0:311:e9bb:f8d4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e43:b0:312:e445:fdd5
 with SMTP id 98e67ed59e1d1-313bfbe89f9mr1322456a91.35.1749677780496; Wed, 11
 Jun 2025 14:36:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:50 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-12-seanjc@google.com>
Subject: [PATCH v2 11/18] KVM: x86: Don't clear PIT's IRQ line status when
 destroying PIT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Don't bother clearing the PIT's IRQ line status when destroying the PIT,
as userspace can't possibly rely on KVM to lower the IRQ line in any sane
use case, and it's not at all obvious that clearing the PIT's IRQ line is
correct/desirable in kvm_create_pit()'s error path.

When called from kvm_arch_pre_destroy_vm(), the entire VM is being torn
down and thus {kvm_pic,kvm_ioapic}.irq_states are unreachable.

As for the error path in kvm_create_pit(), the only way the PIT's bit in
irq_states can be set is if userspace raises the associated IRQ before
KVM_CREATE_PIT{2} completes.  Forcefully clearing the bit would clobber
userspace's input, nonsensical though that input may be.  Not to mention
that no known VMM will continue on if PIT creation fails.

Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 --
 arch/x86/kvm/i8254.c            | 10 ----------
 arch/x86/kvm/i8259.c            | 10 ----------
 arch/x86/kvm/ioapic.c           | 10 ----------
 arch/x86/kvm/ioapic.h           |  1 -
 5 files changed, 33 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c8654e461933..ebda93979179 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2207,8 +2207,6 @@ static inline int __kvm_irq_line_state(unsigned long *irq_state,
 	return !!(*irq_state);
 }
 
-void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
-
 void kvm_inject_nmi(struct kvm_vcpu *vcpu);
 int kvm_get_nr_pending_nmis(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index fa8187608cfc..d1b79b418c05 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -641,14 +641,6 @@ static void kvm_pit_reset(struct kvm_pit *pit)
 	kvm_pit_reset_reinject(pit);
 }
 
-static void kvm_pit_clear_all(struct kvm *kvm)
-{
-	mutex_lock(&kvm->irq_lock);
-	kvm_ioapic_clear_all(kvm->arch.vioapic, KVM_PIT_IRQ_SOURCE_ID);
-	kvm_pic_clear_all(kvm->arch.vpic, KVM_PIT_IRQ_SOURCE_ID);
-	mutex_unlock(&kvm->irq_lock);
-}
-
 static void pit_mask_notifer(struct kvm_irq_mask_notifier *kimn, bool mask)
 {
 	struct kvm_pit *pit = container_of(kimn, struct kvm_pit, mask_notifier);
@@ -803,7 +795,6 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	kvm_pit_set_reinject(pit, false);
 	kthread_destroy_worker(pit->worker);
 fail_kthread:
-	kvm_pit_clear_all(kvm);
 	kfree(pit);
 	return NULL;
 }
@@ -820,7 +811,6 @@ void kvm_free_pit(struct kvm *kvm)
 		kvm_pit_set_reinject(pit, false);
 		hrtimer_cancel(&pit->pit_state.timer);
 		kthread_destroy_worker(pit->worker);
-		kvm_pit_clear_all(kvm);
 		kfree(pit);
 	}
 }
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 0150aec4f523..4de055efc4ee 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -206,16 +206,6 @@ int kvm_pic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
 	return ret;
 }
 
-void kvm_pic_clear_all(struct kvm_pic *s, int irq_source_id)
-{
-	int i;
-
-	pic_lock(s);
-	for (i = 0; i < PIC_NUM_PINS; i++)
-		__clear_bit(irq_source_id, &s->irq_states[i]);
-	pic_unlock(s);
-}
-
 /*
  * acknowledge interrupt 'irq'
  */
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 8c8a8062eb19..65626da1407f 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -498,16 +498,6 @@ int kvm_ioapic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
 	return ret;
 }
 
-void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id)
-{
-	int i;
-
-	spin_lock(&ioapic->lock);
-	for (i = 0; i < KVM_IOAPIC_NUM_PINS; i++)
-		__clear_bit(irq_source_id, &ioapic->irq_states[i]);
-	spin_unlock(&ioapic->lock);
-}
-
 static void kvm_ioapic_eoi_inject_work(struct work_struct *work)
 {
 	int i;
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index 289cca3aec69..dc92bd7c37bc 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -114,7 +114,6 @@ void kvm_ioapic_destroy(struct kvm *kvm);
 int kvm_ioapic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
 		       int irq_source_id, int level, bool line_status);
 
-void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id);
 void kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
 void kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
 void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu,
-- 
2.50.0.rc1.591.g9c95f17f64-goog



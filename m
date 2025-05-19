Return-Path: <kvm+bounces-47043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5DF5ABCB71
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:30:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C55CB17A794
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073F8222582;
	Mon, 19 May 2025 23:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r/2tP6Rp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7315221FD5
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697310; cv=none; b=K6QOD/2pdprFqwmxNzziRF6UqEcCaD2UacaHoAnWTjVMCRJzzdNA8Li4LQUWVut+icjOyOyYoy+CwveF+JdpXfslu+aHzhcJBbiuTB20xSYJY4R6fYPISxaoy9mcx0IrMSL2JcGOm37CWwugxgA8tZarZeIqoEfDQKQjc+NCnCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697310; c=relaxed/simple;
	bh=EeoGiFAd9e7iVkaKUKX4cOG8l0ZAUdT5S/GdOseA0v4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PWgQHRDXyGcpBg1bABA+gtFyyc3H1Vm5GuVYzx6BpQ7Xdt2bCKEcKN4t/Y9tlkal8QUTmys960bzf4eoha7KgVNY9+KoTM5/ci/RqD4tb9AwRuFfjR066V4LVDgWA6MqTWTxheJib2oc1QLpSuRnqhrgyyoAjZurl289TR9sDCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r/2tP6Rp; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e2bd11716so4997114a91.3
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697308; x=1748302108; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=k5bXYrAobPzWNfhMoyWUANBVY5VTCDdA5KxrSZD6wWU=;
        b=r/2tP6RpFz0i88zYKgbxl8h7I+6Qk7b05Iu4Q4IirVDMMM09u+tTg5ERhgZ/GDnRPO
         DmWgfwc6vBP4aeP82AbQw7B0zUDg94Sy8zqkQwuFAc8HZCM8aF2BS9YZiNsyWor56Hl0
         ppccoCmHCd687OVd6ExgJJZw/BLE6FzFfhhW4ZkFimFwZZUdoCpQdJ2hDt6cJB2QpxCh
         mX4/UrdqhDmGSNQtJJh+e8ohj7YHgSte+Kxjln7AKwM3QDgwpiK6RZssJzJE41cGB8+W
         PfMGL5wJ99arJ9PJVnfzQ2B6+AwD5NF9TBJch1uTFqeSnF9vWPjKxL1KsygVrr0H8Ecq
         gb6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697308; x=1748302108;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k5bXYrAobPzWNfhMoyWUANBVY5VTCDdA5KxrSZD6wWU=;
        b=cwiK6s0hkmIoxznXwXYM6bWmqYqLZE/vqVF43kDbCxbGQmBubB+u/WnfUMFR9FXfrD
         4BR/jAYkzvw2eGX//mE1fYBdmzDLx2+3JExIUVlPm1qhhiTKuNPcYsNsOUFPv8pUIwWU
         NjlpwsuiOnXqVzHKH6U7IPQPlRBCL9uZw/TNWLlxQNIlBn8TUj+527zr7Zetuocscvs8
         Ok0VfdlYjEnVC26Lp45jD42Dkml8JqKwFWnJQytBWG/QHQZxhy8IcBDUEG68DsZfgGbc
         Xlba81oPLxX2bwD+Wuhk2gUi5XUjyNNPbrP5oNkJ2MBzq19VcqCP4a4Dy154S+bx5yZa
         EXjg==
X-Gm-Message-State: AOJu0YxWwMr34AW+h0jZPE75ZM+h0EKImOHBPXIbqofHfnPUiRao5jxd
	KMEBKdWkoZgyR2iFDvlhUe6sCH8l5x5AJ0623WsYpuI3yY9YnjXDHuoSxOinwMGVbi5lwJ9cY6a
	GwPc6VQ==
X-Google-Smtp-Source: AGHT+IGOVFyvbbjOcdVaDL1tDlyXnQVlPOhO3+t9xBt7HdnFXlctjkbTyTD3yxn4zuA3RoYGgNhwnpL+OcY=
X-Received: from pjbsl15.prod.google.com ([2002:a17:90b:2e0f:b0:2ea:448a:8cd1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dc2:b0:2ee:693e:ed7a
 with SMTP id 98e67ed59e1d1-30e832357d7mr20116257a91.35.1747697307921; Mon, 19
 May 2025 16:28:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:28:01 -0700
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-9-seanjc@google.com>
Subject: [PATCH 08/15] KVM: x86: Don't clear PIT's IRQ line status when
 destroying PIT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Don't bother clearing the PIT's IRQ line status when destroying the PIT,
as userspace can't possibly rely on KVM to lower the IRQ line in any sane
use case, and it's not at all obvious that clearing the PIT's IRQ line is
correct/desirable in kvm_create_pit()'s error path.

When called from kvm_arch_pre_destroy_vm(), the entire VM is being torn
down and thus {kvm_pic,kvm_ioapic}.irq_states are unreachable.

As for the error path in kvm_create_pit(), the only way the PIT's bit in
irq_states can be set is if userspace raises the associated IRQ before
KVM_CREATE_PIT{2} completes.  Forcefully clearing the bit would clobber's
userspace's input, nonsensical though that input may be.  Not to mention
that no known VMM will continue on if PIT creation fails.

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
index d4fc20c265b2..518e2e042605 100644
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
@@ -730,7 +722,6 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	kvm_pit_set_reinject(pit, false);
 	kthread_destroy_worker(pit->worker);
 fail_kthread:
-	kvm_pit_clear_all(kvm);
 	kfree(pit);
 	return NULL;
 }
@@ -747,7 +738,6 @@ void kvm_free_pit(struct kvm *kvm)
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
index dc45ea9f5b9c..7d2d47a6c2b6 100644
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
index a86f59bbea44..fee17eb201ef 100644
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
2.49.0.1101.gccaa498523-goog



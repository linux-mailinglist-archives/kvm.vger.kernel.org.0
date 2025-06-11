Return-Path: <kvm+bounces-49128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9024AD6180
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:37:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCBE33ABC52
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00EA024DD01;
	Wed, 11 Jun 2025 21:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zci8sA4z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7934924C077
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677772; cv=none; b=b1aXY1fXTPI+bXa6S+veWxGzWujiEwEJsyuldxGeqjQmIi+YISgG1fLT4XPe04sRIWRRF6s3m8Jkl1r/1d35/AfheH70AK8Tn70Sjke/Wkf0N3c1IhpIfuQyKy7/7KeO/94VYChWztfU1xHjen5bLc6d/o3/Z7nMHCCMIv2pZ7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677772; c=relaxed/simple;
	bh=b9tasPSO07AOfOTR3Fz0dQ6fZs1kO7tnUY1HpReNO4A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RoyjxWuwzGXVWWZCfPDnO2L+6/Azavm+S7M8dohn77uZWosOyX9ti5fzjgZc0XWXgNSddYLTxFmrgxu27OoU58Sfru9b49YJLa60Iwxo4wSUq9e8JcdoXY7E0lmv3jgQLzxUmSP5FhwTsmUo87fZYXHWLrMP+jUIqf1Cjw20Qpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zci8sA4z; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311f4f2e761so268618a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677770; x=1750282570; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OmXAtx1XbZt4wvNgQpXVRz2kSw/WhSsQf9sWXKV5YV8=;
        b=Zci8sA4zhpuPvOueczyPNu/9Ck1dKUAJiUrvJoiFLPGF/KalWRwhyIjomcE96Y2LcO
         40qyt4a0Q8scjBa6vyS1JeT0wZdYU2QuvSgjjbOxWXd0i2WJUlYLEUsAP2Tmaf7a1qL9
         t/5zp+3oMz2siwhioCY0HKzXVimJGPZqZAtORKCXLK2It3jLATCO79arBU4f9KGW/g2v
         acw6xRbCmr7rj4Oa3n+d2+B0n7qqsTRGTG639Hzi/LCP1rymv1aPC3kktryqsZwHGQup
         7eZeVLUE7gOlByW3kHICsEAlchqMM5pMYdS6rp2eizfpEkiFw5DbYgzRNPjaRqiNQlJO
         T7pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677770; x=1750282570;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OmXAtx1XbZt4wvNgQpXVRz2kSw/WhSsQf9sWXKV5YV8=;
        b=SxjXdFivXhAUGzKeyfnjWjaXBc0XGqhEnzBpVUYenOpNGD6kIEAirLmL/jdJJpWdtI
         Fikm8YNj6PhTYppkE3LoC7+LwC/DyzR3Qwhvv+u6AkpgQE68XfKPK0ghntO7n0lxhW0B
         MRewSXM+5QLO/QVCMNssR2yzUHjPpytitgmJz4gvjJEfdr9+Vu1pyZ3O/CtsYO1AKsmH
         EASemhCN4t+4uNqzdbQ20OTMBOWfolMyDnNXhN29bpnUs5Ay19slEUTsqqiv5YgLkft1
         Io5dwFaZUSIlovhdvhSOScpzkbkNKYciM0Ccz7bmIzTZnzUqVnznZ8RbrNypToHxsodB
         w0pA==
X-Gm-Message-State: AOJu0Yx7s4S1vSb8LqzCN7Q7XyY+WE8FGi5xe+iyCKyasUViGdQE6oyu
	7/0C1wIREx8HcxGctvNake5YxGpyJSWKNglKNTzpCWTdaOSOGWGymtkDRfsfEVD6R/IVkc1h7Te
	VG4KQpA==
X-Google-Smtp-Source: AGHT+IF1hE8qnlCTO3hu1EUZiYrbu1PsQiwZ9i46mOO0rnft1x25MlCUDTADVG/YhODZnvKIaoQLJhru1NE=
X-Received: from pjbsc6.prod.google.com ([2002:a17:90b:5106:b0:311:f699:df0a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55c6:b0:312:f650:c795
 with SMTP id 98e67ed59e1d1-313c08b05afmr823856a91.21.1749677769809; Wed, 11
 Jun 2025 14:36:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:44 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-6-seanjc@google.com>
Subject: [PATCH v2 05/18] KVM: x86: Move PIT ioctl helpers to i8254.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the PIT ioctl helpers to i8254.c, i.e. to the file that implements
PIT emulation.  Eliminating PIT code in x86.c will allow adding a Kconfig
to control support for in-kernel I/O APIC, PIC, and PIT emulation with
minimal #ifdefs.

Opportunistically make kvm_pit_set_reinject() and kvm_pit_load_count()
local to i8254.c as they were only publicly visible to make them available
to the ioctl helpers.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/i8254.c | 79 ++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/i8254.h | 12 ++++---
 arch/x86/kvm/x86.c   | 74 -----------------------------------------
 3 files changed, 84 insertions(+), 81 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 739aa6c0d0c3..59f956f35f4c 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -288,7 +288,7 @@ static inline void kvm_pit_reset_reinject(struct kvm_pit *pit)
 	atomic_set(&pit->pit_state.irq_ack, 1);
 }
 
-void kvm_pit_set_reinject(struct kvm_pit *pit, bool reinject)
+static void kvm_pit_set_reinject(struct kvm_pit *pit, bool reinject)
 {
 	struct kvm_kpit_state *ps = &pit->pit_state;
 	struct kvm *kvm = pit->kvm;
@@ -400,8 +400,8 @@ static void pit_load_count(struct kvm_pit *pit, int channel, u32 val)
 	}
 }
 
-void kvm_pit_load_count(struct kvm_pit *pit, int channel, u32 val,
-		int hpet_legacy_start)
+static void kvm_pit_load_count(struct kvm_pit *pit, int channel, u32 val,
+			       int hpet_legacy_start)
 {
 	u8 saved_mode;
 
@@ -649,6 +649,79 @@ static void pit_mask_notifer(struct kvm_irq_mask_notifier *kimn, bool mask)
 		kvm_pit_reset_reinject(pit);
 }
 
+int kvm_vm_ioctl_get_pit(struct kvm *kvm, struct kvm_pit_state *ps)
+{
+	struct kvm_kpit_state *kps = &kvm->arch.vpit->pit_state;
+
+	BUILD_BUG_ON(sizeof(*ps) != sizeof(kps->channels));
+
+	mutex_lock(&kps->lock);
+	memcpy(ps, &kps->channels, sizeof(*ps));
+	mutex_unlock(&kps->lock);
+	return 0;
+}
+
+int kvm_vm_ioctl_set_pit(struct kvm *kvm, struct kvm_pit_state *ps)
+{
+	int i;
+	struct kvm_pit *pit = kvm->arch.vpit;
+
+	mutex_lock(&pit->pit_state.lock);
+	memcpy(&pit->pit_state.channels, ps, sizeof(*ps));
+	for (i = 0; i < 3; i++)
+		kvm_pit_load_count(pit, i, ps->channels[i].count, 0);
+	mutex_unlock(&pit->pit_state.lock);
+	return 0;
+}
+
+int kvm_vm_ioctl_get_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
+{
+	mutex_lock(&kvm->arch.vpit->pit_state.lock);
+	memcpy(ps->channels, &kvm->arch.vpit->pit_state.channels,
+		sizeof(ps->channels));
+	ps->flags = kvm->arch.vpit->pit_state.flags;
+	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
+	memset(&ps->reserved, 0, sizeof(ps->reserved));
+	return 0;
+}
+
+int kvm_vm_ioctl_set_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
+{
+	int start = 0;
+	int i;
+	u32 prev_legacy, cur_legacy;
+	struct kvm_pit *pit = kvm->arch.vpit;
+
+	mutex_lock(&pit->pit_state.lock);
+	prev_legacy = pit->pit_state.flags & KVM_PIT_FLAGS_HPET_LEGACY;
+	cur_legacy = ps->flags & KVM_PIT_FLAGS_HPET_LEGACY;
+	if (!prev_legacy && cur_legacy)
+		start = 1;
+	memcpy(&pit->pit_state.channels, &ps->channels,
+	       sizeof(pit->pit_state.channels));
+	pit->pit_state.flags = ps->flags;
+	for (i = 0; i < 3; i++)
+		kvm_pit_load_count(pit, i, pit->pit_state.channels[i].count,
+				   start && i == 0);
+	mutex_unlock(&pit->pit_state.lock);
+	return 0;
+}
+
+int kvm_vm_ioctl_reinject(struct kvm *kvm, struct kvm_reinject_control *control)
+{
+	struct kvm_pit *pit = kvm->arch.vpit;
+
+	/* pit->pit_state.lock was overloaded to prevent userspace from getting
+	 * an inconsistent state after running multiple KVM_REINJECT_CONTROL
+	 * ioctls in parallel.  Use a separate lock if that ioctl isn't rare.
+	 */
+	mutex_lock(&pit->pit_state.lock);
+	kvm_pit_set_reinject(pit, control->pit_reinject);
+	mutex_unlock(&pit->pit_state.lock);
+
+	return 0;
+}
+
 static const struct kvm_io_device_ops pit_dev_ops = {
 	.read     = pit_ioport_read,
 	.write    = pit_ioport_write,
diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index a768212ba821..338095829ec8 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -6,6 +6,8 @@
 
 #include <kvm/iodev.h>
 
+#include <uapi/asm/kvm.h>
+
 struct kvm_kpit_channel_state {
 	u32 count; /* can be 65536 */
 	u16 latched_count;
@@ -55,11 +57,13 @@ struct kvm_pit {
 #define KVM_MAX_PIT_INTR_INTERVAL   HZ / 100
 #define KVM_PIT_CHANNEL_MASK	    0x3
 
+int kvm_vm_ioctl_get_pit(struct kvm *kvm, struct kvm_pit_state *ps);
+int kvm_vm_ioctl_set_pit(struct kvm *kvm, struct kvm_pit_state *ps);
+int kvm_vm_ioctl_get_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps);
+int kvm_vm_ioctl_set_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps);
+int kvm_vm_ioctl_reinject(struct kvm *kvm, struct kvm_reinject_control *control);
+
 struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags);
 void kvm_free_pit(struct kvm *kvm);
 
-void kvm_pit_load_count(struct kvm_pit *pit, int channel, u32 val,
-		int hpet_legacy_start);
-void kvm_pit_set_reinject(struct kvm_pit *pit, bool reinject);
-
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dd34a2ec854c..50e9fa57b859 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6450,80 +6450,6 @@ static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 	return r;
 }
 
-static int kvm_vm_ioctl_get_pit(struct kvm *kvm, struct kvm_pit_state *ps)
-{
-	struct kvm_kpit_state *kps = &kvm->arch.vpit->pit_state;
-
-	BUILD_BUG_ON(sizeof(*ps) != sizeof(kps->channels));
-
-	mutex_lock(&kps->lock);
-	memcpy(ps, &kps->channels, sizeof(*ps));
-	mutex_unlock(&kps->lock);
-	return 0;
-}
-
-static int kvm_vm_ioctl_set_pit(struct kvm *kvm, struct kvm_pit_state *ps)
-{
-	int i;
-	struct kvm_pit *pit = kvm->arch.vpit;
-
-	mutex_lock(&pit->pit_state.lock);
-	memcpy(&pit->pit_state.channels, ps, sizeof(*ps));
-	for (i = 0; i < 3; i++)
-		kvm_pit_load_count(pit, i, ps->channels[i].count, 0);
-	mutex_unlock(&pit->pit_state.lock);
-	return 0;
-}
-
-static int kvm_vm_ioctl_get_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
-{
-	mutex_lock(&kvm->arch.vpit->pit_state.lock);
-	memcpy(ps->channels, &kvm->arch.vpit->pit_state.channels,
-		sizeof(ps->channels));
-	ps->flags = kvm->arch.vpit->pit_state.flags;
-	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
-	memset(&ps->reserved, 0, sizeof(ps->reserved));
-	return 0;
-}
-
-static int kvm_vm_ioctl_set_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
-{
-	int start = 0;
-	int i;
-	u32 prev_legacy, cur_legacy;
-	struct kvm_pit *pit = kvm->arch.vpit;
-
-	mutex_lock(&pit->pit_state.lock);
-	prev_legacy = pit->pit_state.flags & KVM_PIT_FLAGS_HPET_LEGACY;
-	cur_legacy = ps->flags & KVM_PIT_FLAGS_HPET_LEGACY;
-	if (!prev_legacy && cur_legacy)
-		start = 1;
-	memcpy(&pit->pit_state.channels, &ps->channels,
-	       sizeof(pit->pit_state.channels));
-	pit->pit_state.flags = ps->flags;
-	for (i = 0; i < 3; i++)
-		kvm_pit_load_count(pit, i, pit->pit_state.channels[i].count,
-				   start && i == 0);
-	mutex_unlock(&pit->pit_state.lock);
-	return 0;
-}
-
-static int kvm_vm_ioctl_reinject(struct kvm *kvm,
-				 struct kvm_reinject_control *control)
-{
-	struct kvm_pit *pit = kvm->arch.vpit;
-
-	/* pit->pit_state.lock was overloaded to prevent userspace from getting
-	 * an inconsistent state after running multiple KVM_REINJECT_CONTROL
-	 * ioctls in parallel.  Use a separate lock if that ioctl isn't rare.
-	 */
-	mutex_lock(&pit->pit_state.lock);
-	kvm_pit_set_reinject(pit, control->pit_reinject);
-	mutex_unlock(&pit->pit_state.lock);
-
-	return 0;
-}
-
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog



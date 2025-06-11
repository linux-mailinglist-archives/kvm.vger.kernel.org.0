Return-Path: <kvm+bounces-49131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E5F1AD6186
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:38:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69B681E20CB
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E51F2550A4;
	Wed, 11 Jun 2025 21:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xrjHjBhB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F6E250C06
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677777; cv=none; b=KzBqaKH9FekDZl9sb789xvl9tYlwB6MmwmXVxw0WU1XFgHdg3vUI0MNayBBQ7Ep9UMDXQMEnzWk7Gcc/ByPBrvw1pZGViqhdQhfCF8zu7bQ23ByjefK0NVmc+rqqI668GNaUJXNlPYWS2d9wq/FuVEkMMYX72MlX1y9zGbnRQvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677777; c=relaxed/simple;
	bh=XorePl0mxfOcrJfGTzaPFq1U7BBsUL2+aNak2wohPm4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KrprEbQAx6/oZloqJ+qDeclGGcMFCwd4mNXKh80bsaCb90OA/Fcu1wvP/9nbA/Md5qzetgNMvsVB8Aw35XSOISgyoMK/Ox8ENavW/hbYBP/Ewy/WG1UL1owzVL2zMK4/Nws8lSsUyzwEIc8NG7j3PFBTfs5+a00e7Yu5RxbvHvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xrjHjBhB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3122368d82bso446581a91.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677773; x=1750282573; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4gDUIVx78BpW8niDMorhxWJJwZ8FKj7ZSpFaK3gGW20=;
        b=xrjHjBhB9OuZWoH14W4L+aQYZz4vNCO3yBjwtw1zxDRzptLbLUGBxUwLkm9R4Z5MhW
         stEUONlsVskkmJGWI+3Osdby+gcUVpx+bf1InMd1MVdYCbSLhnUmcfLuu3OCNR3KyaTD
         Rc+d07PszsQU++hgLwS4MQ1EjLVVFnpmkmxp4RSv//cyaMJxCNNWe0Rz8cBr6eYrgYl+
         +Yy+VajFlfz4dL8o+0+3W41ccuPVo2QcaoxNJGJWcnf4h5OyomgnWOCRMIRo3ajUE9lU
         cf94C2Kne9p9RypVAZqDUVLzIzKcnx1pqEbPZy8begexOfXOayzVJ82M/OXJ9fMbaIHp
         arRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677773; x=1750282573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4gDUIVx78BpW8niDMorhxWJJwZ8FKj7ZSpFaK3gGW20=;
        b=v+a0qxqwCN3XviV806cWRVeSD7TN2Zg2Jo2WrS17hGuskrxzQheAelgtgYYUTTUMmS
         qO1LBtEkcJAHD1cBhbNW/x+GZE31oA4xs0pioPG/EE917RmBmEVe+dbf5cAQlKAAXl24
         6jS0+Mf4V1sbW6WaMgTES75ONL6xa/eXfgBmxmzzJbxR5MCqy869DzWF4czg7rXdLuZc
         kJSCl3EYqR4Mt31ip9k/PVbgF6v6w1Hwpv93JxKtkDGPesKRnuwMSwKuUK57E8gNW/P3
         ycmSVLpNDKbCP5oUXG3WnHz2ariE4F1mhsrai/oQ0Q6f2yUnCgoohJhD+ikwK7+0jO3K
         lcKg==
X-Gm-Message-State: AOJu0Yy6VfVO3CC42kEzCka3nF8HcCZk7Wr2wUX3eHMmNYUFLBMSnnzE
	FzLdYBxUJnuIAV2rKtx5rpY52fz9Vw3ltonNgBVsOdBy0s+SCrVBnmg5aeFxZ28g+WA8mh5A5w/
	maT95jA==
X-Google-Smtp-Source: AGHT+IFxUADQqWbYA8KE1mFSsyzUwkZdB7xqcgPI+4qVwr0jLE4fnzqBJqKweobTOL2ru25CHC0FfYWl+BI=
X-Received: from pjl7.prod.google.com ([2002:a17:90b:2f87:b0:312:1dae:6bf0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:520a:b0:312:1d2d:18e2
 with SMTP id 98e67ed59e1d1-313bfbf4236mr1385761a91.20.1749677773499; Wed, 11
 Jun 2025 14:36:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:46 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-8-seanjc@google.com>
Subject: [PATCH v2 07/18] KVM: x86: Rename irqchip_kernel() to irqchip_full()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename irqchip_kernel() to irqchip_full(), as "kernel" is very ambiguous
due to the existence of split IRQ chip support, where only some of the
"irqchip" is in emulated by the kernel/KVM.  E.g. irqchip_kernel() often
gets confused with irqchip_in_kernel().

Opportunistically hoist the definition up in irq.h so that it's
co-located with other "full" irqchip code in anticipation of wrapping it
all with a Kconfig/#ifdef.

No functional change intended.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/ioapic.h   |  2 +-
 arch/x86/kvm/irq.c      |  2 +-
 arch/x86/kvm/irq.h      | 22 +++++++++++-----------
 arch/x86/kvm/irq_comm.c |  2 +-
 arch/x86/kvm/x86.c      |  4 ++--
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index a86f59bbea44..289cca3aec69 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -103,7 +103,7 @@ do {									\
 
 static inline int ioapic_in_kernel(struct kvm *kvm)
 {
-	return irqchip_kernel(kvm);
+	return irqchip_full(kvm);
 }
 
 void kvm_rtc_eoi_tracking_restore_one(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index da47e2165389..97e1617ce24d 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -172,7 +172,7 @@ bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
 {
 	bool resample = args->flags & KVM_IRQFD_FLAG_RESAMPLE;
 
-	return resample ? irqchip_kernel(kvm) : irqchip_in_kernel(kvm);
+	return resample ? irqchip_full(kvm) : irqchip_in_kernel(kvm);
 }
 
 bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index aa77a6b2828c..4ac346102350 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -69,16 +69,7 @@ int kvm_pic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
 int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip);
 int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip);
 
-static inline int irqchip_split(struct kvm *kvm)
-{
-	int mode = kvm->arch.irqchip_mode;
-
-	/* Matches smp_wmb() when setting irqchip_mode */
-	smp_rmb();
-	return mode == KVM_IRQCHIP_SPLIT;
-}
-
-static inline int irqchip_kernel(struct kvm *kvm)
+static inline int irqchip_full(struct kvm *kvm)
 {
 	int mode = kvm->arch.irqchip_mode;
 
@@ -89,7 +80,16 @@ static inline int irqchip_kernel(struct kvm *kvm)
 
 static inline int pic_in_kernel(struct kvm *kvm)
 {
-	return irqchip_kernel(kvm);
+	return irqchip_full(kvm);
+}
+
+static inline int irqchip_split(struct kvm *kvm)
+{
+	int mode = kvm->arch.irqchip_mode;
+
+	/* Matches smp_wmb() when setting irqchip_mode */
+	smp_rmb();
+	return mode == KVM_IRQCHIP_SPLIT;
 }
 
 static inline int irqchip_in_kernel(struct kvm *kvm)
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 28a8555ab58b..bcf2f1e4a005 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -200,7 +200,7 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
 		goto unlock;
 	}
 	clear_bit(irq_source_id, &kvm->arch.irq_sources_bitmap);
-	if (!irqchip_kernel(kvm))
+	if (!irqchip_full(kvm))
 		goto unlock;
 
 	kvm_ioapic_clear_all(kvm->arch.vioapic, irq_source_id);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 311a670b6652..fb7b0d301c38 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7039,7 +7039,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		}
 
 		r = -ENXIO;
-		if (!irqchip_kernel(kvm))
+		if (!irqchip_full(kvm))
 			goto get_irqchip_out;
 		r = kvm_vm_ioctl_get_irqchip(kvm, chip);
 		if (r)
@@ -7063,7 +7063,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		}
 
 		r = -ENXIO;
-		if (!irqchip_kernel(kvm))
+		if (!irqchip_full(kvm))
 			goto set_irqchip_out;
 		r = kvm_vm_ioctl_set_irqchip(kvm, chip);
 	set_irqchip_out:
-- 
2.50.0.rc1.591.g9c95f17f64-goog



Return-Path: <kvm+bounces-49125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78FB8AD617A
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:36:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD9D53AB894
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D41E9248888;
	Wed, 11 Jun 2025 21:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3A/bYdhA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0FB246BBE
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677765; cv=none; b=SRK9HItJRb1Vsy9xe/HrsI2Eo3fqcAEJhhtR2S7CbNHjzTmSCfwSDfkMg79X471yma7wGPyX+vTFWmcAwW6YNqc/Da7y4FnKUOczSOWDcwkyqhCUPTKGHrKb276Zefg4KsMxi1lXAgbUdlyAMdFnI1rfKP0Sd2lWpgJzYXBrOQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677765; c=relaxed/simple;
	bh=iBgu8VQrFAzBzHjOcFJGyC7B0S/jSUUo1LM+MQoNfPo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gb1Jd+8at2+EWqkRmmc+fPoTRq5fvtdwET5TaYEfafKAqMCZLzo+a/cUbz8+EAW+chtGPchPO6Ok87mjsJaWd4FHoazf6oDTKFAI4xAzlKyB8lBeS52uJFRnDRd16LUE+jM67rTV2qNvIOiG41Q/zJ8UiGkhE46GvHyoiyZ5yms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3A/bYdhA; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311e7337f26so216714a91.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677764; x=1750282564; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2JaUG+lAMcEA3STa8zY9dDuT6d/UMMtmtelCk9MZjcw=;
        b=3A/bYdhACcQKnBuz3GEOESY6R1kTCzsISBCZEzYCI7q1HJ8oZNrUFVW9kAhFUdEdgh
         4yP5FHcoqzGTTqeonRes721tiKK1Tmtws/YqLKj36kcpMKm+yzlrn3UIi1HNUCNb8ET5
         rP4qGHu25//zFyzg0Ctoe4zD/QuJtJGoBtZd6CHMlOyEoC8rSNkwDMQaSgVxzCEUVqPf
         JeJrZvApNFOmGGmjVQRjEB/q+/1OGZydnc8TIMNpleZ53tHcwx53S+4f2lzIriFmL+aj
         /OHThaiNRafXsGcLwO0LFXlgGEPO0vQvbNB1CJ0WKiqKDarR2DthvuX/Bz2vehw2H3Qf
         zyjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677764; x=1750282564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2JaUG+lAMcEA3STa8zY9dDuT6d/UMMtmtelCk9MZjcw=;
        b=Q8R0A9pSE+GD2JFH+nTRnpjfVhOcCVYcglZwiKH+pdZjV74p5k5svIa8V7LnPR5Y6x
         waFnUOdxft6A1QV0r/Vv7iMp89fMIbC197793IghcBQ+H+JSv/WmgCtQf8jlu/S5yB+6
         L4qF+2QwP797KY4pknW7j7W9Bwgiilmt6XqZO2yX3gp6l/LV5rdFzePfqjGyzE4kgzOx
         9n2iRinDtXxDoIqBMHLp5DxL4iaRuY3IyWk7vLVi3cyKPGpPQe2yAtjEqVYY22ovtNxH
         UsTetO6HnDbhdaeN5dgELq19yB4+tTVaGOO70uD+m9QV88E2B+4VuRKdI3KkgM68spVF
         1Kbg==
X-Gm-Message-State: AOJu0YwtVnPspIDEX+USq0JaQIY5FrINLKV8mQhDSRETZEWpdvhrRvLt
	7/xOkaj5n/sa1Kga5Hq8tgK0T5QnnBapbbxU2dWEwPsBB4EvtMh/hWgy9xEVOKcAl2Q9QI7q7Cm
	oojGBiQ==
X-Google-Smtp-Source: AGHT+IG6B6kgW6H0pxkQD+dVPNuTQyDl6CJ46+89mkFbuv65EfOtjJWPPwjiEK+h36aAz0qlZaANfNlZVDc=
X-Received: from pjbdb8.prod.google.com ([2002:a17:90a:d648:b0:30c:4b1f:78ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a4f:b0:311:f99e:7f4e
 with SMTP id 98e67ed59e1d1-313af1abc88mr7672525a91.16.1749677763697; Wed, 11
 Jun 2025 14:36:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:41 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-3-seanjc@google.com>
Subject: [PATCH v2 02/18] KVM: x86: Drop superfluous kvm_set_pic_irq() =>
 kvm_pic_set_irq() wrapper
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Drop the superfluous and confusing kvm_set_pic_irq() => kvm_pic_set_irq()
wrapper, and instead wire up ->set() directly to its final destination.

Opportunistically move the declaration kvm_pic_set_irq() to irq.h to
start gathering more of the in-kernel APIC/IO-APIC logic in irq.{c,h}.

No functional change intended.

Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/i8259.c            |  5 ++++-
 arch/x86/kvm/irq.h              |  2 ++
 arch/x86/kvm/irq_comm.c         | 10 +---------
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 330cdcbed1a6..f25ec3ec5ce4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2208,7 +2208,6 @@ static inline int __kvm_irq_line_state(unsigned long *irq_state,
 	return !!(*irq_state);
 }
 
-int kvm_pic_set_irq(struct kvm_pic *pic, int irq, int irq_source_id, int level);
 void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index a8fb19940975..0150aec4f523 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -185,8 +185,11 @@ void kvm_pic_update_irq(struct kvm_pic *s)
 	pic_unlock(s);
 }
 
-int kvm_pic_set_irq(struct kvm_pic *s, int irq, int irq_source_id, int level)
+int kvm_pic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
+		    int irq_source_id, int level, bool line_status)
 {
+	struct kvm_pic *s = kvm->arch.vpic;
+	int irq = e->irqchip.pin;
 	int ret, irq_level;
 
 	BUG_ON(irq < 0 || irq >= PIC_NUM_PINS);
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 76d46b2f41dd..33dd5666b656 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -63,6 +63,8 @@ int kvm_pic_init(struct kvm *kvm);
 void kvm_pic_destroy(struct kvm *kvm);
 int kvm_pic_read_irq(struct kvm *kvm);
 void kvm_pic_update_irq(struct kvm_pic *s);
+int kvm_pic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
+		    int irq_source_id, int level, bool line_status);
 
 static inline int irqchip_split(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index e2ae62ff9cc2..64f352e7bcb0 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -27,14 +27,6 @@
 #include "x86.h"
 #include "xen.h"
 
-static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
-			   struct kvm *kvm, int irq_source_id, int level,
-			   bool line_status)
-{
-	struct kvm_pic *pic = kvm->arch.vpic;
-	return kvm_pic_set_irq(pic, e->irqchip.pin, irq_source_id, level);
-}
-
 static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
 			      struct kvm *kvm, int irq_source_id, int level,
 			      bool line_status)
@@ -296,7 +288,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		case KVM_IRQCHIP_PIC_MASTER:
 			if (ue->u.irqchip.pin >= PIC_NUM_PINS / 2)
 				return -EINVAL;
-			e->set = kvm_set_pic_irq;
+			e->set = kvm_pic_set_irq;
 			break;
 		case KVM_IRQCHIP_IOAPIC:
 			if (ue->u.irqchip.pin >= KVM_IOAPIC_NUM_PINS)
-- 
2.50.0.rc1.591.g9c95f17f64-goog



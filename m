Return-Path: <kvm+bounces-49126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC604AD617C
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 214973A7497
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F1F6248F7A;
	Wed, 11 Jun 2025 21:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="umjqxFj8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F2C23AB94
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677767; cv=none; b=Jx5pSPx7Neqq6piMCc1rzyhr2ccawqOILfKE3H6COWCveW6LJ9Tin4NnNqGRBRjrUmRcB0uba507EgsRqijyaIygcK6cD9jvVwXlNGem5eNPGE+JZJmTQTPmHosRpNi0h3m0mnl/cStXWKgzqDXFEXCPsehjZ5x+GMcF8bO5ypw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677767; c=relaxed/simple;
	bh=sQoc0mSFqSf4AmjsbAJoaKmVVcniW3l9UwXr/qlENo8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D/+8bUqSM6NDbVVyV6dlYYYTCvY+cZeGZXth8DaBRT/DwCaQM1vSMTXfrd0fJ8zyM36Y1jiWMo8G2P0pDqy1c84LPOncd/p772/jcquZKNy6KP1FP51Be82Um3YhoqM4ZBJo2Z3q0QEZ/qqLO4ryE3pmR2QBIOpBAsXeUnuCvds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=umjqxFj8; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311f4f2e6baso283080a91.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677765; x=1750282565; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=03EsK0XCZQ7bSC/xx33gLkDKNm/oHdhWEdLJr87/zMc=;
        b=umjqxFj8xH/5UrRhciOwT3OvmX5mXzyHuDuxd3TODhCkPS/1nZnMje8n7eznVwNea/
         3ZKtQsZPr/Dei7QY2uYn42wqI4pEsXEy2xUT38pL+jwFQwwweu8tffnhvUmRB3w+0kHH
         okXLoD7tLKio1Jf815r2oOyy0fAAxTzFejmyyddLOYsioCql/UPAxwrNrZuix6yWKZVD
         2enH37jToKlTDVGv1WDGYjljX4i8CQWHM/5Szq2zlr0e+GP1fcxjosCH2cWOMKvIfdxw
         VZ8DLHmbWKvWI0uTXbz2S050zF0l2BB3ETgPcdsY57ZfMTpwqsRNI7GVuAlXV0cr0M/Z
         Ziew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677765; x=1750282565;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=03EsK0XCZQ7bSC/xx33gLkDKNm/oHdhWEdLJr87/zMc=;
        b=pqpNx19uP4BrwjUku1AzFC/PjbrfySDsZvuDoGLIpaDLy6gtz7aNOrUkESYVG3HV4o
         Dm7xCy0hS0fhHJB6P1rjhBFqAk+3mgHWwhDsX14SZJv9iuavy2j0kMl5o6xK3iOAbzgU
         ytjqo+owhfRTqaunL1BF5f7aPOyY3jSlI/Av4uNqAMk0patE6EXsZWGcqcrJh1+xJzjN
         VnGJCx8k9n8rGbsfsXxc7FSGpQi78uTWR9V0UWspZstjgPZK16nWKfWCJ+2W4snJ3mdo
         09J+7JboT8oa9OieGi2J91jutA54YC/PKxl0gI5suk/WqNuH3+7kAhF/utTSXi/MzHtN
         Og7A==
X-Gm-Message-State: AOJu0Yycw+fhqbM4ecHYIi8Cf2nDSOIFfPyPEk/vMvghi2nbdaVbzC36
	Ny2oiF4gU73d9OuNMj9z/GTUlPB3W3oAlnL7F/WkrS4lHtKhHE3oiepZ771dRGxQdre6cVMI1mh
	W+TY6Xg==
X-Google-Smtp-Source: AGHT+IENVmaNV+oSCi8pwtRJAQTeKuH5EAR+8VPfi82j/imfQfOzPW98WiMDU7ChOjR3QLEwXXUc68+xHjA=
X-Received: from pjbqi5.prod.google.com ([2002:a17:90b:2745:b0:30a:31eb:ec8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e70d:b0:311:df4b:4b8a
 with SMTP id 98e67ed59e1d1-313c068ac96mr830545a91.3.1749677765181; Wed, 11
 Jun 2025 14:36:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:42 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-4-seanjc@google.com>
Subject: [PATCH v2 03/18] KVM: x86: Drop superfluous kvm_set_ioapic_irq() =>
 kvm_ioapic_set_irq() wrapper
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Drop the superfluous and confusing kvm_set_ioapic_irq() and instead wire
up ->set() directly to its final destination.

No functional change intended.

Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/ioapic.c   |  6 ++++--
 arch/x86/kvm/ioapic.h   |  5 +++--
 arch/x86/kvm/irq_comm.c | 11 +----------
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 45dae2d5d2f1..8c8a8062eb19 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -479,9 +479,11 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
 	return ret;
 }
 
-int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
-		       int level, bool line_status)
+int kvm_ioapic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
+		       int irq_source_id, int level, bool line_status)
 {
+	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
+	int irq = e->irqchip.pin;
 	int ret, irq_level;
 
 	BUG_ON(irq < 0 || irq >= IOAPIC_NUM_PINS);
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index aa8cb4ac0479..a86f59bbea44 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -111,8 +111,9 @@ void kvm_ioapic_update_eoi(struct kvm_vcpu *vcpu, int vector,
 			int trigger_mode);
 int kvm_ioapic_init(struct kvm *kvm);
 void kvm_ioapic_destroy(struct kvm *kvm);
-int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
-		       int level, bool line_status);
+int kvm_ioapic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
+		       int irq_source_id, int level, bool line_status);
+
 void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id);
 void kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
 void kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 64f352e7bcb0..8dcb6a555902 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -27,15 +27,6 @@
 #include "x86.h"
 #include "xen.h"
 
-static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
-			      struct kvm *kvm, int irq_source_id, int level,
-			      bool line_status)
-{
-	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
-	return kvm_ioapic_set_irq(ioapic, e->irqchip.pin, irq_source_id, level,
-				line_status);
-}
-
 int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, struct dest_map *dest_map)
 {
@@ -293,7 +284,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		case KVM_IRQCHIP_IOAPIC:
 			if (ue->u.irqchip.pin >= KVM_IOAPIC_NUM_PINS)
 				return -EINVAL;
-			e->set = kvm_set_ioapic_irq;
+			e->set = kvm_ioapic_set_irq;
 			break;
 		default:
 			return -EINVAL;
-- 
2.50.0.rc1.591.g9c95f17f64-goog



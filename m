Return-Path: <kvm+bounces-47044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6E12ABCB73
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F32FC1BA0028
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67DCC2236E8;
	Mon, 19 May 2025 23:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K0U5Xyfq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B46A222561
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697311; cv=none; b=TZn0whUi67G1e0JBN3I8IE6DFAnQ7DIeEsEwdVlsPcXC7rgow0xuIEqXcNEwcifTgSjpKzPTDR1hV8X+P3HXlV0//TdW1aWFSXIVRQXwkxrwSb0uOWdVFN4Thaewk7SdlgILXtdfOUeLjWnQKJa+PKDRuXl/yAeScdaTgAqJWk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697311; c=relaxed/simple;
	bh=OPUsOxJQRGQw18S5qUhUF69GtSIfHQcNTuuAQQroEw8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dss1JQsIQ85Bvt7vAzTkmF2hkvYrV1HHy3ZNiHE5wfVQLHDz2Zsr8tzDvsoeNS4NoGEUYhnO9Pkwbr265HRDYSP0bXSCbobvQIoKZ1WicCAoncGRIpc3dM1WC2IU95oxocKhD4l2tKfDEB/EoM+HVuG2x2mf69ODA4Oev+tqsqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K0U5Xyfq; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7401179b06fso3910733b3a.1
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697309; x=1748302109; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OzpwPK/JEQxQkuGwL5Uwcgd2u1TTmwDV5SMaEASMIM8=;
        b=K0U5XyfqgHrS2d9PlpRzAfQDjGsuiEqKG5sEJZDSwrpGBKOTPlolW2ZNCjJAaesWfK
         WPv/GR4F4SSckoZ4enIKwF6RFley8RsZ7oxr7jCJtDiUMCBCa9m3VCOwxRsZa+Oyrbn8
         hr9QsW/4hgJj9B4iMtZTBEbTzIiD0sQA8JuUxOt1QhoXlLfQEoi03h266SoUOpegAFg0
         oRJCzs0Zta8fHlrEDqQ77ZPi28z4qj7/x4kQdi1NsOHhyf6TshwKehBUM88WJZn1VS/r
         OgkjmfqMaNVp3/EamztMXO7eBe4DXdGVngYK0Y9nZ3T0Mf/5vw7EqadqAnsh1WqEs+8E
         pKRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697309; x=1748302109;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OzpwPK/JEQxQkuGwL5Uwcgd2u1TTmwDV5SMaEASMIM8=;
        b=OgToFQ8DLMJkoyurssswpHSCnkMXejRFUOu3WKn+DsIrosu5y5uqyuEB+bT0WGS6Ps
         efoBDZEOLFTAAUCQ/DWKmhLcIwsdwLLTRl4GBgbQL8PoLuWAGgcqyjPPdRJufQs6SeUK
         7QzEZMJ7yrTHY65X1PS06mgPRN9cnGmGtFDWUS5fbN/1QlX58QOIXTlTuh2D3gsA+3l7
         1IyLs7++PU7kQ88eTwFmVBE7y8Z4uvFyBj1OyCq+haelrmuCGd2/zRr+MGfezr4rUqgs
         Zj3ERY53rAP8W1PXjBPcsdK/Vb1gwKNgpAEvtcOMb+JkQLMM+Xyh8yN30U9khDo3SGh8
         7rWQ==
X-Gm-Message-State: AOJu0Yw9/mK4oEs6eS3YwktH4j84B8prNkdiHbJs/hzJ+TynJJ2uilog
	FpdC+MHqw5cfu/FSsyYicghv+HIrlAo2VDOtsKTXR0LL8gyQ9fvPIvrTdnUhoc5PMeDyd5u23+P
	lxdEcUg==
X-Google-Smtp-Source: AGHT+IES8VHuEi1O9VM21YWHDIFRJ/0jkBwb+8TYaOYI0d7V6KDKgJQT1u+7T8XTP8XEgC0NqDqkFIUei3w=
X-Received: from pjyp5.prod.google.com ([2002:a17:90a:e705:b0:30e:7783:edb6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:69b:b0:1f5:7c6f:6c8a
 with SMTP id adf61e73a8af0-216219f8d9dmr22093394637.35.1747697309545; Mon, 19
 May 2025 16:28:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:28:02 -0700
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-10-seanjc@google.com>
Subject: [PATCH 09/15] KVM: x86: Explicitly check for in-kernel PIC when
 getting ExtINT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Explicitly check for an in-kernel PIC when checking for a pending ExtINT
in the PIC.  Effectively swapping the split vs. full irqchip logic will
allow guarding the in-kernel I/O APIC (and PIC) emulation with a Kconfig,
and also makes it more obvious that kvm_pic_read_irq() won't result in a
NULL pointer dereference.

Opportunistically add WARNs in the fallthrough path, mostly to document
that the userspace ExtINT logic is only relevant to split IRQ chips.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 97d68d837929..b9b9df00ab77 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -41,6 +41,14 @@ static int pending_userspace_extint(struct kvm_vcpu *v)
 	return v->arch.pending_external_vector != -1;
 }
 
+static int get_userspace_extint(struct kvm_vcpu *vcpu)
+{
+	int vector = vcpu->arch.pending_external_vector;
+
+	vcpu->arch.pending_external_vector = -1;
+	return vector;
+}
+
 /*
  * check if there is pending interrupt from
  * non-APIC source without intack.
@@ -67,10 +75,11 @@ int kvm_cpu_has_extint(struct kvm_vcpu *v)
 	if (!kvm_apic_accept_pic_intr(v))
 		return 0;
 
-	if (irqchip_split(v->kvm))
-		return pending_userspace_extint(v);
-	else
+	if (pic_in_kernel(v->kvm))
 		return v->kvm->arch.vpic->output;
+
+	WARN_ON_ONCE(!irqchip_split(v->kvm));
+	return pending_userspace_extint(v);
 }
 
 /*
@@ -126,13 +135,11 @@ int kvm_cpu_get_extint(struct kvm_vcpu *v)
 		return v->kvm->arch.xen.upcall_vector;
 #endif
 
-	if (irqchip_split(v->kvm)) {
-		int vector = v->arch.pending_external_vector;
-
-		v->arch.pending_external_vector = -1;
-		return vector;
-	} else
+	if (pic_in_kernel(v->kvm))
 		return kvm_pic_read_irq(v->kvm); /* PIC */
+
+	WARN_ON_ONCE(!irqchip_split(v->kvm));
+	return get_userspace_extint(v);
 }
 EXPORT_SYMBOL_GPL(kvm_cpu_get_extint);
 
-- 
2.49.0.1101.gccaa498523-goog



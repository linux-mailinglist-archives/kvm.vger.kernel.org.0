Return-Path: <kvm+bounces-49139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3896CAD6194
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:40:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E34C7166CA7
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C4625F98F;
	Wed, 11 Jun 2025 21:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="scnox8Tw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855BA25DCFD
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677791; cv=none; b=O6uH5HbDydw9mSuYZ8yAqsnmArLriDv6pHnTdlkAXVCuw/qnQx1AbqGsMV+/phPwz71AFK3KmS9iFpgQ3Dhb6AAxpJW5rM9cjfqXeD/fuBicd++m+wllqEQAFxCAvXCk4sOs7dRHIZVwREvjV7uNqEDnZU42HwlADArSEaSuSXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677791; c=relaxed/simple;
	bh=npPjU5eEGnuKsT0xEaMcH1B9YlxW36/8MC9u3V1VB0o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hGXXNmSqR2WQ7Tw0SVMJbYlnXQt1RaSZ9vLQu+kM3G+UhyJgoUF8ry1pBK2oU04JCN/K75Fw7oDI3Pf8Xz+JQ3PuU104jI98e6dMtGXy7Qwo424tu8Iet2+Hmwnpf/ZLn1GBr9yaPvuPPPV7S1BYivPOKmpzh5QfYAB9P/0EO8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=scnox8Tw; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747fa83d81dso224472b3a.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677789; x=1750282589; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0cQC/hkOLEWlnfZsN0A9UKbPGQtORyJ4/5SEvQ1tLM4=;
        b=scnox8TwtuU3aC+ZpJwAqGDq3SqpyrUhIa5Ek0jpx6jbytTlVMrSmUyhycqz98+UYS
         Q0ruCdOmwsxghoFTG4cuK4/mEinV5JEP72ukupZfPqpN17snCcFf9Q6eQyTa/rXrmKM9
         F9hd2YSTgK1feLZa2N2zz6Bv866iLTC+pwC1EqldR2avrNNny/mmIpYyZqwf9ieFaoKp
         QUhedXefmTbHdd+EN4r+ruh3wpse2SJXLsk0e/9Z2pwvSKymzFuugeOQ8vC9UBlGrfdg
         Dq5MQ9ZoMWUztrTqNt8fImcVxPHn/Gke0u8Tg0pOG/xnBGQFwIiuAp+SkbSSO7zvtYdq
         JCmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677789; x=1750282589;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0cQC/hkOLEWlnfZsN0A9UKbPGQtORyJ4/5SEvQ1tLM4=;
        b=VpdVgPwxX9ZEwrxf7vWHms/snplPvuJUofp5kbNl0R0IdRIaivrfXvjKvE0GBjVXaV
         CY43bIVwWd2kTc9deCvB5G2CNwXvoHs3AyPI0DbAn/Pg9gYq7+dvPwufZHwwHNdbCPHy
         yp05fDYkh8NUv+t+bM4xkC9amOccAhswYl3sKidXuI6qZsc/wQtOjRNvzQpInDe6go02
         qAcdPlf86i+qbzm5Mdu68rbvZ7JL22m3aQ/Tvy3pEP2WCBknnKdNAgqaUCc6mLcvgsmN
         6BPtVAV3sGLuYfbPU5uDZQ1P6uHc84HztWEsENh12rmxYwYN6AJE6dIwjHxpup+rtW7W
         RRLQ==
X-Gm-Message-State: AOJu0YzelYfV/TCOfrbuAKC9MPAT78PeuC6eufYU5dfjsB9r/+GRZRJJ
	mY/HIGOyjsHr5HHGBrRYDtd054G0oDoAcxx+wk80BgRFOBVH+WrZZ1KJUQ80m84ApfE1VVBDtNk
	ER+9uDw==
X-Google-Smtp-Source: AGHT+IHKomR4o60NTzsrusMmg+bCGTRAszO7F/K0fCz4Tv+qh1wlC/LNy7j0ZhMaZ9VffDciXgTipqOz6Do=
X-Received: from pgls10.prod.google.com ([2002:a63:524a:0:b0:b2e:beba:356])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:729e:b0:204:695f:47e1
 with SMTP id adf61e73a8af0-21f978a5ca6mr1864502637.23.1749677788807; Wed, 11
 Jun 2025 14:36:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:55 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-17-seanjc@google.com>
Subject: [PATCH v2 16/18] KVM: selftests: Fall back to split IRQ chip if full
 in-kernel chip is unsupported
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM x86 allows compiling out support for in-kernel I/O APIC (and
PIC and PIT) emulation, i.e. allows disabling KVM_CREATE_IRQCHIP for all
intents and purposes, fall back to a split IRQ chip for x86 if creating
the full in-kernel version fails with ENOTTY.

Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a055343a7bf7..93a921deeb99 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1716,7 +1716,18 @@ void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa)
 /* Create an interrupt controller chip for the specified VM. */
 void vm_create_irqchip(struct kvm_vm *vm)
 {
-	vm_ioctl(vm, KVM_CREATE_IRQCHIP, NULL);
+	int r;
+
+	/*
+	 * Allocate a fully in-kernel IRQ chip by default, but fall back to a
+	 * split model (x86 only) if that fails (KVM x86 allows compiling out
+	 * support for KVM_CREATE_IRQCHIP).
+	 */
+	r = __vm_ioctl(vm, KVM_CREATE_IRQCHIP, NULL);
+	if (r && errno == ENOTTY && kvm_has_cap(KVM_CAP_SPLIT_IRQCHIP))
+		vm_enable_cap(vm, KVM_CAP_SPLIT_IRQCHIP, 24);
+	else
+		TEST_ASSERT_VM_VCPU_IOCTL(!r, KVM_CREATE_IRQCHIP, r, vm);
 
 	vm->has_irqchip = true;
 }
-- 
2.50.0.rc1.591.g9c95f17f64-goog



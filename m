Return-Path: <kvm+bounces-61519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CB25C21D8B
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 19:58:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FFAE1A654CA
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 18:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFA85374ACB;
	Thu, 30 Oct 2025 18:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LQPBLkT8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6759136E372
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 18:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761850690; cv=none; b=J4iGRZ0qMhdsTV813gZfyM2dAiBHXlEHJKXyGZMP1G6fQ93q4Tjf3rTf5/oyISlLdyrhvCP3S6Om4KmXqaPMalW09uPbAZcnzsaFnfU8Gr3EkS361TwhV+D29HW+nx5dp5I8rdoKkbQF5NX00beV16RXYqQ5gwcl4py9knhjR48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761850690; c=relaxed/simple;
	bh=gBhNaafHCGkv+teWASnFAg94iaqRXR4iTaEf314TGQw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SlrA0mcnyAycBxLnkD8c2dr7F0bFg5AeswSExs1QRSHI/bH477wgKgEhdtQ2c4Rt8NDRp1lFKYXtufPsnDNmykuy8bRqrTM8aZHStKMQZvscqsKwRBi7FGuSnnZl1m+wN6qcFTCO9eRLKva0+kvsPmSyJf9F9nXSEEg/zd1i47c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LQPBLkT8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3307af9b55eso1145283a91.2
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 11:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761850689; x=1762455489; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qjjFGFuC/i6bzqqoHJlMMUDjmHoXRQt84ZbrHXQbM7E=;
        b=LQPBLkT8c6jyvVF8kl6ZrFKLa10FxnfExScmvv5+4wHCaF6AhmDdoKtF/VIDvRtOA6
         oU7dYehrggI/nRpzM7ZGCSs5rcTUcPQW9ZqQpOY1q4Julu7zQSJSxFehFM0M9UwWTapS
         u/vojPEYROc5PWdT/C7KTTZK+Fs5TkKoWMMAgWUwmSI2IYgIrz3Dr9CFGrykJxWj0BQN
         5moCdCMtzCR3rK7AJiBwzdHDxtJS8hbXOcZheCVEbdiqg8MLH1DfIi6QkqcCpoqU02qT
         uUR9F//oYIBJZm9LaqGKFHrXaq0DjYZ7BIocag+Ln+2xu7jha6ggeTlQXNkyfRTMP4p/
         0tEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761850689; x=1762455489;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qjjFGFuC/i6bzqqoHJlMMUDjmHoXRQt84ZbrHXQbM7E=;
        b=o5HuP2/jyQVV0tBgtKM5DKdm0+ckCoej381OyGc8qxXPjUNRzlgWmVMVrzCAbV4/EP
         m22Ha0Ynj72pAhFz9dSpKmq5BSh0VBJn/ysza3dUzJkCsZYJy2EKHZhZHp2c8VCuD/zJ
         wm8uLc6bRWFCs7DSyKnYryq5QgMxi0PAwrnAD8yieIoCnV6zkVTLd4/HNyHOMaETC9sz
         ve+2YuaMfB1YKUr5gcZ8uNSXijMzWgJJqNQVkOAgzc+Q2AmMwLUnObMKUBnma6YBa8/l
         u4is+gYwCRAnLf3P/o+RAHxvkfOhcjBQAGHklpJVSgdCj2t13ogQajP9pAdgCsxQUe3+
         jD+Q==
X-Gm-Message-State: AOJu0YzwXmxyNX8nmzZzRvz3QRX12YBv4tNuyMY4SL+uga4129mc0roP
	iqrM3B0iiVWwtXVq3FrOte0efAzyGj7Hi4NXx/rLpzyOYP55MVj+YZjFRRCflw+GkBs9OIrreEk
	5pN/ZXQ==
X-Google-Smtp-Source: AGHT+IEKgvy0wUgCv5T8CNLcmWcQSEO5ENvBe1HV5y63XOGG6rep4wBvG0goTUcSpE7EICJuck+LW8gP5+Y=
X-Received: from pjbqd11.prod.google.com ([2002:a17:90b:3ccb:b0:339:ae3b:2bc7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:134e:b0:33b:dec9:d9aa
 with SMTP id 98e67ed59e1d1-3408308c667mr906032a91.25.1761850688619; Thu, 30
 Oct 2025 11:58:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 11:58:02 -0700
In-Reply-To: <20251030185802.3375059-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030185802.3375059-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030185802.3375059-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: x86: Harden KVM against imbalanced load/put of guest
 FPU state
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"

Assert, via KVM_BUG_ON(), that guest FPU state isn't/is in use when
loading/putting the FPU to help detect KVM bugs without needing an assist
from KASAN.  If an imbalanced load/put is detected, skip the redundant
load/put to avoid clobbering guest state and/or crashing the host.

Note, kvm_access_xstate_msr() already provides a similar assertion.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d1e048d14e88..67e5f735adf2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11807,6 +11807,9 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 /* Swap (qemu) user FPU context for the guest FPU context. */
 static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
+	if (KVM_BUG_ON(vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm))
+		return;
+
 	/* Exclude PKRU, it's restored separately immediately after VM-Exit. */
 	fpu_swap_kvm_fpstate(&vcpu->arch.guest_fpu, true);
 	trace_kvm_fpu(1);
@@ -11815,6 +11818,9 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 /* When vcpu_run ends, restore user space FPU context. */
 static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 {
+	if (KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm))
+		return;
+
 	fpu_swap_kvm_fpstate(&vcpu->arch.guest_fpu, false);
 	++vcpu->stat.fpu_reload;
 	trace_kvm_fpu(0);
-- 
2.51.1.930.gacf6e81ea2-goog



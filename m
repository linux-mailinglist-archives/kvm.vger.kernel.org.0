Return-Path: <kvm+bounces-54041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0C35B1BAA5
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 21:08:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9C1172010B
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 19:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F3C32BD5AF;
	Tue,  5 Aug 2025 19:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A5qUfrX9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314182BCF5C
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 19:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754420746; cv=none; b=bbKMqkW23WF4pjQHaHZsVhOnVTkURmV0mVPkvOTQvKAZg3jgQBsUscvQtZfc5eVbhsOZ7tg2WYm1tJ4I3UHG3v8Q61qCS9YjSyupfk+eUpsJTn4MxeBEyeSC2OlulyAD8TU4V7BUgON02NrGJTrHIP9yA/pcXd6tmmHAwOhL5xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754420746; c=relaxed/simple;
	bh=ATOJWurILJ+pXvAy7vgZb2du/uRW5OngKfJEtQ9MjgE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cWKC6Q7UwJX9JrTV0E17Sln96DkoPUsmjV1LFhEQw7WcqXVGtAeOpAzyOqcMeJ6NzFxV54tjpfjFloHufSBupe0vWuXRJsIhz9p8Qc+Pm7s35euw2TAW2CyiM/af9EtJM5OOZeNCd2Cpw2J6ntm4TB11w7CVbDC8J9nr0me/6q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A5qUfrX9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ecb3a3d0aso5485896a91.3
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 12:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754420743; x=1755025543; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fXcZGtwr18gSNfbGq/ApRRZ2cGpCSejOkegwkd2RB7g=;
        b=A5qUfrX9p8W5M2MMDCKietvNz9pH4MYXTCrKsz3zFzXI2DeY3E0wnplRn7A3LM8VP8
         XYF7Wr/HBKbgYr6LOaSarsjoP8BkbjIK9ZplauyILn4ZGmZrP0lcdnaE7fVnqkL3EkG+
         PC1yc8x6EX3fYKkKQwSIQGTsHAJ22oy8+cGJHEWxTm05Hn/F+J8NhA7+Hi9nHCMWq+IR
         e+/5/hSC0KVXlq5U0Wkajan1p9vU+HI5okyPrV6PYzhqyIT08XHhnkBE947jidGTCDV5
         iILU6z4VVEDvgoophv7olhAK1gkzNlziC7hJpmawAbmjVubFjF7aICe0ZiptQIZONAVN
         QEgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754420743; x=1755025543;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fXcZGtwr18gSNfbGq/ApRRZ2cGpCSejOkegwkd2RB7g=;
        b=BBc0PG4sPzIS5ndHnez2nPkHc9Ru4uyawm525SY4xYnf/Nl/x6GAs7CgoLdXQVqdYk
         HNaQ30t5US5Kc1p06CID5mfiWSR+CUjSijEtAaQfBU4B9BmZV4VPqCwNqFhjkkVO3nxn
         9dlLOSOnoN/YQCyzZVutn7FTTziG+mknSXndPwTd25whYlIaRb1wBcl2plC/IpdTZBf9
         LvszWYXBf8D9lw2DpcURDDk5qGCc32Clkx//VdT+8NqGQdzSAGnE8EZrSg5Egc2RIVE0
         Nqmj2G5PETd6fzuo9+aiV3sfgiBFvCImuNQzWDR64aqxd5a9pdaV3sJjdlgm0zAanlgq
         FF2g==
X-Gm-Message-State: AOJu0YzYjdpxPSf0ku6w7ZWHJQ8vWQ+lwTRxIuiwB3wn4kJiIXTUIoiD
	0mjOwYttxJquzvqB6J5e4qrNov7C47sBUK0XOCxIp+0GyVkMwpuzK5cJFOJbEnaBvQK6IH1baWH
	Kkg7TrA==
X-Google-Smtp-Source: AGHT+IFzn/biQe1Qxm6XvedDBvzagTRf5b39R3idgrE1MR4qbj1/mKxMhU5L7MOTzCIbn6eqqm8/r77blPw=
X-Received: from pjbli2.prod.google.com ([2002:a17:90b:48c2:b0:2ff:6132:8710])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1346:b0:31f:9114:ead8
 with SMTP id 98e67ed59e1d1-321161dd744mr21743989a91.6.1754420743452; Tue, 05
 Aug 2025 12:05:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 12:05:16 -0700
In-Reply-To: <20250805190526.1453366-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805190526.1453366-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805190526.1453366-9-seanjc@google.com>
Subject: [PATCH 08/18] KVM: x86: Fold WRMSR fastpath helpers into the main handler
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"

Fold the per-MSR WRMSR fastpath helpers into the main handler now that the
IPI path in particular is relatively tiny.  In addition to eliminating a
decent amount of boilerplate, this removes the ugly -errno/1/0 => bool
conversion (which is "necessitated" by kvm_x2apic_icr_write_fast()).

Opportunistically drop the comment about IPIs, as the purpose of the
fastpath is hopefully self-evident, and _if_ it needs more documentation,
the documentation (and rules!) should be placed in a more central location.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 34 +++++-----------------------------
 1 file changed, 5 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e6c221f9b92e..a4441f036929 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2133,48 +2133,24 @@ static inline bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
 	       kvm_request_pending(vcpu) || xfer_to_guest_mode_work_pending();
 }
 
-/*
- * The fast path for frequent and performance sensitive wrmsr emulation,
- * i.e. the sending of IPI, sending IPI early in the VM-Exit flow reduces
- * the latency of virtual IPI by avoiding the expensive bits of transitioning
- * from guest to host, e.g. reacquiring KVM's SRCU lock. In contrast to the
- * other cases which must be called after interrupts are enabled on the host.
- */
-static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data)
-{
-	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(vcpu->arch.apic))
-		return 1;
-
-	return kvm_x2apic_icr_write_fast(vcpu->arch.apic, data);
-}
-
-static int handle_fastpath_set_tscdeadline(struct kvm_vcpu *vcpu, u64 data)
-{
-	kvm_set_lapic_tscdeadline_msr(vcpu, data);
-	return 0;
-}
-
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 {
 	u64 data = kvm_read_edx_eax(vcpu);
 	u32 msr = kvm_rcx_read(vcpu);
-	bool handled;
 	int r;
 
 	switch (msr) {
 	case APIC_BASE_MSR + (APIC_ICR >> 4):
-		handled = !handle_fastpath_set_x2apic_icr_irqoff(vcpu, data);
+		if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(vcpu->arch.apic) ||
+		    kvm_x2apic_icr_write_fast(vcpu->arch.apic, data))
+			return EXIT_FASTPATH_NONE;
 		break;
 	case MSR_IA32_TSC_DEADLINE:
-		handled = !handle_fastpath_set_tscdeadline(vcpu, data);
+		kvm_set_lapic_tscdeadline_msr(vcpu, data);
 		break;
 	default:
-		handled = false;
-		break;
-	}
-
-	if (!handled)
 		return EXIT_FASTPATH_NONE;
+	}
 
 	kvm_vcpu_srcu_read_lock(vcpu);
 	r = kvm_skip_emulated_instruction(vcpu);
-- 
2.50.1.565.gc32cd1483b-goog



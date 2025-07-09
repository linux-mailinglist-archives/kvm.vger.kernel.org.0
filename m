Return-Path: <kvm+bounces-51882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4F9CAFE0D0
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 09:05:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18DC5173B07
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 07:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 118BC270EB0;
	Wed,  9 Jul 2025 07:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wU0tuLLR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1A726FA46
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 07:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752044703; cv=none; b=Kn9fUd/IDJf8/dPrLmHX/CrTh5iElgKwDOakvAw9eH1Bodt+TVLkOJ+GtIkePxQrwmksZvRqgxk6HsbOT/BIHMn76H+aAv2RiCVRG58T3TjGt9Tb6egvQVdEn6GMeOtkkaisyz6RGLHHyGvx4H3cME0Fh1pp7+25qTBhXZXbt/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752044703; c=relaxed/simple;
	bh=b1ROLBUa4PfoqSlkIa9V4t2N2ShKCwEmh/fAeQ9vc1A=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=Ii5Mm4nz9DoZu5cVdAGf7vc4Boz2n+pbI+Pr0TnOKTM+kFaA33UnBccT6B0nQF/6/w31dQhqTwhZVWWcswS6LFMRVkm4f53Bup5nSgqtZhF2+Dd7wVd7Z7gqlLhvSWq4ru0r8ceJ+A2cNuVCA1+MbPmVW87m+8HZQ32zwrOuzbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wU0tuLLR; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e8973c943d6so1133284276.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 00:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752044699; x=1752649499; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A2BQcTBupd9j0a9HC05i7mP4BWhaEQOOI0kqaY+fjtk=;
        b=wU0tuLLRkVAg/IsAzEgIHe+wOuRLtmt15BlJ7vF7nrXyWwaprADj06rUkOBnQycogI
         UN+s459AXOrGVT7Zm7JTaE2syJMAjm8ivbqthtLhNTKxPExb3fwzqigw3lT6bqZAOEA1
         2yaGlOV7kdZZ65loKF8yZkzvn3KdzLAg/DGn05Z2DAyLcwLtfEG8foKxgnd2Gv6WW6V9
         jPZ7TD0SiaZbuMKo2UGXh04NF4ruOxHEFuPDLd/aLLBAgnOrzjZ+ZrDP6UZKfXiX1mQb
         5lsvOxooEooGdrbYUxX+Fmn4rWWG+SvlQ9cmFF9Yo2QUj7KxnIGHDo+NY2oAcn9XzbWw
         mJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752044699; x=1752649499;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A2BQcTBupd9j0a9HC05i7mP4BWhaEQOOI0kqaY+fjtk=;
        b=V2L6px7LpCJKSSEImxsClGOfLqyUEDZPC9377xjZFLYUZJ7RfemvrX/Hp0X5chvt91
         hlqVMKFQlOiLwK26zhJBqYTfQuj12TlHf4iB/2B9dk3JYXoSOvnpS1BHGBjZoZZ4W1oT
         Lv5RkzT5m/s7NrAcVeJBblpQwk0ToMKy0IEF93wtIseLrlt0mAu9x9W+6LgVtyDGIBQD
         VQDfW/pRdFrR1N2/JeDQ4L7jV0ImHFmEhUrVt/WKFQDOEc/akWtHYc5FEIl/ZH2OdHZu
         ZOWh9cLFAYQOgiJU5lVpzWoHXVx3NzGC1SKyfPL/IeCaoHIX9n5IHmEvfvyEEnvLdomM
         60TQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBSiWy6aXk7IK3Oqk1jlBvwP6mad5J5CSuXhNdPBJyIn8aVjXW3d98o0+Lj873F96/EG0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVymtzJLTEiu3u2su1O3zwpfUSKsHeLHgtKWgiS9iu9qC+SWbR
	gqEZ4SQjK3gdfhQNGcgLcBOHz5pc3jiYRo2bquJbCxJvcDPuEIVPQWE83yM58uRnGqY8/tTJEvD
	1GB/bu6JIFAQTyA==
X-Google-Smtp-Source: AGHT+IFq26cqQyA00Q/GYkwS611peRZ2ZRuPlGXXHtSsrI7go/c7F2mBXe5ybETtjGiZXawkvn9U7II0Kz+zeQ==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:a92c:694f:82fe:62a])
 (user=suleiman job=sendgmr) by 2002:a25:3d81:0:b0:e87:9e04:4c30 with SMTP id
 3f1490d57ef6-e8b6f4db84fmr865276.4.1752044699070; Wed, 09 Jul 2025 00:04:59
 -0700 (PDT)
Date: Wed,  9 Jul 2025 16:04:48 +0900
In-Reply-To: <20250709070450.473297-1-suleiman@google.com>
Message-Id: <20250709070450.473297-2-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709070450.473297-1-suleiman@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Subject: [PATCH v6 1/3] KVM: x86: Advance guest TSC after deep suspend.
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	John Stultz <jstultz@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org, Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

Advance guest TSC to current time after suspend when the host
TSCs went backwards.

This makes the behavior consistent between suspends where host TSC
resets and suspends where it doesn't, such as suspend-to-idle, where
in the former case if the host TSC resets, the guests' would
previously be "frozen" due to KVM's backwards TSC prevention, while
in the latter case they would advance.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 28 +++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 639d9bcee8424d..5c465bdd6d088a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1414,6 +1414,7 @@ struct kvm_arch {
 	u64 cur_tsc_offset;
 	u64 cur_tsc_generation;
 	int nr_vcpus_matched_tsc;
+	bool host_was_suspended;
 
 	u32 default_tsc_khz;
 	bool user_set_tsc;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9d992d5652fa0..e66bab1a1f56e2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5035,7 +5035,32 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
-		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
+		unsigned long flags;
+		struct kvm *kvm;
+		bool advance;
+		u64 kernel_ns, l1_tsc, offset, tsc_now;
+
+		kvm = vcpu->kvm;
+		advance = kvm_get_time_and_clockread(&kernel_ns, &tsc_now);
+		raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
+		/*
+		 * Advance the guest's TSC to current time instead of only
+		 * preventing it from going backwards, while making sure
+		 * all the vCPUs use the same offset.
+		 */
+		if (kvm->arch.host_was_suspended && advance) {
+			l1_tsc = nsec_to_cycles(vcpu,
+						kvm->arch.kvmclock_offset + kernel_ns);
+			offset = kvm_compute_l1_tsc_offset(vcpu, l1_tsc);
+			kvm->arch.cur_tsc_offset = offset;
+			kvm_vcpu_write_tsc_offset(vcpu, offset);
+		} else if (advance)
+			kvm_vcpu_write_tsc_offset(vcpu, kvm->arch.cur_tsc_offset);
+		} else {
+			adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
+		}
+		kvm->arch.host_was_suspended = false;
+		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 		vcpu->arch.tsc_offset_adjustment = 0;
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 	}
@@ -12729,6 +12754,7 @@ int kvm_arch_enable_virtualization_cpu(void)
 				kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
 			}
 
+			kvm->arch.host_was_suspended = true;
 			/*
 			 * We have to disable TSC offset matching.. if you were
 			 * booting a VM while issuing an S4 host suspend....
-- 
2.50.0.727.gbf7dc18ff4-goog



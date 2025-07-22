Return-Path: <kvm+bounces-53076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16135B0D16F
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:51:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38387544D35
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 467AE28F531;
	Tue, 22 Jul 2025 05:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KNULWDde"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32A928D85D
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 05:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753163446; cv=none; b=bPZ8bNWRUB9rfOujnpaZGwlGXUB5f1hRbPBv9xfhgFjmLaZxJ0ESSvK+R6VQVLX4V+lW8/LvI/zNw+uFt02/Tou2/0sWHpmZj3ORtXwF4ADZxbsoT5V0r+kuR2KnLSTzIE621F1wWS8PWXx2shQ5Td2zq+tTjhxIPchxNgeSb1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753163446; c=relaxed/simple;
	bh=/fx4kWRX+PU6Fv4S7XnbQ02veHjaFijyVUSS0cLjVF8=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=djZlh3gHICshmB4KkxRreBVxYO76jAhbtFy9nX8ahCL0waA6yOLhYW/ePY4mRksqBzu8wguu+YDxtytJ/XiD3DT/hJ8o8eEzbTnhINAVdbz+gnOyrlRvwkgVCjwr0jRWED6WQhDdWsSF1Jp4qo4Ja/ruopzu1ROoNAP6CRrdyxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KNULWDde; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-710f05af33eso68887347b3.1
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 22:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753163443; x=1753768243; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GeeOPD6VQHaCMKZJuXhAQvuJ1HF7a4B8fy+bBRtdRfM=;
        b=KNULWDdeeOUEHINlMsfKGhVT7aMrbcdR1SydqTcnfOxWjl0Nj5rlLUrHE9iCicyWIW
         9ByWu9PnZxH+XWv96a5LpaGookMv8uAOdKqorClaj6msTONA05HOvfP0uwVk/OkJGyqa
         +qJe6eDF/TOAopUZAYCOKlbSKCoQaoxalmiVoYkE8+vbfhHInTokYG9L+jaWSeyw5vy0
         QLlX4rJlhSouan4r8NlVBCULPe1Ms7Tcj+jmFXpJtJ1XeBHyCbw7FHZs/npv+yOW44Sw
         1ey/i336EhNwkoo3zMySffrpTSnTtUmKxl0wfe+CF7hFjiBlCRqfe1J8Sp1jppBbucnc
         11CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753163443; x=1753768243;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GeeOPD6VQHaCMKZJuXhAQvuJ1HF7a4B8fy+bBRtdRfM=;
        b=v6lB8FFtfIKpM2JYSxEwGSzNTAMV3rHF5HVTmpRC4B15KG4gFaqxf0Foji2PP54Eug
         /Qkwmi0JuqVn6iaMC4/5GqwoNmnsogj2bFMzyglBq0lICv8wDfp/C7ijsLKY4e/3iNG2
         1t/DQgo6qkILCwYFBwyNCWAA6FRIMzFxhBZ/lHmX5R42i9IZzh9zLBVE8xwomKTxevzD
         sBdfbOmTst/lQ8XU5P62ibP52pc+P7lbnj2wBrDXwiZXwmm8y2XTuqUizTB5KdaE9qm5
         JMRHwnzbYG2CQP3fS61/2sHSgvzb4dkfLm6PLLodcKj4Zqyz/s+SJHbuh1J1nVCPMhV0
         WNzA==
X-Forwarded-Encrypted: i=1; AJvYcCVyQ4OmtpU4hiHwkOqH8wBnq3Og1IZqjH0lpbeM7eVg7HBvBY/eQGmURGZuyffaPgRpXs0=@vger.kernel.org
X-Gm-Message-State: AOJu0YweoRIXK3z7Eh2blv14uRudnnXOGq9oZtbTz0iVqkQuWBpOgVyj
	wIfoXSTewq5tSv2FQGwVxv9DjW6MqaCGMHq8b/AkqGwKwTM+WzN3vWkM3E3x/ywrTRAK+m4fUue
	Bl70ZQDc+2y28zg==
X-Google-Smtp-Source: AGHT+IG0/er4Oy4baTA0rbPQI0RPFFRIlvUUkZi83jLlYdOmAyZ0wGQZ0n3y5nto8lfMSr6b3Bt7hRUlYbWmSQ==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:eafa:b5d9:dc1:d7b1])
 (user=suleiman job=sendgmr) by 2002:a81:c902:0:b0:70e:70de:64ef with SMTP id
 00721157ae682-71836903ef2mr51877b3.0.1753163443305; Mon, 21 Jul 2025 22:50:43
 -0700 (PDT)
Date: Tue, 22 Jul 2025 14:50:28 +0900
In-Reply-To: <20250722055030.3126772-1-suleiman@google.com>
Message-Id: <20250722055030.3126772-2-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250722055030.3126772-1-suleiman@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Subject: [PATCH v8 1/3] KVM: x86: Advance guest TSC after deep suspend.
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

Try to advance guest TSC to current time after suspend when the host
TSCs went backwards.

This makes the behavior consistent between suspends where host TSC
resets and suspends where it doesn't, such as suspend-to-idle, where
in the former case if the host TSC resets, the guests' would
previously be "frozen" due to KVM's backwards TSC prevention, while
in the latter case they would advance.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/x86.c              | 49 ++++++++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fb01e456b624..e57d51e9f2be 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1415,6 +1415,9 @@ struct kvm_arch {
 	u64 cur_tsc_offset;
 	u64 cur_tsc_generation;
 	int nr_vcpus_matched_tsc;
+#ifdef CONFIG_X86_64
+	bool host_was_suspended;
+#endif
 
 	u32 default_tsc_khz;
 	bool user_set_tsc;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9d992d5652f..422c7fcc5d83 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2779,7 +2779,7 @@ static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
 	kvm_vcpu_write_tsc_offset(vcpu, tsc_offset + adjustment);
 }
 
-static inline void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
+static inline void __adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
 {
 	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_caps.default_tsc_scaling_ratio)
 		WARN_ON(adjustment < 0);
@@ -4995,6 +4995,52 @@ static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 
 static DEFINE_PER_CPU(struct kvm_vcpu *, last_vcpu);
 
+#ifdef CONFIG_X86_64
+static void kvm_set_host_was_suspended(struct kvm *kvm)
+{
+	kvm->arch.host_was_suspended = true;
+}
+
+static void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, u64 adj)
+{
+	unsigned long flags;
+	struct kvm *kvm;
+	bool advance;
+	u64 kernel_ns, l1_tsc, offset, tsc_now;
+
+	kvm = vcpu->kvm;
+	advance = kvm_get_time_and_clockread(&kernel_ns, &tsc_now);
+	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
+	/*
+	 * Advance the guest's TSC to current time instead of only preventing
+	 * it from going backwards, while making sure all the vCPUs use the
+	 * same offset.
+	 */
+	if (kvm->arch.host_was_suspended && advance) {
+		l1_tsc = nsec_to_cycles(vcpu,
+					kvm->arch.kvmclock_offset + kernel_ns);
+		offset = kvm_compute_l1_tsc_offset(vcpu, l1_tsc);
+		kvm->arch.cur_tsc_offset = offset;
+		kvm_vcpu_write_tsc_offset(vcpu, offset);
+	} else if (advance) {
+		kvm_vcpu_write_tsc_offset(vcpu, kvm->arch.cur_tsc_offset);
+	} else {
+		__adjust_tsc_offset_host(vcpu, adj);
+	}
+	kvm->arch.host_was_suspended = false;
+	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
+}
+#else
+static void kvm_set_host_was_suspended(struct kvm *kvm)
+{
+}
+
+static void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, u64 adj)
+{
+	__adjust_tsc_offset_host(vcpu, adj);
+}
+#endif /* CONFIG_X86_64 */
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -12729,6 +12775,7 @@ int kvm_arch_enable_virtualization_cpu(void)
 				kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
 			}
 
+			kvm_set_host_was_suspended(kvm);
 			/*
 			 * We have to disable TSC offset matching.. if you were
 			 * booting a VM while issuing an S4 host suspend....
-- 
2.50.0.727.gbf7dc18ff4-goog



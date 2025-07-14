Return-Path: <kvm+bounces-52262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 731AEB03500
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 05:37:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 107201899B0E
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 03:37:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 039061F4CB6;
	Mon, 14 Jul 2025 03:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lTgs8mId"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9218B1F461A
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 03:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752464237; cv=none; b=BfmAF06+dKaFEUXaqKGzeiapcchHjkgYPv+wjRRJ/MCE9zck1TkCIsRnEmmcBnAtFKwYSn1eBoWhQ+UnZfEbGkUHi3Ey7hO/gjlKzwOYXdzuzptrLud7gacjKtrwGUy3re6JBB7/gzaRMudwM5jP8kZ0d3h5X3+OpXDe82mVO0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752464237; c=relaxed/simple;
	bh=mw5FigrZgTtmJOz9CWwbj+XpPfjGVB57QW5wwlLEhXg=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=Pu0FuVtkD89Iymcve+iWDznu2xhOlF4CmPHfoEcHy7ZXPFLEkpyZmprW+q3lH+hNm2FVuJmF8ggigA5uN5P8IHxtG+atWypWsqwFIUvSFvU8/KVhf8FCXGxQT381KkgiN9XHIVlUY9zLhiRlGVLBAl2orro97jzIvOveh3FuvnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lTgs8mId; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e897c8c9ca4so4309261276.2
        for <kvm@vger.kernel.org>; Sun, 13 Jul 2025 20:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752464234; x=1753069034; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oxJhV9NlBlE0YNzyyXRMKN2+XBXwbAmlO7pRJnVb+ZM=;
        b=lTgs8mIdhtNptbilVGOYeIB+jbRsvUWTPZk3v2pE2EzBNqC9uMF+2BZo2z3yN/lisT
         +J4+7W0L8tN12EeXzWyyuej1sxEuVekDjpl1ru4VJGlY1lSBNtZeIIbE1ozi/JF8Anlk
         /nfQbr5wzlKvSHoJOQox/YfAxkVwLk8SnWqw8hNfumkx0RjuQjNz1Un7MYyjopO7Hykc
         nz1wW2SovZt6LFFQDDnGgYhDP4KW+jAvr912JYPnlyBgvPHWSRT6cmKMtj0Ewd9KOW6/
         PYQGpN9KI9fsT9WyQ0YQzpiX0EjxfzncHYCROb1/ly6SbzIXmKaTUcn5fDat4osIBSgp
         lt7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752464234; x=1753069034;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oxJhV9NlBlE0YNzyyXRMKN2+XBXwbAmlO7pRJnVb+ZM=;
        b=UB7IIiEAQ5URb2ALx+dPHe9cAPh5qoEwPWSaoQRn1CDVd+3+YnfbLQmYjZQAnUYBTD
         3Ik4A7B1E3rML+n2g7UFQTN8WY8N7fGZo9ZjvVhS/6RufyC7P9T0UV6R5EQWX9ZCEo+r
         iOG81UBZW0sQrrmZnesOU41nO1mj0pE3cDUuic0SbY3cd1Sfp8AQL9M7yXiWsqLCzFgb
         R2ljOvkv6cKlBPvq+jZ7I0j/TAMYkker7DjLY9WFMOqEhgh7wlfzUODzC+5uX2p2WJfV
         8dG9uhwdYvvlPc6QqNA1iIv8O/OQf+KBk9pRtOBMbs6eB087jDJpQ7CFtFkvL/VHsZhy
         HeKA==
X-Forwarded-Encrypted: i=1; AJvYcCW2i1XIX/dClab65F8DbZdr4fHESNQRd6MydwWX9O6CBh1oGsjywAybaWCt1/5AMDeQhs0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhhgOXdgZNPtwCzS9To36WJ4pt9VzYxr3eskVLYp8BrETkKZei
	pJOqnsTObo1QvIzXf0JFrbfwhMTcb5wly1HsfHx8jGfb6f4sieCQ1KAURt5Z5tHVQsjYKVz9Ybq
	m8RqanuBYPeBbjw==
X-Google-Smtp-Source: AGHT+IHKbV9ka5oFdT+zXuHEvk8R4LEZJ8+tvfQz+p5fpWhzt6Vy5KjvxcDRWPaoyblR40rIUlihiynW9uQsFg==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:4f90:1ee3:198b:1fe4])
 (user=suleiman job=sendgmr) by 2002:a25:b10f:0:b0:e86:1c5:3e2 with SMTP id
 3f1490d57ef6-e8b85a39fd7mr5176276.3.1752464234542; Sun, 13 Jul 2025 20:37:14
 -0700 (PDT)
Date: Mon, 14 Jul 2025 12:36:47 +0900
In-Reply-To: <20250714033649.4024311-1-suleiman@google.com>
Message-Id: <20250714033649.4024311-2-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250714033649.4024311-1-suleiman@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Subject: [PATCH v7 1/3] KVM: x86: Advance guest TSC after deep suspend.
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
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/x86.c              | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7b9ccdd99f32..3650a513ba19 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1414,6 +1414,9 @@ struct kvm_arch {
 	u64 cur_tsc_offset;
 	u64 cur_tsc_generation;
 	int nr_vcpus_matched_tsc;
+#ifdef CONFIG_X86_64
+	bool host_was_suspended;
+#endif
 
 	u32 default_tsc_khz;
 	bool user_set_tsc;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e21f5f2fe059..6539af701016 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5035,7 +5035,36 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
+#ifdef CONFIG_X86_64
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
+		} else if (advance) {
+			kvm_vcpu_write_tsc_offset(vcpu, kvm->arch.cur_tsc_offset);
+		} else {
+			adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
+		}
+		kvm->arch.host_was_suspended = false;
+		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
+#else
 		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
+#endif /* CONFIG_X86_64 */
 		vcpu->arch.tsc_offset_adjustment = 0;
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 	}
@@ -12729,6 +12758,9 @@ int kvm_arch_enable_virtualization_cpu(void)
 				kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
 			}
 
+#ifdef CONFIG_X86_64
+			kvm->arch.host_was_suspended = true;
+#endif
 			/*
 			 * We have to disable TSC offset matching.. if you were
 			 * booting a VM while issuing an S4 host suspend....
-- 
2.50.0.727.gbf7dc18ff4-goog



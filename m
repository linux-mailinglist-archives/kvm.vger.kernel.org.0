Return-Path: <kvm+bounces-13305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B8098947B5
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 01:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6EAA1B22413
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 23:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D0F656B8F;
	Mon,  1 Apr 2024 23:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EkUTm+Bl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE2156B89
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 23:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712014200; cv=none; b=f5m7OVHlwkBT4ijd1bbk/EraXWGrlj/XPX8ev+3rd5QhDSzYbAltBSaXR2Zv7+PKa11IpHGmUuCwj5uPFGpb4TXdM6FxmQMwIr2LLYNzny3tKTTZV73gJpOenJWT1Uf2VPQsBzhsqLBOfvO4v0pSW7nKVgePHZ05LwJA0HRQkMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712014200; c=relaxed/simple;
	bh=0ndCTUSKNYjrC7chZIPInNHsk3SUFRlCdRJOI83//j4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kulRzRB4A6sN5HnFoPJjo5CW4aTJmMAwWXroQhBIlWbYzVHZGmmmS+v1L1MEJgohm3SYdvW90HNrKlxzME5Rnp2Fazqs9+G+t25OxiaMF8LQZzu+IMAHcLCghUsX1G9VvBp91i1x3eeVfrUL/ymKLSVKULthmxsDGF/nPhMym2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EkUTm+Bl; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a20c33f06so52732877b3.2
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 16:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712014198; x=1712618998; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lJfaFUFI3gJojofhvI2fMvWTfkDCiiHnhDdEzunFXno=;
        b=EkUTm+BlIHv+2yFf9PmTsBJqBNyP5xBbhe1kcuVvTw03Jg0NYO8n0slTm0ul57EyED
         LhWUM2QaOtiznKp+R/JqMTo6Dk54IzyK4f/LGqe1NvhnAR1JCHvyADpgX+55UVf+yZYS
         idgRM9fRqgjpjZfwJqMBHO0RFxKCAYEY3TgFPsXEN+cv6Pdqvu1Ebi63s4nQzgLH/Pft
         wmf92n6UtCnIBHneAXEAcKvKNCOXa9LqZxEgAzfD2pBivWpNGEIcsnYiTa/PqJEBhpKq
         98ttLvPCxCjIdOhRyuzFBfII2Chir14fbDNEg5eaw99qBWpDmm05Aa17iqCRdt0Dyv/6
         8n0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712014198; x=1712618998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lJfaFUFI3gJojofhvI2fMvWTfkDCiiHnhDdEzunFXno=;
        b=LipXf0x/yZIXFcJWOFegRKgAVHvbg+0UwTvc/sqTf2xWEe9QvOxPbuX/6+Z8J/JXBz
         lMRlv9SKn8ffYXR9ulzJgEewZpbEREd0aLXVrIsZ7a0INuUVyXWvpVo00YIuHnARMEWE
         Sntm8m0OxqEIMhA2n4iQ2kcYohyVqEZ0BwHwvBVbeNYZBpYjX9BpFXKul0W+ZuiUIWCz
         jA/guFljeGy7t8cRDLWseeRAjcoUS9zaB3+xlCm9aKrE1ptXNfsjkXma7Ht0zWM6VXLe
         8cywK/RgyZx5+IXb6YO19o2/aUVyt9/n00HQaXOp75Zh4svo3qDq3IZU8qlJncxdkXT0
         Gjqw==
X-Forwarded-Encrypted: i=1; AJvYcCUjd44a7lMdcOZrpgPyf4RQu8y1eEbxE8k7s4UYplSaMQGJIVpNKsIxaUp74cjGdlR33dI/4Z8hNFHCZWTG6SVL0GNK
X-Gm-Message-State: AOJu0YxPUZUax8IWBLJHLUs0SX1qbRxukcmbVY0jtg1xqPb3xrUgJVb4
	5nfpe9f+gfoi3eQMt4g7WzlzekuvXK9kpxcCepS/bH5QQ1RIY9PkDXXx+SYi640dZlgJUIgi2v8
	dxc2Cn/TrBnVQytDDgQ==
X-Google-Smtp-Source: AGHT+IEzS+9pOebrRYAPHZcYp9+yLQ7vZUDEjcM1NuDRlvVAs7z0PGB+6rnD36HZsSFqff67vdpG7JIIt1VZPePZ
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:1006:b0:dcc:94b7:a7a3 with
 SMTP id w6-20020a056902100600b00dcc94b7a7a3mr767796ybt.12.1712014198123; Mon,
 01 Apr 2024 16:29:58 -0700 (PDT)
Date: Mon,  1 Apr 2024 23:29:41 +0000
In-Reply-To: <20240401232946.1837665-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240401232946.1837665-3-jthoughton@google.com>
Subject: [PATCH v3 2/7] KVM: Move MMU notifier function declarations
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>, David Matlack <dmatlack@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

To allow new MMU-notifier-related functions to use gfn_to_hva_memslot(),
move some declarations around.

Also move mmu_notifier_to_kvm() for wider use later.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_host.h | 41 +++++++++++++++++++++-------------------
 virt/kvm/kvm_main.c      |  5 -----
 2 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 48f31dcd318a..1800d03a06a9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -257,25 +257,6 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
-#ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
-union kvm_mmu_notifier_arg {
-	pte_t pte;
-	unsigned long attributes;
-};
-
-struct kvm_gfn_range {
-	struct kvm_memory_slot *slot;
-	gfn_t start;
-	gfn_t end;
-	union kvm_mmu_notifier_arg arg;
-	bool may_block;
-};
-bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
-bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
-#endif
-
 enum {
 	OUTSIDE_GUEST_MODE,
 	IN_GUEST_MODE,
@@ -2012,6 +1993,11 @@ extern const struct kvm_stats_header kvm_vcpu_stats_header;
 extern const struct _kvm_stats_desc kvm_vcpu_stats_desc[];
 
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
+static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
+{
+	return container_of(mn, struct kvm, mmu_notifier);
+}
+
 static inline int mmu_invalidate_retry(struct kvm *kvm, unsigned long mmu_seq)
 {
 	if (unlikely(kvm->mmu_invalidate_in_progress))
@@ -2089,6 +2075,23 @@ static inline bool mmu_invalidate_retry_gfn_unsafe(struct kvm *kvm,
 
 	return READ_ONCE(kvm->mmu_invalidate_seq) != mmu_seq;
 }
+
+union kvm_mmu_notifier_arg {
+	pte_t pte;
+	unsigned long attributes;
+};
+
+struct kvm_gfn_range {
+	struct kvm_memory_slot *slot;
+	gfn_t start;
+	gfn_t end;
+	union kvm_mmu_notifier_arg arg;
+	bool may_block;
+};
+bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 #endif
 
 #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ca4b1ef9dfc2..d0545d88c802 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -534,11 +534,6 @@ void kvm_destroy_vcpus(struct kvm *kvm)
 EXPORT_SYMBOL_GPL(kvm_destroy_vcpus);
 
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
-static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
-{
-	return container_of(mn, struct kvm, mmu_notifier);
-}
-
 typedef bool (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 
 typedef void (*on_lock_fn_t)(struct kvm *kvm);
-- 
2.44.0.478.gd926399ef9-goog



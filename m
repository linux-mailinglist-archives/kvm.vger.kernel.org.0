Return-Path: <kvm+bounces-34959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 224B6A081B3
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 21:52:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 777FD7A1D17
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:52:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59A3F2066CC;
	Thu,  9 Jan 2025 20:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XKvnVZX5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com [209.85.160.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5793E205AAE
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 20:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455803; cv=none; b=FrDrsN569EJEG8nCb8BhaitqeA/rYpaqqhYjYgb3cKLwJq+VXLqq/LMeK4FohhcdnMWV1+nUDcQ+w6ljuhrKXrids0+Ip/Q5qLkUN+ezyIMJkfeHZv+vFv4l9vooI8dt1ufIDYXdz/LjDpMEbCfc5t3WIRkHl6YZDmASTABklaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455803; c=relaxed/simple;
	bh=Bf6Z/SdUsbkpIsqoT2JIQQkVc3cDT9ghaIOkviu+ke8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fl2OZPB4+BwxL86TVQnjEt48xqC/nM+sEXpIuTF3gI3eXTnzGPNnrkvp8b3gq4EsykxfCfQG6N0+1CZ3ntoIuwYgPy3NiF2CYJwQTQm0dkGKQySe9OXWCWYZElt4XNn+y0Mm4+Y/mxgbrKMY8BNeydiMAHb1JB2iTZbL43WJDUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XKvnVZX5; arc=none smtp.client-ip=209.85.160.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-qt1-f202.google.com with SMTP id d75a77b69052e-4675749a982so22458031cf.1
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 12:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736455800; x=1737060600; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ej4vKCsRcXi3JRFU5yXFClNg+jWCgVgQEDR3f6Axo50=;
        b=XKvnVZX53ule8fsbj+y0ODeoguCnwbs4AppPD6dYohQG0IVcsTq9Wc/PzEeZxwOOts
         SOzF59ti/yPAf6ZnKEVI2TWAV6LqOIhs/T0xwb2X5442vyG1iFMqv+1QT1iB82ax2+kJ
         36rgyIhocAVPUvxPwFAuikBPR0bfbHEz9ceRCvqM8gd7JY1Ca90FFJUc4ptq3XLXR763
         tlU6dWx4OFkqlvhmsE8fFZl8ygqH5peXACJMsW+JqgwXM4/D+XUob67JkkHjzJxJc535
         OR5bZKmyb6W0se36a8r3GUuNXq/oZOM5UQmZXtDv7zsn1+ZAlAICDSjekWNkwFLW+r+B
         ar+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455800; x=1737060600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ej4vKCsRcXi3JRFU5yXFClNg+jWCgVgQEDR3f6Axo50=;
        b=V/OO8mInDMrDmodPpP6EPgdoMtPuEAQuyLptAKVUsmr+k1X25n/oJb/C3Iq6fhSyTI
         VKC3+NHgYgCZwEJJKcvxV2sqrL4mPalb2iSeaoB5yj2WdSBKKIhueCXF0AjnCU0O7eEQ
         GTn6Ahaeu5ZW6J6rRwmfqaEX5Jb+PGuMNhPhZd5CxcvlAOv4Nhg/IP7ku7uUYkhSnSQ7
         CbHkrqeiUMoaYZrjgpgjLeOdapkcXHl5dnoXX+CtTtR2k1V16sMCIrNGRpSzTMJ/+Isq
         2t9Qarvgw6f5Np4m9GJ1jaOykR5aH2sJ8AEIwVnf/7yCGbNUfCrfptL7jTK/JM+2D4eX
         lwbA==
X-Forwarded-Encrypted: i=1; AJvYcCVX6Cu/EE11+JlEglgJRedmBmutNcFGzfFhFZRzHHleP4OvQuOTIibJEUiFZ1/OykRrej8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/G2Q/M+uQYRm1qcMnnOnsrcz5CyNOnjkZTC8pUXVGgWNsSeU5
	R19mCAJLWOsLIZJoPk390T+7HsZL8Omvz9H4Rot69L5FdZpADrvUaWQ0BtQCAjmUnYv8nB/qGqm
	0g5390MIoMeMc5s0R6A==
X-Google-Smtp-Source: AGHT+IEjWh1ifMEjbhq2t/4s1LokEzVaJxOMILKR5p4NmJRJSQEQbDzHfJF1YycGc5qCqnm1VGVZZj4bYy7TorUf
X-Received: from qtbiw5.prod.google.com ([2002:a05:622a:6f85:b0:466:928b:3b7c])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:622a:14e:b0:467:5926:fcf2 with SMTP id d75a77b69052e-46c7107e0b4mr103936581cf.9.1736455800057;
 Thu, 09 Jan 2025 12:50:00 -0800 (PST)
Date: Thu,  9 Jan 2025 20:49:22 +0000
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250109204929.1106563-7-jthoughton@google.com>
Subject: [PATCH v2 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Adhering to the requirements of KVM Userfault:
1. When it is toggled on, zap the second stage with
   kvm_arch_flush_shadow_memslot(). This is to respect userfault-ness.
2. When KVM_MEM_USERFAULT is enabled, restrict new second-stage mappings
   to be PAGE_SIZE, just like when dirty logging is enabled.

Do not zap the second stage when KVM_MEM_USERFAULT is disabled to remain
consistent with the behavior when dirty logging is disabled.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/kvm/Kconfig |  1 +
 arch/arm64/kvm/mmu.c   | 26 +++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ead632ad01b4..d89b4088b580 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -38,6 +38,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select HAVE_KVM_USERFAULT
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c9d46ad57e52..e099bdcfac42 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1493,7 +1493,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * logging_active is guaranteed to never be true for VM_PFNMAP
 	 * memslots.
 	 */
-	if (logging_active) {
+	if (logging_active || kvm_memslot_userfault(memslot)) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
 	} else {
@@ -1582,6 +1582,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
+	if (kvm_gfn_userfault(kvm, memslot, gfn)) {
+		kvm_prepare_memory_fault_exit(vcpu, gfn << PAGE_SHIFT,
+					      PAGE_SIZE, write_fault,
+					      exec_fault, false, true);
+		return -EFAULT;
+	}
+
 	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
 				&writable, &page);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
@@ -2073,6 +2080,23 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   enum kvm_mr_change change)
 {
 	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+	u32 new_flags = new ? new->flags : 0;
+	u32 changed_flags = (new_flags) ^ (old ? old->flags : 0);
+
+	/*
+	 * If KVM_MEM_USERFAULT has been enabled, drop all the stage-2 mappings
+	 * so that we can respect userfault-ness.
+	 */
+	if ((changed_flags & KVM_MEM_USERFAULT) &&
+	    (new_flags & KVM_MEM_USERFAULT) &&
+	    change == KVM_MR_FLAGS_ONLY)
+		kvm_arch_flush_shadow_memslot(kvm, old);
+
+	/*
+	 * Nothing left to do if not toggling dirty logging.
+	 */
+	if (!(changed_flags & KVM_MEM_LOG_DIRTY_PAGES))
+		return;
 
 	/*
 	 * At this point memslot has been committed and there is an
-- 
2.47.1.613.gc27f4b7a9f-goog



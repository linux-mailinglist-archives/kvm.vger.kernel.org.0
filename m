Return-Path: <kvm+bounces-8032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8663984A0C8
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 18:31:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E98D81F22CCC
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 17:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD41444C7E;
	Mon,  5 Feb 2024 17:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z0bqpZx7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB5740BEB
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 17:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707154297; cv=none; b=nuXn8KSKEPRMMFE7L2LkYF3yI3nIPZA33jx2gxNrf1OQy4yxaGXhM3VatIQMfikGok9hWv3Et3DB2oUbQaRd+6ZgGPSlJYaS28qgriBNvzLCPoVodnwh2pEIXS87zncCUqm3AsVm+shsPjw5Dfuua+BFX2OhImlYHWXRVB7g2QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707154297; c=relaxed/simple;
	bh=xEyqyUOvdZboKmHpNCarFdt8jnKerrHqE4MpHsotmFI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=cAxv4YeFYEfc6sQpmSNKdjV+fYcRcrI9YOb0ZE52aBbc6Dp+w2renGC7Kq6bBKQW+5HY7tIp86liiOzxk8Zwh3Fw2PdBgJtc7ogqNPoE77mItN3VQV4D67OjNbKmdwUmcpphZtGI+7Lp1MSQqvfsTHvRSHaByIkhyVlegAaUupE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--avagin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z0bqpZx7; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--avagin.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cf2714e392so2830921a12.0
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 09:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707154295; x=1707759095; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xAh+m8NpmmquiTQVj9HnmFfN4D8u5RS8wXiyWZb6U7A=;
        b=Z0bqpZx7MOs4JrARy9CRfQv6ti8RwYWmFz7ed0E9qSbBPs+UEjCfDjAWWhRjTOPuhx
         LhenMoN9QzfUKQmihjJl1gPwS+bD1y72hVqoZBgojmDLZYTVnMBAir30NEWpBeURqHln
         4UWXL5oukkXnoB33Lq2udKKJwxQ+GuByth5II74lxwz1FYH6UvyUauq5CXD6q2kIWSeg
         /Du/uE9y4D1ygMH5Smj3BxK46HqzSfo7pnx9QDDJGzaVglTXeT0HinsB6VTx6STnn2tu
         BOszngCnL2VB6+m9Otw/MuLlRq5wXfynNH0kUJE3yv9lAm2taGqoqRXNdVny+K7e9L1r
         HtKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707154295; x=1707759095;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xAh+m8NpmmquiTQVj9HnmFfN4D8u5RS8wXiyWZb6U7A=;
        b=BVMgmdeB4APkZxOD76VIwkMn6phHfN/9ZjDs+3JMqtQWvbZ9Eor14sBV0wAL72fZ5P
         RL/daL5F/pzScBQNDs+3LEtx3I1WkdhXIxTOafbOgr5cOYlNNaL2lx1RkQCf8M0wcHoh
         CJxHSsJQHSagpWV4aKx9ySIgl4iwcA3tEsldTOVqUTUNSgJX1Hv/7qfW+JiekwgR+bZO
         aIHSsRjaGT2ZIjl61mhsllft4XJOKkR49ZhiQK0F4vPQyiSCqW2eQGYWP6elpSYV5VfM
         wb5GAtt7mG/09lJ3PvvPiBW0Nov/5JKlJjiKSnmaZw9X99o8uiWkFNKCwaOKZWfYdDGg
         GzrQ==
X-Gm-Message-State: AOJu0Yyv4z3YyPaBirgv0ziBKZrPS7C4ly9XtjQVrWywd2wUBVcOMtVH
	Jt4i0gIFwjYwviIEKAXcQKITiQ2fxv4mofbT6sTICfxQ5xB4P05xFQb8l7yaL0QleYDktoAyud7
	qLQ==
X-Google-Smtp-Source: AGHT+IFVl860tRNXfVokCOJ+o6Ci2XKuNL395E+aTa7wrxYbxHjuwDpIoisRAUqIdRdRieAvjJFc+aKs/50=
X-Received: from avagin.kir.corp.google.com ([2620:0:1008:10:98af:717c:5f3:596d])
 (user=avagin job=sendgmr) by 2002:a63:7702:0:b0:5dc:229b:6777 with SMTP id
 s2-20020a637702000000b005dc229b6777mr31895pgc.1.1707154294803; Mon, 05 Feb
 2024 09:31:34 -0800 (PST)
Date: Mon,  5 Feb 2024 09:31:24 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240205173124.366901-1-avagin@google.com>
Subject: [PATCH] kvm/x86: add capability to disable the write-track mechanism
From: Andrei Vagin <avagin@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	Andrei Vagin <avagin@google.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Zhi Wang <zhi.a.wang@intel.com>
Content-Type: text/plain; charset="UTF-8"

The write-track is used externally only by the gpu/drm/i915 driver.
Currently, it is always enabled, if a kernel has been compiled with this
driver.

Enabling the write-track mechanism adds a two-byte overhead per page across
all memory slots. It isn't significant for regular VMs. However in gVisor,
where the entire process virtual address space is mapped into the VM, even
with a 39-bit address space, the overhead amounts to 256MB.

This change introduces the new KVM_CAP_PAGE_WRITE_TRACKING capability,
allowing users to enable/disable the write-track mechanism. It is enabled
by default for backward compatibility.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Zhi Wang <zhi.a.wang@intel.com>
Signed-off-by: Andrei Vagin <avagin@google.com>
---
 Documentation/virt/kvm/api.rst  | 16 ++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/mmu/page_track.c   | 13 +++++++++++--
 arch/x86/kvm/x86.c              | 25 +++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  1 +
 5 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3ec0b7a455a0..448a96c950e7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8791,6 +8791,22 @@ means the VM type with value @n is supported.  Possible values of @n are::
   #define KVM_X86_DEFAULT_VM	0
   #define KVM_X86_SW_PROTECTED_VM	1
 
+8.38 KVM_CAP_PAGE_WRITE_TRACKING
+-------------------------------------
+
+:Capability: KVM_CAP_PAGE_WRITE_TRACKING
+:Architectures: x86
+:Type: system ioctl
+:Parameters: args[0] defines whether the feature should be enabled or not
+:Returns: 0 on success, -EINVAL if args[0] isn't 1 or 0, -EINVAL if any memslot
+          was already created or any users was registered, -EBUSY if write
+          tracking is used for internal needs and can't be disabled.
+
+This capability enables/disables the page write-track mechanism. It is enabled
+by default for backward compatibility.
+
+This capability may only be set before any mem slots are created.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d271ba20a0b2..8a05e3322a59 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1503,6 +1503,10 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
+	bool page_write_tracking_disabled;
+#endif
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index c87da11f3a04..bf8f9ca7b86e 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -20,9 +20,15 @@
 #include "mmu_internal.h"
 #include "page_track.h"
 
+#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
+#define KVM_EXTERNAL_WRITE_TRACKING_ENABLED(kvm) \
+		(!kvm->arch.page_write_tracking_disabled)
+#else
+#define KVM_EXTERNAL_WRITE_TRACKING_ENABLED(kvm) false
+#endif
+
 bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
-{
-	return IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) ||
+{	return KVM_EXTERNAL_WRITE_TRACKING_ENABLED(kvm) ||
 	       !tdp_enabled || kvm_shadow_root_allocated(kvm);
 }
 
@@ -165,6 +171,9 @@ int kvm_page_track_register_notifier(struct kvm *kvm,
 	if (!kvm || kvm->mm != current->mm)
 		return -ESRCH;
 
+	if (kvm->arch.page_write_tracking_disabled)
+		return -EINVAL;
+
 	kvm_get_kvm(kvm);
 
 	head = &kvm->arch.track_notifier_head;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bf10a9073a09..2f28a1b357dd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4668,6 +4668,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_MEMORY_FAULT_INFO:
+	case KVM_CAP_PAGE_WRITE_TRACKING:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -6675,6 +6676,30 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_PAGE_WRITE_TRACKING: {
+		bool enabling = cap->args[0];
+
+		r = -EINVAL;
+		if (cap->args[0] & ~1)
+			break;
+
+		r = -EBUSY;
+		if (!enabling && (!tdp_enabled || kvm_shadow_root_allocated(kvm)))
+			break;
+#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
+		write_lock(&kvm->mmu_lock);
+		if (!kvm_memslots_empty(kvm_memslots(kvm)) ||
+		    kvm_page_track_has_external_user(kvm)) {
+			write_unlock(&kvm->mmu_lock);
+			r = -EINVAL;
+			break;
+		}
+		kvm->arch.page_write_tracking_disabled = !enabling;
+		write_unlock(&kvm->mmu_lock);
+#endif
+		r = 0;
+		break;
+	}
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c3308536482b..0e9ea5a62e38 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1155,6 +1155,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_PAGE_WRITE_TRACKING 236
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.43.0.594.gd9cf4e227d-goog



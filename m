Return-Path: <kvm+bounces-49795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6905BADE26A
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:25:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 118433B90E0
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 04:25:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8EC3212FBE;
	Wed, 18 Jun 2025 04:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cPL4pQVE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F366020409A
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220676; cv=none; b=Oe2R+mEsDqxsTMRKmXY1rjyIXOpEbAauIjcb5zJ1UcrAk+oNm3rUjKboTpGTOsnHWfOkoPpgeKHun9HFqQHLN6ZvZ77+dPRqgeUdBP/JS0MQn93FQ7826J60Ex8+ZgbnZXvhzKXspesD1IaWeeJ7WjSFJ6SZeCMAz9NJ4lpACeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220676; c=relaxed/simple;
	bh=ktpeP3vGqvb2VrKVgvEJ+JbvYtkH68vgsXA6IZugPJ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t8gvTSgvLLNnYT2aSsnage1x2rNCPQXEFxmgi18khpQ23w+2PRkWmWiXngq/LDM7I0hXPSgKnHNwX/jJ9gwyxtW11xapCxBK/F/+Ddsidgt9EP4HKbluihHrykfMomevBaJhWs54uG5gm1d0vzHXmVFFyWuIV2L6i9nQflvcQS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cPL4pQVE; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26e33ae9d5so7231925a12.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220673; x=1750825473; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oFoW3AOc+QuFugacj5s9TiS04hgfBImIEFygFMt/Gog=;
        b=cPL4pQVEq0EoF49GPtsICRIBeDHI9KSLZOGdLTfzU7++/kWeqA5Vj651WH/McWTwXl
         4cNEqoPPoISj3dgKmNP3Pe/rmXETGvxZJ793l93cZxadppd5FCnSFyD+x6m8lJla4VsH
         aRxEl8Pl3bSYAolz0vjel5jWtPjCwb8j7pXMRpa3ENR3VxtFE2BoeMd71aZ9Vdn7IHCV
         eeikv0gXlvj1tt1/qsLIWgsN6ohqoDV7bSpujcj6IAjdcj9UU1MqXUFjQf+FznsAg2tL
         6D4QOFADKZxkk3+Vkr1r5mdRW+McBKEkRu4NigXQ4qvIiRIoyYaLM7e/Q/M/cT9rAt7M
         W0Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220673; x=1750825473;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oFoW3AOc+QuFugacj5s9TiS04hgfBImIEFygFMt/Gog=;
        b=UD5YlAq/yPSk16isc7M0Vg1h4c3sQi4im8tKz4BLoygqrm8S22LPt2Y8RY06iGD/VV
         GUerN/++RuW/AUgKd24vo/TCnlR/u80VTA39ub3lBaEBEKN663K9aV7TE34rCMHQ4IWC
         oyGH5gq5TLyVMItPwfH5nWv3Djh4egLgzMlGrUvQq7LlW/lOyzMlTUmffkjxK6yUXPcV
         QPJliO013vNh4JK0dpBCC6qvm8yGcIJpB17NG6/8n/6J2y/SLCNkEq8WX0zsHXyg71Uz
         lV3frL20eSyb8xEeL+5lUlhooBYtzx+DDXgoTsmP8YM/wL9ln3yfj8r18oNGlNwS5vQk
         SJrw==
X-Forwarded-Encrypted: i=1; AJvYcCXH9VXhlKXCM0g7DHqCr923ETNLLEwd4QzmBPPg5xkHaGUkMlIFQr0NHSWIB+jQpZPBY6Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4EsuRjfOyKe5VX/dYpgSiAVJP4NPHitj2XjaahmOhE+ojot2i
	byTnYW1k1/s582Jlhew/6pef6nu2hY4U3+ENZ5IIaPeK7zLQPBaWX5dt8ZSVBbvNfXgX+ZiagUK
	PB0XdU38ttyKZqZJplRR48w==
X-Google-Smtp-Source: AGHT+IFbfVtTMrlDGyQ0S31hA6FZ725AcPC2U4LvoTBYCTExhfd2YSckOKywCjqOOmu17hz/wpGpnzKXQhdQJMVq
X-Received: from pgan185.prod.google.com ([2002:a63:40c2:0:b0:b31:cd5e:6d0e])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:e687:b0:1f5:9330:29fe with SMTP id adf61e73a8af0-21fbd4c7e08mr20135116637.17.1750220673296;
 Tue, 17 Jun 2025 21:24:33 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:13 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-5-jthoughton@google.com>
Subject: [PATCH v3 04/15] KVM: Add common infrastructure for KVM Userfaults
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

KVM Userfault consists of a bitmap in userspace that describes which
pages the user wants exits on (when KVM_MEM_USERFAULT is enabled). To
get those exits, the memslot where KVM_MEM_USERFAULT is being enabled
must drop (at least) all of the translations that the bitmap says should
generate faults. Today, simply drop all translations for the memslot. Do
so with a new arch interface, kvm_arch_userfault_enabled(), which can be
specialized in the future by any architecture for which optimizations
make sense.

Make some changes to kvm_set_memory_region() to support setting
KVM_MEM_USERFAULT on KVM_MEM_GUEST_MEMFD memslots, including relaxing
the retrictions on guest_memfd memslots from only deletion to no moving.

Signed-off-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 23 ++++++++++++++++++
 include/uapi/linux/kvm.h |  5 +++-
 virt/kvm/kvm_main.c      | 51 ++++++++++++++++++++++++++++++++++++----
 3 files changed, 74 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9a85500cd5c50..bd5fb5ae10d05 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -597,6 +597,7 @@ struct kvm_memory_slot {
 	unsigned long *dirty_bitmap;
 	struct kvm_arch_memory_slot arch;
 	unsigned long userspace_addr;
+	unsigned long __user *userfault_bitmap;
 	u32 flags;
 	short id;
 	u16 as_id;
@@ -1236,6 +1237,20 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot);
 
+#ifndef __KVM_HAVE_ARCH_USERFAULT_ENABLED
+static inline void kvm_arch_userfault_enabled(struct kvm *kvm,
+					      struct kvm_memory_slot *slot)
+{
+	/*
+	 * kvm_arch_userfault_enabled() must ensure that new faults on pages
+	 * marked as userfault will exit to userspace. Dropping all
+	 * translations is sufficient; architectures may choose to optimize
+	 * this.
+	 */
+	return kvm_arch_flush_shadow_memslot(kvm, slot);
+}
+#endif
+
 int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
 		       struct page **pages, int nr_pages);
 
@@ -2524,6 +2539,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 	if (fault->is_private)
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
+
+bool kvm_do_userfault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
+
+static inline bool kvm_is_userfault_memslot(struct kvm_memory_slot *memslot)
+{
+	return memslot && memslot->flags & KVM_MEM_USERFAULT;
+}
+
 #endif
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d00b85cb168c3..e3b871506ec85 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -40,7 +40,8 @@ struct kvm_userspace_memory_region2 {
 	__u64 guest_memfd_offset;
 	__u32 guest_memfd;
 	__u32 pad1;
-	__u64 pad2[14];
+	__u64 userfault_bitmap;
+	__u64 pad2[13];
 };
 
 /*
@@ -51,6 +52,7 @@ struct kvm_userspace_memory_region2 {
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
 #define KVM_MEM_GUEST_MEMFD	(1UL << 2)
+#define KVM_MEM_USERFAULT	(1UL << 3)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -443,6 +445,7 @@ struct kvm_run {
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
 #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+#define KVM_MEMORY_EXIT_FLAG_USERFAULT	(1ULL << 4)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eec82775c5bfb..bef6760cd1c0e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1747,6 +1747,14 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 		if (old->dirty_bitmap && !new->dirty_bitmap)
 			kvm_destroy_dirty_bitmap(old);
 
+		/*
+		 * If KVM_MEM_USERFAULT is being enabled for the slot, drop the
+		 * translations that are marked as userfault.
+		 */
+		if (!(old_flags & KVM_MEM_USERFAULT) &&
+		    (new_flags & KVM_MEM_USERFAULT))
+			kvm_arch_userfault_enabled(kvm, old);
+
 		/*
 		 * The final quirk.  Free the detached, old slot, but only its
 		 * memory, not any metadata.  Metadata, including arch specific
@@ -2039,6 +2047,12 @@ static int kvm_set_memory_region(struct kvm *kvm,
 	if (id < KVM_USER_MEM_SLOTS &&
 	    (mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
 		return -EINVAL;
+	if (mem->flags & KVM_MEM_USERFAULT &&
+	    ((mem->userfault_bitmap != untagged_addr(mem->userfault_bitmap)) ||
+	     !access_ok(u64_to_user_ptr(mem->userfault_bitmap),
+			DIV_ROUND_UP(mem->memory_size >> PAGE_SHIFT, BITS_PER_LONG)
+			 * sizeof(long))))
+		return -EINVAL;
 
 	slots = __kvm_memslots(kvm, as_id);
 
@@ -2071,14 +2085,15 @@ static int kvm_set_memory_region(struct kvm *kvm,
 		if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
 			return -EINVAL;
 	} else { /* Modify an existing slot. */
-		/* Private memslots are immutable, they can only be deleted. */
-		if (mem->flags & KVM_MEM_GUEST_MEMFD)
-			return -EINVAL;
 		if ((mem->userspace_addr != old->userspace_addr) ||
 		    (npages != old->npages) ||
 		    ((mem->flags ^ old->flags) & KVM_MEM_READONLY))
 			return -EINVAL;
 
+		/* Moving a guest_memfd memslot isn't supported. */
+		if (base_gfn != old->base_gfn && mem->flags & KVM_MEM_GUEST_MEMFD)
+			return -EINVAL;
+
 		if (base_gfn != old->base_gfn)
 			change = KVM_MR_MOVE;
 		else if (mem->flags != old->flags)
@@ -2102,11 +2117,13 @@ static int kvm_set_memory_region(struct kvm *kvm,
 	new->npages = npages;
 	new->flags = mem->flags;
 	new->userspace_addr = mem->userspace_addr;
-	if (mem->flags & KVM_MEM_GUEST_MEMFD) {
+	if (mem->flags & KVM_MEM_GUEST_MEMFD && change == KVM_MR_CREATE) {
 		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
 		if (r)
 			goto out;
 	}
+	if (mem->flags & KVM_MEM_USERFAULT)
+		new->userfault_bitmap = u64_to_user_ptr(mem->userfault_bitmap);
 
 	r = kvm_set_memslot(kvm, old, new, change);
 	if (r)
@@ -4980,6 +4997,32 @@ static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
 	return cleared;
 }
 
+#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
+bool kvm_do_userfault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+{
+	struct kvm_memory_slot *slot = fault->slot;
+	unsigned long __user *user_chunk;
+	unsigned long chunk;
+	gfn_t offset;
+
+	if (!kvm_is_userfault_memslot(slot))
+		return false;
+
+	offset = fault->gfn - slot->base_gfn;
+	user_chunk = slot->userfault_bitmap + (offset / BITS_PER_LONG);
+
+	if (__get_user(chunk, user_chunk))
+		return true;
+
+	if (!test_bit(offset % BITS_PER_LONG, &chunk))
+		return false;
+
+	kvm_prepare_memory_fault_exit(vcpu, fault);
+	vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_USERFAULT;
+	return true;
+}
+#endif
+
 int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 						  struct kvm_enable_cap *cap)
 {
-- 
2.50.0.rc2.692.g299adb8693-goog



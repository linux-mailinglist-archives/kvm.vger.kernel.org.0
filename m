Return-Path: <kvm+bounces-66290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A1A0BCCE216
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 02:20:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A00FE302832C
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 01:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2ED3212557;
	Fri, 19 Dec 2025 01:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="awyfdZlM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBA5288D2
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 01:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766107248; cv=none; b=iXKwB6qz4f7UgqFEJG7YxH0XFs+LD+fMUaO9dhIQ9rbTBFgsp/kiM3DJSHKKQz6AI0Bbf7NDiufB5qLDQQZyZGsrtVBUzLmOSmfEc0rpcRUDeotbnd910+HlCK418Di+8Af3fkB83T3LwL7hSU+JACGd3Cmab0dbYY2iCOTtwXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766107248; c=relaxed/simple;
	bh=CrLw4VBrWjUWwrcAbgLxBCMhqzVtML6nTp4cl92xOqw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=myDlqimroqORgPftGfAEj3UsbawVSLf1EP1apaCX/gnz+WDzA1xaE2iNqA0NHVWqyV2exwPlqcjpsAGnQYJqf7piwabh2f11OdT3dGRGd41ygzFYOQPlVpn8m1Pyeb753/5p7IpiBadHIDTGMBj11Z1Of3Y/axEWuPG8WU9oR/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=awyfdZlM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c43f8ef9bso2172877a91.1
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 17:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766107246; x=1766712046; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e1oi4mnuLLL6bf0wFuVJldfb0uYmu/pj+f61oQSJDA4=;
        b=awyfdZlM0JlQyZsn4VtvoBZY/Am538l/fqesSuQlECoTDyXWsKKcPYNe1r/fdFCkYf
         XfV9dJ1JOx2PPK7hU3LnVkmoKqKnVBOwt3hGZQlyXhRb87mKa17DUh5NxOjA8Sj8dA95
         tMQIbK2r7x3/131y/lD5RFJI+sDB5cwJEWkdhX5G0maL34tqkrgWpfDhmeaOSQ0onnOx
         LoTRtWX/hATagY2MxxtSC+5endHdRgZlqBJumawKpjIKM7VNS9IU6k0pwDHzahjM9hvk
         zxE9kWDhGEtbaniUxZwUGObuNz5zs83zI2ROxDmpCPZ1EvDhTKO94zTW+Fau9Q0OqF9A
         vRDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766107246; x=1766712046;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e1oi4mnuLLL6bf0wFuVJldfb0uYmu/pj+f61oQSJDA4=;
        b=N0T5nMwXzDoUuV8xhkdnzz9OLUSEVbaf+KlYwrUH9HFppkxrsSrQBtN9CtUwiW9KRi
         hfpMEgYfSzUTfaV01zc78TqpgftB/btQeGdbgQucSC9yL8juoDqDsDdn0yeyBhTnS/xR
         TDflP9Pe2+W5xuM2V2C4Ejf3q6nvoP5KPgYsUWG8ku+7ZZGU7AuuRwQjBVZ6Pley+3fJ
         aZiSDwBMfYfFCDrXmQ/Rm4INWlRzOZTM1tKYgFVy20y3GGC3pEoDOfNmVRcSw1k38BQc
         FHS2IAWPEbJYc7rAALt9yDNx0Wor41jikrjZkd98yS0kcIz+0WYRd/wZv42fhfuVli/F
         jmUQ==
X-Gm-Message-State: AOJu0Ywq/SI4FoGNqFxJFQKLsZlmvbsZ384Gj2LVuDNViBKzDkHAwpgx
	tiJgyOB/JhdbxbgtRrNBo+bZ7Ve9/ZQkYGA91SF4/urr3Pv1esDtppcRQnfQxLpWdyilgcIJfy7
	GrWxS1w==
X-Google-Smtp-Source: AGHT+IGLTrkeHUpYZnEoFTF29YffsALKfo6ydvjvl5TSAkMMUt/GVaCCR6jGLVhothpsyiRu5euzCVWGq5c=
X-Received: from pjsg8.prod.google.com ([2002:a17:90a:7148:b0:340:c53d:2599])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:57c6:b0:340:b501:7b83
 with SMTP id 98e67ed59e1d1-34e90dcfcd2mr1085541a91.10.1766107245633; Thu, 18
 Dec 2025 17:20:45 -0800 (PST)
Date: Thu, 18 Dec 2025 17:20:44 -0800
In-Reply-To: <DS0PR02MB9321EA7B6AB2B559CA1CDFDD8BD9A@DS0PR02MB9321.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20221005211551.152216-1-thanos.makatos@nutanix.com>
 <aLrvLfkiz6TwR4ML@google.com> <DS0PR02MB93218C62840E0E9FA240FAF68BD8A@DS0PR02MB9321.namprd02.prod.outlook.com>
 <aS9uBw_w7NM_Vnw1@google.com> <DS0PR02MB9321EA7B6AB2B559CA1CDFDD8BD9A@DS0PR02MB9321.namprd02.prod.outlook.com>
Message-ID: <aUSobNVZ9VEaLN79@google.com>
Subject: Re: [RFC PATCH] KVM: optionally commit write on ioeventfd write
From: Sean Christopherson <seanjc@google.com>
To: Thanos Makatos <thanos.makatos@nutanix.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, John Levon <john.levon@nutanix.com>, 
	"mst@redhat.com" <mst@redhat.com>, "dinechin@redhat.com" <dinechin@redhat.com>, 
	"cohuck@redhat.com" <cohuck@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, 
	"stefanha@redhat.com" <stefanha@redhat.com>, "jag.raman@oracle.com" <jag.raman@oracle.com>, 
	"eafanasova@gmail.com" <eafanasova@gmail.com>, 
	"elena.ufimtseva@oracle.com" <elena.ufimtseva@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

+Paolo (just realized Paolo isn't on the Cc)

On Wed, Dec 03, 2025, Thanos Makatos wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > Side topic, Paolo had an off-the-cuff idea of adding uAPI to support
> > notifications on memslot ranges, as opposed to posting writes via
> > ioeventfd.  E.g. add a memslot flag, or maybe a memory attribute, that
> > causes KVM to write-protect a region, emulate in response to writes, and
> > then notify an eventfd after emulating the write.  It'd be a lot like
> > KVM_MEM_READONLY, except that KVM would commit the write to memory and
> > notify, as opposed to exiting to userspace.
> 
> Are you thinking for reusing/adapting the mechanism in this patch for that?

Paolo's idea was to forego this patch entirely and instead add a more generic
write-notify mechanism.  In practice, the only real difference is that the writes
would be fully in-place instead of a redirection, which in turn would allow the
guest to read without triggering a VM-Exit, and I suppose might save userspace
from some dirty logging operations.
 
While I really like the mechanics of the idea, after sketching out the basic
gist (see below), I'm not convinced the additional complexity is worth the gains.
Unless reading from NVMe submission queues is a common operation, it doesn't seem
like eliding VM-Exits on reads buys much.

Every arch would need to be updated to handle the new way of handling emulated
writes, with varying degrees of complexity.  E.g. on x86 I think it would just be
teaching the MMU about the new "emulate on write" behavior, but for arm64 (and
presumably any other architecture without a generic emulator), it would be that
plus new code to actually commit the write to guest memory.

The other scary aspect is correctly handling "writable from KVM" and "can't be
mapped writable".  Getting that correct in all places is non-trivial, and seems
like it could be a pain to maintain, which potentially fatal failure modes, e.g.
if KVM writes guest memory but fails to notify, tracking down the bug would be
"fun".

So my vote is to add POST_WRITE functionality to I/O eventfd, and hold off on a
generic write-notify mechanism until there's a (really) strong use case.

Paolo, thoughts?


---
 arch/x86/kvm/mmu/mmu.c   |  6 +++--
 include/linux/kvm_host.h |  2 ++
 include/uapi/linux/kvm.h |  3 ++-
 virt/kvm/kvm_main.c      | 51 +++++++++++++++++++++++++++++++++-------
 4 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 02c450686b4a..acad277ba2a1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3493,7 +3493,8 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 	 * into the spte otherwise read access on readonly gfn also can
 	 * caused mmio page fault and treat it as mmio access.
 	 */
-	if (fault->pfn == KVM_PFN_ERR_RO_FAULT)
+	if (fault->pfn == KVM_PFN_ERR_RO_FAULT ||
+	    fault->pfn == KVM_PFN_ERR_WRITE_NOTIFY)
 		return RET_PF_EMULATE;
 
 	if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
@@ -4582,7 +4583,8 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
 		return r;
 	}
 
-	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
+	fault->map_writable = !(fault->slot->flags &
+				(KVM_MEM_READONLY | KVM_MEM_WRITE_NOTIFY));
 	fault->max_level = kvm_max_level_for_order(max_order);
 
 	return RET_PF_CONTINUE;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..e75dc5c2a279 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -99,6 +99,7 @@
 #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
 #define KVM_PFN_ERR_SIGPENDING	(KVM_PFN_ERR_MASK + 3)
 #define KVM_PFN_ERR_NEEDS_IO	(KVM_PFN_ERR_MASK + 4)
+#define KVM_PFN_ERR_WRITE_NOTIFY (KVM_PFN_ERR_MASK + 5)
 
 /*
  * error pfns indicate that the gfn is in slot but faild to
@@ -615,6 +616,7 @@ struct kvm_memory_slot {
 		pgoff_t pgoff;
 	} gmem;
 #endif
+	struct eventfd_ctx *eventfd;
 };
 
 static inline bool kvm_slot_has_gmem(const struct kvm_memory_slot *slot)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dddb781b0507..c3d084a09d6c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -39,7 +39,7 @@ struct kvm_userspace_memory_region2 {
 	__u64 userspace_addr;
 	__u64 guest_memfd_offset;
 	__u32 guest_memfd;
-	__u32 pad1;
+	__u32 eventfd;
 	__u64 pad2[14];
 };
 
@@ -51,6 +51,7 @@ struct kvm_userspace_memory_region2 {
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
 #define KVM_MEM_GUEST_MEMFD	(1UL << 2)
+#define KVM_MEM_WRITE_NOTIFY	(1UL << 3)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f1f6a71b2b5f..e58d43bae757 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -953,6 +953,8 @@ static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
 /* This does not remove the slot from struct kvm_memslots data structures */
 static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
+	if (slot->flags & KVM_MEM_WRITE_NOTIFY)
+		eventfd_ctx_put(slot->eventfd);
 	if (slot->flags & KVM_MEM_GUEST_MEMFD)
 		kvm_gmem_unbind(slot);
 
@@ -1607,11 +1609,15 @@ static int check_memory_region_flags(struct kvm *kvm,
 	/*
 	 * GUEST_MEMFD is incompatible with read-only memslots, as writes to
 	 * read-only memslots have emulated MMIO, not page fault, semantics,
-	 * and KVM doesn't allow emulated MMIO for private memory.
+	 * and KVM doesn't allow emulated MMIO for private memory.  Ditto for
+	 * write-notify memslots (emulated exitless MMIO).
 	 */
-	if (kvm_arch_has_readonly_mem(kvm) &&
-	    !(mem->flags & KVM_MEM_GUEST_MEMFD))
-		valid_flags |= KVM_MEM_READONLY;
+	if (!mem->flags & KVM_MEM_GUEST_MEMFD) {
+		if (kvm_arch_has_readonly_mem(kvm))
+			valid_flags |= KVM_MEM_READONLY;
+		if (kvm_arch_has_write_notify_mem(kvm))
+			valid_flags |= KVM_MEM_WRITE_NOTIFY;
+	}
 
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
@@ -2100,7 +2106,9 @@ static int kvm_set_memory_region(struct kvm *kvm,
 			return -EINVAL;
 		if ((mem->userspace_addr != old->userspace_addr) ||
 		    (npages != old->npages) ||
-		    ((mem->flags ^ old->flags) & (KVM_MEM_READONLY | KVM_MEM_GUEST_MEMFD)))
+		    ((mem->flags ^ old->flags) & (KVM_MEM_READONLY |
+						  KVM_MEM_GUEST_MEMFD |
+						  KVM_MEM_WRITE_NOTIFY)))
 			return -EINVAL;
 
 		if (base_gfn != old->base_gfn)
@@ -2131,13 +2139,29 @@ static int kvm_set_memory_region(struct kvm *kvm,
 		if (r)
 			goto out;
 	}
+	if (mem->flags & KVM_MEM_WRITE_NOTIFY) {
+		CLASS(fd, f)(mem->eventfd);
+		if (fd_empty(f)) {
+			r = -EBADF;
+			goto out_unbind;
+		}
+
+		new->eventfd = eventfd_ctx_fileget(fd_file(f));
+		if (IS_ERR(new->eventfd)) {
+			r = PTR_ERR(new->eventfd);
+			goto out_unbind;
+		}
+	}
 
 	r = kvm_set_memslot(kvm, old, new, change);
 	if (r)
-		goto out_unbind;
+		goto out_eventfd;
 
 	return 0;
 
+out_eventfd:
+	if (mem->flags & KVM_MEM_WRITE_NOTIFY)
+		eventfd_ctx_put(new->eventfd);
 out_unbind:
 	if (mem->flags & KVM_MEM_GUEST_MEMFD)
 		kvm_gmem_unbind(new);
@@ -2727,6 +2751,11 @@ unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
 	return size;
 }
 
+static bool memslot_is_write_notify(const struct kvm_memory_slot *slot)
+{
+	return slot->flags & KVM_MEM_WRITE_NOTIFY;
+}
+
 static bool memslot_is_readonly(const struct kvm_memory_slot *slot)
 {
 	return slot->flags & KVM_MEM_READONLY;
@@ -2786,7 +2815,7 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot,
 	unsigned long hva = __gfn_to_hva_many(slot, gfn, NULL, false);
 
 	if (!kvm_is_error_hva(hva) && writable)
-		*writable = !memslot_is_readonly(slot);
+		*writable = !memslot_is_readonly(slot)
 
 	return hva;
 }
@@ -3060,7 +3089,11 @@ static kvm_pfn_t kvm_follow_pfn(struct kvm_follow_pfn *kfp)
 	if (kvm_is_error_hva(kfp->hva))
 		return KVM_PFN_NOSLOT;
 
-	if (memslot_is_readonly(kfp->slot) && kfp->map_writable) {
+	if ((kfp->flags & FOLL_WRITE) && memslot_is_write_notify(kfp->slot))
+		return KVM_PFN_ERR_WRITE_NOTIFY;
+
+	if (kfp->map_writable &&
+	    (memslot_is_readonly(kfp->slot) || memslot_is_write_notify(kfp->slot)) {
 		*kfp->map_writable = false;
 		kfp->map_writable = NULL;
 	}
@@ -3324,6 +3357,8 @@ static int __kvm_write_guest_page(struct kvm *kvm,
 	r = __copy_to_user((void __user *)addr + offset, data, len);
 	if (r)
 		return -EFAULT;
+	if (memslot_is_write_notify(memslot))
+		eventfd_signal(memslot->eventfd);
 	mark_page_dirty_in_slot(kvm, memslot, gfn);
 	return 0;
 }

base-commit: 58e10b63777d0aebee2cf4e6c67e1a83e7edbe0f
--


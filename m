Return-Path: <kvm+bounces-67969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F59CD1AB71
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 18:46:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1DB5D304A8E6
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D0C53939CA;
	Tue, 13 Jan 2026 17:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ttdsE+eT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2FF3939C3
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 17:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768326373; cv=none; b=myMSCax5pkXtfhXoC3SNtF6iI/5Qs+jXMoyE9wdYn/9L+ExZ5ExWUnwUnEZ35hwdgGJWE2mJK+lD911Gs+DDfsq3gpkpnM0ajbfPwnFX2dU0uqVrcdktEu/Cser0DqOBJpMmWmEl+M8TR3VwwSztGMWEd1dN5WZvjmYegh8JhLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768326373; c=relaxed/simple;
	bh=4ZTtxbzTNmYnUM+MsSzb1wsDVYo0Qs03WvcCysD6+C8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SaFUN7uf6bn8dfyvkz08iw2sfnP/eiAvyGYUa9rFCUKIJ4b9t8+6oUEpTQWLIsPFqvT5vXy9o54+hkkQlT59/DwxzbLMd0BbM6BTkjkvY9AhTeaHBCiKqvsFZSO8Zm4OK1off4FIHoACnIpGYCC0a9R1puxp0/eH8T/ICsVHEE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ttdsE+eT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0d058fc56so63358085ad.3
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 09:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768326371; x=1768931171; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YNb2VF84dP46LgFx8kiI9WVhad6Rik0R6dM/dGioytE=;
        b=ttdsE+eTatJw14Afq144jOjFP5iT4YrjCaRRiGzpZLEfeXAO1+dh3/v1heUeySkCuy
         rtzjvslLEc8D+Zdye3a2CS1KUkz4zWNTnITjBTZXf30aZlvAT6x/13dWqdZlZzFhWTLw
         3eSJIjR0DDF+xLSYrtGE7YVVJNEK3WmWQIODA1L1OVQLz2qJPHQoqfiQby2Him2blX7o
         snl7BKg0huTzbWA3OhW/icI5apwLE23MKPQP8GboEADs8Q24FC6GBhh419qpdXtq3/7p
         hSvkI9+uJZRahcdVy7C5v1d3v2eHsZv2d/fhvCbFELDC58zqUk7cYwFrCqM4tqyfBT6p
         rdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768326371; x=1768931171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YNb2VF84dP46LgFx8kiI9WVhad6Rik0R6dM/dGioytE=;
        b=K/hA1LpRYpVUN97D7gRwOWht7Fg+3aiy3ZaL8eX7tBZ6C6+keORejBsq4mfFec3e/a
         nUNPnTysudHQQ1MTtO8JpduZwOyxCcOwTjboCr6JhPA+yVqiDJpQgUEZw2oPJbUSQu98
         c3JAsDsrBQkkhNNde4FgwQfA+FMRuZr15MhQNL7onnF/WH+Gg4ytMo9jksp8jQ3SmrsR
         2v2SaqmWvphr14y1wXhzSRTrkOv0BFydkAEEoUeDDd0vmXSCOhuV8MrVXq6I7hd3WQbx
         zuYBrhCKHA5gmRtJZaHLJXNZ9ufQb0UvT4Hyc4Dax9AyoaSIvZhniqd9VKi1krbsGvSU
         gCbQ==
X-Gm-Message-State: AOJu0YwcgnW/mWz/5yFGeo5RjqdEz6TJXKVQWu72xgqxlAKtl7sbqPrL
	CsW0pd1TgnfIuRaSQ7Tr82HpCkNpwYNPYN5bsDgjTMDuEL+LBhHchClxfjcEqYSHc2LIWQcbJd1
	8ATnZkQ==
X-Google-Smtp-Source: AGHT+IEKlBSoSv5shvkXPl9+9fw8Es6u45z4EYm65607JuzRtL7Cln0TrdLfZO0/fpXy5y1svjXiHFuAGOo=
X-Received: from pjboo9.prod.google.com ([2002:a17:90b:1c89:b0:34c:2f52:23aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b03:b0:343:e461:9022
 with SMTP id 98e67ed59e1d1-34f68ca444bmr22112564a91.24.1768326370718; Tue, 13
 Jan 2026 09:46:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 13 Jan 2026 09:46:05 -0800
In-Reply-To: <20260113174606.104978-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113174606.104978-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113174606.104978-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: Don't clobber irqfd routing type when deassigning irqfd
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"

When deassigning a KVM_IRQFD, don't clobber the irqfd's copy of the IRQ's
routing entry as doing so breaks kvm_arch_irq_bypass_del_producer() on x86
and arm64, which explicitly look for KVM_IRQ_ROUTING_MSI.  Instead, to
handle a concurrent routing update, verify that the irqfd is still active
before consuming the routing information.  As evidenced by the x86 and
arm64 bugs, and another bug in kvm_arch_update_irqfd_routing() (see below),
clobbering the entry type without notifying arch code is surprising and
error prone.

As a bonus, checking that the irqfd is active provides a convenient
location for documenting _why_ KVM must not consume the routing entry for
an irqfd that is in the process of being deassigned: once the irqfd is
deleted from the list (which happens *before* the eventfd is detached), it
will no longer receive updates via kvm_irq_routing_update(), and so KVM
could deliver an event using stale routing information (relative to
KVM_SET_GSI_ROUTING returning to userspace).

As an even better bonus, explicitly checking for the irqfd being active
fixes a similar bug to the one the clobbering is trying to prevent: if an
irqfd is deactivated, and then its routing is changed,
kvm_irq_routing_update() won't invoke kvm_arch_update_irqfd_routing()
(because the irqfd isn't in the list).  And so if the irqfd is in bypass
mode, IRQs will continue to be posted using the old routing information.

As for kvm_arch_irq_bypass_del_producer(), clobbering the routing type
results in KVM incorrectly keeping the IRQ in bypass mode, which is
especially problematic on AMD as KVM tracks IRQs that are being posted to
a vCPU in a list whose lifetime is tied to the irqfd.

Without the help of KASAN to detect use-after-free, the most common
sympton on AMD is a NULL pointer deref in amd_iommu_update_ga() due to
the memory for irqfd structure being re-allocated and zeroed, resulting
in irqfd->irq_bypass_data being NULL when read by
avic_update_iommu_vcpu_affinity():

  BUG: kernel NULL pointer dereference, address: 0000000000000018
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 40cf2b9067 P4D 40cf2b9067 PUD 408362a067 PMD 0
  Oops: Oops: 0000 [#1] SMP
  CPU: 6 UID: 0 PID: 40383 Comm: vfio_irq_test
  Tainted: G     U  W  O        6.19.0-smp--5dddc257e6b2-irqfd #31 NONE
  Tainted: [U]=USER, [W]=WARN, [O]=OOT_MODULE
  Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 34.78.2-0 09/05/2025
  RIP: 0010:amd_iommu_update_ga+0x19/0xe0
  Call Trace:
   <TASK>
   avic_update_iommu_vcpu_affinity+0x3d/0x90 [kvm_amd]
   __avic_vcpu_load+0xf4/0x130 [kvm_amd]
   kvm_arch_vcpu_load+0x89/0x210 [kvm]
   vcpu_load+0x30/0x40 [kvm]
   kvm_arch_vcpu_ioctl_run+0x45/0x620 [kvm]
   kvm_vcpu_ioctl+0x571/0x6a0 [kvm]
   __se_sys_ioctl+0x6d/0xb0
   do_syscall_64+0x6f/0x9d0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x46893b
    </TASK>
  ---[ end trace 0000000000000000 ]---

If AVIC is inhibited when the irfd is deassigned, the bug will manifest as
list corruption, e.g. on the next irqfd assignment.

  list_add corruption. next->prev should be prev (ffff8d474d5cd588),
                       but was 0000000000000000. (next=ffff8d8658f86530).
  ------------[ cut here ]------------
  kernel BUG at lib/list_debug.c:31!
  Oops: invalid opcode: 0000 [#1] SMP
  CPU: 128 UID: 0 PID: 80818 Comm: vfio_irq_test
  Tainted: G     U  W  O        6.19.0-smp--f19dc4d680ba-irqfd #28 NONE
  Tainted: [U]=USER, [W]=WARN, [O]=OOT_MODULE
  Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 34.78.2-0 09/05/2025
  RIP: 0010:__list_add_valid_or_report+0x97/0xc0
  Call Trace:
   <TASK>
   avic_pi_update_irte+0x28e/0x2b0 [kvm_amd]
   kvm_pi_update_irte+0xbf/0x190 [kvm]
   kvm_arch_irq_bypass_add_producer+0x72/0x90 [kvm]
   irq_bypass_register_consumer+0xcd/0x170 [irqbypass]
   kvm_irqfd+0x4c6/0x540 [kvm]
   kvm_vm_ioctl+0x118/0x5d0 [kvm]
   __se_sys_ioctl+0x6d/0xb0
   do_syscall_64+0x6f/0x9d0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>
  ---[ end trace 0000000000000000 ]---

On Intel and arm64, the bug is less noisy, as the end result is that the
device keeps posting IRQs to the vCPU even after it's been deassigned.

Note, the worst of the breakage can be traced back to commit cb210737675e
("KVM: Pass new routing entries and irqfd when updating IRTEs"), as before
that commit KVM would pull the routing information from the per-VM routing
table.  But as above, similar bugs have existed since support for IRQ
bypass was added.  E.g. if a routing change finished before irq_shutdown()
invoked kvm_arch_irq_bypass_del_producer(), VMX and SVM would see stale
routing information and potentially leave the irqfd in bypass mode.

Alternatively, x86 could be fixed by explicitly checking irq_bypass_vcpu
instead of irq_entry.type in kvm_arch_irq_bypass_del_producer(), and arm64
could be modified to utilize irq_bypass_vcpu in a similar manner.  But (a)
that wouldn't fix the routing updates bug, and (b) fixing core code doesn't
preclude x86 (or arm64) from adding such code as a sanity check (spoiler
alert).

Fixes: f70c20aaf141 ("KVM: Add an arch specific hooks in 'struct kvm_kernel_irqfd'")
Fixes: cb210737675e ("KVM: Pass new routing entries and irqfd when updating IRTEs")
Fixes: a0d7e2fc61ab ("KVM: arm64: vgic-v4: Only attempt vLPI mapping for actual MSIs")
Cc: stable@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 0e8b5277be3b..a369b20d47f0 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -157,21 +157,28 @@ irqfd_shutdown(struct work_struct *work)
 }
 
 
-/* assumes kvm->irqfds.lock is held */
-static bool
-irqfd_is_active(struct kvm_kernel_irqfd *irqfd)
+static bool irqfd_is_active(struct kvm_kernel_irqfd *irqfd)
 {
+	/*
+	 * Assert that either irqfds.lock or SRCU is held, as irqfds.lock must
+	 * be held to prevent false positives (on the irqfd being active), and
+	 * while false negatives are impossible as irqfds are never added back
+	 * to the list once they're deactivated, the caller must at least hold
+	 * SRCU to guard against routing changes if the irqfd is deactivated.
+	 */
+	lockdep_assert_once(lockdep_is_held(&irqfd->kvm->irqfds.lock) ||
+			    srcu_read_lock_held(&irqfd->kvm->irq_srcu));
+
 	return list_empty(&irqfd->list) ? false : true;
 }
 
 /*
  * Mark the irqfd as inactive and schedule it for removal
- *
- * assumes kvm->irqfds.lock is held
  */
-static void
-irqfd_deactivate(struct kvm_kernel_irqfd *irqfd)
+static void irqfd_deactivate(struct kvm_kernel_irqfd *irqfd)
 {
+	lockdep_assert_held(&irqfd->kvm->irqfds.lock);
+
 	BUG_ON(!irqfd_is_active(irqfd));
 
 	list_del_init(&irqfd->list);
@@ -217,8 +224,15 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
 			seq = read_seqcount_begin(&irqfd->irq_entry_sc);
 			irq = irqfd->irq_entry;
 		} while (read_seqcount_retry(&irqfd->irq_entry_sc, seq));
-		/* An event has been signaled, inject an interrupt */
-		if (kvm_arch_set_irq_inatomic(&irq, kvm,
+
+		/*
+		 * An event has been signaled, inject an interrupt unless the
+		 * irqfd is being deassigned (isn't active), in which case the
+		 * routing information may be stale (once the irqfd is removed
+		 * from the list, it will stop receiving routing updates).
+		 */
+		if (unlikely(!irqfd_is_active(irqfd)) ||
+		    kvm_arch_set_irq_inatomic(&irq, kvm,
 					      KVM_USERSPACE_IRQ_SOURCE_ID, 1,
 					      false) == -EWOULDBLOCK)
 			schedule_work(&irqfd->inject);
@@ -585,18 +599,8 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list) {
-		if (irqfd->eventfd == eventfd && irqfd->gsi == args->gsi) {
-			/*
-			 * This clearing of irq_entry.type is needed for when
-			 * another thread calls kvm_irq_routing_update before
-			 * we flush workqueue below (we synchronize with
-			 * kvm_irq_routing_update using irqfds.lock).
-			 */
-			write_seqcount_begin(&irqfd->irq_entry_sc);
-			irqfd->irq_entry.type = 0;
-			write_seqcount_end(&irqfd->irq_entry_sc);
+		if (irqfd->eventfd == eventfd && irqfd->gsi == args->gsi)
 			irqfd_deactivate(irqfd);
-		}
 	}
 
 	spin_unlock_irq(&kvm->irqfds.lock);
-- 
2.52.0.457.g6b5491de43-goog



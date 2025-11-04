Return-Path: <kvm+bounces-61932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 43E7DC2EB5D
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 02:12:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BA60534A9B5
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 01:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 562FD18DB1F;
	Tue,  4 Nov 2025 01:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jNZzKcuG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C395D27456
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 01:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762218730; cv=none; b=t2qp+9tnEYRetQBW5sth+7Z5IQDPlDzOH+v8ZVXgBUZwj3IRQt5BTBP/T3RROnXS40rDeeu2Do/zoi/6Zrk+dJMnee0yMeYOWAqWveo6vG2aLjYOFVTXoAd2pds4qdfUeZsQMCCg50jTuMJx+BThKsHhD//Il4kisYzRvvem8Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762218730; c=relaxed/simple;
	bh=l8fQ7Sg54DhzN6R5hMatFRXXOT5EnptU7MLiyQB8q/c=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LoXslenKybJhtQPzWC/kubAv4vcAUCsKuPC+EZrdowN/GLwtzCNCE8kSIbkYvyRz1muwSdiXUxFXJc6BlyJ9gV4C0wRMZijqBVxUfjRHdU0VAWIYgBmWGF3favVpB/KTkvE0fV6c7CFAi6cTCSxuWTvhtoagDgd5dQvhNwlVMFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jNZzKcuG; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b99d6bd6cc9so1861778a12.1
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 17:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762218727; x=1762823527; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SpAT0xXfZ+ThbyNiIH4mbkTqFi5O02tcf+VLN4RFP/E=;
        b=jNZzKcuGl1X5qiWXzMXjIYCa/7OcF+Tewy1tNxHjCKdp93CmA0ugSwEIE0br874RrB
         ZHfMyMIQotNczvyzLQRM7tdKTkpQLHh+CeVelqb3NK+0c0QgG1XnSeiltW6mzPqZHbrQ
         LDYJc9fjWAaLeS8yNGgUyz8i470o6a/jeIhTrCL9so0suRDOV6sxgx/MJ5GK3IVODGJx
         p0BMkntaSPDBKiJ8M1k7fCtKpu/QsXmI0mRZDmK3m78T4XqjZOvT/qhsG7Deop3jxaqD
         Jb/sx3jwkw7f8aGkvlby7nMqvE7RVH+r8CeVj/q9+0oDKEXSp09U0yeaQem2BrDxRD7c
         YIxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762218727; x=1762823527;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SpAT0xXfZ+ThbyNiIH4mbkTqFi5O02tcf+VLN4RFP/E=;
        b=vhNEjr1g1VTbtNM5N043mUb3/ffGeOGUuf1s63hjNXdexKkLD4NDsh6bHK1KyuekG7
         zMEudffxfExaAbh1kBDgPnc/QEeRYCpngJj9W8BeVJL53/QEn3fiZND4kTTX2qt2D0qf
         yB/JASvAsXcMH9yKGATybpjQsJfUvCOgnlWvkunbjax1BMmpoEvVHxYr0WgZhzIYYFMh
         GT28vueEroL9J6B8eiu0ndkgj2eyQNRynkr3anYbex7rmLVKJAugSGNa37uoPGkTLLBk
         eNilkkCyIfsFYviD/FvrZRHFlUyEP/AerqAGKrc9IofbSQawHfKGyOPvrrgCQxXwStct
         rxnQ==
X-Gm-Message-State: AOJu0YyskGgP12o8zMO+BdcRpcUlG+/Xc/ICtel6UZbGnD4rzRQquKpJ
	cAGy/zl+iPn5TVNmcokDWVkx7OWw2lxlJ6nb+5gtbdHJcH7IL4sDWehXhVyEAuGKExM9lv25Pvi
	/ReWyzQ==
X-Google-Smtp-Source: AGHT+IGFj9aJy9gxzUfPcPhWHWgMut9zcBq6jDDOCpbynrVs7FFI7X//6kWpi6L2p4Jx1aJX4IEMpAAQnOg=
X-Received: from pjzm12.prod.google.com ([2002:a17:90b:68c:b0:32d:e4c6:7410])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7350:b0:33e:6885:2bd4
 with SMTP id adf61e73a8af0-348cc8e365fmr21744928637.29.1762218726995; Mon, 03
 Nov 2025 17:12:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  3 Nov 2025 17:12:05 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1006.ga50a493c49-goog
Message-ID: <20251104011205.3853541-1-seanjc@google.com>
Subject: [PATCH] KVM: guest_memfd: Remove bindings on memslot deletion when
 gmem is dying
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com, 
	Hillf Danton <hdanton@sina.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

When unbinding a memslot from a guest_memfd instance, remove the bindings
even if the guest_memfd file is dying, i.e. even if its file refcount has
gone to zero.  If the memslot is freed before the file is fully released,
nullifying the memslot side of the binding in kvm_gmem_release() will
write to freed memory, as detected by syzbot+KASAN:

  ==================================================================
  BUG: KASAN: slab-use-after-free in kvm_gmem_release+0x176/0x440 virt/kvm/guest_memfd.c:353
  Write of size 8 at addr ffff88807befa508 by task syz.0.17/6022

  CPU: 0 UID: 0 PID: 6022 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
  Call Trace:
   <TASK>
   dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
   print_address_description mm/kasan/report.c:378 [inline]
   print_report+0xca/0x240 mm/kasan/report.c:482
   kasan_report+0x118/0x150 mm/kasan/report.c:595
   kvm_gmem_release+0x176/0x440 virt/kvm/guest_memfd.c:353
   __fput+0x44c/0xa70 fs/file_table.c:468
   task_work_run+0x1d4/0x260 kernel/task_work.c:227
   resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
   exit_to_user_mode_loop+0xe9/0x130 kernel/entry/common.c:43
   exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
   syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
   syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
   do_syscall_64+0x2bd/0xfa0 arch/x86/entry/syscall_64.c:100
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7fbeeff8efc9
   </TASK>

  Allocated by task 6023:
   kasan_save_stack mm/kasan/common.c:56 [inline]
   kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
   poison_kmalloc_redzone mm/kasan/common.c:397 [inline]
   __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:414
   kasan_kmalloc include/linux/kasan.h:262 [inline]
   __kmalloc_cache_noprof+0x3e2/0x700 mm/slub.c:5758
   kmalloc_noprof include/linux/slab.h:957 [inline]
   kzalloc_noprof include/linux/slab.h:1094 [inline]
   kvm_set_memory_region+0x747/0xb90 virt/kvm/kvm_main.c:2104
   kvm_vm_ioctl_set_memory_region+0x6f/0xd0 virt/kvm/kvm_main.c:2154
   kvm_vm_ioctl+0x957/0xc60 virt/kvm/kvm_main.c:5201
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:597 [inline]
   __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  Freed by task 6023:
   kasan_save_stack mm/kasan/common.c:56 [inline]
   kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
   kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
   poison_slab_object mm/kasan/common.c:252 [inline]
   __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:284
   kasan_slab_free include/linux/kasan.h:234 [inline]
   slab_free_hook mm/slub.c:2533 [inline]
   slab_free mm/slub.c:6622 [inline]
   kfree+0x19a/0x6d0 mm/slub.c:6829
   kvm_set_memory_region+0x9c4/0xb90 virt/kvm/kvm_main.c:2130
   kvm_vm_ioctl_set_memory_region+0x6f/0xd0 virt/kvm/kvm_main.c:2154
   kvm_vm_ioctl+0x957/0xc60 virt/kvm/kvm_main.c:5201
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:597 [inline]
   __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Deliberately don't acquire filemap invalid lock when the file is dying as
the lifecycle of f_mapping is outside the purview of KVM.  Dereferencing
the mapping is *probably* fine, but there's no need to invalidate anything
as memslot deletion is responsible for zapping SPTEs, and the only code
that can access the dying file is kvm_gmem_release(), whose core code is
mutually exclusive with unbinding.

Note, the mutual exclusivity is also what makes it self to access the
bindings on a dying gmem instance.  Unbinding either runs with slots_lock
held, or after the last reference to the owning "struct kvm" is put, and
kvm_gmem_release() nullifies the slot pointer under slots_lock, and puts
its reference to the VM after that is done.

Reported-by: syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68fa7a22.a70a0220.3bf6c6.008b.GAE@google.com
Tested-by: syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com
Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Cc: stable@vger.kernel.org
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 46 +++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fbca8c0972da..050731922522 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -623,24 +623,11 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return r;
 }
 
-void kvm_gmem_unbind(struct kvm_memory_slot *slot)
+static void __kvm_gmem_unbind(struct kvm_memory_slot *slot, struct kvm_gmem *gmem)
 {
 	unsigned long start = slot->gmem.pgoff;
 	unsigned long end = start + slot->npages;
-	struct kvm_gmem *gmem;
-	struct file *file;
 
-	/*
-	 * Nothing to do if the underlying file was already closed (or is being
-	 * closed right now), kvm_gmem_release() invalidates all bindings.
-	 */
-	file = kvm_gmem_get_file(slot);
-	if (!file)
-		return;
-
-	gmem = file->private_data;
-
-	filemap_invalidate_lock(file->f_mapping);
 	xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
 
 	/*
@@ -648,6 +635,37 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	 * cannot see this memslot.
 	 */
 	WRITE_ONCE(slot->gmem.file, NULL);
+}
+
+void kvm_gmem_unbind(struct kvm_memory_slot *slot)
+{
+	struct file *file;
+
+	/*
+	 * Nothing to do if the underlying file was _already_ closed, as
+	 * kvm_gmem_release() invalidates and nullifies all bindings.
+	 */
+	if (!slot->gmem.file)
+		return;
+
+	file = kvm_gmem_get_file(slot);
+
+	/*
+	 * However, if the file is _being_ closed, then the bindings need to be
+	 * removed as kvm_gmem_release() might not run until after the memslot
+	 * is freed.  Note, modifying the bindings is safe even though the file
+	 * is dying as kvm_gmem_release() nullifies slot->gmem.file under
+	 * slots_lock, and only puts its reference to KVM after destroying all
+	 * bindings.  I.e. reaching this point means kvm_gmem_release() can't
+	 * concurrently destroy the bindings or free the gmem_file.
+	 */
+	if (!file) {
+		__kvm_gmem_unbind(slot, slot->gmem.file->private_data);
+		return;
+	}
+
+	filemap_invalidate_lock(file->f_mapping);
+	__kvm_gmem_unbind(slot, file->private_data);
 	filemap_invalidate_unlock(file->f_mapping);
 
 	fput(file);

base-commit: 4361f5aa8bfcecbab3fc8db987482b9e08115a6a
-- 
2.51.2.1006.ga50a493c49-goog



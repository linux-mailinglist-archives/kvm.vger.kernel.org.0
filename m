Return-Path: <kvm+bounces-68324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 254B6D332D8
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 16:28:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 85CE230142D3
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 15:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E8D337B84;
	Fri, 16 Jan 2026 15:25:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68271EB5E3;
	Fri, 16 Jan 2026 15:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768577106; cv=none; b=Jpvv6ZT/zVA+cohuzPZxhiLGNfKQK6IZ+kgBlSuVfMC1/T+huVwkcrhiWnHH3sj0MYxrKAAPIEM+VGS8c9M8U16URLkLfn17KALrqAXE8vvjN/NAQlxCXHa5ItzFIrHLq7m5+EXbahHJrim17sVTpi2uWi3aFdNCppGQC4k/FTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768577106; c=relaxed/simple;
	bh=NnNILwwEf8q8gYNi0EH0hrKTeQ5anT8JQMysOCMTTqg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HBMk0ZZLg8HGeS81G7rio6+ncEwLN/ARgEJWehWGqAnNRbMCAziGrsjaHBxEep0C21IUCzgCLkUkjDbB3aYRSxCWAAaKf+8BSFDsPFzgzFa0wjafv7myNptiOWcckycCE5XKZ5Pq6SGe4uR6/ppCG8sI1lO77FkxYw9rqtYsxK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [193.43.11.2])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id D6E2723395;
	Fri, 16 Jan 2026 18:15:23 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	kovalev@altlinux.org
Subject: [PATCH] KVM: x86: Add SRCU protection for KVM_GET_SREGS2
Date: Fri, 16 Jan 2026 18:15:23 +0300
Message-Id: <20260116151523.291892-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add SRCU read-side protection to KVM_GET_SREGS2 ioctl handler.

__get_sregs2() may read guest memory when caching PDPTR registers:
__get_sregs2() -> kvm_pdptr_read() -> svm_cache_reg() -> load_pdptrs()
-> kvm_vcpu_read_guest_page() -> kvm_vcpu_gfn_to_memslot()

kvm_vcpu_gfn_to_memslot() dereferences memslots via __kvm_memslots(),
which uses srcu_dereference_check() and requires either kvm->srcu or
kvm->slots_lock to be held. Currently only vcpu->mutex is held,
triggering lockdep warning:

=============================
WARNING: suspicious RCU usage in kvm_vcpu_gfn_to_memslot
6.12.59+ #3 Not tainted
-----------------------------
include/linux/kvm_host.h:1062 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz.5.1717/15100:
 #0: ff1100002f4b00b0 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x1d5/0x1590

Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xf0/0x120 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x1e3/0x270 kernel/locking/lockdep.c:6824
 __kvm_memslots include/linux/kvm_host.h:1062 [inline]
 __kvm_memslots include/linux/kvm_host.h:1059 [inline]
 kvm_vcpu_memslots include/linux/kvm_host.h:1076 [inline]
 kvm_vcpu_gfn_to_memslot+0x518/0x5e0 virt/kvm/kvm_main.c:2617
 kvm_vcpu_read_guest_page+0x27/0x50 virt/kvm/kvm_main.c:3302
 load_pdptrs+0xff/0x4b0 arch/x86/kvm/x86.c:1065
 svm_cache_reg+0x1c9/0x230 arch/x86/kvm/svm/svm.c:1688
 kvm_pdptr_read arch/x86/kvm/kvm_cache_regs.h:141 [inline]
 __get_sregs2 arch/x86/kvm/x86.c:11784 [inline]
 kvm_arch_vcpu_ioctl+0x3e20/0x4aa0 arch/x86/kvm/x86.c:6279
 kvm_vcpu_ioctl+0x856/0x1590 virt/kvm/kvm_main.c:4663
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl fs/ioctl.c:893 [inline]
 __x64_sys_ioctl+0x18b/0x210 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xbd/0x1d0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Cc: stable@vger.kernel.org
Fixes: 6dba94035203 ("KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2")
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
Note 1: commit 85e5ba83c016 ("KVM: x86: Do all post-set CPUID processing
during vCPU creation") in v6.14+ reduces the likelihood of hitting this
path by ensuring proper MMU initialization, but does not eliminate the
requirement for SRCU protection when accessing guest memory.

Note 2: KVM_SET_SREGS2 is not modified because __set_sregs_common()
already acquires SRCU when update_pdptrs=true, which covers the case
when PDPTRs must be loaded from guest memory.
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8acfdfc583a1..73c900c72f31 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6619,7 +6619,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = -ENOMEM;
 		if (!u.sregs2)
 			goto out;
+		kvm_vcpu_srcu_read_lock(vcpu);
 		__get_sregs2(vcpu, u.sregs2);
+		kvm_vcpu_srcu_read_unlock(vcpu);
 		r = -EFAULT;
 		if (copy_to_user(argp, u.sregs2, sizeof(struct kvm_sregs2)))
 			goto out;
-- 
2.50.1



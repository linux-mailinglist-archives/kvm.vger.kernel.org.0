Return-Path: <kvm+bounces-69023-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ODD4CBr2c2nG0QAAu9opvQ
	(envelope-from <kvm+bounces-69023-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:28:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B097B27A
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:28:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2D0483028348
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 22:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C90982D8DDF;
	Fri, 23 Jan 2026 22:28:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C55133985;
	Fri, 23 Jan 2026 22:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769207296; cv=none; b=QoZNJsTFTh9T0C65whZ3lZoIA9gsg6IdKbp8VYU+WQJsWU9++C3YFYXnRlJ5fN8sz53KU8ZtdR/SVb5jfOxzScT6ltYfGbN2pbwo77c8uIQ0L70YP3upgl+NW63mcJC1n0XSzfaEm6jcBZYiXolvmevYdRR1iaeA9/JT7O7w9bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769207296; c=relaxed/simple;
	bh=VWRZeQ56cAdk8X0xitzdlPQGNbd378aNkZE0Bh8Vb64=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k/RlM+YumA4ifOqe6lRbOUe1mxK3/oDk3C1uRdSCN5HYbGjvpkEvIvYxO/F1L0QoZB27UenO7pIpU71WeV/rBtPIUb/4cxg6ayvZdChAeZLjtz0K/yHv3NTQH8PHsJhfueIQw19a3zC9sM2ZKyKdiAQd8JfmX5FS1BKkYg6Wcsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [193.43.11.2])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id C56912339E;
	Sat, 24 Jan 2026 01:28:02 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	kovalev@altlinux.org
Subject: [PATCH v2] KVM: x86: Add SRCU protection for reading PDPTRs in __get_sregs2()
Date: Sat, 24 Jan 2026 01:28:01 +0300
Message-Id: <20260123222801.646123-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69023-lists,kvm=lfdr.de];
	DMARC_NA(0.00)[altlinux.org];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[kovalev@altlinux.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[altlinux.org:mid,altlinux.org:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linuxtesting.org:url]
X-Rspamd-Queue-Id: C0B097B27A
X-Rspamd-Action: no action

Add SRCU read-side protection when reading PDPTR registers in
__get_sregs2().

Reading PDPTRs may trigger access to guest memory:
kvm_pdptr_read() -> svm_cache_reg() -> load_pdptrs() ->
kvm_vcpu_read_guest_page() -> kvm_vcpu_gfn_to_memslot()

kvm_vcpu_gfn_to_memslot() dereferences memslots via __kvm_memslots(),
which uses srcu_dereference_check() and requires either kvm->srcu or
kvm->slots_lock to be held. Currently only vcpu->mutex is held,
triggering lockdep warning:

=============================
WARNING: suspicious RCU usage in kvm_vcpu_gfn_to_memslot
6.12.59+ #3 Not tainted

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

Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Fixes: 6dba94035203 ("KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2")
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
v2: Move SRCU lock inside __get_sregs2() as suggested by Sean Christopherson

v1: https://lore.kernel.org/all/20260116151523.291892-1-kovalev@altlinux.org/
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8acfdfc583a1..f2aa2986df86 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12166,9 +12166,11 @@ static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
 		return;
 
 	if (is_pae_paging(vcpu)) {
+		kvm_vcpu_srcu_read_lock(vcpu);
 		for (i = 0 ; i < 4 ; i++)
 			sregs2->pdptrs[i] = kvm_pdptr_read(vcpu, i);
 		sregs2->flags |= KVM_SREGS2_FLAGS_PDPTRS_VALID;
+		kvm_vcpu_srcu_read_unlock(vcpu);
 	}
 }
 
-- 
2.50.1



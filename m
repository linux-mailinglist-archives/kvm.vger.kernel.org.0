Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D532C649
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 14:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfE1MRr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 08:17:47 -0400
Received: from 3.mo173.mail-out.ovh.net ([46.105.34.1]:50488 "EHLO
        3.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfE1MRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 08:17:47 -0400
Received: from player692.ha.ovh.net (unknown [10.109.160.62])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id C674A10AB89
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 14:17:44 +0200 (CEST)
Received: from kaod.org (deibp9eh1--blueice1n4.emea.ibm.com [195.212.29.166])
        (Authenticated sender: clg@kaod.org)
        by player692.ha.ovh.net (Postfix) with ESMTPSA id 754D763FC2D1;
        Tue, 28 May 2019 12:17:36 +0000 (UTC)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     Paul Mackerras <paulus@samba.org>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH 2/2] KVM: PPC: Book3S HV: XIVE: take the srcu read lock when accessing memslots
Date:   Tue, 28 May 2019 14:17:16 +0200
Message-Id: <20190528121716.18419-3-clg@kaod.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190528121716.18419-1-clg@kaod.org>
References: <20190528121716.18419-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 2803490769338600308
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedghedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to Documentation/virtual/kvm/locking.txt, the srcu read lock
should be taken when accessing the memslots of the VM. The XIVE KVM
device needs to do so when configuring the page of the OS event queue
of vCPU for a given priority and when marking the same page dirty
before migration.

This avoids warnings such as :

[  208.224882] =============================
[  208.224884] WARNING: suspicious RCU usage
[  208.224889] 5.2.0-rc2-xive+ #47 Not tainted
[  208.224890] -----------------------------
[  208.224894] ../include/linux/kvm_host.h:633 suspicious rcu_dereference_check() usage!
[  208.224896]
               other info that might help us debug this:

[  208.224898]
               rcu_scheduler_active = 2, debug_locks = 1
[  208.224901] no locks held by qemu-system-ppc/3923.
[  208.224902]
               stack backtrace:
[  208.224907] CPU: 64 PID: 3923 Comm: qemu-system-ppc Kdump: loaded Not tainted 5.2.0-rc2-xive+ #47
[  208.224909] Call Trace:
[  208.224918] [c000200cdd98fa30] [c000000000be1934] dump_stack+0xe8/0x164 (unreliable)
[  208.224924] [c000200cdd98fa80] [c0000000001aec80] lockdep_rcu_suspicious+0x110/0x180
[  208.224935] [c000200cdd98fb00] [c0080000075933a0] gfn_to_memslot+0x1c8/0x200 [kvm]
[  208.224943] [c000200cdd98fb40] [c008000007599600] gfn_to_pfn+0x28/0x60 [kvm]
[  208.224951] [c000200cdd98fb70] [c008000007599658] gfn_to_page+0x20/0x40 [kvm]
[  208.224959] [c000200cdd98fb90] [c0080000075b495c] kvmppc_xive_native_set_attr+0x8b4/0x1480 [kvm]
[  208.224967] [c000200cdd98fca0] [c00800000759261c] kvm_device_ioctl_attr+0x64/0xb0 [kvm]
[  208.224974] [c000200cdd98fcf0] [c008000007592730] kvm_device_ioctl+0xc8/0x110 [kvm]
[  208.224979] [c000200cdd98fd10] [c000000000433a24] do_vfs_ioctl+0xd4/0xcd0
[  208.224981] [c000200cdd98fdb0] [c000000000434724] ksys_ioctl+0x104/0x120
[  208.224984] [c000200cdd98fe00] [c000000000434768] sys_ioctl+0x28/0x80
[  208.224988] [c000200cdd98fe20] [c00000000000b888] system_call+0x5c/0x70
legoater@boss01:~$

Fixes: 13ce3297c576 ("KVM: PPC: Book3S HV: XIVE: Add controls for the EQ configuration")
Fixes: e6714bd1671d ("KVM: PPC: Book3S HV: XIVE: Add a control to dirty the XIVE EQ pages")
Signed-off-by: Cédric Le Goater <clg@kaod.org>
---
 arch/powerpc/kvm/book3s_xive_native.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index fec3b85411ef..8b762e3ebbc5 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -535,6 +535,7 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
 	struct xive_q *q;
 	gfn_t gfn;
 	unsigned long page_size;
+	int srcu_idx;
 
 	/*
 	 * Demangle priority/server tuple from the EQ identifier
@@ -610,20 +611,24 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
 		return -EINVAL;
 	}
 
+	srcu_idx = srcu_read_lock(&kvm->srcu);
 	gfn = gpa_to_gfn(kvm_eq.qaddr);
 	page = gfn_to_page(kvm, gfn);
 	if (is_error_page(page)) {
+		srcu_read_unlock(&kvm->srcu, srcu_idx);
 		pr_err("Couldn't get queue page %llx!\n", kvm_eq.qaddr);
 		return -EINVAL;
 	}
 
 	page_size = kvm_host_page_size(kvm, gfn);
 	if (1ull << kvm_eq.qshift > page_size) {
+		srcu_read_unlock(&kvm->srcu, srcu_idx);
 		pr_warn("Incompatible host page size %lx!\n", page_size);
 		return -EINVAL;
 	}
 
 	qaddr = page_to_virt(page) + (kvm_eq.qaddr & ~PAGE_MASK);
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
 
 	/*
 	 * Backup the queue page guest address to the mark EQ page
@@ -854,6 +859,7 @@ static int kvmppc_xive_native_vcpu_eq_sync(struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_xive_vcpu *xc = vcpu->arch.xive_vcpu;
 	unsigned int prio;
+	int srcu_idx;
 
 	if (!xc)
 		return -ENOENT;
@@ -865,7 +871,9 @@ static int kvmppc_xive_native_vcpu_eq_sync(struct kvm_vcpu *vcpu)
 			continue;
 
 		/* Mark EQ page dirty for migration */
+		srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 		mark_page_dirty(vcpu->kvm, gpa_to_gfn(q->guest_qaddr));
+		srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
 	}
 	return 0;
 }
-- 
2.21.0


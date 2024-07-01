Return-Path: <kvm+bounces-20743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FC3F91D552
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 02:21:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 429ED1C209E8
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 00:21:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30CDC4A3E;
	Mon,  1 Jul 2024 00:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nL7ym+if"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5422B4315D;
	Mon,  1 Jul 2024 00:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719792883; cv=none; b=i9lRzbpNkb2ulKWlMCzrQWLczAgCSXTLPah+VE7mavLUIAwxx23KdFDRSpF3nmGkdhtCY10ekfJlGyIPnBtlmM6WcmNEvDRROV6BTZMqxKoPZSSEN1dvdi7mr0E0J/md7qdZP9MRHnjeUSYX+PrfuXjrCBWGssTfSFt7kbuamVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719792883; c=relaxed/simple;
	bh=bTgEOnmPgOyG6B2nRHRseuUUfUXtcdGR4HmyiaqhKpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kT1EuHfkHQmsUOl98jP2nY7ImIWVmCBbP+Y0fGKEHrZEirBAnmcy2R7t6+Eh9VFAYHuvov75ExOEPNzL2/qV/JIMXhAxIhSuWdluGP+gi1LH+EqObVBlHq6dkWYOMwT7oZku3Xk7S/nCbnbPqYaKgB9QxLRwx62lw95mK+2ZMVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nL7ym+if; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B54C4AF0A;
	Mon,  1 Jul 2024 00:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719792882;
	bh=bTgEOnmPgOyG6B2nRHRseuUUfUXtcdGR4HmyiaqhKpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nL7ym+if/wWjpbH8+D4wbKdo7kesJmMBfq5inh2cUKKeO1ugsPRTHn8ZgywgLOaZi
	 vExHCyizMXhpDOcuuh5oJHrw8F56Ap21xj6NaZnM7XGsHJnMS8WLHLobuwC9ZwREFo
	 pnk8NTTQ+AfGJCIqRI1fVhvyiz4ZgThLJMDcQfP9kvfPGM2WlqVucP2rB8hhb9mR8y
	 /52C/xLQ0cOtV89QnVQdcAphAX1o7foODkcZ8Wh4z/r1hXyycyVfIWCC9wCXXvpOKw
	 pWwS2FKUL+G0yme3T67jr60HM4tcIRNvNfcatfH7sljWnjhfJ/CakUsvsVbL1bZ4Ta
	 1O9al+fjWv0rg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 2/5] KVM: PPC: Book3S HV: Prevent UAF in kvm_spapr_tce_attach_iommu_group()
Date: Sun, 30 Jun 2024 20:14:30 -0400
Message-ID: <20240701001438.2921324-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240701001438.2921324-1-sashal@kernel.org>
References: <20240701001438.2921324-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.161
Content-Transfer-Encoding: 8bit

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit a986fa57fd81a1430e00b3c6cf8a325d6f894a63 ]

Al reported a possible use-after-free (UAF) in kvm_spapr_tce_attach_iommu_group().

It looks up `stt` from tablefd, but then continues to use it after doing
fdput() on the returned fd. After the fdput() the tablefd is free to be
closed by another thread. The close calls kvm_spapr_tce_release() and
then release_spapr_tce_table() (via call_rcu()) which frees `stt`.

Although there are calls to rcu_read_lock() in
kvm_spapr_tce_attach_iommu_group() they are not sufficient to prevent
the UAF, because `stt` is used outside the locked regions.

With an artifcial delay after the fdput() and a userspace program which
triggers the race, KASAN detects the UAF:

  BUG: KASAN: slab-use-after-free in kvm_spapr_tce_attach_iommu_group+0x298/0x720 [kvm]
  Read of size 4 at addr c000200027552c30 by task kvm-vfio/2505
  CPU: 54 PID: 2505 Comm: kvm-vfio Not tainted 6.10.0-rc3-next-20240612-dirty #1
  Hardware name: 8335-GTH POWER9 0x4e1202 opal:skiboot-v6.5.3-35-g1851b2a06 PowerNV
  Call Trace:
    dump_stack_lvl+0xb4/0x108 (unreliable)
    print_report+0x2b4/0x6ec
    kasan_report+0x118/0x2b0
    __asan_load4+0xb8/0xd0
    kvm_spapr_tce_attach_iommu_group+0x298/0x720 [kvm]
    kvm_vfio_set_attr+0x524/0xac0 [kvm]
    kvm_device_ioctl+0x144/0x240 [kvm]
    sys_ioctl+0x62c/0x1810
    system_call_exception+0x190/0x440
    system_call_vectored_common+0x15c/0x2ec
  ...
  Freed by task 0:
   ...
   kfree+0xec/0x3e0
   release_spapr_tce_table+0xd4/0x11c [kvm]
   rcu_core+0x568/0x16a0
   handle_softirqs+0x23c/0x920
   do_softirq_own_stack+0x6c/0x90
   do_softirq_own_stack+0x58/0x90
   __irq_exit_rcu+0x218/0x2d0
   irq_exit+0x30/0x80
   arch_local_irq_restore+0x128/0x230
   arch_local_irq_enable+0x1c/0x30
   cpuidle_enter_state+0x134/0x5cc
   cpuidle_enter+0x6c/0xb0
   call_cpuidle+0x7c/0x100
   do_idle+0x394/0x410
   cpu_startup_entry+0x60/0x70
   start_secondary+0x3fc/0x410
   start_secondary_prolog+0x10/0x14

Fix it by delaying the fdput() until `stt` is no longer in use, which
is effectively the entire function. To keep the patch minimal add a call
to fdput() at each of the existing return paths. Future work can convert
the function to goto or __cleanup style cleanup.

With the fix in place the test case no longer triggers the UAF.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Closes: https://lore.kernel.org/all/20240610024437.GA1464458@ZenIV/
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240614122910.3499489-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_64_vio.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 3cb2e05a7ee83..a8e5eefee794f 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -117,14 +117,16 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 	}
 	rcu_read_unlock();
 
-	fdput(f);
-
-	if (!found)
+	if (!found) {
+		fdput(f);
 		return -EINVAL;
+	}
 
 	table_group = iommu_group_get_iommudata(grp);
-	if (WARN_ON(!table_group))
+	if (WARN_ON(!table_group)) {
+		fdput(f);
 		return -EFAULT;
+	}
 
 	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
 		struct iommu_table *tbltmp = table_group->tables[i];
@@ -145,8 +147,10 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 			break;
 		}
 	}
-	if (!tbl)
+	if (!tbl) {
+		fdput(f);
 		return -EINVAL;
+	}
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(stit, &stt->iommu_tables, next) {
@@ -157,6 +161,7 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 			/* stit is being destroyed */
 			iommu_tce_table_put(tbl);
 			rcu_read_unlock();
+			fdput(f);
 			return -ENOTTY;
 		}
 		/*
@@ -164,6 +169,7 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 		 * its KVM reference counter and can return.
 		 */
 		rcu_read_unlock();
+		fdput(f);
 		return 0;
 	}
 	rcu_read_unlock();
@@ -171,6 +177,7 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 	stit = kzalloc(sizeof(*stit), GFP_KERNEL);
 	if (!stit) {
 		iommu_tce_table_put(tbl);
+		fdput(f);
 		return -ENOMEM;
 	}
 
@@ -179,6 +186,7 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 
 	list_add_rcu(&stit->next, &stt->iommu_tables);
 
+	fdput(f);
 	return 0;
 }
 
-- 
2.43.0



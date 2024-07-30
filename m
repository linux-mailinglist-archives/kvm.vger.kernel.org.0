Return-Path: <kvm+bounces-22682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5474F941629
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 17:57:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 868721C22F26
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 15:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4226F1BA880;
	Tue, 30 Jul 2024 15:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KloSbefG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692E429A2;
	Tue, 30 Jul 2024 15:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355011; cv=none; b=FGNm0FTe28COMfAT4M3EryZY2gDJNy3/+05PWTF0CGy6iH4OvZfJtrY3S6iPm21wUcrdzX7TbN2JfYfmDqsENLaPczcuFxuk0tpySzljL8IUc8FOe4EXmCiwf/J1z1RE7AHtCLBb6lmx/i3DoF22BpC9YYR0L7BAWIWm/C2wO8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355011; c=relaxed/simple;
	bh=NwxPPUduOd4UYeuGxtrrawyvduj3Rfr54xa8BTINUL8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KdZu2N3BgYmixQtHF/7qnECrtkaCMgTRVRO2lN4BlyH8biai/hSwaWlJT14PB8xi4/fErXCYoGBioRDxJpj6LOk/lgiaSMfjUlkOhShMvNphSrx7qILPLUryhXqec1HTk0nJfoCgg20ST6qZy1A1GIfdf2UolIsG/i3EhCRz9II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KloSbefG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25D3C32782;
	Tue, 30 Jul 2024 15:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722355011;
	bh=NwxPPUduOd4UYeuGxtrrawyvduj3Rfr54xa8BTINUL8=;
	h=From:To:Cc:Subject:Date:From;
	b=KloSbefGq6eTp3plC8iMf2GcsuBesky1HKZAXzQJpzWzh0ILWsIqoC0/SKjTkgj+1
	 qepI5/xPYFNYxwXHKA5ijBeFBGy2UE7lspnkIindMibnIym5kVGDtdEdb7T2I31l+6
	 wHXdajr+7W96WzOahcKWjVCnmCyLf/DDyDSnpIhG5A8Ksp44PifBvcs38y7bXllDwV
	 Ooehd4BmRoUm2H3KizjmFoYhsCqZcPZfCP3k+FCuY9EfplADnbyck9kWYa3gL0+BFd
	 HGEsFp1tq2Ik2pMt7yoQdtGL8Ubn6W6/mdcCF0iYxG2koW15Z669qCI/7RxMbGQSgz
	 sI5hIrBrXeJFw==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Alexander Potapenko <glider@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH] KVM: Fix error path in kvm_vm_ioctl_create_vcpu() on xa_store() failure
Date: Tue, 30 Jul 2024 16:56:46 +0100
Message-Id: <20240730155646.1687-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the xa_store() fails in kvm_vm_ioctl_create_vcpu() then we shouldn't
drop the reference to the 'struct kvm' because the vCPU fd has been
installed and will take care of the refcounting.

This was found by inspection, but forcing the xa_store() to fail
confirms the problem:

 | Unable to handle kernel paging request at virtual address ffff800080ecd960
 | Call trace:
 |  _raw_spin_lock_irq+0x2c/0x70
 |  kvm_irqfd_release+0x24/0xa0
 |  kvm_vm_release+0x1c/0x38
 |  __fput+0x88/0x2ec
 |  ____fput+0x10/0x1c
 |  task_work_run+0xb0/0xd4
 |  do_exit+0x210/0x854
 |  do_group_exit+0x70/0x98
 |  get_signal+0x6b0/0x73c
 |  do_signal+0xa4/0x11e8
 |  do_notify_resume+0x60/0x12c
 |  el0_svc+0x64/0x68
 |  el0t_64_sync_handler+0x84/0xfc
 |  el0t_64_sync+0x190/0x194
 | Code: b9000909 d503201f 2a1f03e1 52800028 (88e17c08)

Add a new label to the error path so that we can branch directly to the
xa_release() if the xa_store() fails.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michal Luczaj <mhal@rbox.co>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 virt/kvm/kvm_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0788d0a72cc..b80dd8cead8c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4293,7 +4293,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 
 	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
 		r = -EINVAL;
-		goto kvm_put_xa_release;
+		goto err_xa_release;
 	}
 
 	/*
@@ -4310,6 +4310,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 
 kvm_put_xa_release:
 	kvm_put_kvm_no_destroy(kvm);
+err_xa_release:
 	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
-- 
2.46.0.rc1.232.g9752f9e123-goog



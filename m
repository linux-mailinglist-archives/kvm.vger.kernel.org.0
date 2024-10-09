Return-Path: <kvm+bounces-28254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97922996F5A
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:13:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50730283DDE
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 15:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC9551DFD85;
	Wed,  9 Oct 2024 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MjSjx6RX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E9B1E0DAB
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728486307; cv=none; b=c4hUlO2WMqlMxLDhU51XE0ivksAzULdtqp60HrYMc1n9xE+dqKrF1hF2sqBSpTUWAc+rS/rICnk9y4RVB/hPEyQlkiYliD3np0tDdQuUknUYWVeOdTErvPdJD/ZMo7ThAwjadcvdsLtR10Tq8cPZ/aPcd2EDr4UW1QZoxHjOvkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728486307; c=relaxed/simple;
	bh=tVLsRpJbZXDe+kzv+FAqKCNsZbBglsLvMCPd+8nr58w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BAW+O8D2JOphZoTxeVRYpj2YLb0riBFHxPxpwezfa5aw9dIvU0K2WyaLTof+5r2DUmz5wudFhaKWxx20qZOXCLkPkulP1RfvDbd+eQtyQ7kM9lEtPl4GNgbFxsumWXqjoinj6cIg6IbCRSqNB+RqNF+k8Tvq1nCp097p1m6xQX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MjSjx6RX; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-20afe0063e0so63025515ad.3
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728486306; x=1729091106; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l2sEte6w0yql7C3jUnlweM/OP/SrvH1RtBMyVo9Nnx0=;
        b=MjSjx6RXx3hFf6Lt7uwt8NMX1Y1V1mDExzzxVZNAqwQO8gXvfvqb4wwVCxpbkgoaWp
         0cFUjy1wcgDzaHvzdlpCbTwbwD6m8TfH3P4QWRHz+aTMjQF7WRo0EaVAnSbhKquM76cQ
         tyALs1ee/WJQ92q9gnFBI0YZn0SZr/aXZPBqFUsmceDfIg/DiAPpfpvBYLqlTCmv7IV+
         iH7JaIwIu5hphxxIY19sYjCWL2ol4rp0aH2hwxKCJ9vvyimCXkpu3lD27dteh2x7na0H
         C6GWZEBoA7EHYgaFWMTxTryr8jHbyBig+FBYgazpQetE3rWiq48Fd0fB1W25emSloKbB
         XBYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728486306; x=1729091106;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l2sEte6w0yql7C3jUnlweM/OP/SrvH1RtBMyVo9Nnx0=;
        b=YQkQbLjgu1Ki+n4uXYyCINidwEKhzoieVGkuen62ek9kf9TB12QtQZ5tPG/6ncM8SP
         z9SODIkbzvJYr0JvwHhbg9l/EJEj8/z9Pm0kGXCMdPhGMyov8CD6np4TaLE+bRcO7jIQ
         qOyXdEX6myn5q9y0K8YfXeolokb6kHIJtw+vhxAYi1HQNJW1rwQYqtMRZmnnvqCPzGm0
         ocGPOrIHVxZtA7ZQQakOcFSt6zMQPtcgdDTPShJ7Cp4Smmqdd0mVDuxaL6uqXM8OP1kv
         DckoeTnVDpVFolW973M2AbIyzkToGM5XZPmG5ppdilkqRcKlGxsz+EmM+8BQU9X4FFTu
         cM4g==
X-Gm-Message-State: AOJu0Yzl7NiQN8xM50PLsdqeQmaOOuV8I9UwsF+g6Xv3BUxeh2dZ3PEO
	BgzlevJ5lvlQrrG265/Gw1s3UaYlZ3Mx3PchTL5kkS9qnTqEJD/lxdgTI60xZGYsLdrQz+didL8
	D6Q==
X-Google-Smtp-Source: AGHT+IELCX1qYO/0MUAuBAKQDNuzkJraNga4+zHZoKeuBnW8kE0C0ViynAYb38PizCcjLvDCYymXpEx60MI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:c40f:b0:20c:510:f81b with SMTP id
 d9443c01a7336-20c6371d90bmr223375ad.4.1728486305490; Wed, 09 Oct 2024
 08:05:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:04:53 -0700
In-Reply-To: <20241009150455.1057573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009150455.1057573-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009150455.1057573-5-seanjc@google.com>
Subject: [PATCH 4/6] Revert "KVM: Fix vcpu_array[0] races"
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Michal Luczaj <mhal@rbox.co>, Sean Christopherson <seanjc@google.com>, 
	Alexander Potapenko <glider@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Now that KVM loads from vcpu_array if and only if the target index is
valid with respect to online_vcpus, i.e. now that it is safe to erase a
not-fully-onlined vCPU entry, revert to storing into vcpu_array before
success is guaranteed.

If xa_store() fails, which _should_ be impossible, then putting the vCPU's
reference to 'struct kvm' results in a refcounting bug as the vCPU fd has
been installed and owns the vCPU's reference.

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

Practically speaking, this is a non-issue as xa_store() can't fail, absent
a nasty kernel bug.  But the code is visually jarring and technically
broken.

This reverts commit afb2acb2e3a32e4d56f7fbd819769b98ed1b7520.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michal Luczaj <mhal@rbox.co>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fca9f74e9544..f081839521ef 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4283,7 +4283,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	}
 
 	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
-	r = xa_reserve(&kvm->vcpu_array, vcpu->vcpu_idx, GFP_KERNEL_ACCOUNT);
+	r = xa_insert(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
+	BUG_ON(r == -EBUSY);
 	if (r)
 		goto unlock_vcpu_destroy;
 
@@ -4298,12 +4299,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	kvm_get_kvm(kvm);
 	r = create_vcpu_fd(vcpu);
 	if (r < 0)
-		goto kvm_put_xa_release;
-
-	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
-		r = -EINVAL;
-		goto kvm_put_xa_release;
-	}
+		goto kvm_put_xa_erase;
 
 	/*
 	 * Pairs with smp_rmb() in kvm_get_vcpu.  Store the vcpu
@@ -4318,10 +4314,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	kvm_create_vcpu_debugfs(vcpu);
 	return r;
 
-kvm_put_xa_release:
+kvm_put_xa_erase:
 	mutex_unlock(&vcpu->mutex);
 	kvm_put_kvm_no_destroy(kvm);
-	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
+	xa_erase(&kvm->vcpu_array, vcpu->vcpu_idx);
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
 	kvm_dirty_ring_free(&vcpu->dirty_ring);
-- 
2.47.0.rc0.187.ge670bccf7e-goog



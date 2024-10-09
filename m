Return-Path: <kvm+bounces-28253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BA3C5996F58
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:13:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11277B23D7D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 15:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 006941E0DEB;
	Wed,  9 Oct 2024 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TGgDgmb7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0D61DFD85
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728486307; cv=none; b=sNm3BBLOai4RuDe2liQHgWiG7LB/Hw7+nb1/8DPU+8CmFC3WFBlC1GssbKVij4+lWAJEkhvBsAln2J78yBIqi1jcZJd4qMnhXDZUUuhgjFimFWzWLn3z38oDtfr0SLYMw7WAZAreJ1vtSaEGr+9odi62TdGMA/Nbiqp376q/skA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728486307; c=relaxed/simple;
	bh=UUOuALX/8jUEKOE5MK93z/TIwR6ptoN4Q45Bp2t7r80=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EssHnnCQLgsKkxUn4Tl1jqF+DfQvC5CFFY1QCvE8wrMdhkH4eOCE9d/R133YG4iu7mU/tjtqW7PP8UBKfK+qRUhopxcNw9tedzXF5JgnjUVjnKX4QqrZ+fdOBAKBID+AMAQj0UrGZ2Xgc4ORLcFOr9d23ysFZ5PftC3F9eqH2y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TGgDgmb7; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e23ee3110fso128334147b3.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728486303; x=1729091103; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5SrGD6ntAFoOH+8A+yPE5xRGZ7AhTh5r8ioRJwoyvss=;
        b=TGgDgmb7U4/+O8I6VcHU5l+lNX8QJ3BOyKQJQzXZ5+KIainT0W0kcJcZ92lXRPmAv6
         ew33grIfQl7wTGIgJ8z7RXF4FrMWmW1qF2XX+/Bps4RPAyM3C3T63ynEI+jauCeWCLPH
         MDudM0l6sf1Wtr1fOBVbhJfnebNaUkdqWD6V8+jj1CYu5OYzSz5PmM1ODOQjn3aq6BwV
         Pb/oMvBRaYPLLpkHoPg27+CI9sQYdgbcgTNdw4HIHZwPtWpl3SzCvYe3Z9W5ka1RhJZz
         vbikjorCUyAz5tmYN1TGSNdu6F3OQF5sEN48aA3cEki27gLCB5sfis+jC/JOWl4VUQ6f
         bPMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728486303; x=1729091103;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5SrGD6ntAFoOH+8A+yPE5xRGZ7AhTh5r8ioRJwoyvss=;
        b=L+rf1zwbWvHmXu+nF74YXbmzVTy4XPofF3NR/kjOgJBxssyHXifbroGdxt03IYl9GL
         OS6iT4YocKIX3ga+v9Logl9npTAeyRKwj2g545qa3Dzhl6N2LWJImpjVMX4/l6C68UXu
         /7pHBHP7qwDq+WfyCwVUu1+KzT7tPEIvKKjMB/zhNu2Ygo8SQkr/t/QVClCN1TLLohYr
         Ysa5I+kJUnuwCwAaeJYM0dlkRk3sMmCK9NRpG0liZbebLKsACwG/W0R1Kri5kYgqPnOj
         N5ewADCDcEgzM6BJfonELlQevPg1YSxud7e0Fktk37ZCAr6TJAG0GHV1wLyglGLYctfr
         dDSw==
X-Gm-Message-State: AOJu0YxyAb7oW+4jrSELfYrIrxsaoJ+BYFcAUWVZXJ2xtqR9GYvw4MUA
	JUlOeUNewvx8P9w9mtHWMB2VMIQ1i7UXBcJupmSrl+tPITv6v/+jMiS9ASoSw6ml21Vcw48Y7Zv
	qWw==
X-Google-Smtp-Source: AGHT+IFedXDgPxwolm1IOTnRjA9oTcL70vgsBXdT7cV8n0QPoljgzOxfYmHoJ/QpWjSoaCiWMtRKhm2aykA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3382:b0:6e2:4b3:ee22 with SMTP id
 00721157ae682-6e32216166cmr582417b3.6.1728486303499; Wed, 09 Oct 2024
 08:05:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:04:52 -0700
In-Reply-To: <20241009150455.1057573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009150455.1057573-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009150455.1057573-4-seanjc@google.com>
Subject: [PATCH 3/6] KVM: Grab vcpu->mutex across installing the vCPU's fd and
 bumping online_vcpus
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Michal Luczaj <mhal@rbox.co>, Sean Christopherson <seanjc@google.com>, 
	Alexander Potapenko <glider@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"

During vCPU creation, acquire vcpu->mutex prior to exposing the vCPU to
userspace, and hold the mutex until online_vcpus is bumped, i.e. until the
vCPU is fully online from KVM's perspective.

To ensure asynchronous vCPU ioctls also wait for the vCPU to come online,
explicitly check online_vcpus at the start of kvm_vcpu_ioctl(), and take
the vCPU's mutex to wait if necessary (having to wait for any ioctl should
be exceedingly rare, i.e. not worth optimizing).

Reported-by: Will Deacon <will@kernel.org>
Reported-by: Michal Luczaj <mhal@rbox.co>
Link: https://lore.kernel.org/all/20240730155646.1687-1-will@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 47 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 05cbb2548d99..fca9f74e9544 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4287,7 +4287,14 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	if (r)
 		goto unlock_vcpu_destroy;
 
-	/* Now it's all set up, let userspace reach it */
+	/*
+	 * Now it's all set up, let userspace reach it.  Grab the vCPU's mutex
+	 * so that userspace can't invoke vCPU ioctl()s until the vCPU is fully
+	 * visible (per online_vcpus), e.g. so that KVM doesn't get tricked
+	 * into a NULL-pointer dereference because KVM thinks the _current_
+	 * vCPU doesn't exist.
+	 */
+	mutex_lock(&vcpu->mutex);
 	kvm_get_kvm(kvm);
 	r = create_vcpu_fd(vcpu);
 	if (r < 0)
@@ -4304,6 +4311,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	 */
 	smp_wmb();
 	atomic_inc(&kvm->online_vcpus);
+	mutex_unlock(&vcpu->mutex);
 
 	mutex_unlock(&kvm->lock);
 	kvm_arch_vcpu_postcreate(vcpu);
@@ -4311,6 +4319,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	return r;
 
 kvm_put_xa_release:
+	mutex_unlock(&vcpu->mutex);
 	kvm_put_kvm_no_destroy(kvm);
 	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
 unlock_vcpu_destroy:
@@ -4437,6 +4446,33 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 }
 #endif
 
+static int kvm_wait_for_vcpu_online(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	/*
+	 * In practice, this happy path will always be taken, as a well-behaved
+	 * VMM will never invoke a vCPU ioctl() before KVM_CREATE_VCPU returns.
+	 */
+	if (likely(vcpu->vcpu_idx < atomic_read(&kvm->online_vcpus)))
+		return 0;
+
+	/*
+	 * Acquire and release the vCPU's mutex to wait for vCPU creation to
+	 * complete (kvm_vm_ioctl_create_vcpu() holds the mutex until the vCPU
+	 * is fully online).
+	 */
+	if (mutex_lock_killable(&vcpu->mutex))
+		return -EINTR;
+
+	mutex_unlock(&vcpu->mutex);
+
+	if (WARN_ON_ONCE(!kvm_get_vcpu(kvm, vcpu->vcpu_idx)))
+		return -EIO;
+
+	return 0;
+}
+
 static long kvm_vcpu_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -4452,6 +4488,15 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
 		return -EINVAL;
 
+	/*
+	 * Wait for the vCPU to be online before handling the ioctl(), as KVM
+	 * assumes the vCPU is reachable via vcpu_array, i.e. may dereference
+	 * a NULL pointer if userspace invokes an ioctl() before KVM is ready.
+	 */
+	r = kvm_wait_for_vcpu_online(vcpu);
+	if (r)
+		return r;
+
 	/*
 	 * Some architectures have vcpu ioctls that are asynchronous to vcpu
 	 * execution; mutex_lock() would break them.
-- 
2.47.0.rc0.187.ge670bccf7e-goog



Return-Path: <kvm+bounces-19177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D88D6901F6E
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 12:31:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 781B6285A86
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 10:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A2AE78C6D;
	Mon, 10 Jun 2024 10:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XiS5Den/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27142C190
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 10:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718015487; cv=none; b=ZnQxE/d14z5zWH/oAUbqKjARdJA1JvNzLJA7CuaeiIitHDeIch6iYWtT9su4y7TFDOymkDFPrN6B6KQVjahRtpwnOUiPgojNRV9504HRMumPwCdOCvvvI1vS1TyVS0y1t3cjvqDlKhHI5uF2aIrhmELOxBY7+SPCkUVmLPyFV4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718015487; c=relaxed/simple;
	bh=WNuuhWtO3rE/jKY1dq1NOrZRmv4qV2KwCsR2xXMQ/M4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dzg2jlOhqOtWeX6pFIYj2yLYpPn9lDf5cmtEUVH2vBmFwfb4UUYukwgAbf2XxOVN7rFG60yCij8y5+xTAVs8bvCzQ+3EzYxqykMX5XkSf4rYoh+PlUnbQF49Q13MuqDN08A1Bu5TWjLImmEgdyjRBkzu1ZJJE5HBsyc1EbrqNPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XiS5Den/; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4217990f997so16176935e9.2
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 03:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718015484; x=1718620284; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=//EWRjUz3u1rUIjLwDjk8bwSaOugI3kbrvouh/nUuR0=;
        b=XiS5Den/PdswCQvTnlLoC0sQxyrjCkCn8JMp84nquYFV+JBzfaVfyEVhnmQNLKnj3o
         tZ5FZqjOaCqdofre7PUCILHqVbKrLisgyxgX+iJiRX+6sz5xOJx1nb7mO+2bbTfxP/62
         35+9VKMf0CMR0xYr1VsHHfk/epv+Ij2mJQYAKt4jMQ9an6zbc8Nv+1CumR3ClJubgRLA
         qwip9JjXkw3gWQ/JE/DhzwJ76qK+fFvwLrdCxcY4wbyCBW3z2qU9c87Vq2ImQm4G8Gbn
         V1L9d5F8EZLF1MxYL8DT4pjfFXoLTGMBduyOY52aqlWyD0Uu+GZr+RNXbvoC5HmIEUuQ
         47aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718015484; x=1718620284;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=//EWRjUz3u1rUIjLwDjk8bwSaOugI3kbrvouh/nUuR0=;
        b=Kq8W3rYpPc6FICxgdu02DUkdYkonxru1r71Rc7GIPAZkkcxSotAd48wyCiVbF9+t/G
         MTUohbO2I+NvmW0GJMYZ9JQJhLWBc3VHYoSxO6ZO3fP0go1D9E1O2hxIoEAzaCof5XT+
         p8+N2QjJpJU0ClpTqLovi0Wnib+mOJdsALmLRQwLO3LinkH4I8NGWZTOl7M9TMXRX9HI
         srg8n4x72q8ZH1DQUOk0kry6KD/P0S4EJMOPTt5MLH7LnENyVqa8ZOvUWn2Y8sJ8x3FC
         ABEO8AHkCWtcPODB/9uDXr0XCo1EvaXJPJT2gEkKcxPLb4CHZDYt6kvX7W4DkGRybQZB
         4sQg==
X-Gm-Message-State: AOJu0YxOVMXYGoJB6mRkjmBVqaLocQRtk/VAnZM1HDRHQwwP12B4OYV4
	V/BfBwuAZemeYL13G7v6llVN4N5t9IDEF6zxuS4aAA5fNYlO7UI2m1kg
X-Google-Smtp-Source: AGHT+IEYgdcNss6mkLEMLbboEiZM9D45I9ZrsGHgFAX69kQQKJ26onCNMt2VdB1V1a/+yR3X92vKdA==
X-Received: by 2002:a05:600c:1e04:b0:421:7891:4263 with SMTP id 5b1f17b1804b1-42178914304mr44481655e9.39.1718015483771;
        Mon, 10 Jun 2024 03:31:23 -0700 (PDT)
Received: from p183 ([46.53.251.104])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421c9d30f31sm31172155e9.1.2024.06.10.03.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jun 2024 03:31:23 -0700 (PDT)
Date: Mon, 10 Jun 2024 13:31:21 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Subject: [PATCH] kvm: do not account temporary allocations to kmem
Message-ID: <c0122f66-f428-417e-a360-b25fc0f154a0@p183>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Some allocations done by KVM are temporary, they are created as result
of program actions, but can't exists for arbitrary long times.

They should have been GFP_TEMPORARY (rip!).

OTOH, kvm-nx-lpage-recovery and kvm-pit kernel threads exist for as long
as VM exists but their task_struct memory is not accounted.
This is story for another day.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 virt/kvm/kvm_main.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4427,7 +4427,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		struct kvm_regs *kvm_regs;
 
 		r = -ENOMEM;
-		kvm_regs = kzalloc(sizeof(struct kvm_regs), GFP_KERNEL_ACCOUNT);
+		kvm_regs = kzalloc(sizeof(struct kvm_regs), GFP_KERNEL);
 		if (!kvm_regs)
 			goto out;
 		r = kvm_arch_vcpu_ioctl_get_regs(vcpu, kvm_regs);
@@ -4454,8 +4454,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_GET_SREGS: {
-		kvm_sregs = kzalloc(sizeof(struct kvm_sregs),
-				    GFP_KERNEL_ACCOUNT);
+		kvm_sregs = kzalloc(sizeof(struct kvm_sregs), GFP_KERNEL);
 		r = -ENOMEM;
 		if (!kvm_sregs)
 			goto out;
@@ -4547,7 +4546,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_GET_FPU: {
-		fpu = kzalloc(sizeof(struct kvm_fpu), GFP_KERNEL_ACCOUNT);
+		fpu = kzalloc(sizeof(struct kvm_fpu), GFP_KERNEL);
 		r = -ENOMEM;
 		if (!fpu)
 			goto out;
@@ -6210,7 +6209,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 	active = kvm_active_vms;
 	mutex_unlock(&kvm_lock);
 
-	env = kzalloc(sizeof(*env), GFP_KERNEL_ACCOUNT);
+	env = kzalloc(sizeof(*env), GFP_KERNEL);
 	if (!env)
 		return;
 
@@ -6226,7 +6225,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 	add_uevent_var(env, "PID=%d", kvm->userspace_pid);
 
 	if (!IS_ERR(kvm->debugfs_dentry)) {
-		char *tmp, *p = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
+		char *tmp, *p = kmalloc(PATH_MAX, GFP_KERNEL);
 
 		if (p) {
 			tmp = dentry_path_raw(kvm->debugfs_dentry, p, PATH_MAX);


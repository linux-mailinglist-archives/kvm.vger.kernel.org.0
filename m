Return-Path: <kvm+bounces-36574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2E5AA1BD22
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 21:07:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D2993A99CD
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 20:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFD24224B18;
	Fri, 24 Jan 2025 20:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Oqjn3180"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0901DB132
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 20:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737749253; cv=none; b=IRpf4nAdH9/yM659hF/Wqx5YUTIJVfYYRIlm3YCmluCysTZE+hME4/I4sHgtTGcMOgUPnpWW0k8hDxfKJt+kLm0vzXVu+ahnQyDourCg0DPt6CDjnRo+D8687OE/KFl6YF6c5jALusNjLZM+K54u2Q6yL2e9yDLt9m62hLmEIr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737749253; c=relaxed/simple;
	bh=ODSntvjD6W+4YpXp9Bh6F5/SFdR8yiKpNusKGnRb7N0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s0bh6kSyT5g6lNNPBqMmrRoJ5AgUUPZOP0U0Gm7XXL+WH/d4vKwx3HAV7/9Id1HRaXXeqjnsMtLQaQyYjZT47SipV2DePzY6z6XV1TdPx4g37Yabshvoz3LfLsH6lO4rWwWUQIHMGb2st24RZEfzgtgcktPpQ/KaQpPuT6OSn9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Oqjn3180; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-218cf85639eso69239675ad.3
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 12:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737749250; x=1738354050; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KhTPDZKClR8RwBmtEvLH4PFqfS6j7uQiwi1REIM/kTk=;
        b=Oqjn318044Ez2SOAXqAoFtOakrZVU6V6jmg2Kd5zQ32bfx0gc7RHAt++s6G+xeweRP
         JNrRkXNACAcwiJGfcP4nhdExdyPPdFIj9gTi4K5vxtH8csFnqHP4GmELiI95R9CNzslJ
         nWws/Zxvua7hhlz/HZ6+LzB1wREhYMgOyyNBQjMXagcnfYcGrqk/kgBMqn8rd51+dZKD
         4zFEnY2SZwYfd2wFjOmyQaE9cUjq9Y0vlByubJmsOI3cfh2qqU471Gcc0rDWDJQyO+21
         xiwTnYUEaJeKbirFI3Wf6S5k+FzyQrn6VubflT7Jlmt/Jv/fa1RPxTKtEtrJHelR0QV0
         PGeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737749250; x=1738354050;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KhTPDZKClR8RwBmtEvLH4PFqfS6j7uQiwi1REIM/kTk=;
        b=M1Mrdv/5RMO+RY2v1lt+VsbeCtApbJN12f7MJCrdVs7R44+A5x5rSot26xG0QfYKPV
         ytqbi13fdUrapUeqOotYdhszhZyanavxi0Q/Mg9B3x6QaXhbvTomnRxUGRY9GfkZAfcR
         sGvD0JqdNUerOpUjbJWQxILNqxfCMEw+I8NfP8g2MvFXqjDxyNOINLmWvQLhbmNonkSA
         m0Vp//GJmpJWlyLnAT4CpOQ+IVSX0RzZkDhP10wAD/p2fYtdWuzicLdYTge52Gf2rOw+
         7JiNpfWzci7Ts2VOZa4LAXZY5KBJ7QdGghlsm96Oe9IWiG5hZE2roYk+8SOTZR9pljKP
         PGdg==
X-Gm-Message-State: AOJu0YzddUXnzI0JXGs8mcFKGgzg3zX2X3OihR6ibP3SzKA4vMgQuzCv
	6eXGFhTBjO7BpVCSDIN+1e5rqotxQiyxem7N1rVVQA1Yt1Vjkcr+Aw8BpWFSboPhXGd2yt1vUgQ
	5NA==
X-Google-Smtp-Source: AGHT+IGcJ6wP8hLd4osx+Vo7Twq6Px7+RiViueK+P+RCJ4HbMqpM6aOH1imQopNLRyQ/23ONZIEYC8znPL4=
X-Received: from pfbbd39.prod.google.com ([2002:a05:6a00:27a7:b0:725:cd3b:3256])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:21cd:b0:72d:3861:895c
 with SMTP id d2e1a72fcca58-72dafa030ebmr48992669b3a.8.1737749249994; Fri, 24
 Jan 2025 12:07:29 -0800 (PST)
Date: Fri, 24 Jan 2025 12:07:24 -0800
In-Reply-To: <20250123153543.2769928-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250123153543.2769928-1-kbusch@meta.com>
Message-ID: <Z5Py_JYc8nYHNgZS@google.com>
Subject: Re: [PATCH] kvm: defer huge page recovery vhost task to later
From: Sean Christopherson <seanjc@google.com>
To: Keith Busch <kbusch@meta.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Vlad Poenaru <thevlad@meta.com>, tj@kernel.org, Keith Busch <kbusch@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Alyssa Ross <hi@alyssa.is>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 23, 2025, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Some libraries want to ensure they are single threaded before forking,
> so making the kernel's kvm huge page recovery process a vhost task of
> the user process breaks those. The minijail library used by crosvm is
> one such affected application.
> 
> Defer the task to after the first VM_RUN call, which occurs after the
> parent process has forked all its jailed processes. This needs to happen
> only once for the kvm instance, so this patch introduces infrastructure
> to do that (Suggested-by Paolo).
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Tested-by: Alyssa Ross <hi@alyssa.is>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 26b4ba7e7cb5e..a45ae60e84ab4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7447,20 +7447,28 @@ static bool kvm_nx_huge_page_recovery_worker(void *data)
>  	return true;
>  }
>  
> -int kvm_mmu_post_init_vm(struct kvm *kvm)
> +static void kvm_mmu_start_lpage_recovery(struct once *once)
>  {
> -	if (nx_hugepage_mitigation_hard_disabled)
> -		return 0;
> +	struct kvm_arch *ka = container_of(once, struct kvm_arch, nx_once);
> +	struct kvm *kvm = container_of(ka, struct kvm, arch);
>  
>  	kvm->arch.nx_huge_page_last = get_jiffies_64();
>  	kvm->arch.nx_huge_page_recovery_thread = vhost_task_create(
>  		kvm_nx_huge_page_recovery_worker, kvm_nx_huge_page_recovery_worker_kill,
>  		kvm, "kvm-nx-lpage-recovery");
>  
> +	if (kvm->arch.nx_huge_page_recovery_thread)
> +		vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
> +}
> +
> +int kvm_mmu_post_init_vm(struct kvm *kvm)
> +{
> +	if (nx_hugepage_mitigation_hard_disabled)
> +		return 0;
> +
> +	call_once(&kvm->arch.nx_once, kvm_mmu_start_lpage_recovery);
>  	if (!kvm->arch.nx_huge_page_recovery_thread)
>  		return -ENOMEM;
> -
> -	vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6e248152fa134..6d4a6734b2d69 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11471,6 +11471,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  	struct kvm_run *kvm_run = vcpu->run;
>  	int r;
>  
> +	r = kvm_mmu_post_init_vm(vcpu->kvm);
> +	if (r)
> +		return r;

This is broken.  If the module param is toggled before the first KVM_RUN, KVM
will hit a NULL pointer deref due to trying to start a non-existent vhost task:

  BUG: kernel NULL pointer dereference, address: 0000000000000040
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0 
  Oops: Oops: 0000 [#1] SMP
  CPU: 16 UID: 0 PID: 1190 Comm: bash Not tainted 6.13.0-rc3-9bb02e874121-x86/xen_msr_fixes-vm #2382
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:vhost_task_wake+0x5/0x10
  Call Trace:
   <TASK>
   set_nx_huge_pages+0xcc/0x1e0 [kvm]
   param_attr_store+0x8a/0xd0
   module_attr_store+0x1a/0x30
   kernfs_fop_write_iter+0x12f/0x1e0
   vfs_write+0x233/0x3e0
   ksys_write+0x60/0xd0
   do_syscall_64+0x5b/0x160
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7f3b52710104
   </TASK>
  Modules linked in: kvm_intel kvm
  CR2: 0000000000000040
  ---[ end trace 0000000000000000 ]---
 


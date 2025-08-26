Return-Path: <kvm+bounces-55732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A761AB35620
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 09:53:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41D071627A9
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 07:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D053B2F659C;
	Tue, 26 Aug 2025 07:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OEu9AwVg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB5B2D3A85
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 07:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756194793; cv=none; b=fUhj9TU4XLA+huW2QxXwnulQN8zVFMCr3l+jEG4bkkL3DWExFASbjJaqApUJSWMQOGslf1OP/eorVHXzFVuJZ10xJRObIkMqtEvdEiOXxnGekBvew2KiklRl0t/Y8h0eQdKzVIbVbkGzjZmwvkgHDoMDT8A53fUGLVKDrWPUBY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756194793; c=relaxed/simple;
	bh=dX+JPSw1HIhEjyyyMZ4WgA8Kp7gGa/+lE1IIRyJ7GNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BG08N5l2V4j4nJA0ImIEhEyjwJxqS+HdGmt7N16GCpY/dHK47VOxoTk4m4O5aX08sy/wLorseHKgOCMla6RoITMgYo/42SDR8cBPalmc45anbQox/SRhYLoCj8LoTgxWzdIRdKN97FhYjMmzPr0LjaffEnvD9mliPPRMW2Zzkqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OEu9AwVg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756194790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LoG/oMiDA0PShlYbHntrvwEM5QdNxw6NlWrg87rRvc0=;
	b=OEu9AwVg2OjDKzoLV3k3j57QM/mSZnBnCpgTsp6IJfRAhuD9EJioCVzzBQOUd3MxDvunvl
	/IU5s/tK5MgkB0Csymtx54UPl9yfBhTmQRsLZfC1jPsq8uMRilpcAf980GV6dTtt59LDln
	Zt5y9e+HJxAoKkpcKyMnI95bfwVcL6A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-eoK2teDoP3q1kTnrP7vM-A-1; Tue, 26 Aug 2025 03:53:07 -0400
X-MC-Unique: eoK2teDoP3q1kTnrP7vM-A-1
X-Mimecast-MFC-AGG-ID: eoK2teDoP3q1kTnrP7vM-A_1756194786
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3c75de76cacso2063470f8f.3
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 00:53:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756194785; x=1756799585;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LoG/oMiDA0PShlYbHntrvwEM5QdNxw6NlWrg87rRvc0=;
        b=t5l3MmzWR6z2R0JSJd8edu9YmpgWoX25ARpaCtd5LGrydbX66sAa7k0Rt4A2ypuXov
         hBcgH3j5pp5cqhEw3fimf+aa9WLJP41jKOHcH0O6Dugp7w9xFiZjsvzwTzsOMFi0991U
         DesWoiiivWgcKiJ/kz2IT9Cw6ZJPViJ+JK+yd2+9tCiQB+oM85XCmaoW2piBeUSGGScM
         PHHa0tbhpaseWEsPVmHnMlZ59ma/jSLuLpH21+x0W9KrRWkrdNbkiRg0Jodwfr6rbs3y
         J4f1O09lghHKuRZDuptVAAVCASTUum42R+ukP00NlzA5JS2ga9mGO7KmYLSz67+iakVy
         pUYg==
X-Forwarded-Encrypted: i=1; AJvYcCVmffxgRn0ujvI62peGB8x7m2j/R52X/oTGP9jioIQ+E0X4mn0h5R3hkD+hw/s9jYFmlsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHkY+rxAMyrCakLOBbLjoHIFaMuEW8J3b+D0D6ixlbaI228fXw
	KfmVXiD95xR5MYL49cpT1iMuXeYdBM/mfWefiMeCcf3VCSqioBrdckrLocHIpU7kZ7aBcYZy8wV
	CUG7VNy0vaOVpxiSWK4ss0nvbPP8bW8libcA82WmWbaxH/tyBuO1BYFsvpjw2bg==
X-Gm-Gg: ASbGnctl7jAoBAoFiSH3MH085p7ZbVP2dnB9NrFxpHAMMMBwF07J3zm6ZehLHuIDoUS
	ej7kKNZVnbJIumL1va3mFpt8BlcntLix2WyXB9kpws1pKOPSVJBr3O2CRA6GrpnD7l7+VCjqb0o
	Sx9on333OFPxVdrgeNYXUfiy7FjGcbEX8SvLh1JGExpPhr/JZgGGe78NQAhRC6has6zXp8lJqyK
	dxbVWjt56lMzAT3YDBP9nfzf7yqVWchNIE38T4rGIozSm/AwWwSZ8/9h+lnlel4kN0z1HSBwbgF
	GJUjf+XIokXJ0P6puOAIon8e7VG9sPQ=
X-Received: by 2002:a05:6000:4211:b0:3c7:95cb:baae with SMTP id ffacd0b85a97d-3c795cbc786mr7797584f8f.36.1756194784910;
        Tue, 26 Aug 2025 00:53:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqVz0b+NfcNpGcCbXovaqiNDlqX9kOt6jyKlVBDTJ5Jc9+aLhIKRxVtdKSdE6hyWoOT2t9Kw==
X-Received: by 2002:a05:6000:4211:b0:3c7:95cb:baae with SMTP id ffacd0b85a97d-3c795cbc786mr7797560f8f.36.1756194784423;
        Tue, 26 Aug 2025 00:53:04 -0700 (PDT)
Received: from redhat.com ([185.128.27.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70ef566dcsm14823742f8f.24.2025.08.26.00.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 00:53:03 -0700 (PDT)
Date: Tue, 26 Aug 2025 03:52:59 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jason Wang <jasowang@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 1/3] vhost_task: KVM: Don't wake KVM x86's recovery
 thread if vhost task was killed
Message-ID: <20250826034937-mutt-send-email-mst@kernel.org>
References: <20250826004012.3835150-1-seanjc@google.com>
 <20250826004012.3835150-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826004012.3835150-2-seanjc@google.com>

On Mon, Aug 25, 2025 at 05:40:09PM -0700, Sean Christopherson wrote:
> Add a vhost_task_wake_safe() variant to handle the case where a vhost task
> has exited due to a signal, i.e. before being explicitly stopped by the
> owner of the task, and use the "safe" API in KVM when waking NX hugepage
> recovery tasks.  This fixes a bug where KVM will attempt to wake a task
> that has exited, which ultimately results in all manner of badness, e.g.
> 
>   Oops: general protection fault, probably for non-canonical address 0xff0e899fa1566052: 0000 [#1] SMP
>   CPU: 51 UID: 0 PID: 53807 Comm: tee Tainted: G S         O        6.17.0-smp--38183c31756a-next #826 NONE
>   Tainted: [S]=CPU_OUT_OF_SPEC, [O]=OOT_MODULE
>   Hardware name: Google LLC Indus/Indus_QC_03, BIOS 30.110.0 09/13/2024
>   RIP: 0010:queued_spin_lock_slowpath+0x123/0x250
>   Code: ... <48> 89 8c 02 c0 da 47 a2 83 79 08 00 75 08 f3 90 83 79 08 00 74 f8
>   RSP: 0018:ffffbf55cffe7cf8 EFLAGS: 00010006
>   RAX: ff0e899fff0e8562 RBX: 0000000000d00000 RCX: ffffa39b40aefac0
>   RDX: 0000000000000030 RSI: fffffffffffffff8 RDI: ffffa39d0592e68c
>   RBP: 0000000000d00000 R08: 00000000ffffff80 R09: 0000000400000000
>   R10: ffffa36cce4fe401 R11: 0000000000000800 R12: 0000000000000003
>   R13: 0000000000000000 R14: ffffa39d0592e68c R15: ffffa39b9e672000
>   FS:  00007f233b2e9740(0000) GS:ffffa39b9e672000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007f233b39fda0 CR3: 00000004d031f002 CR4: 00000000007726f0
>   PKRU: 55555554
>   Call Trace:
>    <TASK>
>    _raw_spin_lock_irqsave+0x50/0x60
>    try_to_wake_up+0x4f/0x5d0
>    set_nx_huge_pages+0xe4/0x1c0 [kvm]
>    param_attr_store+0x89/0xf0
>    module_attr_store+0x1e/0x30
>    kernfs_fop_write_iter+0xe4/0x160
>    vfs_write+0x2cb/0x420
>    ksys_write+0x7f/0xf0
>    do_syscall_64+0x6f/0x1f0
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>   RIP: 0033:0x7f233b4178b3
>   R13: 0000000000000002 R14: 00000000226ff3d0 R15: 0000000000000002
>    </TASK>
> 
> Provide an API in vhost task instead of forcing KVM to solve the problem,
> as KVM would literally just add an equivalent to VHOST_TASK_FLAGS_KILLED,
> along with a new lock to protect said flag.  In general, forcing simple
> usage of vhost task to care about signals _and_ take non-trivial action to
> do the right thing isn't developer friendly, and is likely to lead to
> similar bugs in the future.
> 
> Debugged-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Link: https://lore.kernel.org/all/aKkLEtoDXKxAAWju@google.com
> Link: https://lore.kernel.org/all/aJ_vEP2EHj6l0xRT@google.com
> Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Fixes: d96c77bd4eeb ("KVM: x86: switch hugepage recovery thread to vhost_task")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

OK but I dislike the API.

Default APIs should be safe. So vhost_task_wake_safe should be
vhost_task_wake

This also reduces the changes to kvm.


It does not look like we need the "unsafe" variant, so pls drop it.
If we do need it, it should be called __vhost_task_wake.






> ---
>  arch/x86/kvm/mmu/mmu.c           |  2 +-
>  include/linux/sched/vhost_task.h |  1 +
>  kernel/vhost_task.c              | 42 +++++++++++++++++++++++++++++---
>  3 files changed, 41 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6e838cb6c9e1..d11730467fd4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7376,7 +7376,7 @@ static void kvm_wake_nx_recovery_thread(struct kvm *kvm)
>  	struct vhost_task *nx_thread = READ_ONCE(kvm->arch.nx_huge_page_recovery_thread);
>  
>  	if (nx_thread)
> -		vhost_task_wake(nx_thread);
> +		vhost_task_wake_safe(nx_thread);
>  }
>  
>  static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)
> diff --git a/include/linux/sched/vhost_task.h b/include/linux/sched/vhost_task.h
> index 25446c5d3508..5d5c187088f7 100644
> --- a/include/linux/sched/vhost_task.h
> +++ b/include/linux/sched/vhost_task.h
> @@ -10,5 +10,6 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
>  void vhost_task_start(struct vhost_task *vtsk);
>  void vhost_task_stop(struct vhost_task *vtsk);
>  void vhost_task_wake(struct vhost_task *vtsk);
> +void vhost_task_wake_safe(struct vhost_task *vtsk);
>  
>  #endif /* _LINUX_SCHED_VHOST_TASK_H */
> diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
> index bc738fa90c1d..5aa8ddf88d01 100644
> --- a/kernel/vhost_task.c
> +++ b/kernel/vhost_task.c
> @@ -67,18 +67,54 @@ static int vhost_task_fn(void *data)
>  	do_exit(0);
>  }
>  
> +static void __vhost_task_wake(struct vhost_task *vtsk)
> +{
> +	wake_up_process(vtsk->task);
> +}
> +
>  /**
>   * vhost_task_wake - wakeup the vhost_task
>   * @vtsk: vhost_task to wake
>   *
> - * wake up the vhost_task worker thread
> + * Wake up the vhost_task worker thread.  The caller is responsible for ensuring
> + * that the task hasn't exited.
>   */
>  void vhost_task_wake(struct vhost_task *vtsk)
>  {
> -	wake_up_process(vtsk->task);
> +	/*
> +	 * Checking VHOST_TASK_FLAGS_KILLED can race with signal delivery, but
> +	 * a race can only result in false negatives and this is just a sanity
> +	 * check, i.e. if KILLED is set, the caller is buggy no matter what.
> +	 */
> +	if (WARN_ON_ONCE(test_bit(VHOST_TASK_FLAGS_KILLED, &vtsk->flags)))
> +		return;
> +
> +	__vhost_task_wake(vtsk);
>  }
>  EXPORT_SYMBOL_GPL(vhost_task_wake);
>  
> +/**
> + * vhost_task_wake_safe - wakeup the vhost_task if it hasn't been killed
> + * @vtsk: vhost_task to wake
> + *
> + * Wake up the vhost_task worker thread if the task hasn't exited, e.g. due to
> + * a signal.
> + */
> +void vhost_task_wake_safe(struct vhost_task *vtsk)
> +{
> +	guard(mutex)(&vtsk->exit_mutex);
> +
> +	/* Attempting to wake a task that has been explicitly stopped is a bug. */
> +	if (WARN_ON_ONCE(test_bit(VHOST_TASK_FLAGS_STOP, &vtsk->flags)))
> +		return;
> +
> +	if (test_bit(VHOST_TASK_FLAGS_KILLED, &vtsk->flags))
> +		return;
> +
> +	__vhost_task_wake(vtsk);
> +}
> +EXPORT_SYMBOL_GPL(vhost_task_wake_safe);
> +
>  /**
>   * vhost_task_stop - stop a vhost_task
>   * @vtsk: vhost_task to stop
> @@ -91,7 +127,7 @@ void vhost_task_stop(struct vhost_task *vtsk)
>  	mutex_lock(&vtsk->exit_mutex);
>  	if (!test_bit(VHOST_TASK_FLAGS_KILLED, &vtsk->flags)) {
>  		set_bit(VHOST_TASK_FLAGS_STOP, &vtsk->flags);
> -		vhost_task_wake(vtsk);
> +		__vhost_task_wake(vtsk);
>  	}
>  	mutex_unlock(&vtsk->exit_mutex);
>  
> -- 
> 2.51.0.261.g7ce5a0a67e-goog



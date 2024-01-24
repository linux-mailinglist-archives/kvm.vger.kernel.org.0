Return-Path: <kvm+bounces-6859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C581283B1C0
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 20:05:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E923A1C21FA8
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 19:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8BAB131E39;
	Wed, 24 Jan 2024 19:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nd4nM82Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFA9131E41
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 19:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706123099; cv=none; b=NChc8YbQc39AC9+oQlI3RpF6tXQHWnfz+g5rwlbB179+1HX3uZAAIkaX2bHJaE0zVsUx0VgSE5pNRiYRCxLJrOEh/Rpa/bsYaREt3jEI+2K3pcM8g4mPKwZAQeY9o3beXgPXgAwAMSImGYiJGAB+nbYVYX1YIMxVbNQeGkgcTE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706123099; c=relaxed/simple;
	bh=c5btgQrk1BDhz/0vTxGV7Vcu8tvNas/9Lb+j0KERx10=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=blec8pCKvlfrlP/AwzKiaBzcYy3ND8cwrQyjAIfwukJ3CQ5uqhrskKOx80wU3aEavtzksyPzcsegNj4w6wtt6n4daasF2kAki6emuHitCAgw4PeEEZ6n7+hmx8Gq7T3xXVyFCTaNfzWQENw0Wzgzv6JmIRt1Pw5h2lcOS21ktUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nd4nM82Z; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbe9e13775aso8518272276.1
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 11:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706123096; x=1706727896; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vAZqoNc/Roso568VdStpsH9vQUOsPSWPM9DJObD4iWg=;
        b=nd4nM82ZFy1Tli6eLc6CJpF0bSJt++yYIN2UoFzDC/31k1d3sU9MXdcb1HgYgpbdb5
         AUJkjyVe1uxYSMnyXIdaczdBkoBnzG4zpXrvTZzMTg1EtInSm0JxnGqaUtruaLuUU4+b
         zzOUE4/ZXK1NzHwCWwoKCU2XPD+zjl8iSLHATpu8ARaLTNFGz/ygBTraXC48spZ1dRae
         C4UjDvFzJGqvwWD0VqK5I1HLYNKl5CnCE+7Pz9B6Fj5hidqpwjJDSIv/j5AyrYDZ3fHD
         rwws4uHJSEWtM+NbeofCn8GYrnQKLreJHN+uHiVkKn5I0/IF6jrr/dPOpj2xHzTIXYJK
         aggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706123096; x=1706727896;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vAZqoNc/Roso568VdStpsH9vQUOsPSWPM9DJObD4iWg=;
        b=wO8uNWMt928K4u74rIZhe9yXR+NSpXAzS/owVFLAr5kz8v3BNvQHjkqzG1xqVbAhWZ
         09p5IlGf0IgRD7M0VjWqOY1FCpGiiNuHvXzBVjZEpbEx9qtJoQfSt43VTPJfYpL/6m9W
         NDtzDDuOYzNTKfgWnkl/aiQkYGmGUMnTuxyT05Mf8Va7p9DlB13to0ap28ARGMHm5I+T
         NB5utbtcuEdrDfHM+LcLHKgTrlZJr7ZkSpBEQK1jEy25JilMb+zRO15Nd/hsEI57edcN
         u8JK36wh5XctnE73DpQFjOIn0xYsMBKasAF4a7KSD+PaSWlLsssgtsew8OiWUGxJtHc4
         JCUA==
X-Gm-Message-State: AOJu0YxKP6gDCd5buDj+FcjmI1jCc0nwJe7aQcKV/NjnfPfx/LeK0aBv
	6R80DPcao/K4CcFbvLbwm1OH9cI6CpLEdcHgz7Mhgf28mU2zVH8eo2mnO+PzpmM0BXHN5Qp7NzT
	ziA==
X-Google-Smtp-Source: AGHT+IGZ3P+g0NZG3xrH3V796G8tgabmal0b44HFtxDWLHT5kAGUC452wzMacuHtyluNxa94X5PkM/QEFGo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d6cb:0:b0:dc2:4d7e:23e4 with SMTP id
 n194-20020a25d6cb000000b00dc24d7e23e4mr545467ybg.4.1706123096765; Wed, 24 Jan
 2024 11:04:56 -0800 (PST)
Date: Wed, 24 Jan 2024 11:04:55 -0800
In-Reply-To: <Zau/VQ0B5MCwoqZT@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110011533.503302-1-seanjc@google.com> <20240110011533.503302-2-seanjc@google.com>
 <Zau/VQ0B5MCwoqZT@yilunxu-OptiPlex-7050>
Message-ID: <ZbFfVxp76qoBstul@google.com>
Subject: Re: [PATCH 1/4] KVM: Always flush async #PF workqueue when vCPU is
 being destroyed
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Jan 20, 2024, Xu Yilun wrote:
> On Tue, Jan 09, 2024 at 05:15:30PM -0800, Sean Christopherson wrote:
> > Always flush the per-vCPU async #PF workqueue when a vCPU is clearing its
> > completion queue, e.g. when a VM and all its vCPUs is being destroyed.
> > KVM must ensure that none of its workqueue callbacks is running when the
> > last reference to the KVM _module_ is put.  Gifting a reference to the
> > associated VM prevents the workqueue callback from dereferencing freed
> > vCPU/VM memory, but does not prevent the KVM module from being unloaded
> > before the callback completes.
> > 
> > Drop the misguided VM refcount gifting, as calling kvm_put_kvm() from
> > async_pf_execute() if kvm_put_kvm() flushes the async #PF workqueue will
> > result in deadlock.  async_pf_execute() can't return until kvm_put_kvm()
> > finishes, and kvm_put_kvm() can't return until async_pf_execute() finishes:
> > 
> >  WARNING: CPU: 8 PID: 251 at virt/kvm/kvm_main.c:1435 kvm_put_kvm+0x2d/0x320 [kvm]
> >  Modules linked in: vhost_net vhost vhost_iotlb tap kvm_intel kvm irqbypass
> >  CPU: 8 PID: 251 Comm: kworker/8:1 Tainted: G        W          6.6.0-rc1-e7af8d17224a-x86/gmem-vm #119
> >  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> >  Workqueue: events async_pf_execute [kvm]
> >  RIP: 0010:kvm_put_kvm+0x2d/0x320 [kvm]
> >  Call Trace:
> >   <TASK>
> >   async_pf_execute+0x198/0x260 [kvm]
> >   process_one_work+0x145/0x2d0
> >   worker_thread+0x27e/0x3a0
> >   kthread+0xba/0xe0
> >   ret_from_fork+0x2d/0x50
> >   ret_from_fork_asm+0x11/0x20
> >   </TASK>
> >  ---[ end trace 0000000000000000 ]---
> >  INFO: task kworker/8:1:251 blocked for more than 120 seconds.
> >        Tainted: G        W          6.6.0-rc1-e7af8d17224a-x86/gmem-vm #119
> >  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >  task:kworker/8:1     state:D stack:0     pid:251   ppid:2      flags:0x00004000
> >  Workqueue: events async_pf_execute [kvm]
> >  Call Trace:
> >   <TASK>
> >   __schedule+0x33f/0xa40
> >   schedule+0x53/0xc0
> >   schedule_timeout+0x12a/0x140
> >   __wait_for_common+0x8d/0x1d0
> >   __flush_work.isra.0+0x19f/0x2c0
> >   kvm_clear_async_pf_completion_queue+0x129/0x190 [kvm]
> >   kvm_arch_destroy_vm+0x78/0x1b0 [kvm]
> >   kvm_put_kvm+0x1c1/0x320 [kvm]
> >   async_pf_execute+0x198/0x260 [kvm]
> >   process_one_work+0x145/0x2d0
> >   worker_thread+0x27e/0x3a0
> >   kthread+0xba/0xe0
> >   ret_from_fork+0x2d/0x50
> >   ret_from_fork_asm+0x11/0x20
> >   </TASK>
> > 
> > If kvm_clear_async_pf_completion_queue() actually flushes the workqueue,
> > then there's no need to gift async_pf_execute() a reference because all
> > invocations of async_pf_execute() will be forced to complete before the
> > vCPU and its VM are destroyed/freed.  And that in turn fixes the module
> > unloading bug as __fput() won't do module_put() on the last vCPU reference
> > until the vCPU has been freed, e.g. if closing the vCPU file also puts the
> 
> I'm not sure why __fput() of vCPU fd should be mentioned here. I assume
> we just need to say that vCPUs are freed before module_put(KVM the module)
> in kvm_destroy_vm(), then the whole logic for module unloading fix is:
> 
>   1. All workqueue callbacks complete when kvm_clear_async_pf_completion_queue(vcpu)
>   2. kvm_clear_async_pf_completion_queue(vcpu) must be executed before vCPU free.
>   3. vCPUs must be freed before module_put(KVM the module).
> 
>   So all workqueue callbacks complete before module_put(KVM the module).
> 
> 
> __fput() of vCPU fd is not the only trigger of kvm_destroy_vm(), that
> makes me distracted from reason of the fix.

My goal was to call out that (a) the vCPU file descriptor is what ensures kvm.ko
is alive at this point and (b) that __fput() very deliberately ensures module_put()
is called after all module function callbacks/hooks complete, as there was quite
a bit of confusion around who/what can safely do module_put().

> > last reference to the KVM module.
> > 
> > Note that kvm_check_async_pf_completion() may also take the work item off
> > the completion queue and so also needs to flush the work queue, as the
> > work will not be seen by kvm_clear_async_pf_completion_queue().  Waiting
> > on the workqueue could theoretically delay a vCPU due to waiting for the
> > work to complete, but that's a very, very small chance, and likely a very
> > small delay.  kvm_arch_async_page_present_queued() unconditionally makes a
> > new request, i.e. will effectively delay entering the guest, so the
> > remaining work is really just:
> > 
> >         trace_kvm_async_pf_completed(addr, cr2_or_gpa);
> > 
> >         __kvm_vcpu_wake_up(vcpu);
> > 
> >         mmput(mm);
> > 
> > and mmput() can't drop the last reference to the page tables if the vCPU is
> > still alive, i.e. the vCPU won't get stuck tearing down page tables.
> > 
> > Add a helper to do the flushing, specifically to deal with "wakeup all"
> > work items, as they aren't actually work items, i.e. are never placed in a
> > workqueue.  Trying to flush a bogus workqueue entry rightly makes
> > __flush_work() complain (kudos to whoever added that sanity check).
> > 
> > Note, commit 5f6de5cbebee ("KVM: Prevent module exit until all VMs are
> > freed") *tried* to fix the module refcounting issue by having VMs grab a
> > reference to the module, but that only made the bug slightly harder to hit
> > as it gave async_pf_execute() a bit more time to complete before the KVM
> > module could be unloaded.
> > 
> > Fixes: af585b921e5d ("KVM: Halt vcpu if page it tries to access is swapped out")
> > Cc: stable@vger.kernel.org
> > Cc: David Matlack <dmatlack@google.com>
> > Cc: Xu Yilun <yilun.xu@linux.intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  virt/kvm/async_pf.c | 37 ++++++++++++++++++++++++++++++++-----
> >  1 file changed, 32 insertions(+), 5 deletions(-)
> > 
> > diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> > index e033c79d528e..876927a558ad 100644
> > --- a/virt/kvm/async_pf.c
> > +++ b/virt/kvm/async_pf.c
> > @@ -87,7 +87,25 @@ static void async_pf_execute(struct work_struct *work)
> >  	__kvm_vcpu_wake_up(vcpu);
> >  
> >  	mmput(mm);
> > -	kvm_put_kvm(vcpu->kvm);
> > +}
> > +
> > +static void kvm_flush_and_free_async_pf_work(struct kvm_async_pf *work)
> > +{
> > +	/*
> > +	 * The async #PF is "done", but KVM must wait for the work item itself,
> > +	 * i.e. async_pf_execute(), to run to completion.  If KVM is a module,
> > +	 * KVM must ensure *no* code owned by the KVM (the module) can be run
> > +	 * after the last call to module_put(), i.e. after the last reference
> > +	 * to the last vCPU's file is put.
> 
> Maybe drop the i.e? It is not exactly true, other components like VFIO
> may also be the last one to put KVM reference?

Ah, yeah, agreed.  I'll drop that last snippet, it doesn't and much value.


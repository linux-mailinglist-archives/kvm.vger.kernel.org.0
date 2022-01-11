Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5835B48AC94
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 12:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349510AbiAKLgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 06:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbiAKLgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 06:36:39 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C42EC06173F
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 03:36:39 -0800 (PST)
Date:   Tue, 11 Jan 2022 12:36:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1641900996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=amay2vL/DrpGsXXR7q47fJrUHNyvlwb+4weXufDt8J4=;
        b=oRdKOx9CsymIUJeJ89IQwze6Te8Eigdya+s0NfMefEcwseoBHieW5TRSsveVXXYOvspBt6
        ue8Z2OZYeKgCFdqQ2gAN0UQNGzI+kfJ4NMTZxw4mcZwVXFdEPI4GMB5xZLCf7Z8qjWa8Zb
        4w1O79OFFNTTkqLvyDuxjqeRWCNtQg/zTgwKJKxFpvyJ9BaQB9fVpvGJaBy01CoZeOtKyT
        bEUEiDeyX4ZmmucOiQ8mHeNRVqw3qG4IMejIuUaqXqoLSvOnkdCYlxvSAXevDTyURtBwyZ
        BRiKcgXdRijbnK+FaYQ2jqWziFoyS3Hh935e/hBS98SOExgICaN1bdNxctX7HQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1641900996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=amay2vL/DrpGsXXR7q47fJrUHNyvlwb+4weXufDt8J4=;
        b=U9h3UL8okyhxNJBoYme+EBBE0gXyL694TmV3dSbOWqK/WMehppkyRg6iq/SJ9xPiB9Y8ss
        8ubwurlS8EyKCjBQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: VMX: switch wakeup_vcpus_on_cpu_lock to raw spinlock
Message-ID: <Yd1rw+XiUYFH1+OZ@linutronix.de>
References: <20220107175114.GA261406@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220107175114.GA261406@fuller.cnet>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-01-07 14:51:14 [-0300], Marcelo Tosatti wrote:
> 
> wakeup_vcpus_on_cpu_lock is taken from hard interrupt context 
> (pi_wakeup_handler), therefore it cannot sleep.
> 
> Switch it to a raw spinlock.
> 
> Fixes:
> 
> [41297.066254] BUG: scheduling while atomic: CPU 0/KVM/635218/0x00010001 
> [41297.066323] Preemption disabled at: 
> [41297.066324] [<ffffffff902ee47f>] irq_enter_rcu+0xf/0x60 
> [41297.066339] Call Trace: 
> [41297.066342]  <IRQ> 
> [41297.066346]  dump_stack_lvl+0x34/0x44 
> [41297.066353]  ? irq_enter_rcu+0xf/0x60 
> [41297.066356]  __schedule_bug.cold+0x7d/0x8b 
> [41297.066361]  __schedule+0x439/0x5b0 
> [41297.066365]  ? task_blocks_on_rt_mutex.constprop.0.isra.0+0x1b0/0x440 
> [41297.066369]  schedule_rtlock+0x1e/0x40 
> [41297.066371]  rtlock_slowlock_locked+0xf1/0x260 
> [41297.066374]  rt_spin_lock+0x3b/0x60 
> [41297.066378]  pi_wakeup_handler+0x31/0x90 [kvm_intel] 
> [41297.066388]  sysvec_kvm_posted_intr_wakeup_ipi+0x9d/0xd0 
> [41297.066392]  </IRQ> 
> [41297.066392]  asm_sysvec_kvm_posted_intr_wakeup_ipi+0x12/0x20 
> ...
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

so I have here v5.16 and no wakeup_vcpus_on_cpu_lock. It was also not
removed so this patch is not intended for a previous kernel. Also
checked next-20220111 and no wakeup_vcpus_on_cpu_lock.

Sebastian

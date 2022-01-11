Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57DA48ADB7
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 13:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbiAKMjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 07:39:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238370AbiAKMjB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 07:39:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641904741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gp9IbW0Mf4P4dtdpjc7hp/JmxG2MvZ7XSY8haquwGLs=;
        b=ULCguBJTC1/ia39AAHH2IWdv/Qq+QvL+u5ZYNaTYMRl5Sox93yliDdOkjCznX0UzFp3/Lj
        F10JMBtMyvcXSimbIDzgKlajwZZqL6VhIjYPnp32m9rVptuEQ6Lin1pe50xdkKRVjTFYgj
        26bsY7GWWueChXJrH//8OZic3R0Zgrg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-0mZoBmzEOVOzv63zmYerXQ-1; Tue, 11 Jan 2022 07:38:58 -0500
X-MC-Unique: 0mZoBmzEOVOzv63zmYerXQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED913425FC;
        Tue, 11 Jan 2022 12:38:56 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E01484A11;
        Tue, 11 Jan 2022 12:38:56 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id EE1E541042E3; Tue, 11 Jan 2022 09:13:17 -0300 (-03)
Date:   Tue, 11 Jan 2022 09:13:17 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: VMX: switch wakeup_vcpus_on_cpu_lock to raw spinlock
Message-ID: <20220111121317.GA8480@fuller.cnet>
References: <20220107175114.GA261406@fuller.cnet>
 <Yd1rw+XiUYFH1+OZ@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd1rw+XiUYFH1+OZ@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022 at 12:36:35PM +0100, Sebastian Andrzej Siewior wrote:
> On 2022-01-07 14:51:14 [-0300], Marcelo Tosatti wrote:
> > 
> > wakeup_vcpus_on_cpu_lock is taken from hard interrupt context 
> > (pi_wakeup_handler), therefore it cannot sleep.
> > 
> > Switch it to a raw spinlock.
> > 
> > Fixes:
> > 
> > [41297.066254] BUG: scheduling while atomic: CPU 0/KVM/635218/0x00010001 
> > [41297.066323] Preemption disabled at: 
> > [41297.066324] [<ffffffff902ee47f>] irq_enter_rcu+0xf/0x60 
> > [41297.066339] Call Trace: 
> > [41297.066342]  <IRQ> 
> > [41297.066346]  dump_stack_lvl+0x34/0x44 
> > [41297.066353]  ? irq_enter_rcu+0xf/0x60 
> > [41297.066356]  __schedule_bug.cold+0x7d/0x8b 
> > [41297.066361]  __schedule+0x439/0x5b0 
> > [41297.066365]  ? task_blocks_on_rt_mutex.constprop.0.isra.0+0x1b0/0x440 
> > [41297.066369]  schedule_rtlock+0x1e/0x40 
> > [41297.066371]  rtlock_slowlock_locked+0xf1/0x260 
> > [41297.066374]  rt_spin_lock+0x3b/0x60 
> > [41297.066378]  pi_wakeup_handler+0x31/0x90 [kvm_intel] 
> > [41297.066388]  sysvec_kvm_posted_intr_wakeup_ipi+0x9d/0xd0 
> > [41297.066392]  </IRQ> 
> > [41297.066392]  asm_sysvec_kvm_posted_intr_wakeup_ipi+0x12/0x20 
> > ...
> > 
> > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> so I have here v5.16 and no wakeup_vcpus_on_cpu_lock. It was also not
> removed so this patch is not intended for a previous kernel. Also
> checked next-20220111 and no wakeup_vcpus_on_cpu_lock.
> 
> Sebastian
> 
> 

Sebastian,

The variable has been renamed on kvm.git/queue (sorry for not mentioning
that).

I suppose Paolo can integrate through kvm.git.



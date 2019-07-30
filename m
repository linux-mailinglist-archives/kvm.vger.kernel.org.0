Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF497A7BF
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 14:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbfG3MJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 08:09:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60076 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfG3MJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 08:09:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eRpWKW7gLROmOjbwkP88njPjYWqjaFOZOs22bzkiPOs=; b=baF0RKwT0FNJW3MqdNL4/geCuW
        qbk6m5ow0a/Mzl/KZm+2LUBCvGd+QFKYCYVjawnLgITwQ28fONgeHjLtRBAa14c53KHP54uc6KHhf
        AqiwGY8/5QQNvZGYL/5m82pV4Y1BRsMis5Y8IomyiRlf+wd5MoDNEGQcuAr3m2qcWu9Z9GMDxIuFH
        Slzo+unOJs3ofV5hlodv85oeWjcpiMEsB5cnvU8Zye9UkmcfZHJPHpuVHv2EWmHUAq/lAW9yAyL15
        WOSPHW+PULgoW5/WCkhRyc/6Wk2mF4mVDyvVKZbMZX5h+MMhubX5DHQuhlmuAQyE7/ceP/q1T5xEu
        Jr49+eXw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hsQwn-0002Fj-Ao; Tue, 30 Jul 2019 12:09:41 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1428D2029FD58; Tue, 30 Jul 2019 14:09:39 +0200 (CEST)
Date:   Tue, 30 Jul 2019 14:09:39 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: Disable wake-affine vCPU process to mitigate lock
 holder preemption
Message-ID: <20190730120939.GM31381@hirez.programming.kicks-ass.net>
References: <1564479235-25074-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1564479235-25074-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 30, 2019 at 05:33:55PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Wake-affine is a feature inside scheduler which we attempt to make processes 
> running closely, it gains benefit mostly from cache-hit. When waker tries 
> to wakup wakee, it needs to select cpu to run wakee, wake affine heuristic 
> mays select the cpu which waker is running on currently instead of the prev 
> cpu which wakee was last time running. 
> 
> However, in multiple VMs over-subscribe virtualization scenario, it increases 
> the probability to incur vCPU stacking which means that the sibling vCPUs from 
> the same VM will be stacked on one pCPU. I test three 80 vCPUs VMs running on 
> one 80 pCPUs Skylake server(PLE is supported), the ebizzy score can increase 17% 
> after disabling wake-affine for vCPU process. 
> 
> When qemu/other vCPU inject virtual interrupt to guest through waking up one 
> sleeping vCPU, it increases the probability to stack vCPUs/qemu by scheduler
> wake-affine. vCPU stacking issue can greately inceases the lock synchronization 
> latency in a virtualized environment. This patch disables wake-affine vCPU 
> process to mitigtate lock holder preemption.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  include/linux/sched.h | 1 +
>  kernel/sched/fair.c   | 3 +++
>  virt/kvm/kvm_main.c   | 1 +
>  3 files changed, 5 insertions(+)

> index 036be95..18eb1fa 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5428,6 +5428,9 @@ static int wake_wide(struct task_struct *p)
>  	unsigned int slave = p->wakee_flips;
>  	int factor = this_cpu_read(sd_llc_size);
>  
> +	if (unlikely(p->flags & PF_NO_WAKE_AFFINE))
> +		return 1;
> +
>  	if (master < slave)
>  		swap(master, slave);
>  	if (slave < factor || master < slave * factor)

I intensely dislike how you misrepresent this patch as a KVM patch.

Also the above is very much not the right place, even if this PF_flag
were to live.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5980B3755F1
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 16:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhEFOwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 10:52:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42686 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234759AbhEFOwI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 10:52:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620312670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CQ9Mos2syCik0TQ8OY7wSpK2F3tBlzqwRXD+sm7DThY=;
        b=B+nAythzKN0Ip7byT19S5ilS1970C5n3ujJzOQdI1o/gP4/jLkgWePn11cqKcM73FHIU8+
        1y4WRP4uTf55Jvwfgav+VV5nAPgliXGHkHfwW02mgz0mFYiq7ah53yUxWnIJC8OJWR6g4B
        The1Ai+vYgIKUd18Tuxk/3Rsrb5kfdw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-HeIboeheMsyxBpi8bDAQEw-1; Thu, 06 May 2021 10:51:08 -0400
X-MC-Unique: HeIboeheMsyxBpi8bDAQEw-1
Received: by mail-wm1-f69.google.com with SMTP id y193-20020a1c32ca0000b029014cbf30c3f2so2721084wmy.1
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 07:51:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CQ9Mos2syCik0TQ8OY7wSpK2F3tBlzqwRXD+sm7DThY=;
        b=f4b4+sk5UXlM5dCBsZO+ghsITXhpQ0qzeG6ACdhlGwNOAU5EfYlnfsH0rLO52gjVSa
         csvuGBrOFWZTVsC6GIiRMEF9bI6pO95na+mEuBSyNnc0Inl0uLXZ/55HexgiH/sPhUcY
         +40RixYoEJOjMV2fIN0u9nIAa7O5zHnuRVxoZ4bkOoMxO+9fOKD2xuS26PcluCduPLhI
         bwA8/Cg9+YTlC6TRfeau8CvFDX+CSU/KXciVh+8MjJXuU+uefIZ55GDQSQMFa9BlZRAl
         QTABOScYsIWpEHTzlefk2+76YmhKxXS6Dj3/5AhsxiaSIIbnEM7yDbXptWgVto/rgZSc
         rgYw==
X-Gm-Message-State: AOAM533P2BWDAJtMnWXbSpyKyxyfW8OZHfzsnx7p2cnLU3awLc8e7Iw+
        2ZyPYaF5HubbmkjzNksChEpQhij7kxCvq+WYJUiU8qExK96RzR0tnj9MLayc9x6tKUkqdeKrAHf
        PIS3kN+RRWWcT
X-Received: by 2002:a1c:ed05:: with SMTP id l5mr15782682wmh.154.1620312667252;
        Thu, 06 May 2021 07:51:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgQBvDMcNI9wNnQwD/PsxXf8YXOY8vJFlTDGKhPFHN8RvRON+E2K2yUYk1PiJBVLh7Txvaxg==
X-Received: by 2002:a1c:ed05:: with SMTP id l5mr15782658wmh.154.1620312667063;
        Thu, 06 May 2021 07:51:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z18sm4339616wrh.16.2021.05.06.07.51.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 07:51:06 -0700 (PDT)
Subject: Re: KVM: x86: Prevent deadlock against tk_core.seq
To:     Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <87h7jgm1zy.ffs@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a087fe30-6d43-bc5e-6ada-6f48f3da8d25@redhat.com>
Date:   Thu, 6 May 2021 16:51:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87h7jgm1zy.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/21 15:21, Thomas Gleixner wrote:
> syzbot reported a possible deadlock in pvclock_gtod_notify():
> 
> CPU 0  		  	   	    	    CPU 1
> write_seqcount_begin(&tk_core.seq);
>    pvclock_gtod_notify()			    spin_lock(&pool->lock);
>      queue_work(..., &pvclock_gtod_work)	    ktime_get()
>       spin_lock(&pool->lock);		      do {
>       						seq = read_seqcount_begin(tk_core.seq)
> 						...
> 				              } while (read_seqcount_retry(&tk_core.seq, seq);
> 
> While this is unlikely to happen, it's possible.
> 
> Delegate queue_work() to irq_work() which postpones it until the
> tk_core.seq write held region is left and interrupts are reenabled.
> 
> Fixes: 16e8d74d2da9 ("KVM: x86: notifier for clocksource changes")
> Reported-by: syzbot+6beae4000559d41d80f8@syzkaller.appspotmail.com
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> Link: https://lore.kernel.org/r/0000000000001d43ac05c0f5c6a0@google.com
> ---
>   arch/x86/kvm/x86.c |   22 ++++++++++++++++++----
>   1 file changed, 18 insertions(+), 4 deletions(-)
> 
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8040,6 +8040,18 @@ static void pvclock_gtod_update_fn(struc
>   static DECLARE_WORK(pvclock_gtod_work, pvclock_gtod_update_fn);
>   
>   /*
> + * Indirection to move queue_work() out of the tk_core.seq write held
> + * region to prevent possible deadlocks against time accessors which
> + * are invoked with work related locks held.
> + */
> +static void pvclock_irq_work_fn(struct irq_work *w)
> +{
> +	queue_work(system_long_wq, &pvclock_gtod_work);
> +}
> +
> +static DEFINE_IRQ_WORK(pvclock_irq_work, pvclock_irq_work_fn);
> +
> +/*
>    * Notification about pvclock gtod data update.
>    */
>   static int pvclock_gtod_notify(struct notifier_block *nb, unsigned long unused,
> @@ -8050,13 +8062,14 @@ static int pvclock_gtod_notify(struct no
>   
>   	update_pvclock_gtod(tk);
>   
> -	/* disable master clock if host does not trust, or does not
> -	 * use, TSC based clocksource.
> +	/*
> +	 * Disable master clock if host does not trust, or does not use,
> +	 * TSC based clocksource. Delegate queue_work() to irq_work as
> +	 * this is invoked with tk_core.seq write held.
>   	 */
>   	if (!gtod_is_based_on_tsc(gtod->clock.vclock_mode) &&
>   	    atomic_read(&kvm_guest_has_master_clock) != 0)
> -		queue_work(system_long_wq, &pvclock_gtod_work);
> -
> +		irq_work_queue(&pvclock_irq_work);
>   	return 0;
>   }
>   
> @@ -8168,6 +8181,7 @@ void kvm_arch_exit(void)
>   	cpuhp_remove_state_nocalls(CPUHP_AP_X86_KVM_CLK_ONLINE);
>   #ifdef CONFIG_X86_64
>   	pvclock_gtod_unregister_notifier(&pvclock_gtod_notifier);
> +	irq_work_sync(&pvclock_irq_work);
>   	cancel_work_sync(&pvclock_gtod_work);
>   #endif
>   	kvm_x86_ops.hardware_enable = NULL;
> 

Queued, thanks.

Paolo


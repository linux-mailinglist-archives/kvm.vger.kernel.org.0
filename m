Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B269F347830
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 13:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhCXMTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 08:19:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30712 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232276AbhCXMTR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Mar 2021 08:19:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616588356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cZiAAKs9ejvPZ3jXRcykVdCeorbUdVbH3T9vRLxzcWk=;
        b=NgeVZXWqtSXAZXk+rICOM+1mbTX5kM0cVSTCogVJjyQJTBJb5xvLnebo0HwCSyxU0HS5JL
        hhJBHw4SjJWq+zTyKIuzJK199/U7PWl6rIKGFI48kvhPkv+T9V9m+ImByKsyhKDKw3H0M5
        ScangEPm6j1vSsvClwx15z3Cw05yf64=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-PKmRBFBMPpSL8yVQRjwzig-1; Wed, 24 Mar 2021 08:19:13 -0400
X-MC-Unique: PKmRBFBMPpSL8yVQRjwzig-1
Received: by mail-wm1-f70.google.com with SMTP id a63so355809wmd.8
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 05:19:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cZiAAKs9ejvPZ3jXRcykVdCeorbUdVbH3T9vRLxzcWk=;
        b=Lpq8tbinPuQ5MovQkO6PrZLcH38GocXLXllQhc6GjbHUlFHsDDrk27TUyl79ZQY+ln
         CJwJPo9Gca5060Et0p/fT+0RW5Nrpdn7sNrLBhB4FI45N7Y9L0iL/t1Mw7hd82e5SLlV
         a+iKU5FhpOlQHS6xysU/Wlj81zw5QK9V1ZhaOaRe5ZGKpnfM/6XNzV37kWPxA1uJ2/gt
         i4fsapEPKT7xZ4DwXKhFuE+NEuOG0TDdwPWFRD8JbPotshRTUf7MMGGuAFWSi9sHHPnX
         5rI3f25DbqPgmrleCWkahCviaZTGC2HeV7DcoN+kbHTtzBtT3qOytEYOLHuzlrIrzV5B
         taMQ==
X-Gm-Message-State: AOAM532BAEuBsD0fDXHMmH4YhpZU1FN1U29s7aFbp3ullF+uGXRusbsJ
        83b2RPI66uO9zqVhDKxH4OmdYiHKiORqahyZJ34zOEXrLpiqxOhKfqcJUJuB4NCimZK2NBKPSuA
        VjmSHalKLvCxa
X-Received: by 2002:adf:dd47:: with SMTP id u7mr3218954wrm.13.1616588351834;
        Wed, 24 Mar 2021 05:19:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmTMhejcN6U3LW1m4Gy0NGVsHBhHf10k8b24Uu6SXwa0J/8lBL6q2Wqwxt4WNDnqXSItwvxA==
X-Received: by 2002:adf:dd47:: with SMTP id u7mr3218925wrm.13.1616588351623;
        Wed, 24 Mar 2021 05:19:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id g16sm3060902wrs.76.2021.03.24.05.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 05:19:11 -0700 (PDT)
Subject: Re: [syzbot] possible deadlock in scheduler_tick
To:     Wanpeng Li <kernellwp@gmail.com>,
        syzbot <syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        syzkaller-bugs@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        David Woodhouse <dwmw@amazon.co.uk>
References: <00000000000087f95b05be42a0c7@google.com>
 <CANRm+CwLouTk7r_J=0OqJ80sXY+sCPTZKEr3FyLiXgGiS5304w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f244df99-a063-af9d-d4a5-f23f906c4b9a@redhat.com>
Date:   Wed, 24 Mar 2021 13:19:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CwLouTk7r_J=0OqJ80sXY+sCPTZKEr3FyLiXgGiS5304w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/03/21 12:34, Wanpeng Li wrote:
> Cc David Woodhouse,
> On Wed, 24 Mar 2021 at 18:11, syzbot
> <syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    1c273e10 Merge tag 'zonefs-5.12-rc4' of git://git.kernel.o..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=13c0414ed00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=6abda3336c698a07
>> dashboard link: https://syzkaller.appspot.com/bug?extid=b282b65c2c68492df769
>> userspace arch: i386
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17d86ad6d00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17b8497cd00000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com
>>
>> =====================================================
>> WARNING: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected
>> 5.12.0-rc3-syzkaller #0 Not tainted
>> -----------------------------------------------------
>> syz-executor030/8435 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
>> ffffc90001a2a230 (&kvm->arch.pvclock_gtod_sync_lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
>> ffffc90001a2a230 (&kvm->arch.pvclock_gtod_sync_lock){+.+.}-{2:2}, at: get_kvmclock_ns+0x25/0x390 arch/x86/kvm/x86.c:2587
>>
>> and this task is already holding:
>> ffff8880b9d35198 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1321 [inline]
>> ffff8880b9d35198 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x21c/0x21b0 kernel/sched/core.c:4990
>> which would create a new lock dependency:
>>   (&rq->lock){-.-.}-{2:2} -> (&kvm->arch.pvclock_gtod_sync_lock){+.+.}-{2:2}
>>
>> but this new dependency connects a HARDIRQ-irq-safe lock:
>>   (&rq->lock){-.-.}-{2:2}
>>
>> ... which became HARDIRQ-irq-safe at:
>>    lock_acquire kernel/locking/lockdep.c:5510 [inline]
>>    lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
>>    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>>    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>>    rq_lock kernel/sched/sched.h:1321 [inline]
>>    scheduler_tick+0xa4/0x4b0 kernel/sched/core.c:4538
>>    update_process_times+0x191/0x200 kernel/time/timer.c:1801
>>    tick_periodic+0x79/0x230 kernel/time/tick-common.c:100
>>    tick_handle_periodic+0x41/0x120 kernel/time/tick-common.c:112
>>    timer_interrupt+0x3f/0x60 arch/x86/kernel/time.c:57
>>    __handle_irq_event_percpu+0x303/0x8f0 kernel/irq/handle.c:156
>>    handle_irq_event_percpu kernel/irq/handle.c:196 [inline]
>>    handle_irq_event+0x102/0x290 kernel/irq/handle.c:213
>>    handle_level_irq+0x256/0x6e0 kernel/irq/chip.c:650
>>    generic_handle_irq_desc include/linux/irqdesc.h:158 [inline]
>>    handle_irq arch/x86/kernel/irq.c:231 [inline]
>>    __common_interrupt+0x9e/0x200 arch/x86/kernel/irq.c:250
>>    common_interrupt+0x9f/0xd0 arch/x86/kernel/irq.c:240
>>    asm_common_interrupt+0x1e/0x40 arch/x86/include/asm/idtentry.h:623
>>    __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:161 [inline]
>>    _raw_spin_unlock_irqrestore+0x38/0x70 kernel/locking/spinlock.c:191
>>    __setup_irq+0xc72/0x1ce0 kernel/irq/manage.c:1737
>>    request_threaded_irq+0x28a/0x3b0 kernel/irq/manage.c:2127
>>    request_irq include/linux/interrupt.h:160 [inline]
>>    setup_default_timer_irq arch/x86/kernel/time.c:70 [inline]
>>    hpet_time_init+0x28/0x42 arch/x86/kernel/time.c:82
>>    x86_late_time_init+0x58/0x94 arch/x86/kernel/time.c:94
>>    start_kernel+0x3ee/0x496 init/main.c:1028
>>    secondary_startup_64_no_verify+0xb0/0xbb
>>
>> to a HARDIRQ-irq-unsafe lock:
>>   (&kvm->arch.pvclock_gtod_sync_lock){+.+.}-{2:2}
>>
>> ... which became HARDIRQ-irq-unsafe at:
>> ...
>>    lock_acquire kernel/locking/lockdep.c:5510 [inline]
>>    lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
>>    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>>    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>>    spin_lock include/linux/spinlock.h:354 [inline]
>>    kvm_synchronize_tsc+0x459/0x1230 arch/x86/kvm/x86.c:2332
>>    kvm_arch_vcpu_postcreate+0x73/0x180 arch/x86/kvm/x86.c:10183
>>    kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:3239 [inline]
>>    kvm_vm_ioctl+0x1b2d/0x2800 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3839
>>    kvm_vm_compat_ioctl+0x125/0x230 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4052
>>    __do_compat_sys_ioctl+0x1d3/0x230 fs/ioctl.c:842
>>    do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
>>    __do_fast_syscall_32+0x56/0x90 arch/x86/entry/common.c:140
>>    do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:165
>>    entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
>>
>> other info that might help us debug this:
>>
>>   Possible interrupt unsafe locking scenario:
>>
>>         CPU0                    CPU1
>>         ----                    ----
>>    lock(&kvm->arch.pvclock_gtod_sync_lock);
>>                                 local_irq_disable();
>>                                 lock(&rq->lock);
>>                                 lock(&kvm->arch.pvclock_gtod_sync_lock);
>>    <Interrupt>
>>      lock(&rq->lock);
>>
> 
> The offender is get_kvmclock_ns() which is called in the context
> switch process. The bad commit is 30b5c851af7991ad0 ("KVM: x86/xen:
> Add support for vCPU runstate information").
> 

I'll send a patch, thanks.

Paolo


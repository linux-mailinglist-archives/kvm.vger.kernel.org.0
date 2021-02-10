Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698AD315B8C
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 01:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbhBJApw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 19:45:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41668 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233440AbhBJAn3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 19:43:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612917713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OoKI80HZS6lCIrXTNzjB+lEIOXnmXDsoZF4iEGe3dto=;
        b=NDid4zDxnYrv/mO8OdFz1S7KVg1Ul4g+VYDsyx3jU00nkOcrA4j6o5ETr1lbmmlvzFQrah
        We38UwCegGlp6LgQoZxQODdkWcikHbNVDpOinHtkBIY7S0zW2cJeRaItcPXee+Dt3424/v
        4RfkmkfOk7fDcvQtRS+g963WoVzfKQI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14--po1ySDlMGm2TfU6JdE-jw-1; Tue, 09 Feb 2021 19:41:49 -0500
X-MC-Unique: -po1ySDlMGm2TfU6JdE-jw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62103804023;
        Wed, 10 Feb 2021 00:41:47 +0000 (UTC)
Received: from llong.remote.csb (ovpn-119-222.rdu2.redhat.com [10.10.119.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3274E60C61;
        Wed, 10 Feb 2021 00:41:42 +0000 (UTC)
Subject: Re: [PATCH v2 06/28] locking/rwlocks: Add contention detection for
 rwlocks
From:   Waiman Long <longman@redhat.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <dbueso@suse.de>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-7-bgardon@google.com>
 <20210209203908.GA255655@roeck-us.net>
 <3ee109cd-e406-4a70-17e8-dfeae7664f5f@redhat.com>
 <20210209222519.GA178687@roeck-us.net>
 <fc7792e2-26f1-2b37-fb79-002d8d6d4ef7@redhat.com>
Organization: Red Hat
Message-ID: <6fef33ce-f470-255b-0872-cc9dd057e857@redhat.com>
Date:   Tue, 9 Feb 2021 19:41:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <fc7792e2-26f1-2b37-fb79-002d8d6d4ef7@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/21 7:27 PM, Waiman Long wrote:
> On 2/9/21 5:25 PM, Guenter Roeck wrote:
>> On Tue, Feb 09, 2021 at 04:46:02PM -0500, Waiman Long wrote:
>>> On 2/9/21 3:39 PM, Guenter Roeck wrote:
>>>> On Tue, Feb 02, 2021 at 10:57:12AM -0800, Ben Gardon wrote:
>>>>> rwlocks do not currently have any facility to detect contention
>>>>> like spinlocks do. In order to allow users of rwlocks to better 
>>>>> manage
>>>>> latency, add contention detection for queued rwlocks.
>>>>>
>>>>> CC: Ingo Molnar <mingo@redhat.com>
>>>>> CC: Will Deacon <will@kernel.org>
>>>>> Acked-by: Peter Zijlstra <peterz@infradead.org>
>>>>> Acked-by: Davidlohr Bueso <dbueso@suse.de>
>>>>> Acked-by: Waiman Long <longman@redhat.com>
>>>>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>>>>> Signed-off-by: Ben Gardon <bgardon@google.com>
>>>> When building mips:defconfig, this patch results in:
>>>>
>>>> Error log:
>>>> In file included from include/linux/spinlock.h:90,
>>>>                    from include/linux/ipc.h:5,
>>>>                    from include/uapi/linux/sem.h:5,
>>>>                    from include/linux/sem.h:5,
>>>>                    from include/linux/compat.h:14,
>>>>                    from arch/mips/kernel/asm-offsets.c:12:
>>>> arch/mips/include/asm/spinlock.h:17:28: error: redefinition of 
>>>> 'queued_spin_unlock'
>>>>      17 | #define queued_spin_unlock queued_spin_unlock
>>>>         |                            ^~~~~~~~~~~~~~~~~~
>>>> arch/mips/include/asm/spinlock.h:22:20: note: in expansion of macro 
>>>> 'queued_spin_unlock'
>>>>      22 | static inline void queued_spin_unlock(struct qspinlock 
>>>> *lock)
>>>>         |                    ^~~~~~~~~~~~~~~~~~
>>>> In file included from include/asm-generic/qrwlock.h:17,
>>>>                    from ./arch/mips/include/generated/asm/qrwlock.h:1,
>>>>                    from arch/mips/include/asm/spinlock.h:13,
>>>>                    from include/linux/spinlock.h:90,
>>>>                    from include/linux/ipc.h:5,
>>>>                    from include/uapi/linux/sem.h:5,
>>>>                    from include/linux/sem.h:5,
>>>>                    from include/linux/compat.h:14,
>>>>                    from arch/mips/kernel/asm-offsets.c:12:
>>>> include/asm-generic/qspinlock.h:94:29: note: previous definition of 
>>>> 'queued_spin_unlock' was here
>>>>      94 | static __always_inline void queued_spin_unlock(struct 
>>>> qspinlock *lock)
>>>>         |                             ^~~~~~~~~~~~~~~~~~
>>> I think the compile error is caused by the improper header file 
>>> inclusion
>>> ordering. Can you try the following change to see if it can fix the 
>>> compile
>>> error?
>>>
>> That results in:
>>
>> In file included from ./arch/mips/include/generated/asm/qrwlock.h:1,
>>                   from ./arch/mips/include/asm/spinlock.h:13,
>>                   from ./include/linux/spinlock.h:90,
>>                   from ./include/linux/ipc.h:5,
>>                   from ./include/uapi/linux/sem.h:5,
>>                   from ./include/linux/sem.h:5,
>>                   from ./include/linux/compat.h:14,
>>                   from arch/mips/kernel/asm-offsets.c:12:
>> ./include/asm-generic/qrwlock.h: In function 
>> 'queued_rwlock_is_contended':
>> ./include/asm-generic/qrwlock.h:127:9: error: implicit declaration of 
>> function 'arch_spin_is_locked'
>>
>> Guenter
>
> It is because in arch/mips/include/asm/spinlock.h, asm/qrwlock.h is 
> included before asm/qspinlock.h. The compilation error should be gone 
> if the asm/qrwlock.h is removed or moved after asm/qspinlock.h. 

After thinking a bit more, I think we should remove asm/qrwlock.h in 
arch/mips/include/asm/spinlock.h. qrwlock and qspinlocks are 
independent. An architecture can include one but not the other. Also 
there is no point in including qrwlock.h in a asm/spinlock.h.

Regards,
Longman


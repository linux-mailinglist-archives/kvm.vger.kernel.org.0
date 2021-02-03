Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA2130E24A
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 19:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhBCSQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 13:16:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233015AbhBCSPt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 13:15:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612376063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JdIaLSZs1e7M958L0sW3Aol0GsSG/V+g7JLrbBtrz4o=;
        b=DKrsXtbdgFz7N0abTmeac78RN72Ctm3AvvNOic8bVP9BPJHB6EgdW/PlxdKn5CKgA/Bt21
        5CSYO1jPvy92+3PfT7/odPKiQyv7kACOpHv0ia8sylLgt6AaUVWV9WIVYbJKJfkuEOkNMO
        FVxRTa8umJGU+UQz15L9zHWncCFtPwg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-xh_0Try6MqOeCak9Di6xqQ-1; Wed, 03 Feb 2021 13:14:21 -0500
X-MC-Unique: xh_0Try6MqOeCak9Di6xqQ-1
Received: by mail-ed1-f71.google.com with SMTP id o8so354343edh.12
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 10:14:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JdIaLSZs1e7M958L0sW3Aol0GsSG/V+g7JLrbBtrz4o=;
        b=JdXpj7cJ9ijvAlxO9t/koPsF25hzG6IzG2yp6jRqNgG9auLW+9KjgzaA6do2Ud+81Q
         SkhBJsncYzoYYju5w3P4YbghNOalUjELk5fbJNG8sVreAb/tn9ffZM/0oPjkgGcuM2rc
         +6mTryN31N/tXDIZyvcNPBwU581EC8sQW/wfQWt9oL0on1W9yUKqZ48vYJe5N/FQgL6Q
         9YVe+BS9LvTi3CXIj/YpJEbJhBdM22N0OhaQ8eeZMzgbPHz09AqVBbsL7JyPTPcRkSRL
         nMQZulIPNLPK8BfM8AvKSojKboH5Tw4/AEZeVN6jvgHs66meKYsu05yLdTXmdcdRk2A6
         Odng==
X-Gm-Message-State: AOAM533NCMGJ2V5Xf1WnU/d22a3m5TYFo3ITHT/jFKYRGknARIKGCXeQ
        X7Ez02JcycRcIZn99z/4/OHCqRYx0uHncEG1ulkCiVjInT436mQYMXsdPyb42waNdjJ/zVmMWoz
        8m+VNm+Mg9vdhdyMnhd7imlrxVGEAwffl/el5DijogNzhFL0oFs0405CnntQXoPG6
X-Received: by 2002:a50:998f:: with SMTP id m15mr4377786edb.342.1612376059557;
        Wed, 03 Feb 2021 10:14:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxVO7xsOPGwXDcVCqLq9ZgDZlXY28pncBn+h4LzbxQFNbyiXVms+1iDJaMCWOhTA02Lht04rQ==
X-Received: by 2002:a50:998f:: with SMTP id m15mr4377762edb.342.1612376059264;
        Wed, 03 Feb 2021 10:14:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u9sm1259286edv.32.2021.02.03.10.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 10:14:18 -0800 (PST)
Subject: Re: [PATCH v2 18/28] KVM: x86/mmu: Use an rwlock for the x86 MMU
To:     Ben Gardon <bgardon@google.com>, KVM list <kvm@vger.kernel.org>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-19-bgardon@google.com>
 <c8aa8f9c-2305-5d58-3b48-261663524ad5@redhat.com>
 <CANgfPd_RxhBwM95MQQmGOdtmeH8c6=zPqUnXXHNV5Ta0R5R=iw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <106f4dff-703e-762e-d923-909d66b8fd0b@redhat.com>
Date:   Wed, 3 Feb 2021 19:14:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd_RxhBwM95MQQmGOdtmeH8c6=zPqUnXXHNV5Ta0R5R=iw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Sent offlist by mistake]

On 03/02/21 19:03, Ben Gardon wrote:
> On Wed, Feb 3, 2021 at 3:08 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 02/02/21 19:57, Ben Gardon wrote:
>>> Add a read / write lock to be used in place of the MMU spinlock on x86.
>>> The rwlock will enable the TDP MMU to handle page faults, and other
>>> operations in parallel in future commits.
>>>
>>> Reviewed-by: Peter Feiner <pfeiner@google.com>
>>> Signed-off-by: Ben Gardon <bgardon@google.com>
>>>
>>> ---
>>>
>>> v1 -> v2
>>> - Removed MMU lock wrappers
>>> - Completely replaced the MMU spinlock with an rwlock for x86
>>>
>>>    arch/x86/include/asm/kvm_host.h |  2 +
>>>    arch/x86/kvm/mmu/mmu.c          | 90 ++++++++++++++++-----------------
>>>    arch/x86/kvm/mmu/page_track.c   |  8 +--
>>>    arch/x86/kvm/mmu/paging_tmpl.h  |  8 +--
>>>    arch/x86/kvm/mmu/tdp_mmu.c      | 20 ++++----
>>>    arch/x86/kvm/x86.c              |  4 +-
>>>    include/linux/kvm_host.h        |  5 ++
>>>    virt/kvm/dirty_ring.c           | 10 ++++
>>>    virt/kvm/kvm_main.c             | 46 +++++++++++------
>>>    9 files changed, 112 insertions(+), 81 deletions(-)
>>
>> Let's create a new header file, to abstract this even more.
>>
>> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
>> index 70ba572f6e5c..3eeb8c0e9590 100644
>> --- a/virt/kvm/dirty_ring.c
>> +++ b/virt/kvm/dirty_ring.c
>> @@ -9,6 +9,7 @@
>>    #include <linux/vmalloc.h>
>>    #include <linux/kvm_dirty_ring.h>
>>    #include <trace/events/kvm.h>
>> +#include "mmu_lock.h"
>>
>>    int __weak kvm_cpu_dirty_log_size(void)
>>    {
>> @@ -60,19 +61,9 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32
>> slot, u64 offset, u64 mask)
>>          if (!memslot || (offset + __fls(mask)) >= memslot->npages)
>>                  return;
>>
>> -#ifdef KVM_HAVE_MMU_RWLOCK
>> -       write_lock(&kvm->mmu_lock);
>> -#else
>> -       spin_lock(&kvm->mmu_lock);
>> -#endif /* KVM_HAVE_MMU_RWLOCK */
>> -
>> +       KVM_MMU_LOCK(kvm);
>>          kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mask);
>> -
>> -#ifdef KVM_HAVE_MMU_RWLOCK
>> -       write_unlock(&kvm->mmu_lock);
>> -#else
>> -       spin_unlock(&kvm->mmu_lock);
>> -#endif /* KVM_HAVE_MMU_RWLOCK */
>> +       KVM_MMU_UNLOCK(kvm);
>>    }
>>
>>    int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size)
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 6f0c1473b474..356068103f8a 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -58,6 +58,7 @@
>>
>>    #include "coalesced_mmio.h"
>>    #include "async_pf.h"
>> +#include "mmu_lock.h"
>>    #include "vfio.h"
>>
>>    #define CREATE_TRACE_POINTS
>> @@ -450,14 +451,6 @@ static void
>> kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
>>          srcu_read_unlock(&kvm->srcu, idx);
>>    }
>>
>> -#ifdef KVM_HAVE_MMU_RWLOCK
>> -#define KVM_MMU_LOCK(kvm) write_lock(&kvm->mmu_lock)
>> -#define KVM_MMU_UNLOCK(kvm) write_unlock(&kvm->mmu_lock)
>> -#else
>> -#define KVM_MMU_LOCK(kvm) spin_lock(&kvm->mmu_lock)
>> -#define KVM_MMU_UNLOCK(kvm) spin_unlock(&kvm->mmu_lock)
>> -#endif /* KVM_HAVE_MMU_RWLOCK */
>> -
>>    static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
>>                                          struct mm_struct *mm,
>>                                          unsigned long address,
>> @@ -755,11 +748,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>>          if (!kvm)
>>                  return ERR_PTR(-ENOMEM);
>>
>> -#ifdef KVM_HAVE_MMU_RWLOCK
>> -       rwlock_init(&kvm->mmu_lock);
>> -#else
>> -       spin_lock_init(&kvm->mmu_lock);
>> -#endif /* KVM_HAVE_MMU_RWLOCK */
>> +       KVM_MMU_LOCK_INIT(kvm);
>>          mmgrab(current->mm);
>>          kvm->mm = current->mm;
>>          kvm_eventfd_init(kvm);
>> diff --git a/virt/kvm/mmu_lock.h b/virt/kvm/mmu_lock.h
>> new file mode 100644
>> index 000000000000..1dd1ca2cdc77
>> --- /dev/null
>> +++ b/virt/kvm/mmu_lock.h
>> @@ -0,0 +1,23 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +
>> +#ifndef KVM_MMU_LOCK_H
>> +#define KVM_MMU_LOCK_H 1
>> +
>> +/*
>> + * Architectures can choose whether to use an rwlock or spinlock
>> + * for the mmu_lock.  These macros, for use in common code
>> + * only, avoids using #ifdefs in places that must deal with
>> + * multiple architectures.
>> + */
>> +
>> +#ifdef KVM_HAVE_MMU_RWLOCK
>> +#define KVM_MMU_LOCK_INIT(kvm) rwlock_init(&(kvm)->mmu_lock)
>> +#define KVM_MMU_LOCK(kvm)      write_lock(&(kvm)->mmu_lock)
>> +#define KVM_MMU_UNLOCK(kvm)    write_unlock(&(kvm)->mmu_lock)
>> +#else
>> +#define KVM_MMU_LOCK_INIT(kvm) spin_lock_init(&(kvm)->mmu_lock)
>> +#define KVM_MMU_LOCK(kvm)      spin_lock(&(kvm)->mmu_lock)
>> +#define KVM_MMU_UNLOCK(kvm)    spin_unlock(&(kvm)->mmu_lock)
>> +#endif /* KVM_HAVE_MMU_RWLOCK */
>> +
>> +#endif
>>
> 
> That sounds good to me. I don't know if you meant to send that
> off-list, but I'm happy to make that change in a v3.

No, I didn't.  At this point I'm crossing fingers that there's no v3 
(except for the couple patches at the end).


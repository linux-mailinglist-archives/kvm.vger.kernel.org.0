Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3DC257A16
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 15:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgHaNJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 09:09:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27345 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727786AbgHaNJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 09:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598879361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l2GnCcv2WvVq5iCUqDhGffUDjlXCs353uZj6NC6srVM=;
        b=Z/CcgAopq/6i6ULRgyXIVrRnhIm9JDBvCUJAdeGa+0yTuoQGBs0tWJV88IiDI++nIhJJ6i
        hpAWQYlG1j4KsIrXemHcLPqm/jXD91JB2drGS8r/ryvucGj9CIbfMwzIJjFpeuixkjuYCL
        c6JqcJp/8IyFbcCkJTGaicWG0i66eCk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-RBwECqLmPfWb9yPtQ9H_-w-1; Mon, 31 Aug 2020 09:09:19 -0400
X-MC-Unique: RBwECqLmPfWb9yPtQ9H_-w-1
Received: by mail-wm1-f71.google.com with SMTP id c72so463453wme.4
        for <kvm@vger.kernel.org>; Mon, 31 Aug 2020 06:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=l2GnCcv2WvVq5iCUqDhGffUDjlXCs353uZj6NC6srVM=;
        b=ImcXIxZ8qlCSi1FIHUY+3yZra6fQVWaz6ZNjXoBsSWY6Sj6nSpAfy7PDU3oqxV+lYT
         k3sdVrvGcNg1x2gCMwIWpac2Q4JowTGpKs2Hg41Q+eN7z11ivsQFECimuvaTZIkQUK0m
         RDIuHLouH7429vtsuiEaBkP29YFKGZlOzo3YezTLLrRdwSmTwoEnmwHJBN9RuR6Ab0JQ
         dgD6/WSUzaVjLVGkPrf/omAGeAAREQrmpp38L89Zv8KTFn8oV5JYN/qRyNTfuPOdIfD6
         HSDXXi8DTN65V3DPw0oHiTmMAvHlzYGiatplCBlqX7aCWfBnXnOHhLWTla8Oy4Q8JJIF
         5KWA==
X-Gm-Message-State: AOAM532F3MW3XIc6zEFK15EehwpmRwJ6iTFulegKuZ3r8OCEov7Z7foa
        5S17thVNnpRJkGk/XFZUTegwSaDzDhuqh2QH9w7TKIluv7YURYDHoozmAur97AKRWbhe7ji6wZ1
        LJfFn03nFCBOr
X-Received: by 2002:adf:cc8c:: with SMTP id p12mr1710325wrj.92.1598879357917;
        Mon, 31 Aug 2020 06:09:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/1+vKHyvkY7iAfm+ukdoRDuyURSwkR27pytCRbfzdoM7lD9CNUTZ+Lt7aTkXhxMzxGsxqHA==
X-Received: by 2002:adf:cc8c:: with SMTP id p12mr1710303wrj.92.1598879357649;
        Mon, 31 Aug 2020 06:09:17 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k184sm11767549wme.1.2020.08.31.06.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 06:09:16 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] kvm x86/mmu: use KVM_REQ_MMU_SYNC to sync when needed
In-Reply-To: <CAJhGHyC1Ykq5V_2nFPLRz9JmtAiQu6aw4fCKo1LO7Qwzjvfg2g@mail.gmail.com>
References: <20200824101825.4106-1-jiangshanlai@gmail.com> <CAJhGHyC1Ykq5V_2nFPLRz9JmtAiQu6aw4fCKo1LO7Qwzjvfg2g@mail.gmail.com>
Date:   Mon, 31 Aug 2020 15:09:15 +0200
Message-ID: <875z8zx8qs.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lai Jiangshan <jiangshanlai@gmail.com> writes:

> Ping @Sean Christopherson
>

Let's try 'Beetlejuice' instead :-)

> On Mon, Aug 24, 2020 at 5:18 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>>
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> 8c8560b83390("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes)
>> changed it without giving any reason in the changelog.
>>
>> In theory, the syncing is needed, and need to be fixed by reverting
>> this part of change.

Even if the original commit is not wordy enough this is hardly
better. Are you seeing a particular scenario when a change in current
vCPU's MMU requires flushing TLB entries for *other* contexts, ... (see
below)

>>
>> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
>> ---
>>  arch/x86/kvm/mmu/mmu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 4e03841f053d..9a93de921f2b 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -2468,7 +2468,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>>                 }
>>
>>                 if (sp->unsync_children)
>> -                       kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>> +                       kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);

... in particular, why are you reverting only this hunk? Please elaborate.

>>
>>                 __clear_sp_write_flooding_count(sp);
>>
>> --
>> 2.19.1.6.gb485710b
>>
>

-- 
Vitaly


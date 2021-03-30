Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C0034E553
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 12:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhC3KVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 06:21:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231828AbhC3KVh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 06:21:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617099697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZKmA1XTWo9ftjD4D+AGaK0+IVZowP/ZF3jSZIUehoOo=;
        b=Vx8Zs8TbhCpuYVUXEil1nDGp1l3OWrnHVgwknyNCsgaYm8/P9y+SmqhNSkTFIrf6e7y+mq
        1tWsi8jqnGp4dIbwHzOvt5ymnYLb7VjZwO8QvvjmHB9QbGDXajiH4+BcDuXnLqVjNMOS5Q
        QdALeCXLX7+qhjPuGY8lS5lIR2zWlwA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-L5pOzaVPMAqp4Cy7vVXJZg-1; Tue, 30 Mar 2021 06:21:35 -0400
X-MC-Unique: L5pOzaVPMAqp4Cy7vVXJZg-1
Received: by mail-ed1-f70.google.com with SMTP id w18so9964734edu.5
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 03:21:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZKmA1XTWo9ftjD4D+AGaK0+IVZowP/ZF3jSZIUehoOo=;
        b=Pop+l0qieTbvUGsysJqXzHstTdNDuqI6KfTC8xZoNbRdlldm4+8RC+gqp9a2m5n/Ep
         h0ZnxQVc1tF9HjF0vtcOGWXylZPoaRHBrLr8J1tcq/0OI5OOb7tvMMtLKaCPUJdaZRR1
         xFafD3r1BRt0kQS+vY/xq2rlSLpyrJObLz/XTElIGHX/81Pi5ki2sg9T48HpBgje6zzX
         qCNBFQVdHV2plgzK/Y0wk5zHaB3FtD0AxRWCWF/Hu7vrrAubcw47GWAc5ewnfZTJ8IVu
         q/ZElc5y7NdTh28W8QBHdDrT3wsCpU9v4UHxTPvPhYmz0ML0tLijWs0fQKIhd5z6MnkT
         6ZGA==
X-Gm-Message-State: AOAM532citOj58v2riayVD7IOX7YTn35+mhatygjpAkjqTN4sAgj44R7
        TvdRJ3H10iNW5vA0YKEkfqTdlK+aHZ7eVo3GEtb8z/tx/8Txsp18k/VNp/oUS3v1yPDoLBA6K+y
        PpbwsJyIDq3gN
X-Received: by 2002:a05:6402:1691:: with SMTP id a17mr33152095edv.336.1617099693908;
        Tue, 30 Mar 2021 03:21:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyujffrO5JuyOKzMt1CRsyH5qabFJylKLKAOomG38U3RZAxOX589/hbm+W9AZe29AZePEkDxQ==
X-Received: by 2002:a05:6402:1691:: with SMTP id a17mr33152082edv.336.1617099693730;
        Tue, 30 Mar 2021 03:21:33 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id br13sm9757928ejb.87.2021.03.30.03.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 03:21:33 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: hyper-v: Properly divide
 maybe-negative 'hv_clock->system_time' in compute_tsc_page_parameters()
In-Reply-To: <YGINPcQxyco2WueO@google.com>
References: <20210329114800.164066-1-vkuznets@redhat.com>
 <20210329114800.164066-2-vkuznets@redhat.com>
 <YGINPcQxyco2WueO@google.com>
Date:   Tue, 30 Mar 2021 12:21:32 +0200
Message-ID: <87o8f1t00j.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Mar 29, 2021, Vitaly Kuznetsov wrote:
>> When guest time is reset with KVM_SET_CLOCK(0), it is possible for
>> hv_clock->system_time to become a small negative number. This happens
>> because in KVM_SET_CLOCK handling we set kvm->arch.kvmclock_offset based
>> on get_kvmclock_ns(kvm) but when KVM_REQ_CLOCK_UPDATE is handled,
>> kvm_guest_time_update() does
>> 
>> hv_clock.system_time = ka->master_kernel_ns + v->kvm->arch.kvmclock_offset;
>> 
>> And 'master_kernel_ns' represents the last time when masterclock
>> got updated, it can precede KVM_SET_CLOCK() call. Normally, this is not a
>> problem, the difference is very small, e.g. I'm observing
>> hv_clock.system_time = -70 ns. The issue comes from the fact that
>> 'hv_clock.system_time' is stored as unsigned and 'system_time / 100' in
>> compute_tsc_page_parameters() becomes a very big number.
>> 
>> Use div_s64() to get the proper result when dividing maybe-negative
>> 'hv_clock.system_time' by 100.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/hyperv.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index f98370a39936..0529b892f634 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -1070,10 +1070,13 @@ static bool compute_tsc_page_parameters(struct pvclock_vcpu_time_info *hv_clock,
>>  				hv_clock->tsc_to_system_mul,
>>  				100);
>>  
>> -	tsc_ref->tsc_offset = hv_clock->system_time;
>> -	do_div(tsc_ref->tsc_offset, 100);
>> -	tsc_ref->tsc_offset -=
>> +	/*
>> +	 * Note: 'hv_clock->system_time' despite being 'u64' can hold a negative
>> +	 * value here, thus div_s64().
>> +	 */
>
> Will anything break if hv_clock.system_time is made a s64?
>

I think no, but pvclock-abi.h says:

"
 * These structs MUST NOT be changed.
 * They are the ABI between hypervisor and guest OS.
 * Both Xen and KVM are using this.
"

so I was kind of scared to suggest a change...

-- 
Vitaly


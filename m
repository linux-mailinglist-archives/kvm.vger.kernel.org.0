Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3E933C09B
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 16:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhCOPzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 11:55:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33571 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229505AbhCOPzM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 11:55:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615823711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2RtrMeo7+6C33syP/ppW8DPH4IpAYTqGXSBD94o2bnM=;
        b=b+3UI9ad5/Fe7wiWOzOYthnzuuctZfjlXXXFRZFt+r7EU8ISchFG1vkKFeyMHZW6nSVx61
        rkJMeb5Um9A4HDDANB5FQEg4qpJNhEXMJeJjpGnWsWfdlxzvOsSwGVLqYumGbprrL0UghW
        UruhbCVuE8xDwI42rozUB3QfOixoLZo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-rJMheXL_Oh235P8r2DIqPw-1; Mon, 15 Mar 2021 11:55:09 -0400
X-MC-Unique: rJMheXL_Oh235P8r2DIqPw-1
Received: by mail-wr1-f71.google.com with SMTP id e13so15258699wrg.4
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 08:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2RtrMeo7+6C33syP/ppW8DPH4IpAYTqGXSBD94o2bnM=;
        b=szJrjTLY1UKE2VIYz8h6rgv116T4a3+1dMqLtUJjunEToJyq4n/TBfhvnkpqORFHTZ
         njQrAQUSCMdUoXgvWJWLeHUFLRmtSNN89vlG6AQqmDNhjc4qesNIuGrWCg5vZasg6F9M
         RbSyn1aOXg8mnVaEN1/zOSwjeLc2PVhYhLF1M/VgQXHjhCf2J6GmHgK6d3DCQYR/U0cM
         tXBPxWqCtaK39f+HeITeiYfCQWZ2RkB9LBxvaj2wjIsa6gVXg4fPc/cqw1iCcyk6Xak8
         /mBaZ4ODUgzer6IHvHWK5bSfHXB1vnxjYxdLcyprkWsMeSCaOIQCp/dtjS2FAmPMZgoI
         dnDg==
X-Gm-Message-State: AOAM532vPJ3dkJkL9i0H0RBzOMk6W1EuHxjXyr+ofLd0yOVrqIAwv/LI
        Chl1Pp2sN7iDivV3KUL4yuMwk2Nzs0c+egIP4py3tChBY7rta0PfeAeo3ATSpvGgR6uCI60T3pM
        WztwB13XxqWDK
X-Received: by 2002:a7b:c357:: with SMTP id l23mr353365wmj.152.1615823708621;
        Mon, 15 Mar 2021 08:55:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJx3VlQMxD8rYju3Oz2hSAowohPcCGOlnoGzzv6kx4rhbdXE1UOxszvKj4SO0QA0jYMNH2+w==
X-Received: by 2002:a7b:c357:: with SMTP id l23mr353355wmj.152.1615823708481;
        Mon, 15 Mar 2021 08:55:08 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i10sm18066324wrs.11.2021.03.15.08.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 08:55:08 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 2/4] KVM: x86: hyper-v: Prevent using not-yet-updated
 TSC page by secondary CPUs
In-Reply-To: <6b392d7e-8135-53a9-9040-f6f5e316c6cb@redhat.com>
References: <20210315143706.859293-1-vkuznets@redhat.com>
 <20210315143706.859293-3-vkuznets@redhat.com>
 <6b392d7e-8135-53a9-9040-f6f5e316c6cb@redhat.com>
Date:   Mon, 15 Mar 2021 16:55:07 +0100
Message-ID: <87im5s8l9g.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 15/03/21 15:37, Vitaly Kuznetsov wrote:
>> When KVM_REQ_MASTERCLOCK_UPDATE request is issued (e.g. after migration)
>> we need to make sure no vCPU sees stale values in PV clock structures and
>> thus all vCPUs are kicked with KVM_REQ_CLOCK_UPDATE. Hyper-V TSC page
>> clocksource is global and kvm_guest_time_update() only updates in on vCPU0
>> but this is not entirely correct: nothing blocks some other vCPU from
>> entering the guest before we finish the update on CPU0 and it can read
>> stale values from the page.
>> 
>> Call kvm_hv_setup_tsc_page() on all vCPUs. Normally, KVM_REQ_CLOCK_UPDATE
>> should be very rare so we may not care much about being wasteful.
>
> I think we should instead write 0 to the page in kvm_gen_update_masterclock.
>

We can do that but we will also need to invalidate
hv->tsc_ref.tsc_sequence to prevent MSR based clocksource
(HV_X64_MSR_TIME_REF_COUNT -> get_time_ref_counter()) from using stale
hv->tsc_ref.tsc_scale/tsc_offset values (in case we had them
calculated).

Also, we can't really disable TSC page for nested scenario when guest
opted for reenlightenment (PATCH4) but we're not going to update the
page anyway so there's not much different.

> Paolo
>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 47e021bdcc94..882c509bfc86 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2748,8 +2748,9 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>>   				       offsetof(struct compat_vcpu_info, time));
>>   	if (vcpu->xen.vcpu_time_info_set)
>>   		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
>> -	if (v == kvm_get_vcpu(v->kvm, 0))
>> -		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
>> +
>> +	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
>> +
>>   	return 0;
>>   }
>>   
>> 
>

-- 
Vitaly


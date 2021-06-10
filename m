Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE673A246F
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 08:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhFJGY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 02:24:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229778AbhFJGY4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 02:24:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623306180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y9OIQ37NN86b1J9AvzEspXWjtjFLEFdsV3WicIqcSRs=;
        b=i1U5cOZ2v5sjHf3xUaw4yXg+SD7l0L0L6vyKN3eXcXBgCd2SF7IvZvThOXmuaKJlcgdEqd
        ybjaNamOOxI3E+Z+hEDQdmMVjOneFKvGEJuSbKgtkf43mZlP1oGlzon6ezD+3Gt2yThFvW
        6CUTsD9XTEDriRarXZqV97gG/nVMpfQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-un74YOB3NRiXegnM3YKfNA-1; Thu, 10 Jun 2021 02:22:57 -0400
X-MC-Unique: un74YOB3NRiXegnM3YKfNA-1
Received: by mail-wm1-f69.google.com with SMTP id n2-20020a05600c3b82b02901aeb7a4ac06so3386291wms.5
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 23:22:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y9OIQ37NN86b1J9AvzEspXWjtjFLEFdsV3WicIqcSRs=;
        b=P/oU2MsXD9f2kuOOWr+csvznEqHBqoeE9KUzr7snVu2nDGsGir2k/m/5zgZjJFZt4g
         zvsL8TT3OQpIRyQzeGZs/O7hXdF6pD4ehk2MDHElDwZ7ryj85+RIhrXlxUA0v+jgiwDf
         S8jIBri9ERi/B+rY2o8IcsdinCiScGF6k53tAxhU6kHRV0muSf+dXj5MGmOtmAZOaR6d
         O7PFQEUW+gkDBLSE3IBZ9EcjK8ZY7C1HytlTaD0QskPZhNeh6r/diRUnt6YivIQrNW9T
         wH5XKKo/PzCWhnOGx14HeGWpnAOENsAte92E3bhUZ1so7I5UHYdkQdtO/AzHdCYQgY/c
         BCIw==
X-Gm-Message-State: AOAM5327YOnxHnU+MV1pGzOXu+pUg18wvMrfLD8g9Tw0OxuIMfdwkGvY
        BSOPD+JsnDYjVAs71XkeTM3/FuMMTDZ2O/Dt5sJgwuIZF0pOaZuxG+mlUVUGU5L3WPCRHr8vq1L
        D3QNBTju/tE+y
X-Received: by 2002:a1c:4304:: with SMTP id q4mr12694511wma.89.1623306176574;
        Wed, 09 Jun 2021 23:22:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZTfWBq0Fv/sP2kbhWGpCObvkcy+Kk8Uv1WxLCdGVISIn/nfvKSLGOLnAS9rw4rbGo0hCx6w==
X-Received: by 2002:a1c:4304:: with SMTP id q4mr12694493wma.89.1623306176334;
        Wed, 09 Jun 2021 23:22:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m132sm1862894wmf.10.2021.06.09.23.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 23:22:55 -0700 (PDT)
To:     Oliver Upton <oupton@google.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
References: <20210608214742.1897483-1-oupton@google.com>
 <63db3823-b8a3-578d-4baa-146104bb977f@redhat.com>
 <CAOQ_QsgPHAUuzeLy5sX=EhE8tKs7yEF3rxM47YeM_Pk3DUXMcg@mail.gmail.com>
 <d5a79989-6866-a405-5501-a3b1223b2ecd@redhat.com>
 <CAOQ_QsgvmmiQgV5rUBnNtoz+NfwEe2e4ebfpe8rJviR20QUjoQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 00/10] KVM: Add idempotent controls for migrating system
 counter state
Message-ID: <7b57ce79-6a17-70ac-4639-47a0df463e49@redhat.com>
Date:   Thu, 10 Jun 2021 08:22:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOQ_QsgvmmiQgV5rUBnNtoz+NfwEe2e4ebfpe8rJviR20QUjoQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/21 00:04, Oliver Upton wrote:
>> Your approach still needs to use the "quirky" approach to host-initiated
>> MSR_IA32_TSC_ADJUST writes, which write the MSR without affecting the
>> VMCS offset.  This is just a documentation issue.
> 
> My suggested ioctl for the vCPU will still exist, and it will still
> affect the VMCS tsc offset, right? However, we need to do one of the
> following:
> 
> - Stash the guest's MSR_IA32_TSC_ADJUST value in the
> kvm_system_counter_state structure. During
> KVM_SET_SYSTEM_COUNTER_STATE, check to see if the field is valid. If
> so, treat it as a dumb value (i.e. show it to the guest but don't fold
> it into the offset).

Yes, it's already folded into the guestTSC-hostTSC offset that the 
caller provides.

> - Inform userspace that it must still migrate MSR_IA32_TSC_ADJUST, and
> continue to our quirky behavior around host-initiated writes of the
> MSR.
> 
> This is why Maxim's spin migrated a value for IA32_TSC_ADJUST, right?

Yes, so that he could then remove (optionally) the quirk for 
host-initiated writes to the TSC and TSC_ADJUST MSRs.

> Doing so ensures we don't have any guest-observable consequences due
> to our migration of TSC state. To me, adding the guest IA32_TSC_ADJUST
> MSR into the new counter state structure is probably best. No strong
> opinions in either direction on this point, though:)

Either is good for me, since documentation will be very important either 
way.  This is a complex API to use due to the possibility of skewed TSCs.

Just one thing, please don't introduce a new ioctl and use 
KVM_GET_DEVICE_ATTR/KVM_SET_DEVICE_ATTR/KVM_HAS_DEVICE_ATTR.

Christian, based on what Oliver mentions here, it's probably useful for 
s390 to have functionality to get/set kvm->arch.epoch and kvm->arch.epdx 
in addition to the absolute TOD values that you are migrating now.

Paolo

>> 1) In the kernel:
>>
>> * KVM_GET_CLOCK should also return kvmclock_ns - realtime_ns and
>> host_TSC.  It should set two flags in struct kvm_clock_data saying that
>> the respective fields are valid.
>>
>> * KVM_SET_CLOCK checks the flag for kvmclock_ns - realtime_ns.  If set,
>> it looks at the kvmclock_ns - realtime_ns field and disregards the
>> kvmclock_ns field.
>>
>> 2) On the source, userspace will:
>>
>> * per-VM: invoke KVM_GET_CLOCK.  Migrate kvmclock_ns - realtime_ns and
>> kvmclock_ns.  Stash host_TSC for subsequent use.
>>
>> * per-vCPU: retrieve guest_TSC - host_TSC with your new ioctl.  Sum it
>> to the stashed host_TSC value; migrate the resulting value (a guest TSC).
>>
>> 3) On the destination:
>>
>> * per-VM: Pass the migrated kvmclock_ns - realtime_ns to KVM_SET_CLOCK.
>>   Use KVM_GET_CLOCK to get a consistent pair of kvmclock_ns ("newNS"
>> below) and host TSC ("newHostTSC").  Stash them for subsequent use,
>> together with the migrated kvmclock_ns value ("sourceNS") that you
>> haven't used yet.
>>
>> * per-vCPU: using the data of the previous step, and the sourceGuestTSC
>> in the migration stream, compute sourceGuestTSC + (newNS - sourceNS) *
>> freq - newHostTSC.  This is the TSC offset to be passed to your new ioctl.


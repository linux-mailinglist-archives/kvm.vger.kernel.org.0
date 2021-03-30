Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEA434EACB
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 16:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbhC3OpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 10:45:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58756 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232082AbhC3Ooo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 10:44:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617115483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8oV679DP/iNhdvBIRqE4RRGamFWEXfcrx8eMPG+AlfQ=;
        b=hQ601MaLWANdT9+2cyFezGFATfwru+SPKXcvcb5e51NkgH25ta2orvTmVhjVYpDmf6J8Z5
        QQZqRq+7cCLqvoKosgYydzKcEUifH2wKydFR0KCI8pWb3zTYTz0Xvv5/p2cQ0LuLCsVBUw
        8h43gq5UUG+1V/qZ+bXmpbNi63ePrXQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-ik25oT_SNAODcqaHD5HPdQ-1; Tue, 30 Mar 2021 10:44:31 -0400
X-MC-Unique: ik25oT_SNAODcqaHD5HPdQ-1
Received: by mail-ed1-f71.google.com with SMTP id r19so10317318edv.3
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 07:44:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=8oV679DP/iNhdvBIRqE4RRGamFWEXfcrx8eMPG+AlfQ=;
        b=sIB8jt2JOjXOaQYDPOR+dQzVylmn+1twOnIHgGhR82ecxxwgzCfuc/mp5HcO+EJvR8
         TGQdtqKiQNIrRRSPxXWXliIlZPIN4NQpEOybyk9MX+efrWX4GkTwN+NkwXkf1Ea15S3k
         6OsObx5megJy7TNGg7xLtvLILkXy+RNkmK02b2Ef8o+YdJG8CqxdW8z2UFO195TLKihV
         NIt9dXkcPX44WPWJXxJiHbfsot+DG5PrW2Z74l8Vi1guGBlkyxNbeFGAW10Z04Ui3kmx
         Zuk7+Pgp/2qzMIHy4lxTguMUK18Av8tLgwCGN5hTJanN0S/CMsRgtZZany2VWxJU5S1+
         MkWg==
X-Gm-Message-State: AOAM530pFfmWE1qX//HyiPy7zDh0wsq6dgGs3w6I/YIDQguzKq+0soXt
        6Zju9yoCtV7U9uVHdqVo1stuHrDiFaPWRJtJrg9fTgO7Nn8GJ8kq9IrHIJ8on+uMzzi3xI1gHFw
        pBUhdYHbyRApg
X-Received: by 2002:a17:906:37db:: with SMTP id o27mr34527338ejc.60.1617115470565;
        Tue, 30 Mar 2021 07:44:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYiRaT5uqeJeR3HetGlLhHI1wzPhBik1gPG1VEtQ6Ou1+YnbNnLabUKLOKi1y3CFKh7IuCxA==
X-Received: by 2002:a17:906:37db:: with SMTP id o27mr34527313ejc.60.1617115470289;
        Tue, 30 Mar 2021 07:44:30 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j25sm11457904edy.9.2021.03.30.07.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 07:44:29 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: hyper-v: Properly divide
 maybe-negative 'hv_clock->system_time' in compute_tsc_page_parameters()
In-Reply-To: <20210330131236.GA5932@fuller.cnet>
References: <20210329114800.164066-1-vkuznets@redhat.com>
 <20210329114800.164066-2-vkuznets@redhat.com>
 <20210330131236.GA5932@fuller.cnet>
Date:   Tue, 30 Mar 2021 16:44:29 +0200
Message-ID: <87ft0cu2eq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marcelo Tosatti <mtosatti@redhat.com> writes:

> Hi Vitaly,
>
> On Mon, Mar 29, 2021 at 01:47:59PM +0200, Vitaly Kuznetsov wrote:
>> When guest time is reset with KVM_SET_CLOCK(0), it is possible for
>> hv_clock->system_time to become a small negative number. This happens
>> because in KVM_SET_CLOCK handling we set kvm->arch.kvmclock_offset based
>> on get_kvmclock_ns(kvm) but when KVM_REQ_CLOCK_UPDATE is handled,
>> kvm_guest_time_update() does
>> 
>> hv_clock.system_time = ka->master_kernel_ns + v->kvm->arch.kvmclock_offset;
>
> Hum, masterclock update should always precede KVM_SET_CLOCK() call.
>
> So when KVM_SET_CLOCK(0) is called, we'd like the guest (or the
> following):
>
> static __always_inline
> u64 __pvclock_read_cycles(const struct pvclock_vcpu_time_info *src, u64 tsc)
> {
>         u64 delta = tsc - src->tsc_timestamp;
>         u64 offset = pvclock_scale_delta(delta, src->tsc_to_system_mul,
>                                              src->tsc_shift);
>         return src->system_time + offset;
> }
>
> To return 0 (which won't happen if pvclock_data->system_time is being
> initialized to a negative value).
>
> 	KVM_SET_CLOCK(0)
>
>  	kvm_gen_update_masterclock(kvm);
> 	now_ns = get_kvmclock_ns(kvm);
> 	kvm->arch.kvmclock_offset += user_ns.clock - now_ns = -now_ns; 
>
> 	hv_clock.tsc_timestamp = ka->master_cycle_now;
>         hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
>
> Wonder if the negative value happens due to the switch from
> masterclock=off -> on (get_kvmclock_ns reading kernel time directly).
>
> Perhaps this error is being added to clock when migration is performed.
>

The issue is very easy to reproduce if you take the selftest (PATCH2
from this series), it is just a simple KVM_SET_CLOCK(0) call which makes
Hyper-V TSC page value very very big.

The order of events is:

KVM_SET_CLOCK(0) is performed and we set 

	        now_ns = get_kvmclock_ns(kvm);
                kvm->arch.kvmclock_offset += user_ns.clock - now_ns;

user_ns.clock is zero here. Note, we use get_kvmclock_ns() which gives
the precise kvmclock value for the moment , to simplify things a bit:

 kvm->arch.kvmclock_offset = kvmclock_offset - master_kernel_ns -
 kvmclock_offset - pvclock_scale_delta() == -master_kernel_ns - pvclock_scale_delta()
 
pvclock_scale_delta() is time since the begining of the time
interval.

Now we call kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE) and
this leads to kvm_guest_time_update(). In kvm_guest_time_update() we do:

	if (use_master_clock) {
                host_tsc = ka->master_cycle_now;
                kernel_ns = ka->master_kernel_ns;
        }
        ...
        vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;

Note, we don't add the delta since the beginning of the time interval
(assuming we are still on the same interval) so combined with the
above:

vcpu->hv_clock.system_time = master_kernel_ns - master_kernel_ns -
pvclock_scale_delta() == -pvclock_scale_delta()

and this is certainly a negative number. A very small one, but it's
negative.

We could've solved the problem by reducing the precision a bit and
instead of doing 

 now_ns = get_kvmclock_ns(kvm);

in KVM_SET_CLOCK() handling we could do

 now_ns = ka->master_kernel_ns

and that would make vcpu->hv_clock.system_time == 0 after
kvm_guest_time_update() but it'd hurt 'normal' use-cases to fix the
corner case.

> But just thinking out loud...
>
>> And 'master_kernel_ns' represents the last time when masterclock
>> got updated, it can precede KVM_SET_CLOCK() call. Normally, this is not a
>> problem, the difference is very small, e.g. I'm observing
>> hv_clock.system_time = -70 ns. The issue comes from the fact that
>> 'hv_clock.system_time' is stored as unsigned and 'system_time / 100' in
>> compute_tsc_page_parameters() becomes a very big number.
>
> Which it is (a very big number).
>
>> Use div_s64() to get the proper result when dividing maybe-negative
>> 'hv_clock.system_time' by 100.
>
> Well hv_clock.system_time is not negative. It is positive.
>
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
>> +	tsc_ref->tsc_offset = div_s64(hv_clock->system_time, 100) -
>>  		mul_u64_u64_shr(hv_clock->tsc_timestamp, tsc_ref->tsc_scale, 64);
>> +
>>  	return true;
>>  }
>
> Won't the guest see:
>
> 0.1, 0.005, 0.0025, 0.0001, ..., 0, 0.0001, 0.0025, 0.005, 0.1, ...
>
> As system_time progresses from negative value to positive value with
> the above fix?
>
> While the fix seems OK in practice, perhaps the negative system_time 
> could be fixed instead.

Well, that was v1 of the patch where I suggested to clamp system_time
value to 0 in kvm_guest_time_update() but Paolo talked me into this v2
:-)

-- 
Vitaly


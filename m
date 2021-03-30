Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DDA34E8A6
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 15:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhC3NOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 09:14:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231848AbhC3NOL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 09:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617110050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0twi1z0PJOp6ywJ5GbyQdDoa8bz2Dk1LUKuuh/XBBMo=;
        b=YSwXgfE7lq9DhEDBURwgGtYd7OlGKO7Assal1FbXCgS7cKLhvp3G29WvIOP1GXZhXME26d
        9SxhBifwf45JloI65U8GoP5MK4bMsXc/6jTzmjTlqlL/xI4ziGYl/pj2ItXqqUwAPyeAlV
        ypGGDE+1kYTPv5Fh1WNXqAfnmgMWl/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-DpIWWDtrN2Gi8kg1f2a8tw-1; Tue, 30 Mar 2021 09:14:07 -0400
X-MC-Unique: DpIWWDtrN2Gi8kg1f2a8tw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68EFEA40C1;
        Tue, 30 Mar 2021 13:14:05 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 92CED1037E83;
        Tue, 30 Mar 2021 13:14:04 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 669F9416CD79; Tue, 30 Mar 2021 10:12:36 -0300 (-03)
Date:   Tue, 30 Mar 2021 10:12:36 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: hyper-v: Properly divide maybe-negative
 'hv_clock->system_time' in compute_tsc_page_parameters()
Message-ID: <20210330131236.GA5932@fuller.cnet>
References: <20210329114800.164066-1-vkuznets@redhat.com>
 <20210329114800.164066-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329114800.164066-2-vkuznets@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Vitaly,

On Mon, Mar 29, 2021 at 01:47:59PM +0200, Vitaly Kuznetsov wrote:
> When guest time is reset with KVM_SET_CLOCK(0), it is possible for
> hv_clock->system_time to become a small negative number. This happens
> because in KVM_SET_CLOCK handling we set kvm->arch.kvmclock_offset based
> on get_kvmclock_ns(kvm) but when KVM_REQ_CLOCK_UPDATE is handled,
> kvm_guest_time_update() does
> 
> hv_clock.system_time = ka->master_kernel_ns + v->kvm->arch.kvmclock_offset;

Hum, masterclock update should always precede KVM_SET_CLOCK() call.

So when KVM_SET_CLOCK(0) is called, we'd like the guest (or the
following):

static __always_inline
u64 __pvclock_read_cycles(const struct pvclock_vcpu_time_info *src, u64 tsc)
{
        u64 delta = tsc - src->tsc_timestamp;
        u64 offset = pvclock_scale_delta(delta, src->tsc_to_system_mul,
                                             src->tsc_shift);
        return src->system_time + offset;
}

To return 0 (which won't happen if pvclock_data->system_time is being
initialized to a negative value).

	KVM_SET_CLOCK(0)

 	kvm_gen_update_masterclock(kvm);
	now_ns = get_kvmclock_ns(kvm);
	kvm->arch.kvmclock_offset += user_ns.clock - now_ns = -now_ns; 

	hv_clock.tsc_timestamp = ka->master_cycle_now;
        hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;

Wonder if the negative value happens due to the switch from
masterclock=off -> on (get_kvmclock_ns reading kernel time directly).

Perhaps this error is being added to clock when migration is performed.

But just thinking out loud...

> And 'master_kernel_ns' represents the last time when masterclock
> got updated, it can precede KVM_SET_CLOCK() call. Normally, this is not a
> problem, the difference is very small, e.g. I'm observing
> hv_clock.system_time = -70 ns. The issue comes from the fact that
> 'hv_clock.system_time' is stored as unsigned and 'system_time / 100' in
> compute_tsc_page_parameters() becomes a very big number.

Which it is (a very big number).

> Use div_s64() to get the proper result when dividing maybe-negative
> 'hv_clock.system_time' by 100.

Well hv_clock.system_time is not negative. It is positive.

> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index f98370a39936..0529b892f634 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1070,10 +1070,13 @@ static bool compute_tsc_page_parameters(struct pvclock_vcpu_time_info *hv_clock,
>  				hv_clock->tsc_to_system_mul,
>  				100);
>  
> -	tsc_ref->tsc_offset = hv_clock->system_time;
> -	do_div(tsc_ref->tsc_offset, 100);
> -	tsc_ref->tsc_offset -=
> +	/*
> +	 * Note: 'hv_clock->system_time' despite being 'u64' can hold a negative
> +	 * value here, thus div_s64().
> +	 */
> +	tsc_ref->tsc_offset = div_s64(hv_clock->system_time, 100) -
>  		mul_u64_u64_shr(hv_clock->tsc_timestamp, tsc_ref->tsc_scale, 64);
> +
>  	return true;
>  }

Won't the guest see:

0.1, 0.005, 0.0025, 0.0001, ..., 0, 0.0001, 0.0025, 0.005, 0.1, ...

As system_time progresses from negative value to positive value with
the above fix?

While the fix seems OK in practice, perhaps the negative system_time 
could be fixed instead.



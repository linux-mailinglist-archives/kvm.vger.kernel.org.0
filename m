Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12BF34EA06
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 16:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhC3ONS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 10:13:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20654 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231803AbhC3ONC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 10:13:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617113582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hyd2xCYibl1HZruNMHz3cEH8jei/5ja38vogxu4xMX8=;
        b=A7Nfh7dnGDS4ONoVPtaP7m7G+TdEPe8klFvZ25hFTf1u8FrqlqynoW0GXg2qMsjQltB9in
        dWB9YM6mt8Bl4yOaN+Zi4Hp0B11X3c7GlnQ7kuZ5AtabbJ4j4HWkgMw+VDFD2Q19fp0MU6
        p+I41YF1xFL5wVBTCX0BYn/zIl6Ubf0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-TedcgJzbPOSutpJjOsqwUA-1; Tue, 30 Mar 2021 10:12:58 -0400
X-MC-Unique: TedcgJzbPOSutpJjOsqwUA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85D961083E81;
        Tue, 30 Mar 2021 14:12:57 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 12B895D740;
        Tue, 30 Mar 2021 14:12:57 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 495A1416D862; Tue, 30 Mar 2021 11:12:32 -0300 (-03)
Date:   Tue, 30 Mar 2021 11:12:32 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: hyper-v: Properly divide maybe-negative
 'hv_clock->system_time' in compute_tsc_page_parameters()
Message-ID: <20210330141232.GA10559@fuller.cnet>
References: <20210329114800.164066-1-vkuznets@redhat.com>
 <20210329114800.164066-2-vkuznets@redhat.com>
 <YGINPcQxyco2WueO@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGINPcQxyco2WueO@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 29, 2021 at 05:24:13PM +0000, Sean Christopherson wrote:
> On Mon, Mar 29, 2021, Vitaly Kuznetsov wrote:
> > When guest time is reset with KVM_SET_CLOCK(0), it is possible for
> > hv_clock->system_time to become a small negative number. This happens
> > because in KVM_SET_CLOCK handling we set kvm->arch.kvmclock_offset based
> > on get_kvmclock_ns(kvm) but when KVM_REQ_CLOCK_UPDATE is handled,
> > kvm_guest_time_update() does
> > 
> > hv_clock.system_time = ka->master_kernel_ns + v->kvm->arch.kvmclock_offset;
> > 
> > And 'master_kernel_ns' represents the last time when masterclock
> > got updated, it can precede KVM_SET_CLOCK() call. Normally, this is not a
> > problem, the difference is very small, e.g. I'm observing
> > hv_clock.system_time = -70 ns. The issue comes from the fact that
> > 'hv_clock.system_time' is stored as unsigned and 'system_time / 100' in
> > compute_tsc_page_parameters() becomes a very big number.
> > 
> > Use div_s64() to get the proper result when dividing maybe-negative
> > 'hv_clock.system_time' by 100.
> > 
> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > ---
> >  arch/x86/kvm/hyperv.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index f98370a39936..0529b892f634 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -1070,10 +1070,13 @@ static bool compute_tsc_page_parameters(struct pvclock_vcpu_time_info *hv_clock,
> >  				hv_clock->tsc_to_system_mul,
> >  				100);
> >  
> > -	tsc_ref->tsc_offset = hv_clock->system_time;
> > -	do_div(tsc_ref->tsc_offset, 100);
> > -	tsc_ref->tsc_offset -=
> > +	/*
> > +	 * Note: 'hv_clock->system_time' despite being 'u64' can hold a negative
> > +	 * value here, thus div_s64().
> > +	 */
> 
> Will anything break if hv_clock.system_time is made a s64?

IMHO hv_clock.system_time represents an unsigned value:

        system_time:
                a host notion of monotonic time, including sleep
                time at the time this structure was last updated. Unit is
                nanoseconds.


Delta between values is not transmitted through this variable, 
so unclear what negative values would mean.



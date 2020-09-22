Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B47527475B
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 19:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgIVRWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 13:22:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgIVRWr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 13:22:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600795365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KigQAlr6UDmkQYx0L4r7q/CQ87ZmKU7WeTN3EhF7o1U=;
        b=Xj+E0UhpMIrmbp/ZZhbdVAgtzEEW+KR0xzT9bg/++xFBLj1fPyC0Dfrn6dy8mlYTyUyCdG
        xURyDw42ygj3N54gl78531uMkWwHAU2uRlJmauFGC+oFbVdC2qmS5ZFDJr/wXCa1nXXKBp
        7I096nhYgmJEeOT+/cdf/sLNfxqVBOE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-iB7jGidHOHy5WQMu-BGUQg-1; Tue, 22 Sep 2020 13:22:35 -0400
X-MC-Unique: iB7jGidHOHy5WQMu-BGUQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B1E1802B5E;
        Tue, 22 Sep 2020 17:22:34 +0000 (UTC)
Received: from localhost (unknown [10.10.67.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2177614F5;
        Tue, 22 Sep 2020 17:22:30 +0000 (UTC)
Date:   Tue, 22 Sep 2020 13:22:29 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     qemu-devel@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        1896263@bugs.launchpad.net, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH] i386: Don't try to set MSR_KVM_ASYNC_PF_EN if
 kernel-irqchip=off
Message-ID: <20200922172229.GB57321@habkost.net>
References: <20200922151455.1763896-1-ehabkost@redhat.com>
 <87v9g5es9n.fsf@vitty.brq.redhat.com>
 <20200922161055.GY57321@habkost.net>
 <87pn6depau.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87pn6depau.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 22, 2020 at 06:42:17PM +0200, Vitaly Kuznetsov wrote:
> Eduardo Habkost <ehabkost@redhat.com> writes:
> 
> > On Tue, Sep 22, 2020 at 05:38:12PM +0200, Vitaly Kuznetsov wrote:
> >> Eduardo Habkost <ehabkost@redhat.com> writes:
> >> 
> >> > This addresses the following crash when running Linux v5.8
> >> > with kernel-irqchip=off:
> >> >
> >> >   qemu-system-x86_64: error: failed to set MSR 0x4b564d02 to 0x0
> >> >   qemu-system-x86_64: ../target/i386/kvm.c:2714: kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
> >> >
> >> > There is a kernel-side fix for the issue too (kernel commit
> >> > d831de177217 "KVM: x86: always allow writing '0' to
> >> > MSR_KVM_ASYNC_PF_EN"), but it's nice to simply not trigger
> >> > the bug if running an older kernel.
> >> >
> >> > Fixes: https://bugs.launchpad.net/bugs/1896263
> >> > Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> >> > ---
> >> >  target/i386/kvm.c | 7 ++++++-
> >> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> >> > index 9efb07e7c83..1492f41349f 100644
> >> > --- a/target/i386/kvm.c
> >> > +++ b/target/i386/kvm.c
> >> > @@ -2818,7 +2818,12 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
> >> >          kvm_msr_entry_add(cpu, MSR_IA32_TSC, env->tsc);
> >> >          kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
> >> >          kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
> >> > -        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF)) {
> >> > +        /*
> >> > +         * Some kernel versions (v5.8) won't let MSR_KVM_ASYNC_PF_EN to be set
> >> > +         * at all if kernel-irqchip=off, so don't try to set it in that case.
> >> > +         */
> >> > +        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF) &&
> >> > +            kvm_irqchip_in_kernel()) {
> >> >              kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_EN, env->async_pf_en_msr);
> >> >          }
> >> >          if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_PV_EOI)) {
> >> 
> >> I'm not sure kvm_irqchip_in_kernel() was required before we switched to
> >> interrupt-based APF (as we were always injecting #PF) but with
> >> kernel-5.8+ this should work. [...]
> >
> > Were guests able to set MSR_KVM_ASYNC_PF_EN to non-zero with
> > kernel-irqchip=off on hosts running Linux <= 5.7? 
> 
> lapic_in_kernel() check appeared in kernel with the following commit:
> 
> commit 9d3c447c72fb2337ca39f245c6ae89f2369de216
> Author: Wanpeng Li <wanpengli@tencent.com>
> Date:   Mon Jun 29 18:26:31 2020 +0800
> 
>     KVM: X86: Fix async pf caused null-ptr-deref
> 
> which was post-interrupt-based-APF. I *think* it was OK to enable APF
> with !lapic_in_kernel() before (at least I don't see what would not
> allow that).

If it was possible, did KVM break live migration of
kernel-irqchip=off guests that enabled APF?  This would mean my
patch is replacing a crash with a silent migration bug.  Not nice
either way.

> 
> > I am assuming
> > kvm-asyncpf never worked with kernel-irqchip=off (and enabling it
> > by default with kernel-irqchip=off was a mistake).
> >
> >
> >>                         [...] We'll need to merge this with
> >> 
> >> https://lists.nongnu.org/archive/html/qemu-devel/2020-09/msg02963.html
> >> (queued by Paolo) and
> >> https://lists.nongnu.org/archive/html/qemu-devel/2020-09/msg06196.html
> >> which fixes a bug in it.
> >> 
> >> as kvm_irqchip_in_kernel() should go around both KVM_FEATURE_ASYNC_PF
> >> and KVM_FEATURE_ASYNC_PF_INT I believe.
> >
> > Shouldn't we just disallow kvm-asyncpf-int=on if kernel-irqchip=off?
> 
> (Sarcasm: if disallowing 'kernel-irqchip=off' is not an option, then)

I'm working on it.  :-)

> yes, we probably can, but kvm-asyncpf-int=on is the default we have so
> we can't just implicitly change it underneath or migration will break...

kvm-asyncpf-int wasn't merged yet, was it?  This means we don't
have compatibility issues to care about.

-- 
Eduardo


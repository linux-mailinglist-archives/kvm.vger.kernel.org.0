Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FD63C28B5
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 19:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhGIRtw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 13:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhGIRtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 13:49:52 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA8DC0613DD
        for <kvm@vger.kernel.org>; Fri,  9 Jul 2021 10:47:08 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id f5so10696554pgv.3
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 10:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=30xPD7GYzAZX0IiGmAfrxnKmuF0NjhprTumuFzuoNBk=;
        b=NcbG3Xa8GsfmeXQ3FKD6sb0VfgW3UhLhVKE/aq75ryTkyNqG3RWv23QAkLEVAVscYX
         9ltB971OBaKW9DYEQYPhPc7ql8P1plsqEyKX/k7+SMmFXBMfdxPeaGfiIYBv7pNPrYD7
         gWtRf73EDG7NtR3PR2e6D9kkzKksRTf8pMC7J3h9PeTj63TBou16tulJaZuSaQLVyKSZ
         /vmusUpmF0CHCL+gAwYYekd8WFrjoO36fCATu7H6VhO3SvBe6Pwy5RGliDDa5zZn6Urs
         gEZ9HtBOIPYH6baJO7kHfSaspxYcwjk54RKWV4FylAFmWHDoVEKJhRySQaGJXvavcuTx
         WyCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=30xPD7GYzAZX0IiGmAfrxnKmuF0NjhprTumuFzuoNBk=;
        b=G2CvAZX6I+U/C/XkibbMSCM0F+ELDYQisaZNb7BCrI93VuytGbiOo8+TFLherFvu1T
         UwIi+G1TbhK2nDi8TUnCl+mklwj/WRi7UVs8jXklYWssAj3Cn235NkeiRqTfpOyrDHEE
         suqB/SlvFcL4Xg92QKJ6xEDM6D5Fi51ZR24nRmqJDwrc8lEbKTfOwG9TYI8Ua66JRqAw
         +Lvr8OXUMNVQS/+M8iF6QU5RPrF+BPLHEnseByuEBm2cLxWnBLKeSQBMzUQdvmRqLYZr
         z/YpfBASyFu2H6nQP/UlfTLoiGkbP0L0ldfAa1PYM9L9hGwIiW9Z+xHWFVY0IiOdEFj/
         S9Yg==
X-Gm-Message-State: AOAM5301Mbl/uNvms1v00TvZCbXu/UI/eSlO4zH1hkyn2YglQZ43vsVz
        bCA8QPH5C0BnDDOwsWygNLV0OA==
X-Google-Smtp-Source: ABdhPJzi/k+BTzieAqVzIcdKlZ6oGGuY3N8an0oVLOPqPkTzJtAZDNYsCnOBCzcgW65azzz5XmaBFg==
X-Received: by 2002:a62:b515:0:b029:318:dc18:dd13 with SMTP id y21-20020a62b5150000b0290318dc18dd13mr37896963pfe.18.1625852827165;
        Fri, 09 Jul 2021 10:47:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n34sm5990682pji.45.2021.07.09.10.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 10:47:06 -0700 (PDT)
Date:   Fri, 9 Jul 2021 17:47:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Venkatesh Srinivas <venkateshs@chromium.org>, kvm@vger.kernel.org,
        jmattson@google.com, elver@google.com, dvyukov@google.com
Subject: Re: [PATCH] KVM: kvm_vcpu_kick: Do not read potentially-stale
 vcpu->cpu
Message-ID: <YOiLlqZBhEK0hsie@google.com>
References: <20210630031037.584190-1-venkateshs@chromium.org>
 <YNyayUOiDDZ9V3Ex@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNyayUOiDDZ9V3Ex@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 30, 2021, David Matlack wrote:
> On Tue, Jun 29, 2021 at 08:10:37PM -0700, Venkatesh Srinivas wrote:
> > vcpu->cpu contains the last cpu a vcpu run/is running on;
> > kvm_vcpu_kick is used to 'kick' a guest vcpu by sending an IPI
> > to the last CPU; vcpu->cpu is updated on sched_in when a vcpu
> > moves to a new CPU, so it possible for the vcpu->cpu field to
> > be stale.

This fails to document the actual bug being fixed, and why the fix is correct.
The fact that vcpu->cpu may be stale is itself not a bug, e.g. even with this
patch, the IPI can be sent to the "wrong", i.e. smp_send_reschedule() can still
consume a stale vcpu->cpu.

The bug that's being fixed is that grabbing the potentially-stale vcpu->cpu
_before_ kvm_arch_vcpu_should_kick() can cause KVM to send an IPI to the wrong
CPU _and_ let the vCPU run longer than intended.  The fix is correct because KVM
doesn't truly care about sending an IPI to the correct pCPU, it only cares about
about kicking the pCPU out of the guest.  If the vCPU has exited and been loaded
on a different pCPU after kvm_arch_vcpu_should_kick(), then its mission has been
accomplished and the IPI (to the wrong pCPU) is truly spurious.

> > kvm_vcpu_kick also read vcpu->cpu early with a plain read,
> > while vcpu->cpu could be concurrently written. This caused
> > a data race, found by kcsan:
> > 
> > write to 0xffff8880274e8460 of 4 bytes by task 30718 on cpu 0:
> >  kvm_arch_vcpu_load arch/x86/kvm/x86.c:4018
> >  kvm_sched_in virt/kvm/kvm_main.c:4864
> > 
> > vs
> >  kvm_vcpu_kick virt/kvm/kvm_main.c:2909
> >  kvm_arch_async_page_present_queued arch/x86/kvm/x86.c:11287
> >  async_pf_execute virt/kvm/async_pf.c:79
> >  ...
> > 
> > Use a READ_ONCE to atomically read vcpu->cpu and avoid the
> > data race.
> > 
> > Found by kcsan & syzbot.
> > 
> > Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>

Suggested-by: Sean Christopherson <seanjc@google.com>

> Reviewed-by: David Matlack <dmatlack@google.com>
> 
> > ---
> >  virt/kvm/kvm_main.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 46fb042837d2..0525f42afb7d 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3058,16 +3058,18 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
> >   */
> >  void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
> >  {
> > -	int me;
> > -	int cpu = vcpu->cpu;
> > +	int me, cpu;
> >  
> >  	if (kvm_vcpu_wake_up(vcpu))
> >  		return;
> >  
> >  	me = get_cpu();
> > -	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
> > -		if (kvm_arch_vcpu_should_kick(vcpu))
> > +	if (kvm_arch_vcpu_should_kick(vcpu)) {
> > +		cpu = READ_ONCE(vcpu->cpu);
> > +		WARN_ON_ONCE(cpu == me);
> 
> nit: A comment here may be useful to explain the interaction with
> kvm_arch_vcpu_should_kick(). Took me a minute to understand why you
> added the warning.

Agreed.

> > +		if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
> >  			smp_send_reschedule(cpu);
> > +	}
> >  	put_cpu();
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
> > -- 
> > 2.30.2
> > 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6F623F5DB
	for <lists+kvm@lfdr.de>; Sat,  8 Aug 2020 04:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgHHCCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 22:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbgHHCCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 22:02:19 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 556122177B;
        Sat,  8 Aug 2020 02:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596852139;
        bh=M7e8nNoyl6EfhVREHZ1cwRCgUZ9WV4iuP8Lr8RQENGQ=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=P+dL/kbC21xqwm4MeFcFFSwlJ8q4EKHQOUFMZjB0clfwtOtL2iLnEJEn9LZc8S9Xm
         YpXGoVETQhbTrhLcofm0J6lSLgmQIkCpxR1GSK1KepipeMyS8s09o/xiC2YMhWrnTk
         RK3f+Zm6nEK3efxqfgK4HpiawCrPuv7jYcYNTLM4=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 3563935206C1; Fri,  7 Aug 2020 19:02:19 -0700 (PDT)
Date:   Fri, 7 Aug 2020 19:02:19 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: Guest OS migration and lost IPIs
Message-ID: <20200808020219.GA4295@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200805000720.GA7516@paulmck-ThinkPad-P72>
 <191fd6d6-a66e-06b1-aa6e-9a0f12efcfc8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <191fd6d6-a66e-06b1-aa6e-9a0f12efcfc8@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 07, 2020 at 02:36:17PM +0200, Paolo Bonzini wrote:
> On 05/08/20 02:07, Paul E. McKenney wrote:
> > 
> > We are seeing occasional odd hangs, but only in cases where guest OSes
> > are being migrated.  Migrating more often makes the hangs happen more
> > frequently.
> > 
> > Added debug showed that the hung CPU is stuck trying to send an IPI (e.g.,
> > smp_call_function_single()).  The hung CPU thinks that it has sent the
> > IPI, but the destination CPU has interrupts enabled (-not- disabled,
> > enabled, as in ready, willing, and able to take interrupts).  In fact,
> > the destination CPU usually is going about its business as if nothing
> > was wrong, which makes me suspect that the IPI got lost somewhere along
> > the way.
> > 
> > I bumbled a bit through the qemu and KVM source, and didn't find anything
> > synchronizing IPIs and migrations, though given that I know pretty much
> > nothing about either qemu or KVM, this doesn't count for much.
> 
> The code migrating the interrupt controller is in
> kvm_x86_ops.sync_pir_to_irr (which calls vmx_sync_pir_to_irr) and
> kvm_apic_get_state.  kvm_apic_get_state is called after CPUs are stopped.
> 
> It's possible that we're missing a kvm_x86_ops.sync_pir_to_irr call
> somewhere.  It would be surprising but it would explain the symptoms
> very well.

Thank you for the info, Paolo!  I will see what I can find.  ;-)

							Thanx, Paul

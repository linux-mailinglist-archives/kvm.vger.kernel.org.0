Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD303BA05
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2019 18:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbfFJQva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 12:51:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49454 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbfFJQva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 12:51:30 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 56651308213B;
        Mon, 10 Jun 2019 16:51:30 +0000 (UTC)
Received: from flask (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5CB085C1B4;
        Mon, 10 Jun 2019 16:51:28 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Mon, 10 Jun 2019 18:51:27 +0200
Date:   Mon, 10 Jun 2019 18:51:27 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/3] KVM: LAPIC: lapic timer interrupt is injected by
 posted interrupt
Message-ID: <20190610165127.GA8389@flask>
References: <1559799086-13912-1-git-send-email-wanpengli@tencent.com>
 <1559799086-13912-3-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559799086-13912-3-git-send-email-wanpengli@tencent.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 10 Jun 2019 16:51:30 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

2019-06-06 13:31+0800, Wanpeng Li:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Dedicated instances are currently disturbed by unnecessary jitter due 
> to the emulated lapic timers fire on the same pCPUs which vCPUs resident.
> There is no hardware virtual timer on Intel for guest like ARM. Both 
> programming timer in guest and the emulated timer fires incur vmexits.
> This patch tries to avoid vmexit which is incurred by the emulated 
> timer fires in dedicated instance scenario. 
> 
> When nohz_full is enabled in dedicated instances scenario, the emulated 
> timers can be offload to the nearest busy housekeeping cpus since APICv 
> is really common in recent years. The guest timer interrupt is injected 
> by posted-interrupt which is delivered by housekeeping cpu once the emulated 
> timer fires. 
> 
> 3%~5% redis performance benefit can be observed on Skylake server.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 32 +++++++++++++++++++++++++-------
>  arch/x86/kvm/x86.h   |  5 +++++
>  2 files changed, 30 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 09b7387..c08e5a8 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -133,6 +133,12 @@ static inline bool posted_interrupt_inject_timer_enabled(struct kvm_vcpu *vcpu)
>  		kvm_mwait_in_guest(vcpu->kvm);
>  }
>  
> +static inline bool can_posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
> +{
> +	return posted_interrupt_inject_timer_enabled(vcpu) &&
> +		!vcpu_halt_in_guest(vcpu);

It would make more sense to have a condition for general blocking in
KVM, but keep in mind that we're not running on the same cpu anymore, so
any code like that has to be properly protected against VM entries under
our hands.  (The VCPU could appear halted here, but before we get make
the timer pending, the VCPU would enter and potentially never check the
interrupt.)

I think we should be able to simply do

  if (posted_interrupt_inject_timer_enabled(vcpu))
  	kvm_inject_apic_timer_irqs();

directly in the apic_timer_expired() as the injection will wake up the
target if necessary.  It's going to be a bit slow for timer callback in
those (too slow to warrant special handling?), but there hopefully
aren't any context restrictions in place.


Thanks.

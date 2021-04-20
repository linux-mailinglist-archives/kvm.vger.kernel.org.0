Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C467366262
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 01:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhDTXOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 19:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233964AbhDTXOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 19:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DA4661077;
        Tue, 20 Apr 2021 23:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618960445;
        bh=bABGXNgRwbfLWHYv8TT/2SyXxSMeEs2k/LJH89x02lw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D+2IPr9ZOe5jKZ2c0lXeYydwIcYu3A+FuKw45WQLjoU521n3B5QrFEeDY08wy2Q+y
         FnNoVqoimzaAqghTiPSC9aBQswy2JgHoBUzqQrjp0UeYHkBYXMIKYUGqFbXoo+GYXA
         2T6fLZJylvV0ebt+JOvtzvF/C4HqKPpcGY3coC14fTMZzCVgdr1SKmfa/A3Zrkgn6F
         BEqEFaqat1A/0lmTbAb0TVomACdTaWXodg8fBZw1bLE/IQuNMftfwGxQw/vkFi7GFO
         mrYVOd8GSG+GcMB568g9Teo8kudZdJbmOTJDO4xdNx9pgjgCAU4do261+JYsUyfQnO
         6ngwJ8s8AH7XQ==
Date:   Wed, 21 Apr 2021 01:14:02 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v3 3/9] KVM: x86: Defer tick-based accounting 'til after
 IRQ handling
Message-ID: <20210420231402.GA8720@lothringen>
References: <20210415222106.1643837-1-seanjc@google.com>
 <20210415222106.1643837-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415222106.1643837-4-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 15, 2021 at 03:21:00PM -0700, Sean Christopherson wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> When using tick-based accounting, defer the call to account guest time
> until after servicing any IRQ(s) that happened in the guest or
> immediately after VM-Exit.  Tick-based accounting of vCPU time relies on
> PF_VCPU being set when the tick IRQ handler runs, and IRQs are blocked
> throughout {svm,vmx}_vcpu_enter_exit().
> 
> This fixes a bug[*] where reported guest time remains '0', even when
> running an infinite loop in the guest.
> 
> [*] https://bugzilla.kernel.org/show_bug.cgi?id=209831
> 
> Fixes: 87fa7f3e98a131 ("x86/kvm: Move context tracking where it belongs")
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Michael Tokarev <mjt@tls.msk.ru>
> Cc: stable@vger.kernel.org#v5.9-rc1+
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 16fb39503296..e4d475df1d4a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9230,6 +9230,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	local_irq_disable();
>  	kvm_after_interrupt(vcpu);
>  
> +	/*
> +	 * When using tick-based accounting, wait until after servicing IRQs to
> +	 * account guest time so that any ticks that occurred while running the
> +	 * guest are properly accounted to the guest.
> +	 */
> +	if (!vtime_accounting_enabled_this_cpu())
> +		vtime_account_guest_exit();

Can we rather have instead:

static inline void tick_account_guest_exit(void)
{
	if (!vtime_accounting_enabled_this_cpu())
		current->flags &= ~PF_VCPU;
}

It duplicates a bit of code but I think this will read less confusing.

Thanks.

> +
>  	if (lapic_in_kernel(vcpu)) {
>  		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
>  		if (delta != S64_MIN) {
> -- 
> 2.31.1.368.gbe11c130af-goog
> 

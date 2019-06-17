Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE2348140
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 13:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFQLs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 07:48:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46120 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbfFQLs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 07:48:57 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 443A130872E6;
        Mon, 17 Jun 2019 11:48:57 +0000 (UTC)
Received: from xz-x1 (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D05847DF6F;
        Mon, 17 Jun 2019 11:48:54 +0000 (UTC)
Date:   Mon, 17 Jun 2019 19:48:51 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 1/5] KVM: LAPIC: Make lapic timer unpinned
Message-ID: <20190617114850.GC30983@xz-x1>
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
 <1560770687-23227-2-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1560770687-23227-2-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 17 Jun 2019 11:48:57 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 17, 2019 at 07:24:43PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Make lapic timer unpinned when timer is injected by posted-interrupt,

It has nothing to do with PI, yet?

And, how about mentioning 61abdbe0bc and telling that this could be
another solution for that problem (but will be used in follow up
patches)?

> the emulated timer can be offload to the housekeeping cpus, kick after 
> setting the pending timer request as alternative to commit 61abdbe0bcc.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 8 ++++----
>  arch/x86/kvm/x86.c   | 6 +-----
>  2 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index e82a18c..87ecb56 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1578,7 +1578,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
>  	    likely(ns > apic->lapic_timer.timer_advance_ns)) {
>  		expire = ktime_add_ns(now, ns);
>  		expire = ktime_sub_ns(expire, ktimer->timer_advance_ns);
> -		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS_PINNED);
> +		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS);
>  	} else
>  		apic_timer_expired(apic);
>  
> @@ -1680,7 +1680,7 @@ static void start_sw_period(struct kvm_lapic *apic)
>  
>  	hrtimer_start(&apic->lapic_timer.timer,
>  		apic->lapic_timer.target_expiration,
> -		HRTIMER_MODE_ABS_PINNED);
> +		HRTIMER_MODE_ABS);
>  }
>  
>  bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu)
> @@ -2317,7 +2317,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>  	apic->vcpu = vcpu;
>  
>  	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
> -		     HRTIMER_MODE_ABS_PINNED);
> +		     HRTIMER_MODE_ABS);
>  	apic->lapic_timer.timer.function = apic_timer_fn;
>  	if (timer_advance_ns == -1) {
>  		apic->lapic_timer.timer_advance_ns = 1000;
> @@ -2506,7 +2506,7 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
>  
>  	timer = &vcpu->arch.apic->lapic_timer.timer;
>  	if (hrtimer_cancel(timer))
> -		hrtimer_start_expires(timer, HRTIMER_MODE_ABS_PINNED);
> +		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
>  }
>  
>  /*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0a05a4e..9450a16 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1437,12 +1437,8 @@ static void update_pvclock_gtod(struct timekeeper *tk)
>  
>  void kvm_set_pending_timer(struct kvm_vcpu *vcpu)
>  {
> -	/*
> -	 * Note: KVM_REQ_PENDING_TIMER is implicitly checked in
> -	 * vcpu_enter_guest.  This function is only called from
> -	 * the physical CPU that is running vcpu.
> -	 */
>  	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
> +	kvm_vcpu_kick(vcpu);
>  }
>  
>  static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
> -- 
> 2.7.4
> 

Regards,

-- 
Peter Xu

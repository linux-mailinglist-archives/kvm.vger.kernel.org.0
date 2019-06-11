Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC0C4163B
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 22:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406429AbfFKUjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 16:39:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35348 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405843AbfFKUjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 16:39:51 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E20630832EE;
        Tue, 11 Jun 2019 20:39:51 +0000 (UTC)
Received: from amt.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA21E7A008;
        Tue, 11 Jun 2019 20:39:50 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 04F07105165;
        Tue, 11 Jun 2019 17:19:00 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x5BKIuE9013566;
        Tue, 11 Jun 2019 17:18:56 -0300
Date:   Tue, 11 Jun 2019 17:18:52 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v3 2/4] KVM: LAPIC: lapic timer interrupt is injected by
 posted interrupt
Message-ID: <20190611201849.GA7520@amt.cnet>
References: <1560255429-7105-1-git-send-email-wanpengli@tencent.com>
 <1560255429-7105-3-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1560255429-7105-3-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 11 Jun 2019 20:39:51 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 11, 2019 at 08:17:07PM +0800, Wanpeng Li wrote:
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
> ~3% redis performance benefit can be observed on Skylake server.
> 
> w/o patch:
> 
>             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time   Avg time
> 
> EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   106.09us   0.71us ( +-   1.09% )
> 
> w/ patch:
> 
>             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time         Avg time
> 
> EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    57.88us   0.72us ( +-   4.02% )
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 32 +++++++++++++++++++++++++-------
>  1 file changed, 25 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index e57eeba..020599f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -133,6 +133,12 @@ inline bool posted_interrupt_inject_timer_enabled(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer_enabled);
>  
> +static inline bool can_posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
> +{
> +	return posted_interrupt_inject_timer_enabled(vcpu) &&
> +		kvm_hlt_in_guest(vcpu->kvm);
> +}

Hi Li,

Don't think its necessary to depend on kvm_hlt_in_guest: Can also use
exitless injection if the guest is running (think DPDK style workloads
that busy-spin on network card).


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5084A266
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 15:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbfFRNgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 09:36:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729493AbfFRNgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 09:36:23 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5369430860A0;
        Tue, 18 Jun 2019 13:36:22 +0000 (UTC)
Received: from amt.cnet (ovpn-112-7.gru2.redhat.com [10.97.112.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA61F1001DE7;
        Tue, 18 Jun 2019 13:36:21 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 07144105165;
        Tue, 18 Jun 2019 10:35:50 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x5IDZkZI027558;
        Tue, 18 Jun 2019 10:35:46 -0300
Date:   Tue, 18 Jun 2019 10:35:42 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v4 2/5] KVM: LAPIC: inject lapic timer interrupt by
 posted interrupt
Message-ID: <20190618133541.GA3932@amt.cnet>
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
 <1560770687-23227-3-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1560770687-23227-3-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 18 Jun 2019 13:36:22 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 17, 2019 at 07:24:44PM +0800, Wanpeng Li wrote:
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
> The host admin should fine tuned, e.g. dedicated instances scenario w/ 
> nohz_full cover the pCPUs which vCPUs resident, several pCPUs surplus 
> for busy housekeeping, disable mwait/hlt/pause vmexits to keep in non-root  
> mode, ~3% redis performance benefit can be observed on Skylake server.
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
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c            | 33 ++++++++++++++++++++++++++-------
>  arch/x86/kvm/lapic.h            |  1 +
>  arch/x86/kvm/vmx/vmx.c          |  3 ++-
>  arch/x86/kvm/x86.c              |  5 +++++
>  arch/x86/kvm/x86.h              |  2 ++
>  include/linux/sched/isolation.h |  2 ++
>  kernel/sched/isolation.c        |  6 ++++++
>  7 files changed, 44 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 87ecb56..9ceeee5 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -122,6 +122,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
>  	return apic->vcpu->vcpu_id;
>  }
>  
> +bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
> +{
> +	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> +		kvm_hlt_in_guest(vcpu->kvm);
> +}
> +EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer);

Paolo, can you explain the reasoning behind this?

Should not be necessary...


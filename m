Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B085339E9B0
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 00:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhFGWkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 18:40:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49696 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230237AbhFGWka (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 18:40:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623105518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MItQuezXOveybUnPSAV4SZWP+k+EdoOi4OaV+jJO8Pw=;
        b=Txv0gX4/wREM4lkXqdQz5S1OIxdcTdsWjbDGXBL+NbBn7DHHl06cUOgszzyBBNcX7n+Y27
        mIDYi2pXUb/9tYVt8kT7hMKJ+e5F0IY3ZxoxZOo8VmY6mcss+ET1KymGkkLAhSi8Rozxb0
        tvBhgdHtebxzg5u39hsXkYpIw/hZCc8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-q3b-BoHbN5S6zix-zVc8kw-1; Mon, 07 Jun 2021 18:38:37 -0400
X-MC-Unique: q3b-BoHbN5S6zix-zVc8kw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 346BB801106;
        Mon,  7 Jun 2021 22:38:35 +0000 (UTC)
Received: from starship (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E243B19C66;
        Mon,  7 Jun 2021 22:38:30 +0000 (UTC)
Message-ID: <9d457b982c3fcd6e7413065350b9f860d45a6e47.camel@redhat.com>
Subject: Re: [PATCH V2] KVM: X86: fix tlb_flush_guest()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Date:   Tue, 08 Jun 2021 01:38:29 +0300
In-Reply-To: <20210531172256.2908-1-jiangshanlai@gmail.com>
References: <4c3ef411ba68ca726531a379fb6c9d16178c8513.camel@redhat.com>
         <20210531172256.2908-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-06-01 at 01:22 +0800, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> For KVM_VCPU_FLUSH_TLB used in kvm_flush_tlb_multi(), the guest expects
> the hypervisor do the operation that equals to native_flush_tlb_global()
> or invpcid_flush_all() in the specified guest CPU.
> 
> When TDP is enabled, there is no problem to just flush the hardware
> TLB of the specified guest CPU.
> 
> But when using shadowpaging, the hypervisor should have to sync the
> shadow pagetable at first before flushing the hardware TLB so that
> it can truely emulate the operation of invpcid_flush_all() in guest.
> 
> The problem exists since the first implementation of KVM_VCPU_FLUSH_TLB
> in commit f38a7b75267f ("KVM: X86: support paravirtualized help for TLB
> shootdowns").  But I don't think it would be a real world problem that
> time since the local CPU's tlb is flushed at first in guest before queuing
> KVM_VCPU_FLUSH_TLB to other CPUs.  It means that the hypervisor syncs the
> shadow pagetable before seeing the corresponding KVM_VCPU_FLUSH_TLBs.
> 
> After commit 4ce94eabac16 ("x86/mm/tlb: Flush remote and local TLBs
> concurrently"), the guest doesn't flush local CPU's tlb at first and
> the hypervisor can handle other VCPU's KVM_VCPU_FLUSH_TLB earlier than
> local VCPU's tlb flush and might flush the hardware tlb without syncing
> the shadow pagetable beforehand.
> 
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Fixes: f38a7b75267f ("KVM: X86: support paravirtualized help for TLB shootdowns")
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
> Changed from V1
> 	Use kvm_mmu_unload() instead of KVM_REQ_MMU_RELOAD to avoid
> 	causing unneeded iteration of vcpu_enter_guest().
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bbc4e04e67ad..27248e330767 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3072,6 +3072,22 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
>  static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
>  {
>  	++vcpu->stat.tlb_flush;
> +
> +	if (!tdp_enabled) {
> +		/*
> +		 * When two dimensional paging is not enabled, the
> +		 * operation should equal to native_flush_tlb_global()
> +		 * or invpcid_flush_all() on the guest's behalf via
> +		 * synchronzing shadow pagetable and flushing.
> +		 *
> +		 * kvm_mmu_unload() results consequent kvm_mmu_load()
> +		 * before entering guest which will do the required
> +		 * pagetable synchronzing and TLB flushing.
> +		 */
> +		kvm_mmu_unload(vcpu);
> +		return;
> +	}
> +
>  	static_call(kvm_x86_tlb_flush_guest)(vcpu);
>  }
>  
Hi!
 
So this patch *does* fix the windows boot without TDP!
 
However it feels like either I was extremely unlucky or
something else was fixed recently since:
 
1. I am sure I did test the window VM without any hyperv enlightenments
(I think with -hypervisor even). I always suspect the HV code to cause
trouble so I disable it.
 
2. When running with single vcpu, even with 'hv-tlbflush' windows doesn't 
use the PV TLB flush much. It uses it but rarely. 
 
As I see now without this patch (which makes the windows boot always), 
with a single vCPU I can boot a VM without EPT, and I am sure I tested this.
without NPT I still can't boot on AMD, as windows seems to use PV TLB flush
more often on AMD, even with a single vCPU.
 
I do remember testing with single vCPU on both Intel and AMD, and I never had
gotten either of them to boot without TDP.
 
But anyway with this patch the bug is gone for good.
Thank you very very much for fixing this, you saved me lot of time which
I would have put it into this bug eventually.
 
Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
 
As for the patch itself, it also looks fine in its current form
(It can't probably be optimized but this can be done later)
So
 
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
 

More notes from the testing I just did:
 
1. On AMD with npt=0, the windows VM boots very slowly, and then in the task manager
I see that it booted with 1 CPU, although I configured it for 3-28 vCPUs (doesn't matter how many)
I tested this with several win10 VMs, same pattern repeats.
 
2. The windows nag screen about "we beg you to open a microsoft account" makes the VM enter a live lock.
I see about half million at least VM exits per second due to page faults and it is stuck in 'please wait' screen
while with NPT=1 it shows up instantly. The VM has 12 GB of ram so I don't think RAM is an issue.
 
It's likely that those are just result of unoptimized code in regard to TLB flushes,
and timeouts in windows.
On my Intel laptop, the VM is way faster with EPT=0 and it boots with 3 vCPUs just fine
(the laptop has just dual core CPU, so I can't really give more that 3 vCPU to the VM)



Best regards,
	Maxim Levitsky





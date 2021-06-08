Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29693A0611
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhFHVdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 17:33:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234110AbhFHVdk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 17:33:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623187907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CvrEi2GE2Atbb4rbk+xVX4b+a6jCFTVxrl2QJI/S3oA=;
        b=XkAF8nDIhprZk5Cb5FciqN9TTvl1Zo/mJBIUlZJe43Fe4nrqKJ8MosORxduUKc43BbrEC8
        tRVRXcworUV7c40WDozZFZhUOwaNuOU1s7kyr5uExmqteaCniNKvtIxKfQ39chAAiBfp2R
        fftxZuveNmAJeGkeS3h2g+H+KZs8pTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-lXWMaEruOr2w0-fOhiPbsw-1; Tue, 08 Jun 2021 17:31:43 -0400
X-MC-Unique: lXWMaEruOr2w0-fOhiPbsw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 814376D246;
        Tue,  8 Jun 2021 21:31:41 +0000 (UTC)
Received: from starship (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E692060C04;
        Tue,  8 Jun 2021 21:31:36 +0000 (UTC)
Message-ID: <e68ca103927cc376b5132ea42ceb43420e2b93a0.camel@redhat.com>
Subject: Re: [PATCH V2] KVM: X86: fix tlb_flush_guest()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Date:   Wed, 09 Jun 2021 00:31:35 +0300
In-Reply-To: <YL6z5sv7cnsbZhvT@google.com>
References: <4c3ef411ba68ca726531a379fb6c9d16178c8513.camel@redhat.com>
         <20210531172256.2908-1-jiangshanlai@gmail.com>
         <9d457b982c3fcd6e7413065350b9f860d45a6e47.camel@redhat.com>
         <YL6z5sv7cnsbZhvT@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-06-08 at 00:03 +0000, Sean Christopherson wrote:
> On Tue, Jun 08, 2021, Maxim Levitsky wrote:
> > So this patch *does* fix the windows boot without TDP!
> 
> Woot!
> 
> > Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Lai,
> 
> I have a reworded version of your patch sitting in a branch that leverages this
> path to fix similar bugs and do additional cleanup.  Any objection to me gathering
> Maxim's tags and posting the version below?  I'm more than happy to hold off if
> you'd prefer to send your own version, but I don't want to send my own series
> without this fix as doing so would introduce bugs.
> 
> Thanks!
> 
> Author: Lai Jiangshan <laijs@linux.alibaba.com>
> Date:   Tue Jun 1 01:22:56 2021 +0800
> 
>     KVM: x86: Unload MMU on guest TLB flush if TDP disabled to force MMU sync
>     
>     When using shadow paging, unload the guest MMU when emulating a guest TLB
>     flush to all roots are synchronized.  From the guest's perspective,
>     flushing the TLB ensures any and all modifications to its PTEs will be
>     recognized by the CPU.
>     
>     Note, unloading the MMU is overkill, but is done to mirror KVM's existing
>     handling of INVPCID(all) and ensure the bug is squashed.  Future cleanup
>     can be done to more precisely synchronize roots when servicing a guest
>     TLB flush.
>     
>     If TDP is enabled, synchronizing the MMU is unnecessary even if nested
>     TDP is in play, as a "legacy" TLB flush from L1 does not invalidate L1's
>     TDP mappgins.  For EPT, an explicit INVEPT is required to invalidate
>     guest-physical mappings.  For NPT, guest mappings are always tagged with
>     an ASID and thus can only be invalidated via the VMCB's ASID control.
>     
>     This bug has existed since the introduction of KVM_VCPU_FLUSH_TLB, but
>     was only recently exposed after Linux guests stopped flushing the local
>     CPU's TLB prior to flushing remote TLBs (see commit 4ce94eabac16,
>     "x86/mm/tlb: Flush remote and local TLBs concurrently").
>     
>     Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
>     Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>     Fixes: f38a7b75267f ("KVM: X86: support paravirtualized help for TLB shootdowns")
>     Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
>     [sean: massaged comment and changelog]
>     Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1cd6d4685932..3b02528d5ee8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3072,6 +3072,18 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
>  static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
>  {
>         ++vcpu->stat.tlb_flush;
> +
> +       if (!tdp_enabled) {
> +               /*
> +                * Unload the entire MMU to force a sync of the shadow page
> +                * tables.  A TLB flush on behalf of the guest is equivalent
> +                * to INVPCID(all), toggling CR4.PGE, etc...  Note, loading the
> +                * MMU will also do an actual TLB flush.
> +                */
> +               kvm_mmu_unload(vcpu);
> +               return;
> +       }
> +
>         static_call(kvm_x86_tlb_flush_guest)(vcpu);
>  }
>  
> 
> > More notes from the testing I just did:
> >  
> > 1. On AMD with npt=0, the windows VM boots very slowly, and then in the task manager
> > I see that it booted with 1 CPU, although I configured it for 3-28 vCPUs (doesn't matter how many)
> > I tested this with several win10 VMs, same pattern repeats.
> 
> That's very odd.  Maybe it's so slow that the guest gives up on the AP and marks
> it as dead?  That seems unlikely though, I can't imagine waking APs would be
> _that_ slow.

I also can't say that it is that slow, but it is possible that a live lock like situation
similar to what I see with the nag screen causes an AP bootup to timeout.
I also see that using my old workaround to boot with NPT=0 which was to always keep shadow
MMU in sync, also causes windows to see a single vCPU.

I will when I have some time for this to try to artificially slow windows down in some other way
and see if it still fails to bring up more than one vCPU.


> 
> > 2. The windows nag screen about "we beg you to open a microsoft account" makes the VM enter a live lock.
> > I see about half million at least VM exits per second due to page faults and it is stuck in 'please wait' screen
> > while with NPT=1 it shows up instantly. The VM has 12 GB of ram so I don't think RAM is an issue.
> >  
> > It's likely that those are just result of unoptimized code in regard to TLB flushes,
> > and timeouts in windows.
> > On my Intel laptop, the VM is way faster with EPT=0 and it boots with 3 vCPUs just fine
> > (the laptop has just dual core CPU, so I can't really give more that 3 vCPU to the VM)
> 
> Any chance your Intel CPU has PCID?  Although the all-contexts INVPCID emulation
> nukes everything, the single-context INVPCID emulation in KVM is optimized to
> (a) sync the current MMU (if necessary) instead of unloading it and (b) free
> only roots with the matching PCID.  I believe all other forms of TLB flushing
> that are likely to be used by the guest will lead to KVM unloading the entire
> MMU and rebuilding it from scratch.

Yes it has it. It is relatively recent Kabylake processor (i7-7600U),
so this could be it. I'll try to disable it as well when I have some time for
this.


Finally about my testing of running HyperV nested. This patch can't fix it,
since it only changes the non TDP code path, but we also have another patch on
the list that is shadow paging related 
"KVM: X86: MMU: Use the correct inherited permissions to get shadow page"

Sadly the VM still did eventually bluescreen (with 'critical process died' after about 400
migration cycles this time. No luck this time.

Best regards,
	Maxim Levitsky




Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641B378643E
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 02:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238908AbjHXAa0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 20:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238905AbjHXAaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 20:30:05 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5728FE7F
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 17:30:03 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 12A7E84;
        Wed, 23 Aug 2023 17:30:03 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id ZMm3BS5N07xL; Wed, 23 Aug 2023 17:30:02 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id E0BF539;
        Wed, 23 Aug 2023 17:30:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net E0BF539
Date:   Wed, 23 Aug 2023 17:30:01 -0700 (PDT)
From:   Eric Wheeler <kvm@lists.ewheeler.net>
To:     Sean Christopherson <seanjc@google.com>
cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Subject: Re: Deadlock due to EPT_VIOLATION
In-Reply-To: <ZOaUdP46f8XjQvio@google.com>
Message-ID: <5da12792-1e5d-b89d-ea0-e1159c645568@ewheeler.net>
References: <ZN+BRjUxouKiDSbx@google.com> <418345e5-a3e5-6e8d-395a-f5551ea13e2@ewheeler.net> <5fc6cea-9f51-582c-8bb3-21e0b4bf397@ewheeler.net> <ZOP4lwiMU2Uf89eQ@google.com> <468b1298-e43e-2397-5f3-4b6af6e2f461@ewheeler.net> <ZOTQPUk5kxskDcsi@google.com>
 <58f24fa2-a5f4-c59a-2bcf-c49f7bddc5b@ewheeler.net> <ZOZH3xe0u4NHhvL8@google.com> <db7c65b-6530-692-5e50-c74a7757f22@ewheeler.net> <347d3526-7f8d-4744-2a9c-8240cc556975@ewheeler.net> <ZOaUdP46f8XjQvio@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Aug 2023, Sean Christopherson wrote:
> On Wed, Aug 23, 2023, Eric Wheeler wrote:

...

> > 22:23:31:481714 tid[142943] pid[142917] MAP @ rip ffffffffa43ce877 (1208 hits), gpa = cf7f000, hva = 7f6d24f7f000, pfn = 1ee50ee
> > 22:23:31:481714 tid[142943] pid[142917] ITER @ rip ffffffffa43ce877 (1208 hits), gpa = cf7f000 (cf7f000), hva = 7f6d24f7f000, pfn = 1ee50ee, tdp_mmu = 1, role = 3784, count = 1
> > 22:23:31:481715 tid[142943] pid[142917] SPTE @ rip ffffffffa43ce877 (1208 hits), gpa = cf7f000, hva = 7f6d24f7f000, pfn = 1ee50ee
> > 22:23:31:481716 tid[142943] pid[142917] MAP_RET @ rip ffffffffa43ce877 (1208 hits), gpa = cf7f000, hva = 7f6d24f7f000, pfn = 1ee50ee, ret = 4
> 
> This vCPU is making forward progress, it just happens to be taken lots of fualts
> on a single RIP.  MAP_RET's "ret = 4" means KVM did inded "fix" the fault, and
> the faulting GPA/HVA is changing on every fault.  Best guess is that the guest
> is zeroing a hugepage, but the guest's 2MiB page is mapped with 4KiB EPT entries,
> i.e. the vCPU is doing REP STOS on a 2MiB region.

...

> > > 21:25:50:282726 tid[3484173] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (92239 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000

...

> > > 21:25:50:282354 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90073 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
> > > 21:25:50:282571 tid[3484174] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (90121 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000

...

> These vCPUs (which belong to the same VM) appear to be well and truly stuck.  The
> fact that you got prints from MAP, MAP_RET, ITER, and SPTE for an unrelated (and
> not stuck) vCPU is serendipitious, as it all but guarantees that the trace is
> "good", i.e. that MAP prints aren't missing because the bpf program is bad.
> 
> Since the mmu_notifier info is stable (though the seq is still *insanely* high),
> assuming there's no kernel memory corruption, that means that KVM is bailing
> because is_page_fault_stale() returns true.  Based on v5.15 being the last known
> good kernel for you,

I should note that v5.15 was speculative information that may not be
100% correct.  However, the occurance of failures <= 5.15 is miniscule
compared to >5.15, as almost all occurences are in 6.1.x (which could be
biased by the number of 6.1.x deployments).

It is entirely possible that the <= 5.15 issues are false-positives, but
we don't have TBF on anything <6.1.30, so no kprobe traces.

> that places the blame squarerly on commit
> a955cad84cda ("KVM: x86/mmu: Retry page fault if root is invalidated by memslot update").
> Note, that commit had an unrelated but fixed by 18c841e1f411 ("KVM: x86: Retry
> page fault if MMU reload is pending and root has no sp"), but all flavors of v6.1
> have said fix and the bug caused a crash, not stuck vCPUs.
> 
> The "MMU seq = 8002dc25" value still gives me pause.  It's one hell of a coincidence
> that all stuck vCPUs have had a sequence counter of 0x800xxxxx.
> 
> <time goes by as I keep staring>
> 
> Fudge (that's not actually what I said).  *sigh*
> 
> Not a coincidence, at all.  The bug is that, in v6.1, is_page_fault_stale() takes
> the local @mmu_seq snapshot as an int, whereas as the per-VM count is stored as an
> unsigned long.

I'm surprised that there were no compiler warnings about signedness or
type precision.  What would have prevented such a compiler warning?

> When the sequence sets bit 31, the local @mmu_seq value becomes
> a signed *negative* value, and then when that gets passed to mmu_invalidate_retry_hva(),
> which correctly takes an unsigned long, the negative value gets sign-extended and
> so the comparison ends up being
> 
> 	if (0x8002dc25 != 0xffffffff8002dc25)
>
> and KVM thinks the sequence count is stale.  I missed it for so long because I
> was stupidly looking mostly at upstream code (see below), and because of the subtle
> sign-extension behavior (I was mostly on the lookout for a straight truncation
> bug where bits[63:32] got dropped).
> 
> I suspect others haven't hit this issues because no one else is generating anywhere
> near the same number of mmu_notifier invalidations, and/or live migrates VMs more
> regularly (which effectively resets the sequence count).
> 
> The real kicker to all this is that the bug was accidentally fixed in v6.3 by
> commit ba6e3fe25543 ("KVM: x86/mmu: Grab mmu_invalidate_seq in kvm_faultin_pfn()"),
> as that refactoring correctly stored the "local" mmu_seq as an unsigned long.
> 
> I'll post the below as a proper patch for inclusion in stable kernels.

Awesome, and well done.  Can you think of a "simple" patch for the
6.1-series that would be live-patch safe?

-Eric

> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 230108a90cf3..beca03556379 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4212,7 +4212,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   * root was invalidated by a memslot update or a relevant mmu_notifier fired.
>   */
>  static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
> -                               struct kvm_page_fault *fault, int mmu_seq)
> +                               struct kvm_page_fault *fault,
> +                               unsigned long mmu_seq)
>  {
>         struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
>  
> P.S. FWIW, it's probably worth taking a peek at your NUMA setup and/or KSM settings.
> 2 billion invalidations is still quite insane, even for a long-lived VM.  E.g.
> we (Google) disable NUMA balancing and instead rely on other parts of the stack
> to hit our SLOs for NUMA locality.  That certainly has its own challenges, and
> might not be viable for your environment, but NUMA balancing is far from a free
> lunch for VMs; NUMA balancing is a _lot_ more costly when KVM is on the receiving
> end due to the way mmu_notifier invalidations work.   And for KSM, I personally
> think KSM is a terrible tradeoff and should never be enabled.  It saves memory at
> the cost of CPU cycles, guest performance, and guest security.



--
Eric Wheeler



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F22787C1E
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 01:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbjHXXvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 19:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235165AbjHXXva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 19:51:30 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93D2E77
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 16:51:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 737E085;
        Thu, 24 Aug 2023 16:51:26 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id OaFOtKhSeKnP; Thu, 24 Aug 2023 16:51:22 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id EF5E645;
        Thu, 24 Aug 2023 16:51:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net EF5E645
Date:   Thu, 24 Aug 2023 16:51:21 -0700 (PDT)
From:   Eric Wheeler <kvm@lists.ewheeler.net>
To:     Sean Christopherson <seanjc@google.com>
cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Subject: Re: Deadlock due to EPT_VIOLATION
In-Reply-To: <ZOaptK09RbJtFbmk@google.com>
Message-ID: <50b37641-ac2e-c4c4-440-7a443b115913@ewheeler.net>
References: <5fc6cea-9f51-582c-8bb3-21e0b4bf397@ewheeler.net> <ZOP4lwiMU2Uf89eQ@google.com> <468b1298-e43e-2397-5f3-4b6af6e2f461@ewheeler.net> <ZOTQPUk5kxskDcsi@google.com> <58f24fa2-a5f4-c59a-2bcf-c49f7bddc5b@ewheeler.net> <ZOZH3xe0u4NHhvL8@google.com>
 <db7c65b-6530-692-5e50-c74a7757f22@ewheeler.net> <347d3526-7f8d-4744-2a9c-8240cc556975@ewheeler.net> <ZOaUdP46f8XjQvio@google.com> <5da12792-1e5d-b89d-ea0-e1159c645568@ewheeler.net> <ZOaptK09RbJtFbmk@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-110721984-1692921081=:30383"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-110721984-1692921081=:30383
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 23 Aug 2023, Sean Christopherson wrote:
> On Wed, Aug 23, 2023, Eric Wheeler wrote:
> > On Wed, 23 Aug 2023, Sean Christopherson wrote:
> > > Not a coincidence, at all.  The bug is that, in v6.1, is_page_fault_stale() takes
> > > the local @mmu_seq snapshot as an int, whereas as the per-VM count is stored as an
> > > unsigned long.
> > 
> > I'm surprised that there were no compiler warnings about signedness or
> > type precision.  What would have prevented such a compiler warning?
> 
> -Wconversion can detect this, but it detects freaking *everything*, i.e. its
> signal to noise ratio is straight up awful.  It's so noisy in fact that it's not
> even in the kernel's W=1 build, it's pushed down all the way to W=3.  W=1 is
> basically "you'll get some noise, but it may find useful stuff.  W=3 is essentially
> "don't bother wading through the warnings unless you're masochistic".
> 
> E.g. turning it on leads to:
> 
> linux/include/linux/kvm_host.h:891:60: error:
> conversion to ‘long unsigned int’ from ‘int’ may change the sign of the result [-Werror=sign-conversion]
>   891 |                           (atomic_read(&kvm->online_vcpus) - 1))
>       |                           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
> 
> which is completely asinine (suppressing the warning would require declaring the
> above literal as 1u).

I can see that.  I suppose we'll never see the kernel compile with -Wall 
-Werror!

 
> FWIW, I would love to be able to prevent these types of bugs as this isn't the
> first implicit conversion bug that has hit KVM x86[*], but the signal to noise
> ratio is just so, so bad.
> 
> [*] commit d5aaad6f8342 ("KVM: x86/mmu: Fix per-cpu counter corruption on 32-bit builds")
> 
> > > When the sequence sets bit 31, the local @mmu_seq value becomes
> > > a signed *negative* value, and then when that gets passed to mmu_invalidate_retry_hva(),
> > > which correctly takes an unsigned long, the negative value gets sign-extended and
> > > so the comparison ends up being
> > > 
> > > 	if (0x8002dc25 != 0xffffffff8002dc25)
> > >
> > > and KVM thinks the sequence count is stale.  I missed it for so long because I
> > > was stupidly looking mostly at upstream code (see below), and because of the subtle
> > > sign-extension behavior (I was mostly on the lookout for a straight truncation
> > > bug where bits[63:32] got dropped).
> > > 
> > > I suspect others haven't hit this issues because no one else is generating anywhere
> > > near the same number of mmu_notifier invalidations, and/or live migrates VMs more
> > > regularly (which effectively resets the sequence count).
> > > 
> > > The real kicker to all this is that the bug was accidentally fixed in v6.3 by
> > > commit ba6e3fe25543 ("KVM: x86/mmu: Grab mmu_invalidate_seq in kvm_faultin_pfn()"),
> > > as that refactoring correctly stored the "local" mmu_seq as an unsigned long.
> > > 
> > > I'll post the below as a proper patch for inclusion in stable kernels.
> > 
> > Awesome, and well done.  Can you think of a "simple" patch for the
> > 6.1-series that would be live-patch safe?
> 
> This is what I'm going to post for 6.1, it's as safe and simple a patch as can
> be.  The only potential hiccup for live-patching is that it's all but guaranteed
> to be inlined, but the scope creep should be limited to one-level up, e.g. to
> direct_page_fault().
> 
> Author: Sean Christopherson <seanjc@google.com>
> Date:   Wed Aug 23 16:28:12 2023 -0700
> 
>     KVM: x86/mmu: Fix an sign-extension bug with mmu_seq that hangs vCPUs
>     
>     Take the vCPU's mmu_seq snapshot as an "unsigned long" instead of an "int"
>     when checking to see if a page fault is stale, as the sequence count is
>     stored as an "unsigned long" everywhere else in KVM.  This fixes a bug
>     where KVM will effectively hang vCPUs due to always thinking page faults
>     are stale, which result in KVM refusing to "fix" faults.
>     
>     mmu_invalidate_seq (née mmu_notifier_seq) is sequence counter used when
>     KVM is handling page faults to detect if userspace mapping relevant to the
>     guest was invalidated snapshotting the counter and acquiring mmu_lock, to
>     ensure that the host pfn that KVM retrieved is still fresh.  If KVM sees
>     that the counter has change, KVM resumes the guest without fixing the
>     fault.
>     
>     What _should_ happen is that the source of the mmu_notifier invalidations
>     eventually goes away, mmu_invalidate_seq will become stable, and KVM can
>     once again fix guest page fault(s).
>     
>     But for a long-lived VM and/or a VM that the host just doesn't particularly
>     like, it's possible for a VM to be on the receiving end of 2 billion (with
>     a B) mmu_notifier invalidations.  When that happens, bit 31 will be set in
>     mmu_invalidate_seq.  This causes the value to be turned into a 32-bit
>     negative value when implicitly cast to an "int" by is_page_fault_stale(),
>     and then sign-extended into a 64-bit unsigned when the signed "int" is
>     implicitly cast back to an "unsigned long" on the call to
>     mmu_invalidate_retry_hva().
>     
>     As a result of the casting and sign-extension, given a sequence counter of
>     e.g. 0x8002dc25, mmu_invalidate_retry_hva() ends up doing
>     
>             if (0x8002dc25 != 0xffffffff8002dc25)
>     
>     and signals that the page fault is stale and needs to be retried even
>     though the sequence counter is stable, and KVM effectively hangs any vCPU
>     that takes a page fault (EPT violation or #NPF when TDP is enabled).
>     
>     Note, upstream commit ba6e3fe25543 ("KVM: x86/mmu: Grab mmu_invalidate_seq
>     in kvm_faultin_pfn()") unknowingly fixed the bug in v6.3 when refactoring
>     how KVM tracks the sequence counter snapshot.
>     
>     Reported-by: Brian Rak <brak@vultr.com>
>     Reported-by: Amaan Cheval <amaan.cheval@gmail.com>
>     Reported-by: Eric Wheeler <kvm@lists.ewheeler.net>
>     Closes: https://lore.kernel.org/all/f023d927-52aa-7e08-2ee5-59a2fbc65953@gameservers.com

Thanks again for all your help on this, I enjoyed working on it with you.

-Eric

>     Fixes: a955cad84cda ("KVM: x86/mmu: Retry page fault if root is invalidated by memslot update")
>     Signed-off-by: Sean Christopherson <seanjc@google.com>
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
> 
> 
--8323328-110721984-1692921081=:30383--

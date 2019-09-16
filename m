Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 790AAB3F6A
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 19:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390245AbfIPRHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 13:07:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57485 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390235AbfIPRHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 13:07:39 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A2553084037;
        Mon, 16 Sep 2019 17:07:39 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 472AF600F8;
        Mon, 16 Sep 2019 17:07:38 +0000 (UTC)
Date:   Mon, 16 Sep 2019 11:07:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Harvey <jamespharvey20@gmail.com>
Subject: Re: [PATCH 00/11] KVM: x86/mmu: Restore fast invalidate/zap flow
Message-ID: <20190916110737.4abfc93d@x1.home>
In-Reply-To: <20190913024612.28392-1-sean.j.christopherson@intel.com>
References: <20190913024612.28392-1-sean.j.christopherson@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 16 Sep 2019 17:07:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Sep 2019 19:46:01 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Restore the fast invalidate flow for zapping shadow pages and use it
> whenever vCPUs can be active in the VM.  This fixes (in theory, not yet
> confirmed) a regression reported by James Harvey where KVM can livelock
> in kvm_mmu_zap_all() when it's invoked in response to a memslot update.
> 
> The fast invalidate flow was removed as it was deemed to be unnecessary
> after its primary user, memslot flushing, was reworked to zap only the
> memslot in question instead of all shadow pages.  Unfortunately, zapping
> only the memslot being (re)moved during a memslot update introduced a
> regression for VMs with assigned devices.  Because we could not discern
> why zapping only the relevant memslot broke device assignment, or if the
> regression extended beyond device assignment, we reverted to zapping all
> shadow pages when a memslot is (re)moved.
> 
> The revert to "zap all" failed to account for subsequent changes that
> have been made to kvm_mmu_zap_all() between then and now.  Specifically,
> kvm_mmu_zap_all() now conditionally drops reschedules and drops mmu_lock
> if a reschedule is needed or if the lock is contended.  Dropping the lock
> allows other vCPUs to add shadow pages, and, with enough vCPUs, can cause
> kvm_mmu_zap_all() to get stuck in an infinite loop as it can never zap all
> pages before observing lock contention or the need to reschedule.
> 
> The reasoning behind having kvm_mmu_zap_all() conditionally reschedule was
> that it would only be used when the VM is inaccesible, e.g. when its
> mm_struct is dying or when the VM itself is being destroyed.  In that case,
> playing nice with the rest of the kernel instead of hogging cycles to free
> unused shadow pages made sense.
> 
> Since it's unlikely we'll root cause the device assignment regression any
> time soon, and that simply removing the conditional rescheduling isn't
> guaranteed to return us to a known good state, restore the fast invalidate
> flow for zapping on memslot updates, including mmio generation wraparound.
> Opportunisticaly tack on a bug fix and a couple enhancements.
> 
> Alex and James, it probably goes without saying... please test, especially
> patch 01/11 as a standalone patch as that'll likely need to be applied to
> stable branches, assuming it works.  Thanks!

It looks like Paolo already included patch 01/11 in v5.3, I tested that
and it behaves ok for the GPU assignment windows issue.  I applied the
remaining 10 patches on v5.3 and tested those separately.  They also
behave well for this test case.

Tested-by: Alex Williamson <alex.williamson@redhat.com>

Thanks,
Alex 

> 
> Sean Christopherson (11):
>   KVM: x86/mmu: Reintroduce fast invalidate/zap for flushing memslot
>   KVM: x86/mmu: Treat invalid shadow pages as obsolete
>   KVM: x86/mmu: Use fast invalidate mechanism to zap MMIO sptes
>   KVM: x86/mmu: Revert "Revert "KVM: MMU: show mmu_valid_gen in shadow
>     page related tracepoints""
>   KVM: x86/mmu: Revert "Revert "KVM: MMU: add tracepoint for
>     kvm_mmu_invalidate_all_pages""
>   KVM: x86/mmu: Revert "Revert "KVM: MMU: zap pages in batch""
>   KVM: x86/mmu: Revert "Revert "KVM: MMU: collapse TLB flushes when zap
>     all pages""
>   KVM: x86/mmu: Revert "Revert "KVM: MMU: reclaim the zapped-obsolete
>     page first""
>   KVM: x86/mmu: Revert "KVM: x86/mmu: Remove is_obsolete() call"
>   KVM: x86/mmu: Explicitly track only a single invalid mmu generation
>   KVM: x86/mmu: Skip invalid pages during zapping iff root_count is zero
> 
>  arch/x86/include/asm/kvm_host.h |   4 +-
>  arch/x86/kvm/mmu.c              | 154 ++++++++++++++++++++++++++++----
>  arch/x86/kvm/mmutrace.h         |  42 +++++++--
>  arch/x86/kvm/x86.c              |   1 +
>  4 files changed, 173 insertions(+), 28 deletions(-)
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B62D8C008
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 19:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbfHMR5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 13:57:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbfHMR5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 13:57:39 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7591013A82;
        Tue, 13 Aug 2019 17:57:38 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10D6ABA54;
        Tue, 13 Aug 2019 17:57:38 +0000 (UTC)
Date:   Tue, 13 Aug 2019 11:57:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190813115737.5db7d815@x1.home>
In-Reply-To: <20190813170440.GC13991@linux.intel.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
        <20190205210137.1377-11-sean.j.christopherson@intel.com>
        <20190813100458.70b7d82d@x1.home>
        <20190813170440.GC13991@linux.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 13 Aug 2019 17:57:38 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Aug 2019 10:04:41 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> On Tue, Aug 13, 2019 at 10:04:58AM -0600, Alex Williamson wrote:
> > On Tue,  5 Feb 2019 13:01:21 -0800
> > Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> >   
> > > Modify kvm_mmu_invalidate_zap_pages_in_memslot(), a.k.a. the x86 MMU's
> > > handler for kvm_arch_flush_shadow_memslot(), to zap only the pages/PTEs
> > > that actually belong to the memslot being removed.  This improves
> > > performance, especially why the deleted memslot has only a few shadow
> > > entries, or even no entries.  E.g. a microbenchmark to access regular
> > > memory while concurrently reading PCI ROM to trigger memslot deletion
> > > showed a 5% improvement in throughput.
> > > 
> > > Cc: Xiao Guangrong <guangrong.xiao@gmail.com>
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > ---
> > >  arch/x86/kvm/mmu.c | 33 ++++++++++++++++++++++++++++++++-
> > >  1 file changed, 32 insertions(+), 1 deletion(-)  
> > 
> > A number of vfio users are reporting VM instability issues since v5.1,
> > some have traced it back to this commit 4e103134b862 ("KVM: x86/mmu: Zap
> > only the relevant pages when removing a memslot"), which I've confirmed
> > via bisection of the 5.1 merge window KVM pull (636deed6c0bc) and
> > re-verified on current 5.3-rc4 using the below patch to toggle the
> > broken behavior.
> > 
> > My reproducer is a Windows 10 VM with assigned GeForce GPU running a
> > variety of tests, including FurMark and PassMark Performance Test.
> > With the code enabled as exists in upstream currently, PassMark will
> > generally introduce graphics glitches or hangs.  Sometimes it's
> > necessary to reboot the VM to see these issues.  
> 
> As in, the issue only shows up when the VM is rebooted?  Just want to
> double check that that's not a typo.

No, it can occur on the first boot as well, it's just that the recipe
to induce a failure is not well understood and manifests itself in
different ways.  I generally run the tests, then if it still hasn't
reproduced, I reboot the VM a couple times, running a couple apps in
between to try to trigger/notice bad behavior.

> > Flipping the 0/1 in the below patch appears to resolve the issue.
> > 
> > I'd appreciate any insights into further debugging this block of code
> > so that we can fix this regression.  Thanks,  
> 
> If it's not too painful to reproduce, I'd say start by determining whether
> it's a problem with the basic logic or if the cond_resched_lock() handling
> is wrong.  I.e. comment/ifdef out this chunk:
> 
> 		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
> 			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
> 			flush = false;
> 			cond_resched_lock(&kvm->mmu_lock);
> 		}

If anything, removing this chunk seems to make things worse.  Thanks,

Alex

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6988C18E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 21:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfHMTdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 15:33:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfHMTdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 15:33:18 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 92F53883BA;
        Tue, 13 Aug 2019 19:33:17 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AE867FB87;
        Tue, 13 Aug 2019 19:33:17 +0000 (UTC)
Date:   Tue, 13 Aug 2019 13:33:16 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190813133316.6fc6f257@x1.home>
In-Reply-To: <20190813115737.5db7d815@x1.home>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
        <20190205210137.1377-11-sean.j.christopherson@intel.com>
        <20190813100458.70b7d82d@x1.home>
        <20190813170440.GC13991@linux.intel.com>
        <20190813115737.5db7d815@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 13 Aug 2019 19:33:17 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Aug 2019 11:57:37 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 13 Aug 2019 10:04:41 -0700
> Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> 
> > On Tue, Aug 13, 2019 at 10:04:58AM -0600, Alex Williamson wrote:  
> > > On Tue,  5 Feb 2019 13:01:21 -0800
> > > Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > >     
> > > > Modify kvm_mmu_invalidate_zap_pages_in_memslot(), a.k.a. the x86 MMU's
> > > > handler for kvm_arch_flush_shadow_memslot(), to zap only the pages/PTEs
> > > > that actually belong to the memslot being removed.  This improves
> > > > performance, especially why the deleted memslot has only a few shadow
> > > > entries, or even no entries.  E.g. a microbenchmark to access regular
> > > > memory while concurrently reading PCI ROM to trigger memslot deletion
> > > > showed a 5% improvement in throughput.
> > > > 
> > > > Cc: Xiao Guangrong <guangrong.xiao@gmail.com>
> > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > ---
> > > >  arch/x86/kvm/mmu.c | 33 ++++++++++++++++++++++++++++++++-
> > > >  1 file changed, 32 insertions(+), 1 deletion(-)    
> > > 
> > > A number of vfio users are reporting VM instability issues since v5.1,
> > > some have traced it back to this commit 4e103134b862 ("KVM: x86/mmu: Zap
> > > only the relevant pages when removing a memslot"), which I've confirmed
> > > via bisection of the 5.1 merge window KVM pull (636deed6c0bc) and
> > > re-verified on current 5.3-rc4 using the below patch to toggle the
> > > broken behavior.
> > > 
> > > My reproducer is a Windows 10 VM with assigned GeForce GPU running a
> > > variety of tests, including FurMark and PassMark Performance Test.
> > > With the code enabled as exists in upstream currently, PassMark will
> > > generally introduce graphics glitches or hangs.  Sometimes it's
> > > necessary to reboot the VM to see these issues.    
> > 
> > As in, the issue only shows up when the VM is rebooted?  Just want to
> > double check that that's not a typo.  
> 
> No, it can occur on the first boot as well, it's just that the recipe
> to induce a failure is not well understood and manifests itself in
> different ways.  I generally run the tests, then if it still hasn't
> reproduced, I reboot the VM a couple times, running a couple apps in
> between to try to trigger/notice bad behavior.
> 
> > > Flipping the 0/1 in the below patch appears to resolve the issue.
> > > 
> > > I'd appreciate any insights into further debugging this block of code
> > > so that we can fix this regression.  Thanks,    
> > 
> > If it's not too painful to reproduce, I'd say start by determining whether
> > it's a problem with the basic logic or if the cond_resched_lock() handling
> > is wrong.  I.e. comment/ifdef out this chunk:
> > 
> > 		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
> > 			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
> > 			flush = false;
> > 			cond_resched_lock(&kvm->mmu_lock);
> > 		}  
> 
> If anything, removing this chunk seems to make things worse.

Could it be something with the gfn test:

                        if (sp->gfn != gfn)
                                continue;

If I remove it, I can't trigger the misbehavior.  If I log it, I only
get hits on VM boot/reboot and some of the gfns look suspiciously like
they could be the assigned GPU BARs and maybe MSI mappings:

               (sp->gfn) != (gfn)
[   71.829450] gfn fec00 != c02c4
[   71.835554] gfn ffe00 != c046f
[   71.841664] gfn 0 != c0720
[   71.847084] gfn 0 != c0720
[   71.852489] gfn 0 != c0720
[   71.857899] gfn 0 != c0720
[   71.863306] gfn 0 != c0720
[   71.868717] gfn 0 != c0720
[   71.874122] gfn 0 != c0720
[   71.879531] gfn 0 != c0720
[   71.884937] gfn 0 != c0720
[   71.890349] gfn 0 != c0720
[   71.895757] gfn 0 != c0720
[   71.901163] gfn 0 != c0720
[   71.906569] gfn 0 != c0720
[   71.911980] gfn 0 != c0720
[   71.917387] gfn 0 != c0720
[   71.922808] gfn fee00 != c0edc
[   71.928915] gfn fee00 != c0edc
[   71.935018] gfn fee00 != c0edc
[   71.941730] gfn c1000 != 8002d7
[   71.948039] gfn 80000 != 8006d5
[   71.954328] gfn 80000 != 8006d5
[   71.960600] gfn 80000 != 8006d5
[   71.966874] gfn 80000 != 8006d5
[   71.992272] gfn 0 != c0720
[   71.997683] gfn 0 != c0720
[   72.003725] gfn 80000 != 8006d5
[   72.044333] gfn 0 != c0720
[   72.049743] gfn 0 != c0720
[   72.055846] gfn 80000 != 8006d5
[   72.177341] gfn ffe00 != c046f
[   72.183453] gfn 0 != c0720
[   72.188864] gfn 0 != c0720
[   72.194290] gfn 0 != c0720
[   72.200308] gfn 80000 != 8006d5
[   82.539023] gfn fec00 != c02c4
[   82.545142] gfn 40000 != c0377
[   82.551343] gfn ffe00 != c046f
[   82.557466] gfn 100000 != c066f
[   82.563839] gfn 800000 != c06ec
[   82.570133] gfn 800000 != c06ec
[   82.576408] gfn 0 != c0720
[   82.581850] gfn 0 != c0720
[   82.587275] gfn 0 != c0720
[   82.592685] gfn 0 != c0720
[   82.598131] gfn 0 != c0720
[   82.603552] gfn 0 != c0720
[   82.608978] gfn 0 != c0720
[   82.614419] gfn 0 != c0720
[   82.619844] gfn 0 != c0720
[   82.625291] gfn 0 != c0720
[   82.630791] gfn 0 != c0720
[   82.636208] gfn 0 != c0720
[   82.641635] gfn 80a000 != c085e
[   82.647929] gfn fee00 != c0edc
[   82.654062] gfn fee00 != c0edc
[   82.660504] gfn 100000 != c066f
[   82.666800] gfn 0 != c0720
[   82.672211] gfn 0 != c0720
[   82.677635] gfn 0 != c0720
[   82.683060] gfn 0 != c0720
[   82.689209] gfn c1000 != 8002d7
[   82.695501] gfn 80000 != 8006d5
[   82.701796] gfn 80000 != 8006d5
[   82.708092] gfn 100000 != 80099b
[   82.714547] gfn 0 != 800a4c
[   82.720154] gfn 0 != 800a4c
[   82.725752] gfn 0 != 800a4c
[   82.731370] gfn 0 != 800a4c
[   82.738705] gfn 100000 != 80099b
[   82.745201] gfn 0 != 800a4c
[   82.750793] gfn 0 != 800a4c
[   82.756381] gfn 0 != 800a4c
[   82.761979] gfn 0 != 800a4c
[   82.768122] gfn 100000 != 8083a4
[   82.774605] gfn 0 != 8094aa
[   82.780196] gfn 0 != 8094aa
[   82.785796] gfn 0 != 8094aa
[   82.791412] gfn 0 != 8094aa
[   82.797523] gfn 100000 != 8083a4
[   82.803977] gfn 0 != 8094aa
[   82.809576] gfn 0 != 8094aa
[   82.815193] gfn 0 != 8094aa
[   82.820809] gfn 0 != 8094aa

(GPU has a BAR mapped at 0x80000000)

Is this gfn optimization correct?  Overzealous?  Doesn't account
correctly for something about MMIO mappings?  Thanks,

Alex

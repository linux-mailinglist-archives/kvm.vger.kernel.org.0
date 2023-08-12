Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1CF779C2A
	for <lists+kvm@lfdr.de>; Sat, 12 Aug 2023 02:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbjHLAul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 20:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236914AbjHLAuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 20:50:40 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCB010E6
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 17:50:39 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 46B7D84;
        Fri, 11 Aug 2023 17:50:39 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id H8HrlnczRXpA; Fri, 11 Aug 2023 17:50:35 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id DC41040;
        Fri, 11 Aug 2023 17:50:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net DC41040
Date:   Fri, 11 Aug 2023 17:50:08 -0700 (PDT)
From:   Eric Wheeler <kvm@lists.ewheeler.net>
To:     Sean Christopherson <seanjc@google.com>
cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Subject: Re: Deadlock due to EPT_VIOLATION
In-Reply-To: <ZNZ3owRcRjGejWFn@google.com>
Message-ID: <68e7d342-bdeb-39bf-5233-ba1121f0afc@ewheeler.net>
References: <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com> <ZMp3bR2YkK2QGIFH@google.com> <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com> <ZMqX7TJavsx8WEY2@google.com> <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com>
 <ZNJ2V2vRXckMwPX2@google.com> <e21d306a-bed6-36e1-be99-7cdab6b36d11@ewheeler.net> <e1d2a8c-ff48-bc69-693-9fe75138632b@ewheeler.net> <ZNV5rrq1Ja7QgES5@google.com> <CAG+wEg1wio-0grasdwdfNHr7fHZkZWt2TF2LZtw65WZx42jkyQ@mail.gmail.com>
 <ZNZ3owRcRjGejWFn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Aug 2023, Sean Christopherson wrote:
> On Fri, Aug 11, 2023, Amaan Cheval wrote:
> > > Since it sounds like you can test with a custom kernel, try running with this
> > > patch and then enable the kvm_page_fault tracepoint when a vCPU gets
> > > stuck.  The below expands said tracepoint to capture information about
> > > mmu_notifiers and memslots generation.  With luck, it will reveal a smoking
> > > gun.
> > 
> > Thanks for the patch there. We tried migrating a locked up guest to a host with
> > this modified kernel twice (logs below). The guest "fixed itself" post
> > migration, so the results may not have captured the "problematic" kind of
> > page-fault, but here they are.
> 
> The traces need to be captured from the host where a vCPU is stuck.
> 
> > Complete logs of kvm_page_fault tracepoint events, starting just before the
> > migration (with 0 guests before the migration, so the first logs should be of
> > the problematic guest) as it resolves the lockup:
> > 
> > 1. https://transfer.sh/QjB3MjeBqh/trace-kvm-kpf2.log
> > 2. https://transfer.sh/wEFQm4hLHs/trace-kvm-pf.log
> > 
> > Truncated logs of `trace-cmd record -e kvm -e kvmmmu` in case context helps:
> > 
> > 1. https://transfer.sh/FoFsNoFQCP/trace-kvm2.log
> > 2. https://transfer.sh/LBFJryOfu7/trace-kvm.log
> > 
> > Note that for migration #2 in both respectively above (trace-kvm-pf.log and
> > trace-kvm.log), we didn't confirm that the guest was locked up before migration
> > mistakenly. It most likely was but in case trace #2 doesn't present the same
> > symptoms, that's why.
> > 
> > Off an uneducated glance, it seems like `in_prog = 0x1` at least once for every
> > `seq` / kvm_page_fault that seems to be "looping" and staying unresolved -
> 
> This is completely expected.   The "in_prog" thing is just saying that a vCPU
> took a fault while there was an mmu_notifier event in-progress.
> 
> > indicating a lock contention, perhaps, in trying to invalidate/read/write the
> > same page range?
> 
> No, just a collision between the primary MMU invalidating something, e.g. to move
> a page or do KSM stuff, and a vCPU accessing the page in question.
> 
> > We do know this issue _occurs_ as late as 6.1.38 at least (i.e. hosts running
> > 6.1.38 have had guests lockup - we don't have hosts on more recent kernels, so
> > this isn't proof that it's been fixed since then, nor is migration proof of
> > that, IMO).
> 
> Note, if my hunch is correct, it's the act of migrating to a different *host* that
> resolves the problem, not the fact that the migration is to a different kernel.
> E.g. I would expect that migrating to the exact same kernel would still unstick
> the vCPU.
> 
> What I suspect is happening is that the in-progress count gets left high, e.g.
> because of a start() without a paired end(), and that causes KVM to refuse to
> install mappings for the affected range of guest memory.  Or possibly that the
> problematic host is generating an absolutely massive storm of invalidations and
> unintentionally DoS's the guest.


It would would be great to write a micro benchmark of sorts that generates 
EPT page invalidation pressure, and run it on a test system inside a 
virtual machine to see if we can get it to fault:

Can you suggest the type(s) of memory operations that could be written in 
user space (or kernel space as a module) to, find a test case that forces 
it to fail within a reasonable period of time?

We were thinking of memory mapping lots of page-sized mappings from 
/dev/zero and then randomly write and free them after there are tons of 
them allocated, and do this across multiple threads, while simultaneously 
using `taskset` (or `virsh vcpupin`) on the host to move the guest vCPUs 
across NUMA boundaries, and also with numabalance turned on.

I have also considered passing a device like null_blk.ko into the guest, 
and then doing memory mappings against it in the same way to put pressure 
or on the direct IO path from KVM into the guest user space. 

If you (or anyone else) have other suggestions then I would love to hear 
it. Maybe we can make a reproducer for this.


--
Eric Wheeler


> 
> Either way, migrating the VM to a new host and thus a new KVM instance essentially
> resets all of that metadata and allows KVM to fault-in pages and establish mappings.
> 
> Actually, one thing you could try to unstick a VM would be to do an intra-host
> migration, i.e. migrate it to a new KVM instance on the same host.  If that "fixes"
> the guest, then the bug is likely an mmu_notifier counting bug and not an
> invalidation storm.
> 
> But the easiest thing would be to catch a host in the act, i.e. capture traces
> with my debug patch from a host with a stuck vCPU.
> 

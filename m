Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160CC7802D3
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 02:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356763AbjHRA4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 20:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356773AbjHRA4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 20:56:04 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243D03589
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:56:03 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 8DD1E84;
        Thu, 17 Aug 2023 17:56:02 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id otG8UYnT2ZPT; Thu, 17 Aug 2023 17:55:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 2B3A045;
        Thu, 17 Aug 2023 17:55:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 2B3A045
Date:   Thu, 17 Aug 2023 17:55:58 -0700 (PDT)
From:   Eric Wheeler <kvm@lists.ewheeler.net>
To:     Sean Christopherson <seanjc@google.com>
cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Subject: Re: Deadlock due to EPT_VIOLATION
In-Reply-To: <ZN5lD5Ro9LVgTA6M@google.com>
Message-ID: <3ee6ddd4-74ad-9660-e3e5-a420a089ea54@ewheeler.net>
References: <ZMAGuic1viMLtV7h@google.com> <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com> <ZMp3bR2YkK2QGIFH@google.com> <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com> <ZMqX7TJavsx8WEY2@google.com>
 <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com> <ZNJ2V2vRXckMwPX2@google.com> <c412929a-14ae-2e1-480-418c8d91368a@ewheeler.net> <ZNujhuG++dMbCp6Z@google.com> <5e678d57-66b-a18d-f97e-b41357fdb7f@ewheeler.net>
 <ZN5lD5Ro9LVgTA6M@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Aug 2023, Sean Christopherson wrote:
> On Wed, Aug 16, 2023, Eric Wheeler wrote:
> > On Tue, 15 Aug 2023, Sean Christopherson wrote:
> > > On Mon, Aug 14, 2023, Eric Wheeler wrote:
> > > > On Tue, 8 Aug 2023, Sean Christopherson wrote:
> > > > > > If you have any suggestions on how modifying the host kernel (and then migrating
> > > > > > a locked up guest to it) or eBPF programs that might help illuminate the issue
> > > > > > further, let me know!
> > > > > > 
> > > > > > Thanks for all your help so far!
> > > > > 
> > > > > Since it sounds like you can test with a custom kernel, try running with this
> > > > > patch and then enable the kvm_page_fault tracepoint when a vCPU gets stuck.  The
> > > > > below expands said tracepoint to capture information about mmu_notifiers and
> > > > > memslots generation.  With luck, it will reveal a smoking gun.
> > > > 
> > > > Getting this patch into production systems is challenging, perhaps live
> > > > patching is an option:
> > > 
> > > Ah, I take when you gathered information after a live migration you were migrating
> > > VMs into a sidecar environment.
> > > 
> > > > Questions:
> > > > 
> > > > 1. Do you know if this would be safe to insert as a live kernel patch?
> > > 
> > > Hmm, probably not safe.
> > > 
> > > > For example, does adding to TRACE_EVENT modify a struct (which is not
> > > > live-patch-safe) or is it something that should plug in with simple
> > > > function redirection?
> > > 
> > > Yes, the tracepoint defines a struct, e.g. in this case trace_event_raw_kvm_page_fault.
> > > 
> > > Looking back, I think I misinterpreted an earlier response regarding bpftrace and
> > > unnecessarily abandoned that tactic. *sigh*
> > > 
> > > If your environment provides btf info, then this bpftrace program should provide
> > > the mmu_notifier half of the tracepoint hack-a-patch.  If this yields nothing
> > > interesting then we can try diving into whether or not the mmu_root is stale, but
> > > let's cross that bridge when we have to.
> > > 
> > > I recommend loading this only when you have a stuck vCPU, it'll be quite noisy.
> > > 
> > > kprobe:handle_ept_violation
> > > {
> > > 	printf("vcpu = %lx pid = %u MMU seq = %lx, in-prog = %lx, start = %lx, end = %lx\n",
> > > 	       arg0, ((struct kvm_vcpu *)arg0)->pid->numbers[0].nr,
> > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_seq,
> > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_in_progress,
> > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_start,
> > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_end);
> > > }
> > > 
> > > If you don't have BTF info, we can still use a bpf program, but to get at the
> > > fields of interested, I think we'd have to resort to pointer arithmetic with struct
> > > offsets grab from your build.
> > 
> > We have BTF, so hurray for not needing struct offsets!

Well, I was part right: not all hosts have BTF.

What is involved in doing this with struct offsets for Linux v6.1.x?

> > I am testing this on a host that is not (yet) known to be stuck. Please do 
> > a quick sanity check for me and make sure this looks like the kind of 
> > output that you want to see:
> > 
> > I had to shrink the printf line because it was longer than 64 bytes. I put 
> > the process ID as the first item and changed %lx to %08lx for visual 
> > alignment. Aside from that, it is the same as what you provided.
> > 
> > We're piping it through `uniq -c` to only see interesting changes (and 
> > show counts) because it is extremely noisy. If this looks good to you then 
> > please confirm and I will run it on a production system after a lock-up:
> > 
> > 	kprobe:handle_ept_violation
> > 	{
> > 		printf("ept[%u] vcpu=%08lx seq=%08lx inprog=%lx start=%08lx end=%08lx\n",
> > 		       ((struct kvm_vcpu *)arg0)->pid->numbers[0].nr,
> > 			arg0, 
> > 		       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_seq,
> > 		       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_in_progress,
> > 		       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_start,
> > 		       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_end);
> > 	}
> > 
> > Questions:
> >   - Should pid be zero?  (Note this is not yet running on a host with a 
> >     locked-up guest, in case that is the reason.)
> 
> No.  I'm not at all familiar with PID management, I just copy+pasted from
> pid_nr(), which is what KVM uses when displaying the pid in debugfs.  I printed
> the PID purely to be able to unambiguously correlated prints to vCPUs without
> needing to cross reference kernel addresses.  I.e. having the PID makes life
> easier, but it shouldn't be strictly necessary.

ok

> >   - Can you think of any reason that this would be unsafe? (Forgive my 
> >     paranoia, but of course this will be running on a production
> >     hypervisor.)
> 
> Printing the raw address of the vCPU structure will effectively neuter KASLR, but
> KASLR isn't all that much of a barrier, and whoever has permission to load a BPF
> program on the system can do far, far more damage.

agreed
 
> >   - Can you think of any adjustments to the bpf script above before 
> >     running this for real?
> 
> You could try and make it less noisy or more precise, e.g. by tailoring it to
> print only information on the vCPU that is stuck.  If the noise isn't a problem
> though, I would keep it as-is, the more information the better.

Ok, will leave it as-is

> > Here is an example trace on a test host that isn't locked up:
> > 
> >  ~]# bpftrace handle_ept_violation.bt | grep ^ept --line-buffered | uniq -c
> >    1926 ept[0] vcpu=ffff969569468000 seq=8009c7eb inprog=0 start=7f5993200000 end=7f5993400000
> >  215722 ept[0] vcpu=ffff9695684b8000 seq=8009c7eb inprog=0 start=7f5993200000 end=7f5993400000
> >   66280 ept[0] vcpu=ffff969569468000 seq=8009c7eb inprog=0 start=7f5993200000 end=7f5993400000
> > 18609437 ept[0] vcpu=ffff9695684b8000 seq=8009c7eb inprog=0 start=7f5993200000 end=7f5993400000
> 
> Woah.  That's over 2 *billion* invalidations for a single VM.  Even if that's a
> long-lived VM, that's still seems rather insane.  E.g. if the uptime of that VM
> *on that host* is 6 months, my back of the napkin math says that that's nearly
> 100 invalidations every second for 6 months straight.
> 
> Bit 31 being set in relative isolation almost makes me wonder if mmu_invalidate_seq
> got corrupted somehow.  Either that or you are thrashing that VM with a vengeance.
 
Not sure what is happening on that host, but it could be being thrashed by 
another dev to try and reproduce the bug for bisect, but we don't have a 
reproducer yet...



--
Eric Wheeler



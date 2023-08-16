Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B532277EDFD
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 01:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347250AbjHPXzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 19:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347255AbjHPXy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 19:54:56 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EDE1BEE
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 16:54:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id D14EC85;
        Wed, 16 Aug 2023 16:54:54 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id UaIkHMSmQa0X; Wed, 16 Aug 2023 16:54:50 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 4D0DD45;
        Wed, 16 Aug 2023 16:54:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 4D0DD45
Date:   Wed, 16 Aug 2023 16:54:50 -0700 (PDT)
From:   Eric Wheeler <kvm@lists.ewheeler.net>
To:     Sean Christopherson <seanjc@google.com>
cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Subject: Re: Deadlock due to EPT_VIOLATION
In-Reply-To: <ZNujhuG++dMbCp6Z@google.com>
Message-ID: <5e678d57-66b-a18d-f97e-b41357fdb7f@ewheeler.net>
References: <ZLrCUkwot/yiVC8T@google.com> <CAG+wEg21f6PPEnP2N7oE=48PBSd_2bHOcRsTy_ZuBpa2=dGuiA@mail.gmail.com> <ZMAGuic1viMLtV7h@google.com> <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com> <ZMp3bR2YkK2QGIFH@google.com>
 <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com> <ZMqX7TJavsx8WEY2@google.com> <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com> <ZNJ2V2vRXckMwPX2@google.com> <c412929a-14ae-2e1-480-418c8d91368a@ewheeler.net>
 <ZNujhuG++dMbCp6Z@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Aug 2023, Sean Christopherson wrote:
> On Mon, Aug 14, 2023, Eric Wheeler wrote:
> > On Tue, 8 Aug 2023, Sean Christopherson wrote:
> > > > If you have any suggestions on how modifying the host kernel (and then migrating
> > > > a locked up guest to it) or eBPF programs that might help illuminate the issue
> > > > further, let me know!
> > > > 
> > > > Thanks for all your help so far!
> > > 
> > > Since it sounds like you can test with a custom kernel, try running with this
> > > patch and then enable the kvm_page_fault tracepoint when a vCPU gets stuck.  The
> > > below expands said tracepoint to capture information about mmu_notifiers and
> > > memslots generation.  With luck, it will reveal a smoking gun.
> > 
> > Getting this patch into production systems is challenging, perhaps live
> > patching is an option:
> 
> Ah, I take when you gathered information after a live migration you were migrating
> VMs into a sidecar environment.
> 
> > Questions:
> > 
> > 1. Do you know if this would be safe to insert as a live kernel patch?
> 
> Hmm, probably not safe.
> 
> > For example, does adding to TRACE_EVENT modify a struct (which is not
> > live-patch-safe) or is it something that should plug in with simple
> > function redirection?
> 
> Yes, the tracepoint defines a struct, e.g. in this case trace_event_raw_kvm_page_fault.
> 
> Looking back, I think I misinterpreted an earlier response regarding bpftrace and
> unnecessarily abandoned that tactic. *sigh*
> 
> If your environment provides btf info, then this bpftrace program should provide
> the mmu_notifier half of the tracepoint hack-a-patch.  If this yields nothing
> interesting then we can try diving into whether or not the mmu_root is stale, but
> let's cross that bridge when we have to.
> 
> I recommend loading this only when you have a stuck vCPU, it'll be quite noisy.
> 
> kprobe:handle_ept_violation
> {
> 	printf("vcpu = %lx pid = %u MMU seq = %lx, in-prog = %lx, start = %lx, end = %lx\n",
> 	       arg0, ((struct kvm_vcpu *)arg0)->pid->numbers[0].nr,
> 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_seq,
> 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_in_progress,
> 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_start,
> 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_end);
> }
> 
> If you don't have BTF info, we can still use a bpf program, but to get at the
> fields of interested, I think we'd have to resort to pointer arithmetic with struct
> offsets grab from your build.

We have BTF, so hurray for not needing struct offsets!

I am testing this on a host that is not (yet) known to be stuck. Please do 
a quick sanity check for me and make sure this looks like the kind of 
output that you want to see:

I had to shrink the printf line because it was longer than 64 bytes. I put 
the process ID as the first item and changed %lx to %08lx for visual 
alignment. Aside from that, it is the same as what you provided.

We're piping it through `uniq -c` to only see interesting changes (and 
show counts) because it is extremely noisy. If this looks good to you then 
please confirm and I will run it on a production system after a lock-up:

	kprobe:handle_ept_violation
	{
		printf("ept[%u] vcpu=%08lx seq=%08lx inprog=%lx start=%08lx end=%08lx\n",
		       ((struct kvm_vcpu *)arg0)->pid->numbers[0].nr,
			arg0, 
		       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_seq,
		       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_in_progress,
		       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_start,
		       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_end);
	}

Questions:
  - Should pid be zero?  (Note this is not yet running on a host with a 
    locked-up guest, in case that is the reason.)

  - Can you think of any reason that this would be unsafe? (Forgive my 
    paranoia, but of course this will be running on a production
    hypervisor.)

  - Can you think of any adjustments to the bpf script above before 
    running this for real?


Here is an example trace on a test host that isn't locked up:

 ~]# bpftrace handle_ept_violation.bt | grep ^ept --line-buffered | uniq -c
   1926 ept[0] vcpu=ffff969569468000 seq=8009c7eb inprog=0 start=7f5993200000 end=7f5993400000
 215722 ept[0] vcpu=ffff9695684b8000 seq=8009c7eb inprog=0 start=7f5993200000 end=7f5993400000
  66280 ept[0] vcpu=ffff969569468000 seq=8009c7eb inprog=0 start=7f5993200000 end=7f5993400000
18609437 ept[0] vcpu=ffff9695684b8000 seq=8009c7eb inprog=0 start=7f5993200000 end=7f5993400000
     30 ept[0] vcpu=ffff96955de90000 seq=001fa362 inprog=0 start=7fa25ef0f000 end=7fa25ef10000
      1 ept[0] vcpu=ffff96955de92340 seq=001fa44e inprog=0 start=7fa23f789000 end=7fa23f78a000
      2 ept[0] vcpu=ffff96955de92340 seq=001fa59f inprog=0 start=7fa23dfe8000 end=7fa23dfe9000
      2 ept[0] vcpu=ffff96955de92340 seq=001fa5a0 inprog=0 start=7fa23b723000 end=7fa23b724000
      1 ept[0] vcpu=ffff96955de92340 seq=001fa5a1 inprog=0 start=7fa238d50000 end=7fa238d51000
      1 ept[0] vcpu=ffff96955de92340 seq=001fa5a5 inprog=0 start=7fa24d920000 end=7fa24d921000
      1 ept[0] vcpu=ffff96955de92340 seq=001fa5a6 inprog=0 start=7fa238a73000 end=7fa238a74000
      1 ept[0] vcpu=ffff96955de92340 seq=001fa5ea inprog=0 start=7fa244791000 end=7fa244792000
      1 ept[0] vcpu=ffff96955de92340 seq=001fa5eb inprog=0 start=7fa24c988000 end=7fa24c989000
      3 ept[0] vcpu=ffff96955de92340 seq=001fa5ec inprog=0 start=7fa23f78b000 end=7fa23f78c000
      2 ept[0] vcpu=ffff96955de92340 seq=001fa5ed inprog=0 start=7fa24256a000 end=7fa24256b000
      2 ept[0] vcpu=ffff96955de92340 seq=001fa5ee inprog=0 start=7fa24ed2b000 end=7fa24ed2c000

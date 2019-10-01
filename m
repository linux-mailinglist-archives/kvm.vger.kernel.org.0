Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 810CDC41F7
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 22:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfJAUtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 16:49:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:59737 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbfJAUtu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 16:49:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 13:49:45 -0700
X-IronPort-AV: E=Sophos;i="5.64,571,1559545200"; 
   d="scan'208";a="181819191"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 13:49:45 -0700
Message-ID: <b45c9ea924cbb8b8dc390082d5a0b4bd91e7a8f8.camel@linux.intel.com>
Subject: Re: [PATCH v11 0/6] mm / virtio: Provide support for unused page
 reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, riel@surriel.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com
Date:   Tue, 01 Oct 2019 13:49:45 -0700
In-Reply-To: <d21e6fce694f286ecaf227697a1ec5555734520b.camel@linux.intel.com>
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
         <7233498c-2f64-d661-4981-707b59c78fd5@redhat.com>
         <1ea1a4e11617291062db81f65745b9c95fd0bb30.camel@linux.intel.com>
         <8bd303a6-6e50-b2dc-19ab-4c3f176c4b02@redhat.com>
         <d21e6fce694f286ecaf227697a1ec5555734520b.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-10-01 at 13:25 -0700, Alexander Duyck wrote:
> On Tue, 2019-10-01 at 15:16 -0400, Nitesh Narayan Lal wrote:
> > On 10/1/19 12:21 PM, Alexander Duyck wrote:
> > > On Tue, 2019-10-01 at 17:35 +0200, David Hildenbrand wrote:
> > > > On 01.10.19 17:29, Alexander Duyck wrote:
> 
> <snip>
> 
> > > > > As far as possible regressions I have focused on cases where performing
> > > > > the hinting would be non-optimal, such as cases where the code isn't
> > > > > needed as memory is not over-committed, or the functionality is not in
> > > > > use. I have been using the will-it-scale/page_fault1 test running with 16
> > > > > vcpus and have modified it to use Transparent Huge Pages. With this I see
> > > > > almost no difference with the patches applied and the feature disabled.
> > > > > Likewise I see almost no difference with the feature enabled, but the
> > > > > madvise disabled in the hypervisor due to a device being assigned. With
> > > > > the feature fully enabled in both guest and hypervisor I see a regression
> > > > > between -1.86% and -8.84% versus the baseline. I found that most of the
> > > > > overhead was due to the page faulting/zeroing that comes as a result of
> > > > > the pages having been evicted from the guest.
> > > > I think Michal asked for a performance comparison against Nitesh's
> > > > approach, to evaluate if keeping the reported state + tracking inside
> > > > the buddy is really worth it. Do you have any such numbers already? (or
> > > > did my tired eyes miss them in this cover letter? :/)
> > > > 
> > > I thought what Michal was asking for was what was the benefit of using the
> > > boundary pointer. I added a bit up above and to the description for patch
> > > 3 as on a 32G VM it adds up to about a 18% difference without factoring in
> > > the page faulting and zeroing logic that occurs when we actually do the
> > > madvise.
> > > 
> > > Do we have a working patch set for Nitesh's code? The last time I tried
> > > running his patch set I ran into issues with kernel panics. If we have a
> > > known working/stable patch set I can give it a try.
> > 
> > Did you try the v12 patch-set [1]?
> > I remember that you reported the CPU stall issue, which I fixed in the v12.
> > 
> > [1] https://lkml.org/lkml/2019/8/12/593
> > 
> > > - Alex
> > > 
> 
> I haven't tested it. I will pull the patches and give it a try. It works
> with the same QEMU changes that mine does right? If so we should be able
> to get an apples-to-apples comparison.
> 
> Also, instead of providing lkml.org links to your patches in the future it
> might be better to provide a link to the lore.kernel.org version of the
> thread. So for example the v12 set would be:
> https://lore.kernel.org/lkml/20190812131235.27244-1-nitesh@redhat.com/
> 
> The advantage is you can just look up the message ID in your own inbox to
> figure out the link, and it provides raw access to the email if needed.
> 
> Thanks.
> 
> - Alex

So it looks like v12 still has issues. I'm pretty sure you should be using
spin_lock_irq(), not spin_lock() in page_reporting.c to avoid the
possibility of an IRQ firing and causing lock recursion on the zone lock.

I'm trying to work around it now, but it needs to be addressed for future
versions.

Here is the lock-up my guest reported.

[  127.869086] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[  127.872219] rcu: 	0-...0: (0 ticks this GP) idle=94e/1/0x4000000000000002 softirq=5354/5354 fqs=15000 
[  127.874915] rcu: 	1-...0: (0 ticks this GP) idle=3b6/1/0x4000000000000000 softirq=3359/3359 fqs=15000 
[  127.877616] 	(detected by 2, t=60004 jiffies, g=8153, q=8)
[  127.879229] Sending NMI from CPU 2 to CPUs 0:
[  127.881523] NMI backtrace for cpu 0
[  127.881524] CPU: 0 PID: 658 Comm: kworker/0:6 Not tainted 5.3.0-next-20190930nshuffle+ #2
[  127.881524] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[  127.881525] Workqueue: events page_reporting_wq
[  127.881526] RIP: 0010:queued_spin_lock_slowpath+0x21/0x1f0
[  127.881526] Code: c0 75 ec c3 90 90 90 90 90 0f 1f 44 00 00 0f 1f 44 00 00 ba 01 00 00 00 8b 07 85 c0 75 0a f0 0f b1 17 85 c0 75 f2 f3 c3 f3 90 <eb> ec 81 fe 00 01 00 00 0f 84 44 01 00 00 81 e6 00 ff ff ff 75 3e
[  127.881527] RSP: 0018:ffffb77480003df0 EFLAGS: 00000002
[  127.881527] RAX: 0000000000000001 RBX: 0000000000000001 RCX: dead000000000122
[  127.881528] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff992a3fffd240
[  127.881528] RBP: 0000000000000006 R08: 0000000000000000 R09: ffffdd9c508cf948
[  127.881528] R10: 0000000000000000 R11: 0000000000000000 R12: ffff992a3fffcd00
[  127.881529] R13: ffffdd9c508cf900 R14: ffff992a2fa2e380 R15: 0000000000000001
[  127.881529] FS:  0000000000000000(0000) GS:ffff992a2fa00000(0000) knlGS:0000000000000000
[  127.881529] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  127.881530] CR2: 00007ffff7c50000 CR3: 000000042c6b8004 CR4: 0000000000160ef0
[  127.881530] Call Trace:
[  127.881530]  <IRQ>
[  127.881531]  free_pcppages_bulk+0x15f/0x7d0
[  127.881531]  free_unref_page+0x54/0x70
[  127.881531]  tlb_remove_table_rcu+0x23/0x40
[  127.881531]  rcu_do_batch+0x139/0x3f0
[  127.881532]  rcu_core+0x1b9/0x2d0
[  127.881532]  __do_softirq+0xe2/0x2bb
[  127.881532]  irq_exit+0xd5/0xe0
[  127.881532]  smp_apic_timer_interrupt+0x74/0x140
[  127.881533]  apic_timer_interrupt+0xf/0x20
[  127.881533]  </IRQ>
[  127.881533] RIP: 0010:__list_del_entry_valid+0x31/0x90
[  127.881534] Code: 00 00 00 00 ad de 48 8b 57 08 48 39 c8 74 26 48 b9 22 01 00 00 00 00 ad de 48 39 ca 74 53 48 8b 12 48 39 d7 75 38 48 8b 50 08 <48> 39 d7 75 1c b8 01 00 00 00 c3 48 89 c2 48 89 fe 31 c0 48 c7 c7
[  127.881534] RSP: 0018:ffffb774837cfdf8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[  127.881535] RAX: ffffdd9c50858008 RBX: ffffdd9c50798000 RCX: dead000000000122
[  127.881535] RDX: ffffdd9c50798008 RSI: 0000000000000000 RDI: ffffdd9c50798008
[  127.881536] RBP: ffff992a3fffcd00 R08: 0000000000000000 R09: 00000000003241ad
[  127.881536] R10: 0000000000000000 R11: 00000000000025c4 R12: 0000000000000009
[  127.881536] R13: fffffffffffffe00 R14: 0000000000000001 R15: ffff992a3fffcd00
[  127.881537]  __isolate_free_page+0xe9/0x1d0
[  127.881537]  page_reporting_wq+0x1ba/0x290
[  127.881537]  process_one_work+0x16c/0x370
[  127.881538]  worker_thread+0x49/0x3e0
[  127.881538]  kthread+0xf8/0x130
[  127.881538]  ? apply_wqattrs_commit+0x100/0x100
[  127.881538]  ? kthread_bind+0x10/0x10
[  127.881539]  ret_from_fork+0x35/0x40
[  127.881543] Sending NMI from CPU 2 to CPUs 1:
[  127.921299] NMI backtrace for cpu 1
[  127.921300] CPU: 1 PID: 1257 Comm: page_fault4_pro Not tainted 5.3.0-next-20190930nshuffle+ #2
[  127.921300] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[  127.921300] RIP: 0010:queued_spin_lock_slowpath+0x21/0x1f0
[  127.921301] Code: c0 75 ec c3 90 90 90 90 90 0f 1f 44 00 00 0f 1f 44 00 00 ba 01 00 00 00 8b 07 85 c0 75 0a f0 0f b1 17 85 c0 75 f2 f3 c3 f3 90 <eb> ec 81 fe 00 01 00 00 0f 84 44 01 00 00 81 e6 00 ff ff ff 75 3e
[  127.921301] RSP: 0000:ffffb7748378bbd8 EFLAGS: 00000002
[  127.921302] RAX: 0000000000000001 RBX: 0000000000000246 RCX: 0000000000000001
[  127.921302] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff992a3fffd240
[  127.921303] RBP: 0000000000000009 R08: 0000000000000080 R09: 0000000000323dae
[  127.921303] R10: 0000000000000009 R11: 00000000000030d1 R12: 0000000000000081
[  127.921304] R13: 00000000003c24ca R14: 0000000000000000 R15: ffff992a3fffcd00
[  127.921304] FS:  00007ffff7c52540(0000) GS:ffff992a2fa40000(0000) knlGS:0000000000000000
[  127.921304] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  127.921305] CR2: 00007ffff1e00000 CR3: 000000042f17c001 CR4: 0000000000160ee0
[  127.921305] Call Trace:
[  127.921305]  _raw_spin_lock_irqsave+0x35/0x40
[  127.921305]  get_page_from_freelist+0xba0/0x13c0
[  127.921306]  ? prep_new_page+0xad/0xf0
[  127.921306]  __alloc_pages_nodemask+0x197/0x350
[  127.921306]  alloc_pages_vma+0x160/0x1b0
[  127.921307]  do_huge_pmd_anonymous_page+0x123/0x8a0
[  127.921307]  __handle_mm_fault+0xcbe/0x15f0
[  127.921307]  ? do_mmap+0x47b/0x5e0
[  127.921307]  handle_mm_fault+0xe2/0x1f0
[  127.921308]  __do_page_fault+0x234/0x4c0
[  127.921308]  do_page_fault+0x31/0x120
[  127.921308]  async_page_fault+0x3e/0x50
[  127.921308] RIP: 0033:0x401c30
[  127.921309] Code: 00 00 00 08 e8 d1 f4 ff ff 48 89 c5 48 83 f8 ff 74 40 ba 0e 00 00 00 be 00 00 00 08 48 89 c7 e8 e6 f5 ff ff 31 c0 0f 1f 40 00 <c6> 44 05 00 00 4c 01 e0 48 83 03 01 48 3d ff ff ff 07 76 ec be 00
[  127.921309] RSP: 002b:00007fffffffc8f0 EFLAGS: 00010293
[  127.921310] RAX: 00000000021af000 RBX: 00007ffff7ffb080 RCX: 00007ffff7eaf2eb
[  127.921310] RDX: 000000000000000e RSI: 0000000008000000 RDI: 00007fffefc51000
[  127.921311] RBP: 00007fffefc51000 R08: 00000000ffffffff R09: 0000000000000000
[  127.921311] R10: 0000000000000022 R11: 0000000000000213 R12: 0000000000001000
[  127.921311] R13: 000000000044de20 R14: 000000000040d890 R15: 0000000000408d20



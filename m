Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDB4784DE3
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 02:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjHWAjw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 20:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjHWAjw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 20:39:52 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2409E93
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 17:39:50 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id CCFE385;
        Tue, 22 Aug 2023 17:39:49 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id Fct1ubrqms8S; Tue, 22 Aug 2023 17:39:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 328C145;
        Tue, 22 Aug 2023 17:39:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 328C145
Date:   Tue, 22 Aug 2023 17:39:45 -0700 (PDT)
From:   Eric Wheeler <kvm@lists.ewheeler.net>
To:     Sean Christopherson <seanjc@google.com>
cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Subject: Re: Deadlock due to EPT_VIOLATION
In-Reply-To: <ZOTQPUk5kxskDcsi@google.com>
Message-ID: <58f24fa2-a5f4-c59a-2bcf-c49f7bddc5b@ewheeler.net>
References: <c412929a-14ae-2e1-480-418c8d91368a@ewheeler.net> <ZNujhuG++dMbCp6Z@google.com> <5e678d57-66b-a18d-f97e-b41357fdb7f@ewheeler.net> <ZN5lD5Ro9LVgTA6M@google.com> <3ee6ddd4-74ad-9660-e3e5-a420a089ea54@ewheeler.net> <ZN+BRjUxouKiDSbx@google.com>
 <418345e5-a3e5-6e8d-395a-f5551ea13e2@ewheeler.net> <5fc6cea-9f51-582c-8bb3-21e0b4bf397@ewheeler.net> <ZOP4lwiMU2Uf89eQ@google.com> <468b1298-e43e-2397-5f3-4b6af6e2f461@ewheeler.net> <ZOTQPUk5kxskDcsi@google.com>
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

On Tue, 22 Aug 2023, Sean Christopherson wrote:
> > Here is the whole log with 500,000+ lines over 5 minutes of recording, it 
> > was first stuck on one vcpu for most of the time, and toward the end it 
> > was stuck on a different VCPU:
> > 
> > The file starts with 555,596 occurances of vcpu=ffff9964cdc48000 and is 
> > then followed by 31,784 occurances of vcpu=ffff9934ed50c680.  As you can 
> > see in the file, they are not interleaved:
> > 
> > 	https://www.linuxglobal.com/out/handle_ept_violation.log2
> > 
> >   # awk '{print $3}' handle_ept_violation.log2 |uniq -c
> >    555596 vcpu=ffff9964cdc48000
> >     31784 vcpu=ffff9934ed50c680
> 
> Hrm, but the address range being invalidated is changing.  Without seeing the
> guest RIP, or even a timestamp, it's impossible to tell if the vCPU is well and
> truly stuck or if it's just getting thrashed so hard by NUMA balancing or KSM
> that it looks stuck.
> 
> Drat.
> 
> > > Below is another bpftrace program that will hopefully shrink the 
> > > haystack to the point where we can find something via code inspection.
> > 
> > Ok thanks, we'll give it a try.
> 
> Try this version instead.  It's more comprehensive and more precise, e.g. should
> only trigger on the guest being 100% stuck, and also fixes a PID vs. TID goof.
> 
> Note!  Enable trace_kvm_exit before/when running this to ensure KVM grabs the guest RIP
> from the VMCS.  Without that enabled, RIP from vcpu->arch.regs[16] may be stale.

Ok, we got a 740MB log, zips down to 25MB if you would like to see the
whole thing, it is here:
	http://linuxglobal.com/out/handle_ept_violation-v2.log.gz

For brevity, here is a sample of each 100,000th line:

# zcat handle_ept_violation-v2.log.gz | perl -lne '!($n++%100000) && print'
Attaching 3 probes...
00:30:31:347560 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (375972 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:32:047769 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (706308 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:32:746729 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (1039825 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:33:447298 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (1375881 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:34:160967 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (1715243 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:34:882187 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (2060501 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:35:597351 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (2402485 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:36:323613 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (2749250 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:37:039834 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (3090704 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:37:775801 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (3444375 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:38:564075 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (3824996 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:39:320611 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (4186268 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:40:006544 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (4514744 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:40:708219 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (4850395 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:41:424570 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (5195103 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:42:147032 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (5543824 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:42:878845 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (5887371 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:43:590424 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (6234881 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:44:308041 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (6581426 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:45:039868 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (6925844 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:45:773678 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (7278195 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:46:507469 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (7634480 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:47:252621 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (7997426 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:47:935297 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (8323684 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:48:626000 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (8654836 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:49:344852 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (8991281 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:50:239769 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (9414664 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:50:940747 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (9755243 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:51:666992 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (10101607 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:52:383241 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (10433521 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:53:105012 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (10785355 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:53:867494 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (11149981 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:54:632045 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (11515349 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:55:403662 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (11882055 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:56:182540 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (12251134 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:56:915633 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (12596230 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:57:658496 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (12939661 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:58:395829 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (13290046 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
00:30:59:186697 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (13670748 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000

...

@same[553909]: 14142928


--
Eric Wheeler



> 
> struct kvm_page_fault {
> 	const u64 addr;
> 	const u32 error_code;
> 	const bool prefetch;
> 
> 	const bool exec;
> 	const bool write;
> 	const bool present;
> 	const bool rsvd;
> 	const bool user;
> 
> 	const bool is_tdp;
> 	const bool nx_huge_page_workaround_enabled;
> 
> 	bool huge_page_disallowed;
> 	u8 max_level;
> 
> 	u8 req_level;
> 
> 	u8 goal_level;
> 
> 	u64 gfn;
> 
> 	struct kvm_memory_slot *slot;
> 
> 	u64 pfn;
> 	unsigned long hva;
> 	bool map_writable;
> };
> 
> kprobe:kvm_faultin_pfn
> {
> 	$vcpu = (struct kvm_vcpu *)arg0;
> 	$kvm = $vcpu->kvm;
> 	$rip = $vcpu->arch.regs[16];
> 
> 	if (@last_rip[tid] == $rip) {
> 		@same[tid]++
> 	} else {
> 		@same[tid] = 0;
> 	}
> 	@last_rip[tid] = $rip;
> 
> 	if (@same[tid] > 1000) {
> 		$fault = (struct kvm_page_fault *)arg1;
> 		$hva = -1;
> 		$flags = 0;
> 
> 		if ($fault->slot != 0) {
> 			$hva = $fault->slot->userspace_addr +
> 			       (($fault->gfn - $fault->slot->base_gfn) << 12);
> 			$flags = $fault->slot->flags;
> 		}
> 
> 		printf("%s tid[%u] pid[%u] stuck @ rip %lx (%lu hits), gpa = %lx, hva = %lx : MMU seq = %lx, in-prog = %lx, start = %lx, end = %lx\n",
> 		       strftime("%H:%M:%S:%f", nsecs), tid, pid, $rip, @same[tid], $fault->addr, $hva,
> 		       $kvm->mmu_invalidate_seq, $kvm->mmu_invalidate_in_progress,
> 		       $kvm->mmu_invalidate_range_start, $kvm->mmu_invalidate_range_end);
> 	}
> }
> 
> kprobe:make_mmio_spte
> {
>         if (@same[tid] > 1000) {
> 	        $vcpu = (struct kvm_vcpu *)arg0;
> 		$rip = $vcpu->arch.regs[16];
> 
> 		printf("%s tid[%u] pid[%u] stuck @ rip %lx made it to make_mmio_spte()\n",
> 		       strftime("%H:%M:%S:%f", nsecs), tid, pid, $rip);
> 	}
> }
> 
> kprobe:make_spte
> {
>         if (@same[tid] > 1000) {
> 	        $vcpu = (struct kvm_vcpu *)arg0;
> 		$rip = $vcpu->arch.regs[16];
> 
> 		printf("%s tid[%u] pid[%u] stuck @ rip %lx made it to make_spte()\n",
> 		       strftime("%H:%M:%S:%f", nsecs), tid, pid, $rip);
> 	}
> }
> 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCDF785EF5
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 19:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237926AbjHWRyo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 13:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234813AbjHWRyo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 13:54:44 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53BEE7E
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 10:54:41 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-68a2d9a6b5fso6179442b3a.0
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 10:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692813281; x=1693418081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FRS5JycPIbwXyepy+wtXK/xgbAvVm4Y5kSYZYv7pZro=;
        b=CaScwIbHjNalEgm8mDbbvhRqFtY2hd3VcU4NfsvTZLv01vrPmr5OrLi5RVl3ef9N1n
         KQ+zkhvN8+39aOwg0M5oA8A2AQ3HjXeXC05yE6nnlemIJ1/a/wXWP6JQwJ98LWt0BcIf
         x4UguKrjuU/5qk79Ha1CjeFlDVh9SRNJSpzZyvUYLlvwMdvwr9Rph2RTO40BTVGKPL6p
         s/w/PHWW6wc1CxRBgvizu/hIBoTMCUVp4Kv/7MvreStmQbu5BHairGhEiUlkO4LJrXhx
         9Y2x2xI5zGj6Jut2g3VFmtz+E2eQjG056q5Jv61lkT/b13vn+oltG0i9E/P1EjCccYKE
         y4Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692813281; x=1693418081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FRS5JycPIbwXyepy+wtXK/xgbAvVm4Y5kSYZYv7pZro=;
        b=Xjv33mmL4xt0jp64q/RLbpM8HIC/r2U6sN/KxIrW7Y3gtNSbenW6TD9c0wujOjfUQd
         gjd+uUBfwoyziFRGho4wbca2/s6WhcBxi8X7J9qGj7Fq0QQkDfLOPDEQjyACNGebrOqp
         K1dwFCiPjfmS1uXf8lsvCnqW4VIYKMb/d83ck47FVugbv4fg3504cOIfibrccnWRJINE
         dFy5pfTPeW0ZFl8isOd3TdMc1zANgQGKFD0jc2W2KxFfXelS9tDeV+VWP1ebUCK3BsP0
         GkfS+hHmf9Gk+ZukBNxzDGvYRzAFom3rC2bZXTXBkeUJzcW+0m2DCXzsZQNflNvcCFy8
         wDjA==
X-Gm-Message-State: AOJu0Yyq02HBqbnRTyURuaNk2VSSx4qsgLlQ523DqV/6WRay6hI3puh1
        0QlbmDKNDsVbjJ3zOC0SHyBcutid+2M=
X-Google-Smtp-Source: AGHT+IGqyqUB5YL1GXyMSP2MQldFgNtsuPWQntLuougmLzJdJR5fJtGRptKATycBFqzTSk/Q0Y7BnY0rHjw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:17a6:b0:68a:6735:e44 with SMTP id
 s38-20020a056a0017a600b0068a67350e44mr3335280pfg.6.1692813281100; Wed, 23 Aug
 2023 10:54:41 -0700 (PDT)
Date:   Wed, 23 Aug 2023 10:54:39 -0700
In-Reply-To: <58f24fa2-a5f4-c59a-2bcf-c49f7bddc5b@ewheeler.net>
Mime-Version: 1.0
References: <5e678d57-66b-a18d-f97e-b41357fdb7f@ewheeler.net>
 <ZN5lD5Ro9LVgTA6M@google.com> <3ee6ddd4-74ad-9660-e3e5-a420a089ea54@ewheeler.net>
 <ZN+BRjUxouKiDSbx@google.com> <418345e5-a3e5-6e8d-395a-f5551ea13e2@ewheeler.net>
 <5fc6cea-9f51-582c-8bb3-21e0b4bf397@ewheeler.net> <ZOP4lwiMU2Uf89eQ@google.com>
 <468b1298-e43e-2397-5f3-4b6af6e2f461@ewheeler.net> <ZOTQPUk5kxskDcsi@google.com>
 <58f24fa2-a5f4-c59a-2bcf-c49f7bddc5b@ewheeler.net>
Message-ID: <ZOZH3xe0u4NHhvL8@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Eric Wheeler <kvm@lists.ewheeler.net>
Cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 22, 2023, Eric Wheeler wrote:
> On Tue, 22 Aug 2023, Sean Christopherson wrote:
> > > Here is the whole log with 500,000+ lines over 5 minutes of recording, it 
> > > was first stuck on one vcpu for most of the time, and toward the end it 
> > > was stuck on a different VCPU:
> > > 
> > > The file starts with 555,596 occurances of vcpu=ffff9964cdc48000 and is 
> > > then followed by 31,784 occurances of vcpu=ffff9934ed50c680.  As you can 
> > > see in the file, they are not interleaved:
> > > 
> > > 	https://www.linuxglobal.com/out/handle_ept_violation.log2
> > > 
> > >   # awk '{print $3}' handle_ept_violation.log2 |uniq -c
> > >    555596 vcpu=ffff9964cdc48000
> > >     31784 vcpu=ffff9934ed50c680
> > 
> > Hrm, but the address range being invalidated is changing.  Without seeing the
> > guest RIP, or even a timestamp, it's impossible to tell if the vCPU is well and
> > truly stuck or if it's just getting thrashed so hard by NUMA balancing or KSM
> > that it looks stuck.
> > 
> > Drat.
> > 
> > > > Below is another bpftrace program that will hopefully shrink the 
> > > > haystack to the point where we can find something via code inspection.
> > > 
> > > Ok thanks, we'll give it a try.
> > 
> > Try this version instead.  It's more comprehensive and more precise, e.g. should
> > only trigger on the guest being 100% stuck, and also fixes a PID vs. TID goof.
> > 
> > Note!  Enable trace_kvm_exit before/when running this to ensure KVM grabs the guest RIP
> > from the VMCS.  Without that enabled, RIP from vcpu->arch.regs[16] may be stale.
> 
> Ok, we got a 740MB log, zips down to 25MB if you would like to see the
> whole thing, it is here:
> 	http://linuxglobal.com/out/handle_ept_violation-v2.log.gz
> 
> For brevity, here is a sample of each 100,000th line:
> 
> # zcat handle_ept_violation-v2.log.gz | perl -lne '!($n++%100000) && print'
> Attaching 3 probes...
> 00:30:31:347560 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (375972 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000

Argh.  I'm having a bit of a temper tantrum because I forgot to have the printf
spit out the memslot flags.  And I apparently gave you a version without a probe
on kvm_tdp_mmu_map().  Grr.

Can you capture one more trace?  Fingers crossed this is the last one.  Modified
program below.

On the plus side, I'm slowly learning how to effectively use bpf programs.
This version also prints return values and and other relevant side effects from
kvm_faultin_pfn(), and I figured out a way to get at the vCPU's root MMU page.

And it stops printing after a vCPU (task) has been stuck for 100k exits, i.e. it
should self-limit the spam.  Even if the vCPU managed to unstick itself after
that point, which is *extremely* unlikely, being stuck for 100k exits all but
guarantees there's a bug somewhere.

So this *should* give us a smoking gun.  Depending on what the gun points at, a
full root cause may still be a long ways off, but I'm pretty sure this mess will
tell us exactly why KVM is refusing to fix the fault.

--

struct kvm_page_fault {
	const u64 addr;
	const u32 error_code;

	const bool prefetch;
	const bool exec;
	const bool write;
	const bool present;

	const bool rsvd;
	const bool user;
	const bool is_tdp;
	const bool nx_huge_page_workaround_enabled;

	bool huge_page_disallowed;

	u8 max_level;
	u8 req_level;
	u8 goal_level;

	u64 gfn;

	struct kvm_memory_slot *slot;

	u64 pfn;
	unsigned long hva;
	bool map_writable;
};

struct kvm_mmu_page {
	struct list_head link;
	struct hlist_node hash_link;

	bool tdp_mmu_page;
	bool unsync;
	u8 mmu_valid_gen;
	bool lpage_disallowed;

	u32 role;
	u64 gfn;

	u64 *spt;

	u64 *shadowed_translation;

	int root_count;
}

kprobe:kvm_faultin_pfn
{
	$vcpu = (struct kvm_vcpu *)arg0;
	$kvm = $vcpu->kvm;
	$rip = $vcpu->arch.regs[16];

	if (@last_rip[tid] == $rip) {
		@same[tid]++
	} else {
		@same[tid] = 0;
	}
	@last_rip[tid] = $rip;

	if (@same[tid] > 1000 && @same[tid] < 100000) {
		$fault = (struct kvm_page_fault *)arg1;
		$hva = -1;
		$flags = 0;

		@__vcpu[tid] = arg0;
		@__fault[tid] = arg1;

		if ($fault->slot != 0) {
			$hva = $fault->slot->userspace_addr +
			       (($fault->gfn - $fault->slot->base_gfn) << 12);
			$flags = $fault->slot->flags;
		}

		printf("%s tid[%u] pid[%u] FAULTIN @ rip %lx (%lu hits), gpa = %lx, hva = %lx, flags = %lx : MMU seq = %lx, in-prog = %lx, start = %lx, end = %lx\n",
		       strftime("%H:%M:%S:%f", nsecs), tid, pid, $rip, @same[tid], $fault->addr, $hva, $flags,
		       $kvm->mmu_invalidate_seq, $kvm->mmu_invalidate_in_progress,
		       $kvm->mmu_invalidate_range_start, $kvm->mmu_invalidate_range_end);
	} else {
		@__vcpu[tid] = 0;
		@__fault[tid] = 0;
	}
}

kretprobe:kvm_faultin_pfn
{
	if (@__fault[tid] != 0) {
		$vcpu = (struct kvm_vcpu *)@__vcpu[tid];
		$kvm = $vcpu->kvm;
		$fault = (struct kvm_page_fault *)@__fault[tid];
		$hva = -1;
		$flags = 0;

		if ($fault->slot != 0) {
			$hva = $fault->slot->userspace_addr +
			       (($fault->gfn - $fault->slot->base_gfn) << 12);
			$flags = $fault->slot->flags;
		}

		printf("%s tid[%u] pid[%u] FAULTIN_RET @ rip %lx (%lu hits), gpa = %lx, hva = %lx (%lx), flags = %lx, pfn = %lx, ret = %lu : MMU seq = %lx, in-prog = %lx, start = %lx, end = %lx\n",
		       strftime("%H:%M:%S:%f", nsecs), tid, pid, @last_rip[tid], @same[tid],
		       $fault->addr, $hva, $fault->hva, $flags, $fault->pfn, retval,
		       $kvm->mmu_invalidate_seq, $kvm->mmu_invalidate_in_progress,
		       $kvm->mmu_invalidate_range_start, $kvm->mmu_invalidate_range_end);
	} else if (@same[tid] > 1000 && @same[tid] < 100000) {
		printf("%s tid[%u] pid[%u] FAULTIN_ERROR @ rip %lx (%lu hits), ret = %lu\n",
		       strftime("%H:%M:%S:%f", nsecs), tid, pid,  @last_rip[tid], @same[tid], retval);
	}
}

kprobe:kvm_tdp_mmu_map
{
	$vcpu = (struct kvm_vcpu *)arg0;
	$rip = $vcpu->arch.regs[16];

	if (@last_rip[tid] == $rip) {
		@same[tid]++
	} else {
		@same[tid] = 0;
	}
	@last_rip[tid] = $rip;

	if (@__fault[tid] != 0) {
	        $vcpu = (struct kvm_vcpu *)arg0;
		$fault = (struct kvm_page_fault *)arg1;

                if (@__vcpu[tid] != arg0 || @__fault[tid] != arg1) {
                        printf("%s tid[%u] pid[%u] MAP_ERROR vcpu %lx vs. %lx, fault %lx vs. %lx\n",
                               strftime("%H:%M:%S:%f", nsecs), tid, pid, @__vcpu[tid], arg0, @__fault[tid], arg1);
                }

		printf("%s tid[%u] pid[%u] MAP @ rip %lx (%lu hits), gpa = %lx, hva = %lx, pfn = %lx\n",
		       strftime("%H:%M:%S:%f", nsecs), tid, pid, @last_rip[tid], @same[tid],
		       $fault->addr, $fault->hva, $fault->pfn);
	} else {
		@__vcpu[tid] = 0;
		@__fault[tid] = 0;
	}
}

kretprobe:kvm_tdp_mmu_map
{
	if (@__fault[tid] != 0) {
		$vcpu = (struct kvm_vcpu *)@__vcpu[tid];
		$fault = (struct kvm_page_fault *)@__fault[tid];
		$hva = -1;
		$flags = 0;

		if ($fault->slot != 0) {
			$hva = $fault->slot->userspace_addr +
			       (($fault->gfn - $fault->slot->base_gfn) << 12);
			$flags = $fault->slot->flags;
		}

		printf("%s tid[%u] pid[%u] MAP_RET @ rip %lx (%lu hits), gpa = %lx, hva = %lx, pfn = %lx, ret = %lx\n",
		       strftime("%H:%M:%S:%f", nsecs), tid, pid, @last_rip[tid], @same[tid],
		       $fault->addr, $fault->hva, $fault->pfn, retval);
	} else if (@same[tid] > 1000 && @same[tid] < 100000) {
		printf("%s tid[%u] pid[%u] MAP_RET_ERROR @ rip %lx (%lu hits), ret = %lu\n",
		       strftime("%H:%M:%S:%f", nsecs), tid, pid,  @last_rip[tid], @same[tid], retval);
	}
}

kprobe:tdp_iter_start
{
	if (@__fault[tid] != 0) {
                $vcpu = (struct kvm_vcpu *)@__vcpu[tid];
		$fault = (struct kvm_page_fault *)@__fault[tid];
	        $root = (struct kvm_mmu_page *)arg1;

		printf("%s tid[%u] pid[%u] ITER @ rip %lx (%lu hits), gpa = %lx (%lx), hva = %lx, pfn = %lx, tdp_mmu = %u, role = %x, count = %d\n",
		       strftime("%H:%M:%S:%f", nsecs), tid, pid, @last_rip[tid], @same[tid],
		       $fault->addr, arg3 << 12, $fault->hva, $fault->pfn,
                       $root->tdp_mmu_page, $root->role, $root->root_count);
	} else {
		@__vcpu[tid] = 0;
		@__fault[tid] = 0;
	}
}

kprobe:make_mmio_spte
{
        if (@__fault[tid] != 0) {
		$fault = (struct kvm_page_fault *)@__fault[tid];

		printf("%s tid[%u] pid[%u] MMIO @ rip %lx (%lu hits), gpa = %lx, hva = %lx, pfn = %lx\n",
		       strftime("%H:%M:%S:%f", nsecs), tid, pid, @last_rip[tid], @same[tid],
		       $fault->addr, $fault->hva, $fault->pfn);
	} else if (@same[tid] > 1000 && @same[tid] < 100000) {
		printf("%s tid[%u] pid[%u] MMIO_ERROR @ rip %lx (%lu hits)\n",
		       strftime("%H:%M:%S:%f", nsecs), tid, pid,  @last_rip[tid], @same[tid]);
	}
}

kprobe:make_spte
{
        if (@__fault[tid] != 0) {
		$fault = (struct kvm_page_fault *)@__fault[tid];

		printf("%s tid[%u] pid[%u] SPTE @ rip %lx (%lu hits), gpa = %lx, hva = %lx, pfn = %lx\n",
		       strftime("%H:%M:%S:%f", nsecs), tid, pid, @last_rip[tid], @same[tid],
		       $fault->addr, $fault->hva, $fault->pfn);
	} else if (@same[tid] > 1000 && @same[tid] < 100000) {
		printf("%s tid[%u] pid[%u] SPTE_ERROR @ rip %lx (%lu hits)\n",
		       strftime("%H:%M:%S:%f", nsecs), tid, pid,  @last_rip[tid], @same[tid]);
	}
}


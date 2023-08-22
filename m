Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0AF783739
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 03:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbjHVBKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 21:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjHVBKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 21:10:48 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F07D13D
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 18:10:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 47FF684;
        Mon, 21 Aug 2023 18:10:45 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id azJDirYp01Zu; Mon, 21 Aug 2023 18:10:41 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id CCA0239;
        Mon, 21 Aug 2023 18:10:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net CCA0239
Date:   Mon, 21 Aug 2023 18:10:40 -0700 (PDT)
From:   Eric Wheeler <kvm@lists.ewheeler.net>
To:     Sean Christopherson <seanjc@google.com>
cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Subject: Re: Deadlock due to EPT_VIOLATION
In-Reply-To: <ZOP4lwiMU2Uf89eQ@google.com>
Message-ID: <468b1298-e43e-2397-5f3-4b6af6e2f461@ewheeler.net>
References: <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com> <ZNJ2V2vRXckMwPX2@google.com> <c412929a-14ae-2e1-480-418c8d91368a@ewheeler.net> <ZNujhuG++dMbCp6Z@google.com> <5e678d57-66b-a18d-f97e-b41357fdb7f@ewheeler.net> <ZN5lD5Ro9LVgTA6M@google.com>
 <3ee6ddd4-74ad-9660-e3e5-a420a089ea54@ewheeler.net> <ZN+BRjUxouKiDSbx@google.com> <418345e5-a3e5-6e8d-395a-f5551ea13e2@ewheeler.net> <5fc6cea-9f51-582c-8bb3-21e0b4bf397@ewheeler.net> <ZOP4lwiMU2Uf89eQ@google.com>
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

On Mon, 21 Aug 2023, Sean Christopherson wrote:
> On Mon, Aug 21, 2023, Eric Wheeler wrote:
> > On Fri, 18 Aug 2023, Eric Wheeler wrote:
> > > On Fri, 18 Aug 2023, Sean Christopherson wrote:
> > > > On Thu, Aug 17, 2023, Eric Wheeler wrote:
> > > > > On Thu, 17 Aug 2023, Sean Christopherson wrote:
> > > > > > > > kprobe:handle_ept_violation
> > > > > > > > {
> > > > > > > > 	printf("vcpu = %lx pid = %u MMU seq = %lx, in-prog = %lx, start = %lx, end = %lx\n",
> > > > > > > > 	       arg0, ((struct kvm_vcpu *)arg0)->pid->numbers[0].nr,
> > > > > > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_seq,
> > > > > > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_in_progress,
> > > > > > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_start,
> > > > > > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_end);
> > > > > > > > }
> > > > > > > > 
> > > > > > > > If you don't have BTF info, we can still use a bpf program, but to get at the
> > > > > > > > fields of interested, I think we'd have to resort to pointer arithmetic with struct
> > > > > > > > offsets grab from your build.
> > > > > > > 
> > > > > > > We have BTF, so hurray for not needing struct offsets!
> > 
> > We found a new sample in 6.1.38, right after a lockup, where _all_ log 
> > entries show inprog=1, in case that is interesting. Here is a sample, 
> > there are 500,000+ entries so let me know if you want the whole log.
> > 
> > To me, these are opaque numbers.  What do they represent?  What are you looking for in them?
> 
> inprog is '1' if there is an in-progress mmu_notifier invalidation at the time
> of the EPT violation.  start/end are the range that is being invalidated _if_
> there is an in-progress invalidation.  If a vCPU were stuck with inprog=1, then
> the most likely scenario is that there's an unpaired invalidation, i.e. something
> started an invalidation but never completed it.
> 
> seq is a sequence count that is incremented when an invalidation completes, e.g.
> if a vCPU was stuck and seq were constantly changing, then it would mean that
> the primary MMU is invalidating the same range over and over so quickly that the
> vCPU can't make forward progress.

Here is another one, I think you described exactly this: the vcpu is 
always the same, and the sequence increments, forever:

      1 ept[0] vcpu=ffff9964cdc48000 seq=80854227 inprog=1 start=7fa3183a3000 end=7fa3183a4000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854228 inprog=1 start=7fa3183a3000 end=7fa3183a4000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854229 inprog=1 start=7fa3183a4000 end=7fa3183a5000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085422a inprog=1 start=7fa3183a4000 end=7fa3183a5000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085422b inprog=1 start=7fa3183a8000 end=7fa3183a9000
      2 ept[0] vcpu=ffff9964cdc48000 seq=8085422d inprog=1 start=7fa3183a9000 end=7fa3183aa000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085422e inprog=1 start=7fa3183a9000 end=7fa3183aa000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854232 inprog=1 start=7fa3183ac000 end=7fa3183ad000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854233 inprog=1 start=7fa3183ad000 end=7fa3183ae000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854235 inprog=1 start=7fa3183ae000 end=7fa3183af000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854236 inprog=1 start=7fa3183ae000 end=7fa3183af000

Here is the whole log with 500,000+ lines over 5 minutes of recording, it 
was first stuck on one vcpu for most of the time, and toward the end it 
was stuck on a different VCPU:

The file starts with 555,596 occurances of vcpu=ffff9964cdc48000 and is 
then followed by 31,784 occurances of vcpu=ffff9934ed50c680.  As you can 
see in the file, they are not interleaved:

	https://www.linuxglobal.com/out/handle_ept_violation.log2

  # awk '{print $3}' handle_ept_violation.log2 |uniq -c
   555596 vcpu=ffff9964cdc48000
    31784 vcpu=ffff9934ed50c680

> Below is another bpftrace program that will hopefully shrink the 
> haystack to the point where we can find something via code inspection.

Ok thanks, we'll give it a try.

> Just a heads up, if we don't find a smoking gun, I likely won't be able 
> to help beyond high level guidance as we're approaching what I can do 
> with bpftrace without a significant time investment (which I can't 
> make).

I understand, I'm grateful for your help, whatever you can offer.

-Eric

> 
> ---
> struct kvm_page_fault {
> 	const gpa_t addr;
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
> 	gfn_t gfn;
> 
> 	struct kvm_memory_slot *slot;
> 
> 	kvm_pfn_t pfn;
> 	unsigned long hva;
> 	bool map_writable;
> };
> 
> kprobe:handle_ept_violation
> {
> 	$vcpu = (struct kvm_vcpu *)arg0;
> 	$nr_handled = $vcpu->stat.pf_emulate + $vcpu->stat.pf_fixed + $vcpu->stat.pf_spurious;
> 
> 	if (($vcpu->stat.pf_taken / 5) > $nr_handled) {
> 		printf("PID = %u stuck, taken = %lu, emulated = %lu, fixed = %lu, spurious = %lu\n",
> 		       pid, $vcpu->stat.pf_taken, $vcpu->stat.pf_emulate, $vcpu->stat.pf_fixed, $vcpu->stat.pf_spurious);
> 	}
> }
> 
> kprobe:kvm_faultin_pfn
> {
> 	$vcpu = (struct kvm_vcpu *)arg0;
> 	$nr_handled = $vcpu->stat.pf_emulate + $vcpu->stat.pf_fixed + $vcpu->stat.pf_spurious;
> 
> 	if (($vcpu->stat.pf_taken / 5) > $nr_handled) {
> 		$fault = (struct kvm_page_fault *)arg1;
> 		$flags = 0;
> 
> 		if ($fault->slot != 0) {
> 			$flags = $fault->slot->flags;
> 		}
> 
> 		printf("PID = %u stuck, reached kvm_faultin_pfn(), slot = %lx, flags = %lx\n",
> 		       pid, arg1, $flags);
> 	}
> }
> 
> kprobe:make_mmio_spte
> {
> 	$vcpu = (struct kvm_vcpu *)arg0;
> 	$nr_handled = $vcpu->stat.pf_emulate + $vcpu->stat.pf_fixed + $vcpu->stat.pf_spurious;
> 
> 	if (($vcpu->stat.pf_taken / 5) > $nr_handled) {
> 		printf("PID %u stuck, reached make_mmio_spte()", pid);
> 	}
> }
> 
> kprobe:make_spte
> {
> 	$vcpu = (struct kvm_vcpu *)arg0;
> 	$nr_handled = $vcpu->stat.pf_emulate + $vcpu->stat.pf_fixed + $vcpu->stat.pf_spurious;
> 
> 	if (($vcpu->stat.pf_taken / 5) > $nr_handled) {
> 		printf("PID %u stuck, reached make_spte()", pid);
> 	}
> }
> 
> 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17776786339
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 00:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbjHWWNA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 18:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238569AbjHWWMf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 18:12:35 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD14BE6D
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 15:12:31 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 79C1346;
        Wed, 23 Aug 2023 15:12:31 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id tyXQ5nrzn456; Wed, 23 Aug 2023 15:12:27 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id EF7F647;
        Wed, 23 Aug 2023 15:12:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net EF7F647
Date:   Wed, 23 Aug 2023 15:12:26 -0700 (PDT)
From:   Eric Wheeler <kvm@lists.ewheeler.net>
To:     Sean Christopherson <seanjc@google.com>
cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Subject: Re: Deadlock due to EPT_VIOLATION
In-Reply-To: <ZOZH3xe0u4NHhvL8@google.com>
Message-ID: <db7c65b-6530-692-5e50-c74a7757f22@ewheeler.net>
References: <5e678d57-66b-a18d-f97e-b41357fdb7f@ewheeler.net> <ZN5lD5Ro9LVgTA6M@google.com> <3ee6ddd4-74ad-9660-e3e5-a420a089ea54@ewheeler.net> <ZN+BRjUxouKiDSbx@google.com> <418345e5-a3e5-6e8d-395a-f5551ea13e2@ewheeler.net> <5fc6cea-9f51-582c-8bb3-21e0b4bf397@ewheeler.net>
 <ZOP4lwiMU2Uf89eQ@google.com> <468b1298-e43e-2397-5f3-4b6af6e2f461@ewheeler.net> <ZOTQPUk5kxskDcsi@google.com> <58f24fa2-a5f4-c59a-2bcf-c49f7bddc5b@ewheeler.net> <ZOZH3xe0u4NHhvL8@google.com>
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

On Wed, 23 Aug 2023, Sean Christopherson wrote:
> On Tue, Aug 22, 2023, Eric Wheeler wrote:
> > On Tue, 22 Aug 2023, Sean Christopherson wrote:
> > > > Here is the whole log with 500,000+ lines over 5 minutes of recording, it 
> > > > was first stuck on one vcpu for most of the time, and toward the end it 
> > > > was stuck on a different VCPU:
> > > > 
> > > > The file starts with 555,596 occurances of vcpu=ffff9964cdc48000 and is 
> > > > then followed by 31,784 occurances of vcpu=ffff9934ed50c680.  As you can 
> > > > see in the file, they are not interleaved:
> > > > 
> > > > 	https://www.linuxglobal.com/out/handle_ept_violation.log2
> > > > 
> > > >   # awk '{print $3}' handle_ept_violation.log2 |uniq -c
> > > >    555596 vcpu=ffff9964cdc48000
> > > >     31784 vcpu=ffff9934ed50c680
> > > 
> > > Hrm, but the address range being invalidated is changing.  Without seeing the
> > > guest RIP, or even a timestamp, it's impossible to tell if the vCPU is well and
> > > truly stuck or if it's just getting thrashed so hard by NUMA balancing or KSM
> > > that it looks stuck.
> > > 
> > > Drat.
> > > 
> > > > > Below is another bpftrace program that will hopefully shrink the 
> > > > > haystack to the point where we can find something via code inspection.
> > > > 
> > > > Ok thanks, we'll give it a try.
> > > 
> > > Try this version instead.  It's more comprehensive and more precise, e.g. should
> > > only trigger on the guest being 100% stuck, and also fixes a PID vs. TID goof.
> > > 
> > > Note!  Enable trace_kvm_exit before/when running this to ensure KVM grabs the guest RIP
> > > from the VMCS.  Without that enabled, RIP from vcpu->arch.regs[16] may be stale.
> > 
> > Ok, we got a 740MB log, zips down to 25MB if you would like to see the
> > whole thing, it is here:
> > 	http://linuxglobal.com/out/handle_ept_violation-v2.log.gz
> > 
> > For brevity, here is a sample of each 100,000th line:
> > 
> > # zcat handle_ept_violation-v2.log.gz | perl -lne '!($n++%100000) && print'
> > Attaching 3 probes...
> > 00:30:31:347560 tid[553909] pid[553848] stuck @ rip ffffffff80094a41 (375972 hits), gpa = 294a41, hva = 7efc5b094000 : MMU seq = 8000b139, in-prog = 0, start = 7efc6e10f000, end = 7efc6e110000
> 
> Argh.  I'm having a bit of a temper tantrum because I forgot to have the printf
> spit out the memslot flags.  And I apparently gave you a version without a probe
> on kvm_tdp_mmu_map().  Grr.
> 
> Can you capture one more trace?  Fingers crossed this is the last one.  

Here it is: http://linuxglobal.com/out/handle_ept_violation-v3.log.gz

Here are the highlights:

# zcat handle_ept_violation-v3.log.gz | grep 3484173 | tail -n30
21:25:50:282711 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92234 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282714 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92235 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282720 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92237 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282723 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92238 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282726 tid[3484173] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (92239 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282743 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92245 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282749 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92247 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282752 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92248 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282755 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92249 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282769 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92254 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282775 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92256 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282778 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92257 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282784 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92259 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282804 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92266 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282813 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92269 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282816 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92270 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282822 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92272 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282825 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92273 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282831 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92275 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282837 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92277 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282845 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92280 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282854 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92283 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282857 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92284 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282863 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92286 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282866 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92287 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282869 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92288 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
@__fault[3484173]: 0
@__vcpu[3484173]: 0
@last_rip[3484173]: 18446744071583984805
@same[3484173]: 11615602


# zcat handle_ept_violation-v3.log.gz | grep 3484174 | tail -n30
21:25:50:282354 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90073 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282418 tid[3484174] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (90087 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282475 tid[3484174] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (90100 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282507 tid[3484174] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (90107 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282524 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90111 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282528 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90112 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282557 tid[3484174] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (90118 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282571 tid[3484174] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (90121 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282660 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90141 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282670 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90143 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282684 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90146 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282693 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90148 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282731 tid[3484174] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (90156 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282735 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90157 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282739 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90158 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282759 tid[3484174] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (90162 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282764 tid[3484174] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (90163 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282786 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90168 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282791 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90169 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282795 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90170 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282800 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90171 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282809 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90173 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282832 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90178 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282841 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90180 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282851 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90182 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
21:25:50:282874 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90187 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
@__fault[3484174]: 0
@__vcpu[3484174]: 0
@last_rip[3484174]: 18446744071583984805
@same[3484174]: 11598962


--
Eric Wheeler




> 
> On the plus side, I'm slowly learning how to effectively use bpf programs.
> This version also prints return values and and other relevant side effects from
> kvm_faultin_pfn(), and I figured out a way to get at the vCPU's root MMU page.
> 
> And it stops printing after a vCPU (task) has been stuck for 100k exits, i.e. it
> should self-limit the spam.  Even if the vCPU managed to unstick itself after
> that point, which is *extremely* unlikely, being stuck for 100k exits all but
> guarantees there's a bug somewhere.
> 
> So this *should* give us a smoking gun.  Depending on what the gun points at, a
> full root cause may still be a long ways off, but I'm pretty sure this mess will
> tell us exactly why KVM is refusing to fix the fault.
> 
> --
> 
> struct kvm_page_fault {
> 	const u64 addr;
> 	const u32 error_code;
> 
> 	const bool prefetch;
> 	const bool exec;
> 	const bool write;
> 	const bool present;
> 
> 	const bool rsvd;
> 	const bool user;
> 	const bool is_tdp;
> 	const bool nx_huge_page_workaround_enabled;
> 
> 	bool huge_page_disallowed;
> 
> 	u8 max_level;
> 	u8 req_level;
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
> struct kvm_mmu_page {
> 	struct list_head link;
> 	struct hlist_node hash_link;
> 
> 	bool tdp_mmu_page;
> 	bool unsync;
> 	u8 mmu_valid_gen;
> 	bool lpage_disallowed;
> 
> 	u32 role;
> 	u64 gfn;
> 
> 	u64 *spt;
> 
> 	u64 *shadowed_translation;
> 
> 	int root_count;
> }
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
> 	if (@same[tid] > 1000 && @same[tid] < 100000) {
> 		$fault = (struct kvm_page_fault *)arg1;
> 		$hva = -1;
> 		$flags = 0;
> 
> 		@__vcpu[tid] = arg0;
> 		@__fault[tid] = arg1;
> 
> 		if ($fault->slot != 0) {
> 			$hva = $fault->slot->userspace_addr +
> 			       (($fault->gfn - $fault->slot->base_gfn) << 12);
> 			$flags = $fault->slot->flags;
> 		}
> 
> 		printf("%s tid[%u] pid[%u] FAULTIN @ rip %lx (%lu hits), gpa = %lx, hva = %lx, flags = %lx : MMU seq = %lx, in-prog = %lx, start = %lx, end = %lx\n",
> 		       strftime("%H:%M:%S:%f", nsecs), tid, pid, $rip, @same[tid], $fault->addr, $hva, $flags,
> 		       $kvm->mmu_invalidate_seq, $kvm->mmu_invalidate_in_progress,
> 		       $kvm->mmu_invalidate_range_start, $kvm->mmu_invalidate_range_end);
> 	} else {
> 		@__vcpu[tid] = 0;
> 		@__fault[tid] = 0;
> 	}
> }
> 
> kretprobe:kvm_faultin_pfn
> {
> 	if (@__fault[tid] != 0) {
> 		$vcpu = (struct kvm_vcpu *)@__vcpu[tid];
> 		$kvm = $vcpu->kvm;
> 		$fault = (struct kvm_page_fault *)@__fault[tid];
> 		$hva = -1;
> 		$flags = 0;
> 
> 		if ($fault->slot != 0) {
> 			$hva = $fault->slot->userspace_addr +
> 			       (($fault->gfn - $fault->slot->base_gfn) << 12);
> 			$flags = $fault->slot->flags;
> 		}
> 
> 		printf("%s tid[%u] pid[%u] FAULTIN_RET @ rip %lx (%lu hits), gpa = %lx, hva = %lx (%lx), flags = %lx, pfn = %lx, ret = %lu : MMU seq = %lx, in-prog = %lx, start = %lx, end = %lx\n",
> 		       strftime("%H:%M:%S:%f", nsecs), tid, pid, @last_rip[tid], @same[tid],
> 		       $fault->addr, $hva, $fault->hva, $flags, $fault->pfn, retval,
> 		       $kvm->mmu_invalidate_seq, $kvm->mmu_invalidate_in_progress,
> 		       $kvm->mmu_invalidate_range_start, $kvm->mmu_invalidate_range_end);
> 	} else if (@same[tid] > 1000 && @same[tid] < 100000) {
> 		printf("%s tid[%u] pid[%u] FAULTIN_ERROR @ rip %lx (%lu hits), ret = %lu\n",
> 		       strftime("%H:%M:%S:%f", nsecs), tid, pid,  @last_rip[tid], @same[tid], retval);
> 	}
> }
> 
> kprobe:kvm_tdp_mmu_map
> {
> 	$vcpu = (struct kvm_vcpu *)arg0;
> 	$rip = $vcpu->arch.regs[16];
> 
> 	if (@last_rip[tid] == $rip) {
> 		@same[tid]++
> 	} else {
> 		@same[tid] = 0;
> 	}
> 	@last_rip[tid] = $rip;
> 
> 	if (@__fault[tid] != 0) {
> 	        $vcpu = (struct kvm_vcpu *)arg0;
> 		$fault = (struct kvm_page_fault *)arg1;
> 
>                 if (@__vcpu[tid] != arg0 || @__fault[tid] != arg1) {
>                         printf("%s tid[%u] pid[%u] MAP_ERROR vcpu %lx vs. %lx, fault %lx vs. %lx\n",
>                                strftime("%H:%M:%S:%f", nsecs), tid, pid, @__vcpu[tid], arg0, @__fault[tid], arg1);
>                 }
> 
> 		printf("%s tid[%u] pid[%u] MAP @ rip %lx (%lu hits), gpa = %lx, hva = %lx, pfn = %lx\n",
> 		       strftime("%H:%M:%S:%f", nsecs), tid, pid, @last_rip[tid], @same[tid],
> 		       $fault->addr, $fault->hva, $fault->pfn);
> 	} else {
> 		@__vcpu[tid] = 0;
> 		@__fault[tid] = 0;
> 	}
> }
> 
> kretprobe:kvm_tdp_mmu_map
> {
> 	if (@__fault[tid] != 0) {
> 		$vcpu = (struct kvm_vcpu *)@__vcpu[tid];
> 		$fault = (struct kvm_page_fault *)@__fault[tid];
> 		$hva = -1;
> 		$flags = 0;
> 
> 		if ($fault->slot != 0) {
> 			$hva = $fault->slot->userspace_addr +
> 			       (($fault->gfn - $fault->slot->base_gfn) << 12);
> 			$flags = $fault->slot->flags;
> 		}
> 
> 		printf("%s tid[%u] pid[%u] MAP_RET @ rip %lx (%lu hits), gpa = %lx, hva = %lx, pfn = %lx, ret = %lx\n",
> 		       strftime("%H:%M:%S:%f", nsecs), tid, pid, @last_rip[tid], @same[tid],
> 		       $fault->addr, $fault->hva, $fault->pfn, retval);
> 	} else if (@same[tid] > 1000 && @same[tid] < 100000) {
> 		printf("%s tid[%u] pid[%u] MAP_RET_ERROR @ rip %lx (%lu hits), ret = %lu\n",
> 		       strftime("%H:%M:%S:%f", nsecs), tid, pid,  @last_rip[tid], @same[tid], retval);
> 	}
> }
> 
> kprobe:tdp_iter_start
> {
> 	if (@__fault[tid] != 0) {
>                 $vcpu = (struct kvm_vcpu *)@__vcpu[tid];
> 		$fault = (struct kvm_page_fault *)@__fault[tid];
> 	        $root = (struct kvm_mmu_page *)arg1;
> 
> 		printf("%s tid[%u] pid[%u] ITER @ rip %lx (%lu hits), gpa = %lx (%lx), hva = %lx, pfn = %lx, tdp_mmu = %u, role = %x, count = %d\n",
> 		       strftime("%H:%M:%S:%f", nsecs), tid, pid, @last_rip[tid], @same[tid],
> 		       $fault->addr, arg3 << 12, $fault->hva, $fault->pfn,
>                        $root->tdp_mmu_page, $root->role, $root->root_count);
> 	} else {
> 		@__vcpu[tid] = 0;
> 		@__fault[tid] = 0;
> 	}
> }
> 
> kprobe:make_mmio_spte
> {
>         if (@__fault[tid] != 0) {
> 		$fault = (struct kvm_page_fault *)@__fault[tid];
> 
> 		printf("%s tid[%u] pid[%u] MMIO @ rip %lx (%lu hits), gpa = %lx, hva = %lx, pfn = %lx\n",
> 		       strftime("%H:%M:%S:%f", nsecs), tid, pid, @last_rip[tid], @same[tid],
> 		       $fault->addr, $fault->hva, $fault->pfn);
> 	} else if (@same[tid] > 1000 && @same[tid] < 100000) {
> 		printf("%s tid[%u] pid[%u] MMIO_ERROR @ rip %lx (%lu hits)\n",
> 		       strftime("%H:%M:%S:%f", nsecs), tid, pid,  @last_rip[tid], @same[tid]);
> 	}
> }
> 
> kprobe:make_spte
> {
>         if (@__fault[tid] != 0) {
> 		$fault = (struct kvm_page_fault *)@__fault[tid];
> 
> 		printf("%s tid[%u] pid[%u] SPTE @ rip %lx (%lu hits), gpa = %lx, hva = %lx, pfn = %lx\n",
> 		       strftime("%H:%M:%S:%f", nsecs), tid, pid, @last_rip[tid], @same[tid],
> 		       $fault->addr, $fault->hva, $fault->pfn);
> 	} else if (@same[tid] > 1000 && @same[tid] < 100000) {
> 		printf("%s tid[%u] pid[%u] SPTE_ERROR @ rip %lx (%lu hits)\n",
> 		       strftime("%H:%M:%S:%f", nsecs), tid, pid,  @last_rip[tid], @same[tid]);
> 	}
> }
> 
> 

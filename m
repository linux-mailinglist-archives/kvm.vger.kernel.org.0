Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF66FD7C4D
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388268AbfJOQtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:49:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40666 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfJOQtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:49:55 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D7ED7882FB;
        Tue, 15 Oct 2019 16:49:54 +0000 (UTC)
Received: from mail (ovpn-124-232.rdu2.redhat.com [10.10.124.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E4616031D;
        Tue, 15 Oct 2019 16:49:53 +0000 (UTC)
Date:   Tue, 15 Oct 2019 12:49:52 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 12/14] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20191015164952.GE331@redhat.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
 <20190928172323.14663-13-aarcange@redhat.com>
 <933ca564-973d-645e-fe9c-9afb64edba5b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <933ca564-973d-645e-fe9c-9afb64edba5b@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 15 Oct 2019 16:49:54 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 15, 2019 at 10:28:39AM +0200, Paolo Bonzini wrote:
> If you're including EXIT_REASON_EPT_MISCONFIG (MMIO access) then you
> should include EXIT_REASON_IO_INSTRUCTION too.  Depending on the devices
> that are in the guest, the doorbell register might be MMIO or PIO.

The fact outb/inb devices exists isn't the question here. The question
you should clarify is: which of the PIO devices is performance
critical as much as MMIO with virtio/vhost? I mean even on real
hardware those devices aren't performance critical. I didn't run into
PIO drivers with properly configured guests.

> So, the difference between my suggested list (which I admit is just
> based on conjecture, not benchmarking) is that you add
> EXIT_REASON_PAUSE_INSTRUCTION, EXIT_REASON_PENDING_INTERRUPT,
> EXIT_REASON_EXTERNAL_INTERRUPT, EXIT_REASON_HLT, EXIT_REASON_MSR_READ,
> EXIT_REASON_CPUID.
> 
> Which of these make a difference for the hrtimer testcase?  It's of
> course totally fine to use benchmarks to prove that my intuition was
> bad---but you must also use them to show why your intuition is right. :)

The hrtimer flood hits on this:

           MSR_WRITE     338793    56.54%     5.51%      0.33us     34.44us      0.44us ( +-   0.20% )
   PENDING_INTERRUPT     168431    28.11%     2.52%      0.36us     32.06us      0.40us ( +-   0.28% )
    PREEMPTION_TIMER      91723    15.31%     1.32%      0.34us     30.51us      0.39us ( +-   0.41% )
  EXTERNAL_INTERRUPT        234     0.04%     0.00%      0.25us      5.53us      0.43us ( +-   5.67% )
                 HLT         65     0.01%    90.64%      0.49us 319933.79us  37562.71us ( +-  21.68% )
            MSR_READ          6     0.00%     0.00%      0.67us      1.96us      1.06us ( +-  17.97% )
       EPT_MISCONFIG          6     0.00%     0.01%      3.09us    105.50us     26.76us ( +-  62.10% )

PENDING_INTERRUPT is the big missing thing in your list. It probably
accounts for the bulk of slowdown from your list.  However I could
imagine other loads with higher external interrupt/hlt/rdmsr than the
hrtimer one so I didn't drop those. Other loads are hitting on a flood
of HLT and from host standpoint it's no a slow path. Not all OS have
the cpuidle haltpoll governor to mitigate the HLT frequency.

I'm pretty sure HLT/EXTERNAL_INTERRUPT/PENDING_INTERRUPT should be
included.

The least useful are PAUSE, CPUID and MSR_READ, we could considering
dropping some of those (in the short term cpuid helps for benchmarking
to more accurately measure the performance improvement of not hitting
the retpoline there). I simply could imagine some load hitting
frequently on those too so I didn't drop them.

I also wonder if VMCALL should be added, certain loads hit on fairly
frequent VMCALL, but none of the one I benchmarked.

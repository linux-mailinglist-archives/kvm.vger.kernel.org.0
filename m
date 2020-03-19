Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE0A18BE29
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 18:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbgCSRfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 13:35:52 -0400
Received: from mga07.intel.com ([134.134.136.100]:38076 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgCSRfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 13:35:52 -0400
IronPort-SDR: zyXWx5Wl2Y8lB5eL3mQ/XOJbqzfJ+dVXNo9v3b6GP/k4QWvp2ZVjyaY2F/xRmUgRRq9Co6MV+Q
 RSUU4KEU8eag==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 10:35:50 -0700
IronPort-SDR: U25Y8QeKwZcBeM3tJy8sVucZGXnY815ZafwzO0n2oFiMwoWvN++K31m1yI6pQ20ljIaL57topA
 JHLen4SEe5BQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,572,1574150400"; 
   d="scan'208";a="444655601"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 19 Mar 2020 10:35:49 -0700
Date:   Thu, 19 Mar 2020 10:35:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     syzbot <syzbot+00be5da1d75f1cc95f6b@syzkaller.appspotmail.com>,
        bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, rkrcmar@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Subject: Re: WARNING in vcpu_enter_guest
Message-ID: <20200319173549.GC11305@linux.intel.com>
References: <000000000000f965b8059877e5e6@google.com>
 <00000000000081861f05a132b9cd@google.com>
 <20200319144952.GB11305@linux.intel.com>
 <20be9560-fce7-1495-3a83-e2b56dbc2389@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20be9560-fce7-1495-3a83-e2b56dbc2389@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 04:14:55PM +0100, Paolo Bonzini wrote:
> On 19/03/20 15:49, Sean Christopherson wrote:
> > On Thu, Mar 19, 2020 at 03:35:16AM -0700, syzbot wrote:
> >> syzbot has found a reproducer for the following crash on:
> >>
> >> HEAD commit:    5076190d mm: slub: be more careful about the double cmpxch..
> >> git tree:       upstream
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=143ca61de00000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=9f894bd92023de02
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=00be5da1d75f1cc95f6b
> >> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10bb4023e00000
> >>
> >> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> >> Reported-by: syzbot+00be5da1d75f1cc95f6b@syzkaller.appspotmail.com
> > Reproduced with a little tweaking of the reproducer, debug in progress.
> > 
> 
> I think the WARN_ON at x86.c:2447 is just bogus.  You can always get it
> to trigger if garbage is passed to KVM_SET_CLOCK.

Yep.  I worked through logic/math, mostly to gain a wee bit of knowledge
about the clock stuff, and it's sound.  The KVM_SET_CLOCK from syzkaller
is simply making time go backwards.

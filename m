Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B227D8EFF6
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731052AbfHOQAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:00:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:63630 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730298AbfHOQAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:00:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 09:00:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,389,1559545200"; 
   d="scan'208";a="376420449"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 15 Aug 2019 09:00:06 -0700
Date:   Thu, 15 Aug 2019 09:00:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190815160006.GC27076@linux.intel.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
 <20190205210137.1377-11-sean.j.christopherson@intel.com>
 <20190813100458.70b7d82d@x1.home>
 <20190813170440.GC13991@linux.intel.com>
 <20190813115737.5db7d815@x1.home>
 <20190813133316.6fc6f257@x1.home>
 <20190813201914.GI13991@linux.intel.com>
 <20190815092324.46bb3ac1@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815092324.46bb3ac1@x1.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 15, 2019 at 09:23:24AM -0600, Alex Williamson wrote:
> Ok, fun day of trying to figure out which ranges are relevant, I've
> narrowed it down to all of these:
> 
> 0xffe00
> 0xfee00
> 0xfec00

APIC and I/O APIC stuff

> 0xc1000

Assigned audio

> 0x80a000

?

> 0x800000

GPU BAR

> 0x100000

?

The APIC ranges are puzzling, I wouldn't expect their mappings to change.

> ie. I can effective only say that sp->gfn values of 0x0, 0x40000, and
> 0x80000 can take the continue branch without seeing bad behavior in the
> VM.
> 
> The assigned GPU has BARs at GPAs:
> 
> 0xc0000000-0xc0ffffff
> 0x800000000-0x808000000
> 0x808000000-0x809ffffff
> 
> And the assigned companion audio function is at GPA:
> 
> 0xc1080000-0xc1083fff
> 
> Only one of those seems to align very well with a gfn base involved
> here.  The virtio ethernet has an mmio range at GPA 0x80a000000,
> otherwise I don't find any other I/O devices coincident with the gfns
> above.
> 
> I'm running the VM with 2MB hugepages, but I believe the issue still
> occurs with standard pages.  When run with standard pages I see more
> hits to gfn values 0, 0x40000, 0x80000, but the same number of hits to
> the set above that cannot take the continue branch.  I don't know if
> that means anything.
> 
> Any further ideas what to look for?  Thanks,

Maybe try isolating which memslot removal causes problems?  E.g. flush
the affected ranges if base_gfn == (xxx || yyy || zzz), otherwise flush
only the memslot's gfns.  Based on the log you sent a while back for gfn
mismatches, I'm guessing the culprits are all GPU BARs, but it's
probably worth confirming.  That might also explain why gfn == 0x80000
can take the continue branch, i.e. if removing the corresponding memslot
is what's causing problems, then it's being flushed and not actually
taking the continue path.

One other thought would be to force a call to kvm_flush_remote_tlbs(kvm),
e.g. set flush=true just before the final kvm_mmu_remote_flush_or_zap().
Maybe it's a case where there are no SPTEs for the memslot, but the TLB
flush is needed for some reason.

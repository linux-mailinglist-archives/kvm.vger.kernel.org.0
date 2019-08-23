Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8669A56D
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 04:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388641AbfHWCZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 22:25:03 -0400
Received: from mga14.intel.com ([192.55.52.115]:50237 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729716AbfHWCZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 22:25:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 19:25:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="181581227"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 22 Aug 2019 19:25:02 -0700
Date:   Thu, 22 Aug 2019 19:25:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190823022502.GA4525@linux.intel.com>
References: <20190813133316.6fc6f257@x1.home>
 <20190813201914.GI13991@linux.intel.com>
 <20190815092324.46bb3ac1@x1.home>
 <a05b07d8-343b-3f3d-4262-f6562ce648f2@redhat.com>
 <20190820200318.GA15808@linux.intel.com>
 <20190820144204.161f49e0@x1.home>
 <20190820210245.GC15808@linux.intel.com>
 <20190821130859.4330bcf4@x1.home>
 <20190821133504.79b87767@x1.home>
 <20190821203041.GJ29345@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821203041.GJ29345@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 21, 2019 at 01:30:41PM -0700, Sean Christopherson wrote:
> On Wed, Aug 21, 2019 at 01:35:04PM -0600, Alex Williamson wrote:
> > On Wed, 21 Aug 2019 13:08:59 -0600
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> > > Does this suggests something is still fundamentally wrong with the
> > > premise of this change or have I done something stupid?
> > 
> > Seems the latter, particularly your comment that we're looking for
> > pages pointing to the gfn range to be removed, not just those in the
> > range.  Slot gfn ranges like ffe00-ffe1f are getting reduced to 0-0 or
> > c0000-c0000, zapping zero or c0000, and I think one of the ones you
> > were looking for c1080-c1083 is reduce to c1000-c1000 and therefore
> > zaps sp->gfn c1000.  I'll keep looking.  Thanks,
> 
> Ya.  As far as where to look, at this point I don't think it's an issue of
> incorrect zapping.  Not because  I'm 100% confident the zapping logic is
> correct, but because many of the tests, e.g. removing 'sp->gfn != gfn' and
> not being able to exclude APIC/IOAPIC ranges, suggest that the badness is
> 'fixed' by zapping seemingly unrelated sps.
> 
> In other words, it may be fundamentally wrong to zap only the memslot
> being removed, but I really want to know why.  History isn't helpful as
> KVM has always zapped all pages when removing a memslot (on x86), and the
> introduction of the per-memslot flush hook in commit
> 
>   2df72e9bc4c5 ("KVM: split kvm_arch_flush_shadow")
> 
> was all about refactoring generic code, and doesn't have any information
> on whether per-memslot flushing was actually tried for x86.

One semi-random idea would be to zap mmio pages, i.e. don't skip pages
for which sp->mmio_cached is true, regardless of their gfn or level.  I
don't expect it to make a difference, but it would shrink the haystack on
the off change it does "fix" the issues.

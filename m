Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1751C7E20
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 01:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgEFXrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 19:47:47 -0400
Received: from mga04.intel.com ([192.55.52.120]:59741 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgEFXrr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 19:47:47 -0400
IronPort-SDR: iAmViCGcscekFeNzGDm+G/qkXkM+ivZefd36SQvtYJ1J3APNVqiTm4P5oJzzTvOjQean0xgObI
 zEjOFlhCKP9Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 16:47:46 -0700
IronPort-SDR: beRTOGuFv6QSTNeNoRQ86XR/js8gaxc/d6LQ0N1Z+zLsHMbwxrRp3l1lwLYMRKstTQaaCeapcv
 xqwywBwVDJfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,361,1583222400"; 
   d="scan'208";a="249928462"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 06 May 2020 16:47:46 -0700
Date:   Wed, 6 May 2020 16:47:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 8/9] KVM: x86, SVM: do not clobber guest DR6 on
 KVM_EXIT_DEBUG
Message-ID: <20200506234746.GN3329@linux.intel.com>
References: <20200506111034.11756-1-pbonzini@redhat.com>
 <20200506111034.11756-9-pbonzini@redhat.com>
 <20200506181515.GR6299@xz-x1>
 <8f7f319c-4093-0ddc-f9f5-002c41d5622c@redhat.com>
 <20200506211356.GD228260@xz-x1>
 <20200506212047.GI3329@linux.intel.com>
 <20200506233306.GE228260@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200506233306.GE228260@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 07:33:06PM -0400, Peter Xu wrote:
> On Wed, May 06, 2020 at 02:20:47PM -0700, Sean Christopherson wrote:
> > On Wed, May 06, 2020 at 05:13:56PM -0400, Peter Xu wrote:
> > > Oh... so is dr6 going to have some leftover bit set in the GD test if without
> > > this patch for AMD?  Btw, I noticed a small difference on Intel/AMD spec for
> > > this case, e.g., B[0-3] definitions on such leftover bits...
> > > 
> > > Intel says:
> > > 
> > >         B0 through B3 (breakpoint condition detected) flags (bits 0 through 3)
> > >         — Indicates (when set) that its associated breakpoint condition was met
> > >         when a debug exception was generated. These flags are set if the
> > >         condition described for each breakpoint by the LENn, and R/Wn flags in
> > >         debug control register DR7 is true. They may or may not be set if the
> > >         breakpoint is not enabled by the Ln or the Gn flags in register
> > >         DR7. Therefore on a #DB, a debug handler should check only those B0-B3
> > >         bits which correspond to an enabled breakpoint.
> > > 
> > > AMD says:
> > > 
> > >         Breakpoint-Condition Detected (B3–B0)—Bits 3:0. The processor updates
> > >         these four bits on every debug breakpoint or general-detect
> > >         condition. A bit is set to 1 if the corresponding address- breakpoint
> > >         register detects an enabled breakpoint condition, as specified by the
> > >         DR7 Ln, Gn, R/Wn and LENn controls, and is cleared to 0 otherwise. For
> > >         example, B1 (bit 1) is set to 1 if an address- breakpoint condition is
> > >         detected by DR1.
> > > 
> > > I'm not sure whether it means AMD B[0-3] bits are more strict on the Intel ones
> > > (if so, then the selftest could be a bit too strict to VMX).
> > 
> > If the question is "can DR6 bits 3:0 be set on Intel CPUs even if the
> > associated breakpoint is disabled?", then the answer is yes.  I haven't
> > looked at the selftest, but if it's checking DR6 then it should ignore
> > bits corresponding to disabled breakpoints.
> 
> Currently the selftest will also check that the B[0-3] is cleared when specific
> BP is disabled.  We can loose that.  The thing is this same test can also run
> on AMD hosts, so logically on the other hand we should still check those bits
> as cleared to follow the AMD spec (and it never failed for me even on Intel..).

There still has to be an address and type match, e.g. if the DRs are
completely bogus in the selftest then the "cleard to zero" check is still
valid.  And if I'm reading the selftest code correctly, this is indeed the
case as only the DRn being tested is configured.

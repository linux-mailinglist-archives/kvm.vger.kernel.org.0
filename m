Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 901ED14AB5D
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 21:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgA0U4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 15:56:07 -0500
Received: from mga04.intel.com ([192.55.52.120]:8095 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgA0U4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 15:56:07 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jan 2020 12:56:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,371,1574150400"; 
   d="scan'208";a="217416903"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 27 Jan 2020 12:56:06 -0800
Date:   Mon, 27 Jan 2020 12:56:06 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
Message-ID: <20200127205606.GC2523@linux.intel.com>
References: <20191202204356.250357-1-aaronlewis@google.com>
 <4EFDEFF2-D1CD-4AF3-9EF8-5F160A4D93CD@gmail.com>
 <20200124233835.GT2109@linux.intel.com>
 <1A882E15-4F22-463E-AD03-460FA9251489@gmail.com>
 <CALMp9eTXVhCA=-t1S-bVn-5ZVyh7UkR2Kqe26b8c5gfxW11F+Q@mail.gmail.com>
 <436117EB-5017-4FF0-A89B-16B206951804@gmail.com>
 <CALMp9eQYS3W5_PB8wP36UBBGHRHSoJmBDUEJ95AUcXYQ1sC9mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQYS3W5_PB8wP36UBBGHRHSoJmBDUEJ95AUcXYQ1sC9mQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 27, 2020 at 11:24:31AM -0800, Jim Mattson wrote:
> On Sun, Jan 26, 2020 at 8:36 PM Nadav Amit <nadav.amit@gmail.com> wrote:
> >
> > > On Jan 26, 2020, at 2:06 PM, Jim Mattson <jmattson@google.com> wrote:
> > >
> > > If I had to guess, you probably have SMM malware on your host. Remove
> > > the malware, and the test should pass.
> >
> > Well, malware will always be an option, but I doubt this is the case.
> 
> Was my innuendo too subtle? I consider any code executing in SMM to be malware.

SMI complications seem unlikely.  The straw that broke the camel's back
was a 1152 cyle delta, presumably the other failing runs had similar deltas.
I've never benchmarked SMI+RSM, but I highly doubt it comes anywhere close
to VM-Enter/VM-Exit's super optimized ~400 cycle round trip.  E.g. I
wouldn't be surprised if just SMI+RSM is over 1500 cycles.

> > Interestingly, in the last few times the failure did not reproduce. Yet,
> > thinking about it made me concerned about MTRRs configuration, and that
> > perhaps performance is affected by memory marked as UC after boot, since
> > kvm-unit-test does not reset MTRRs.
> >
> > Reading the variable range MTRRs, I do see some ranges marked as UC (most of
> > the range 2GB-4GB, if I read the MTRRs correctly):
> >
> >   MSR 0x200 = 0x80000000
> >   MSR 0x201 = 0x3fff80000800
> >   MSR 0x202 = 0xff000005
> >   MSR 0x203 = 0x3fffff000800
> >   MSR 0x204 = 0x38000000000
> >   MSR 0x205 = 0x3f8000000800
> >
> > Do you think we should set the MTRRs somehow in KVM-unit-tests? If yes, can
> > you suggest a reasonable configuration?
> 
> I would expect MTRR issues to result in repeatable failures. For
> instance, if your VMCS ended up in UC memory, that might slow things
> down quite a bit. But, I would expect the VMCS to end up at the same
> address each time the test is run.

Agreed on the repeatable failures part, but putting the VMCS in UC memory
shouldn't affect this type of test.  The CPU's internal VMCS cache isn't
coherent, and IIRC isn't disabled if the MTRRs for the VMCS happen to be
UC.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE74B9811B
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 19:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbfHURRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 13:17:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:16580 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729309AbfHURRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 13:17:39 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 10:17:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="180107328"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 21 Aug 2019 10:17:38 -0700
Date:   Wed, 21 Aug 2019 10:17:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Matt Delco <delco@google.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: lapic: restart counter on change to periodic mode
Message-ID: <20190821171737.GG29345@linux.intel.com>
References: <20190819230422.244888-1-delco@google.com>
 <80390180-93a3-4d6e-b62a-d4194eb13106@redhat.com>
 <20190820003700.GH1916@linux.intel.com>
 <CAHGX9VrZyPQ8OxnYnOWg-ES3=kghSx1LSyzrX8i3=O+o0JAsig@mail.gmail.com>
 <20190820015641.GK1916@linux.intel.com>
 <74C7BC03-99CA-4213-8327-B8D23E3B22AB@gmail.com>
 <CANRm+Cz_3g9bUwzMzWffZCSayaEKqbx9=J3E7CWMMbQP224h9g@mail.gmail.com>
 <CAHGX9Vr4HsVowENg8CS9pVWMr2n58H_tJqDX823oAHL++L8yHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHGX9Vr4HsVowENg8CS9pVWMr2n58H_tJqDX823oAHL++L8yHA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 20, 2019 at 12:34:20AM -0700, Matt Delco wrote:
> On Mon, Aug 19, 2019 at 10:09 PM Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > On Tue, 20 Aug 2019 at 12:10, Nadav Amit <nadav.amit@gmail.com> wrote:
> > > These tests pass on bare-metal.
> >
> > Good to know this. In addition, in linux apic driver, during mode
> > switch __setup_APIC_LVTT() always sets lapic_timer_period(number of
> > clock cycles per jiffy)/APIC_DIVISOR to APIC_TMICT which can avoid the
> > issue Matt report. So is it because there is no such stuff in windows
> > or the windows version which Matt testing is too old?
> 
> I'm using Windows 10 (May 2019). Multimedia apps on Windows tend to
> request higher frequency clocks, and this in turn can affect how the
> kernel configures HW timers.  I may need to examine how Windows
> typically interacts with the APIC timer and see if/how this changes
> when Skype is used.  The frequent timer mode changes are not something
> I'd expect a reasonably behaved kernel to do.

Have you tried analyzing the guest code?  If we're lucky, doing so might
provide insight into what's going awry.

E.g.:

  Are the LVTT/TMICT writes are coming from a single blob/sequence of code
  in the guest?

  Is the unpaired LVTT coming from the same code sequence or is it a new
  rip entirely?

  Can you dump the relevant asm code sequences?

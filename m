Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787441BB186
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 00:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgD0Wah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 18:30:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:35943 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgD0Wag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 18:30:36 -0400
IronPort-SDR: O5hRZXx8VI37ECkdveCJw1IKXbO3kifkJAkGbMd4MhfEbuPNtBnm3qgHxYKYVVZPpCDswQ47br
 8tCbr5dGx2Hw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 15:30:35 -0700
IronPort-SDR: nFx1d4nP5l1IMWoHG+x1djP41SgeNJwJTbkT0gWEaADkc7OHlmlUx9bPGHgQaixbNcoIJKkBRX
 eL2thr/ZxsGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="257421736"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 27 Apr 2020 15:30:35 -0700
Date:   Mon, 27 Apr 2020 15:30:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: VMX: Improve handle_external_interrupt_irqoff
 inline assembly
Message-ID: <20200427223035.GV14870@linux.intel.com>
References: <20200426115255.305060-1-ubizjak@gmail.com>
 <20200427192512.GT14870@linux.intel.com>
 <CAFULd4bJR0bHCkbHdioBtKCs6=cRyrj8v6XYCezrNLUTf8OwgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFULd4bJR0bHCkbHdioBtKCs6=cRyrj8v6XYCezrNLUTf8OwgA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 10:08:01PM +0200, Uros Bizjak wrote:
> On Mon, Apr 27, 2020 at 9:25 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Sun, Apr 26, 2020 at 01:52:55PM +0200, Uros Bizjak wrote:
> > > Improve handle_external_interrupt_irqoff inline assembly in several ways:
> > > - use "n" operand constraint instead of "i" and remove
> >
> > What's the motivation for using 'n'?  The 'i' variant is much more common,
> > i.e. less likely to trip up readers.
> >
> >   $ git grep -E "\"i\"\s*\(" | wc -l
> >   768
> >   $ git grep -E "\"n\"\s*\(" | wc -l
> >   11

...

> PUSH is able to use "i" here, since the operand is word wide. But, do
> we really want to allow symbol references and labels here?

No, but on the other hand, I doubt this particular code is going to change
much.  I don't have a strong preference.

> > >   unneeded %c operand modifiers and "$" prefixes
> > > - use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
> > > - use $-16 immediate to align %rsp
> >
> > Heh, this one depends on the reader, I find 0xfffffffffffffff0 to be much
> > more intuitive, though admittedly also far easier to screw up.
> 
> I was beaten by this in the past ... but don't want to bikeshed here.

I'm good with either approach.  Same as above, the argument for keeping the
existing code is that it's there, it works, and from some people it's more
readable.

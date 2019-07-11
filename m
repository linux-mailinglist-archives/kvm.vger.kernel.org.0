Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F86766242
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 01:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbfGKXe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 19:34:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:3463 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728532AbfGKXe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 19:34:27 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 16:34:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,480,1557212400"; 
   d="scan'208";a="160223732"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga008.jf.intel.com with ESMTP; 11 Jul 2019 16:34:26 -0700
Date:   Thu, 11 Jul 2019 16:34:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <zhexu@redhat.com>
Cc:     kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] tscdeadline_latency: Check condition
 first before loop
Message-ID: <20190711233426.GS15067@linux.intel.com>
References: <20190711071756.2784-1-peterx@redhat.com>
 <20190711073335.GC7847@xz-x1>
 <20190711140553.GB7645@linux.intel.com>
 <20190711232736.GD7847@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711232736.GD7847@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 07:27:36AM +0800, Peter Xu wrote:
> On Thu, Jul 11, 2019 at 07:05:53AM -0700, Sean Christopherson wrote:
> > Ensuring the first hlt lands in an interrupt shadow should prevent getting
> > into a halted state after the timer has been disabled, e.g.:
> > 
> >     irq_disable();
> >     test_tsc_deadline_timer();
> > 
> >     do {
> >         safe_halt();
> >     } while (!hitmax && table_idx < size);
> 
> Yes seems better, thanks for the suggestion (though I'll probably also
> need to remove the hidden sti in start_tsc_deadline_timer).
> 
> Is safe_halt() really safe?  I mean, IRQ handler could still run
> before HLT right after STI right?  Though no matter what I think it's
> fine for this test case because we'll skip the first IRQ after all.
> Just curious.

It's safe, at least on modern hardware.  Everything since P6, and I
think all AMD CPUs?, have an interrupt shadow where interrupts are
blocked for one additional instruction after being enabled by STI.

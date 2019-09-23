Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0672BBB10
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 20:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440371AbfIWSQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 14:16:00 -0400
Received: from mga12.intel.com ([192.55.52.136]:63537 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394280AbfIWSQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 14:16:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 11:15:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,541,1559545200"; 
   d="scan'208";a="203179266"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 23 Sep 2019 11:15:59 -0700
Date:   Mon, 23 Sep 2019 11:15:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20190923181558.GI18195@linux.intel.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <20190923163746.GE18195@linux.intel.com>
 <24dc5c23-eed8-22db-fd15-5a165a67e747@redhat.com>
 <20190923174244.GA19996@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923174244.GA19996@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 01:42:44PM -0400, Andrea Arcangeli wrote:
> On Mon, Sep 23, 2019 at 06:53:10PM +0200, Paolo Bonzini wrote:
> > On 23/09/19 18:37, Sean Christopherson wrote:
> > >> Would it be too much if we get rid of
> > >> kvm_vmx_exit_handlers completely replacing this code with one switch()?
> > > Hmm, that'd require redirects for nVMX functions since they are set at
> > > runtime.  That isn't necessarily a bad thing.  The approach could also be
> > > used if Paolo's idea of making kvm_vmx_max_exit_handlers const allows the
> > > compiler to avoid retpoline.
> > 
> > But aren't switch statements also retpolin-ized if they use a jump table?
> 
> See commit a9d57ef15cbe327fe54416dd194ee0ea66ae53a4.
> 
> We disabled that feature or the kernel would potentially suffer the
> downsides of the exit handlers through pointer to functions for every
> switch statement in the kernel.
> 
> In turn you can't make it run any faster by converting my "if" to a
> "switch" at least the "if" can deterministic control the order of what
> is more likely that we should also re-review, but the order of secondary
> effect, the important thing is to reduce the retpolines to zero during
> normal hrtimer guest runtime.

On the flip side, using a switch for the fast-path handlers gives the
compiler more flexibility to rearrange and combine checks.  Of course that
doesn't mean the compiler will actually generate faster code for our
purposes :-)

Anyways, getting rid of the retpolines is much more important.

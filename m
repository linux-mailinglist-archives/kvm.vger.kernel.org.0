Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 385B710F176
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 21:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfLBUVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 15:21:21 -0500
Received: from mga12.intel.com ([192.55.52.136]:59942 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbfLBUVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 15:21:20 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 12:21:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,270,1571727600"; 
   d="scan'208";a="360937960"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 02 Dec 2019 12:21:20 -0800
Date:   Mon, 2 Dec 2019 12:21:19 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 00/15] KVM: Dirty ring interface
Message-ID: <20191202202119.GK4063@linux.intel.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <b8f28d8c-2486-2d66-04fd-a2674b598cfd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8f28d8c-2486-2d66-04fd-a2674b598cfd@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 30, 2019 at 09:29:42AM +0100, Paolo Bonzini wrote:
> Hi Peter,
> 
> thanks for the RFC!  Just a couple comments before I look at the series
> (for which I don't expect many surprises).
> 
> On 29/11/19 22:34, Peter Xu wrote:
> > I marked this series as RFC because I'm at least uncertain on this
> > change of vcpu_enter_guest():
> > 
> >         if (kvm_check_request(KVM_REQ_DIRTY_RING_FULL, vcpu)) {
> >                 vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
> >                 /*
> >                         * If this is requested, it means that we've
> >                         * marked the dirty bit in the dirty ring BUT
> >                         * we've not written the date.  Do it now.
> >                         */
> >                 r = kvm_emulate_instruction(vcpu, 0);
> >                 r = r >= 0 ? 0 : r;
> >                 goto out;
> >         }
> 
> This is not needed, it will just be a false negative (dirty page that
> actually isn't dirty).  The dirty bit will be cleared when userspace
> resets the ring buffer; then the instruction will be executed again and
> mark the page dirty again.  Since ring full is not a common condition,
> it's not a big deal.

Side topic, KVM_REQ_DIRTY_RING_FULL is misnamed, it's set when a ring goes
above its soft limit, not when the ring is actually full.  It took quite a
bit of digging to figure out whether or not PML was broken...

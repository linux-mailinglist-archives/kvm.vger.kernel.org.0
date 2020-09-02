Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D6925AF27
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 17:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgIBPeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 11:34:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:43844 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727895AbgIBPUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 11:20:01 -0400
IronPort-SDR: WXReCybxJdxHS2J5btFqGPIY4jVz16bnTx3g5NMWm6AWaeZZ9fphe4awJpXVYNpyo89GDnOMd/
 4l0e66/WAcJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="158398293"
X-IronPort-AV: E=Sophos;i="5.76,383,1592895600"; 
   d="scan'208";a="158398293"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 08:18:50 -0700
IronPort-SDR: 84PhDN9HHr/+zSjnMDCSGNAPptVMhcinqyKwasO4yk24J3FhV2mRwDQaVWAeny12WobOhMqmF2
 k/mrv8Lkysdg==
X-IronPort-AV: E=Sophos;i="5.76,383,1592895600"; 
   d="scan'208";a="446557920"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 08:18:49 -0700
Date:   Wed, 2 Sep 2020 08:18:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: fix crash cleanup when KVM wasn't used
Message-ID: <20200902151848.GA11695@sjchrist-ice>
References: <20200401081348.1345307-1-vkuznets@redhat.com>
 <CALMp9eROXAOg_g=R8JRVfywY7uQXzBtVxKJYXq0dUcob-BfR-g@mail.gmail.com>
 <20200822034046.GE4769@sjchrist-ice>
 <CALMp9eRHh9KXO12k4GaoenSJazFnSaN68FTVxOGhE9Mxw-hf2A@mail.gmail.com>
 <CALMp9eS1HusEZvzLShuuuxQnReKgTtunsKLoy+2GMVJAaTrZ7A@mail.gmail.com>
 <20200825000920.GB15046@sjchrist-ice>
 <87pn75wzpj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pn75wzpj.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 01, 2020 at 12:36:40PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > On Mon, Aug 24, 2020 at 03:45:26PM -0700, Jim Mattson wrote:
> >> On Mon, Aug 24, 2020 at 11:57 AM Jim Mattson <jmattson@google.com> wrote:
> >> >
> >> > On Fri, Aug 21, 2020 at 8:40 PM Sean Christopherson
> >> > <sean.j.christopherson@intel.com> wrote:
> >> > > I agree the code is a mess (kvm_init() and kvm_exit() included), but I'm
> >> > > pretty sure hardware_disable_nolock() is guaranteed to be a nop as it's
> >> > > impossible for kvm_usage_count to be non-zero if vmx_init() hasn't
> >> > > finished.
> >> >
> >> > Unless I'm missing something, there's no check for a non-zero
> >> > kvm_usage_count on this path. There is such a check in
> >> > hardware_disable_all_nolock(), but not in hardware_disable_nolock().
> >> 
> >> However, cpus_hardware_enabled shouldn't have any bits set, so
> >> everything's fine. Nothing to see here, after all.
> >
> > Ugh, I forgot that hardware_disable_all_nolock() does a BUG_ON() instead of
> > bailing on !kvm_usage_count.
> 
> But we can't hit this BUG_ON(), right? I'm failing to see how
> hardware_disable_all_nolock() can be reached with kvm_usage_count==0.

Correct, I was mostly talking to myself.

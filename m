Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558B3126BF6
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 20:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbfLSTAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 14:00:31 -0500
Received: from mga18.intel.com ([134.134.136.126]:31252 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728433AbfLSTAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 14:00:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 11:00:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,332,1571727600"; 
   d="scan'208";a="241261269"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 19 Dec 2019 11:00:28 -0800
Date:   Thu, 19 Dec 2019 11:00:28 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: Re: Async page fault delivered while irq are disabled?
Message-ID: <20191219190028.GB6439@linux.intel.com>
References: <20191219152814.GA24080@lenoir>
 <20191219155745.GA6439@linux.intel.com>
 <20191219161524.GB24080@lenoir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219161524.GB24080@lenoir>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 19, 2019 at 05:15:25PM +0100, Frederic Weisbecker wrote:
> On Thu, Dec 19, 2019 at 07:57:46AM -0800, Sean Christopherson wrote:
> > On Thu, Dec 19, 2019 at 04:28:15PM +0100, Frederic Weisbecker wrote:
> > > Hi,
> > > 
> > > While checking the x86 async page fault code, I can't
> > > find anything that prevents KVM_PV_REASON_PAGE_READY to be injected
> > > while the guest has interrupts disabled. If that page fault happens
> > > to trap in an interrupt disabled section, there may be a deadlock due to the
> > > call to wake_up_process() which locks the rq->lock (among others).
> > > 
> > > Given how long that code is there, I guess such an issue would
> > > have been reported for a while already. But I just would like to
> > > be sure we are checking that.
> > > 
> > > Can someone enlighten me?
> > 
> > The check is triggered from the caller of kvm_async_page_present().
> > 
> > kvm_check_async_pf_completion()
> > |
> > |-> kvm_arch_can_inject_async_page_present()
> >     |
> >     |-> kvm_can_do_async_pf()
> >         |
> >         |-> kvm_x86_ops->interrupt_allowed()
> 
> Ah thanks, I missed that one. And what about
> kvm_async_page_present_sync()? I don't see a similar check
> there.

CONFIG_KVM_ASYNC_PF_SYNC is selected only by s390, it can't be turned on
for x86.

> And one last silly question, what about that line in
> kvm_arch_can_inject_async_page_present:
> 
> 	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
> 		return true;
> 
> That looks weird, also it shortcuts the irqs_allowed() check.

I wondered about that code as well :-).  Definitely odd, but it would
require the guest to disable async #PF after an async #PF is queued.  Best
guess is the idea is that it's the guest's problem if it disables async #PF
on the fly.

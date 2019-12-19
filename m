Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8E1126676
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 17:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLSQP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 11:15:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:56168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726797AbfLSQP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 11:15:28 -0500
Received: from localhost (lfbn-ncy-1-150-155.w83-194.abo.wanadoo.fr [83.194.232.155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DFE02146E;
        Thu, 19 Dec 2019 16:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576772128;
        bh=FrF0wQaSQPRIqJVzELwiL0szraQpcov4qnK7vwtCbZw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mk5UJMzzKXwWJIE7Fne8Yp8MZugFkSDWca9CIyLU3bjQ16cpMuT6HVk+zPRUVxN6Q
         127FrzjtTfw1+ADvpivjlkLz1i3ankvGAllq/1NDK2YEJcEflOHlZwXuTuI6NyPBn2
         QdLV4zQMMjHUCxgReOg5Zzjpm3HHniKrzAKLYvfo=
Date:   Thu, 19 Dec 2019 17:15:25 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: Re: Async page fault delivered while irq are disabled?
Message-ID: <20191219161524.GB24080@lenoir>
References: <20191219152814.GA24080@lenoir>
 <20191219155745.GA6439@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219155745.GA6439@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 19, 2019 at 07:57:46AM -0800, Sean Christopherson wrote:
> On Thu, Dec 19, 2019 at 04:28:15PM +0100, Frederic Weisbecker wrote:
> > Hi,
> > 
> > While checking the x86 async page fault code, I can't
> > find anything that prevents KVM_PV_REASON_PAGE_READY to be injected
> > while the guest has interrupts disabled. If that page fault happens
> > to trap in an interrupt disabled section, there may be a deadlock due to the
> > call to wake_up_process() which locks the rq->lock (among others).
> > 
> > Given how long that code is there, I guess such an issue would
> > have been reported for a while already. But I just would like to
> > be sure we are checking that.
> > 
> > Can someone enlighten me?
> 
> The check is triggered from the caller of kvm_async_page_present().
> 
> kvm_check_async_pf_completion()
> |
> |-> kvm_arch_can_inject_async_page_present()
>     |
>     |-> kvm_can_do_async_pf()
>         |
>         |-> kvm_x86_ops->interrupt_allowed()

Ah thanks, I missed that one. And what about
kvm_async_page_present_sync()? I don't see a similar check
there.

And one last silly question, what about that line in
kvm_arch_can_inject_async_page_present:

	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
		return true;

That looks weird, also it shortcuts the irqs_allowed() check.

Thanks!

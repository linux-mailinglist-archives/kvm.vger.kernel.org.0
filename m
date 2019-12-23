Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600561290DA
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 03:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfLWCRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Dec 2019 21:17:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:42206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726291AbfLWCRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Dec 2019 21:17:49 -0500
Received: from localhost (lfbn-ncy-1-150-155.w83-194.abo.wanadoo.fr [83.194.232.155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3324F206B7;
        Mon, 23 Dec 2019 02:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577067468;
        bh=miTSmIlQER90/gB1vhZTQXbtQ8c1anmfc+yqS8BL1zM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uh1YcktQGJd8w+s1MRkjzwIqSOULKRDvl/C+2h43shx7TWxPE065BG3RltoSGnPpl
         /ElWfMUYs4Rtqe0pXIH03/AFbnFEc+Gbzek1HnrZ5r0/kUVqIGynj7H7uhpVoa4au6
         Osge/KnUimc0ZMt/j2R+mrMzrVigybaUX6vOuX0A=
Date:   Mon, 23 Dec 2019 03:17:46 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: Re: Async page fault delivered while irq are disabled?
Message-ID: <20191223021745.GA21615@lenoir>
References: <20191219152814.GA24080@lenoir>
 <20191219155745.GA6439@linux.intel.com>
 <20191219161524.GB24080@lenoir>
 <20191219190028.GB6439@linux.intel.com>
 <925b4dd2-7919-055e-0041-672dad8c082e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <925b4dd2-7919-055e-0041-672dad8c082e@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 20, 2019 at 10:34:20AM +0100, Paolo Bonzini wrote:
> On 19/12/19 20:00, Sean Christopherson wrote:
> >> And one last silly question, what about that line in
> >> kvm_arch_can_inject_async_page_present:
> >>
> >> 	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
> >> 		return true;
> >>
> >> That looks weird, also it shortcuts the irqs_allowed() check.
> > 
> > I wondered about that code as well :-).  Definitely odd, but it would
> > require the guest to disable async #PF after an async #PF is queued.  Best
> > guess is the idea is that it's the guest's problem if it disables async #PF
> > on the fly.
> > 
> 
> When the guest disables async #PF all outstanding page faults are
> cancelled by kvm_clear_async_pf_completion_queue.  However, in case they
> complete while in cancel_work_sync. you need to inject them even if
> interrupts are disabled.

Hmm, shouldn't the guest wait for the whole pending waitqueue in kvm_async_pf_task_wait()
to be serviced and woken up before actually allowing to disable async #PF ?
Because you can't really afford to inject those #PF while IRQs are disabled,
that's a big rq deadlock risk.

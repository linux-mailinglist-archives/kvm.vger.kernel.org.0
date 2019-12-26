Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 955A112ADA7
	for <lists+kvm@lfdr.de>; Thu, 26 Dec 2019 18:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfLZR2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Dec 2019 12:28:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfLZR2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Dec 2019 12:28:30 -0500
Received: from localhost (lfbn-ncy-1-150-155.w83-194.abo.wanadoo.fr [83.194.232.155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 096F62075E;
        Thu, 26 Dec 2019 17:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577381309;
        bh=wnCDfyy3g8i5vE2UMY6gLVXzOlxS4iAl3JCnYpQBh2Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NOFNCFdd4T+BwFAieqeRAFhvfPWs4J5wECEgnnA2bARsO2Ir6aD3uVjOQB+Zdnr91
         R1Q4s7lZS151icBjKsYzc1ixr3Nv2DpoPiATihYXTdS+y1EKqjhkXNNnPDosPTnSOk
         FcHoe4s2dkTEqhoffOcbqwxFjoC6FeKUzHBJG5bM=
Date:   Thu, 26 Dec 2019 18:28:27 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: Re: Async page fault delivered while irq are disabled?
Message-ID: <20191226172826.GA24003@lenoir>
References: <20191219152814.GA24080@lenoir>
 <20191219155745.GA6439@linux.intel.com>
 <20191219161524.GB24080@lenoir>
 <20191219190028.GB6439@linux.intel.com>
 <925b4dd2-7919-055e-0041-672dad8c082e@redhat.com>
 <20191223021745.GA21615@lenoir>
 <9bfb0925-a571-d51d-367d-3dc2cf74fc8c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bfb0925-a571-d51d-367d-3dc2cf74fc8c@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 23, 2019 at 09:38:18AM +0100, Paolo Bonzini wrote:
> On 23/12/19 03:17, Frederic Weisbecker wrote:
> > On Fri, Dec 20, 2019 at 10:34:20AM +0100, Paolo Bonzini wrote:
> >> On 19/12/19 20:00, Sean Christopherson wrote:
> >>>> And one last silly question, what about that line in
> >>>> kvm_arch_can_inject_async_page_present:
> >>>>
> >>>> 	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
> >>>> 		return true;
> >>>>
> >>>> That looks weird, also it shortcuts the irqs_allowed() check.
> >>>
> >>> I wondered about that code as well :-).  Definitely odd, but it would
> >>> require the guest to disable async #PF after an async #PF is queued.  Best
> >>> guess is the idea is that it's the guest's problem if it disables async #PF
> >>> on the fly.
> >>>
> >>
> >> When the guest disables async #PF all outstanding page faults are
> >> cancelled by kvm_clear_async_pf_completion_queue.  However, in case they
> >> complete while in cancel_work_sync. you need to inject them even if
> >> interrupts are disabled.
> > 
> > Hmm, shouldn't the guest wait for the whole pending waitqueue in kvm_async_pf_task_wait()
> > to be serviced and woken up before actually allowing to disable async #PF ?
> > Because you can't really afford to inject those #PF while IRQs are disabled,
> > that's a big rq deadlock risk.
> 
> That's just how Linux works, and Linux doesn't ever disable async page
> faults with disabled IRQ (reboot_notifier_list is a blocking notifier).

So when I talk about IRQs enabled requirement, this is to prevent the page fault from
interrupting code that may hold a lock.

Now in those case I think we are good, as kvm_pv_guest_cpu_reboot() is called from
a generic IPI (rq and others shouldn't be held at that time) and kvm_guest_cpu_offline()
is called from a thread with interrupts disabled.

Anyway those semantics and expectations are very obscure. Probably those async page
faults should be considered as IRQs from lockdep POV.

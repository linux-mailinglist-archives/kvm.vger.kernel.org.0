Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10CF81CD30
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 18:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfENQpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 12:45:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:55352 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbfENQpE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 12:45:04 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 May 2019 09:45:03 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga001.jf.intel.com with ESMTP; 14 May 2019 09:45:03 -0700
Date:   Tue, 14 May 2019 09:45:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH 3/3] KVM: LAPIC: Optimize timer latency further
Message-ID: <20190514164503.GA1668@linux.intel.com>
References: <1557401361-3828-1-git-send-email-wanpengli@tencent.com>
 <1557401361-3828-4-git-send-email-wanpengli@tencent.com>
 <20190513195417.GM28561@linux.intel.com>
 <CANRm+CxVRMQF9yHoqDMJR9FROGtLwYgaQXPqu++S7Juneh2vtw@mail.gmail.com>
 <CANRm+Czg-0m1dV1DVfqSTr89Xrq169xx3LqEGTYH0mmjafvhMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+Czg-0m1dV1DVfqSTr89Xrq169xx3LqEGTYH0mmjafvhMQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 14, 2019 at 06:56:04PM +0800, Wanpeng Li wrote:
> On Tue, 14 May 2019 at 09:45, Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > On Tue, 14 May 2019 at 03:54, Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > > Rather than reinvent the wheel, can we simply move the call to
> > > wait_lapic_expire() into vmx.c and svm.c?  For VMX we'd probably want to
> > > support the advancement if enable_unrestricted_guest=true so that we avoid
> > > the emulation_required case, but other than that I don't see anything that
> > > requires wait_lapic_expire() to be called where it is.
> >
> > I also considered to move wait_lapic_expire() into vmx.c and svm.c
> > before, what do you think, Paolo, Radim?
> 
> However, guest_enter_irqoff() also prevents this. Otherwise, we will
> account busy wait time as guest time. How about sampling several times
> and get the average value or conservative min value to handle Sean's
> concern?

Hmm, looking at the history, wait_lapic_expire() was originally called
immediately before kvm_x86_ops->run()[1].  The call was moved above
guest_enter_irqoff() because of its tracepoint, which violated the RCU
extended quiescent state invoked by guest_enter_irqoff()[2][3].  In
other words, I don't think there is a fundamental issue with accounting
the busy wait time to the guest rather than the host.

Assuming the tracepoint was added to help tune the advancement time, I
think we can simply remove the tracepoint, which would allow moving
wait_lapic_expire().  Now that the advancement time is tracked per-vCPU,
realizing a change in the advancement time requires creating a new VM.
For all intents and purposes this makes it impractical to hand tune the
advancement in real time using the tracepoint as the feedback mechanism.

If we want to expose the per-vCPU advancement time to the user, a debugfs
entry is likely sufficient given that the advancement time is
automatically adjusted.

[1] Commit d0659d946be0 ("KVM: x86: add option to advance tscdeadline hrtimer expiration")
[2] Commit 8b89fe1f6c43 ("kvm: x86: move tracepoints outside extended quiescent state")
[3] https://patchwork.kernel.org/patch/7821111/

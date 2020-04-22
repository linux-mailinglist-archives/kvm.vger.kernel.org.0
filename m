Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F591B50A6
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 01:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgDVXIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 19:08:16 -0400
Received: from mga12.intel.com ([192.55.52.136]:58194 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgDVXIQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 19:08:16 -0400
IronPort-SDR: jHb4JmA+qrT/AuSlR1m7AaxhgI3/htWRlKt/44wY/PsUlDykpz01hrXiQPfKk38R7wENzQVcw0
 chAsJd1Zclng==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 16:08:15 -0700
IronPort-SDR: nl3s9nvCegAeZ4jpYLj9PpXPXC2fnrV6glRGVEY4BYMZBDjCSauWBFSfqYwALd//m4eOuItQCx
 ZzQ6iKo5iwZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,304,1583222400"; 
   d="scan'208";a="259234828"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 22 Apr 2020 16:08:15 -0700
Date:   Wed, 22 Apr 2020 16:08:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Makarand Sonare <makarandsonare@google.com>,
        kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
Subject: Re: [kvm PATCH 2/2] KVM: nVMX: Don't clobber preemption timer in the
 VMCS12 before L2 ran
Message-ID: <20200422230815.GC4662@linux.intel.com>
References: <20200417183452.115762-1-makarandsonare@google.com>
 <20200417183452.115762-3-makarandsonare@google.com>
 <20200422015759.GE17836@linux.intel.com>
 <20200422020216.GF17836@linux.intel.com>
 <CALMp9eRUE7hRNUohhAuz8UoX0Zu1LtoXum7inuqW5ROy=m1hyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRUE7hRNUohhAuz8UoX0Zu1LtoXum7inuqW5ROy=m1hyQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 10:05:45AM -0700, Jim Mattson wrote:
> On Tue, Apr 21, 2020 at 7:02 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index 409a39af121f..7dd6440425ab 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -3951,7 +3951,8 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
> > >         else
> > >                 vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
> > >
> > > -       if (nested_cpu_has_preemption_timer(vmcs12)) {
> > > +       if (nested_cpu_has_preemption_timer(vmcs12) &&
> > > +           !vmx->nested.nested_run_pending) {
> > >                 vmx->nested.preemption_timer_remaining =
> > >                         vmx_get_preemption_timer_value(vcpu);
> > >                 if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
> >
> > Actually, why is this a separate patch?  The code it's fixing was introduced
> > in patch one of this series.
> 
> That's my fault. I questioned the legitimacy of this patch. When
> nested_run_pending is set in sync_vmcs02_to_vmcs12, we are in the
> middle of executing a VMLAUNCH or VMRESUME and userspace has requested
> a dump of the nested state. At this point, we have already called
> nested_vmx_enter_non_root_mode, and we have already started the timer.
> Even though we are going to repeat the vmcs02 setup when restoring the
> nested state, we do not actually rollback and restart the instruction.
> Setting up the vmcs02 on the target is just something we have to do to
> continue where we left off. Since we're continuing a partially
> executed instruction after the restore rather than rolling back, I
> think it's perfectly reasonable to go ahead and count the time elapsed
> prior to KVM_GET_NESTED_STATE against L2's VMX-preemption timer.

Counting the time lapsed seems reasonable, and is allowed from an
architectural standpoint.  It probably ends up being more accurate for the
KVM (as L1) use case where the preemption timer is being used to emulate
the TSC deadline timer, i.e. is less delayed.

> I don't have a strong objection to this patch. It just seems to add
> gratuitous complexity. If the consensus is to take it, the two parts
> should be squashed together.

I too don't have a strong opinion either way.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDAA1BE1A7
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 16:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgD2Oum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 10:50:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:48625 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgD2Oum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 10:50:42 -0400
IronPort-SDR: UDWzAqqCjLLyHarYtbpjNt1UQRI9PghqyabRKJpto5QAlJuwwWQpOxXOqCQM6HUWEl6E7LfBZk
 qZHkor+kzSQg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 07:50:41 -0700
IronPort-SDR: /CUW6veITOGaL328946rO9ZoBt7dZGCUr4lv91D0xopfsMKl10QH5StxrIJokqk5mc25775ZKn
 1K4JckKKJzuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="459603004"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 29 Apr 2020 07:50:41 -0700
Date:   Wed, 29 Apr 2020 07:50:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 09/13] KVM: nVMX: Prioritize SMI over nested IRQ/NMI
Message-ID: <20200429145040.GA15992@linux.intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
 <20200423022550.15113-10-sean.j.christopherson@intel.com>
 <CALMp9eSuYqeVmWhb6q7T5DAW_Npbuin_N1+sbWjvcu0zTqiwsQ@mail.gmail.com>
 <20200428225949.GP12735@linux.intel.com>
 <CALMp9eRFfEB1avbQv0O0V=EGrJdSNTxg8Z-BONmQ--dV66CuAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eRFfEB1avbQv0O0V=EGrJdSNTxg8Z-BONmQ--dV66CuAg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 04:16:16PM -0700, Jim Mattson wrote:
> On Tue, Apr 28, 2020 at 3:59 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Tue, Apr 28, 2020 at 03:04:02PM -0700, Jim Mattson wrote:
> > > From the SDM, volume 3:
> > >
> > > • System-management interrupts (SMIs), INIT signals, and higher
> > > priority events take priority over MTF VM exits.
> > >
> > > I think this block needs to be moved up.
> >
> > Hrm.  It definitely needs to be moved above the preemption timer, though I
> > can't find any public documentation about the preemption timer's priority.
> > Preemption timer is lower priority than MTF, ergo it's not in the same
> > class as SMI.
> >
> > Regarding SMI vs. MTF and #DB trap, to actually prioritize SMIs above MTF
> > and #DBs, we'd need to save/restore MTF and pending #DBs via SMRAM.  I
> > think it makes sense to take the easy road and keep SMI after the traps,
> > with a comment to say it's technically wrong but not worth fixing.
> 
> Pending debug exceptions should just go in the pending debug
> exceptions field. End of story and end of complications. I don't
> understand why kvm is so averse to using this field the way it was
> intended.

Ah, it took my brain a bit to catch on.  I assume you're suggesting calling
nested_vmx_updated_pending_dbg() so that the pending #DB naturally gets
propagated to/from vmcs12 on SMI/RSM?  I think that should work.

> As for the MTF, section 34.14.1 of the SDM, volume 3, clearly states:
> 
> The pseudocode above makes reference to the saving of VMX-critical
> state. This state consists of the following:
> (1) SS.DPL (the current privilege level); (2) RFLAGS.VM; (3) the state
> of blocking by STI and by MOV SS (see
> Table 24-3 in Section 24.4.2); (4) the state of virtual-NMI blocking
> (only if the processor is in VMX non-root oper-
> ation and the “virtual NMIs” VM-execution control is 1); and (5) an
> indication of whether an MTF VM exit is pending
> (see Section 25.5.2). These data may be saved internal to the
> processor or in the VMCS region of the current
> VMCS. Processors that do not support SMI recognition while there is
> blocking by STI or by MOV SS need not save
> the state of such blocking.
> 
> I haven't really looked at kvm's implementation of SMM (because Google
> doesn't support it), but it seems that the "MTF VM exit is pending"
> bit should be trivial to deal with. I assume we save the other
> VMX-critical state somewhere!

True, I spaced on the extistence of vmx_pre_{enter,leave}_smm().

I'll send a patch, the delta to what's in kvm/queue should actually be
quite small.

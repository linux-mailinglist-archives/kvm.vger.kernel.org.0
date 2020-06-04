Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D914E1EEB1A
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 21:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgFDT00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 15:26:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:57917 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbgFDT0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 15:26:24 -0400
IronPort-SDR: StJW+2JGnqqryjggKV4hgSZ5tWdMJswSXhpovEevadyDPmtE1dNcCxbL+3g6DB+8T3uSzM4Kuq
 QKHxfJsEwK2Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 12:26:22 -0700
IronPort-SDR: CXA7BlGP+SOUE3ISA9bbvMmsKqwu5Vc3yMtFUHRpJyX95xm/jfyJSyfamIVo/wE9Y2j/GBCn9V
 9NfwfW3YfFqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,472,1583222400"; 
   d="scan'208";a="445614131"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 04 Jun 2020 12:26:22 -0700
Date:   Thu, 4 Jun 2020 12:26:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v3 3/4] kvm: vmx: Add last_cpu to struct vcpu_vmx
Message-ID: <20200604192622.GE30456@linux.intel.com>
References: <20200601222416.71303-1-jmattson@google.com>
 <20200601222416.71303-4-jmattson@google.com>
 <20200602012139.GF21661@linux.intel.com>
 <CALMp9eS3XEVdZ-_pRsevOiKRBSbCr96saicxC+stPfUqsM1u1A@mail.gmail.com>
 <20200603022414.GA24364@linux.intel.com>
 <CALMp9eSth924epmxS8-mMXopGMFfR_JK7Hm8tQXyeqGF3ebxcg@mail.gmail.com>
 <20200604184656.GD30456@linux.intel.com>
 <CALMp9eR3c3wQ4YrP7O0UwP=B95XR_-rEpbjet1AgKVMYNEWskA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eR3c3wQ4YrP7O0UwP=B95XR_-rEpbjet1AgKVMYNEWskA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 04, 2020 at 12:00:33PM -0700, Jim Mattson wrote:
> On Thu, Jun 4, 2020 at 11:47 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Wed, Jun 03, 2020 at 01:18:31PM -0700, Jim Mattson wrote:
> > > On Tue, Jun 2, 2020 at 7:24 PM Sean Christopherson
> > > <sean.j.christopherson@intel.com> wrote:
> > > > As an alternative to storing the last run/attempted CPU, what about moving
> > > > the "bad VM-Exit" detection into handle_exit_irqoff, or maybe a new hook
> > > > that is called after IRQs are enabled but before preemption is enabled, e.g.
> > > > detect_bad_exit or something?  All of the paths in patch 4/4 can easily be
> > > > moved out of handle_exit.  VMX would require a little bit of refacotring for
> > > > it's "no handler" check, but that should be minor.
> > >
> > > Given the alternatives, I'm willing to compromise my principles wrt
> > > emulation_required. :-) I'll send out v4 soon.
> >
> > What do you dislike about the alternative approach?
> 
> Mainly, I wanted to stash this in a common location so that I could
> print it out in our local version of dump_vmcs(). Ideally, we'd like
> to be able to identify the bad part(s) just from the kernel logs.

But this would also move dump_vmcs() to before preemption is enabled, i.e.
your version could read the CPU directly.

And actually, if we're talking about ferreting out hardware issues, you
really do want this happening before preemption is enabled so that the VMCS
dump comes from the failing CPU.  If the vCPU is migrated, the VMCS will be
dumped after a VMCLEAR->VMPTRLD, i.e. will be written to memory and pulled
back into the VMCS cache on a different CPU, and will also have been written
to by the new CPU to update host state.  Odds are that wouldn't affect the
dump in a meaningful way, but never say never.

Tangentially related, what about adding an option to do VMCLEAR at the end
of dump_vmcs(), followed by a dump of raw memory?  It'd be useless for
debugging software issues, but might be potentially useful/interesting for
triaging hardware problems.

> That, and I wouldn't have been as comfortable with the refactoring
> without a lot more testing.

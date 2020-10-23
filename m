Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CD22968AD
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 05:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460308AbgJWDOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 23:14:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:51179 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S460302AbgJWDOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 23:14:35 -0400
IronPort-SDR: EFAI8MCFg+t12VBxkwHO32IQyiNnshOvbdHAVw3YiYThD4ozuGMIYp4BmqFm2ZtVXfzRgH5Qhy
 57CAHeo44Wnw==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="154580356"
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="154580356"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 20:14:34 -0700
IronPort-SDR: p6CNCd4eagDKxkiyiJUCnAaQSYO7wabCEomHDn0v6o2bn2PGWZ1H+d3+sl7Ry+WMHRhglaIf66
 +BgrA/HDlJYg==
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="316944216"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 20:14:34 -0700
Date:   Thu, 22 Oct 2020 20:14:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Mohammed Gamal <mgamal@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v3 7/9] KVM: VMX: Add guest physical address check in EPT
 violation and misconfig
Message-ID: <20201023031433.GF23681@linux.intel.com>
References: <20200710154811.418214-1-mgamal@redhat.com>
 <20200710154811.418214-8-mgamal@redhat.com>
 <CALMp9eSbY6FjZAXt7ojQrX_SC_Lyg24dTGFZdKZK7fARGA=3hg@mail.gmail.com>
 <CALMp9eTFzQMpsrGhN4uJxyUHMKd5=yFwxLoBy==2BTHwmv_UGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTFzQMpsrGhN4uJxyUHMKd5=yFwxLoBy==2BTHwmv_UGQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 14, 2020 at 04:44:57PM -0700, Jim Mattson wrote:
> On Fri, Oct 9, 2020 at 9:17 AM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Fri, Jul 10, 2020 at 8:48 AM Mohammed Gamal <mgamal@redhat.com> wrote:
> > > @@ -5308,6 +5314,18 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
> > >                PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> > >
> > >         vcpu->arch.exit_qualification = exit_qualification;
> > > +
> > > +       /*
> > > +        * Check that the GPA doesn't exceed physical memory limits, as that is
> > > +        * a guest page fault.  We have to emulate the instruction here, because
> > > +        * if the illegal address is that of a paging structure, then
> > > +        * EPT_VIOLATION_ACC_WRITE bit is set.  Alternatively, if supported we
> > > +        * would also use advanced VM-exit information for EPT violations to
> > > +        * reconstruct the page fault error code.
> > > +        */
> > > +       if (unlikely(kvm_mmu_is_illegal_gpa(vcpu, gpa)))
> > > +               return kvm_emulate_instruction(vcpu, 0);
> > > +
> >
> > Is kvm's in-kernel emulator up to the task? What if the instruction in
> > question is AVX-512, or one of the myriad instructions that the
> > in-kernel emulator can't handle? Ice Lake must support the advanced
> > VM-exit information for EPT violations, so that would seem like a
> > better choice.
> >
> Anyone?

Using "advanced info" if it's supported seems like the way to go.  Outright
requiring it is probably overkill; if userspace wants to risk having to kill a
(likely broken) guest, so be it.

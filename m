Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7773B20B801
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 20:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgFZSS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 14:18:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:56435 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgFZSS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 14:18:28 -0400
IronPort-SDR: xMmZJhzWXjmxOCDj5+N2sUOJAylcQiaC1d+0UyHtsg9bLczcZgEukUfbJhf2RFO0pMOKFojWPV
 zcX2AchrG+1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="133807647"
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="133807647"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 11:18:21 -0700
IronPort-SDR: zt3o9bkoY2+2CVGUSRNpYgXOxP/x4EH7zmKj1n+lLxhmxrtVehX/6N5gbuv7BcmeTMBznrePPY
 yMz62I503MXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="424152589"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 26 Jun 2020 11:18:20 -0700
Date:   Fri, 26 Jun 2020 11:18:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Message-ID: <20200626181820.GG6583@linux.intel.com>
References: <20200622220442.21998-1-peterx@redhat.com>
 <20200622220442.21998-2-peterx@redhat.com>
 <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com>
 <20200626180732.GB175520@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626180732.GB175520@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 26, 2020 at 02:07:32PM -0400, Peter Xu wrote:
> On Thu, Jun 25, 2020 at 09:25:40AM -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 5eb618dbf211..64322446e590 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -1013,9 +1013,9 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
> >                 *ebx = entry->ebx;
> >                 *ecx = entry->ecx;
> >                 *edx = entry->edx;
> > -               if (function == 7 && index == 0) {
> > +               if (function == 7 && index == 0 && (*ebx | (F(RTM) | F(HLE))) {
> >                         u64 data;
> > -                       if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
> > +                       if (!kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data) &&
> >                             (data & TSX_CTRL_CPUID_CLEAR))
> >                                 *ebx &= ~(F(RTM) | F(HLE));
> >                 }
> > 
> > 
> > On VMX, MSR_IA32_TSX_CTRL will be added to the so called shared MSR array
> > regardless of whether or not it is being advertised to userspace (this is
> > a bug in its own right).  Using the host_initiated variant means KVM will
> > incorrectly bypass VMX's ARCH_CAP_TSX_CTRL_MSR check, i.e. incorrectly
> > clear the bits if userspace is being weird and stuffed MSR_IA32_TSX_CTRL
> > without advertising it to the guest.
> 
> Btw, would it be more staightforward to check "vcpu->arch.arch_capabilities &
> ARCH_CAP_TSX_CTRL_MSR" rather than "*ebx | (F(RTM) | F(HLE))" even if we want
> to have such a fix?

Not really, That ends up duplicating the check in vmx_get_msr().  From an
emulation perspective, this really is a "guest" access to the MSR, in the
sense that it the virtual CPU is in the guest domain, i.e. not a god-like
entity that gets to break the rules of emulation.

The other thing to consider is that SVM doesn't have any knowledge of any
of this, so arguably the "ignored msr" crud should get logged for SVM as
it's effectively a userspace bug if they've configured the VM to have RTM
or HLE on a system that can't possibly support either.

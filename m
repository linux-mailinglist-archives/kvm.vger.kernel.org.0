Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC67421A7B9
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 21:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgGITYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 15:24:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:63842 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgGITYk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 15:24:40 -0400
IronPort-SDR: 7BNdIwuv1//38vKz3EvnBvo5vkADvhSC/QCUfoTY/GyJ1VBT5RXc8iDbO9MZ84J/UDVLpRzB08
 +Gu8i5St3BSQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="166183556"
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="166183556"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 12:24:40 -0700
IronPort-SDR: sMZsTiHVopK3ePEcpWwnCOAclmj9xhQ/9CxqYKvsyQ8WVcc/mC/cnIrpFDy+ALUTYqjlpxw6W5
 haZS4pM+VAzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="358543721"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 09 Jul 2020 12:24:40 -0700
Date:   Thu, 9 Jul 2020 12:24:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Message-ID: <20200709192440.GD24919@linux.intel.com>
References: <20200622220442.21998-1-peterx@redhat.com>
 <20200622220442.21998-2-peterx@redhat.com>
 <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com>
 <20200626180732.GB175520@xz-x1>
 <20200626181820.GG6583@linux.intel.com>
 <47b90b77-cf03-6087-b25f-fcd2fd313165@redhat.com>
 <20200630154726.GD7733@linux.intel.com>
 <20200709182220.GG199122@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709182220.GG199122@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 09, 2020 at 02:22:20PM -0400, Peter Xu wrote:
> On Tue, Jun 30, 2020 at 08:47:26AM -0700, Sean Christopherson wrote:
> > On Sat, Jun 27, 2020 at 04:24:34PM +0200, Paolo Bonzini wrote:
> > > On 26/06/20 20:18, Sean Christopherson wrote:
> > > >> Btw, would it be more staightforward to check "vcpu->arch.arch_capabilities &
> > > >> ARCH_CAP_TSX_CTRL_MSR" rather than "*ebx | (F(RTM) | F(HLE))" even if we want
> > > >> to have such a fix?
> > > > Not really, That ends up duplicating the check in vmx_get_msr().  From an
> > > > emulation perspective, this really is a "guest" access to the MSR, in the
> > > > sense that it the virtual CPU is in the guest domain, i.e. not a god-like
> > > > entity that gets to break the rules of emulation.
> > > 
> > > But if you wrote a guest that wants to read MSR_IA32_TSX_CTRL, there are
> > > two choices:
> > > 
> > > 1) check ARCH_CAPABILITIES first
> > > 
> > > 2) blindly access it and default to 0.
> > > 
> > > Both are fine, because we know MSR_IA32_TSX_CTRL has no
> > > reserved/must-be-one bits.  Calling __kvm_get_msr and checking for an
> > > invalid MSR through the return value is not breaking the rules of
> > > emulation, it is "faking" a #GP handler.
> > 
> > "guest" was the wrong choice of word.  My point was that, IMO, emulation
> > should never set host_initiated=true.
> > 
> > To me, accessing MSRs with host_initiated is the equivalent of loading a
> > ucode patch, i.e. it's super duper special stuff that deliberately turns
> > off all safeguards and can change the fundamental behavior of the (virtual)
> > CPU.
> 
> This seems to be an orthogonal change against what this series tried to do.  We
> use host_initiated=true in current code, and this series won't change that fact
> either.  As I mentioned in the other thread, at least the rdmsr warning is
> ambiguous when it's not initiated from the guest if without this patchset, and
> this series could address that.

My argument is that using host_initiated=true is wrong.  

> > > So I think Peter's patch is fine, but (possibly on top as a third patch)
> > > __must_check should be added to MSR getters and setters.  Also one
> > > possibility is to return -EINVAL for invalid MSRs.
> 
> Yeah I can add another patch for that.  Also if to repost, I tend to also
> introduce KVM_MSR_RET_[OK|ERROR] too, which seems to be cleaner when we had
> KVM_MSR_RET_INVALID.
> 
> Any objections before I repost?

Heh, or perhaps "Any objections that haven't been overruled before I repost?" :-D

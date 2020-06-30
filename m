Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D75B20F8C6
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 17:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389721AbgF3Pr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 11:47:28 -0400
Received: from mga07.intel.com ([134.134.136.100]:20427 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389506AbgF3Pr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 11:47:27 -0400
IronPort-SDR: 8rQoriK83JpukFlV/DZl9lUathskizCdGdw+gG3Ntu1+AYs8/nypLgpNRG+kczPQ92vYxhvXnu
 6klSq8C5Y2bQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="211338407"
X-IronPort-AV: E=Sophos;i="5.75,297,1589266800"; 
   d="scan'208";a="211338407"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 08:47:26 -0700
IronPort-SDR: SlYIPYZJa5+zSOlnlfXA5REL6IeHhXYQKfFJ6b9i9QWvxh8YKY9HdlppbI+mFmE6m2ZnA1o1oc
 zG0AzYoQSv4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,297,1589266800"; 
   d="scan'208";a="355814591"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 30 Jun 2020 08:47:26 -0700
Date:   Tue, 30 Jun 2020 08:47:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Message-ID: <20200630154726.GD7733@linux.intel.com>
References: <20200622220442.21998-1-peterx@redhat.com>
 <20200622220442.21998-2-peterx@redhat.com>
 <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com>
 <20200626180732.GB175520@xz-x1>
 <20200626181820.GG6583@linux.intel.com>
 <47b90b77-cf03-6087-b25f-fcd2fd313165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47b90b77-cf03-6087-b25f-fcd2fd313165@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 27, 2020 at 04:24:34PM +0200, Paolo Bonzini wrote:
> On 26/06/20 20:18, Sean Christopherson wrote:
> >> Btw, would it be more staightforward to check "vcpu->arch.arch_capabilities &
> >> ARCH_CAP_TSX_CTRL_MSR" rather than "*ebx | (F(RTM) | F(HLE))" even if we want
> >> to have such a fix?
> > Not really, That ends up duplicating the check in vmx_get_msr().  From an
> > emulation perspective, this really is a "guest" access to the MSR, in the
> > sense that it the virtual CPU is in the guest domain, i.e. not a god-like
> > entity that gets to break the rules of emulation.
> 
> But if you wrote a guest that wants to read MSR_IA32_TSX_CTRL, there are
> two choices:
> 
> 1) check ARCH_CAPABILITIES first
> 
> 2) blindly access it and default to 0.
> 
> Both are fine, because we know MSR_IA32_TSX_CTRL has no
> reserved/must-be-one bits.  Calling __kvm_get_msr and checking for an
> invalid MSR through the return value is not breaking the rules of
> emulation, it is "faking" a #GP handler.

"guest" was the wrong choice of word.  My point was that, IMO, emulation
should never set host_initiated=true.

To me, accessing MSRs with host_initiated is the equivalent of loading a
ucode patch, i.e. it's super duper special stuff that deliberately turns
off all safeguards and can change the fundamental behavior of the (virtual)
CPU.

Emulation on the other handle should either be subject to all the normal
rules or have dedicated, intelligent handling for breaking the normal rules,
e.g. nested usage of vmx_set_efer(), vmx_set_cr0, vmx_set_cr4, etc...

> So I think Peter's patch is fine, but (possibly on top as a third patch)
> __must_check should be added to MSR getters and setters.  Also one
> possibility is to return -EINVAL for invalid MSRs.
> 
> Paolo
> 

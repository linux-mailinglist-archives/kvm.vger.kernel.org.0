Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44DBF155B3A
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 16:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgBGPzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 10:55:40 -0500
Received: from mga05.intel.com ([192.55.52.43]:3279 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbgBGPzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 10:55:40 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 07:55:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,413,1574150400"; 
   d="scan'208";a="225583972"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 07 Feb 2020 07:55:39 -0800
Date:   Fri, 7 Feb 2020 07:55:39 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Avoid retpoline on ->page_fault() with TDP
Message-ID: <20200207155539.GC2401@linux.intel.com>
References: <20200206221434.23790-1-sean.j.christopherson@intel.com>
 <878sleg2z7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878sleg2z7.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 10:29:16AM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Wrap calls to ->page_fault() with a small shim to directly invoke the
> > TDP fault handler when the kernel is using retpolines and TDP is being
> > used.  Denote the TDP fault handler by nullifying mmu->page_fault, and
> > annotate the TDP path as likely to coerce the compiler into preferring
> > the TDP path.
> >
> > Rename tdp_page_fault() to kvm_tdp_page_fault() as it's exposed outside
> > of mmu.c to allow inlining the shim.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> 
> Out of pure curiosity, if we do something like
> 
> if (vcpu->arch.mmu->page_fault == tdp_page_fault)
>     tdp_page_fault(...)
> else if (vcpu->arch.mmu->page_fault == nonpaging_page_fault)
>    nonpaging_page_fault(...)
> ...
> 
> we also defeat the retpoline, right?

Yep.

> Should we use this technique ... everywhere? :-)

It becomes a matter of weighing the maintenance cost and robustness against
the performance benefits.  For the TDP case, amost no one (that cares about
performance) uses shadow paging, the change is very explicit, tiny and
isolated, and TDP page fault are a hot path, e.g. when booting the VM.
I.e. low maintenance overhead, still robust, and IMO worth the shenanigans.

The changes to VMX's VM-Exit handlers follow similar thinking: snipe off
the exit handlers that are performance critical, but use a low maintenance
implementation for the majority of handlers.

There have been multiple attempts to add infrastructure to solve the
maintenance and robustness problems[*], but AFAIK none of them have made
their way upstream.

[*] https://lwn.net/Articles/774743/

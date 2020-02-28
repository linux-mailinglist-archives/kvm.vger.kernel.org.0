Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5734D1741F8
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 23:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgB1W0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 17:26:47 -0500
Received: from mga04.intel.com ([192.55.52.120]:64794 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgB1W0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 17:26:47 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Feb 2020 14:26:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,497,1574150400"; 
   d="scan'208";a="232392124"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 28 Feb 2020 14:26:46 -0800
Date:   Fri, 28 Feb 2020 14:26:46 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] KVM: x86: mmu: Add guest physical address check in
 translate_gpa()
Message-ID: <20200228222646.GI2329@linux.intel.com>
References: <20200227172306.21426-1-mgamal@redhat.com>
 <20200227172306.21426-6-mgamal@redhat.com>
 <f81e0503-bc35-d682-4440-68b81c10784f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f81e0503-bc35-d682-4440-68b81c10784f@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 27, 2020 at 07:00:33PM +0100, Paolo Bonzini wrote:
> On 27/02/20 18:23, Mohammed Gamal wrote:
> > In case of running a guest with 4-level page tables on a 5-level page
> > table host, it might happen that a guest might have a physical address
> > with reserved bits set, but the host won't see that and trap it.
> > 
> > Hence, we need to check page faults' physical addresses against the guest's
> > maximum physical memory and if it's exceeded, we need to add
> > the PFERR_RSVD_MASK bits to the PF's error code.
> 
> You can just set it to PFERR_RSVD_MASK | PFERR_PRESENT_MASK (no need to
> use an "|") and return UNMAPPED_GBA.  But I would have thought that this
> is not needed and the
> 
>                 if (unlikely(FNAME(is_rsvd_bits_set)(mmu, pte, walker->level))) {
>                         errcode = PFERR_RSVD_MASK | PFERR_PRESENT_MASK;
>                         goto error;
>                 }
> 
> code would have catch the reserved bits.

That would be my assumption as well.  The only manual check should be in
the top level EPT and NPT handlers.

> > Also make sure the error code isn't overwritten by the page table walker.
> 
> Returning UNMAPPED_GVA would remove that as well.
> 
> I'm not sure this patch is enough however.  For a usermode access with
> "!pte.u pte.40" for example you should be getting:
> 
> - a #PF with PRESENT|USER error code on a machine with physical address
> width >=41; in this case you don't get an EPT violation or misconfig.
> 
> - a #PF with RSVD error code on a machine with physical address with <41.
> 
> You can enable verbose mode in access.c to see if this case is being generated,
> and if so debug it.
> 
> The solution for this would be to trap page faults and do a page table
> walk (with vcpu->arch.walk_mmu->gva_to_gpa) to find the correct error
> code.
> 
> Paolo
> 

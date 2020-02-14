Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2450615F72C
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 20:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388745AbgBNTwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 14:52:30 -0500
Received: from mga03.intel.com ([134.134.136.65]:4841 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387964AbgBNTwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 14:52:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 11:52:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,441,1574150400"; 
   d="scan'208";a="228586264"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 11:52:29 -0800
Date:   Fri, 14 Feb 2020 11:52:29 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Chia-I Wu <olvaffe@gmail.com>, kvm@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Message-ID: <20200214195229.GF20690@linux.intel.com>
References: <20200213213036.207625-1-olvaffe@gmail.com>
 <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
 <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
 <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 11:26:06AM +0100, Paolo Bonzini wrote:
> On 13/02/20 23:18, Chia-I Wu wrote:
> > 
> > The bug you mentioned was probably this one
> > 
> >   https://bugzilla.kernel.org/show_bug.cgi?id=104091
> 
> Yes, indeed.
> 
> > From what I can tell, the commit allowed the guests to create cached
> > mappings to MMIO regions and caused MCEs.  That is different than what
> > I need, which is to allow guests to create uncached mappings to system
> > ram (i.e., !kvm_is_mmio_pfn) when the host userspace also has uncached
> > mappings.  But it is true that this still allows the userspace & guest
> > kernel to create conflicting memory types.

This is ok. 

> Right, the question is whether the MCEs were tied to MMIO regions 
> specifically and if so why.

99.99999% likelihood the answer is "yes".  Cacheable accesses to non-existent
memory and most (all?) MMIO regions will cause a #MC.  This includes
speculative accesses.

Commit fd717f11015f ("KVM: x86: apply guest MTRR virtualization on host
reserved pages") explicitly had a comment "1. MMIO: trust guest MTRR",
which is basically a direct avenue to generating #MCs.

IIRC, WC accesses to non-existent memory will also cause #MC, but KVM has
bigger problems if it has PRESENT EPTEs pointing at garbage. 

> An interesting remark is in the footnote of table 11-7 in the SDM.  
> There, for the MTRR (EPT for us) memory type UC you can read:
> 
>   The UC attribute comes from the MTRRs and the processors are not 
>   required to snoop their caches since the data could never have
>   been cached. This attribute is preferred for performance reasons.
> 
> There are two possibilities:
> 
> 1) the footnote doesn't apply to UC mode coming from EPT page tables.
> That would make your change safe.
> 
> 2) the footnote also applies when the UC attribute comes from the EPT
> page tables rather than the MTRRs.  In that case, the host should use
> UC as the EPT page attribute if and only if it's consistent with the host
> MTRRs; it would be more or less impossible to honor UC in the guest MTRRs.
> In that case, something like the patch below would be needed.

(2), the EPTs effectively replace the MTRRs.  The expectation being that
the VMM will use always use EPT memtypes consistent with the MTRRs.

> It is not clear from the manual why the footnote would not apply to WC; that
> is, the manual doesn't say explicitly that the processor does not do snooping
> for accesses to WC memory.  But I guess that must be the case, which is why I
> used MTRR_TYPE_WRCOMB in the patch below.

A few paragraphs below table 11-12 states:

  In particular, a WC page must never be aliased to a cacheable page because
  WC writes may not check the processor caches.

> Either way, we would have an explanation of why creating cached mapping to
> MMIO regions would, and why in practice we're not seeing MCEs for guest RAM
> (the guest would have set WB for that memory in its MTRRs, not UC).

Aliasing (physical) RAM with different memtypes won't cause #MC, just
memory corruption.
 
> One thing you didn't say: how would userspace use KVM_MEM_DMA?  On which
> regions would it be set?
> 
> Thanks,
> 
> Paolo
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index dc331fb06495..2be6f7effa1d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6920,8 +6920,16 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  	}
>  
>  	cache = kvm_mtrr_get_guest_memory_type(vcpu, gfn);
> -
>  exit:
> +	if (cache == MTRR_TYPE_UNCACHABLE && !is_mmio) {
> +		/*
> +		 * We cannot set UC in the EPT page tables as it can cause
> +		 * machine check exceptions (??).  Hopefully the guest is
> +		 * using PAT.
> +		 */
> +		cache = MTRR_TYPE_WRCOMB;

This is unnecessary.  Setting UC in the EPT tables will never directly lead
to #MC.  Forcing WC is likely more dangerous.

> +	}
> +
>  	return (cache << VMX_EPT_MT_EPTE_SHIFT) | ipat;
>  }
>  
> 

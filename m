Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC75234C62
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 22:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgGaUka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 16:40:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:35243 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgGaUka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 16:40:30 -0400
IronPort-SDR: 76aM58o0ix06Grll67twzUutCm5RTKO4D6dVAwTYFqlmKHJauAkjslWSb1EHmp6MFWlYijiix1
 hooGIHeHhGAg==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="139837578"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="139837578"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 13:40:29 -0700
IronPort-SDR: jvmlBURwnYi3DLR7G3S+0AEhLV2fis4w13+vX0EuBvupppk/0foTP04YkbvdfDoEpH70tdcR/r
 lu4kCIb5rATA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="323351140"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga002.fm.intel.com with ESMTP; 31 Jul 2020 13:40:28 -0700
Date:   Fri, 31 Jul 2020 13:40:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     eric van tassell <Eric.VanTassell@amd.com>
Cc:     kvm@vger.kernel.org, bp@alien8.de, hpa@zytor.com, mingo@redhat.com,
        jmattson@google.com, joro@8bytes.org, pbonzini@redhat.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org, evantass@amd.com
Subject: Re: [Patch 3/4] KVM:SVM: Pin sev_launch_update_data() pages via
 sev_get_page()
Message-ID: <20200731204028.GH31451@linux.intel.com>
References: <20200724235448.106142-1-Eric.VanTassell@amd.com>
 <20200724235448.106142-4-Eric.VanTassell@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724235448.106142-4-Eric.VanTassell@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 06:54:47PM -0500, eric van tassell wrote:
> Add 2 small infrastructure functions here which to enable pinning the SEV
> guest pages used for sev_launch_update_data() using sev_get_page().
> 
> Pin the memory for the data being passed to launch_update_data() because it
> gets encrypted before the guest is first run and must not be moved which
> would corrupt it.
> 
> Signed-off-by: eric van tassell <Eric.VanTassell@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 48 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 040ae4aa7c5a..e0eed9a20a51 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -453,6 +453,37 @@ static int sev_get_page(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
>  	return 0;
>  }
>  
> +static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm,
> +					      unsigned long hva)
> +{
> +	struct kvm_memslots *slots = kvm_memslots(kvm);
> +	struct kvm_memory_slot *memslot;
> +
> +	kvm_for_each_memslot(memslot, slots) {
> +		if (hva >= memslot->userspace_addr &&
> +		    hva < memslot->userspace_addr +
> +			      (memslot->npages << PAGE_SHIFT))
> +			return memslot;
> +	}
> +
> +	return NULL;
> +}
> +
> +static bool hva_to_gfn(struct kvm *kvm, unsigned long hva, gfn_t *gfn)
> +{
> +	struct kvm_memory_slot *memslot;
> +	gpa_t gpa_offset;
> +
> +	memslot = hva_to_memslot(kvm, hva);
> +	if (!memslot)
> +		return false;
> +
> +	gpa_offset = hva - memslot->userspace_addr;
> +	*gfn = ((memslot->base_gfn << PAGE_SHIFT) + gpa_offset) >> PAGE_SHIFT;
> +
> +	return true;
> +}
> +
>  static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
>  	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
> @@ -483,6 +514,23 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		goto e_free;
>  	}
>  
> +	/*
> +	 * Increment the page ref count so that the pages do not get migrated or
> +	 * moved after we are done from the LAUNCH_UPDATE_DATA.
> +	 */
> +	for (i = 0; i < npages; i++) {
> +		gfn_t gfn;
> +
> +		if (!hva_to_gfn(kvm, (vaddr + (i * PAGE_SIZE)) & PAGE_MASK, &gfn)) {

This needs to hold kvm->srcu to block changes to memslots while looking up
the hva->gpa translation.

> +			ret = -EFAULT;
> +			goto e_unpin;
> +		}
> +
> +		ret = sev_get_page(kvm, gfn, page_to_pfn(inpages[i]));

Rather than dump everything into an xarray, KVM can instead pin the pages
by faulting them into its MMU.  By pinning pages in the MMU proper, KVM can
use software available bits in the SPTEs to track which pages are pinned,
can assert/WARN on unexpected behavior with respect to pinned pages, and
can drop/unpin pages as soon as they are no longer reachable from KVM, e.g.
when the mm_struct dies or the associated memslot is removed.

Leveraging the MMU would also make this extensible to non-SEV features,
e.g. it can be shared by VMX if VMX adds a feature that needs similar hooks
in the MMU.  Shoving the tracking in SEV means the core logic would need to
be duplicated for other features.

The big caveat is that funneling this through the MMU requires a vCPU[*],
i.e. is only viable if userspace has already created at least one vCPU.
For QEMU, this is guaranteed.  I don't know about other VMMs.

If there are VMMs that support SEV and don't create vCPUs before encrypting
guest memory, one option would be to automatically go down the optimized
route iff at least one vCPU has been created.  In other words, don't break
old VMMs, but don't carry more hacks to make them faster either.

It just so happens that I have some code that sort of implements the above.
I reworked it to mesh with SEV and will post it as an RFC.  It's far from
a tested-and-ready-to-roll implemenation, but I think it's fleshed out
enough to start a conversation.

[*] This isn't a hard requirement, i.e. KVM could be reworked to provide a
    common MMU for non-nested TDP, but that's a much bigger effort.

> +		if (ret)
> +			goto e_unpin;
> +	}
> +
>  	/*
>  	 * The LAUNCH_UPDATE command will perform in-place encryption of the
>  	 * memory content (i.e it will write the same memory region with C=1).
> -- 
> 2.17.1
> 

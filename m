Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEC1138B7C
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 06:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbgAMF4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 00:56:15 -0500
Received: from mga06.intel.com ([134.134.136.31]:9250 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgAMF4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 00:56:15 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jan 2020 21:56:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,427,1571727600"; 
   d="scan'208";a="397060238"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga005.jf.intel.com with ESMTP; 12 Jan 2020 21:56:13 -0800
Date:   Mon, 13 Jan 2020 14:00:33 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [RESEND PATCH v10 03/10] mmu: spp: Add SPP Table setup functions
Message-ID: <20200113060033.GB12253@local-michael-cet-test.sh.intel.com>
References: <20200102061319.10077-1-weijiang.yang@intel.com>
 <20200102061319.10077-4-weijiang.yang@intel.com>
 <20200110172611.GC21485@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110172611.GC21485@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 10, 2020 at 09:26:11AM -0800, Sean Christopherson wrote:
> On Thu, Jan 02, 2020 at 02:13:12PM +0800, Yang Weijiang wrote:
> > SPPT is a 4-level paging structure similar to EPT, when SPP is
> 
> How does SPP interact with 5-level EPT?
>
It should work, will add the test later.

> > armed for target physical page, bit 61 of the corresponding
> > EPT entry is flaged, then SPPT is traversed with the gfn,
> > the leaf entry of SPPT contains the access bitmap of subpages
> > inside the target 4KB physical page, one bit per 128-byte subpage.
> > 
> > Co-developed-by: He Chen <he.chen@linux.intel.com>
> > Signed-off-by: He Chen <he.chen@linux.intel.com>
> > Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> 
> ...
> 
> > +static u64 format_spp_spte(u32 spp_wp_bitmap)
> > +{
> > +	u64 new_spte = 0;
> > +	int i = 0;
> > +
> > +	/*
> > +	 * One 4K page contains 32 sub-pages, in SPP table L4E, old bits
> 
> Is this
> 
> 	One 4k page constains 32 sub-pages in SPP table L4E.  Old bits are...
> 
> or
> 	One 4k page contains 32 sub-pages.  In SPP table L4E, old bits are...
> 
> or
> 	???
>
The second case, there's a typo, old should be odd. will modify it,
thank you!

> > +	 * are reserved, so we need to transfer u32 subpage write
> 
> Wrap comments at 80 columns to save lines.
> 
> > +	 * protect bitmap to u64 SPP L4E format.
> 
> What is a "page" in "one 4k page"?  What old bits?  Why not just track a
> 64-bit value?  I understand *what* the code below does, but I have no clue
> why or whether it's correct.
old should be "odd", according to SDM, the write-permission is tracked
via even bits(2i), then 32*128 = 4KB. odd bits are reserved now.
> 
> > +	 */
> > +	while (i < 32) {
> > +		if (spp_wp_bitmap & (1ULL << i))
> > +			new_spte |= 1ULL << (i * 2);
> > +		i++;
> > +	}
> 
> 	for (i = 0; i < 32; i++)
> 		new_spte |= (spp_wp_bitmap & BIT_ULL(i)) << i;
> 
> At the very least, use a for loop.
Sure, will change it, thank you!

> 
> > +
> > +	return new_spte;
> > +}
> > +
> > +static void spp_spte_set(u64 *sptep, u64 new_spte)
> > +{
> > +	__set_spte(sptep, new_spte);
> > +}
> > +
> > +bool is_spp_spte(struct kvm_mmu_page *sp)
> > +{
> > +	return sp->role.spp;
> > +}
> > +
> > +#define SPPT_ENTRY_PHA_MASK (0xFFFFFFFFFF << 12)
> > +
> > +int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
> > +			    u32 access_map, gfn_t gfn)
> > +{
> > +	struct kvm_shadow_walk_iterator iter;
> > +	struct kvm_mmu_page *sp;
> > +	gfn_t pseudo_gfn;
> > +	u64 old_spte, spp_spte;
> > +	int ret = -EFAULT;
> > +
> > +	/* direct_map spp start */
> > +	if (!VALID_PAGE(vcpu->kvm->arch.sppt_root))
> > +		return -EFAULT;
> > +
> > +	for_each_shadow_spp_entry(vcpu, (u64)gfn << PAGE_SHIFT, iter) {
> > +		if (iter.level == PT_PAGE_TABLE_LEVEL) {
> > +			spp_spte = format_spp_spte(access_map);
> > +			old_spte = mmu_spte_get_lockless(iter.sptep);
> > +			if (old_spte != spp_spte)
> > +				spp_spte_set(iter.sptep, spp_spte);
> > +			ret = 0;
> > +			break;
> > +		}
> > +
> > +		if (!is_shadow_present_pte(*iter.sptep)) {
> > +			u64 base_addr = iter.addr;
> > +
> > +			base_addr &= PT64_LVL_ADDR_MASK(iter.level);
> > +			pseudo_gfn = base_addr >> PAGE_SHIFT;
> > +			spp_spte = *iter.sptep;
> > +			sp = kvm_spp_get_page(vcpu, pseudo_gfn,
> > +					      iter.level - 1);
> > +			link_spp_shadow_page(vcpu, iter.sptep, sp);
> > +		} else if (iter.level == PT_DIRECTORY_LEVEL  &&
> > +			   !(spp_spte & PT_PRESENT_MASK) &&
> > +			   (spp_spte & SPPT_ENTRY_PHA_MASK)) {
> > +			spp_spte = *iter.sptep;
> > +			spp_spte |= PT_PRESENT_MASK;
> > +			spp_spte_set(iter.sptep, spp_spte);
> > +		}
> > +	}
> > +
> > +	kvm_flush_remote_tlbs(vcpu->kvm);
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_spp_setup_structure);
> > +
> > +inline u64 construct_spptp(unsigned long root_hpa)
> > +{
> > +	return root_hpa & PAGE_MASK;
> > +}
> > +EXPORT_SYMBOL_GPL(construct_spptp);
> > +
> > diff --git a/arch/x86/kvm/mmu/spp.h b/arch/x86/kvm/mmu/spp.h
> > new file mode 100644
> > index 000000000000..8ef94b7a2057
> > --- /dev/null
> > +++ b/arch/x86/kvm/mmu/spp.h
> > @@ -0,0 +1,10 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef __KVM_X86_VMX_SPP_H
> > +#define __KVM_X86_VMX_SPP_H
> > +
> > +bool is_spp_spte(struct kvm_mmu_page *sp);
> > +u64 construct_spptp(unsigned long root_hpa);
> > +int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
> > +			    u32 access_map, gfn_t gfn);
> > +
> > +#endif /* __KVM_X86_VMX_SPP_H */
> > -- 
> > 2.17.2
> > 

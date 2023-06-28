Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE3D740B1F
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbjF1IW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:22:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:41314 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233297AbjF1IUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:20:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687940407; x=1719476407;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JL27lh85xBZAEx37iqF0ZHE4UjNOgtCj+fG3vad4fao=;
  b=Z83XemYPyuH3OYFDgwgFcL0FSRvUD0JQQq9laa1wzuPVqkaZbXW80dXG
   8DOQkSvDgfh7lePXPmL51SVIzJI3h5Clk7DYyGaD+STj1j4MKac4CCzlj
   klTcfUAgpumoE1Py+EmZtZtEcPGNQOsCkckzdJS6k14bcpIyMqJQSVW8p
   M6/CWihvfOrUbnWwFSLm9jjrWzcWiGMjhf8wGvxzErfm274u6vhGLm+uV
   nDviV2P445A/Mi3IetdBJr0pKkRbNcuJx2xS1re2WhBNTTPJ+762DtKzx
   TB/VAhvTOEuxj7p6hVeyh+brCH8IUsm7Kq51KNf0TEzatK+tzkpqDvu/P
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="361807724"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="361807724"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 23:42:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="786952953"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="786952953"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga004.fm.intel.com with ESMTP; 27 Jun 2023 23:41:57 -0700
Date:   Wed, 28 Jun 2023 14:41:56 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>
Subject: Re: [RFC PATCH v2 5/6] KVM: Add flags to struct kvm_gfn_range
Message-ID: <20230628064156.pblgvaks4cvulb3g@yy-desk-7060>
References: <cover.1687474039.git.isaku.yamahata@intel.com>
 <689da77417c2f4055f02a71aab51ff603bc195af.1687474039.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <689da77417c2f4055f02a71aab51ff603bc195af.1687474039.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023 at 04:16:29PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add flags to strut kvm_gfn_range to indicate who triggered the callback
> and new memory attributes.
>
> TDX needs to know the reason for a callback by kvm_unmap_gfn_range().  mmu
> notifier, set memory attributes ioctl or KVM gmem callback.  With TDX,
> zapping a private page from the encrypted page table and adding the page
> back to the same private GPA results in zeroing the page, and the guest has
> to accept the page again.  On the change of memory attribute from private

Is this part used to explains why on MMU notifier only shared pages should
be zapped ?

> to shared, zapping the GPA range irrespective to private-or-shared and
> expecting the fault doesn't work for TDX.  Instead, zap shared pages only
> and keep the private pages.  Concretely

Do you mean:

On the change of memory attribute, zapping the GPA range irrespective to
private-or-shared and expecting that the EPT mapping for attribute converts
to doesn't exist at the time of changing the attribute, zap the "from"
attribute range only and ignore the "to" attribute.

> - If it's from mmu notifier, zap shared pages.
> - If it's from KVM gmem, zap private pages.
> - If setting memory attributes to private, zap shared pages.
> - If setting memory attributes to shared, zap private pages.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>
> ---
> Changes v1 -> v2:
> - consolidate KVM_GFN_RANGE_FLAGS_GMEM_{PUNCH_HOLE, RELEASE} into
>   KVM_GFN_RANGE_FLAGS_GMEM.
> - Update the commit message to describe TDX more.  Drop SEV_SNP.
> ---
>  include/linux/kvm_host.h | 10 +++++++++-
>  virt/kvm/guest_mem.c     |  9 ++++++---
>  virt/kvm/kvm_main.c      |  4 +++-
>  3 files changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1a47cedae8a1..1fe0516fcddf 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -256,12 +256,20 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>  #endif
>
>  #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
> +
> +#define KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR	BIT(0)
> +#define KVM_GFN_RANGE_FLAGS_GMEM		BIT(1)
> +
>  struct kvm_gfn_range {
>  	struct kvm_memory_slot *slot;
>  	gfn_t start;
>  	gfn_t end;
> -	pte_t pte;
> +	union {
> +		pte_t pte;
> +		u64 attrs;
> +	};
>  	bool may_block;
> +	unsigned int flags;
>  };
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
> diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
> index cdf2d84683c8..387226136960 100644
> --- a/virt/kvm/guest_mem.c
> +++ b/virt/kvm/guest_mem.c
> @@ -99,7 +99,8 @@ static struct folio *kvm_gmem_get_folio(struct file *file, pgoff_t index)
>  }
>
>  static void kvm_gmem_invalidate_begin(struct kvm *kvm, struct kvm_gmem *gmem,
> -				      pgoff_t start, pgoff_t end)
> +				      pgoff_t start, pgoff_t end,
> +				      unsigned int flags)
>  {
>  	struct kvm_memory_slot *slot;
>  	unsigned long index;
> @@ -118,6 +119,7 @@ static void kvm_gmem_invalidate_begin(struct kvm *kvm, struct kvm_gmem *gmem,
>  			.slot = slot,
>  			.pte = __pte(0),
>  			.may_block = true,
> +			.flags = flags,
>  		};
>
>  		kvm_mmu_invalidate_range_add(kvm, gfn_range.start, gfn_range.end);
> @@ -156,7 +158,8 @@ static long kvm_gmem_punch_hole(struct file *file, loff_t offset, loff_t len)
>  	 */
>  	filemap_invalidate_lock(file->f_mapping);
>
> -	kvm_gmem_invalidate_begin(kvm, gmem, start, end);
> +	kvm_gmem_invalidate_begin(kvm, gmem, start, end,
> +				  KVM_GFN_RANGE_FLAGS_GMEM);
>
>  	truncate_inode_pages_range(file->f_mapping, offset, offset + len - 1);
>
> @@ -263,7 +266,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>  	 * Free the backing memory, and more importantly, zap all SPTEs that
>  	 * pointed at this file.
>  	 */
> -	kvm_gmem_invalidate_begin(kvm, gmem, 0, -1ul);
> +	kvm_gmem_invalidate_begin(kvm, gmem, 0, -1ul, KVM_GFN_RANGE_FLAGS_GMEM);
>  	truncate_inode_pages_final(file->f_mapping);
>  	kvm_gmem_invalidate_end(kvm, gmem, 0, -1ul);
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 422d49634c56..9cdfa2fb675f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -613,6 +613,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  			gfn_range.start = hva_to_gfn_memslot(hva_start, slot);
>  			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
>  			gfn_range.slot = slot;
> +			gfn_range.flags = 0;
>
>  			if (!locked) {
>  				locked = true;
> @@ -2391,8 +2392,9 @@ static void kvm_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
>  	bool flush = false;
>  	int i;
>
> -	gfn_range.pte = __pte(0);
> +	gfn_range.attrs = attrs;
>  	gfn_range.may_block = true;
> +	gfn_range.flags = KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR;
>
>  	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
>  		slots = __kvm_memslots(kvm, i);
> --
> 2.25.1
>

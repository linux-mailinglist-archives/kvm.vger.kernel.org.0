Return-Path: <kvm+bounces-15950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6AA58B26D6
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:51:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 569A31F24427
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE67814D452;
	Thu, 25 Apr 2024 16:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NwgR5k2j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E305F513;
	Thu, 25 Apr 2024 16:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714063907; cv=none; b=Oectj7wjZUdUt2BhFYgXHqUm2xRMewhJsZsC6aBkYnItkYs+51F7CuuUsbYP8AzE6RX46JzD1kegFTzl8fMIOQpnYt4ym2QbkI3AjCZXd/odlMgwOuglkf8w3Q1H/PWUbOJdMwEZ7RO9BIdvEzKc2vwWcBXXwET1MUeWadJCS+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714063907; c=relaxed/simple;
	bh=0I62XfgogmDs67PefKBaNXZmEUAQ/udGEwyJ6srSYe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QVurYHL8phk5hAcHfrHWimH4A5X+JrZvedBsON4ShcOXx1NyKXLzgmFFmFivfWTKZbsKrG+KNwGlPIIj0g3aejAomLSRi1UTj36SaFJvM0DSqL7XiR98QNiGY3VLysSjio6P4fRbNkj0jKt+NsAfPTRNdYboabHRE5VmPfYSdnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NwgR5k2j; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714063906; x=1745599906;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=0I62XfgogmDs67PefKBaNXZmEUAQ/udGEwyJ6srSYe4=;
  b=NwgR5k2j5L5JBY9iusTJ9OMimY09XTMn48KcmwoENmQO0n5NNUpJOHdI
   KKgwNKY8TINfqu7lJqICqHftaWOP5BidZPfDQcfI6CuV7gFbMc+QXkZvM
   stOFtWlqIgmxAp0q4NlOhK84b01n8pnJU9etIbUnPyOwYlO+d4fhEby1J
   4J4qyzs5Y2YL9n7zl1cQU+ZgxKIaJPR8KxGGoWZ4BRjUlfFaxjHj6rx0t
   saE+eVz8jnhYP+MOUUU/Aby+BwYOhOamxe2o7PHw4kWNLGmakS0EJRTPN
   nuXoIjYowIuCtZR9i0KLZoZmxlgz6AlnB6vGWcgBRUPNB8RIt2IXaNsRH
   w==;
X-CSE-ConnectionGUID: m9Rb2JagRaq5urDdDiFPxQ==
X-CSE-MsgGUID: 8ZaU46KAR7We/6wqXMpkRQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9628146"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="9628146"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 09:51:45 -0700
X-CSE-ConnectionGUID: iD17EIcJQHKvKLjEl4tXqg==
X-CSE-MsgGUID: jDKunPCiSoGC12ZAn0gfmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="29930122"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 09:51:45 -0700
Date: Thu, 25 Apr 2024 09:51:44 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	michael.roth@amd.com, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 09/11] KVM: guest_memfd: Add interface for populating
 gmem pages with user data
Message-ID: <20240425165144.GQ3596705@ls.amr.corp.intel.com>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
 <20240404185034.3184582-10-pbonzini@redhat.com>
 <20240423235013.GO3596705@ls.amr.corp.intel.com>
 <ZimGulY6qyxt6ylO@google.com>
 <20240425011248.GP3596705@ls.amr.corp.intel.com>
 <CABgObfY2TOb6cJnFkpxWjkAmbYSRGkXGx=+-241tRx=OG-yAZQ@mail.gmail.com>
 <Zip-JsAB5TIRDJVl@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zip-JsAB5TIRDJVl@google.com>

On Thu, Apr 25, 2024 at 09:00:38AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Apr 25, 2024, Paolo Bonzini wrote:
> > On Thu, Apr 25, 2024 at 3:12 AM Isaku Yamahata <isaku.yamahata@intel.com> wrote:
> > > > >   get_user_pages_fast(source addr)
> > > > >   read_lock(mmu_lock)
> > > > >   kvm_tdp_mmu_get_walk_private_pfn(vcpu, gpa, &pfn);
> > > > >   if the page table doesn't map gpa, error.
> > > > >   TDH.MEM.PAGE.ADD()
> > > > >   TDH.MR.EXTEND()
> > > > >   read_unlock(mmu_lock)
> > > > >   put_page()
> > > >
> > > > Hmm, KVM doesn't _need_ to use invalidate_lock to protect against guest_memfd
> > > > invalidation, but I also don't see why it would cause problems.
> > 
> > The invalidate_lock is only needed to operate on the guest_memfd, but
> > it's a rwsem so there are no risks of lock inversion.
> > 
> > > > I.e. why not
> > > > take mmu_lock() in TDX's post_populate() implementation?
> > >
> > > We can take the lock.  Because we have already populated the GFN of guest_memfd,
> > > we need to make kvm_gmem_populate() not pass FGP_CREAT_ONLY.  Otherwise we'll
> > > get -EEXIST.
> > 
> > I don't understand why TDH.MEM.PAGE.ADD() cannot be called from the
> > post-populate hook. Can the code for TDH.MEM.PAGE.ADD be shared
> > between the memory initialization ioctl and the page fault hook in
> > kvm_x86_ops?
> 
> Ah, because TDX is required to pre-fault the memory to establish the S-EPT walk,
> and pre-faulting means guest_memfd() 
> 
> Requiring that guest_memfd not have a page when initializing the guest image
> seems wrong, i.e. I don't think we want FGP_CREAT_ONLY.  And not just because I
> am a fan of pre-faulting, I think the semantics are bad.
> 
> E.g. IIUC, doing fallocate() to ensure memory is available would cause LAUNCH_UPDATE
> to fail.  That's weird and has nothing to do with KVM_PRE_FAULT.
> 
> I don't understand why we want FGP_CREAT_ONLY semantics.  Who cares if there's a
> page allocated?  KVM already checks that the page is unassigned in the RMP, so
> why does guest_memfd care whether or not the page was _just_ allocated?
> 
> AFAIK, unwinding on failure is completely uninteresting, and arguably undesirable,
> because undoing LAUNCH_UPDATE or PAGE.ADD will affect the measurement, i.e. there
> is no scenario where deleting pages from guest_memfd would allow a restart/resume
> of the build process to truly succeed.


Just for record.  With the following twist to kvm_gmem_populate,
KVM_TDX_INIT_MEM_REGION can use kvm_gmem_populate().  For those who are curious,
I also append the callback implementation at the end.

--

 include/linux/kvm_host.h | 2 ++
 virt/kvm/guest_memfd.c   | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index df957c9f9115..7c86b77f8895 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2460,6 +2460,7 @@ bool kvm_arch_gmem_prepare_needed(struct kvm *kvm);
  *       (passed to @post_populate, and incremented on each iteration
  *       if not NULL)
  * @npages: number of pages to copy from userspace-buffer
+ * @prepare: Allow page allocation to invoke gmem_prepare hook
  * @post_populate: callback to issue for each gmem page that backs the GPA
  *                 range
  * @opaque: opaque data to pass to @post_populate callback
@@ -2473,6 +2474,7 @@ bool kvm_arch_gmem_prepare_needed(struct kvm *kvm);
  * Returns the number of pages that were populated.
  */
 long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
+		       bool prepare,
 		       int (*post_populate)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 					    void __user *src, int order, void *opaque),
 		       void *opaque);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3195ceefe915..18809e6dea8a 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -638,6 +638,7 @@ static int kvm_gmem_undo_get_pfn(struct file *file, struct kvm_memory_slot *slot
 }
 
 long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
+		       bool prepare,
 		       int (*post_populate)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 					    void __user *src, int order, void *opaque),
 		       void *opaque)
@@ -667,7 +668,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages
 		gfn_t this_gfn = gfn + i;
 		kvm_pfn_t pfn;
 
-		ret = __kvm_gmem_get_pfn(file, slot, this_gfn, &pfn, &max_order, false);
+		ret = __kvm_gmem_get_pfn(file, slot, this_gfn, &pfn, &max_order, prepare);
 		if (ret)
 			break;
 
-- 
2.43.2


Here is the callback for KVM_TDX_INIT_MEM_REGION.
Note: the caller of kvm_gmem_populate() acquires mutex_lock(&kvm->slots_lock)
and idx = srcu_read_lock(&kvm->srcu).


struct tdx_gmem_post_populate_arg {
	struct kvm_vcpu *vcpu;
	__u32 flags;
};

static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
				  void __user *src, int order, void *_arg)
{
	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
	struct tdx_gmem_post_populate_arg *arg = _arg;
	struct kvm_vcpu *vcpu = arg->vcpu;
	struct kvm_memory_slot *slot;
	gpa_t gpa = gfn_to_gpa(gfn);
	struct page *page;
	kvm_pfn_t mmu_pfn;
	int ret, i;
	u64 err;

	/* Pin the source page. */
	ret = get_user_pages_fast((unsigned long)src, 1, 0, &page);
	if (ret < 0)
		return ret;
	if (ret != 1)
		return -ENOMEM;

	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
	if (!kvm_slot_can_be_private(slot) || !kvm_mem_is_private(kvm, gfn)) {
		ret = -EFAULT;
		goto out_put_page;
	}

	read_lock(&kvm->mmu_lock);

	ret = kvm_tdp_mmu_get_walk_private_pfn(vcpu, gpa, &mmu_pfn);
	if (ret < 0)
		goto out;
	if (ret > PG_LEVEL_4K) {
		ret = -EINVAL;
		goto out;
	}
	if (mmu_pfn != pfn) {
		ret = -EAGAIN;
		goto out;
	}

	ret = 0;
	do {
		err = tdh_mem_page_add(kvm_tdx, gpa, pfn_to_hpa(pfn),
				       pfn_to_hpa(page_to_pfn(page)), NULL);
	} while (err == TDX_ERROR_SEPT_BUSY);
	if (err) {
		ret = -EIO;
		goto out;
	}

	WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped));
	atomic64_dec(&kvm_tdx->nr_premapped);
	tdx_account_td_pages(vcpu->kvm, PG_LEVEL_4K);

	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
			err = tdh_mr_extend(kvm_tdx, gpa + i, NULL);
			if (err) {
				ret = -EIO;
				break;
			}
		}
	}

out:
	read_unlock(&kvm->mmu_lock);
out_put_page:
	put_page(page);
	return ret;
}

-- 
Isaku Yamahata <isaku.yamahata@intel.com>


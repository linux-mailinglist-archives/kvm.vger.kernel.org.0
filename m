Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188FFE2A03
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 07:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436466AbfJXFip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 01:38:45 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42683 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390947AbfJXFio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 01:38:44 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46zGJ202kzz9sPL; Thu, 24 Oct 2019 16:38:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1571895522; bh=TUkzeiEyrlAUHxalg6s6mY7dJHYRmYW79iZASyM/640=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BWnwSCNk45l4kLN+O6YLQLTdGPX1nJUMXoxXPjEGCZsKz/cxhC8tbMiIzMtnk+H5M
         fTwYEvnoS7a0n8hu0jBrz4GM5BwhRagsTBpHRZTt7CwhcYQDippMFLBbOYUioA2m6r
         wckeQII21TTH8thi0vc8EAnI1F/zutb1zDXrN6xfsU410dhDANOIsVOmdB3gvUzhHC
         SfPYCXQuUA1Qw/Fnd3uixK1YtyWGKPAQOQ4YplqGvNolaeAP5+9O8vcjT17g3K+swb
         vuT8fAWbsn6+V/zHxqmWo7m4+E81NbftMETe/DYZWUilRsoml7/b2q7Afvy5m0gKvI
         dO78GlmiuzQTQ==
Date:   Thu, 24 Oct 2019 14:43:43 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 13/23] KVM: PPC: Book3S HV: Nested: Infrastructure for
 nested hpt guest setup
Message-ID: <20191024034343.GA773@oak.ozlabs.ibm.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
 <20190826062109.7573-14-sjitindarsingh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826062109.7573-14-sjitindarsingh@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 26, 2019 at 04:20:59PM +1000, Suraj Jitindar Singh wrote:
> Add the infrastructure to book3s_hv_nested.c to allow a nested hpt (hash
> page table) guest to be setup. As this patch doesn't add the capability
> of creating or removing mmu translations return H_PARAMETER when an
> attempt to actually run a nested hpt guest is made.
> 
> Add fields to the nested guest struct to store the hpt and the vrma slb
> entry.
> 
> Update kvmhv_update_ptbl_cache() to determine when a nested guest is
> switching from radix to hpt or hpt to radix and perform the required
> setup. A page table (radix) or hpt (hash) must be allocated with any
> existing table being freed and the radix field in the nested guest
> struct being updated under the mmu_lock (this means that when holding
> the mmu_lock the radix field can be tested and the existance of the
> correct type of page table guaranteed). Also remove all of the nest rmap
> entries which belong to this nested guest since a nested rmap entry is
> specific to whether the nested guest is hash or radix.
> 
> When a nested guest is initially created or when the partition table
> entry is empty we assume a radix guest since it is much less expensive
> to allocate a radix page table compared to a hpt.
> 
> The hpt which is allocated in the hypervisor for the nested guest
> (called the shadow hpt) is identical in size to the one allocated in the
> guest hypervisor to ensure a 1-to-1 mapping between page table entries.
> This simplifies handling of the entries however this requirement could
> be relaxed in future if support was added.
> 
> Introduce a hash nested_page_fault function to be envoked when the
> nested guest which experiences a page fault is hash, returns -EINVAL for
> now. Also return -EINVAL when handling the H_TLB_INVALIDATE hcall. Also
> lacking support for the hypervisor paging out a guest page which has
> been mapped through to a nested guest. These 3 portions of functionality
> added in proceeding patches.
> 
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

Small nit below...

> +/* Caller must hold gp->tlb_lock */
> +static int kvmhv_switch_to_radix_nested(struct kvm_nested_guest *gp)
> +{
> +	struct kvm *kvm = gp->l1_host;
> +	pgd_t *pgtable;
> +
> +	/* try to allocate a radix tree */
> +	pgtable = pgd_alloc(kvm->mm);
> +	if (!pgtable) {
> +		pr_err_ratelimited("KVM: Couldn't alloc nested radix tree\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* mmu_lock protects shadow_hpt & radix in nested guest struct */
> +	spin_lock(&kvm->mmu_lock);
> +	kvmppc_free_hpt(&gp->shadow_hpt);
> +	gp->radix = 1;
> +	gp->shadow_pgtable = pgtable;
> +	spin_unlock(&kvm->mmu_lock);
> +
> +	/* remove all nested rmap entries and perform global invalidation */
> +	kvmhv_remove_all_nested_rmap_lpid(kvm, gp->l1_lpid);
> +	kvmhv_flush_lpid(gp->shadow_lpid, gp->radix);

Shouldn't this flush be done using the old value of gp->radix, i.e. 0?
Both because we want to flush the old translations for the guest, and
because we haven't changed the partition table entry for the guest at
this point, so it still says HPT.

> +
> +	return 0;
> +}
> +
> +/* Caller must hold gp->tlb_lock */
> +static int kvmhv_switch_to_hpt_nested(struct kvm_nested_guest *gp, int order)
> +{
> +	struct kvm *kvm = gp->l1_host;
> +	struct kvm_hpt_info info;
> +	int rc;
> +
> +	/* try to allocate an hpt */
> +	rc = kvmppc_allocate_hpt(&info, order);
> +	if (rc) {
> +		pr_err_ratelimited("KVM: Couldn't alloc nested hpt\n");
> +		return rc;
> +	}
> +
> +	/* mmu_lock protects shadow_pgtable & radix in nested guest struct */
> +	spin_lock(&kvm->mmu_lock);
> +	kvmppc_free_pgtable_radix(kvm, gp->shadow_pgtable, gp->shadow_lpid);
> +	pgd_free(kvm->mm, gp->shadow_pgtable);
> +	gp->shadow_pgtable = NULL;
> +	gp->radix = 0;
> +	gp->shadow_hpt = info;
> +	spin_unlock(&kvm->mmu_lock);
> +
> +	/* remove all nested rmap entries and perform global invalidation */
> +	kvmhv_remove_all_nested_rmap_lpid(kvm, gp->l1_lpid);
> +	kvmhv_flush_lpid(gp->shadow_lpid, gp->radix);

Similarly, shouldn't this be a radix flush?

> +
> +	return 0;
> +}

Paul.

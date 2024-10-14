Return-Path: <kvm+bounces-28790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 304D199D503
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 18:53:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4516283E7B
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 16:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 380541BFDF4;
	Mon, 14 Oct 2024 16:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="H8tAaClf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1A4288B1;
	Mon, 14 Oct 2024 16:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728924817; cv=none; b=PExEtUNoGcb5fx1vWUeQZk9jzxE4Ll26vwlxKmVFH9Mb6rsQUUF+pMKb44FydcxcJWFGFbXymU/GnTH48kA6I5SLRqPxi8l62f1NffLj4/odhK7PB92s6OqdZAug8T7tjYLbewqPj0dYa+Iyb+zFw9hPPwOFy+we9lXCwATB/A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728924817; c=relaxed/simple;
	bh=5/IuWFyTiCxncTxd7OrB6dxxdKxgs3f+l/Ep480x0c0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tgOki6JyagOINAdybX2E+N9rQbpVTFJL6y3Aif62322sXXGIFugT3vUH7M3pnDJ0t2XbB88ZTM686mJ+ggPO/qpsI5dIYurGCUPiVE7oxWek5GJvv0ebzVhKJZisGIlJ304++pQtcFGPyHyKXsimJGMEbiS2H51vWGQmDjhfXA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=H8tAaClf; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EFrv0B020719;
	Mon, 14 Oct 2024 16:52:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=pmaNs7wt7wpKejAxtezcX3Zt
	77+U50H4OCEwJZk53jQ=; b=H8tAaClfW+GC5oznlb3+jS2Bpvw5zFGHkxQrxpAn
	qwzeSbOpyiD04pmNckD3F2+qegI1eGusSS++rMGVWGMSg3pK7rTQ0LcJWNXx8WK8
	tSSm+hW3jzYbYHET1BT+xMvsU6FTBbaKEepPcRPfvbLwBoUGA+3aN2E44swqmrjb
	EfkIT/TQUlHebdBpScOKnjNtjmbHNQYfanJJnw8UamukIsaURaHllmVkz2edii3L
	noBCMKAqjxAfE2PLWAOX5jppITklgWB2VHbKogUAyRu8J2xmXmUqTJyrlcJeLxmA
	+Llr4pIuXCqyOzfw5IstI/ZJrouxpRK5jsA4EOfGC5vpSQ==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4296b7r4n3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 16:52:43 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 49EGqghK008224
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 16:52:42 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Mon, 14 Oct 2024 09:52:40 -0700
Date: Mon, 14 Oct 2024 09:52:40 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
To: Fuad Tabba <tabba@google.com>
CC: <kvm@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-mm@kvack.org>, <pbonzini@redhat.com>, <chenhuacai@kernel.org>,
        <mpe@ellerman.id.au>, <anup@brainfault.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <seanjc@google.com>,
        <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <willy@infradead.org>,
        <akpm@linux-foundation.org>, <xiaoyao.li@intel.com>,
        <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
        <jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
        <yu.c.zhang@linux.intel.com>, <isaku.yamahata@intel.com>,
        <mic@digikod.net>, <vbabka@suse.cz>, <vannapurve@google.com>,
        <ackerleytng@google.com>, <mail@maciej.szmigiero.name>,
        <david@redhat.com>, <michael.roth@amd.com>, <wei.w.wang@intel.com>,
        <liam.merwick@oracle.com>, <isaku.yamahata@gmail.com>,
        <kirill.shutemov@linux.intel.com>, <suzuki.poulose@arm.com>,
        <steven.price@arm.com>, <quic_mnalajal@quicinc.com>,
        <quic_tsoni@quicinc.com>, <quic_svaddagi@quicinc.com>,
        <quic_cvanscha@quicinc.com>, <quic_pderrin@quicinc.com>,
        <quic_pheragu@quicinc.com>, <catalin.marinas@arm.com>,
        <james.morse@arm.com>, <yuzenghui@huawei.com>,
        <oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
        <qperret@google.com>, <keirf@google.com>, <roypat@amazon.co.uk>,
        <shuah@kernel.org>, <hch@infradead.org>, <jgg@nvidia.com>,
        <rientjes@google.com>, <jhubbard@nvidia.com>, <fvdl@google.com>,
        <hughd@google.com>, <jthoughton@google.com>
Subject: Re: [PATCH v3 04/11] KVM: guest_memfd: Allow host to mmap
 guest_memfd() pages when shared
Message-ID: <20241011102208348-0700.eberman@hu-eberman-lv.qualcomm.com>
References: <20241010085930.1546800-1-tabba@google.com>
 <20241010085930.1546800-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241010085930.1546800-5-tabba@google.com>
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: eb4WAlsdVG2NAGQMCDg2OlVMDCYCyVmS
X-Proofpoint-ORIG-GUID: eb4WAlsdVG2NAGQMCDg2OlVMDCYCyVmS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 clxscore=1011 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410140121

On Thu, Oct 10, 2024 at 09:59:23AM +0100, Fuad Tabba wrote:
> Add support for mmap() and fault() for guest_memfd in the host.
> The ability to fault in a guest page is contingent on that page
> being shared with the host.
> 
> The guest_memfd PRIVATE memory attribute is not used for two
> reasons. First because it reflects the userspace expectation for
> that memory location, and therefore can be toggled by userspace.
> The second is, although each guest_memfd file has a 1:1 binding
> with a KVM instance, the plan is to allow multiple files per
> inode, e.g. to allow intra-host migration to a new KVM instance,
> without destroying guest_memfd.
> 
> The mapping is restricted to only memory explicitly shared with
> the host. KVM checks that the host doesn't have any mappings for
> private memory via the folio's refcount. To avoid races between
> paths that check mappability and paths that check whether the
> host has any mappings (via the refcount), the folio lock is held
> in while either check is being performed.
> 
> This new feature is gated with a new configuration option,
> CONFIG_KVM_GMEM_MAPPABLE.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Elliot Berman <quic_eberman@quicinc.com>
> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> 
> ---
> 
> Note that the functions kvm_gmem_is_mapped(),
> kvm_gmem_set_mappable(), and int kvm_gmem_clear_mappable() are
> not used in this patch series. They are intended to be used in
> future patches [*], which check and toggle mapability when the
> guest shares/unshares pages with the host.
> 
> [*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.12-v3-pkvm
> 
> ---
>  include/linux/kvm_host.h |  52 +++++++++++
>  virt/kvm/Kconfig         |   4 +
>  virt/kvm/guest_memfd.c   | 185 +++++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      | 138 +++++++++++++++++++++++++++++
>  4 files changed, 379 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index acf85995b582..bda7fda9945e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2527,4 +2527,56 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  				    struct kvm_pre_fault_memory *range);
>  #endif
>  
> +#ifdef CONFIG_KVM_GMEM_MAPPABLE
> +bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn, gfn_t end);
> +bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end);
> +int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end);
> +int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end);
> +int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot, gfn_t start,
> +			       gfn_t end);
> +int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot, gfn_t start,
> +				 gfn_t end);
> +bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot, gfn_t gfn);
> +#else
> +static inline bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn, gfn_t end)
> +{
> +	WARN_ON_ONCE(1);
> +	return false;
> +}
> +static inline bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	WARN_ON_ONCE(1);
> +	return false;
> +}
> +static inline int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EINVAL;
> +}
> +static inline int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start,
> +					  gfn_t end)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EINVAL;
> +}
> +static inline int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot,
> +					     gfn_t start, gfn_t end)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EINVAL;
> +}
> +static inline int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot,
> +					       gfn_t start, gfn_t end)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EINVAL;
> +}
> +static inline bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot,
> +					     gfn_t gfn)
> +{
> +	WARN_ON_ONCE(1);
> +	return false;
> +}
> +#endif /* CONFIG_KVM_GMEM_MAPPABLE */
> +
>  #endif
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index fd6a3010afa8..2cfcb0848e37 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -120,3 +120,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>  config HAVE_KVM_ARCH_GMEM_INVALIDATE
>         bool
>         depends on KVM_PRIVATE_MEM
> +
> +config KVM_GMEM_MAPPABLE
> +       select KVM_PRIVATE_MEM
> +       bool
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index f414646c475b..df3a6f05a16e 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -370,7 +370,184 @@ static void kvm_gmem_init_mount(void)
>  	kvm_gmem_mnt->mnt_flags |= MNT_NOEXEC;
>  }
>  
> +#ifdef CONFIG_KVM_GMEM_MAPPABLE
> +static struct folio *
> +__kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
> +		   gfn_t gfn, kvm_pfn_t *pfn, bool *is_prepared,
> +		   int *max_order);
> +
> +static int gmem_set_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
> +{
> +	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> +	void *xval = xa_mk_value(true);
> +	pgoff_t i;
> +	bool r;
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +	for (i = start; i < end; i++) {
> +		r = xa_err(xa_store(mappable_offsets, i, xval, GFP_KERNEL));

I think it might not be strictly necessary,

> +		if (r)
> +			break;
> +	}
> +	filemap_invalidate_unlock(inode->i_mapping);
> +
> +	return r;
> +}
> +
> +static int gmem_clear_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
> +{
> +	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> +	pgoff_t i;
> +	int r = 0;
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +	for (i = start; i < end; i++) {
> +		struct folio *folio;
> +
> +		/*
> +		 * Holds the folio lock until after checking its refcount,
> +		 * to avoid races with paths that fault in the folio.
> +		 */
> +		folio = kvm_gmem_get_folio(inode, i);

We don't need to allocate the folio here. I think we can use

		folio = filemap_lock_folio(inode, i);
		if (!folio || WARN_ON_ONCE(IS_ERR(folio)))
			continue;

> +		if (WARN_ON_ONCE(IS_ERR(folio)))
> +			continue;
> +
> +		/*
> +		 * Check that the host doesn't have any mappings on clearing
> +		 * the mappable flag, because clearing the flag implies that the
> +		 * memory will be unshared from the host. Therefore, to maintain
> +		 * the invariant that the host cannot access private memory, we
> +		 * need to check that it doesn't have any mappings to that
> +		 * memory before making it private.
> +		 *
> +		 * Two references are expected because of kvm_gmem_get_folio().
> +		 */
> +		if (folio_ref_count(folio) > 2)

If we'd like to be prepared for large folios, it should be
folio_nr_pages(folio) + 1. 

> +			r = -EPERM;
> +		else
> +			xa_erase(mappable_offsets, i);
> +
> +		folio_put(folio);
> +		folio_unlock(folio);
> +
> +		if (r)
> +			break;
> +	}
> +	filemap_invalidate_unlock(inode->i_mapping);
> +
> +	return r;
> +}
> +
> +static bool gmem_is_mappable(struct inode *inode, pgoff_t pgoff)
> +{
> +	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> +	bool r;
> +
> +	filemap_invalidate_lock_shared(inode->i_mapping);
> +	r = xa_find(mappable_offsets, &pgoff, pgoff, XA_PRESENT);
> +	filemap_invalidate_unlock_shared(inode->i_mapping);
> +
> +	return r;
> +}
> +
> +int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
> +{
> +	struct inode *inode = file_inode(slot->gmem.file);
> +	pgoff_t start_off = slot->gmem.pgoff + start - slot->base_gfn;
> +	pgoff_t end_off = start_off + end - start;
> +
> +	return gmem_set_mappable(inode, start_off, end_off);
> +}
> +
> +int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
> +{
> +	struct inode *inode = file_inode(slot->gmem.file);
> +	pgoff_t start_off = slot->gmem.pgoff + start - slot->base_gfn;
> +	pgoff_t end_off = start_off + end - start;
> +
> +	return gmem_clear_mappable(inode, start_off, end_off);
> +}
> +
> +bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot, gfn_t gfn)
> +{
> +	struct inode *inode = file_inode(slot->gmem.file);
> +	unsigned long pgoff = slot->gmem.pgoff + gfn - slot->base_gfn;
> +
> +	return gmem_is_mappable(inode, pgoff);
> +}
> +
> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	/*
> +	 * Holds the folio lock until after checking whether it can be faulted
> +	 * in, to avoid races with paths that change a folio's mappability.
> +	 */
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (!folio)
> +		return VM_FAULT_SIGBUS;
> +
> +	if (folio_test_hwpoison(folio)) {
> +		ret = VM_FAULT_HWPOISON;
> +		goto out;
> +	}
> +
> +	if (!gmem_is_mappable(inode, vmf->pgoff)) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out;
> +	}
> +
> +	if (!folio_test_uptodate(folio)) {
> +		unsigned long nr_pages = folio_nr_pages(folio);
> +		unsigned long i;
> +
> +		for (i = 0; i < nr_pages; i++)
> +			clear_highpage(folio_page(folio, i));
> +
> +		folio_mark_uptodate(folio);
> +	}
> +
> +	vmf->page = folio_file_page(folio, vmf->pgoff);
> +out:
> +	if (ret != VM_FAULT_LOCKED) {
> +		folio_put(folio);
> +		folio_unlock(folio);
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> +	.fault = kvm_gmem_fault,
> +};
> +
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> +	    (VM_SHARED | VM_MAYSHARE)) {
> +		return -EINVAL;
> +	}
> +
> +	file_accessed(file);
> +	vm_flags_set(vma, VM_DONTDUMP);
> +	vma->vm_ops = &kvm_gmem_vm_ops;
> +
> +	return 0;
> +}
> +#else
> +static int gmem_set_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EINVAL;
> +}
> +#define kvm_gmem_mmap NULL
> +#endif /* CONFIG_KVM_GMEM_MAPPABLE */
> +
>  static struct file_operations kvm_gmem_fops = {
> +	.mmap		= kvm_gmem_mmap,
>  	.open		= generic_file_open,
>  	.release	= kvm_gmem_release,
>  	.fallocate	= kvm_gmem_fallocate,
> @@ -557,6 +734,14 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  		goto err_gmem;
>  	}
>  
> +	if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE)) {
> +		err = gmem_set_mappable(file_inode(file), 0, size >> PAGE_SHIFT);
> +		if (err) {
> +			fput(file);
> +			goto err_gmem;
> +		}
> +	}
> +
>  	kvm_get_kvm(kvm);
>  	gmem->kvm = kvm;
>  	xa_init(&gmem->bindings);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 05cbb2548d99..aed9cf2f1685 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3263,6 +3263,144 @@ static int next_segment(unsigned long len, int offset)
>  		return len;
>  }
>  
> +#ifdef CONFIG_KVM_GMEM_MAPPABLE
> +static bool __kvm_gmem_is_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	struct kvm_memslot_iter iter;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
> +		struct kvm_memory_slot *memslot = iter.slot;
> +		gfn_t gfn_start, gfn_end, i;
> +
> +		gfn_start = max(start, memslot->base_gfn);
> +		gfn_end = min(end, memslot->base_gfn + memslot->npages);
> +		if (WARN_ON_ONCE(gfn_start >= gfn_end))
> +			continue;
> +
> +		for (i = gfn_start; i < gfn_end; i++) {
> +			if (!kvm_slot_gmem_is_mappable(memslot, i))
> +				return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
> +bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	bool r;
> +
> +	mutex_lock(&kvm->slots_lock);
> +	r = __kvm_gmem_is_mappable(kvm, start, end);
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	return r;
> +}
> +
> +static bool kvm_gmem_is_pfn_mapped(struct kvm *kvm, struct kvm_memory_slot *memslot, gfn_t gfn_idx)
> +{
> +	struct page *page;
> +	bool is_mapped;
> +	kvm_pfn_t pfn;
> +
> +	/*
> +	 * Holds the folio lock until after checking its refcount,
> +	 * to avoid races with paths that fault in the folio.
> +	 */
> +	if (WARN_ON_ONCE(kvm_gmem_get_pfn_locked(kvm, memslot, gfn_idx, &pfn, NULL)))
> +		return false;
> +
> +	page = pfn_to_page(pfn);
> +
> +	/* Two references are expected because of kvm_gmem_get_pfn_locked(). */
> +	is_mapped = page_ref_count(page) > 2;
> +
> +	put_page(page);
> +	unlock_page(page);
> +
> +	return is_mapped;
> +}
> +
> +static bool __kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	struct kvm_memslot_iter iter;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
> +		struct kvm_memory_slot *memslot = iter.slot;
> +		gfn_t gfn_start, gfn_end, i;
> +
> +		gfn_start = max(start, memslot->base_gfn);
> +		gfn_end = min(end, memslot->base_gfn + memslot->npages);
> +		if (WARN_ON_ONCE(gfn_start >= gfn_end))
> +			continue;
> +
> +		for (i = gfn_start; i < gfn_end; i++) {
> +			if (kvm_gmem_is_pfn_mapped(kvm, memslot, i))
> +				return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	bool r;
> +
> +	mutex_lock(&kvm->slots_lock);
> +	r = __kvm_gmem_is_mapped(kvm, start, end);
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	return r;
> +}
> +
> +static int kvm_gmem_toggle_mappable(struct kvm *kvm, gfn_t start, gfn_t end,
> +				    bool is_mappable)
> +{
> +	struct kvm_memslot_iter iter;
> +	int r = 0;
> +
> +	mutex_lock(&kvm->slots_lock);
> +
> +	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
> +		struct kvm_memory_slot *memslot = iter.slot;
> +		gfn_t gfn_start, gfn_end;
> +
> +		gfn_start = max(start, memslot->base_gfn);
> +		gfn_end = min(end, memslot->base_gfn + memslot->npages);
> +		if (WARN_ON_ONCE(start >= end))
> +			continue;
> +
> +		if (is_mappable)
> +			r = kvm_slot_gmem_set_mappable(memslot, gfn_start, gfn_end);
> +		else
> +			r = kvm_slot_gmem_clear_mappable(memslot, gfn_start, gfn_end);
> +
> +		if (WARN_ON_ONCE(r))
> +			break;
> +	}
> +
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	return r;
> +}
> +
> +int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	return kvm_gmem_toggle_mappable(kvm, start, end, true);
> +}
> +
> +int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	return kvm_gmem_toggle_mappable(kvm, start, end, false);
> +}
> +
> +#endif /* CONFIG_KVM_GMEM_MAPPABLE */
> +
>  /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
>  static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
>  				 void *data, int offset, int len)
> -- 
> 2.47.0.rc0.187.ge670bccf7e-goog
> 


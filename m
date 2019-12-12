Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6104711D636
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 19:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbfLLSt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 13:49:29 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54978 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730261AbfLLSt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 13:49:29 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCInLfG071241;
        Thu, 12 Dec 2019 18:49:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=N7OiLiDxfNSz8gMex3+M5cE14OOq9s6Ys8OUR2rcXG0=;
 b=h4+/GDMX/2KD7HPS7BFf5+6UKN6o+9IWmTFi+k9Z6KG9JJbhOewEUD7LrywEX0LB4p23
 c5eapsksQpZi9Z36/2MoZXDsrHTfHydK7mQcOhlQ5TlcMoBs8JR5n4hX3oZ6H+g4WTL8
 +P60cHjiyp64AxjiAlfzM9g4DDqOL7SeryuvFwMcfrT5U+5nSr8OkkNIpuiVtYghHTOu
 BEgYZa/HboQBJQ6ZaA/vwRg5RVB8JbbJL/LHOsMSNNHtEbvfCUa2NvRyruO9HrRuVguq
 Xpaq4DGvC/ViSZN5kEGxdr/fkNUJMZBdMETE753mmiudW7D2bDVb5GSo161AnxwLK9Ag Dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wr4qrvtsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 18:49:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCIiCUX192075;
        Thu, 12 Dec 2019 18:47:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wumu4htc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 18:47:20 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBCIlIhc002062;
        Thu, 12 Dec 2019 18:47:19 GMT
Received: from [192.168.14.112] (/109.65.223.49)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Dec 2019 10:47:18 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v5 2/2] kvm: Use huge pages for DAX-backed files
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191212182238.46535-3-brho@google.com>
Date:   Thu, 12 Dec 2019 20:47:13 +0200
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <06108004-1720-41EB-BCAB-BFA8FEBF4772@oracle.com>
References: <20191212182238.46535-1-brho@google.com>
 <20191212182238.46535-3-brho@google.com>
To:     Barret Rhoden <brho@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 12 Dec 2019, at 20:22, Barret Rhoden <brho@google.com> wrote:
>=20
> This change allows KVM to map DAX-backed files made of huge pages with
> huge mappings in the EPT/TDP.

This change isn=E2=80=99t only relevant for TDP. It also affects when =
KVM use shadow-paging.
See how FNAME(page_fault)() calls transparent_hugepage_adjust().

>=20
> DAX pages are not PageTransCompound.  The existing check is trying to
> determine if the mapping for the pfn is a huge mapping or not.

I would rephrase =E2=80=9CThe existing check is trying to determine if =
the pfn
is mapped as part of a transparent huge-page=E2=80=9D.

> For
> non-DAX maps, e.g. hugetlbfs, that means checking PageTransCompound.

This is not related to hugetlbfs but rather THP.

> For DAX, we can check the page table itself.
>=20
> Note that KVM already faulted in the page (or huge page) in the host's
> page table, and we hold the KVM mmu spinlock.  We grabbed that lock in
> kvm_mmu_notifier_invalidate_range_end, before checking the mmu seq.
>=20
> Signed-off-by: Barret Rhoden <brho@google.com>

I don=E2=80=99t think the right place to change for this functionality =
is transparent_hugepage_adjust()
which is meant to handle PFNs that are mapped as part of a transparent =
huge-page.

For example, this would prevent mapping DAX-backed file page as 1GB.
As transparent_hugepage_adjust() only handles the case (level =3D=3D =
PT_PAGE_TABLE_LEVEL).

As you are parsing the page-tables to discover the page-size the PFN is =
mapped in,
I think you should instead modify kvm_host_page_size() to parse =
page-tables instead
of rely on vma_kernel_pagesize() (Which relies on =
vma->vm_ops->pagesize()) in case
of is_zone_device_page().
The main complication though of doing this is that at this point you =
don=E2=80=99t yet have the PFN
that is retrieved by try_async_pf(). So maybe you should consider =
modifying the order of calls
in tdp_page_fault() & FNAME(page_fault)().

-Liran

> ---
> arch/x86/kvm/mmu/mmu.c | 31 +++++++++++++++++++++++++++----
> 1 file changed, 27 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7269130ea5e2..ea8f6951398b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3328,6 +3328,30 @@ static void direct_pte_prefetch(struct kvm_vcpu =
*vcpu, u64 *sptep)
> 	__direct_pte_prefetch(vcpu, sp, sptep);
> }
>=20
> +static bool pfn_is_huge_mapped(struct kvm *kvm, gfn_t gfn, kvm_pfn_t =
pfn)
> +{
> +	struct page *page =3D pfn_to_page(pfn);
> +	unsigned long hva;
> +
> +	if (!is_zone_device_page(page))
> +		return PageTransCompoundMap(page);
> +
> +	/*
> +	 * DAX pages do not use compound pages.  The page should have =
already
> +	 * been mapped into the host-side page table during =
try_async_pf(), so
> +	 * we can check the page tables directly.
> +	 */
> +	hva =3D gfn_to_hva(kvm, gfn);
> +	if (kvm_is_error_hva(hva))
> +		return false;
> +
> +	/*
> +	 * Our caller grabbed the KVM mmu_lock with a successful
> +	 * mmu_notifier_retry, so we're safe to walk the page table.
> +	 */
> +	return dev_pagemap_mapping_shift(hva, current->mm) > PAGE_SHIFT;
> +}
> +
> static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
> 					gfn_t gfn, kvm_pfn_t *pfnp,
> 					int *levelp)
> @@ -3342,8 +3366,8 @@ static void transparent_hugepage_adjust(struct =
kvm_vcpu *vcpu,
> 	 * here.
> 	 */
> 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
> -	    !kvm_is_zone_device_pfn(pfn) && level =3D=3D =
PT_PAGE_TABLE_LEVEL &&
> -	    PageTransCompoundMap(pfn_to_page(pfn))) {
> +	    level =3D=3D PT_PAGE_TABLE_LEVEL &&
> +	    pfn_is_huge_mapped(vcpu->kvm, gfn, pfn)) {
> 		unsigned long mask;
>=20
> 		/*
> @@ -5957,8 +5981,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct =
kvm *kvm,
> 		 * mapping if the indirect sp has level =3D 1.
> 		 */
> 		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
> -		    !kvm_is_zone_device_pfn(pfn) &&
> -		    PageTransCompoundMap(pfn_to_page(pfn))) {
> +		    pfn_is_huge_mapped(kvm, sp->gfn, pfn)) {
> 			pte_list_remove(rmap_head, sptep);
>=20
> 			if (kvm_available_flush_tlb_with_range())
> --=20
> 2.24.0.525.g8f36a354ae-goog
>=20


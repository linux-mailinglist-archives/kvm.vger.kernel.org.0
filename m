Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA0511CD49
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 13:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbfLLMfb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 07:35:31 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57008 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729177AbfLLMfb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 07:35:31 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCCTpGa128359;
        Thu, 12 Dec 2019 12:34:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=n1JBRyyfCwsCHYv3CHqoGwd85kLedGZ22Wnm/zj+jG0=;
 b=OT/1j1tK0abiy5wwnE5NhUn83CiDA9dfgm1NfceOVUHSKUPTBAcIbhrXPAXH9jRLaP5L
 sEeIBsq33bMGm5iaRBN3uIHjy/67+I+GDiHF46ySgbH4ClSK4DurTiNi/FT9gr/SHq2/
 8j5f7gtDq5k/Wbqs4mpz9JC29JEqEBSR6bgOaHZ3QO2BjkthdbIDYafAGTVdNwpnKVd5
 8/kuWWFDeL/tFVS2aZLaQeXw89An+FXsY/Gk+MiTtbNXlJCiyEkZAOOfVKgUaYeSE7wd
 wsBk/hW/fociplvOOdTgHM8eFK2D7gYK5AWqEJRaKrKCtUpV8B7ahVz0voPx6UD/o02b tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wr4qrtn4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 12:34:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCCYBjl123101;
        Thu, 12 Dec 2019 12:34:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wumvy3ffe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 12:34:20 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBCCXhC4029770;
        Thu, 12 Dec 2019 12:33:43 GMT
Received: from [192.168.14.112] (/109.65.223.49)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Dec 2019 04:33:42 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v4 2/2] kvm: Use huge pages for DAX-backed files
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191211213207.215936-3-brho@google.com>
Date:   Thu, 12 Dec 2019 14:33:36 +0200
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <376DB19A-4EF1-42BF-A73C-741558E397D4@oracle.com>
References: <20191211213207.215936-1-brho@google.com>
 <20191211213207.215936-3-brho@google.com>
To:     Barret Rhoden <brho@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 11 Dec 2019, at 23:32, Barret Rhoden <brho@google.com> wrote:
>=20
> This change allows KVM to map DAX-backed files made of huge pages with
> huge mappings in the EPT/TDP.
>=20
> DAX pages are not PageTransCompound.  The existing check is trying to
> determine if the mapping for the pfn is a huge mapping or not.  For
> non-DAX maps, e.g. hugetlbfs, that means checking PageTransCompound.
> For DAX, we can check the page table itself.

For hugetlbfs pages, tdp_page_fault() -> mapping_level() -> =
host_mapping_level() -> kvm_host_page_size() -> vma_kernel_pagesize()
will return the page-size of the hugetlbfs without the need to parse the =
page-tables.
See vma->vm_ops->pagesize() callback implementation at =
hugetlb_vm_ops->pagesize()=3D=3Dhugetlb_vm_op_pagesize().

Only for pages that were originally mapped as small-pages and later =
merged to larger pages by THP, there is a need to check for =
PageTransCompound(). Again, instead of parsing page-tables.

Therefore, it seems more logical to me that:
(a) If DAX-backed files are mapped as large-pages to userspace, it =
should be reflected in vma->vm_ops->page_size() of that mapping. Causing =
kvm_host_page_size() to return the right size without the need to parse =
the page-tables.
(b) If DAX-backed files small-pages can be later merged to large-pages =
by THP, then the =E2=80=9Cstruct page=E2=80=9D of these pages should be =
modified as usual to make PageTransCompound() return true for them. =
I=E2=80=99m not highly familiar with this mechanism, but I would expect =
THP to be able to merge DAX-backed files small-pages to large-pages in =
case DAX provides =E2=80=9Cstruct page=E2=80=9D for the DAX pages.

>=20
> Note that KVM already faulted in the page (or huge page) in the host's
> page table, and we hold the KVM mmu spinlock.  We grabbed that lock in
> kvm_mmu_notifier_invalidate_range_end, before checking the mmu seq.
>=20
> Signed-off-by: Barret Rhoden <brho@google.com>
> ---
> arch/x86/kvm/mmu/mmu.c | 36 ++++++++++++++++++++++++++++++++----
> 1 file changed, 32 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6f92b40d798c..cd07bc4e595f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3384,6 +3384,35 @@ static int kvm_handle_bad_page(struct kvm_vcpu =
*vcpu, gfn_t gfn, kvm_pfn_t pfn)
> 	return -EFAULT;
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
> +	switch (dev_pagemap_mapping_shift(hva, current->mm)) {

Doesn=E2=80=99t dev_pagemap_mapping_shift() get =E2=80=9Cstruct page=E2=80=
=9D as first parameter?
Was this changed by a commit I missed?

-Liran

> +	case PMD_SHIFT:
> +	case PUD_SIZE:
> +		return true;
> +	}
> +	return false;
> +}
> +
> static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
> 					gfn_t gfn, kvm_pfn_t *pfnp,
> 					int *levelp)
> @@ -3398,8 +3427,8 @@ static void transparent_hugepage_adjust(struct =
kvm_vcpu *vcpu,
> 	 * here.
> 	 */
> 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
> -	    !kvm_is_zone_device_pfn(pfn) && level =3D=3D =
PT_PAGE_TABLE_LEVEL &&
> -	    PageTransCompoundMap(pfn_to_page(pfn)) &&
> +	    level =3D=3D PT_PAGE_TABLE_LEVEL &&
> +	    pfn_is_huge_mapped(vcpu->kvm, gfn, pfn) &&
> 	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) =
{
> 		unsigned long mask;
> 		/*
> @@ -6015,8 +6044,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct =
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


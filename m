Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20D9611D463
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbfLLRpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:45:36 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45478 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729791AbfLLRpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 12:45:36 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCHir5l016867;
        Thu, 12 Dec 2019 17:45:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=gQua6smOLP0Ap8OTragAs0MkFrsy/Ykvuffp+G43BKs=;
 b=NtRjRpL11/RyXPiKkIEAnV5dL5Q4UIGwnzyLWXRQrtE03BjvxPNc4KNOwMdEp58mipCD
 hFVqGRdBkgIJGCJ/BD7hIwVVl8aE+7vrQmOzM/RtgvWmG3uSzuWYooKVa6HvE+vvHVki
 OlH32s3L5UaDB7EfgwKHJMtD674O3NgnC3JdxVBPVCRH6YDiNu+pUhhejqsRqJnBiNSV
 spMH6ruJX6WABOsvba+lR2RO8wM8//+G+da8jX2eNnY6DyHrp9gQS3PLBJg0o8kPCKBo
 j7lubFioDlElvq2t+e3SxKB7YDkeVJe2ATWOht+moJr8kLX2d1FOSzTz/DJJE6zDTQhl Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wr4qrvg2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 17:45:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCHhebj177187;
        Thu, 12 Dec 2019 17:45:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wumw0na7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 17:45:28 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBCHjQYl006497;
        Thu, 12 Dec 2019 17:45:26 GMT
Received: from [192.168.14.112] (/109.65.223.49)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Dec 2019 09:45:26 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v4 2/2] kvm: Use huge pages for DAX-backed files
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191212173413.GC3163@linux.intel.com>
Date:   Thu, 12 Dec 2019 19:45:21 +0200
Cc:     Barret Rhoden <brho@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <57D547EE-2627-475D-84AF-0B080433DC52@oracle.com>
References: <20191211213207.215936-1-brho@google.com>
 <20191211213207.215936-3-brho@google.com>
 <20191212173413.GC3163@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120139
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 12 Dec 2019, at 19:34, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Wed, Dec 11, 2019 at 04:32:07PM -0500, Barret Rhoden wrote:
>> This change allows KVM to map DAX-backed files made of huge pages =
with
>> huge mappings in the EPT/TDP.
>>=20
>> DAX pages are not PageTransCompound.  The existing check is trying to
>> determine if the mapping for the pfn is a huge mapping or not.  For
>> non-DAX maps, e.g. hugetlbfs, that means checking PageTransCompound.
>> For DAX, we can check the page table itself.
>>=20
>> Note that KVM already faulted in the page (or huge page) in the =
host's
>> page table, and we hold the KVM mmu spinlock.  We grabbed that lock =
in
>> kvm_mmu_notifier_invalidate_range_end, before checking the mmu seq.
>>=20
>> Signed-off-by: Barret Rhoden <brho@google.com>
>> ---
>> arch/x86/kvm/mmu/mmu.c | 36 ++++++++++++++++++++++++++++++++----
>> 1 file changed, 32 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 6f92b40d798c..cd07bc4e595f 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -3384,6 +3384,35 @@ static int kvm_handle_bad_page(struct kvm_vcpu =
*vcpu, gfn_t gfn, kvm_pfn_t pfn)
>> 	return -EFAULT;
>> }
>>=20
>> +static bool pfn_is_huge_mapped(struct kvm *kvm, gfn_t gfn, kvm_pfn_t =
pfn)
>> +{
>> +	struct page *page =3D pfn_to_page(pfn);
>> +	unsigned long hva;
>> +
>> +	if (!is_zone_device_page(page))
>> +		return PageTransCompoundMap(page);
>> +
>> +	/*
>> +	 * DAX pages do not use compound pages.  The page should have =
already
>> +	 * been mapped into the host-side page table during =
try_async_pf(), so
>> +	 * we can check the page tables directly.
>> +	 */
>> +	hva =3D gfn_to_hva(kvm, gfn);
>> +	if (kvm_is_error_hva(hva))
>> +		return false;
>> +
>> +	/*
>> +	 * Our caller grabbed the KVM mmu_lock with a successful
>> +	 * mmu_notifier_retry, so we're safe to walk the page table.
>> +	 */
>> +	switch (dev_pagemap_mapping_shift(hva, current->mm)) {
>> +	case PMD_SHIFT:
>> +	case PUD_SIZE:
>=20
> I assume this means DAX can have 1GB pages?  I ask because KVM's THP =
logic
> has historically relied on THP only supporting 2MB.  I cleaned this up =
in
> a recent series[*], which is in kvm/queue, but I obviously didn't =
actually
> test whether or not KVM would correctly handle 1GB non-hugetlbfs =
pages.

KVM doesn=E2=80=99t handle 1GB correctly for all types of non-hugetlbfs =
pages.
One example we have noticed internally but haven=E2=80=99t submitted an =
upstream patch yet is
for pages without =E2=80=9Cstruct page=E2=80=9D. As in this case, =
hva_to_pfn() will notice vma->vm_flags have VM_PFNMAP set
and call hva_to_pfn_remapped() -> follow_pfn().
However, follow_pfn() currently just calls follow_pte() which use =
__follow_pte_pmd() that doesn=E2=80=99t handle a huge PUD entry.

>=20
> The easiest thing is probably to rebase on kvm/queue.  You'll need to =
do
> that anyways, and I suspect doing so will help shake out any hiccups.
>=20
> [*] =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lkml.kernel.org_r_2=
0191206235729.29263-2D1-2Dsean.j.christopherson-40intel.com&d=3DDwIBAg&c=3D=
RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryI=
DGQr-yKXPNGZbpTx0&m=3DLk-PXE125WU3GWJOV4U4crsSEFx7f5AUmRJhkrfIeAE&s=3DBIo4=
tnL4OfswRQ2QKfTs9VYScLU5lBy2pwzePBnHow8&e=3D=20
>=20
>> +		return true;
>> +	}
>> +	return false;
>> +}
>> +
>> static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>> 					gfn_t gfn, kvm_pfn_t *pfnp,
>> 					int *levelp)
>> @@ -3398,8 +3427,8 @@ static void transparent_hugepage_adjust(struct =
kvm_vcpu *vcpu,
>> 	 * here.
>> 	 */
>> 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
>> -	    !kvm_is_zone_device_pfn(pfn) && level =3D=3D =
PT_PAGE_TABLE_LEVEL &&
>> -	    PageTransCompoundMap(pfn_to_page(pfn)) &&
>> +	    level =3D=3D PT_PAGE_TABLE_LEVEL &&
>> +	    pfn_is_huge_mapped(vcpu->kvm, gfn, pfn) &&
>> 	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) =
{
>> 		unsigned long mask;
>> 		/*
>> @@ -6015,8 +6044,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct =
kvm *kvm,
>> 		 * mapping if the indirect sp has level =3D 1.
>> 		 */
>> 		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
>> -		    !kvm_is_zone_device_pfn(pfn) &&
>> -		    PageTransCompoundMap(pfn_to_page(pfn))) {
>> +		    pfn_is_huge_mapped(kvm, sp->gfn, pfn)) {
>> 			pte_list_remove(rmap_head, sptep);
>>=20
>> 			if (kvm_available_flush_tlb_with_range())
>> --=20
>> 2.24.0.525.g8f36a354ae-goog
>>=20


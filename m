Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D09B11D439
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbfLLRj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:39:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44040 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730023AbfLLRj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 12:39:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCHYwVn025285;
        Thu, 12 Dec 2019 17:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=GZgjwmhgJteaBjf2zFdb4pvniK3k7AXpKNNZw7iTccY=;
 b=mdpZazkoBsoxr98lQVSyw7xF17N24a+flOtp+DrYxaJQvvsbfJq5mAhzix7rohiPK/cY
 f38m3wBvY7QE4/vCoF6teyEoE2E/dSz5DrQ6WlhRum0SNFcJObw1EDlHb0TLadjAEBr9
 xm2DnqW0ieCXFyJT9F+tz0uEUiWyiKV2vqA3Xqx7t27nncGq4LvS5dX7d/CkmD8FPop4
 MnsDr8YpV7vOVgA76OfE8/uBvdfJGA75p1KN8vnq5crKgsFU4H926Q5PTaiJUJTR0uD8
 /yUC75DM2wL84/NVhB5bDyGNP6o++4uu2KAUEG974+DHmARYu18iEQ42BATPn9KsoQYl ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wrw4nhcw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 17:39:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCHdKjS179849;
        Thu, 12 Dec 2019 17:39:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wumu4et8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 17:39:46 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBCHdUmC012456;
        Thu, 12 Dec 2019 17:39:30 GMT
Received: from [192.168.14.112] (/109.65.223.49)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Dec 2019 09:39:30 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v4 2/2] kvm: Use huge pages for DAX-backed files
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <CAPcyv4gpYF=D323G+69FhFZw4i5W-15_wTRa1xNPdmear0phTw@mail.gmail.com>
Date:   Thu, 12 Dec 2019 19:39:25 +0200
Cc:     Barret Rhoden <brho@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Zeng, Jason" <jason.zeng@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F19843AB-1974-4E79-A85B-9AE00D58E192@oracle.com>
References: <20191211213207.215936-1-brho@google.com>
 <20191211213207.215936-3-brho@google.com>
 <376DB19A-4EF1-42BF-A73C-741558E397D4@oracle.com>
 <CAPcyv4gpYF=D323G+69FhFZw4i5W-15_wTRa1xNPdmear0phTw@mail.gmail.com>
To:     Dan Williams <dan.j.williams@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 12 Dec 2019, at 18:54, Dan Williams <dan.j.williams@intel.com> =
wrote:
>=20
> On Thu, Dec 12, 2019 at 4:34 AM Liran Alon <liran.alon@oracle.com> =
wrote:
>>=20
>>=20
>>=20
>>> On 11 Dec 2019, at 23:32, Barret Rhoden <brho@google.com> wrote:
>>>=20
>>> This change allows KVM to map DAX-backed files made of huge pages =
with
>>> huge mappings in the EPT/TDP.
>>>=20
>>> DAX pages are not PageTransCompound.  The existing check is trying =
to
>>> determine if the mapping for the pfn is a huge mapping or not.  For
>>> non-DAX maps, e.g. hugetlbfs, that means checking PageTransCompound.
>>> For DAX, we can check the page table itself.
>>=20
>> For hugetlbfs pages, tdp_page_fault() -> mapping_level() -> =
host_mapping_level() -> kvm_host_page_size() -> vma_kernel_pagesize()
>> will return the page-size of the hugetlbfs without the need to parse =
the page-tables.
>> See vma->vm_ops->pagesize() callback implementation at =
hugetlb_vm_ops->pagesize()=3D=3Dhugetlb_vm_op_pagesize().
>>=20
>> Only for pages that were originally mapped as small-pages and later =
merged to larger pages by THP, there is a need to check for =
PageTransCompound(). Again, instead of parsing page-tables.
>>=20
>> Therefore, it seems more logical to me that:
>> (a) If DAX-backed files are mapped as large-pages to userspace, it =
should be reflected in vma->vm_ops->page_size() of that mapping. Causing =
kvm_host_page_size() to return the right size without the need to parse =
the page-tables.
>=20
> A given dax-mapped vma may have mixed page sizes so ->page_size()
> can't be used reliably to enumerating the mapping size.

Naive question: Why don=E2=80=99t split the VMA in this case to multiple =
VMAs with different results for ->page_size()?
What you are describing sounds like DAX is breaking this callback =
semantics in an unpredictable manner.

>=20
>> (b) If DAX-backed files small-pages can be later merged to =
large-pages by THP, then the =E2=80=9Cstruct page=E2=80=9D of these =
pages should be modified as usual to make PageTransCompound() return =
true for them. I=E2=80=99m not highly familiar with this mechanism, but =
I would expect THP to be able to merge DAX-backed files small-pages to =
large-pages in case DAX provides =E2=80=9Cstruct page=E2=80=9D for the =
DAX pages.
>=20
> DAX pages do not participate in THP and do not have the
> PageTransCompound accounting. The only mechanism that records the
> mapping size for dax is the page tables themselves.

What is the rational behind this? Given that DAX pages can be described =
with =E2=80=9Cstruct page=E2=80=9D (i.e. ZONE_DEVICE), what prevents THP =
from manipulating page-tables to merge multiple DAX PFNs to a larger =
page?

-Liran

>=20
>=20
>>=20
>>>=20
>>> Note that KVM already faulted in the page (or huge page) in the =
host's
>>> page table, and we hold the KVM mmu spinlock.  We grabbed that lock =
in
>>> kvm_mmu_notifier_invalidate_range_end, before checking the mmu seq.
>>>=20
>>> Signed-off-by: Barret Rhoden <brho@google.com>
>>> ---
>>> arch/x86/kvm/mmu/mmu.c | 36 ++++++++++++++++++++++++++++++++----
>>> 1 file changed, 32 insertions(+), 4 deletions(-)
>>>=20
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index 6f92b40d798c..cd07bc4e595f 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -3384,6 +3384,35 @@ static int kvm_handle_bad_page(struct =
kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
>>>      return -EFAULT;
>>> }
>>>=20
>>> +static bool pfn_is_huge_mapped(struct kvm *kvm, gfn_t gfn, =
kvm_pfn_t pfn)
>>> +{
>>> +     struct page *page =3D pfn_to_page(pfn);
>>> +     unsigned long hva;
>>> +
>>> +     if (!is_zone_device_page(page))
>>> +             return PageTransCompoundMap(page);
>>> +
>>> +     /*
>>> +      * DAX pages do not use compound pages.  The page should have =
already
>>> +      * been mapped into the host-side page table during =
try_async_pf(), so
>>> +      * we can check the page tables directly.
>>> +      */
>>> +     hva =3D gfn_to_hva(kvm, gfn);
>>> +     if (kvm_is_error_hva(hva))
>>> +             return false;
>>> +
>>> +     /*
>>> +      * Our caller grabbed the KVM mmu_lock with a successful
>>> +      * mmu_notifier_retry, so we're safe to walk the page table.
>>> +      */
>>> +     switch (dev_pagemap_mapping_shift(hva, current->mm)) {
>>=20
>> Doesn=E2=80=99t dev_pagemap_mapping_shift() get =E2=80=9Cstruct =
page=E2=80=9D as first parameter?
>> Was this changed by a commit I missed?
>>=20
>> -Liran
>>=20
>>> +     case PMD_SHIFT:
>>> +     case PUD_SIZE:
>>> +             return true;
>>> +     }
>>> +     return false;
>>> +}
>>> +
>>> static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>>>                                      gfn_t gfn, kvm_pfn_t *pfnp,
>>>                                      int *levelp)
>>> @@ -3398,8 +3427,8 @@ static void transparent_hugepage_adjust(struct =
kvm_vcpu *vcpu,
>>>       * here.
>>>       */
>>>      if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
>>> -         !kvm_is_zone_device_pfn(pfn) && level =3D=3D =
PT_PAGE_TABLE_LEVEL &&
>>> -         PageTransCompoundMap(pfn_to_page(pfn)) &&
>>> +         level =3D=3D PT_PAGE_TABLE_LEVEL &&
>>> +         pfn_is_huge_mapped(vcpu->kvm, gfn, pfn) &&
>>>          !mmu_gfn_lpage_is_disallowed(vcpu, gfn, =
PT_DIRECTORY_LEVEL)) {
>>>              unsigned long mask;
>>>              /*
>>> @@ -6015,8 +6044,7 @@ static bool =
kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>>>               * mapping if the indirect sp has level =3D 1.
>>>               */
>>>              if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
>>> -                 !kvm_is_zone_device_pfn(pfn) &&
>>> -                 PageTransCompoundMap(pfn_to_page(pfn))) {
>>> +                 pfn_is_huge_mapped(kvm, sp->gfn, pfn)) {
>>>                      pte_list_remove(rmap_head, sptep);
>>>=20
>>>                      if (kvm_available_flush_tlb_with_range())
>>> --
>>> 2.24.0.525.g8f36a354ae-goog
>>>=20
>>=20


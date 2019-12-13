Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E83F11E948
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 18:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfLMReL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 12:34:11 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59956 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728109AbfLMReL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 12:34:11 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDHTOdn127556;
        Fri, 13 Dec 2019 17:32:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=Xxj7XcIX3BAsTswq61qTm+XpYP5WHVykPf5srMGAjkc=;
 b=mAOGIVqWLZik4enG0nrF6/laKdv7t2RczO8djlQtfN1vtwtXeVg2Ju0XmIywCGa/TaDr
 SJijmblW5eEjQAIlrIpNNOmGKKqy38a3v+vzlJZITA3UenYbGsK7tfuLoAk8GhFphcG5
 rZ0zpDqupDJKZNzJ9WTNUnas5KgrJ+u1a0gKdnj6mWBiGmk5c8GPHt/tWC9MEO9ca7CI
 Nc6QgFGbHW8RDcy57OkK/tSvYT0MVJI4AnZSqLs8LNLwfDzbfBcO2mgXfbkrA6fWFdGP
 diPjDj9RxIhedUnkiV0pxMkjK1SO/1FsNXvx9LZwWsKvujwIadKwVR6VK9mIhXurfV/R Ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wr41qtdeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 17:32:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDHSpew164562;
        Fri, 13 Dec 2019 17:32:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wvb99gs9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 17:32:02 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBDHW0Hb004855;
        Fri, 13 Dec 2019 17:32:00 GMT
Received: from [192.168.14.112] (/109.65.223.49)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 09:32:00 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v5 2/2] kvm: Use huge pages for DAX-backed files
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191213171950.GA31552@linux.intel.com>
Date:   Fri, 13 Dec 2019 19:31:55 +0200
Cc:     Barret Rhoden <brho@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <4A5E026D-53E6-4F30-A80D-B5E6AA07A786@oracle.com>
References: <20191212182238.46535-1-brho@google.com>
 <20191212182238.46535-3-brho@google.com>
 <06108004-1720-41EB-BCAB-BFA8FEBF4772@oracle.com>
 <ED482280-CB47-4AB6-9E7E-EEE7848E0F8B@oracle.com>
 <f8e948ff-6a2a-a6d6-9d8e-92b93003354a@google.com>
 <65FB6CC1-3AD2-4D6F-9481-500BD7037203@oracle.com>
 <20191213171950.GA31552@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912130138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912130138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 13 Dec 2019, at 19:19, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Fri, Dec 13, 2019 at 03:07:31AM +0200, Liran Alon wrote:
>>=20
>>> On 12 Dec 2019, at 21:55, Barret Rhoden <brho@google.com> wrote:
>>>=20
>>>>>> Note that KVM already faulted in the page (or huge page) in the =
host's
>>>>>> page table, and we hold the KVM mmu spinlock.  We grabbed that =
lock in
>>>>>> kvm_mmu_notifier_invalidate_range_end, before checking the mmu =
seq.
>>>>>>=20
>>>>>> Signed-off-by: Barret Rhoden <brho@google.com>
>>>>>=20
>>>>> I don=E2=80=99t think the right place to change for this =
functionality is
>>>>> transparent_hugepage_adjust() which is meant to handle PFNs that =
are
>>>>> mapped as part of a transparent huge-page.
>>>>>=20
>>>>> For example, this would prevent mapping DAX-backed file page as =
1GB.  As
>>>>> transparent_hugepage_adjust() only handles the case (level =3D=3D
>>>>> PT_PAGE_TABLE_LEVEL).
>=20
> Teaching thp_adjust() how to handle 1GB wouldn't be a bad thing.  It's
> unlikely THP itself will support 1GB pages any time soon, but having =
the
> logic there wouldn't hurt anything.

I agree.

>=20
>>>>> As you are parsing the page-tables to discover the page-size the =
PFN is
>>>>> mapped in, I think you should instead modify kvm_host_page_size() =
to
>>>>> parse page-tables instead of rely on vma_kernel_pagesize() (Which =
relies
>>>>> on vma->vm_ops->pagesize()) in case of is_zone_device_page().
>>>>>=20
>>>>> The main complication though of doing this is that at this point =
you
>>>>> don=E2=80=99t yet have the PFN that is retrieved by =
try_async_pf(). So maybe you
>>>>> should consider modifying the order of calls in tdp_page_fault() &
>>>>> FNAME(page_fault)().
>>>>>=20
>>>>> -Liran
>>>> Or alternatively when thinking about it more, maybe just rename
>>>> transparent_hugepage_adjust() to not be specific to THP and better =
handle
>>>> the case of parsing page-tables changing mapping-level to 1GB.
>>>> That is probably easier and more elegant.
>=20
> Agreed.
>=20
>>> I can rename it to hugepage_adjust(), since it's not just THP =
anymore.
>=20
> Or maybe allowed_hugepage_adjust()?  To pair with =
disallowed_hugepage_adjust(),
> which adjusts KVM's page size in the opposite direction to avoid the =
iTLB
> multi-hit issue.
>=20
>>=20
>> Sounds good.
>>=20
>>>=20
>>> I was a little hesitant to change the this to handle 1 GB pages with =
this
>>> patchset at first.  I didn't want to break the non-DAX case stuff by =
doing
>>> so.
>>=20
>> Why would it affect non-DAX case?
>> Your patch should just make hugepage_adjust() to parse page-tables =
only in case is_zone_device_page(). Otherwise, page tables shouldn=E2=80=99=
t be parsed.
>> i.e. THP merged pages should still be detected by =
PageTransCompoundMap().
>=20
> I think what Barret is saying is that teaching thp_adjust() how to do =
1gb
> mappings would naturally affect the code path for THP pages.  But I =
agree
> that it would be superficial.
>=20
>>> Specifically, can a THP page be 1 GB, and if so, how can you tell?  =
If you
>>> can't tell easily, I could walk the page table for all cases, =
instead of
>>> just zone_device().
>=20
> No, THP doesn't currently support 1gb pages.  Expliciting returning
> PMD_SIZE on PageTransCompoundMap() would be a good thing from a =
readability
> perspective.

Right.

>=20
>> I prefer to walk page-tables only for is_zone_device_page().
>>=20
>>>=20
>>> I'd also have to drop the "level =3D=3D PT_PAGE_TABLE_LEVEL" check, =
I think,
>>> which would open this up to hugetlbfs pages (based on the comments). =
 Is
>>> there any reason why that would be a bad idea?
>=20
> No, the "level =3D=3D PT_PAGE_TABLE_LEVEL" check is to filter out the =
case
> where KVM is already planning on using a large page, e.g. when the =
memory
> is backed by hugetlbs.

Right.

>=20
>> KVM already supports mapping 1GB hugetlbfs pages. As level is set to
>> PUD-level by
>> =
tdp_page_fault()->mapping_level()->host_mapping_level()->kvm_host_page_siz=
e()->vma_kernel_pagesize().
>> As VMA which is mmap of hugetlbfs sets vma->vm_ops to =
hugetlb_vm_ops() where
>> hugetlb_vm_op_pagesize() will return appropriate page-size.
>>=20
>> Specifically, I don=E2=80=99t think THP ever merges small pages to =
1GB pages. I think
>> this is why transparent_hugepage_adjust() checks =
PageTransCompoundMap() only
>> in case level =3D=3D PT_PAGE_TABLE_LEVEL. I think you should keep =
this check in
>> the case of !is_zone_device_page().
>=20
> I would add 1gb support for DAX as a third patch in this series.  To =
pave
> the way in patch 2/2, change it to replace "bool pfn_is_huge_mapped()" =
with
> "int host_pfn_mapping_level()", and maybe also renaming =
host_mapping_level()
> to host_vma_mapping_level() to avoid confusion.

I agree.
So also rename kvm_host_page_size() to kvm_host_vma_page_size() :)

>=20
> Then allowed_hugepage_adjust() would look something like:
>=20
> static void allowed_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
> 				    kvm_pfn_t *pfnp, int *levelp, int =
max_level)
> {
> 	kvm_pfn_t pfn =3D *pfnp;
> 	int level =3D *levelp;=09
> 	unsigned long mask;
>=20
> 	if (is_error_noslot_pfn(pfn) || !kvm_is_reserved_pfn(pfn) ||
> 	    level =3D=3D PT_PAGE_TABLE_LEVEL)
> 		return;
>=20
> 	/*
> 	 * mmu_notifier_retry() was successful and mmu_lock is held, so
> 	 * the pmd/pud can't be split from under us.
> 	 */
> 	level =3D host_pfn_mapping_level(vcpu->kvm, gfn, pfn);
>=20
> 	*levelp =3D level =3D min(level, max_level);
> 	mask =3D KVM_PAGES_PER_HPAGE(level) - 1;
> 	VM_BUG_ON((gfn & mask) !=3D (pfn & mask));
> 	*pfnp =3D pfn & ~mask;

Why don=E2=80=99t you still need to kvm_release_pfn_clean() for original =
pfn and kvm_get_pfn() for new huge-page start pfn?

> }

Yep. This is similar to what I had in mind.

Then just put logic of parsing page-tables in case it=E2=80=99s =
is_zone_device_page() or returning PMD_SIZE in case it=E2=80=99s =
PageTransCompoundMap() inside host_pfn_mapping_level(). This make code =
very straight-forward.

-Liran


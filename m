Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD51911DB7F
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 02:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731589AbfLMBHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 20:07:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39090 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727513AbfLMBHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 20:07:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBD10G36157971;
        Fri, 13 Dec 2019 01:07:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=fPXd9WaeWO8tk1E5p/rW9kWN/nN6E2zMrMlpS1GApvM=;
 b=Lul6uFIQmVMejmPBkKC+64VmVUFgk3do7OzMsTJ5C96n59vuXWwlbqn4jLU4EiLT1YAO
 3ILQ7QLF6j7Kf3CBUM+lhP03mt9gaBU+UI7tE0q6ZJSOnChOnfbEo0SuRauhwm+v6LQp
 aHkb1VPX2NQFWYVoYLE5RotbxnH4VdNuHmPe/sgtFjEgR9vSCxtM3qLhghVArn75fWiP
 4AYiRaHSTQAbiphHgwDuGn05de24o91F7u2RTj8ACjfUF9udgLuUGJQsmmIf0ZdIv9Q8
 CrGWw89UTd+aj2hktSYdAKrlXF0w8lqef8WaFvJyahx3/WYlPq/EmoT/QUB6M2GP/R3t 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wr41qpc3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 01:07:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBD13odI061658;
        Fri, 13 Dec 2019 01:07:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wumk72qr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 01:07:39 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBD17bd5024770;
        Fri, 13 Dec 2019 01:07:37 GMT
Received: from [192.168.14.112] (/109.65.223.49)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Dec 2019 17:07:36 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v5 2/2] kvm: Use huge pages for DAX-backed files
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <f8e948ff-6a2a-a6d6-9d8e-92b93003354a@google.com>
Date:   Fri, 13 Dec 2019 03:07:31 +0200
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <65FB6CC1-3AD2-4D6F-9481-500BD7037203@oracle.com>
References: <20191212182238.46535-1-brho@google.com>
 <20191212182238.46535-3-brho@google.com>
 <06108004-1720-41EB-BCAB-BFA8FEBF4772@oracle.com>
 <ED482280-CB47-4AB6-9E7E-EEE7848E0F8B@oracle.com>
 <f8e948ff-6a2a-a6d6-9d8e-92b93003354a@google.com>
To:     Barret Rhoden <brho@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912130006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912130006
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 12 Dec 2019, at 21:55, Barret Rhoden <brho@google.com> wrote:
>=20
> Hi -
>=20
> On 12/12/19 1:49 PM, Liran Alon wrote:
>>> On 12 Dec 2019, at 20:47, Liran Alon <liran.alon@oracle.com> wrote:
>>>=20
>>>=20
>>>=20
>>>> On 12 Dec 2019, at 20:22, Barret Rhoden <brho@google.com> wrote:
>>>>=20
>>>> This change allows KVM to map DAX-backed files made of huge pages =
with
>>>> huge mappings in the EPT/TDP.
>>>=20
>>> This change isn=E2=80=99t only relevant for TDP. It also affects =
when KVM use shadow-paging.
>>> See how FNAME(page_fault)() calls transparent_hugepage_adjust().
>=20
> Cool, I'll drop references to the EPT/TDP from the commit message.
>=20
>>>> DAX pages are not PageTransCompound.  The existing check is trying =
to
>>>> determine if the mapping for the pfn is a huge mapping or not.
>>>=20
>>> I would rephrase =E2=80=9CThe existing check is trying to determine =
if the pfn
>>> is mapped as part of a transparent huge-page=E2=80=9D.
>=20
> Can do.
>=20
>>>=20
>>>> For
>>>> non-DAX maps, e.g. hugetlbfs, that means checking =
PageTransCompound.
>>>=20
>>> This is not related to hugetlbfs but rather THP.
>=20
> I thought that PageTransCompound also returned true for hugetlbfs =
(based off of comments in page-flags.h).  Though I do see the comment =
about the 'level =3D=3D PT_PAGE_TABLE_LEVEL' check excluding hugetlbfs =
pages.
>=20
> Anyway, I'll remove the "e.g. hugetlbfs" from the commit message.
>=20
>>>=20
>>>> For DAX, we can check the page table itself.
>>>>=20
>>>> Note that KVM already faulted in the page (or huge page) in the =
host's
>>>> page table, and we hold the KVM mmu spinlock.  We grabbed that lock =
in
>>>> kvm_mmu_notifier_invalidate_range_end, before checking the mmu seq.
>>>>=20
>>>> Signed-off-by: Barret Rhoden <brho@google.com>
>>>=20
>>> I don=E2=80=99t think the right place to change for this =
functionality is transparent_hugepage_adjust()
>>> which is meant to handle PFNs that are mapped as part of a =
transparent huge-page.
>>>=20
>>> For example, this would prevent mapping DAX-backed file page as 1GB.
>>> As transparent_hugepage_adjust() only handles the case (level =3D=3D =
PT_PAGE_TABLE_LEVEL).
>>>=20
>>> As you are parsing the page-tables to discover the page-size the PFN =
is mapped in,
>>> I think you should instead modify kvm_host_page_size() to parse =
page-tables instead
>>> of rely on vma_kernel_pagesize() (Which relies on =
vma->vm_ops->pagesize()) in case
>>> of is_zone_device_page().
>>> The main complication though of doing this is that at this point you =
don=E2=80=99t yet have the PFN
>>> that is retrieved by try_async_pf(). So maybe you should consider =
modifying the order of calls
>>> in tdp_page_fault() & FNAME(page_fault)().
>>>=20
>>> -Liran
>> Or alternatively when thinking about it more, maybe just rename =
transparent_hugepage_adjust()
>> to not be specific to THP and better handle the case of parsing =
page-tables changing mapping-level to 1GB.
>> That is probably easier and more elegant.
>=20
> I can rename it to hugepage_adjust(), since it's not just THP anymore.

Sounds good.

>=20
> I was a little hesitant to change the this to handle 1 GB pages with =
this patchset at first.  I didn't want to break the non-DAX case stuff =
by doing so.

Why would it affect non-DAX case?
Your patch should just make hugepage_adjust() to parse page-tables only =
in case is_zone_device_page(). Otherwise, page tables shouldn=E2=80=99t =
be parsed.
i.e. THP merged pages should still be detected by =
PageTransCompoundMap().

>=20
> Specifically, can a THP page be 1 GB, and if so, how can you tell?  If =
you can't tell easily, I could walk the page table for all cases, =
instead of just zone_device().

I prefer to walk page-tables only for is_zone_device_page().

>=20
> I'd also have to drop the "level =3D=3D PT_PAGE_TABLE_LEVEL" check, I =
think, which would open this up to hugetlbfs pages (based on the =
comments).  Is there any reason why that would be a bad idea?

KVM already supports mapping 1GB hugetlbfs pages. As level is set to =
PUD-level by =
tdp_page_fault()->mapping_level()->host_mapping_level()->kvm_host_page_siz=
e()->vma_kernel_pagesize(). As VMA which is mmap of hugetlbfs sets =
vma->vm_ops to hugetlb_vm_ops() where hugetlb_vm_op_pagesize() will =
return appropriate page-size.

Specifically, I don=E2=80=99t think THP ever merges small pages to 1GB =
pages. I think this is why transparent_hugepage_adjust() checks =
PageTransCompoundMap() only in case level =3D=3D PT_PAGE_TABLE_LEVEL. I =
think you should keep this check in the case of !is_zone_device_page().

-Liran

>=20
> Thanks,
>=20
> Barret
>=20


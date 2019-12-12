Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09DBA11D59F
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 19:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730403AbfLLScd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 13:32:33 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38284 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730348AbfLLScc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 13:32:32 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCIL1Y9048633;
        Thu, 12 Dec 2019 18:32:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=VNKl5CWbdSpN+Y7fCNta6wdQX8x1ddy6iAvSnWfUssY=;
 b=I6F3qqoXqHAHEXfCss0+urIzy+fVDLvbYUoR6WTt1/zaJyXu5zkYVrNjt6htgFhl3Lrp
 Y/dPbSU0TOJPFKt/bmFXYIrUlDabL6z5skYUdrW9SHCOJvkW0RGAHdVl4KdMFJidJPdb
 oV7Xfa7fhZf4nWlLdd6OIwFSXNrMxz0qe2THcLZyny8vIZXboJygZqeEI8pvf9iNqHbG
 9vJVue4uRPQHXuWExKYuWe8zLY6ubFxbC3Ro0JOfNl4+aDYlrBeoJGVEeBF1mkn/uzpR
 SiijjmLtLCD9wz78zkPMPTJBuGGR82uEOSRsi6SSUU5YBZvnAoro3c6j+DLFuLlwsLpO uQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wr4qrvr8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 18:32:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCILNfq101182;
        Thu, 12 Dec 2019 18:32:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wumw0vm11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 18:32:24 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBCIWMmE005263;
        Thu, 12 Dec 2019 18:32:22 GMT
Received: from [192.168.14.112] (/109.65.223.49)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Dec 2019 10:32:22 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v4 2/2] kvm: Use huge pages for DAX-backed files
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <CAPcyv4i5ZaiA+KeraXzz-0vs25UGEmZ2ka9Z-PUT3T_7URAFMA@mail.gmail.com>
Date:   Thu, 12 Dec 2019 20:32:17 +0200
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
Message-Id: <5F859A55-C964-4362-9A25-3F4BA72E7326@oracle.com>
References: <20191211213207.215936-1-brho@google.com>
 <20191211213207.215936-3-brho@google.com>
 <376DB19A-4EF1-42BF-A73C-741558E397D4@oracle.com>
 <CAPcyv4gpYF=D323G+69FhFZw4i5W-15_wTRa1xNPdmear0phTw@mail.gmail.com>
 <F19843AB-1974-4E79-A85B-9AE00D58E192@oracle.com>
 <CAPcyv4i5ZaiA+KeraXzz-0vs25UGEmZ2ka9Z-PUT3T_7URAFMA@mail.gmail.com>
To:     Dan Williams <dan.j.williams@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 12 Dec 2019, at 19:59, Dan Williams <dan.j.williams@intel.com> =
wrote:
>=20
> On Thu, Dec 12, 2019 at 9:39 AM Liran Alon <liran.alon@oracle.com> =
wrote:
>>=20
>>=20
>>=20
>>> On 12 Dec 2019, at 18:54, Dan Williams <dan.j.williams@intel.com> =
wrote:
>>>=20
>>> On Thu, Dec 12, 2019 at 4:34 AM Liran Alon <liran.alon@oracle.com> =
wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On 11 Dec 2019, at 23:32, Barret Rhoden <brho@google.com> wrote:
>>>>>=20
>>>>> This change allows KVM to map DAX-backed files made of huge pages =
with
>>>>> huge mappings in the EPT/TDP.
>>>>>=20
>>>>> DAX pages are not PageTransCompound.  The existing check is trying =
to
>>>>> determine if the mapping for the pfn is a huge mapping or not.  =
For
>>>>> non-DAX maps, e.g. hugetlbfs, that means checking =
PageTransCompound.
>>>>> For DAX, we can check the page table itself.
>>>>=20
>>>> For hugetlbfs pages, tdp_page_fault() -> mapping_level() -> =
host_mapping_level() -> kvm_host_page_size() -> vma_kernel_pagesize()
>>>> will return the page-size of the hugetlbfs without the need to =
parse the page-tables.
>>>> See vma->vm_ops->pagesize() callback implementation at =
hugetlb_vm_ops->pagesize()=3D=3Dhugetlb_vm_op_pagesize().
>>>>=20
>>>> Only for pages that were originally mapped as small-pages and later =
merged to larger pages by THP, there is a need to check for =
PageTransCompound(). Again, instead of parsing page-tables.
>>>>=20
>>>> Therefore, it seems more logical to me that:
>>>> (a) If DAX-backed files are mapped as large-pages to userspace, it =
should be reflected in vma->vm_ops->page_size() of that mapping. Causing =
kvm_host_page_size() to return the right size without the need to parse =
the page-tables.
>>>=20
>>> A given dax-mapped vma may have mixed page sizes so ->page_size()
>>> can't be used reliably to enumerating the mapping size.
>>=20
>> Naive question: Why don=E2=80=99t split the VMA in this case to =
multiple VMAs with different results for ->page_size()?
>=20
> Filesystems traditionally have not populated ->pagesize() in their
> vm_operations, there was no compelling reason to go add it and the
> complexity seems prohibitive.

I understand. Though this is technical debt that breaks ->page_size() =
semantics which might cause a complex bug some day...

>=20
>> What you are describing sounds like DAX is breaking this callback =
semantics in an unpredictable manner.
>=20
> It's not unpredictable. vma_kernel_pagesize() returns PAGE_SIZE.

Of course. :) I meant it may be unexpected by the caller.

> Huge
> pages in the page cache has a similar issue.

Ok. I haven=E2=80=99t known that. Thanks for the explanation.

>=20
>>>> (b) If DAX-backed files small-pages can be later merged to =
large-pages by THP, then the =E2=80=9Cstruct page=E2=80=9D of these =
pages should be modified as usual to make PageTransCompound() return =
true for them. I=E2=80=99m not highly familiar with this mechanism, but =
I would expect THP to be able to merge DAX-backed files small-pages to =
large-pages in case DAX provides =E2=80=9Cstruct page=E2=80=9D for the =
DAX pages.
>>>=20
>>> DAX pages do not participate in THP and do not have the
>>> PageTransCompound accounting. The only mechanism that records the
>>> mapping size for dax is the page tables themselves.
>>=20
>> What is the rational behind this? Given that DAX pages can be =
described with =E2=80=9Cstruct page=E2=80=9D (i.e. ZONE_DEVICE), what =
prevents THP from manipulating page-tables to merge multiple DAX PFNs to =
a larger page?
>=20
> THP accounting is a function of the page allocator. ZONE_DEVICE pages
> are excluded from the page allocator. ZONE_DEVICE is just enough
> infrastructure to support pfn_to_page(), page_address(), and
> get_user_pages(). Other page allocator services beyond that are not
> present.

Ok.



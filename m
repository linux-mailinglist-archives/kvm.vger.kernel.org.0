Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD9B11D645
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 19:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbfLLSv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 13:51:26 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57256 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730651AbfLLSv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 13:51:26 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCInQ2N071249;
        Thu, 12 Dec 2019 18:51:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=zaKIVHYYQNYvdMbmkRZGkWLw1vkdwvczrml95DtTJAY=;
 b=XwzJ2fiZ/H6sRv26zjzMBqb3PduV1kwp19YMd2Q8A5BYL3kZtD1/DHph5L4EFEAzt5nF
 ur59alOYzAKyd2qzbopbMwdclz1eeGufSx4SUJj+kltObp02f3880J53RuFPEvVdmWsJ
 W+FJIT4RYh89zg3QZ1Ul+CtUbmMSeaWKxXpJNikqkFRFrfnl2XmOqvKvHqORsZq3LX24
 2lg9hceviEG1xwbriNl0b4eJm6HeSPXd/BZA0LiA9qHBC6BbPW+KKtuRESJBPNErXTdM
 tz/7rJpCg2IiGhuYL7BQR6jrdlMNPIZd/bX1l1CC1HRdKcVgbKPNwE0v8kjjXH0R7bcK 7g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wr4qrvu6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 18:51:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCInqlB097689;
        Thu, 12 Dec 2019 18:51:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2wumk6mu80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 18:51:18 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBCIpGOF018385;
        Thu, 12 Dec 2019 18:51:17 GMT
Received: from [192.168.14.112] (/109.65.223.49)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Dec 2019 10:49:57 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v5 2/2] kvm: Use huge pages for DAX-backed files
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <06108004-1720-41EB-BCAB-BFA8FEBF4772@oracle.com>
Date:   Thu, 12 Dec 2019 20:49:52 +0200
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <ED482280-CB47-4AB6-9E7E-EEE7848E0F8B@oracle.com>
References: <20191212182238.46535-1-brho@google.com>
 <20191212182238.46535-3-brho@google.com>
 <06108004-1720-41EB-BCAB-BFA8FEBF4772@oracle.com>
To:     Barret Rhoden <brho@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120144
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



> On 12 Dec 2019, at 20:47, Liran Alon <liran.alon@oracle.com> wrote:
>=20
>=20
>=20
>> On 12 Dec 2019, at 20:22, Barret Rhoden <brho@google.com> wrote:
>>=20
>> This change allows KVM to map DAX-backed files made of huge pages =
with
>> huge mappings in the EPT/TDP.
>=20
> This change isn=E2=80=99t only relevant for TDP. It also affects when =
KVM use shadow-paging.
> See how FNAME(page_fault)() calls transparent_hugepage_adjust().
>=20
>>=20
>> DAX pages are not PageTransCompound.  The existing check is trying to
>> determine if the mapping for the pfn is a huge mapping or not.
>=20
> I would rephrase =E2=80=9CThe existing check is trying to determine if =
the pfn
> is mapped as part of a transparent huge-page=E2=80=9D.
>=20
>> For
>> non-DAX maps, e.g. hugetlbfs, that means checking PageTransCompound.
>=20
> This is not related to hugetlbfs but rather THP.
>=20
>> For DAX, we can check the page table itself.
>>=20
>> Note that KVM already faulted in the page (or huge page) in the =
host's
>> page table, and we hold the KVM mmu spinlock.  We grabbed that lock =
in
>> kvm_mmu_notifier_invalidate_range_end, before checking the mmu seq.
>>=20
>> Signed-off-by: Barret Rhoden <brho@google.com>
>=20
> I don=E2=80=99t think the right place to change for this functionality =
is transparent_hugepage_adjust()
> which is meant to handle PFNs that are mapped as part of a transparent =
huge-page.
>=20
> For example, this would prevent mapping DAX-backed file page as 1GB.
> As transparent_hugepage_adjust() only handles the case (level =3D=3D =
PT_PAGE_TABLE_LEVEL).
>=20
> As you are parsing the page-tables to discover the page-size the PFN =
is mapped in,
> I think you should instead modify kvm_host_page_size() to parse =
page-tables instead
> of rely on vma_kernel_pagesize() (Which relies on =
vma->vm_ops->pagesize()) in case
> of is_zone_device_page().
> The main complication though of doing this is that at this point you =
don=E2=80=99t yet have the PFN
> that is retrieved by try_async_pf(). So maybe you should consider =
modifying the order of calls
> in tdp_page_fault() & FNAME(page_fault)().
>=20
> -Liran

Or alternatively when thinking about it more, maybe just rename =
transparent_hugepage_adjust()
to not be specific to THP and better handle the case of parsing =
page-tables changing mapping-level to 1GB.
That is probably easier and more elegant.

-Liran



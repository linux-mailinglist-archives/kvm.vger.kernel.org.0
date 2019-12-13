Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E639011E9D4
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 19:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbfLMSLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 13:11:14 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52376 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728690AbfLMSLO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 13:11:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDHsZSq145297;
        Fri, 13 Dec 2019 18:09:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=53hxqoMlf8QDJ3jq3QCCM+0wlUtK9bJy534B+kQRWZ8=;
 b=CFCEeP59ftNzKHEjMdPdb+z5y8cPC0j29595ainF8r4ydRLWPiqvjHP/bL9FFwe4XLF1
 PbS1uslrlTy2u5lHVxGJU9nxGGLN2nhvNAUV0IDvMrbOGttliHlxDLTbz9oIyAosfXLi
 sQ3AO9Ybpqx3Ww4gRCr280fQ23NZ3r/zYhJc/0JUdB9YosdRMNE/QZlsTkZL7o35Lz2E
 yZfG/74A5Ue7C+0nzGvLwR3l5Ek4fO6AgT5XdIyu6lFYsyTdsatLESL1nC+G40VJRnAb
 Yv2NHp/daBXpFmg3EvCSI247OXar4cguohOorUrsKUiTAOsGRSUGg5DViN5idJiTN7QR WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wr4qs2g8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 18:09:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDHsWP8049398;
        Fri, 13 Dec 2019 18:09:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wvdwq33d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 18:09:05 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBDI94mN002972;
        Fri, 13 Dec 2019 18:09:04 GMT
Received: from [192.168.14.112] (/109.65.223.49)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 10:09:04 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v5 2/2] kvm: Use huge pages for DAX-backed files
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191213175031.GC31552@linux.intel.com>
Date:   Fri, 13 Dec 2019 20:08:59 +0200
Cc:     Barret Rhoden <brho@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <08D4A158-617C-4043-AA85-B12EE8F062B9@oracle.com>
References: <20191212182238.46535-1-brho@google.com>
 <20191212182238.46535-3-brho@google.com>
 <06108004-1720-41EB-BCAB-BFA8FEBF4772@oracle.com>
 <ED482280-CB47-4AB6-9E7E-EEE7848E0F8B@oracle.com>
 <f8e948ff-6a2a-a6d6-9d8e-92b93003354a@google.com>
 <65FB6CC1-3AD2-4D6F-9481-500BD7037203@oracle.com>
 <20191213171950.GA31552@linux.intel.com>
 <4A5E026D-53E6-4F30-A80D-B5E6AA07A786@oracle.com>
 <20191213175031.GC31552@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912130142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912130142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 13 Dec 2019, at 19:50, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Fri, Dec 13, 2019 at 07:31:55PM +0200, Liran Alon wrote:
>>=20
>>> On 13 Dec 2019, at 19:19, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>>>=20
>>> Then allowed_hugepage_adjust() would look something like:
>>>=20
>>> static void allowed_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t =
gfn,
>>> 				    kvm_pfn_t *pfnp, int *levelp, int =
max_level)
>>> {
>>> 	kvm_pfn_t pfn =3D *pfnp;
>>> 	int level =3D *levelp;=09
>>> 	unsigned long mask;
>>>=20
>>> 	if (is_error_noslot_pfn(pfn) || !kvm_is_reserved_pfn(pfn) ||
>>> 	    level =3D=3D PT_PAGE_TABLE_LEVEL)
>>> 		return;
>>>=20
>>> 	/*
>>> 	 * mmu_notifier_retry() was successful and mmu_lock is held, so
>>> 	 * the pmd/pud can't be split from under us.
>>> 	 */
>>> 	level =3D host_pfn_mapping_level(vcpu->kvm, gfn, pfn);
>>>=20
>>> 	*levelp =3D level =3D min(level, max_level);
>>> 	mask =3D KVM_PAGES_PER_HPAGE(level) - 1;
>>> 	VM_BUG_ON((gfn & mask) !=3D (pfn & mask));
>>> 	*pfnp =3D pfn & ~mask;
>>=20
>> Why don=E2=80=99t you still need to kvm_release_pfn_clean() for =
original pfn and
>> kvm_get_pfn() for new huge-page start pfn?
>=20
> That code is gone in kvm/queue.  thp_adjust() is now called from
> __direct_map() and FNAME(fetch), and so its pfn adjustment doesn't =
bleed
> back to the page fault handlers.  The only reason the put/get pfn code
> existed was because the page fault handlers called =
kvm_release_pfn_clean()
> on the pfn, i.e. they would have put the wrong pfn.

Ack. Thanks for the explaining this.



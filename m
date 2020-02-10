Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED21158155
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 18:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgBJR1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 12:27:16 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41044 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728059AbgBJR1Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 12:27:16 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01AHOVqI054793
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 12:27:15 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y1tnd8w6t-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 12:27:14 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 10 Feb 2020 17:27:13 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Feb 2020 17:27:07 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01AHR6qO54132752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 17:27:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30F8F52050;
        Mon, 10 Feb 2020 17:27:06 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.7.195])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2CFB952059;
        Mon, 10 Feb 2020 17:27:05 +0000 (GMT)
Subject: Re: [PATCH 01/35] mm:gup/writeback: add callbacks for inaccessible
 pages
To:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        kvm-ppc@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-2-borntraeger@de.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Mon, 10 Feb 2020 18:27:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-2-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021017-4275-0000-0000-0000039FD488
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021017-4276-0000-0000-000038B409F8
Message-Id: <28792269-e053-ac70-a344-45612ee5c729@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_06:2020-02-10,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=2 bulkscore=0 phishscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CC Marc Zyngier for KVM on ARM.  Marc, see below. Will there be any
use for this on KVM/ARM in the future?

CC Sean Christopherson/Tom Lendacky. Any obvious use case for Intel/AMD
to have a callback before a page is used for I/O?

Andrew (or other mm people) any chance to get an ACK for this change?
I could then carry that via s390 or KVM tree. Or if you want to carry
that yourself I can send an updated version (we need to kind of 
synchronize that Linus will pull the KVM changes after the mm changes).

Andrea asked if others would benefit from this, so here are some more
information about this (and I can also put this into the patch
description).  So we have talked to the POWER folks. They do not use
the standard normal memory management, instead they have a hard split
between secure and normal memory. The secure memory  is the handled by
the hypervisor as device memory and the ultravisor and the hypervisor
move this forth and back when needed.

On s390 there is no *separate* pool of physical pages that are secure.
Instead, *any* physical page can be marked as secure or not, by
setting a bit in a per-page data structure that hardware uses to stop
unauthorized access.  (That bit is under control of the ultravisor.)

Note that one side effect of this strategy is that the decision
*which* secure pages to encrypt and then swap out is actually done by
the hypervisor, not the ultravisor.  In our case, the hypervisor is
Linux/KVM, so we're using the regular Linux memory management scheme
(active/inactive LRU lists etc.) to make this decision.  The advantage
is that the Ultravisor code does not need to itself implement any
memory management code, making it a lot simpler.

However, in the end this is why we need the hook into Linux memory
management: once Linux has decided to swap a page out, we need to get
a chance to tell the Ultravisor to "export" the page (i.e., encrypt
its contents and mark it no longer secure).

As outlined below this should be a no-op for anybody not opting in.

Christian                                   

On 07.02.20 12:39, Christian Borntraeger wrote:
> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> With the introduction of protected KVM guests on s390 there is now a
> concept of inaccessible pages. These pages need to be made accessible
> before the host can access them.
> 
> While cpu accesses will trigger a fault that can be resolved, I/O
> accesses will just fail.  We need to add a callback into architecture
> code for places that will do I/O, namely when writeback is started or
> when a page reference is taken.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  include/linux/gfp.h | 6 ++++++
>  mm/gup.c            | 2 ++
>  mm/page-writeback.c | 1 +
>  3 files changed, 9 insertions(+)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index e5b817cb86e7..be2754841369 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -485,6 +485,12 @@ static inline void arch_free_page(struct page *page, int order) { }
>  #ifndef HAVE_ARCH_ALLOC_PAGE
>  static inline void arch_alloc_page(struct page *page, int order) { }
>  #endif
> +#ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
> +static inline int arch_make_page_accessible(struct page *page)
> +{
> +	return 0;
> +}
> +#endif
>  
>  struct page *
>  __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
> diff --git a/mm/gup.c b/mm/gup.c
> index 7646bf993b25..a01262cd2821 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -257,6 +257,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
>  			page = ERR_PTR(-ENOMEM);
>  			goto out;
>  		}
> +		arch_make_page_accessible(page);
>  	}
>  	if (flags & FOLL_TOUCH) {
>  		if ((flags & FOLL_WRITE) &&
> @@ -1870,6 +1871,7 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
>  
>  		VM_BUG_ON_PAGE(compound_head(page) != head, page);
>  
> +		arch_make_page_accessible(page);
>  		SetPageReferenced(page);
>  		pages[*nr] = page;
>  		(*nr)++;
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 2caf780a42e7..0f0bd14571b1 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2806,6 +2806,7 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
>  		inc_lruvec_page_state(page, NR_WRITEBACK);
>  		inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
>  	}
> +	arch_make_page_accessible(page);
>  	unlock_page_memcg(page);

As outlined by Ulrich, we can move the callback after the unlock.

>  	return ret;
>  
> 


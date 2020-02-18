Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16CA6161F8E
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 04:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgBRDgJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 17 Feb 2020 22:36:09 -0500
Received: from mga17.intel.com ([192.55.52.151]:15899 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbgBRDgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 22:36:09 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Feb 2020 19:36:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,455,1574150400"; 
   d="scan'208";a="407944737"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga005.jf.intel.com with ESMTP; 17 Feb 2020 19:36:08 -0800
Received: from fmsmsx101.amr.corp.intel.com (10.18.124.199) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 17 Feb 2020 19:36:08 -0800
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 fmsmsx101.amr.corp.intel.com (10.18.124.199) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 17 Feb 2020 19:36:07 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.98]) with mapi id 14.03.0439.000;
 Tue, 18 Feb 2020 11:36:05 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
CC:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        "David Hildenbrand" <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        "Ulrich Weigand" <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [PATCH 01/35] mm:gup/writeback: add callbacks for inaccessible
 pages
Thread-Topic: [PATCH 01/35] mm:gup/writeback: add callbacks for inaccessible
 pages
Thread-Index: AQHV3auCSG5HedHt7Uq9KhpGUrrOXKggXHoQ
Date:   Tue, 18 Feb 2020 03:36:05 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D78AA37@SHSMSX104.ccr.corp.intel.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-2-borntraeger@de.ibm.com>
In-Reply-To: <20200207113958.7320-2-borntraeger@de.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiM2JlMDg5ZWQtNjU4Ni00YzdiLTg2Y2QtZTg3NDAzZGIxMGZiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSDhLbmFEUEgydnpGREt1ZThIZ2p2dXJzTVVudWdPam5Ya2ZUaTlZNHA5elNJXC9xMkVnSkNVbzllaUVLbDZjODUifQ==
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christian Borntraeger
> Sent: Friday, February 7, 2020 7:39 PM
> 
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

What about hooking the callback to DMA API ops?

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
> @@ -485,6 +485,12 @@ static inline void arch_free_page(struct page *page,
> int order) { }
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
>  __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int
> preferred_nid,
> diff --git a/mm/gup.c b/mm/gup.c
> index 7646bf993b25..a01262cd2821 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -257,6 +257,7 @@ static struct page *follow_page_pte(struct
> vm_area_struct *vma,
>  			page = ERR_PTR(-ENOMEM);
>  			goto out;
>  		}
> +		arch_make_page_accessible(page);
>  	}
>  	if (flags & FOLL_TOUCH) {
>  		if ((flags & FOLL_WRITE) &&
> @@ -1870,6 +1871,7 @@ static int gup_pte_range(pmd_t pmd, unsigned
> long addr, unsigned long end,
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
> @@ -2806,6 +2806,7 @@ int __test_set_page_writeback(struct page *page,
> bool keep_write)
>  		inc_lruvec_page_state(page, NR_WRITEBACK);
>  		inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
>  	}
> +	arch_make_page_accessible(page);
>  	unlock_page_memcg(page);
>  	return ret;
> 
> --
> 2.24.0


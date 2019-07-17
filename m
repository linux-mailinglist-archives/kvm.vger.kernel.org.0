Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A7C6BF48
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 17:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfGQPq7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 17 Jul 2019 11:46:59 -0400
Received: from mga05.intel.com ([192.55.52.43]:32729 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbfGQPq7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 11:46:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 08:46:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,274,1559545200"; 
   d="scan'208";a="169592189"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga007.fm.intel.com with ESMTP; 17 Jul 2019 08:46:59 -0700
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 17 Jul 2019 08:46:59 -0700
Received: from shsmsx102.ccr.corp.intel.com ([169.254.2.3]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.240]) with mapi id 14.03.0439.000;
 Wed, 17 Jul 2019 23:46:57 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
CC:     Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        "pagupta@redhat.com" <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "lcapitulino@redhat.com" <lcapitulino@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: RE: use of shrinker in virtio balloon free page hinting
Thread-Topic: use of shrinker in virtio balloon free page hinting
Thread-Index: AQHVPJG4M96i+fJ6kUytx6sFNaZpP6bO17og
Date:   Wed, 17 Jul 2019 15:46:57 +0000
Message-ID: <286AC319A985734F985F78AFA26841F73E16D4B2@shsmsx102.ccr.corp.intel.com>
References: <20190717071332-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190717071332-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZWQwOTNjZDctYzMyOC00Mzg1LTgwOWMtNjNkNjliYmY2Yjg3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUzNSVGk4aHVLTE8xK2Q3XC9QXC9lVVhRTitQNEdsR3pPaWlqRlh4QWdFOGhJWDJFSGlLd3AxNWxZcnRXS082ZDgxIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wednesday, July 17, 2019 7:21 PM, Michael S. Tsirkin wrote:
> 
> Wei, others,
> 
> ATM virtio_balloon_shrinker_scan will only get registered when deflate on
> oom feature bit is set.
> 
> Not sure whether that's intentional. 

Yes, we wanted to follow the old oom behavior, which allows the oom notifier
to deflate pages only when this feature bit has been negotiated.


> Assuming it is:
> 
> virtio_balloon_shrinker_scan will try to locate and free pages that are
> processed by host.
> The above seems broken in several ways:
> - count ignores the free page list completely

Do you mean virtio_balloon_shrinker_count()? It just reports to
do_shrink_slab the amount of freeable memory that balloon has.
(vb->num_pages and vb->num_free_page_blocks are all included )

> - if free pages are being reported, pages freed
>   by shrinker will just get re-allocated again

fill_balloon will re-try the allocation after sleeping 200ms once allocation fails.

 
> I was unable to make this part of code behave in any reasonable way - was
> shrinker usage tested? What's a good way to test that?

Please see the example that I tested before : https://lkml.org/lkml/2018/8/6/29
(just the first one: *1. V3 patches)

What problem did you see?

I just tried the latest code, and find ballooning reports a #GP (seems caused by
418a3ab1e). 
I'll take a look at the details in the office tomorrow.

Best,
Wei

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 949C66C93E
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 08:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfGRGY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 02:24:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:44788 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbfGRGY3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 02:24:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 23:24:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,276,1559545200"; 
   d="scan'208";a="191506353"
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jul 2019 23:24:25 -0700
Message-ID: <5D3011E9.4040908@intel.com>
Date:   Thu, 18 Jul 2019 14:30:01 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Alexander Duyck <alexander.duyck@gmail.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        "pagupta@redhat.com" <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "lcapitulino@redhat.com" <lcapitulino@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: use of shrinker in virtio balloon free page hinting
References: <20190717071332-mutt-send-email-mst@kernel.org> <286AC319A985734F985F78AFA26841F73E16D4B2@shsmsx102.ccr.corp.intel.com> <20190718000434-mutt-send-email-mst@kernel.org> <5D300A32.4090300@intel.com> <20190718015319-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190718015319-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/18/2019 01:58 PM, Michael S. Tsirkin wrote:
>
> what if it does not fail?
>
>
>> Shrinker is called on system memory pressure. On memory pressure
>> get_free_page_and_send will fail memory allocation, so it stops allocating
>> more.
> Memory pressure could be triggered by an unrelated allocation
> e.g. from another driver.

As memory pressure is system-wide (no matter who triggers it), free page 
hinting
will fail on memory pressure, same as other drivers.

As long as the page allocation succeeds, we could just think the system 
is not in
the memory pressure situation, then thing could go on normally.

Also, the VIRTIO_BALLOON_FREE_PAGE_ALLOC_FLAG includes NORETRY and 
NOMEMALLOC,
which makes it easier than most other drivers to fail allocation first.

Best,
Wei

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76B65ADBE1
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 17:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387909AbfIIPLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 11:11:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:37550 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbfIIPLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 11:11:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 08:11:36 -0700
X-IronPort-AV: E=Sophos;i="5.64,486,1559545200"; 
   d="scan'208";a="175007390"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 08:11:36 -0700
Message-ID: <0ca58fea280b51b83e7b42e2087128789bc9448d.camel@linux.intel.com>
Subject: Re: [PATCH v9 1/8] mm: Add per-cpu logic to page shuffling
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        will@kernel.org, linux-arm-kernel@lists.infradead.org,
        osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        kirill.shutemov@linux.intel.com
Date:   Mon, 09 Sep 2019 08:11:36 -0700
In-Reply-To: <0df2e5d0-af92-04b4-aa7d-891387874039@redhat.com>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
         <20190907172512.10910.74435.stgit@localhost.localdomain>
         <0df2e5d0-af92-04b4-aa7d-891387874039@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-09-09 at 10:14 +0200, David Hildenbrand wrote:
> On 07.09.19 19:25, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > Change the logic used to generate randomness in the suffle path so that we
> > can avoid cache line bouncing. The previous logic was sharing the offset
> > and entropy word between all CPUs. As such this can result in cache line
> > bouncing and will ultimately hurt performance when enabled.
> 
> So, usually we perform such changes if there is real evidence. Do you
> have any such performance numbers to back your claims?

I'll have to go rerun the test to get the exact numbers. The reason this
came up is that my original test was spanning NUMA nodes and that made
this more expensive as a result since the memory was both not local to the
CPU and was being updated by multiple sockets.

I will try building a pair of host kernels with shuffling enabled and this
patch applied to one and can add that data to the patch description.

- Alex



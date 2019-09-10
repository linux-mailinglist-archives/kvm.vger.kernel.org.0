Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 846E5AF2CC
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 00:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfIJWLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 18:11:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:38804 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbfIJWLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 18:11:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 15:11:51 -0700
X-IronPort-AV: E=Sophos;i="5.64,490,1559545200"; 
   d="scan'208";a="268551180"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 15:11:50 -0700
Message-ID: <3de2409415b20440d5c8f3016ed78fde3d106dc8.camel@linux.intel.com>
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
Date:   Tue, 10 Sep 2019 15:11:50 -0700
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

I don't have any numbers. From what I can tell the impact is small enough
that this doesn't really have much impact.

With that being the case I can probably just drop this patch. I will
instead just use "rand & 1" in the 2nd patch to generate the return value
which was what was previously done in add_to_free_area_random.


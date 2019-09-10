Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 417D4AEA0F
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 14:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732706AbfIJMLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 08:11:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:36502 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732482AbfIJMLd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 08:11:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 668EEB150;
        Tue, 10 Sep 2019 12:11:31 +0000 (UTC)
Date:   Tue, 10 Sep 2019 14:11:30 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de,
        yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        kirill.shutemov@linux.intel.com
Subject: Re: [PATCH v9 1/8] mm: Add per-cpu logic to page shuffling
Message-ID: <20190910121130.GU2063@dhcp22.suse.cz>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
 <20190907172512.10910.74435.stgit@localhost.localdomain>
 <0df2e5d0-af92-04b4-aa7d-891387874039@redhat.com>
 <0ca58fea280b51b83e7b42e2087128789bc9448d.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ca58fea280b51b83e7b42e2087128789bc9448d.camel@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon 09-09-19 08:11:36, Alexander Duyck wrote:
> On Mon, 2019-09-09 at 10:14 +0200, David Hildenbrand wrote:
> > On 07.09.19 19:25, Alexander Duyck wrote:
> > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > 
> > > Change the logic used to generate randomness in the suffle path so that we
> > > can avoid cache line bouncing. The previous logic was sharing the offset
> > > and entropy word between all CPUs. As such this can result in cache line
> > > bouncing and will ultimately hurt performance when enabled.
> > 
> > So, usually we perform such changes if there is real evidence. Do you
> > have any such performance numbers to back your claims?
> 
> I'll have to go rerun the test to get the exact numbers. The reason this
> came up is that my original test was spanning NUMA nodes and that made
> this more expensive as a result since the memory was both not local to the
> CPU and was being updated by multiple sockets.

What was the pattern of page freeing in your testing? I am wondering
because order 0 pages should be prevailing and those usually go via pcp
lists so they do not get shuffled unless the batch is full IIRC.
-- 
Michal Hocko
SUSE Labs

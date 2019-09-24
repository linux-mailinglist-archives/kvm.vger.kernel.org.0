Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1D8BCA23
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 16:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436926AbfIXOXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 10:23:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:37518 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389459AbfIXOXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 10:23:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5AB60AC84;
        Tue, 24 Sep 2019 14:23:43 +0000 (UTC)
Date:   Tue, 24 Sep 2019 16:23:42 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        linux-mm@kvack.org, vbabka@suse.cz, akpm@linux-foundation.org,
        mgorman@techsingularity.net, linux-arm-kernel@lists.infradead.org,
        osalvador@suse.de, yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com
Subject: Re: [PATCH v10 0/6] mm / virtio: Provide support for unused page
 reporting
Message-ID: <20190924142342.GX23050@dhcp22.suse.cz>
References: <20190918175109.23474.67039.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918175109.23474.67039.stgit@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed 18-09-19 10:52:25, Alexander Duyck wrote:
[...]
> In order to try and keep the time needed to find a non-reported page to
> a minimum we maintain a "reported_boundary" pointer. This pointer is used
> by the get_unreported_pages iterator to determine at what point it should
> resume searching for non-reported pages. In order to guarantee pages do
> not get past the scan I have modified add_to_free_list_tail so that it
> will not insert pages behind the reported_boundary.
> 
> If another process needs to perform a massive manipulation of the free
> list, such as compaction, it can either reset a given individual boundary
> which will push the boundary back to the list_head, or it can clear the
> bit indicating the zone is actively processing which will result in the
> reporting process resetting all of the boundaries for a given zone.

Is this any different from the previous version? The last review
feedback (both from me and Mel) was that we are not happy to have an
externally imposed constrains on how the page allocator is supposed to
maintain its free lists.

If this is really the only way to go forward then I would like to hear
very convincing arguments about other approaches not being feasible.
There are none in this cover letter unfortunately. This will be really a
hard sell without them.
-- 
Michal Hocko
SUSE Labs

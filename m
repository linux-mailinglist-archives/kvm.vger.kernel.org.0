Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF61AEABE
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 14:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390174AbfIJMmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 08:42:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:36414 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726869AbfIJMmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 08:42:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DADE5AC2E;
        Tue, 10 Sep 2019 12:42:09 +0000 (UTC)
Date:   Tue, 10 Sep 2019 14:42:09 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        will@kernel.org, linux-arm-kernel@lists.infradead.org,
        osalvador@suse.de, yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        alexander.h.duyck@linux.intel.com, kirill.shutemov@linux.intel.com
Subject: Re: [PATCH v9 0/8] stg mail -e --version=v9 \
Message-ID: <20190910124209.GY2063@dhcp22.suse.cz>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190907172225.10910.34302.stgit@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I wanted to review "mm: Introduce Reported pages" just realize that I
have no clue on what is going on so returned to the cover and it didn't
really help much. I am completely unfamiliar with virtio so please bear
with me.

On Sat 07-09-19 10:25:03, Alexander Duyck wrote:
[...]
> This series provides an asynchronous means of reporting to a hypervisor
> that a guest page is no longer in use and can have the data associated
> with it dropped. To do this I have implemented functionality that allows
> for what I am referring to as unused page reporting
> 
> The functionality for this is fairly simple. When enabled it will allocate
> statistics to track the number of reported pages in a given free area.
> When the number of free pages exceeds this value plus a high water value,
> currently 32, it will begin performing page reporting which consists of
> pulling pages off of free list and placing them into a scatter list. The
> scatterlist is then given to the page reporting device and it will perform
> the required action to make the pages "reported", in the case of
> virtio-balloon this results in the pages being madvised as MADV_DONTNEED
> and as such they are forced out of the guest. After this they are placed
> back on the free list,

And here I am reallly lost because "forced out of the guest" makes me
feel that those pages are no longer usable by the guest. So how come you
can add them back to the free list. I suspect understanding this part
will allow me to understand why we have to mark those pages and prevent
merging.

> and an additional bit is added if they are not
> merged indicating that they are a reported buddy page instead of a
> standard buddy page. The cycle then repeats with additional non-reported
> pages being pulled until the free areas all consist of reported pages.


-- 
Michal Hocko
SUSE Labs

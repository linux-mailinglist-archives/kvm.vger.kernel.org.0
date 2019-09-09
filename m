Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52543ADE87
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 20:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405436AbfIISMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 14:12:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:24313 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405425AbfIISMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 14:12:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 11:12:34 -0700
X-IronPort-AV: E=Sophos;i="5.64,486,1559545200"; 
   d="scan'208";a="178428271"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 11:12:33 -0700
Message-ID: <576de40e00083206bdb0c2e9f04fe34dd406e6b3.camel@linux.intel.com>
Subject: Re: [PATCH v9 3/8] mm: Move set/get_pcppage_migratetype to mmzone.h
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de,
        yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        kirill.shutemov@linux.intel.com
Date:   Mon, 09 Sep 2019 11:12:33 -0700
In-Reply-To: <cca53aa628a25ead13a2f71060b56bde66e19d05.camel@linux.intel.com>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
         <20190907172528.10910.37051.stgit@localhost.localdomain>
         <20190909095608.jwachx3womhqmjbl@box>
         <cca53aa628a25ead13a2f71060b56bde66e19d05.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-09-09 at 11:01 -0700, Alexander Duyck wrote:
> On Mon, 2019-09-09 at 12:56 +0300, Kirill A. Shutemov wrote:
> > On Sat, Sep 07, 2019 at 10:25:28AM -0700, Alexander Duyck wrote:
> > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > 
> > > In order to support page reporting it will be necessary to store and
> > > retrieve the migratetype of a page. To enable that I am moving the set and
> > > get operations for pcppage_migratetype into the mm/internal.h header so
> > > that they can be used outside of the page_alloc.c file.
> > > 
> > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > I'm not sure that it's great idea to export this functionality beyond
> > mm/page_alloc.c without any additional safeguards. How would we avoid to
> > messing with ->index when the page is not in the right state of its
> > life-cycle. Can we add some VM_BUG_ON()s here?
> 
> I am not sure what we would need to check on though. There are essentially
> 2 cases where we are using this. The first is the percpu page lists so the
> value is set either as a result of __rmqueue_smallest or
> free_unref_page_prepare. The second one which hasn't been added yet is for
> the Reported pages case which I add with patch 6.
> 
> When I use it for page reporting I am essentially using the Reported flag
> to identify what pages in the buddy list will have this value set versus
> those that may not. I didn't explicitly define it that way, but that is
> how I am using it so that the value cannot be trusted unless the Reported
> flag is set.

I guess the alternative would be to just treat the ->index value as the
index within the boundary array, and not use the per-cpu list functions.
Doing that might make things a bit more clear since all we are really
doing is storing the index into the boundary list the page is contained
in. I could probably combine the value of order and migratetype and save
myself a few cycles in the process by just saving the index into the array
directly.


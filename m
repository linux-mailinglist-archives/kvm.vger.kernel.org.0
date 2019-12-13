Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F33211E872
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfLMQhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:37:02 -0500
Received: from mga17.intel.com ([192.55.52.151]:42883 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727974AbfLMQhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 11:37:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 08:37:02 -0800
X-IronPort-AV: E=Sophos;i="5.69,309,1571727600"; 
   d="scan'208";a="216480091"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 08:37:01 -0800
Message-ID: <f0153bdb80b26b99495cfc3086934968695deb6c.camel@linux.intel.com>
Subject: Re: [PATCH v15 6/7] virtio-balloon: Add support for providing free
 page reports to host
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
Date:   Fri, 13 Dec 2019 08:37:01 -0800
In-Reply-To: <ca305a98-864e-ccb0-5393-f73997645acf@redhat.com>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
         <20191205162255.19548.63866.stgit@localhost.localdomain>
         <ca305a98-864e-ccb0-5393-f73997645acf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2019-12-13 at 11:15 +0100, David Hildenbrand wrote:
> On 05.12.19 17:22, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > Add support for the page reporting feature provided by virtio-balloon.
> > Reporting differs from the regular balloon functionality in that is is
> > much less durable than a standard memory balloon. Instead of creating a
> > list of pages that cannot be accessed the pages are only inaccessible
> > while they are being indicated to the virtio interface. Once the
> > interface has acknowledged them they are placed back into their respective
> > free lists and are once again accessible by the guest system.
> > 
> > Unlike a standard balloon we don't inflate and deflate the pages. Instead
> > we perform the reporting, and once the reporting is completed it is
> > assumed that the page has been dropped from the guest and will be faulted
> > back in the next time the page is accessed.
> > 
> > For this reason when I had originally introduced the patch set I referred
> > to this behavior as a "bubble" instead of a "balloon" since the duration
> > is short lived, and when the page is touched the "bubble" is popped and
> > the page is faulted back in.
> 
> While an interesting read, I would drop that comment as it isn't really
> of value for the code/codebase itself.

Okay, I can drop the comment.

> [...]
> 
> > +
> > +	vb->pr_dev_info.report = virtballoon_free_page_report;
> > +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> > +		unsigned int capacity;
> > +
> > +		capacity = virtqueue_get_vring_size(vb->reporting_vq);
> > +		if (capacity < PAGE_REPORTING_CAPACITY) {
> > +			err = -ENOSPC;
> > +			goto out_unregister_shrinker;
> 
> It's somewhat strange to fail loading the balloon completely here.
> Wouldn't it be better to print e.g. a warning but continue without free
> page reporting?
> 
> (I guess splitting up the list can be done in an addon patch if ever
> really needed for virtio-balloon)

That was kind of my thought. Odds are it probably is unlikely to come up.
At least with the code I have now I think the virtqueue size is something
like 128 and the capacity is only 32 as I wanted to limit the number of
pages that were being reported at the time.

> Apart from that
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 
> Thanks!
> 


Thanks for the review.

- Alex


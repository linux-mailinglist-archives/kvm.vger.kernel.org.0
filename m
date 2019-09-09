Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9FAADC24
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 17:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388259AbfIIPbw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 11:31:52 -0400
Received: from mga06.intel.com ([134.134.136.31]:40300 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbfIIPbw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 11:31:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 08:31:51 -0700
X-IronPort-AV: E=Sophos;i="5.64,486,1559545200"; 
   d="scan'208";a="359515642"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 08:31:51 -0700
Message-ID: <f9c1abd93b9546885eb10d0cd62ee7421b484ba2.camel@linux.intel.com>
Subject: Re: [PATCH v9 7/8] virtio-balloon: Pull page poisoning config out
 of free page hinting
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
Date:   Mon, 09 Sep 2019 08:31:51 -0700
In-Reply-To: <4dfcf372-97be-65ab-1349-75f24aa4f98a@redhat.com>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
         <20190907172601.10910.95355.stgit@localhost.localdomain>
         <4dfcf372-97be-65ab-1349-75f24aa4f98a@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-09-09 at 10:59 +0200, David Hildenbrand wrote:
> On 07.09.19 19:26, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > Currently the page poisoning setting wasn't being enabled unless free page
> > hinting was enabled. However we will need the page poisoning tracking logic
> > as well for unused page reporting. As such pull it out and make it a
> > separate bit of config in the probe function.
> > 
> > In addition we can actually wrap the code in a check for NO_SANITY. If we
> > don't care what is actually in the page we can just default to 0 and leave
> > it there.
> > 
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > ---
> >  drivers/virtio/virtio_balloon.c |   22 +++++++++++++++-------
> >  1 file changed, 15 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > index 226fbb995fb0..d2547df7de93 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -842,7 +842,6 @@ static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
> >  static int virtballoon_probe(struct virtio_device *vdev)
> >  {
> >  	struct virtio_balloon *vb;
> > -	__u32 poison_val;
> >  	int err;
> >  
> >  	if (!vdev->config->get) {
> > @@ -909,11 +908,18 @@ static int virtballoon_probe(struct virtio_device *vdev)
> >  						  VIRTIO_BALLOON_CMD_ID_STOP);
> >  		spin_lock_init(&vb->free_page_list_lock);
> >  		INIT_LIST_HEAD(&vb->free_page_list);
> > -		if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON)) {
> > -			memset(&poison_val, PAGE_POISON, sizeof(poison_val));
> > -			virtio_cwrite(vb->vdev, struct virtio_balloon_config,
> > -				      poison_val, &poison_val);
> > -		}
> > +	}
> > +	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON)) {
> > +		__u32 poison_val;
> > +
> > +		/*
> > +		 * Let hypervisor know that we are expecting a specific
> > +		 * value to be written back in unused pages.
> > +		 */
> 
> "Let the hypervisor know" ... ?
> 
> > +		memset(&poison_val, PAGE_POISON, sizeof(poison_val));
> > +
> > +		virtio_cwrite(vb->vdev, struct virtio_balloon_config,
> > +			      poison_val, &poison_val);
> >  	}
> >  	/*
> >  	 * We continue to use VIRTIO_BALLOON_F_DEFLATE_ON_OOM to decide if a
> > @@ -1014,7 +1020,9 @@ static int virtballoon_restore(struct virtio_device *vdev)
> >  
> >  static int virtballoon_validate(struct virtio_device *vdev)
> >  {
> > -	if (!page_poisoning_enabled())
> > +	/* Notify host if we care about poison value */
> 
> "Tell the host whether we care about poisoned pages." ?
> 
> > +	if (IS_ENABLED(CONFIG_PAGE_POISONING_NO_SANITY) ||
> > +	    !page_poisoning_enabled())
> >  		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
> >  
> >  	__virtio_clear_bit(vdev, VIRTIO_F_IOMMU_PLATFORM);
> > 
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 

Thanks. I will update the comments for v10.

- Alex


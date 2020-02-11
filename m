Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA72158DBA
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 12:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgBKLrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 06:47:55 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35702 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727561AbgBKLry (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Feb 2020 06:47:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581421673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UZ+e+/Q/bgo4cstCyNeXCa8O9APumSBN7bEnx6koZUg=;
        b=MGNPQQyOvGndLodyayfOv+7xfs6Sp2LUJx9/t8hsmhLQw4aFHORXdAX+FfogSw1NIW95mu
        vxpYr9UYM+/zpYC8I9x5/8n07VEyktR4k8Yh3VhBY/IHdMM5pOvnXsbxQG1ABUFfqPIJTF
        +E/0EgCqjl+5AgQIYjCMgChv43zwNHY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-HxqrL5U2MaSJjLYEfx5PUQ-1; Tue, 11 Feb 2020 06:47:52 -0500
X-MC-Unique: HxqrL5U2MaSJjLYEfx5PUQ-1
Received: by mail-qv1-f70.google.com with SMTP id cn2so6989245qvb.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 03:47:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UZ+e+/Q/bgo4cstCyNeXCa8O9APumSBN7bEnx6koZUg=;
        b=XHSGT6VAECTfPi39Gc3V4O9DX9E1iIExX/oIauaheP+mp27ylwamcTx1ztxb3og1vz
         s+EWlKK7skXTvHvjPBNdMMI8aQO+2FeQ9Bk7A4E6wwjL4J9nzBmEC1PavTSWss8eDxMW
         buLLKUKojepEsWslveKrHJza4bd7xcT80mVT/Hv+zycamCCqpkrmy9Z3nIB5+pu3mm8Z
         HGu305OwVbZmJJsCujwSVkzVJHiolRc7hfXIJbGcvKis/ERIrtFSXHpX4TJ0L4n0UBof
         DpBvBri3weiMlFq88nQscE/TKo18KVHqZHouffNoPYa0D9GrzckC71wj59LVSfoVOJhA
         odcQ==
X-Gm-Message-State: APjAAAXSOwuFcFbirba5OhcXSEyp1ZtKl57Qzq9WU9NexN2TQU3P+tzJ
        U/UfhkcyR6vhLB4bMGMNO2IF5ndIdzMB0PIhyE1FRaKVtNs1oz9djEQUSS2+COrCkSUdkvRlrLL
        j51Rc86BhrO/4
X-Received: by 2002:aed:2643:: with SMTP id z61mr2015610qtc.49.1581421671394;
        Tue, 11 Feb 2020 03:47:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqx6c+QCmz/2JPA19VAPKWAg4SiME/3B79iYqvLXcvvmNlRQinhDVfltdEKaQ6b3MRvo1ed81g==
X-Received: by 2002:aed:2643:: with SMTP id z61mr2015587qtc.49.1581421671068;
        Tue, 11 Feb 2020 03:47:51 -0800 (PST)
Received: from redhat.com (bzq-79-176-41-183.red.bezeqint.net. [79.176.41.183])
        by smtp.gmail.com with ESMTPSA id o6sm1783902qkk.53.2020.02.11.03.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 03:47:50 -0800 (PST)
Date:   Tue, 11 Feb 2020 06:47:44 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz,
        yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com, osalvador@suse.de
Subject: Re: [PATCH v16.1 6/9] virtio-balloon: Add support for providing free
 page reports to host
Message-ID: <20200211063441-mutt-send-email-mst@kernel.org>
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
 <20200122174347.6142.92803.stgit@localhost.localdomain>
 <b8cbf72d-55a7-4a58-6d08-b0ac5fa86e82@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8cbf72d-55a7-4a58-6d08-b0ac5fa86e82@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 12:03:57PM +0100, David Hildenbrand wrote:
> On 22.01.20 18:43, Alexander Duyck wrote:
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
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > Reviewed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > ---
> >  drivers/virtio/Kconfig              |    1 +
> >  drivers/virtio/virtio_balloon.c     |   64 +++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/virtio_balloon.h |    1 +
> >  3 files changed, 66 insertions(+)
> > 
> > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > index 078615cf2afc..4b2dd8259ff5 100644
> > --- a/drivers/virtio/Kconfig
> > +++ b/drivers/virtio/Kconfig
> > @@ -58,6 +58,7 @@ config VIRTIO_BALLOON
> >  	tristate "Virtio balloon driver"
> >  	depends on VIRTIO
> >  	select MEMORY_BALLOON
> > +	select PAGE_REPORTING
> >  	---help---
> >  	 This driver supports increasing and decreasing the amount
> >  	 of memory within a KVM guest.
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > index 40bb7693e3de..a07b9e18a292 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/mount.h>
> >  #include <linux/magic.h>
> >  #include <linux/pseudo_fs.h>
> > +#include <linux/page_reporting.h>
> >  
> >  /*
> >   * Balloon device works in 4K page units.  So each page is pointed to by
> > @@ -47,6 +48,7 @@ enum virtio_balloon_vq {
> >  	VIRTIO_BALLOON_VQ_DEFLATE,
> >  	VIRTIO_BALLOON_VQ_STATS,
> >  	VIRTIO_BALLOON_VQ_FREE_PAGE,
> > +	VIRTIO_BALLOON_VQ_REPORTING,
> >  	VIRTIO_BALLOON_VQ_MAX
> >  };
> >  
> > @@ -114,6 +116,10 @@ struct virtio_balloon {
> >  
> >  	/* To register a shrinker to shrink memory upon memory pressure */
> >  	struct shrinker shrinker;
> > +
> > +	/* Free page reporting device */
> > +	struct virtqueue *reporting_vq;
> > +	struct page_reporting_dev_info pr_dev_info;
> >  };
> >  
> >  static struct virtio_device_id id_table[] = {
> > @@ -153,6 +159,33 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
> >  
> >  }
> >  
> > +int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_info,
> > +				   struct scatterlist *sg, unsigned int nents)
> > +{
> > +	struct virtio_balloon *vb =
> > +		container_of(pr_dev_info, struct virtio_balloon, pr_dev_info);
> > +	struct virtqueue *vq = vb->reporting_vq;
> > +	unsigned int unused, err;
> > +
> > +	/* We should always be able to add these buffers to an empty queue. */
> > +	err = virtqueue_add_inbuf(vq, sg, nents, vb, GFP_NOWAIT | __GFP_NOWARN);
> > +
> > +	/*
> > +	 * In the extremely unlikely case that something has occurred and we
> > +	 * are able to trigger an error we will simply display a warning
> > +	 * and exit without actually processing the pages.
> > +	 */
> > +	if (WARN_ON_ONCE(err))
> > +		return err;
> > +
> > +	virtqueue_kick(vq);
> > +
> > +	/* When host has read buffer, this completes via balloon_ack */
> > +	wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
> > +
> > +	return 0;
> > +}
> 
> 
> Did you see the discussion regarding unifying handling of
> inflate/deflate/free_page_hinting_free_page_reporting, requested by
> Michael? I think free page reporting is special and shall be left alone.

Not sure what do you mean by "left alone here". Could you clarify?

> VIRTIO_BALLOON_F_REPORTING is nothing but a more advanced inflate, right
> (sg, inflate based on size - not "virtio pages")?


Not exactly - it's also initiated by guest as opposed to host, and
not guided by the ballon size request set by the host.
And uses a dedicated queue to avoid blocking other functionality ...

I really think this is more like an inflate immediately followed by deflate.



> And you rely on
> deflates not being required before reusing an inflated page.
> 
> I suggest the following:
> 
> /* New interface (+ 2 virtqueues) to inflate/deflate using a SG */
> VIRTIO_BALLOON_F_SG
> /*
>  * No need to deflate when reusing pages (once the inflate request was
>  * processed). Applies to all inflate queues.
>  */
> VIRTIO_BALLOON_F_OPTIONAL_DEFLATE
> 
> And two new virtqueues
> 
> VIRTIO_BALLOON_VQ_INFLATE_SG
> VIRTIO_BALLOON_VQ_DEFLATE_SG
> 
> 
> Your feature would depend on VIRTIO_BALLOON_F_SG &&
> VIRTIO_BALLOON_F_OPTIONAL_DEFLATE. VIRTIO_BALLOON_F_OPTIONAL_DEFLATE
> could be reused to avoid deflating on certain events (e.g., from
> OOM/shrinker).
> 
> Thoughts?

I'd rather wait until we have a usecase and preferably a POC
showing it helps before we add optional deflate ...
For now I personally am fine with just making this go ahead as is,
and imply SG and OPTIONAL_DEFLATE just for this VQ.

Do you feel strongly we need to bring this up to a TC vote?
It means spec patch needs to be written, but it
does not have to be a big patch ...


> -- 
> Thanks,
> 
> David / dhildenb


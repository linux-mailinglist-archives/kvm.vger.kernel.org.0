Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C26538D0B7
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 12:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbfHNKaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 06:30:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfHNKaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 06:30:09 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0EB3F30083EE;
        Wed, 14 Aug 2019 10:30:07 +0000 (UTC)
Received: from gondolin (dhcp-192-232.str.redhat.com [10.33.192.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59F6C1001B35;
        Wed, 14 Aug 2019 10:29:52 +0000 (UTC)
Date:   Wed, 14 Aug 2019 12:29:49 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        pbonzini@redhat.com, lcapitulino@redhat.com, pagupta@redhat.com,
        wei.w.wang@intel.com, yang.zhang.wz@gmail.com, riel@surriel.com,
        david@redhat.com, mst@redhat.com, dodgen@google.com,
        konrad.wilk@oracle.com, dhildenb@redhat.com, aarcange@redhat.com,
        alexander.duyck@gmail.com, john.starks@microsoft.com,
        dave.hansen@intel.com, mhocko@suse.com
Subject: Re: [RFC][Patch v12 2/2] virtio-balloon: interface to support free
 page reporting
Message-ID: <20190814122949.4946f438.cohuck@redhat.com>
In-Reply-To: <20190812131235.27244-3-nitesh@redhat.com>
References: <20190812131235.27244-1-nitesh@redhat.com>
        <20190812131235.27244-3-nitesh@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 14 Aug 2019 10:30:09 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 12 Aug 2019 09:12:35 -0400
Nitesh Narayan Lal <nitesh@redhat.com> wrote:

> Enables the kernel to negotiate VIRTIO_BALLOON_F_REPORTING feature with
> the host. If it is available and page_reporting_flag is set to true,
> page_reporting is enabled and its callback is configured along with
> the max_pages count which indicates the maximum number of pages that
> can be isolated and reported at a time. Currently, only free pages of
> order >= (MAX_ORDER - 2) are reported. To prevent any false OOM
> max_pages count is set to 16.
> 
> By default page_reporting feature is enabled and gets loaded as soon
> as the virtio-balloon driver is loaded. However, it could be disabled
> by writing the page_reporting_flag which is a virtio-balloon parameter.
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  drivers/virtio/Kconfig              |  1 +
>  drivers/virtio/virtio_balloon.c     | 64 ++++++++++++++++++++++++++++-
>  include/uapi/linux/virtio_balloon.h |  1 +
>  3 files changed, 65 insertions(+), 1 deletion(-)
> 

> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 226fbb995fb0..defec00d4ee2 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c

(...)

> +static void virtballoon_page_reporting_setup(struct virtio_balloon *vb)
> +{
> +	struct device *dev = &vb->vdev->dev;
> +	int err;
> +
> +	vb->page_reporting_conf.report = virtballoon_report_pages;
> +	vb->page_reporting_conf.max_pages = PAGE_REPORTING_MAX_PAGES;
> +	err = page_reporting_enable(&vb->page_reporting_conf);
> +	if (err < 0) {
> +		dev_err(dev, "Failed to enable reporting, err = %d\n", err);
> +		page_reporting_flag = false;

Should we clear the feature bit in this case as well?

> +		vb->page_reporting_conf.report = NULL;
> +		vb->page_reporting_conf.max_pages = 0;
> +		return;
> +	}
> +}
> +
>  static void set_page_pfns(struct virtio_balloon *vb,
>  			  __virtio32 pfns[], struct page *page)
>  {
> @@ -476,6 +524,7 @@ static int init_vqs(struct virtio_balloon *vb)
>  	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
>  	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
>  	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> +	names[VIRTIO_BALLOON_VQ_REPORTING] = NULL;
>  
>  	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
>  		names[VIRTIO_BALLOON_VQ_STATS] = "stats";
> @@ -487,11 +536,18 @@ static int init_vqs(struct virtio_balloon *vb)
>  		callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
>  	}
>  
> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> +		names[VIRTIO_BALLOON_VQ_REPORTING] = "reporting_vq";
> +		callbacks[VIRTIO_BALLOON_VQ_REPORTING] = balloon_ack;

Do we even want to try to set up the reporting queue if reporting has
been disabled via module parameter? Might make more sense to not even
negotiate the feature bit in that case.

> +	}
>  	err = vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX,
>  					 vqs, callbacks, names, NULL, NULL);
>  	if (err)
>  		return err;
>  
> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> +		vb->reporting_vq = vqs[VIRTIO_BALLOON_VQ_REPORTING];
> +
>  	vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
>  	vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
>  	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> @@ -924,6 +980,9 @@ static int virtballoon_probe(struct virtio_device *vdev)
>  		if (err)
>  			goto out_del_balloon_wq;
>  	}
> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING) &&
> +	    page_reporting_flag)
> +		virtballoon_page_reporting_setup(vb);

In that case, you'd only need to check for the feature bit here.

>  	virtio_device_ready(vdev);
>  
>  	if (towards_target(vb))
> @@ -971,6 +1030,8 @@ static void virtballoon_remove(struct virtio_device *vdev)
>  		destroy_workqueue(vb->balloon_wq);
>  	}
>  
> +	if (page_reporting_flag)
> +		page_reporting_disable(&vb->page_reporting_conf);

I think you should not disable it if the feature bit was never offered
in the first place, right?

>  	remove_common(vb);
>  #ifdef CONFIG_BALLOON_COMPACTION
>  	if (vb->vb_dev_info.inode)

(...)

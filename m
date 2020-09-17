Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173FD26D737
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 10:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgIQI4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 04:56:03 -0400
Received: from smtp1.axis.com ([195.60.68.17]:59502 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbgIQI4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 04:56:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=2275; q=dns/txt; s=axis-central1;
  t=1600332961; x=1631868961;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7NfOGX/GL1UDMwdZ9k07i7ou/GGUBIMx7JAJVjygZ7I=;
  b=Xb6szjsK8rHIGlEDX/QQulgoUe29IAnOl89ryhoxvWXgQesMajCev6Qy
   bxfSAfWw7xNGORVfNUXJYflrqtRaSeh+xjPaU95t4De8kw0oZsDPAu/+B
   e5Nzr0ryWyupZMxsIeCKA0eCMTgfx8HAHZrZJzs8aGM9hKfh0me10sJl4
   EReO6dxc3j/JjkBS8uBr82fpZN/3UUs899R/NeCMK3+vHNQqQctdROoqE
   JLYessc8f/ekhu7qLZ9I/6A4+vpLnpjHJBAtKs1sYJxd+WxjDXs0+nNzB
   b25HrTwvqnaRUPcgNnggnP5LfwVohKyxvmWzexS4RW6E6P6nxZ4HmiMbq
   w==;
IronPort-SDR: 6MqQxFg+KYlYJphHffimUhmitKEWQPSswtENyoQ91Ovj6pMX7T6qnNokxLq4K1YYqIKW+8XOXr
 8QxFFxVrBt4TANYJEnUU/zc/mxdRg7mGqCOauW90Ho32mryhm8H3Sw595FtOFZ6oJaimDN+N8J
 /MMYYZq38yqB6MUsXNxl3vZ0hOpba2p7rXyfh8R3zXjBcn8VmYaWDrPOptWGXktOddOp6rPiKd
 y1daRMgtUItqjCYrg2WJQQYJ0Fya8TEg1mGxkPnANvFXWBSKn3ItgMDLGHghqOeRJc0uwK3AgP
 Yq0=
X-IronPort-AV: E=Sophos;i="5.76,436,1592863200"; 
   d="scan'208";a="13045882"
Date:   Thu, 17 Sep 2020 10:55:59 +0200
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "sound-open-firmware@alsa-project.org" 
        <sound-open-firmware@alsa-project.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v7 3/3] vhost: add an RPMsg API
Message-ID: <20200917085559.kxxjrortmhbwpd22@axis.com>
References: <20200910111351.20526-1-guennadi.liakhovetski@linux.intel.com>
 <20200910111351.20526-4-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200910111351.20526-4-guennadi.liakhovetski@linux.intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 10, 2020 at 01:13:51PM +0200, Guennadi Liakhovetski wrote:
> +int vhost_rpmsg_start_lock(struct vhost_rpmsg *vr, struct vhost_rpmsg_iter *iter,
> +			   unsigned int qid, ssize_t len)
> +	__acquires(vq->mutex)
> +{
> +	struct vhost_virtqueue *vq = vr->vq + qid;
> +	unsigned int cnt;
> +	ssize_t ret;
> +	size_t tmp;
> +
> +	if (qid >= VIRTIO_RPMSG_NUM_OF_VQS)
> +		return -EINVAL;
> +
> +	iter->vq = vq;
> +
> +	mutex_lock(&vq->mutex);
> +	vhost_disable_notify(&vr->dev, vq);
> +
> +	iter->head = vhost_rpmsg_get_msg(vq, &cnt);
> +	if (iter->head == vq->num)
> +		iter->head = -EAGAIN;
> +
> +	if (iter->head < 0) {
> +		ret = iter->head;
> +		goto unlock;
> +	}
> +
[...]
> +
> +return_buf:
> +	vhost_add_used(vq, iter->head, 0);
> +unlock:
> +	vhost_enable_notify(&vr->dev, vq);
> +	mutex_unlock(&vq->mutex);
> +
> +	return ret;
> +}

There is a race condition here.  New buffers could have been added while
notifications were disabled (between vhost_disable_notify() and
vhost_enable_notify()), so the other vhost drivers check the return
value of vhost_enable_notify() and rerun their work loops if it returns
true.  This driver doesn't do that so it stops processing requests if
that condition hits.

Something like the below seems to fix it but the correct fix could maybe
involve changing this API to account for this case so that it looks more
like the code in other vhost drivers.

diff --git a/drivers/vhost/rpmsg.c b/drivers/vhost/rpmsg.c
index 7c753258d42..673dd4ec865 100644
--- a/drivers/vhost/rpmsg.c
+++ b/drivers/vhost/rpmsg.c
@@ -302,8 +302,14 @@ static void handle_rpmsg_req_kick(struct vhost_work *work)
 	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
 						  poll.work);
 	struct vhost_rpmsg *vr = container_of(vq->dev, struct vhost_rpmsg, dev);
+	struct vhost_virtqueue *reqvq = vr->vq + VIRTIO_RPMSG_REQUEST;
 
-	while (handle_rpmsg_req_single(vr, vq))
+	/*
+	 * The !vhost_vq_avail_empty() check is needed since the vhost_rpmsg*
+	 * APIs don't check the return value of vhost_enable_notify() and retry
+	 * if there were buffers added while notifications were disabled.
+	 */
+	while (handle_rpmsg_req_single(vr, vq) || !vhost_vq_avail_empty(reqvq->dev, reqvq))
 		;
 }
 

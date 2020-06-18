Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138151FEEBF
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 11:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbgFRJd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 05:33:29 -0400
Received: from smtp1.axis.com ([195.60.68.17]:34170 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728568AbgFRJd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 05:33:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=4801; q=dns/txt; s=axis-central1;
  t=1592472808; x=1624008808;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=POiUqRMkLKEMmSWikpOlHEbZVUCxXpxAdH2zw7lP+8o=;
  b=WKyUi8iK0kIs7Osu35StmMS3HYz8UhMSOVsww32mgOXwCs45TOZFGNxF
   mh3CAIXbu15Ek6s/qC2rCnV1lWBmo7705ndaTa1sb39iQpHWCPS+ZnjDw
   PZaHKtiakVXLEIj+TyX1bV2ryYh01UUiyXhhqNJcLKQ3xKStC1sjO+l9z
   C59SRq+r7ebtOtrpEJTBv2M5rOjUavZcls5XNRnPjJEErNRtkfMBcyV8j
   D0mboixUsgWKNbfZUaTO717BBIiQK2lW/YVv3IXlClMsIo874oItmYFEd
   qRS5VSpbs3W72AkM8B9LE80jaiIzBWEvhQaysjm4FLdy9s8IXb8hx02SN
   w==;
IronPort-SDR: 8BZlmzzFoiA8RVnUI+gkvFO+f+1IeSOUN2A5W6q5nM/X8brRNS3sK3XugQq0ZYzB2WGBwHHksC
 /H/kYV2gYXZqf4KuPWmM4xQEv/k6u1D0NoNSb/ocmdSalJ8MJaFG5LmP9hQEJxHtdxtiZx0Yka
 +VcZilKbBeaV7e2n9uBbY5LgmFJup4cbr8qb7TQa++dNTjjXFcO5RJ+aVVGELe5PCRGajoj8xk
 3aSrWAMbSDVE0z0NlI8wWIOR+7iL2/pvaKC2LbXa8O1O8Q8oPzDkCMXhPYmroTJe5GEvYrXeqv
 EJI=
X-IronPort-AV: E=Sophos;i="5.73,526,1583190000"; 
   d="scan'208";a="9949095"
Date:   Thu, 18 Jun 2020 11:33:24 +0200
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
Subject: Re: [PATCH v3 5/5] vhost: add an RPMsg API
Message-ID: <20200618093324.tu7oldr332ndfgev@axis.com>
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
 <20200527180541.5570-6-guennadi.liakhovetski@linux.intel.com>
 <20200617191741.whnp7iteb36cjnia@axis.com> <20200618090341.GA4189@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200618090341.GA4189@ubuntu>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 18, 2020 at 11:03:42AM +0200, Guennadi Liakhovetski wrote:
> On Wed, Jun 17, 2020 at 09:17:42PM +0200, Vincent Whitchurch wrote:
> > On Wed, May 27, 2020 at 08:05:41PM +0200, Guennadi Liakhovetski wrote:
> > > Linux supports running the RPMsg protocol over the VirtIO transport
> > > protocol, but currently there is only support for VirtIO clients and
> > > no support for a VirtIO server. This patch adds a vhost-based RPMsg
> > > server implementation.
> > 
> > This looks really useful, but why is it implemented as an API and not as
> > a real vhost driver which implements an rpmsg bus?  If you implement it
> > as a vhost driver which implements rpmsg_device_ops and
> > rpmsg_endpoint_ops, then wouldn't you be able to implement your
> > vhost-sof driver using the normal rpmsg APIs?
> 
> Sorry, not sure what you mean by the "normal rpmsg API?" Do you mean the 
> VirtIO RPMsg API? But that's the opposite side of the link - that's the 
> guest side in the VM case and the Linux side in the remoteproc case. What 
> this API is adding is a vhost RPMsg API. The kernel vhost framework 
> itself is essentially a library of functions. Kernel vhost drivers simply 
> create a misc device and use the vhost functions for some common 
> functionality. This RPMsg vhost API stays in the same concept and provides 
> further functions for RPMsg specific vhost operation.

By the "normal rpmsg API" I mean register_rpmsg_driver(), rpmsg_send(),
etc.  That API is not tied to virtio in any way and there are other
non-virtio backends for this API in the tree.  So it seems quite natural
to implement a vhost backend for this API so that both sides of the link
can use the same API but different backends, instead of forcing them to
use of different APIs.

> > I tried quickly hooking up this code to such a vhost driver and I was
> > able to communicate between host and guest systems with both
> > rpmsg-client-sample and rpmsg-char which almost no modifications to
> > those drivers.
> 
> You mean you used this patch to create RPMsg vhost drivers? Without 
> creating a vhost RPMsg bus? Nice, glad to hear that!

Not quite, I hacked togther a single generic vhost-rpmsg-bus driver
which just wraps the API in this patch and implements a basic
rpmsg_device_ops and rpmsg_endpoint_ops.  Then with the following
patches and no other vhost-specific API use, I was able to load and use
the same rpmsg-char and rpmsg-client-sample drivers on both host and
guest kernels.

Userspace sets up the vhost using vhost-rpmsg-bus' misc device and
triggers creation of an rpdev which leads to a probe of the (for
example) rpmsg-client-sample driver on the host (server), which, in
turn, via NS announcement, triggers a creation of an rpdev and a probe
of the rpmsg-client-sample driver on the guest (client).

diff --git a/drivers/rpmsg/rpmsg_char.c b/drivers/rpmsg/rpmsg_char.c
index a76b963a7e5..7a03978d002 100644
--- a/drivers/rpmsg/rpmsg_char.c
+++ b/drivers/rpmsg/rpmsg_char.c
@@ -104,6 +104,11 @@ static int rpmsg_ept_cb(struct rpmsg_device *rpdev, void *buf, int len,
 	struct rpmsg_eptdev *eptdev = priv;
 	struct sk_buff *skb;
 
+	if (rpdev->dst == RPMSG_ADDR_ANY) {
+		printk("%s: got client address %#x from first rx!\n", __func__, addr);
+		rpdev->dst = addr;
+	}
+
 	skb = alloc_skb(len, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
@@ -235,6 +240,12 @@ static ssize_t rpmsg_eptdev_write(struct file *filp, const char __user *buf,
 		goto unlock_eptdev;
 	}
 
+	if (eptdev->rpdev->dst == RPMSG_ADDR_ANY) {
+		ret = -EPIPE;
+		WARN(1, "Cannot write first on server, must wait for client!\n");
+		goto unlock_eptdev;
+	}
+
 	if (filp->f_flags & O_NONBLOCK)
 		ret = rpmsg_trysend(eptdev->ept, kbuf, len);
 	else
diff --git a/samples/rpmsg/rpmsg_client_sample.c b/samples/rpmsg/rpmsg_client_sample.c
index f161dfd3e70..5d8ca84dce0 100644
--- a/samples/rpmsg/rpmsg_client_sample.c
+++ b/samples/rpmsg/rpmsg_client_sample.c
@@ -46,6 +46,9 @@ static int rpmsg_sample_cb(struct rpmsg_device *rpdev, void *data, int len,
 		return 0;
 	}
 
+	if (rpdev->dst == RPMSG_ADDR_ANY)
+		rpdev->dst = src;
+
 	/* send a new message now */
 	ret = rpmsg_send(rpdev->ept, MSG, strlen(MSG));
 	if (ret)
@@ -68,11 +71,13 @@ static int rpmsg_sample_probe(struct rpmsg_device *rpdev)
 
 	dev_set_drvdata(&rpdev->dev, idata);
 
-	/* send a message to our remote processor */
-	ret = rpmsg_send(rpdev->ept, MSG, strlen(MSG));
-	if (ret) {
-		dev_err(&rpdev->dev, "rpmsg_send failed: %d\n", ret);
-		return ret;
+	if (rpdev->dst != RPMSG_ADDR_ANY) {
+		/* send a message to our remote processor */
+		ret = rpmsg_send(rpdev->ept, MSG, strlen(MSG));
+		if (ret) {
+			dev_err(&rpdev->dev, "rpmsg_send failed: %d\n", ret);
+			return ret;
+		}
 	}
 
 	return 0;

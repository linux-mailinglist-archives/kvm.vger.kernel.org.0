Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D4FF3075
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 14:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389125AbfKGNvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 08:51:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59384 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388980AbfKGNvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 08:51:01 -0500
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD1AA4ACA5
        for <kvm@vger.kernel.org>; Thu,  7 Nov 2019 13:51:00 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id m83so2323832qke.14
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 05:51:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nkZBN+5zxQ42o26GlAg4Gu8zR9MU5cE0CTJ+GrFRdeo=;
        b=gfgLnL6AXk3kAPQMbEbLOHvNEEBgdv882eaO0NBa3nY4TqtdTKk15lC9qTs+meRkXP
         WLg7JpomRDclLxCoY+FJCSn9YYycb3QLpT0u7STK4SZsji2LuSLEI0lyMK8UJyX3jmns
         vzh3IbtqrDI3vLuTD5qniyub2t3nyZ0g4apPUzuRku2dlWHIvo0OU6DFBwsIR6NOiNje
         9lBVGC0UkNdNhXQ1X06WOanK1jwe9o/YvhMO38yjYuit2O0q/LlHBvcG81eC2vJpexOd
         iUlApABnexOcHfAqTCeYzh05sJ07vqcZXFePVviCD5rfARzAGmmm/kMij38lV1esSX2S
         RwEw==
X-Gm-Message-State: APjAAAVvRgLXj7aVCE1Fdf8RQLpIs+hAAyWf2HDiCQvIKfGEBnuj7TZ9
        siA9xG9FHAm43a2KMkg8+lgKNk10s5dCPpIIHin36SO6EjSx2oTozbD0M7NCrHbTfaXHTFM+eOg
        uXzYSy/xQJbq7
X-Received: by 2002:a37:f605:: with SMTP id y5mr2957980qkj.288.1573134659999;
        Thu, 07 Nov 2019 05:50:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqwR0XN8Xkg7npgZmypT2TC+6FrvcOeN+9aUQy/VsChc7srS+8pQqGTXKUbO8NQlTjtab+Vs0A==
X-Received: by 2002:a37:f605:: with SMTP id y5mr2957932qkj.288.1573134659680;
        Thu, 07 Nov 2019 05:50:59 -0800 (PST)
Received: from redhat.com (bzq-79-178-12-128.red.bezeqint.net. [79.178.12.128])
        by smtp.gmail.com with ESMTPSA id p3sm1052072qkf.107.2019.11.07.05.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 05:50:58 -0800 (PST)
Date:   Thu, 7 Nov 2019 08:50:46 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
Subject: Re: [PATCH V10 6/6] docs: sample driver to demonstrate how to
 implement virtio-mdev framework
Message-ID: <20191107085013-mutt-send-email-mst@kernel.org>
References: <20191106133531.693-1-jasowang@redhat.com>
 <20191106133531.693-7-jasowang@redhat.com>
 <20191107040700-mutt-send-email-mst@kernel.org>
 <bd2f7796-8d88-0eb3-b55b-3ec062b186b7@redhat.com>
 <20191107061942-mutt-send-email-mst@kernel.org>
 <d09229bc-c3e4-8d4b-c28f-565fe150ced2@redhat.com>
 <20191107080834-mutt-send-email-mst@kernel.org>
 <b2265e3a-6f86-c21a-2ebd-d0e4eea2886f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2265e3a-6f86-c21a-2ebd-d0e4eea2886f@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 07, 2019 at 09:32:29PM +0800, Jason Wang wrote:
> 
> On 2019/11/7 下午9:08, Michael S. Tsirkin wrote:
> > On Thu, Nov 07, 2019 at 08:43:29PM +0800, Jason Wang wrote:
> > > On 2019/11/7 下午7:21, Michael S. Tsirkin wrote:
> > > > On Thu, Nov 07, 2019 at 06:18:45PM +0800, Jason Wang wrote:
> > > > > On 2019/11/7 下午5:08, Michael S. Tsirkin wrote:
> > > > > > On Wed, Nov 06, 2019 at 09:35:31PM +0800, Jason Wang wrote:
> > > > > > > This sample driver creates mdev device that simulate virtio net device
> > > > > > > over virtio mdev transport. The device is implemented through vringh
> > > > > > > and workqueue. A device specific dma ops is to make sure HVA is used
> > > > > > > directly as the IOVA. This should be sufficient for kernel virtio
> > > > > > > driver to work.
> > > > > > > 
> > > > > > > Only 'virtio' type is supported right now. I plan to add 'vhost' type
> > > > > > > on top which requires some virtual IOMMU implemented in this sample
> > > > > > > driver.
> > > > > > > 
> > > > > > > Acked-by: Cornelia Huck<cohuck@redhat.com>
> > > > > > > Signed-off-by: Jason Wang<jasowang@redhat.com>
> > > > > > I'd prefer it that we call this something else, e.g.
> > > > > > mvnet-loopback. Just so people don't expect a fully
> > > > > > functional device somehow. Can be renamed when applying?
> > > > > Actually, I plan to extend it as another standard network interface for
> > > > > kernel. It could be either a standalone pseudo device or a stack device.
> > > > > Does this sounds good to you?
> > > > > 
> > > > > Thanks
> > > > That's a big change in an interface so it's a good reason
> > > > to rename the driver at that point right?
> > > > Oherwise users of an old kernel would expect a stacked driver
> > > > and get a loopback instead.
> > > > 
> > > > Or did I miss something?
> > > 
> > > My understanding is that it was a sample driver in /doc. It should not be
> > > used in production environment. Otherwise we need to move it to
> > > driver/virtio.
> > > 
> > > But if you insist, I can post a V11.
> > > 
> > > Thanks
> > this can be a patch on top.
> 
> 
> Then maybe it's better just extend it to work as a normal networking device
> on top?
> 
> Thanks

That would be a substantial change. Maybe drop 6/6 for now until
we have a better handle on this?


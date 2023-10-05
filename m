Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9957B9DD1
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 15:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjJENzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 09:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243904AbjJENuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 09:50:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C54993C0
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 01:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uOgNX4AIC95ru5JSWRIRe9migKJKaA2qFd+sCFdwwS4=; b=4xlxmplRYCRqZYyHp0fVtta/rK
        gorf9RgXPaSK17QGfavJ1lBSl7JT9e47DGdcRtpu17mgAUhA0f5RGzpBPveErz8dAaSbs+PTHslWP
        DwbYiivx97bpSJvcWtwSnS8fC7Osy7CFu/0lPyieWYgd/y8hnedk0p/uYaZiEZPXD1Ta/YbJICLDG
        k23WI6SmCUTIWrILBwvK5D8VLC0QIqh4mZUoSrCYzKXjxKSaua4PFZhoovS2y5kjCbmIMeUA9u+Ak
        wx7uRk7aa5bch6+7pK1qS46pheInL7Jb9UfyaQWpujISBGf/Apg5z1x8mssBS3ja2hzDy0ZDUkTaI
        naRWeAQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qoK3O-001iHp-0H;
        Thu, 05 Oct 2023 08:49:54 +0000
Date:   Thu, 5 Oct 2023 01:49:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <ZR54shUxqgfIjg/p@infradead.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-11-yishaih@nvidia.com>
 <20230922055336-mutt-send-email-mst@kernel.org>
 <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
 <ZRpjClKM5mwY2NI0@infradead.org>
 <20231002151320.GA650762@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231002151320.GA650762@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023 at 12:13:20PM -0300, Jason Gunthorpe wrote:
> ??? This patch series is an implementation of changes that OASIS
> approved.

I think you are fundamentally missing my point.  This is not about
who publish a spec, but how we struture Linux code.

And the problem is that we trea vfio as a separate thing, and not an
integral part of the driver.  vfio being separate totally makes sense
for the original purpose of vfio, that is a a no-op passthrough of
a device to userspace.

But for all the augmented vfio use cases it doesn't, for them the
augmented vfio functionality is an integral part of the core driver.
That is true for nvme, virtio and I'd argue mlx5 as well.

So we need to stop registering separate pci_drivers for this kind
of functionality, and instead have an interface to the driver to
switch to certain functionalities.

E.g. for this case there should be no new vfio-virtio device, but
instead you should be able to switch the virtio device to an
fake-legacy vfio mode.

Assuming the whole thing actually makes sense, as the use case seems
a bit fishy to start with, but I'll leave that argument to the virtio
maintainers.

Similarly for nvme.  We'll never accept a separate nvme-live migration
vfio driver.  This functionality needs to be part of the nvme driver,
probed there and fully controlled there.

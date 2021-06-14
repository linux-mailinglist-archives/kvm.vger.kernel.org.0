Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE1F3A69A6
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 17:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbhFNPLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 11:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhFNPLH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 11:11:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A92BC061574;
        Mon, 14 Jun 2021 08:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=T+/oxM+z1BUuHd3fgDap8qJ+RDgIJZUJGDdgz0iT8y8=; b=UD2xKWxDFJgEJoUuqCUKG+J+4x
        gWq3kpq6cAriv1lFqug/uPQKNwU636xe2RJsSlIjmgH5EsOqowCCn1KnUyy9Dqdytpvtz8ZlOtx4c
        dla2Igc7SYrWhvA5WDHmx2lVMATlN9H4QsjBu5jwOuMlTWJPknvXszcbiShKY+0Fs60rDr1WH7R6+
        kwIkowdIqD/ZOX0U+NAbD04elyzTIx62jHbPQlZBXusqjf06Qz+dZm4lbySmocb5f9a5MM167pay0
        QyS5037QYkhEQyMmQ9f1uqehXUsWY+f7S3/9llmEdo2w09JYVySoa1jiVyqyAtDsvdtfOQpHwFupm
        I+4A1btQ==;
Received: from [2001:4bb8:19b:fdce:4b1a:b4aa:22d8:1629] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lsoCn-00EfeW-7E; Mon, 14 Jun 2021 15:08:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Allow mdev drivers to directly create the vfio_device (v2 / alternative)
Date:   Mon, 14 Jun 2021 17:08:36 +0200
Message-Id: <20210614150846.4111871-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is my alternative take on this series from Jason:

https://lore.kernel.org/dri-devel/87czsszi9i.fsf@redhat.com/T/

The mdev/vfio parts are exactly the same, but this solves the driver core
changes for the direct probing without the in/out flag that Greg hated,
which cause a little more work, but probably make the result better.

Original decription from Jason below:

The mdev bus's core part for managing the lifecycle of devices is mostly
as one would expect for a driver core bus subsystem.

However instead of having a normal 'struct device_driver' and binding the
actual mdev drivers through the standard driver core mechanisms it open
codes this with the struct mdev_parent_ops and provides a single driver
that shims between the VFIO core's struct vfio_device and the actual
device driver.

Instead, allow mdev drivers implement an actual struct mdev_driver and
directly call vfio_register_group_dev() in the probe() function for the
mdev. Arrange to bind the created mdev_device to the mdev_driver that is
provided by the end driver.

The actual execution flow doesn't change much, eg what was
parent_ops->create is now device_driver->probe and it is called at almost
the exact same time - except under the normal control of the driver core.

Ultimately converting all the drivers unlocks a fair number of additional
VFIO simplifications and cleanups.

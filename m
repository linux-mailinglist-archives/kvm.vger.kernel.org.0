Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E093134EC99
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 17:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhC3Pe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 11:34:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232403AbhC3Peo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 11:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617118484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6DcZ88aD4QgGvF1+XZUsBzAcnmKsroPq30JRDzuUn0E=;
        b=Q3ABcl+C2QZb7O6UE5LtJC5XjbuW3ov46RwX0AP8ORd0ON65xISK/lXTbvOvTyH+hUxrik
        hnOu9RSYLRU9y7OEcbMD8XOzDHB6RhCZEIdfl+FD/UNRAg6gnc7euhwDJkTEeWZtXGcSEx
        0DxdayUZU/sIs6mDd/J84B9lFdiSjk8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-yyCxAwMrOGGdeEhFxBPv8A-1; Tue, 30 Mar 2021 11:34:42 -0400
X-MC-Unique: yyCxAwMrOGGdeEhFxBPv8A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 262A287A82A;
        Tue, 30 Mar 2021 15:34:40 +0000 (UTC)
Received: from gondolin (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B23019C44;
        Tue, 30 Mar 2021 15:34:33 +0000 (UTC)
Date:   Tue, 30 Mar 2021 17:34:31 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dong Jia Shi <bjsdjshi@linux.vnet.ibm.com>,
        Neo Jia <cjia@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 05/18] vfio/mdev: Do not allow a mdev_type to have a
 NULL parent pointer
Message-ID: <20210330173431.66ab8379.cohuck@redhat.com>
In-Reply-To: <5-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
        <5-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Mar 2021 14:55:22 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> There is a small race where the parent is NULL even though the kobj has
> already been made visible in sysfs.
> 
> For instance the attribute_group is made visible in sysfs_create_files()
> and the mdev_type_attr_show() does:
> 
>     ret = attr->show(kobj, type->parent->dev, buf);
> 
> Which will crash on NULL parent. Move the parent setup to before the type
> pointer leaves the stack frame.
> 
> Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/mdev_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


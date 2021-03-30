Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84AD34ECE4
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 17:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhC3Pun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 11:50:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232131AbhC3PuZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 11:50:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617119422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NigF7Ow99qUzLJWT/qP9K5tagrqivjqS+Gys7gTRazc=;
        b=AKmb4F84yq/0Ri/De1j64bfFvjiqIdQ9Er/4ePFbxb6wUM2yTKq1BAsong7Es5Vo1FcatL
        vp/v+JKkx9MsWzVt3mddmHO6T4XJGUH8BjPgVF55ES2pNMUCYCbDTGuNDwZ1UO/kLYWVAa
        gEEVHHf/3Gs6KomwNi9tFXAva4PUofY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-f1xmoJQmOU6dGCxq288OxQ-1; Tue, 30 Mar 2021 11:50:18 -0400
X-MC-Unique: f1xmoJQmOU6dGCxq288OxQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3D5E1922963;
        Tue, 30 Mar 2021 15:50:16 +0000 (UTC)
Received: from gondolin (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FA085D730;
        Tue, 30 Mar 2021 15:50:11 +0000 (UTC)
Date:   Tue, 30 Mar 2021 17:50:09 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 08/18] vfio/mdev: Reorganize mdev_device_create()
Message-ID: <20210330175009.4ef09a73.cohuck@redhat.com>
In-Reply-To: <8-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
        <8-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Mar 2021 14:55:25 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Once the memory for the struct mdev_device is allocated it should
> immediately be device_initialize()'d and filled in so that put_device()
> can always be used to undo the allocation.
> 
> Place the mdev_get/put_parent() so that they are clearly protecting the
> mdev->parent pointer. Move the final put to the release function so that
> the lifetime rules are trivial to understand.
> 
> Remove mdev_device_free() as the release function via device_put() is now
> usable in all cases.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/mdev_core.c | 46 +++++++++++++++--------------------
>  1 file changed, 20 insertions(+), 26 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


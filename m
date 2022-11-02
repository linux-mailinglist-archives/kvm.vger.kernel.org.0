Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F95616648
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 16:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiKBPe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 11:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiKBPe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 11:34:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEFE22B30
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 08:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667403229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OypQqLWai0VaMJwiQgOKKG3cobC5fKhMwKsuUswxphk=;
        b=GFIXWQA3mkDgWIVjwlZgeLxG8Jm8wKiU2xCNH1q2+HNefmBYStkevu2lOMi8M3QjgM9k8y
        UHpzwXj6pmHWsE1Ig5QXA0mjOc71uZTM1GpsByFLq8vwtF2Co9A5tSjScPRm7q8Ug8RxXY
        2bn3KGz216/9EEggmMtVPPkE6zAplIo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-ywcGUWlbNua3SadPps_K9w-1; Wed, 02 Nov 2022 11:33:42 -0400
X-MC-Unique: ywcGUWlbNua3SadPps_K9w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C0D91C0A589;
        Wed,  2 Nov 2022 15:33:36 +0000 (UTC)
Received: from localhost (unknown [10.39.194.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 917E71121339;
        Wed,  2 Nov 2022 15:33:35 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Cc:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH v2 7/7] vfio: Remove vfio_free_device
In-Reply-To: <20221102150152.2521475-8-farman@linux.ibm.com>
Organization: Red Hat GmbH
References: <20221102150152.2521475-1-farman@linux.ibm.com>
 <20221102150152.2521475-8-farman@linux.ibm.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Wed, 02 Nov 2022 16:33:34 +0100
Message-ID: <87pme5s75d.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02 2022, Eric Farman <farman@linux.ibm.com> wrote:

> With the "mess" sorted out, we should be able to inline the
> vfio_free_device call introduced by commit cb9ff3f3b84c
> ("vfio: Add helpers for unifying vfio_device life cycle")
> and remove them from driver release callbacks.
>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c      |  1 -
>  drivers/s390/cio/vfio_ccw_ops.c       |  2 --
>  drivers/s390/crypto/vfio_ap_ops.c     |  6 ------
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c     |  1 -
>  drivers/vfio/pci/vfio_pci_core.c      |  1 -
>  drivers/vfio/platform/vfio_amba.c     |  1 -
>  drivers/vfio/platform/vfio_platform.c |  1 -
>  drivers/vfio/vfio_main.c              | 22 ++++------------------
>  include/linux/vfio.h                  |  1 -
>  samples/vfio-mdev/mbochs.c            |  1 -
>  samples/vfio-mdev/mdpy.c              |  1 -
>  samples/vfio-mdev/mtty.c              |  1 -
>  12 files changed, 4 insertions(+), 35 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


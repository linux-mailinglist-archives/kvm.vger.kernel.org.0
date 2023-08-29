Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74D378CC0D
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 20:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238096AbjH2S2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 14:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237352AbjH2S2g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 14:28:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21A3184
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 11:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693333668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AcD4J76ihqQTKaowv7x00EfWkw4WAAUb9QrDpiQpFpI=;
        b=FdM4sr0ARpMSb0jlFdtJwCI8cJdH2fU/ZehQJhQQ3FihhKx1yrznT+7CYC++0dUS8ujHXP
        KTABh8bY8CBn9j6G/nvTgiz9uGB0ES8cEYG56B4cKWa7m8S8EJCsc7oueTuiVaXaex+bvf
        ABwaCyVPXcHpkxneIPz2rBvCKq4R45o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-zHIZJxAdPruzFPHaxQEUSA-1; Tue, 29 Aug 2023 14:27:43 -0400
X-MC-Unique: zHIZJxAdPruzFPHaxQEUSA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 489D4185A78F;
        Tue, 29 Aug 2023 18:27:40 +0000 (UTC)
Received: from localhost (unknown [10.39.192.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B63B01678B;
        Tue, 29 Aug 2023 18:27:39 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     David Laight <David.Laight@ACULAB.COM>,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH v2 0/3] vfio: use __aligned_u64 for ioctl structs
Date:   Tue, 29 Aug 2023 14:27:17 -0400
Message-ID: <20230829182720.331083-1-stefanha@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
- Rebased onto https://github.com/awilliam/linux-vfio.git next to get the
  vfio_iommu_type1_info pad field [Kevin]
- Fixed min(minsz, sizeof(dmabuf)) -> min(dmabuf.argsz, sizeof(dmabuf)) [Jason, Kevin]
- Squashed Patch 3 (vfio_iommu_type1_info) into Patch 1 since it is trivial now
  that the padding field is already there.

Jason Gunthorpe <jgg@nvidia.com> pointed out that u64 VFIO ioctl struct fields
have architecture-dependent alignment. iommufd already uses __aligned_u64 to
avoid this problem.

See the __aligned_u64 typedef in <uapi/linux/types.h> for details on why it is
a good idea for kernel<->user interfaces.

This series modifies the VFIO ioctl structs to use __aligned_u64. Some of the
changes preserve the existing memory layout on all architectures, so I put them
together into the first patch. The remaining patches are for structs where
explanation is necessary about why changing the memory layout does not break
the uapi.

Stefan Hajnoczi (3):
  vfio: trivially use __aligned_u64 for ioctl structs
  vfio: use __aligned_u64 in struct vfio_device_gfx_plane_info
  vfio: use __aligned_u64 in struct vfio_device_ioeventfd

 include/uapi/linux/vfio.h        | 26 ++++++++++++++------------
 drivers/gpu/drm/i915/gvt/kvmgt.c |  4 +++-
 samples/vfio-mdev/mbochs.c       |  6 ++++--
 samples/vfio-mdev/mdpy.c         |  4 +++-
 4 files changed, 24 insertions(+), 16 deletions(-)

-- 
2.41.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D11776AA5
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 23:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbjHIVEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 17:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjHIVEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 17:04:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705F4C3
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 14:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691615000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JpA3RFdMht7iBEs06qI33SwAayiTbeDZD4PgWl3Pj98=;
        b=PCLZSrioJftvo/ZEMMxyOLnOw9vTWHc4VlGE/u3YKg+KZL+XRcJ7ZJIAKf9+akEC1I2R0Y
        TRGk79MYSO7Y9wmwFoyVS+aGiplbNImDojfQ7Dlf1ZiAtFyhwEhaNXH/Aob11zxpGvz20G
        1kAIZS6Azo0riR+YaUzaQMxugVw8gQQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-iZaueV4sNduKqMdVnyN6EQ-1; Wed, 09 Aug 2023 17:03:16 -0400
X-MC-Unique: iZaueV4sNduKqMdVnyN6EQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2619A101A59A;
        Wed,  9 Aug 2023 21:03:16 +0000 (UTC)
Received: from localhost (unknown [10.39.192.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E7065CBFF;
        Wed,  9 Aug 2023 21:02:50 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Tian, Kevin" <kevin.tian@intel.com>, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 0/4] vfio: use __aligned_u64 for ioctl structs
Date:   Wed,  9 Aug 2023 17:02:44 -0400
Message-ID: <20230809210248.2898981-1-stefanha@redhat.com>
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

Jason Gunthorpe <jgg@ziepe.ca> pointed out that u64 VFIO ioctl struct fields
have architecture-dependent alignment. iommufd already uses __aligned_u64 to
avoid this problem.

Reasons for using __aligned_u64 include avoiding potential information leaks
due to architecture-specific holes in structs and 32-bit userspace on 64-bit
kernel ioctl compatibility issues. See the __aligned_u64 typedef in
<uapi/linux/types.h> for details.

This series modifies the VFIO ioctl structs to use __aligned_u64. Some of the
changes preserve the existing memory layout on all architectures, so I put them
together into the first patch. The remaining patches are for structs where
explanation is necessary about why changing the memory layout does not break
the uapi.

Stefan Hajnoczi (4):
  vfio: trivially use __aligned_u64 for ioctl structs
  vfio: use __aligned_u64 in struct vfio_device_gfx_plane_info
  vfio: use __aligned_u64 in struct vfio_iommu_type1_info
  vfio: use __aligned_u64 in struct vfio_device_ioeventfd

 include/uapi/linux/vfio.h        | 27 +++++++++++++++------------
 drivers/gpu/drm/i915/gvt/kvmgt.c |  4 +++-
 drivers/vfio/vfio_iommu_type1.c  | 11 ++---------
 samples/vfio-mdev/mbochs.c       |  6 ++++--
 samples/vfio-mdev/mdpy.c         |  4 +++-
 5 files changed, 27 insertions(+), 25 deletions(-)

-- 
2.41.0


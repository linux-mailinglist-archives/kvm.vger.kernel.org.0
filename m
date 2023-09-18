Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445B87A548D
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 22:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjIRU5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 16:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjIRU5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 16:57:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E0890
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 13:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695070583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Xi9oKb7wFPrQQdMnj2W18GElU0mEnwlSVsbSjcB2VJk=;
        b=V4M9JoRg4DD8gVnC5/6Hy0wbQij7WpmJCp17c4XuaJYT8Qr0VazqfnedmHnsJRbBGzltqY
        oCFMHVnZItEfTZGdkN/KZivM3hDfC/q/BbY+QzHbtkyfMTxoLI31ePtrJX/CMOH+exZxl+
        IxInhhKBFvZDBaytFVd1sW6J2sszpmA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-cBnr55QAP7yX35TbiBvzXA-1; Mon, 18 Sep 2023 16:56:20 -0400
X-MC-Unique: cBnr55QAP7yX35TbiBvzXA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDDE585A5A8;
        Mon, 18 Sep 2023 20:56:19 +0000 (UTC)
Received: from localhost (unknown [10.39.195.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 39B7540C6EA8;
        Mon, 18 Sep 2023 20:56:18 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Laight <David.Laight@ACULAB.COM>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH v3 0/3] vfio: use __aligned_u64 for ioctl structs
Date:   Mon, 18 Sep 2023 16:56:14 -0400
Message-ID: <20230918205617.1478722-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3:
- Remove the output struct sizing code that copied out zeroed fields at the end
  of the struct. Alex pointed out that new fields (or repurposing a field that
  was previously reserved) must be guarded by a flag and this means userspace
  won't access those fields when they are absent.
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
 drivers/gpu/drm/i915/gvt/kvmgt.c |  2 +-
 samples/vfio-mdev/mbochs.c       |  2 +-
 samples/vfio-mdev/mdpy.c         |  2 +-
 4 files changed, 17 insertions(+), 15 deletions(-)

-- 
2.41.0


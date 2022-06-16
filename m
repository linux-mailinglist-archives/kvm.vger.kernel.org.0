Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70AC354EB52
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 22:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378655AbiFPUir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 16:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378367AbiFPUiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 16:38:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D5755DA11
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 13:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655411924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y0JgXGGQjQ+76tb5Qz2va2beXsgHUHQKL0a2Si01Nko=;
        b=SiJGRcJcMIl4irP8mhllbiXGZyta5R8AS17TU3OM6EtIwGJatt9Sdxob8oxC1S+WeSD0qy
        G5d4b78cTe/IJ8A6Hd74s1bod2bZUL6Zv8A3z8Ah46wzYVzRkN8qOT0CrlzaBh+KGZlz01
        8EZ0i9/NfsH5mIluX+O4wmhCu4wt5C8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-tLVHOe1YMWWbnEfw6inD2Q-1; Thu, 16 Jun 2022 16:38:41 -0400
X-MC-Unique: tLVHOe1YMWWbnEfw6inD2Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 232643C10229;
        Thu, 16 Jun 2022 20:38:41 +0000 (UTC)
Received: from [172.30.41.16] (unknown [10.22.35.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA17D2026D2D;
        Thu, 16 Jun 2022 20:38:39 +0000 (UTC)
Subject: [PATCH v2 0/2] Improve vfio-pci primary GPU assignment behavior
From:   Alex Williamson <alex.williamson@redhat.com>
To:     corbet@lwn.net, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, tzimmermann@suse.de, airlied@linux.ie,
        daniel@ffwll.ch, deller@gmx.de, gregkh@linuxfoundation.org
Cc:     Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Thu, 16 Jun 2022 14:38:39 -0600
Message-ID: <165541020563.1955826.16350888595945658159.stgit@omen>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When assigning a primary graphics device to VM through vfio-pci device
assignment, users often prevent binding of the native PCI graphics
driver to avoid device initialization conflicts, however firmware
console drivers may still be attached to the device which can often be
cumbersome to manually unbind or exclude via cmdline options.

This series proposes to move the DRM aperture helpers out to
drivers/video/ to make it more accessible to drivers like vfio-pci,
which have neither dependencies on DRM code nor a struct drm_driver
to present to existing interfaces.  vfio-pci can then trivially call
into the aperture helpers to remove conflicting drivers, rather than
open coding it ourselves as was proposed with a new symbol export in
v1 of this series[1].

Thanks to Thomas for splitting out the aperture code with new
documentation.

Thomas had proposed this going through the vfio tree with appropriate
stakeholder acks, that's fine with me, but I'm also open to it going
through the DRM tree given that the vfio-pci-core change is even more
trivial now and the bulk of the changes are DRM/video paths.  Thanks,

Alex

[1]https://lore.kernel.org/all/165453797543.3592816.6381793341352595461.stgit@omen/

---

Alex Williamson (1):
      vfio/pci: Remove console drivers

Thomas Zimmermann (1):
      drm: Implement DRM aperture helpers under video/


 Documentation/driver-api/aperture.rst |  13 +
 Documentation/driver-api/index.rst    |   1 +
 drivers/gpu/drm/drm_aperture.c        | 174 +------------
 drivers/gpu/drm/tiny/Kconfig          |   1 +
 drivers/vfio/pci/vfio_pci_core.c      |   5 +
 drivers/video/Kconfig                 |   6 +
 drivers/video/Makefile                |   2 +
 drivers/video/aperture.c              | 340 ++++++++++++++++++++++++++
 drivers/video/console/Kconfig         |   1 +
 drivers/video/fbdev/Kconfig           |   7 +-
 include/linux/aperture.h              |  56 +++++
 11 files changed, 440 insertions(+), 166 deletions(-)
 create mode 100644 Documentation/driver-api/aperture.rst
 create mode 100644 drivers/video/aperture.c
 create mode 100644 include/linux/aperture.h


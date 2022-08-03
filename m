Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA9F589141
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 19:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbiHCRX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 13:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236321AbiHCRXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 13:23:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D666F53D06
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 10:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659547404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=slZPL044q+C7rvNYiFVId3G4VN1Old5kmH5KWkstxKI=;
        b=ULwOmNT7I59igavVvPM3ulz/QAupCS2ZpYPY/HnHYsgjAImd8x/DMhPoDGTE1TBTaTbAiw
        t4W8gKMgTz1V3CNDuxKKNhERlW/3jXnJitd5erZQNEdMLsGvY+OMdPTOIsWkMx4vVkoOn1
        oo5e2ypm/kAtbAl50Jf8kIiH+6hKN/o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-PWmVzDHwPjewsbEIYBPatg-1; Wed, 03 Aug 2022 13:18:55 -0400
X-MC-Unique: PWmVzDHwPjewsbEIYBPatg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CBE810AF7C9;
        Wed,  3 Aug 2022 17:18:26 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE7DA1121314;
        Wed,  3 Aug 2022 17:18:23 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Parav Pandit <parav@mellanox.com>, Cindy Lu <lulu@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: [PATCH v3 0/7] ASID support in vhost-vdpa net
Date:   Wed,  3 Aug 2022 19:18:14 +0200
Message-Id: <20220803171821.481336-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Control VQ is the way net devices use to send changes to the device state, =
like=0D
the number of active queues or its mac address.=0D
=0D
QEMU needs to intercept this queue so it can track these changes and is abl=
e to=0D
migrate the device. It can do it from 1576dbb5bbc4 ("vdpa: Add x-svq to=0D
NetdevVhostVDPAOptions"). However, to enable x-svq implies to shadow all Vi=
rtIO=0D
device's virtqueues, which will damage performance.=0D
=0D
This series adds address space isolation, so the device and the guest=0D
communicate directly with them (passthrough) and CVQ communication is split=
 in=0D
two: The guest communicates with QEMU and QEMU forwards the commands to the=
=0D
device.=0D
=0D
This series is based on [1], and this needs to be applied on top of that.  =
Each=0D
one of them adds a feature on isolation and could be merged individually on=
ce=0D
conflicts are solved.=0D
=0D
Comments are welcome. Thanks!=0D
=0D
v3:=0D
- Do not return an error but just print a warning if vdpa device initializa=
tion=0D
  returns failure while getting AS num of VQ groups=0D
- Delete extra newline=0D
=0D
v2:=0D
- Much as commented on series [1], handle vhost_net backend through=0D
  NetClientInfo callbacks instead of directly.=0D
- Fix not freeing SVQ properly when device does not support CVQ=0D
- Add BIT_ULL missed checking device's backend feature for _F_ASID.=0D
=0D
[1] https://lists.nongnu.org/archive/html/qemu-devel/2022-08/msg00349.html=
=0D
=0D
Eugenio P=C3=A9rez (7):=0D
  linux-headers: Update kernel headers=0D
  vdpa: Use v->shadow_vqs_enabled in vhost_vdpa_svqs_start & stop=0D
  vdpa: Allocate SVQ unconditionally=0D
  vdpa: Add asid parameter to vhost_vdpa_dma_map/unmap=0D
  vdpa: Store x-svq parameter in VhostVDPAState=0D
  vhost_net: Add NetClientInfo prepare callback=0D
  vdpa: Always start CVQ in SVQ mode=0D
=0D
 include/hw/virtio/vhost-vdpa.h               |   8 +-=0D
 include/net/net.h                            |   2 +=0D
 include/standard-headers/asm-x86/bootparam.h |   7 +-=0D
 include/standard-headers/drm/drm_fourcc.h    |  69 +++++++++=0D
 include/standard-headers/linux/ethtool.h     |   1 +=0D
 include/standard-headers/linux/input.h       |  12 +-=0D
 include/standard-headers/linux/pci_regs.h    |   1 +=0D
 include/standard-headers/linux/vhost_types.h |  11 +-=0D
 include/standard-headers/linux/virtio_ids.h  |  14 +-=0D
 linux-headers/asm-arm64/kvm.h                |  27 ++++=0D
 linux-headers/asm-generic/unistd.h           |   4 +-=0D
 linux-headers/asm-riscv/kvm.h                |  20 +++=0D
 linux-headers/asm-riscv/unistd.h             |   3 +-=0D
 linux-headers/asm-x86/kvm.h                  |  11 +-=0D
 linux-headers/asm-x86/mman.h                 |  14 --=0D
 linux-headers/linux/kvm.h                    |  56 ++++++-=0D
 linux-headers/linux/userfaultfd.h            |  10 +-=0D
 linux-headers/linux/vfio.h                   |   4 +-=0D
 linux-headers/linux/vhost.h                  |  26 +++-=0D
 hw/net/vhost_net.c                           |   4 +=0D
 hw/virtio/vhost-vdpa.c                       |  65 ++++----=0D
 net/vhost-vdpa.c                             | 154 ++++++++++++++++++-=0D
 hw/virtio/trace-events                       |   4 +-=0D
 23 files changed, 434 insertions(+), 93 deletions(-)=0D
=0D
-- =0D
2.31.1=0D
=0D


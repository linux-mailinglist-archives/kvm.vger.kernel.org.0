Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441EE637D47
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 16:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiKXPxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 10:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiKXPxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 10:53:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1509A31201
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 07:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669305130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=sTAxewI3DqiTZRkLcenTI0cbA+1ByVgaqRGdvoCixb4=;
        b=Lezc7fsemuAup46PeMih5M9jrF2BQdkMwmEsOW+KBM3CxpIvHA7OwIKnf+l0zXqegyQq95
        iPfZaQjPbSnGRYBG+mTnMWneNy+J+PqUVLrHzuuUe4YeUZY8cUF/YKGPcrte1yzR29JMgd
        5uPPgBn3Hdw2NAZEMCpluCrZp0ndaWA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-gQ6U1SVXMP-Ak0e-zspWOQ-1; Thu, 24 Nov 2022 10:52:07 -0500
X-MC-Unique: gQ6U1SVXMP-Ak0e-zspWOQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32F5F85A5A6;
        Thu, 24 Nov 2022 15:52:06 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1F3E111E3F8;
        Thu, 24 Nov 2022 15:52:02 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Eli Cohen <eli@mellanox.com>, Jason Wang <jasowang@redhat.com>,
        Cindy Lu <lulu@redhat.com>, Parav Pandit <parav@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH for 8.0 v8 00/12] ASID support in vhost-vdpa net
Date:   Thu, 24 Nov 2022 16:51:46 +0100
Message-Id: <20221124155158.2109884-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
This patch add new features so is targeted for qemu 8.0.=0D
=0D
Comments are welcome. Thanks!=0D
=0D
v8:=0D
- Do not allocate iova_tree on net_init_vhost_vdpa if only CVQ is=0D
  shadowed. Move the iova_tree allocation to=0D
  vhost_vdpa_net_cvq_start and vhost_vdpa_net_cvq_stop in this case.=0D
=0D
v7:=0D
- Never ask for number of address spaces, just react if isolation is not=0D
  possible.=0D
- Return ASID ioctl errors instead of masking them as if the device has=0D
  no asid.=0D
- Rename listener_shadow_vq to shadow_data=0D
- Move comment on zero initailization of vhost_vdpa_dma_map above the=0D
  functions.=0D
- Add VHOST_VDPA_GUEST_PA_ASID macro.=0D
=0D
v6:=0D
- Do not allocate SVQ resources like file descriptors if SVQ cannot be used=
.=0D
- Disable shadow CVQ if the device does not support it because of net=0D
  features.=0D
=0D
v5:=0D
- Move vring state in vhost_vdpa_get_vring_group instead of using a=0D
  parameter.=0D
- Rename VHOST_VDPA_NET_CVQ_PASSTHROUGH to VHOST_VDPA_NET_DATA_ASID=0D
=0D
v4:=0D
- Rebased on last CVQ start series, that allocated CVQ cmd bufs at load=0D
- Squash vhost_vdpa_cvq_group_is_independent.=0D
- Do not check for cvq index on vhost_vdpa_net_prepare, we only have one=0D
  that callback registered in that NetClientInfo.=0D
- Add comment specifying behavior if device does not support _F_ASID=0D
- Update headers to a later Linux commit to not to remove SETUP_RNG_SEED=0D
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
Eugenio P=C3=A9rez (12):=0D
  vdpa: use v->shadow_vqs_enabled in vhost_vdpa_svqs_start & stop=0D
  vhost: set SVQ device call handler at SVQ start=0D
  vhost: allocate SVQ device file descriptors at device start=0D
  vhost: move iova_tree set to vhost_svq_start=0D
  vdpa: add vhost_vdpa_net_valid_svq_features=0D
  vdpa: extract vhost_vdpa_svq_allocate_iova_tree=0D
  vdpa: move SVQ vring features check to net/=0D
  vdpa: allocate SVQ array unconditionally=0D
  vdpa: add asid parameter to vhost_vdpa_dma_map/unmap=0D
  vdpa: store x-svq parameter in VhostVDPAState=0D
  vdpa: add shadow_data to vhost_vdpa=0D
  vdpa: always start CVQ in SVQ mode if possible=0D
=0D
 hw/virtio/vhost-shadow-virtqueue.h |   5 +-=0D
 include/hw/virtio/vhost-vdpa.h     |  16 ++-=0D
 hw/virtio/vhost-shadow-virtqueue.c |  44 ++------=0D
 hw/virtio/vhost-vdpa.c             | 126 ++++++++++-----------=0D
 net/vhost-vdpa.c                   | 172 ++++++++++++++++++++++++-----=0D
 hw/virtio/trace-events             |   4 +-=0D
 6 files changed, 236 insertions(+), 131 deletions(-)=0D
=0D
-- =0D
2.31.1=0D
=0D


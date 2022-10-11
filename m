Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D665FB098
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 12:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiJKKmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 06:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiJKKmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 06:42:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34187FF84
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 03:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665484923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=KFzwfI4xWWrXGzPF6GL7m7oIfEjaLoepedAPPZ02oI4=;
        b=Q8hXMYRf0+few8PDZ7j3FqmwPKRPeAbB8U+fihWCMytPxf8LQIKNHJr9p1Nc/uuykfZNMe
        X9phTxwRdHlxkv4gW9PE7MD9kB3qZAgO5v9QD625hCv4UCWqAMaXPVaaalcMT3zV9MyaeA
        3YqG9TZxLixZ6Wo9L0i+NDeYpJ4AHE8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-dClyIeZzMOWJ4f8Yee3m4w-1; Tue, 11 Oct 2022 06:42:00 -0400
X-MC-Unique: dClyIeZzMOWJ4f8Yee3m4w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15FAF299E750;
        Tue, 11 Oct 2022 10:42:00 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D01BA492B09;
        Tue, 11 Oct 2022 10:41:56 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Gautam Dawar <gdawar@xilinx.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Cindy Lu <lulu@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Harpreet Singh Anand <hanand@xilinx.com>
Subject: [PATCH v5 0/6] ASID support in vhost-vdpa net
Date:   Tue, 11 Oct 2022 12:41:48 +0200
Message-Id: <20221011104154.1209338-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
Comments are welcome. Thanks!=0D
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
Eugenio P=C3=A9rez (6):=0D
  vdpa: Use v->shadow_vqs_enabled in vhost_vdpa_svqs_start & stop=0D
  vdpa: Allocate SVQ unconditionally=0D
  vdpa: Add asid parameter to vhost_vdpa_dma_map/unmap=0D
  vdpa: Store x-svq parameter in VhostVDPAState=0D
  vdpa: Add listener_shadow_vq to vhost_vdpa=0D
  vdpa: Always start CVQ in SVQ mode=0D
=0D
 include/hw/virtio/vhost-vdpa.h |  10 ++-=0D
 hw/virtio/vhost-vdpa.c         |  75 ++++++++++---------=0D
 net/vhost-vdpa.c               | 128 ++++++++++++++++++++++++++++++---=0D
 hw/virtio/trace-events         |   4 +-=0D
 4 files changed, 170 insertions(+), 47 deletions(-)=0D
=0D
-- =0D
2.31.1=0D
=0D


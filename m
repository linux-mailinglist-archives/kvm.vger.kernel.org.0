Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF8F3663F1
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 05:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbhDUDWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 23:22:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38575 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233927AbhDUDWL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 23:22:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618975296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GEfjyJT9pCdQ1S+UliWsNNDLnxg2PWz47J1URl6HOzU=;
        b=eEypCuRSDzs0HwL76gE4p7yCtBCnHwUr2m1t7Wvn7UaH2LXMW9Jr3CNY4a5D92Q+2qQLJv
        09ibMyGY/uabo2HmXmKIwVMH0caipuBLuTnhRcHOT7zDhQtHZaVM+ZlCzjcbIR8luqGY6K
        od6OZZ93fmVu7d9IHk2Keba3vrSRoSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-b2XJ9duBPvGdM2cnsCx9ww-1; Tue, 20 Apr 2021 23:21:33 -0400
X-MC-Unique: b2XJ9duBPvGdM2cnsCx9ww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84BEA8189C6;
        Wed, 21 Apr 2021 03:21:31 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-189.pek2.redhat.com [10.72.13.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F6836064B;
        Wed, 21 Apr 2021 03:21:19 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        martin.radev@aisec.fraunhofer.de, konrad.wilk@oracle.com,
        kvm@vger.kernel.org
Subject: [RFC PATCH 0/7] Untrusted device support for virtio
Date:   Wed, 21 Apr 2021 11:21:10 +0800
Message-Id: <20210421032117.5177-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All:

Sometimes, the driver doesn't trust the device. This is usually
happens for the encrtpyed VM or VDUSE[1]. In both cases, technology
like swiotlb is used to prevent the poking/mangling of memory from the
device. But this is not sufficient since current virtio driver may
trust what is stored in the descriptor table (coherent mapping) for
performing the DMA operations like unmap and bounce so the device may
choose to utilize the behaviour of swiotlb to perform attacks[2].

For double insurance, to protect from a malicous device, when DMA API
is used for the device, this series store and use the descriptor
metadata in an auxiliay structure which can not be accessed via
swiotlb instead of the ones in the descriptor table. Actually, we've
almost achieved that through packed virtqueue and we just need to fix
a corner case of handling mapping errors. For split virtqueue we just
follow what's done in the packed.

Note that we don't duplicate descriptor medata for indirect
descriptors since it uses stream mapping which is read only so it's
safe if the metadata of non-indirect descriptors are correct.

The behaivor for non DMA API is kept for minimizing the performance
impact.

Slightly tested with packed on/off, iommu on/of, swiotlb force/off in
the guest.

Please review.

[1] https://lore.kernel.org/netdev/fab615ce-5e13-a3b3-3715-a4203b4ab010@redhat.com/T/
[2] https://yhbt.net/lore/all/c3629a27-3590-1d9f-211b-c0b7be152b32@redhat.com/T/#mc6b6e2343cbeffca68ca7a97e0f473aaa871c95b

Jason Wang (7):
  virtio-ring: maintain next in extra state for packed virtqueue
  virtio_ring: rename vring_desc_extra_packed
  virtio-ring: factor out desc_extra allocation
  virtio_ring: secure handling of mapping errors
  virtio_ring: introduce virtqueue_desc_add_split()
  virtio: use err label in __vring_new_virtqueue()
  virtio-ring: store DMA metadata in desc_extra for split virtqueue

 drivers/virtio/virtio_ring.c | 189 ++++++++++++++++++++++++++---------
 1 file changed, 141 insertions(+), 48 deletions(-)

-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CA439B22B
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 07:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhFDFzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 01:55:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229831AbhFDFzw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Jun 2021 01:55:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622786046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JcMYDN5e5/VcbzKkSMYluKgdtznxbeNg+SJYhFB6TPM=;
        b=BiZLy6VOqAVsMJdUyPfJR+Etkb3csZvRebrmd5+6sGEi5bIJliLOMsSGPpYLqlz9JhORO9
        pizt4IjWK0SYT0DajfMM3rbV/3TMhEjMPF3zafjrD/tnTMut3f80Gum00ZlUvt1qH3VhNQ
        Gfc6hT68/XgI1ZsGjW7o1FDZnjp/PHg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-FfAhthQVOtiRULiLeh5enA-1; Fri, 04 Jun 2021 01:54:05 -0400
X-MC-Unique: FfAhthQVOtiRULiLeh5enA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F41F107ACE3;
        Fri,  4 Jun 2021 05:54:03 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-212.pek2.redhat.com [10.72.12.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A98BE5DEAD;
        Fri,  4 Jun 2021 05:53:52 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, hch@infradead.org,
        ak@linux.intel.com, luto@kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 0/7] Do not read from descriptor ring
Date:   Fri,  4 Jun 2021 13:53:43 +0800
Message-Id: <20210604055350.58753-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi:

The virtio driver should not trust the device. This beame more urgent
for the case of encrtpyed VM or VDUSE[1]. In both cases, technology
like swiotlb/IOMMU is used to prevent the poking/mangling of memory
from the device. But this is not sufficient since current virtio
driver may trust what is stored in the descriptor table (coherent
mapping) for performing the DMA operations like unmap and bounce so
the device may choose to utilize the behaviour of swiotlb to perform
attacks[2].

To protect from a malicous device, this series store and use the
descriptor metadata in an auxiliay structure which can not be accessed
via swiotlb/device instead of the ones in the descriptor table. This
means the descriptor table is write-only from the view of the driver.

Actually, we've almost achieved that through packed virtqueue and we
just need to fix a corner case of handling mapping errors. For split
virtqueue we just follow what's done in the packed.

Note that we don't duplicate descriptor medata for indirect
descriptors since it uses stream mapping which is read only so it's
safe if the metadata of non-indirect descriptors are correct.

For split virtqueue, the change increase the footprint due the the
auxiliary metadata but it's almost neglectlable in simple test like
pktgen and netperf TCP stream (slightly noticed in a 40GBE environment
with more CPU usage).

Slightly tested with packed on/off, iommu on/of, swiotlb force/off in
the guest.

Note that this series tries to fix the attack via descriptor
ring. The other cases (used ring and config space) will be fixed by
other series or patches.

Please review.

Changes from RFC V2:
- no code change
- twaeak the commit log a little bit

Changes from RFC V1:
- Always use auxiliary metadata for split virtqueue
- Don't read from descripto when detaching indirect descriptor

Jason Wang (7):
  virtio-ring: maintain next in extra state for packed virtqueue
  virtio_ring: rename vring_desc_extra_packed
  virtio-ring: factor out desc_extra allocation
  virtio_ring: secure handling of mapping errors
  virtio_ring: introduce virtqueue_desc_add_split()
  virtio: use err label in __vring_new_virtqueue()
  virtio-ring: store DMA metadata in desc_extra for split virtqueue

 drivers/virtio/virtio_ring.c | 201 +++++++++++++++++++++++++----------
 1 file changed, 144 insertions(+), 57 deletions(-)

-- 
2.25.1


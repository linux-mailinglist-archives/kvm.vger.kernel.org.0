Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A982374DE5
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 05:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhEFDVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 23:21:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50926 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230421AbhEFDVp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 23:21:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620271247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gbydVeY5N5w2QHP37+lnpEX2xyTMiLn/vdBHF5b1sNc=;
        b=hl8skKT7xboezdjAlPQ1QX0Yxu5ELNjBEBhpfj4EnGVjvdeOhAtWGthBtw+G04muIYqWXO
        F76+sLDHs7DBxFwBL+z3vDiFRO/J90OIu+W2IYK1xoTKYiH4p/ukVsmWDRQQfSRpFP/WJd
        JAsMsR4wQKMtcct/i9MRbMmYmgcL/Rc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-MouFwKIkOKSXWHLTMzNwpg-1; Wed, 05 May 2021 23:20:44 -0400
X-MC-Unique: MouFwKIkOKSXWHLTMzNwpg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 648C38015F4;
        Thu,  6 May 2021 03:20:42 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-159.pek2.redhat.com [10.72.13.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2096D19C46;
        Thu,  6 May 2021 03:20:31 +0000 (UTC)
Subject: Re: [RFC PATCH V2 0/7] Do not read from descripto ring
To:     mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, hch@infradead.org
References: <20210423080942.2997-1-jasowang@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0e9d70b7-6c8a-4ff5-1fa9-3c4f04885bb8@redhat.com>
Date:   Thu, 6 May 2021 11:20:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210423080942.2997-1-jasowang@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/4/23 ÏÂÎç4:09, Jason Wang Ð´µÀ:
> Hi:
>
> Sometimes, the driver doesn't trust the device. This is usually
> happens for the encrtpyed VM or VDUSE[1]. In both cases, technology
> like swiotlb is used to prevent the poking/mangling of memory from the
> device. But this is not sufficient since current virtio driver may
> trust what is stored in the descriptor table (coherent mapping) for
> performing the DMA operations like unmap and bounce so the device may
> choose to utilize the behaviour of swiotlb to perform attacks[2].
>
> To protect from a malicous device, this series store and use the
> descriptor metadata in an auxiliay structure which can not be accessed
> via swiotlb instead of the ones in the descriptor table. This means
> the descriptor table is write-only from the view of the driver.
>
> Actually, we've almost achieved that through packed virtqueue and we
> just need to fix a corner case of handling mapping errors. For split
> virtqueue we just follow what's done in the packed.
>
> Note that we don't duplicate descriptor medata for indirect
> descriptors since it uses stream mapping which is read only so it's
> safe if the metadata of non-indirect descriptors are correct.
>
> For split virtqueue, the change increase the footprint due the the
> auxiliary metadata but it's almost neglectlable in the simple test
> like pktgen or netpef.
>
> Slightly tested with packed on/off, iommu on/of, swiotlb force/off in
> the guest.
>
> Please review.
>
> Changes from V1:
> - Always use auxiliary metadata for split virtqueue
> - Don't read from descripto when detaching indirect descriptor


Hi Michael:

Our QE see no regression on the perf test for 10G but some regressions 
(5%-10%) on 40G card.

I think this is expected since we increase the footprint, are you OK 
with this and we can try to optimize on top or you have other ideas?

Thanks


>
> [1]
> https://lore.kernel.org/netdev/fab615ce-5e13-a3b3-3715-a4203b4ab010@redhat.com/T/
> [2]
> https://yhbt.net/lore/all/c3629a27-3590-1d9f-211b-c0b7be152b32@redhat.com/T/#mc6b6e2343cbeffca68ca7a97e0f473aaa871c95b
>
> Jason Wang (7):
>    virtio-ring: maintain next in extra state for packed virtqueue
>    virtio_ring: rename vring_desc_extra_packed
>    virtio-ring: factor out desc_extra allocation
>    virtio_ring: secure handling of mapping errors
>    virtio_ring: introduce virtqueue_desc_add_split()
>    virtio: use err label in __vring_new_virtqueue()
>    virtio-ring: store DMA metadata in desc_extra for split virtqueue
>
>   drivers/virtio/virtio_ring.c | 201 +++++++++++++++++++++++++----------
>   1 file changed, 144 insertions(+), 57 deletions(-)
>


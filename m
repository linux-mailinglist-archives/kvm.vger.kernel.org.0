Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1F120C680
	for <lists+kvm@lfdr.de>; Sun, 28 Jun 2020 08:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgF1GfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Jun 2020 02:35:02 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49939 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725958AbgF1GfC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 28 Jun 2020 02:35:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593326100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xhEZEqP2gOLLuRIAsrUzWdxl5PbmR38JJbcII9F4Ac4=;
        b=aO/r0+YrkQfek1PApjd0W+zNq9HsBm6we7E0fZ4znrborKusBP4PQYDb3xzKcrXuhM2yHh
        cdnXWw8y82OpbsCK57Ykx5sRVAwhm1aSnTs2kfgd2DFPwq36MHBqHwz99VaZ89NbpW49AP
        wuS2Dq2u1XuYq9xDf4rUTjZ52QmDOuk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-vCOxReYvN-OiXDQQ_CFRiw-1; Sun, 28 Jun 2020 02:34:58 -0400
X-MC-Unique: vCOxReYvN-OiXDQQ_CFRiw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6761980183C;
        Sun, 28 Jun 2020 06:34:57 +0000 (UTC)
Received: from [10.72.13.164] (ovpn-13-164.pek2.redhat.com [10.72.13.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 497F55BAD6;
        Sun, 28 Jun 2020 06:34:45 +0000 (UTC)
Subject: Re: [RFC 0/3] virtio: NUMA-aware memory allocation
To:     Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20200625135752.227293-1-stefanha@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9cd725b5-4954-efd9-4d1b-3a448a436472@redhat.com>
Date:   Sun, 28 Jun 2020 14:34:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200625135752.227293-1-stefanha@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/6/25 下午9:57, Stefan Hajnoczi wrote:
> These patches are not ready to be merged because I was unable to measure a
> performance improvement. I'm publishing them so they are archived in case
> someone picks up this work again in the future.
>
> The goal of these patches is to allocate virtqueues and driver state from the
> device's NUMA node for optimal memory access latency. Only guests with a vNUMA
> topology and virtio devices spread across vNUMA nodes benefit from this.  In
> other cases the memory placement is fine and we don't need to take NUMA into
> account inside the guest.
>
> These patches could be extended to virtio_net.ko and other devices in the
> future. I only tested virtio_blk.ko.
>
> The benchmark configuration was designed to trigger worst-case NUMA placement:
>   * Physical NVMe storage controller on host NUMA node 0
>   * IOThread pinned to host NUMA node 0
>   * virtio-blk-pci device in vNUMA node 1
>   * vCPU 0 on host NUMA node 1 and vCPU 1 on host NUMA node 0
>   * vCPU 0 in vNUMA node 0 and vCPU 1 in vNUMA node 1
>
> The intent is to have .probe() code run on vCPU 0 in vNUMA node 0 (host NUMA
> node 1) so that memory is in the wrong NUMA node for the virtio-blk-pci devic=
> e.
> Applying these patches fixes memory placement so that virtqueues and driver
> state is allocated in vNUMA node 1 where the virtio-blk-pci device is located.
>
> The fio 4KB randread benchmark results do not show a significant improvement:
>
> Name                  IOPS   Error
> virtio-blk        42373.79 =C2=B1 0.54%
> virtio-blk-numa   42517.07 =C2=B1 0.79%


I remember I did something similar in vhost by using page_to_nid() for 
descriptor ring. And I get little improvement as shown here.

Michael reminds that it was probably because all data were cached. So I 
doubt if the test lacks sufficient stress on the cache ...

Thanks


>
> Stefan Hajnoczi (3):
>    virtio-pci: use NUMA-aware memory allocation in probe
>    virtio_ring: use NUMA-aware memory allocation in probe
>    virtio-blk: use NUMA-aware memory allocation in probe
>
>   include/linux/gfp.h                |  2 +-
>   drivers/block/virtio_blk.c         |  7 +++++--
>   drivers/virtio/virtio_pci_common.c | 16 ++++++++++++----
>   drivers/virtio/virtio_ring.c       | 26 +++++++++++++++++---------
>   mm/page_alloc.c                    |  2 +-
>   5 files changed, 36 insertions(+), 17 deletions(-)
>
> --=20
> 2.26.2
>


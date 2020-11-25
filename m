Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164AA2C39C5
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 08:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgKYHJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 02:09:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726596AbgKYHJS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 02:09:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606288156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VUSbcPm6ZnSi1CPK9hIkQAxwx3nEzibHi6QrBh+W7dE=;
        b=ZqHcBIySTUrn8hKxRxxApA/3H2Cx/C/pDCgReK3hOnRog4wGYv9/zYC5za/ZJ6iLWsddBP
        eZL0hKjlsvtBFsZ4igfKMIJOLbtY/aYxGdxPDa5yW+7yFoWtGh9/5Xo93nxjz3S16L2+NC
        AMXu6T9HUllgGK+b2X/h7smygRTNWXw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-bycO1I44PYCAiQ5nbkcSJA-1; Wed, 25 Nov 2020 02:09:11 -0500
X-MC-Unique: bycO1I44PYCAiQ5nbkcSJA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEF5A809DD9;
        Wed, 25 Nov 2020 07:09:08 +0000 (UTC)
Received: from [10.72.13.165] (ovpn-13-165.pek2.redhat.com [10.72.13.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09EF519C46;
        Wed, 25 Nov 2020 07:08:33 +0000 (UTC)
Subject: Re: [RFC PATCH 00/27] vDPA software assisted live migration
To:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5a4d0b7a-fb62-9e78-9e85-9262dca57f1c@redhat.com>
Date:   Wed, 25 Nov 2020 15:08:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/11/21 上午2:50, Eugenio Pérez wrote:
> This series enable vDPA software assisted live migration for vhost-net
> devices. This is a new method of vhost devices migration: Instead of
> relay on vDPA device's dirty logging capability, SW assisted LM
> intercepts dataplane, forwarding the descriptors between VM and device.
>
> In this migration mode, qemu offers a new vring to the device to
> read and write into, and disable vhost notifiers, processing guest and
> vhost notifications in qemu. On used buffer relay, qemu will mark the
> dirty memory as with plain virtio-net devices. This way, devices does
> not need to have dirty page logging capability.
>
> This series is a POC doing SW LM for vhost-net devices, which already
> have dirty page logging capabilities. None of the changes have actual
> effect with current devices until last two patches (26 and 27) are
> applied, but they can be rebased on top of any other. These checks the
> device to meet all requirements, and disable vhost-net devices logging
> so migration goes through SW LM. This last patch is not meant to be
> applied in the final revision, it is in the series just for testing
> purposes.
>
> For use SW assisted LM these vhost-net devices need to be instantiated:
> * With IOMMU (iommu_platform=on,ats=on)
> * Without event_idx (event_idx=off)


So a question is at what level do we want to implement qemu assisted 
live migration. To me it could be done at two levels:

1) generic vhost level which makes it work for both vhost-net/vhost-user 
and vhost-vDPA
2) a specific type of vhost

To me, having a generic one looks better but it would be much more 
complicated. So what I read from this series is it was a vhost kernel 
specific software assisted live migration which is a good start. 
Actually it may even have real use case, e.g it can save dirty bitmaps 
for guest with large memory. But we need to address the above 
limitations first.

So I would like to know what's the reason for mandating iommu platform 
and ats? And I think we need to fix case of event idx support.


>
> Just the notification forwarding (with no descriptor relay) can be
> achieved with patches 7 and 9, and starting migration. Partial applies
> between 13 and 24 will not work while migrating on source, and patch
> 25 is needed for the destination to resume network activity.
>
> It is based on the ideas of DPDK SW assisted LM, in the series of


Actually we're better than that since there's no need the trick like 
hardcoded IOVA for mediated(shadow) virtqueue.


> DPDK's https://patchwork.dpdk.org/cover/48370/ .


I notice that you do GPA->VA translations and try to establish a VA->VA 
(use VA as IOVA) mapping via device IOTLB. This shortcut should work for 
vhost-kernel/user but not vhost-vDPA. The reason is that there's no 
guarantee that the whole 64bit address range could be used as IOVA. One 
example is that for hardware IOMMU like intel, it usually has 47 or 52 
bits of address width.

So we probably need an IOVA allocator that can make sure the IOVA is not 
overlapped and fit for [1]. We can probably build the IOVA for guest VA 
via memory listeners. Then we have

1) IOVA for GPA
2) IOVA for shadow VQ

And advertise IOVA to VA mapping to vhost.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1b48dc03e575a872404f33b04cd237953c5d7498


>
> Comments are welcome.
>
> Thanks!
>
> Eugenio Pérez (27):
>    vhost: Add vhost_dev_can_log
>    vhost: Add device callback in vhost_migration_log
>    vhost: Move log resize/put to vhost_dev_set_log
>    vhost: add vhost_kernel_set_vring_enable
>    vhost: Add hdev->dev.sw_lm_vq_handler
>    virtio: Add virtio_queue_get_used_notify_split
>    vhost: Route guest->host notification through qemu
>    vhost: Add a flag for software assisted Live Migration
>    vhost: Route host->guest notification through qemu
>    vhost: Allocate shadow vring
>    virtio: const-ify all virtio_tswap* functions
>    virtio: Add virtio_queue_full
>    vhost: Send buffers to device
>    virtio: Remove virtio_queue_get_used_notify_split
>    vhost: Do not invalidate signalled used
>    virtio: Expose virtqueue_alloc_element
>    vhost: add vhost_vring_set_notification_rcu
>    vhost: add vhost_vring_poll_rcu
>    vhost: add vhost_vring_get_buf_rcu
>    vhost: Return used buffers
>    vhost: Add vhost_virtqueue_memory_unmap
>    vhost: Add vhost_virtqueue_memory_map
>    vhost: unmap qemu's shadow virtqueues on sw live migration
>    vhost: iommu changes
>    vhost: Do not commit vhost used idx on vhost_virtqueue_stop
>    vhost: Add vhost_hdev_can_sw_lm
>    vhost: forbid vhost devices logging
>
>   hw/virtio/vhost-sw-lm-ring.h      |  39 +++
>   include/hw/virtio/vhost.h         |   5 +
>   include/hw/virtio/virtio-access.h |   8 +-
>   include/hw/virtio/virtio.h        |   4 +
>   hw/net/virtio-net.c               |  39 ++-
>   hw/virtio/vhost-backend.c         |  29 ++
>   hw/virtio/vhost-sw-lm-ring.c      | 268 +++++++++++++++++++
>   hw/virtio/vhost.c                 | 431 +++++++++++++++++++++++++-----
>   hw/virtio/virtio.c                |  18 +-
>   hw/virtio/meson.build             |   2 +-
>   10 files changed, 758 insertions(+), 85 deletions(-)
>   create mode 100644 hw/virtio/vhost-sw-lm-ring.h
>   create mode 100644 hw/virtio/vhost-sw-lm-ring.c


So this looks like a pretty huge patchset which I'm trying to think of 
ways to split. An idea is to do this is two steps

1) implement a shadow virtqueue mode for vhost first (w/o live 
migration). Then we can test descriptors relay, IOVA allocating, etc.
2) add live migration support on top

And it looks to me it's better to split the shadow virtqueue (virtio 
driver part) into an independent file. And use generic name (w/o 
"shadow") in order to be reused by other use cases as well.

Thoughts?


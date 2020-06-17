Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B291FD3F0
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 20:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgFQR7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 13:59:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30727 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726864AbgFQR7w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 13:59:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592416790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vOyTAkVRj+O9O8epirNOSrk0N1hiwslmvzq2ZgtwDeo=;
        b=SfbMDjXcvTNiGfT5VH+ckzpKS84ESt1ZO7ROotWgWw4+LvEkcdbHNQrCdnP9MQIdmnES2k
        nbNiI25KVQPbAAwkEpwgSDHvikSoTpz2JgOq1/wMW7WGu3Kn+4uBNvbwKvunusd2A0NYoZ
        eJPOsHqg7wQ5jmVYQwX7UcWziQTHNRY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-7Z7rg9BhOgyUDiuYdTNuSw-1; Wed, 17 Jun 2020 13:59:48 -0400
X-MC-Unique: 7Z7rg9BhOgyUDiuYdTNuSw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C6411800D42;
        Wed, 17 Jun 2020 17:59:47 +0000 (UTC)
Received: from work-vm (ovpn-115-47.ams2.redhat.com [10.36.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 862B419931;
        Wed, 17 Jun 2020 17:59:39 +0000 (UTC)
Date:   Wed, 17 Jun 2020 18:59:36 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4 18/21] virtio-mem: Migration sanity checks
Message-ID: <20200617175936.GL2776@work-vm>
References: <20200610115419.51688-1-david@redhat.com>
 <20200610115419.51688-19-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610115419.51688-19-david@redhat.com>
User-Agent: Mutt/1.14.0 (2020-05-02)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand (david@redhat.com) wrote:
> We want to make sure that certain properties don't change during
> migration, especially to catch user errors in a nice way. Let's migrate
> a temporary structure and validate that the properties didn't change.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Yep OK, but some comment below

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  hw/virtio/virtio-mem.c | 69 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index 2df33f9125..450b8dc49d 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -519,12 +519,81 @@ static int virtio_mem_post_load(void *opaque, int version_id)
>      return virtio_mem_restore_unplugged(VIRTIO_MEM(opaque));
>  }
>  
> +typedef struct VirtIOMEMMigSanityChecks {
> +    VirtIOMEM *parent;
> +    uint64_t addr;
> +    uint64_t region_size;
> +    uint64_t block_size;
> +    uint32_t node;
> +} VirtIOMEMMigSanityChecks;
> +
> +static int virtio_mem_mig_sanity_checks_pre_save(void *opaque)
> +{
> +    VirtIOMEMMigSanityChecks *tmp = opaque;
> +    VirtIOMEM *vmem = tmp->parent;
> +
> +    tmp->addr = vmem->addr;
> +    tmp->region_size = memory_region_size(&vmem->memdev->mr);
> +    tmp->block_size = vmem->block_size;
> +    tmp->node = vmem->node;
> +    return 0;
> +}
> +
> +static int virtio_mem_mig_sanity_checks_post_load(void *opaque, int version_id)
> +{
> +    VirtIOMEMMigSanityChecks *tmp = opaque;
> +    VirtIOMEM *vmem = tmp->parent;
> +    const uint64_t new_region_size = memory_region_size(&vmem->memdev->mr);
> +
> +    if (tmp->addr != vmem->addr) {
> +        error_report("Property '%s' changed from 0x%" PRIx64 " to 0x%" PRIx64,
> +                     VIRTIO_MEM_ADDR_PROP, tmp->addr, vmem->addr);
> +        return -EINVAL;
> +    }

It seems weird that you do 'Property ...' and then the string; although
you only do it for 3 out of 4.
I was going to ask you to include the device name here, but I'm guessing
when it fails the outer migration code will print a 'Failed loading
device.....'  so at least you know what it is.
I would want it to be obvious when I see a 'region size changed' that I
knew it was my virtio-mem device that was screwy.

Dave

> +    /*
> +     * Note: Preparation for resizeable memory regions. The maximum size
> +     * of the memory region must not change during migration.
> +     */
> +    if (tmp->region_size != new_region_size) {
> +        error_report("region size changed from 0x%" PRIx64 " to 0x%" PRIx64,
> +                     tmp->region_size, new_region_size);
> +        return -EINVAL;
> +    }
> +    if (tmp->block_size != vmem->block_size) {
> +        error_report("Property '%s' changed from 0x%" PRIx64 " to 0x%" PRIx64,
> +                     VIRTIO_MEM_BLOCK_SIZE_PROP, tmp->block_size,
> +                     vmem->block_size);
> +        return -EINVAL;
> +    }
> +    if (tmp->node != vmem->node) {
> +        error_report("Property '%s' changed from %" PRIu32 " to %" PRIu32,
> +                     VIRTIO_MEM_NODE_PROP, tmp->node, vmem->node);
> +        return -EINVAL;
> +    }
> +    return 0;
> +}
> +
> +static const VMStateDescription vmstate_virtio_mem_sanity_checks = {
> +    .name = "virtio-mem-device/sanity-checks",
> +    .pre_save = virtio_mem_mig_sanity_checks_pre_save,
> +    .post_load = virtio_mem_mig_sanity_checks_post_load,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_UINT64(addr, VirtIOMEMMigSanityChecks),
> +        VMSTATE_UINT64(region_size, VirtIOMEMMigSanityChecks),
> +        VMSTATE_UINT64(block_size, VirtIOMEMMigSanityChecks),
> +        VMSTATE_UINT32(node, VirtIOMEMMigSanityChecks),
> +        VMSTATE_END_OF_LIST(),
> +    },
> +};
> +
>  static const VMStateDescription vmstate_virtio_mem_device = {
>      .name = "virtio-mem-device",
>      .minimum_version_id = 1,
>      .version_id = 1,
>      .post_load = virtio_mem_post_load,
>      .fields = (VMStateField[]) {
> +        VMSTATE_WITH_TMP(VirtIOMEM, VirtIOMEMMigSanityChecks,
> +                         vmstate_virtio_mem_sanity_checks),
>          VMSTATE_UINT64(usable_region_size, VirtIOMEM),
>          VMSTATE_UINT64(size, VirtIOMEM),
>          VMSTATE_UINT64(requested_size, VirtIOMEM),
> -- 
> 2.26.2
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


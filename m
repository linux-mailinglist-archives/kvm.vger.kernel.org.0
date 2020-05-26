Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC631D5678
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 18:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgEOQr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 12:47:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33578 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726023AbgEOQr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 12:47:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589561246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+vDoS6rtXmiEsFGa8fr+cErcnWf910dF9m0oUPGIPlo=;
        b=fwXZIv7ZX1m6jQ/UzVgA0B0vGspjBmUhFNNBx0nHnjwUXQh/QZrR/pDYivQ7mo+rUxtXdy
        ueen5MW6VW6mHVS4zKu0EVjXnVPe2ylRnKDsIf7Z3lgVtDfAa6e3bl8csm/O9HE+fVyFn6
        rSZB+m7Mp17d+op6Kl+H6PFsUu2CK+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-EOXWEmFjMLOHXnoe0r3qXA-1; Fri, 15 May 2020 12:47:23 -0400
X-MC-Unique: EOXWEmFjMLOHXnoe0r3qXA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5807107AFC6;
        Fri, 15 May 2020 16:47:21 +0000 (UTC)
Received: from work-vm (ovpn-114-149.ams2.redhat.com [10.36.114.149])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ED72C5D9F1;
        Fri, 15 May 2020 16:47:02 +0000 (UTC)
Date:   Fri, 15 May 2020 17:46:59 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: [PATCH v1 16/17] virtio-mem: Allow notifiers for size changes
Message-ID: <20200515164659.GK2954@work-vm>
References: <20200506094948.76388-1-david@redhat.com>
 <20200506094948.76388-17-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506094948.76388-17-david@redhat.com>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand (david@redhat.com) wrote:
> We want to send qapi events in case the size of a virtio-mem device
> changes. This allows upper layers to always know how much memory is
> actually currently consumed via a virtio-mem device.
> 
> Unfortuantely, we have to report the id of our proxy device. Let's provide
> an easy way for our proxy device to register, so it can send the qapi
> events. Piggy-backing on the notifier infrastructure (although we'll
> only ever have one notifier registered) seems to be an easy way.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Cc: Igor Mammedov <imammedo@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  hw/virtio/virtio-mem.c         | 21 ++++++++++++++++++++-
>  include/hw/virtio/virtio-mem.h |  5 +++++
>  2 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index e25b2c74f2..88a99a0d90 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -198,6 +198,7 @@ static int virtio_mem_state_change_request(VirtIOMEM *vmem, uint64_t gpa,
>      } else {
>          vmem->size -= size;
>      }
> +    notifier_list_notify(&vmem->size_change_notifiers, &vmem->size);
>      return VIRTIO_MEM_RESP_ACK;
>  }
>  
> @@ -253,7 +254,10 @@ static int virtio_mem_unplug_all(VirtIOMEM *vmem)
>          return -EBUSY;
>      }
>      bitmap_clear(vmem->bitmap, 0, vmem->bitmap_size);
> -    vmem->size = 0;
> +    if (vmem->size != 0) {
> +        vmem->size = 0;
> +        notifier_list_notify(&vmem->size_change_notifiers, &vmem->size);
> +    }
>  
>      virtio_mem_resize_usable_region(vmem, vmem->requested_size, true);
>      return 0;
> @@ -594,6 +598,18 @@ static MemoryRegion *virtio_mem_get_memory_region(VirtIOMEM *vmem, Error **errp)
>      return &vmem->memdev->mr;
>  }
>  
> +static void virtio_mem_add_size_change_notifier(VirtIOMEM *vmem,
> +                                                Notifier *notifier)
> +{
> +    notifier_list_add(&vmem->size_change_notifiers, notifier);
> +}
> +
> +static void virtio_mem_remove_size_change_notifier(VirtIOMEM *vmem,
> +                                                   Notifier *notifier)
> +{
> +    notifier_remove(notifier);
> +}
> +
>  static void virtio_mem_get_size(Object *obj, Visitor *v, const char *name,
>                                  void *opaque, Error **errp)
>  {
> @@ -705,6 +721,7 @@ static void virtio_mem_instance_init(Object *obj)
>      VirtIOMEM *vmem = VIRTIO_MEM(obj);
>  
>      vmem->block_size = VIRTIO_MEM_MIN_BLOCK_SIZE;
> +    notifier_list_init(&vmem->size_change_notifiers);
>  
>      object_property_add(obj, VIRTIO_MEM_SIZE_PROP, "size", virtio_mem_get_size,
>                          NULL, NULL, NULL, &error_abort);
> @@ -743,6 +760,8 @@ static void virtio_mem_class_init(ObjectClass *klass, void *data)
>  
>      vmc->fill_device_info = virtio_mem_fill_device_info;
>      vmc->get_memory_region = virtio_mem_get_memory_region;
> +    vmc->add_size_change_notifier = virtio_mem_add_size_change_notifier;
> +    vmc->remove_size_change_notifier = virtio_mem_remove_size_change_notifier;
>  }
>  
>  static const TypeInfo virtio_mem_info = {
> diff --git a/include/hw/virtio/virtio-mem.h b/include/hw/virtio/virtio-mem.h
> index 27158cb611..5820b5c23e 100644
> --- a/include/hw/virtio/virtio-mem.h
> +++ b/include/hw/virtio/virtio-mem.h
> @@ -66,6 +66,9 @@ typedef struct VirtIOMEM {
>      /* block size and alignment */
>      uint32_t block_size;
>      uint32_t migration_block_size;
> +
> +    /* notifiers to notify when "size" changes */
> +    NotifierList size_change_notifiers;
>  } VirtIOMEM;
>  
>  typedef struct VirtIOMEMClass {
> @@ -75,6 +78,8 @@ typedef struct VirtIOMEMClass {
>      /* public */
>      void (*fill_device_info)(const VirtIOMEM *vmen, VirtioMEMDeviceInfo *vi);
>      MemoryRegion *(*get_memory_region)(VirtIOMEM *vmem, Error **errp);
> +    void (*add_size_change_notifier)(VirtIOMEM *vmem, Notifier *notifier);
> +    void (*remove_size_change_notifier)(VirtIOMEM *vmem, Notifier *notifier);
>  } VirtIOMEMClass;
>  
>  #endif
> -- 
> 2.25.3
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


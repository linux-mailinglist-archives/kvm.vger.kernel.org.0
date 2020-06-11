Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFC01F6560
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 12:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgFKKIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 06:08:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41436 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727036AbgFKKII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 06:08:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591870085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hti1yQlaKXXa4b8vH7t/CX8EVQPiSGu8ey4rYtxv/ZU=;
        b=WODM5n8kJoJ482Gbs0fbyjU21Sw018VLzQiWdtmYQAgYb1BymT7hbBAR6UxfObFXhm7uMd
        BKHPCDAJrUZf9Qjg/5vo/czDnHJWDxGY00YrC7vwt74WZb7wTLeoxHRyut/FoRWh1mnlfA
        slcJEyUf4Yt+I2TB6EUvEqKNbQcdXw8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-nLeYegqwPwSmmIGcvewdWQ-1; Thu, 11 Jun 2020 06:07:59 -0400
X-MC-Unique: nLeYegqwPwSmmIGcvewdWQ-1
Received: by mail-wr1-f70.google.com with SMTP id j16so2346115wre.22
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 03:07:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hti1yQlaKXXa4b8vH7t/CX8EVQPiSGu8ey4rYtxv/ZU=;
        b=AowMOqCzGf65SpdW9QTCKOXhBsZ7LF2QbasMLlcp7p3Hkfj+mJkwBRh2vbpZ/j42bB
         UqrlFVMpqDvS8R0IkZr0KY+9Sdy5kTwkCto/NWQM3WEzMhfDIydeuODgTloO+eTWKOq3
         v/1MWhrecrSk7xioolgUfEFUFshRRw3tGrrbVWfIvBklBR+ZVHEN1zkvQ/BUaOwtmgZD
         dDgc5AysjdSPnyVoVNOHvBGB6GPjbtUuw6jkDFEHJ7MUVnHwDeJosX4X9A+d2ldtJORR
         apm75bjxx1gh6K+urJ1WO0g1WahG/evmLlHi33Ts3/7cvMw6UvHkhD4cYMo/cej9a/m8
         9PQw==
X-Gm-Message-State: AOAM533wO8TJbGKn8/wvDiTRvZkxFZ1XUgVwF4ZiGOvCWCHe/YB+Dm8Y
        4iH4PdAUC4hNXu1AxZWGvzZeUCTenG8OQak6zZ3cEEemp/xSSszZzl0K7SWyt/TKugNIEB/xk0d
        sU7hsSLaVGTIK
X-Received: by 2002:a5d:5449:: with SMTP id w9mr8887302wrv.106.1591870078453;
        Thu, 11 Jun 2020 03:07:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7fUMwNnhBKL0yD4hzPZy5EKspCjidE0BlArAAtqV0VBMDwrTb+hVc8kTwnh7wCpCs88IQZw==
X-Received: by 2002:a5d:5449:: with SMTP id w9mr8887273wrv.106.1591870078148;
        Thu, 11 Jun 2020 03:07:58 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id u4sm3363234wmb.48.2020.06.11.03.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 03:07:57 -0700 (PDT)
Date:   Thu, 11 Jun 2020 06:07:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        teawater <teawaterz@linux.alibaba.com>
Subject: Re: [PATCH v1] virtio-mem: add memory via add_memory_driver_managed()
Message-ID: <20200611060249-mutt-send-email-mst@kernel.org>
References: <20200611093518.5737-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611093518.5737-1-david@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

virtio-mem: add memory via add_memory_driver_managed()


On Thu, Jun 11, 2020 at 11:35:18AM +0200, David Hildenbrand wrote:
> Virtio-mem managed memory is always detected and added by the virtio-mem
> driver, never using something like the firmware-provided memory map.
> This is the case after an ordinary system reboot, and has to be guaranteed
> after kexec. Especially, virtio-mem added memory resources can contain
> inaccessible parts ("unblocked memory blocks"), blindly forwarding them
> to a kexec kernel is dangerous, as unplugged memory will get accessed
> (esp. written).
> 
> Let's use the new way of adding special driver-managed memory introduced
> in commit 75ac4c58bc0d ("mm/memory_hotplug: introduce
> add_memory_driver_managed()").
> 
> This will result in no entries in /sys/firmware/memmap ("raw firmware-
> provided memory map"), the memory resource will be flagged
> IORESOURCE_MEM_DRIVER_MANAGED (esp., kexec_file_load() will not place
> kexec images on this memory), and it is exposed as "System RAM
> (virtio_mem)" in /proc/iomem, so esp. kexec-tools can properly handle it.
> 
> Example /proc/iomem before this change:
>   [...]
>   140000000-333ffffff : virtio0
>     140000000-147ffffff : System RAM
>   334000000-533ffffff : virtio1
>     338000000-33fffffff : System RAM
>     340000000-347ffffff : System RAM
>     348000000-34fffffff : System RAM
>   [...]
> 
> Example /proc/iomem after this change:
>   [...]
>   140000000-333ffffff : virtio0
>     140000000-147ffffff : System RAM (virtio_mem)
>   334000000-533ffffff : virtio1
>     338000000-33fffffff : System RAM (virtio_mem)
>     340000000-347ffffff : System RAM (virtio_mem)
>     348000000-34fffffff : System RAM (virtio_mem)
>   [...]
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Cc: teawater <teawaterz@linux.alibaba.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
> 
> Based on latest Linus' tree (and not a tag) because
> - virtio-mem has just been merged via the vhost tree
> - add_memory_driver_managed() has been merged a week ago via the -mm tree
> 
> I'd like to have this patch in 5.8, with the initial merge of virtio-mem
> if possible (so the user space representation of virtio-mem added memory
> resources won't change anymore).

So my plan is to rebase on top of -rc1 and merge this for rc2 then.
I don't like rebase on top of tip as the results are sometimes kind of
random.
And let's add a Fixes: tag as well, this way people will remember to
pick this.
Makes sense?


> ---
>  drivers/virtio/virtio_mem.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
> index 50c689f250450..d2eab3558a9e1 100644
> --- a/drivers/virtio/virtio_mem.c
> +++ b/drivers/virtio/virtio_mem.c
> @@ -101,6 +101,11 @@ struct virtio_mem {
>  
>  	/* The parent resource for all memory added via this device. */
>  	struct resource *parent_resource;
> +	/*
> +	 * Copy of "System RAM (virtio_mem)" to be used for
> +	 * add_memory_driver_managed().
> +	 */
> +	const char *resource_name;
>  
>  	/* Summary of all memory block states. */
>  	unsigned long nb_mb_state[VIRTIO_MEM_MB_STATE_COUNT];
> @@ -414,8 +419,20 @@ static int virtio_mem_mb_add(struct virtio_mem *vm, unsigned long mb_id)
>  	if (nid == NUMA_NO_NODE)
>  		nid = memory_add_physaddr_to_nid(addr);
>  
> +	/*
> +	 * When force-unloading the driver and we still have memory added to
> +	 * Linux, the resource name has to stay.
> +	 */
> +	if (!vm->resource_name) {
> +		vm->resource_name = kstrdup_const("System RAM (virtio_mem)",
> +						  GFP_KERNEL);
> +		if (!vm->resource_name)
> +			return -ENOMEM;
> +	}
> +
>  	dev_dbg(&vm->vdev->dev, "adding memory block: %lu\n", mb_id);
> -	return add_memory(nid, addr, memory_block_size_bytes());
> +	return add_memory_driver_managed(nid, addr, memory_block_size_bytes(),
> +					 vm->resource_name);
>  }
>  
>  /*
> @@ -1890,10 +1907,12 @@ static void virtio_mem_remove(struct virtio_device *vdev)
>  	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL] ||
>  	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE] ||
>  	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL] ||
> -	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_MOVABLE])
> +	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_MOVABLE]) {
>  		dev_warn(&vdev->dev, "device still has system memory added\n");
> -	else
> +	} else {
>  		virtio_mem_delete_resource(vm);
> +		kfree_const(vm->resource_name);
> +	}
>  
>  	/* remove all tracking data - no locking needed */
>  	vfree(vm->mb_state);
> -- 
> 2.26.2


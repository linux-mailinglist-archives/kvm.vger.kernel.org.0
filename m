Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552B942C94D
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 21:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbhJMTFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 15:05:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53915 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234649AbhJMTFp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 15:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634151821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X2IinELNhBfhTTxLwKLfzZ5P952ASKCzgYoLYGuoDCg=;
        b=Fxqqh49xXLI2K9V+b5JYAToDZuDZniD6IbRrJUZDDkO+B1Y7EX6+ZQpfbKOSF3ufEO1w3K
        PhFNq5/hihR8B5YtE4fWWfyloq+FLQ48kous0TlJgpSF//ZSN5A1HJx5oBrVdCarBhdien
        7ZyMGOux1+HjB6wHDzyH3gfuteFAQzU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-N9j-2VOpM1-Pr5c4E6ZaWA-1; Wed, 13 Oct 2021 15:03:39 -0400
X-MC-Unique: N9j-2VOpM1-Pr5c4E6ZaWA-1
Received: by mail-wr1-f71.google.com with SMTP id r16-20020adfbb10000000b00160958ed8acso2702548wrg.16
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 12:03:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=X2IinELNhBfhTTxLwKLfzZ5P952ASKCzgYoLYGuoDCg=;
        b=qA3lLxrafI/9yJm7xO9I+4HU0zk1PF02QWFvC97nMGwwU49UNE4YLPpPuhoxXMX+2j
         JSZpA+m+bIvJEkiOduTIUEBgHXFWvQ5ve1D+BoE8BdMqm/nEg3/lG4qJT2EJC3mlSAMw
         zycQ+2U//IOoq3WUPRXoP2AdZ8WgEE2VR9+VTAxt6XfWT1efiS5ACS/QzyZWN8GP4ZKg
         +MPm+7OU8kXHtA72SiClnmWtPK+VzhN+1vkSGg8M5HTk0tPKSIbh7HoiGqb5/5BeR9wX
         BI4cYi8D9EwtUIbP0O0xUmWD4U503vfEBof5OFHGRa7WuJnZUTqeCTkhCGc8oE6clqJz
         MfdA==
X-Gm-Message-State: AOAM533yja4sW+50KDuhKkxkIxiQZ3J9eLrXUF91p0Ht4nUPyfD55LSp
        +srJD4t2sXHUGrmHg8KE7AzB1K6fB5sjSP619PBxuwaLQTkwEVhbKbynAlgaQFkFoTmPK0t0IyB
        NykH/Xu946ZjP
X-Received: by 2002:a7b:c841:: with SMTP id c1mr14861487wml.40.1634151818582;
        Wed, 13 Oct 2021 12:03:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIlDtE7cauA91BvZ5GKKOAdDynUC27VP2obs1JBjAkbeu7jFyvaeVnM8VSNpm2Ay2i2Si1Kg==
X-Received: by 2002:a7b:c841:: with SMTP id c1mr14861463wml.40.1634151818309;
        Wed, 13 Oct 2021 12:03:38 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id t4sm218333wro.1.2021.10.13.12.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 12:03:37 -0700 (PDT)
Date:   Wed, 13 Oct 2021 20:03:35 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC 00/15] virtio-mem: Expose device memory via separate
 memslots
Message-ID: <YWcthytjDJUXdN0w@work-vm>
References: <20211013103330.26869-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211013103330.26869-1-david@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand (david@redhat.com) wrote:
> Based-on: 20211011175346.15499-1-david@redhat.com
> 
> A virtio-mem device is represented by a single large RAM memory region
> backed by a single large mmap.
> 
> Right now, we map that complete memory region into guest physical addres
> space, resulting in a very large memory mapping, KVM memory slot, ...
> although only a small amount of memory might actually be exposed to the VM.
> 
> For example, when starting a VM with a 1 TiB virtio-mem device that only
> exposes little device memory (e.g., 1 GiB) towards the VM initialliy,
> in order to hotplug more memory later, we waste a lot of memory on metadata
> for KVM memory slots (> 2 GiB!) and accompanied bitmaps. Although some
> optimizations in KVM are being worked on to reduce this metadata overhead
> on x86-64 in some cases, it remains a problem with nested VMs and there are
> other reasons why we would want to reduce the total memory slot to a
> reasonable minimum.
> 
> We want to:
> a) Reduce the metadata overhead, including bitmap sizes inside KVM but also
>    inside QEMU KVM code where possible.
> b) Not always expose all device-memory to the VM, to reduce the attack
>    surface of malicious VMs without using userfaultfd.
> 
> So instead, expose the RAM memory region not by a single large mapping
> (consuming one memslot) but instead by multiple mappings, each consuming
> one memslot. To do that, we divide the RAM memory region via aliases into
> separate parts and only map the aliases into a device container we actually
> need. We have to make sure that QEMU won't silently merge the memory
> sections corresponding to the aliases (and thereby also memslots),
> otherwise we lose atomic updates with KVM and vhost-user, which we deeply
> care about when adding/removing memory. Further, to get memslot accounting
> right, such merging is better avoided.
> 
> Within the memslots, virtio-mem can (un)plug memory in smaller granularity
> dynamically. So memslots are a pure optimization to tackle a) and b) above.
> 
> Memslots are right now mapped once they fall into the usable device region
> (which grows/shrinks on demand right now either when requesting to
>  hotplug more memory or during/after reboots). In the future, with
> VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE, we'll be able to (un)map aliases even
> more dynamically when (un)plugging device blocks.
> 
> 
> Adding a 500GiB virtio-mem device and not hotplugging any memory results in:
>     0000000140000000-000001047fffffff (prio 0, i/o): device-memory
>       0000000140000000-0000007e3fffffff (prio 0, i/o): virtio-mem-memslots
> 
> Requesting the VM to consume 2 GiB results in (note: the usable region size
> is bigger than 2 GiB, so 3 * 1 GiB memslots are required):
>     0000000140000000-000001047fffffff (prio 0, i/o): device-memory
>       0000000140000000-0000007e3fffffff (prio 0, i/o): virtio-mem-memslots
>         0000000140000000-000000017fffffff (prio 0, ram): alias virtio-mem-memslot-0 @mem0 0000000000000000-000000003fffffff
>         0000000180000000-00000001bfffffff (prio 0, ram): alias virtio-mem-memslot-1 @mem0 0000000040000000-000000007fffffff
>         00000001c0000000-00000001ffffffff (prio 0, ram): alias virtio-mem-memslot-2 @mem0 0000000080000000-00000000bfffffff

I've got a vague memory that there were some devices that didn't like
doing split IO across a memory region (or something) - some virtio
devices?  Do you know if that's still true and if that causes a problem?

Dave

> Requesting the VM to consume 20 GiB results in:
>     0000000140000000-000001047fffffff (prio 0, i/o): device-memory
>       0000000140000000-0000007e3fffffff (prio 0, i/o): virtio-mem-memslots
>         0000000140000000-000000017fffffff (prio 0, ram): alias virtio-mem-memslot-0 @mem0 0000000000000000-000000003fffffff
>         0000000180000000-00000001bfffffff (prio 0, ram): alias virtio-mem-memslot-1 @mem0 0000000040000000-000000007fffffff
>         00000001c0000000-00000001ffffffff (prio 0, ram): alias virtio-mem-memslot-2 @mem0 0000000080000000-00000000bfffffff
>         0000000200000000-000000023fffffff (prio 0, ram): alias virtio-mem-memslot-3 @mem0 00000000c0000000-00000000ffffffff
>         0000000240000000-000000027fffffff (prio 0, ram): alias virtio-mem-memslot-4 @mem0 0000000100000000-000000013fffffff
>         0000000280000000-00000002bfffffff (prio 0, ram): alias virtio-mem-memslot-5 @mem0 0000000140000000-000000017fffffff
>         00000002c0000000-00000002ffffffff (prio 0, ram): alias virtio-mem-memslot-6 @mem0 0000000180000000-00000001bfffffff
>         0000000300000000-000000033fffffff (prio 0, ram): alias virtio-mem-memslot-7 @mem0 00000001c0000000-00000001ffffffff
>         0000000340000000-000000037fffffff (prio 0, ram): alias virtio-mem-memslot-8 @mem0 0000000200000000-000000023fffffff
>         0000000380000000-00000003bfffffff (prio 0, ram): alias virtio-mem-memslot-9 @mem0 0000000240000000-000000027fffffff
>         00000003c0000000-00000003ffffffff (prio 0, ram): alias virtio-mem-memslot-10 @mem0 0000000280000000-00000002bfffffff
>         0000000400000000-000000043fffffff (prio 0, ram): alias virtio-mem-memslot-11 @mem0 00000002c0000000-00000002ffffffff
>         0000000440000000-000000047fffffff (prio 0, ram): alias virtio-mem-memslot-12 @mem0 0000000300000000-000000033fffffff
>         0000000480000000-00000004bfffffff (prio 0, ram): alias virtio-mem-memslot-13 @mem0 0000000340000000-000000037fffffff
>         00000004c0000000-00000004ffffffff (prio 0, ram): alias virtio-mem-memslot-14 @mem0 0000000380000000-00000003bfffffff
>         0000000500000000-000000053fffffff (prio 0, ram): alias virtio-mem-memslot-15 @mem0 00000003c0000000-00000003ffffffff
>         0000000540000000-000000057fffffff (prio 0, ram): alias virtio-mem-memslot-16 @mem0 0000000400000000-000000043fffffff
>         0000000580000000-00000005bfffffff (prio 0, ram): alias virtio-mem-memslot-17 @mem0 0000000440000000-000000047fffffff
>         00000005c0000000-00000005ffffffff (prio 0, ram): alias virtio-mem-memslot-18 @mem0 0000000480000000-00000004bfffffff
>         0000000600000000-000000063fffffff (prio 0, ram): alias virtio-mem-memslot-19 @mem0 00000004c0000000-00000004ffffffff
>         0000000640000000-000000067fffffff (prio 0, ram): alias virtio-mem-memslot-20 @mem0 0000000500000000-000000053fffffff
> 
> Requesting the VM to consume 5 GiB and rebooting (note: usable region size
> will change during reboots) results in:
>     0000000140000000-000001047fffffff (prio 0, i/o): device-memory
>       0000000140000000-0000007e3fffffff (prio 0, i/o): virtio-mem-memslots
>         0000000140000000-000000017fffffff (prio 0, ram): alias virtio-mem-memslot-0 @mem0 0000000000000000-000000003fffffff
>         0000000180000000-00000001bfffffff (prio 0, ram): alias virtio-mem-memslot-1 @mem0 0000000040000000-000000007fffffff
>         00000001c0000000-00000001ffffffff (prio 0, ram): alias virtio-mem-memslot-2 @mem0 0000000080000000-00000000bfffffff
>         0000000200000000-000000023fffffff (prio 0, ram): alias virtio-mem-memslot-3 @mem0 00000000c0000000-00000000ffffffff
>         0000000240000000-000000027fffffff (prio 0, ram): alias virtio-mem-memslot-4 @mem0 0000000100000000-000000013fffffff
>         0000000280000000-00000002bfffffff (prio 0, ram): alias virtio-mem-memslot-5 @mem0 0000000140000000-000000017fffffff
> 
> 
> In addition to other factors, we limit the number of memslots to 1024 per
> devices and the size of one memslot to at least 1 GiB. So only a 1 TiB
> virtio-mem device could consume 1024 memslots in the "worst" case. To
> calculate a memslot limit for a device, we use a heuristic based on all
> available memslots for memory devices and the percentage of
> "device size":"total memory device area size". Users can further limit
> the maximum number of memslots that will be used by a device by setting
> the "max-memslots" property. It's expected to be set to "0" (auto) in most
> setups.
> 
> In recent setups (e.g., KVM with ~32k memslots, vhost-user with ~4k
> memslots after this series), we'll get the biggest benefit. In special
> setups (e.g., older KVM, vhost kernel with 64 memslots), we'll get some
> benefit -- the individual memslots will be bigger.
> 
> Future work:
> - vhost-user and libvhost-user optimizations for handling more memslots
>   more efficiently.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Igor Mammedov <imammedo@redhat.com>
> Cc: Ani Sinha <ani@anisinha.ca>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: Philippe Mathieu-Daudé <f4bug@amsat.org>
> Cc: kvm@vger.kernel.org
> 
> David Hildenbrand (15):
>   memory: Drop mapping check from
>     memory_region_get_ram_discard_manager()
>   kvm: Return number of free memslots
>   vhost: Return number of free memslots
>   memory: Allow for marking memory region aliases unmergeable
>   vhost: Don't merge unmergeable memory sections
>   memory-device: Move memory_device_check_addable() directly into
>     memory_device_pre_plug()
>   memory-device: Generalize memory_device_used_region_size()
>   memory-device: Support memory devices that consume a variable number
>     of memslots
>   vhost: Respect reserved memslots for memory devices when realizing a
>     vhost device
>   virtio-mem: Set the RamDiscardManager for the RAM memory region
>     earlier
>   virtio-mem: Fix typo in virito_mem_intersect_memory_section() function
>     name
>   virtio-mem: Expose device memory via separate memslots
>   vhost-user: Increase VHOST_USER_MAX_RAM_SLOTS to 496 with
>     CONFIG_VIRTIO_MEM
>   libvhost-user: Increase VHOST_USER_MAX_RAM_SLOTS to 4096
>   virtio-mem: Set "max-memslots" to 0 (auto) for the 6.2 machine
> 
>  accel/kvm/kvm-all.c                       |  24 ++-
>  accel/stubs/kvm-stub.c                    |   4 +-
>  hw/core/machine.c                         |   1 +
>  hw/mem/memory-device.c                    | 167 +++++++++++++++---
>  hw/virtio/vhost-stub.c                    |   2 +-
>  hw/virtio/vhost-user.c                    |   7 +-
>  hw/virtio/vhost.c                         |  17 +-
>  hw/virtio/virtio-mem-pci.c                |  22 +++
>  hw/virtio/virtio-mem.c                    | 202 ++++++++++++++++++++--
>  include/exec/memory.h                     |  23 +++
>  include/hw/mem/memory-device.h            |  32 ++++
>  include/hw/virtio/vhost.h                 |   2 +-
>  include/hw/virtio/virtio-mem.h            |  29 +++-
>  include/sysemu/kvm.h                      |   2 +-
>  softmmu/memory.c                          |  35 +++-
>  stubs/qmp_memory_device.c                 |   5 +
>  subprojects/libvhost-user/libvhost-user.h |   7 +-
>  17 files changed, 499 insertions(+), 82 deletions(-)
> 
> -- 
> 2.31.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


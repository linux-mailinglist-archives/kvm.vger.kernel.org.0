Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DE544233B
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbhKAWSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:18:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45518 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232283AbhKAWSS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:18:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kULSYLoNK3MMdlcejBQXxDbQbCYS0VSwoKO2REatSm4=;
        b=h7u6HjGM+lf+MWZG+/aIdzYfV9glLT+FDI27nqCVoz+tOHBvjPIsV5sPa865nOVKnomxRi
        NJAeUlEpQiWBaHi0uAKnzkG3ZQsu9LhVXNEP4YLO2sHs/tEj3nrkE6h35cFpdD3h2lyxzk
        hVz4EYgZ0H3BfV5Nk3D/hqeD4hj6HX8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-Bf7m7GkcNACi58c7BEZo2w-1; Mon, 01 Nov 2021 18:15:40 -0400
X-MC-Unique: Bf7m7GkcNACi58c7BEZo2w-1
Received: by mail-ed1-f72.google.com with SMTP id h16-20020a05640250d000b003dd8167857aso16953565edb.0
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kULSYLoNK3MMdlcejBQXxDbQbCYS0VSwoKO2REatSm4=;
        b=3l5GIkQ1MBj3TRl/qNyIpy6wzxb0ZMz6ivnfrLpB5Rxj3eMoHQ+ncmsIB0zvKSHGn/
         YYC1xeThG24ExD2Yr4f11mL2CuiN1BgoDWOznC5CfQHMt2k/2l4inoGdFBYIdeiU1RuE
         pxKEa9eTiDWESTVwSTV2cxsn35YoX+DrLPFsixxA0u+YSg1054UGOMDOWqoeFzeyL+/k
         UPXNc0cYc52Yy38eFf2agVBfuKnp1Ol55aiyOQXGWlCJtGDSjD2AcHqQfa+a2Z2rg74y
         54+Ttql7VkOKawq4eNxxMrG8imqhtdwvspRHblNKOIzICMU+kTpmdpg4pf9WAAIV9vTK
         YxcA==
X-Gm-Message-State: AOAM531X91RNeuB4qHjidgPaU8bHjqPauxOIKRKhTsd/rODxqlGTm696
        +ChQOOzah/MLd/1nZCJKjLWale8nxiHlatN5MUpYenMpqIfJkMNPqJnIwAzcN5GOlO94FOXfF5y
        cAQlNf8J1Xg5Z
X-Received: by 2002:a17:906:4fc8:: with SMTP id i8mr38381683ejw.342.1635804939146;
        Mon, 01 Nov 2021 15:15:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjWrNq0ltV/7mWaI9dUnocsPMjnaPQxyOdrrUF0hMy1fJO7N0y4OyHwichdduDe/qHph4KJA==
X-Received: by 2002:a17:906:4fc8:: with SMTP id i8mr38381652ejw.342.1635804938912;
        Mon, 01 Nov 2021 15:15:38 -0700 (PDT)
Received: from redhat.com ([2.55.156.42])
        by smtp.gmail.com with ESMTPSA id i22sm9557576edu.93.2021.11.01.15.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:15:37 -0700 (PDT)
Date:   Mon, 1 Nov 2021 18:15:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1 00/12] virtio-mem: Expose device memory via multiple
 memslots
Message-ID: <20211101181352-mutt-send-email-mst@kernel.org>
References: <20211027124531.57561-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211027124531.57561-1-david@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 27, 2021 at 02:45:19PM +0200, David Hildenbrand wrote:
> This is the follow-up of [1], dropping auto-detection and vhost-user
> changes from the initial RFC.
> 
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

I'm confused by the mention of these security considerations,
and I expect users will be just as confused.
So let's say user wants to not be exposed. What value for
the option should be used? What if a lower option is used?
Is there still some security advantage?

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
> The user configures how many memslots a virtio-mem device should use, the
> default is "1" -- essentially corresponding to the old behavior.
> 
> Memslots are right now mapped once they fall into the usable device region
> (which grows/shrinks on demand right now either when requesting to
>  hotplug more memory or during/after reboots). In the future, with
> VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE, we'll be able to (un)map aliases even
> more dynamically when (un)plugging device blocks.
> 
> 
> Adding a 500GiB virtio-mem device with "memslots=500" and not hotplugging
> any memory results in:
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
> 
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
> In addition to other factors (e.g., device block size), we limit the number
> of memslots to 1024 per devices and the size of one memslot to at least
> 128 MiB. Further, we make sure internally to align the memslot size to at
> least 128 MiB. For now, we limit the total number of memslots that can
> be used by memory devices to 2048, to no go crazy on individual RAM
> mappings in our address spaces.
> 
> Future work:
> - vhost-user and libvhost-user/vhost-user-backend changes to support more than
>   32 memslots.
> - "memslots=0" mode to allow for auto-determining the number of memslots to
>   use.
> - Eventually have an interface to query the memslot limit for a QEMU
>   instance. But vhost-* devices complicate that matter.
> 
> RCF -> v1:
> - Dropped "max-memslots=" parameter and converted to "memslots=" parameter
> - Dropped auto-determining the number of memslots to use
> - Dropped vhost* memslot changes
> - Improved error messages regarding memory slot limits
> - Reshuffled, cleaned up patches, rewrote patch descriptions
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
> Cc: Hui Zhu <teawater@gmail.com>
> Cc: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Cc: kvm@vger.kernel.org
> 
> [1] https://lkml.kernel.org/r/20211013103330.26869-1-david@redhat.com
> 
> David Hildenbrand (12):
>   kvm: Return number of free memslots
>   vhost: Return number of free memslots
>   memory: Allow for marking memory region aliases unmergeable
>   vhost: Don't merge unmergeable memory sections
>   memory-device: Move memory_device_check_addable() directly into
>     memory_device_pre_plug()
>   memory-device: Generalize memory_device_used_region_size()
>   memory-device: Support memory devices that dynamically consume
>     multiple memslots
>   vhost: Respect reserved memslots for memory devices when realizing a
>     vhost device
>   memory: Drop mapping check from
>     memory_region_get_ram_discard_manager()
>   virtio-mem: Fix typo in virito_mem_intersect_memory_section() function
>     name
>   virtio-mem: Set the RamDiscardManager for the RAM memory region
>     earlier
>   virtio-mem: Expose device memory via multiple memslots
> 
>  accel/kvm/kvm-all.c            |  24 ++--
>  accel/stubs/kvm-stub.c         |   4 +-
>  hw/mem/memory-device.c         | 115 ++++++++++++++----
>  hw/virtio/vhost-stub.c         |   2 +-
>  hw/virtio/vhost.c              |  21 ++--
>  hw/virtio/virtio-mem-pci.c     |  23 ++++
>  hw/virtio/virtio-mem.c         | 212 +++++++++++++++++++++++++++++----
>  include/exec/memory.h          |  23 ++++
>  include/hw/mem/memory-device.h |  33 +++++
>  include/hw/virtio/vhost.h      |   2 +-
>  include/hw/virtio/virtio-mem.h |  25 +++-
>  include/sysemu/kvm.h           |   2 +-
>  softmmu/memory.c               |  35 ++++--
>  stubs/qmp_memory_device.c      |   5 +
>  14 files changed, 449 insertions(+), 77 deletions(-)
> 
> -- 
> 2.31.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FA71F3B75
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 15:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgFINLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 09:11:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59128 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726083AbgFINLk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jun 2020 09:11:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591708297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=14i4pgJ1cKRxt/SIZY3SGbyK+x6E5qdVnQdLD8Wr0Ac=;
        b=gYPKy/KGyOkrUSAOuLHPycQhYLe86VJn7WQMZA6KS4mmx2ITviNXy5TIZxBHrugImyuvl1
        MVgA+38Cx7ksolLGXHM7MCH2vABO6cPO9Lnv1gNv+EuyF26ldtEtg3VbsoyV5lhKAiYErl
        jlJClR8cMkMOGzI5Ihm80uOUcDWVaa0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-zAjx_Hn9OE2O2imoDP1KTQ-1; Tue, 09 Jun 2020 09:11:26 -0400
X-MC-Unique: zAjx_Hn9OE2O2imoDP1KTQ-1
Received: by mail-wr1-f69.google.com with SMTP id n6so8613208wrv.6
        for <kvm@vger.kernel.org>; Tue, 09 Jun 2020 06:11:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=14i4pgJ1cKRxt/SIZY3SGbyK+x6E5qdVnQdLD8Wr0Ac=;
        b=j/IvxPGiknDwsa0oWgMF4wJnf74rZ51F6qNDMUkQbtHQ+PuivXuhg440XjLza9NgcH
         vB4LmSoILqqVSbTKcyuiM0jA364ERE0JLF6+bSWdlHD9fIdSXYB/ofK2tRLhT07wXber
         4/mTo/2tBRXuO9GuEQW2xEQUDAwKmpAAHc09Lw1e5k6Y8wCBZp/ZwHluYTDT+Ec4c68j
         xaOIOosFKe2q2wS++6c9yTmMmI42A37fTvzWwzSQPZVymDVAKxDzTO+FFTfgGIxyarFy
         8F5zqk3Z42/gbJFX6NJPl+S9A0QoFsA5rU55hxyGy9cMsdca5g0dq7f1iHBsFKDzSri+
         59kQ==
X-Gm-Message-State: AOAM532St8WwFHLtZs7qFRyCO2xRDz9MGp7HWLCuF/CgdYLyASuFI1xG
        aJ8ZWYq7un5Ige7GOoUI6h48jWzeAsC0+2YCZs4wGD5Y1lOQ603vujHzABQyWxFGU07e09AWb2P
        e8Ya2jiM/iUgw
X-Received: by 2002:a5d:4fc4:: with SMTP id h4mr4254412wrw.49.1591708285164;
        Tue, 09 Jun 2020 06:11:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzp5N1qCGoHea3ZDXEjbB8ru/PidP9Mj1IZXGKzhzacYZ4oc6CGuCHF1zzGW4rDHdsY1crdBA==
X-Received: by 2002:a5d:4fc4:: with SMTP id h4mr4254378wrw.49.1591708284871;
        Tue, 09 Jun 2020 06:11:24 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id c16sm3461288wrx.4.2020.06.09.06.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 06:11:24 -0700 (PDT)
Date:   Tue, 9 Jun 2020 09:11:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        teawater <teawaterz@linux.alibaba.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Juan Quintela <quintela@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Markus Armbruster <armbru@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [PATCH v3 00/20] virtio-mem: Paravirtualized memory hot(un)plug
Message-ID: <20200609091034-mutt-send-email-mst@kernel.org>
References: <20200603144914.41645-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603144914.41645-1-david@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 03, 2020 at 04:48:54PM +0200, David Hildenbrand wrote:
> This is the very basic, initial version of virtio-mem. More info on
> virtio-mem in general can be found in the Linux kernel driver v2 posting
> [1] and in patch #10. The latest Linux driver v4 can be found at [2].
> 
> This series is based on [3]:
>     "[PATCH v1] pc: Support coldplugging of virtio-pmem-pci devices on all
>      buses"
> 
> The patches can be found at:
>     https://github.com/davidhildenbrand/qemu.git virtio-mem-v3

So given we tweaked the config space a bit, this needs a respin.


> "The basic idea of virtio-mem is to provide a flexible,
> cross-architecture memory hot(un)plug solution that avoids many limitations
> imposed by existing technologies, architectures, and interfaces."
> 
> There are a lot of addons in the works (esp. protection of unplugged
> memory, better hugepage support (esp. when reading unplugged memory),
> resizeable memory backends, support for more architectures, ...), this is
> the very basic version to get the ball rolling.
> 
> The first 8 patches make sure we don't have any sudden surprises e.g., if
> somebody tries to pin all memory in RAM blocks, resulting in a higher
> memory consumption than desired. The remaining patches add basic virtio-mem
> along with support for x86-64.
> 
> 
> Note: Since commit 7d2ef6dcc1cf ("hmp: Simplify qom-set"), the behavior of
> qom-set changed and we can no longer pass proper sizes (e.g., 300M). The
> description in patch #10 is outdated - but I hope that we'll bring back the
> old behaviour, so I kept it for now :)
> 
> [1] https://lkml.kernel.org/r/20200311171422.10484-1-david@redhat.com
> [2] https://lkml.kernel.org/r/20200507140139.17083-1-david@redhat.com
> [3] https://lkml.kernel.org/r/20200525084511.51379-1-david@redhat.com
> 
> Cc: teawater <teawaterz@linux.alibaba.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> 
> v2 -> v3:
> - Rebased on upstream/[3]
> - "virtio-mem: Exclude unplugged memory during migration"
> -- Added
> - "virtio-mem: Paravirtualized memory hot(un)plug"
> -- Simplify bitmap operations, find consecutive areas
> -- Tweak error messages
> -- Reshuffle some checks
> -- Minor cleanups
> - "accel/kvm: Convert to ram_block_discard_disable()"
> - "target/i386: sev: Use ram_block_discard_disable()"
> -- Keep asserts clean of functional things
> 
> v1 -> v2:
> - Rebased to object_property_*() changes
> - "exec: Introduce ram_block_discard_(disable|require)()"
> -- Change the function names and rephrase/add comments
> - "virtio-balloon: Rip out qemu_balloon_inhibit()"
> -- Add and use "migration_in_incoming_postcopy()"
> - "migration/rdma: Use ram_block_discard_disable()"
> -- Add a comment regarding pin_all vs. !pin_all
> - "virtio-mem: Paravirtualized memory hot(un)plug"
> -- Replace virtio_mem_discard_inhibited() by
>    migration_in_incoming_postcopy()
> -- Drop some asserts
> -- Drop virtio_mem_bad_request(), use virtio_error() directly, printing
>    more information
> -- Replace "Note: Discarding should never fail ..." comments by
>    error_report()
> -- Replace virtio_stw_p() by cpu_to_le16()
> -- Drop migration_addr and migration_block_size
> -- Minor cleanups
> - "linux-headers: update to contain virtio-mem"
> -- Updated to latest v4 in Linux
> - General changes
> -- Fixup the users of the renamed ram_block_discard_(disable|require)
> -- Use "X: cannot disable RAM discard"-styled error messages
> - Added
> -- "virtio-mem: Migration sanity checks"
> -- "virtio-mem: Add trace events"
> 
> David Hildenbrand (20):
>   exec: Introduce ram_block_discard_(disable|require)()
>   vfio: Convert to ram_block_discard_disable()
>   accel/kvm: Convert to ram_block_discard_disable()
>   s390x/pv: Convert to ram_block_discard_disable()
>   virtio-balloon: Rip out qemu_balloon_inhibit()
>   target/i386: sev: Use ram_block_discard_disable()
>   migration/rdma: Use ram_block_discard_disable()
>   migration/colo: Use ram_block_discard_disable()
>   linux-headers: update to contain virtio-mem
>   virtio-mem: Paravirtualized memory hot(un)plug
>   virtio-pci: Proxy for virtio-mem
>   MAINTAINERS: Add myself as virtio-mem maintainer
>   hmp: Handle virtio-mem when printing memory device info
>   numa: Handle virtio-mem in NUMA stats
>   pc: Support for virtio-mem-pci
>   virtio-mem: Allow notifiers for size changes
>   virtio-pci: Send qapi events when the virtio-mem size changes
>   virtio-mem: Migration sanity checks
>   virtio-mem: Add trace events
>   virtio-mem: Exclude unplugged memory during migration
> 
>  MAINTAINERS                                 |   8 +
>  accel/kvm/kvm-all.c                         |   4 +-
>  balloon.c                                   |  17 -
>  exec.c                                      |  52 ++
>  hw/core/numa.c                              |   6 +
>  hw/i386/Kconfig                             |   1 +
>  hw/i386/pc.c                                |  49 +-
>  hw/s390x/s390-virtio-ccw.c                  |  22 +-
>  hw/vfio/ap.c                                |  10 +-
>  hw/vfio/ccw.c                               |  11 +-
>  hw/vfio/common.c                            |  53 +-
>  hw/vfio/pci.c                               |   6 +-
>  hw/virtio/Kconfig                           |  11 +
>  hw/virtio/Makefile.objs                     |   2 +
>  hw/virtio/trace-events                      |  10 +
>  hw/virtio/virtio-balloon.c                  |   8 +-
>  hw/virtio/virtio-mem-pci.c                  | 157 ++++
>  hw/virtio/virtio-mem-pci.h                  |  34 +
>  hw/virtio/virtio-mem.c                      | 876 ++++++++++++++++++++
>  include/exec/memory.h                       |  41 +
>  include/hw/pci/pci.h                        |   1 +
>  include/hw/vfio/vfio-common.h               |   4 +-
>  include/hw/virtio/virtio-mem.h              |  86 ++
>  include/migration/colo.h                    |   2 +-
>  include/migration/misc.h                    |   2 +
>  include/standard-headers/linux/virtio_ids.h |   1 +
>  include/standard-headers/linux/virtio_mem.h | 211 +++++
>  include/sysemu/balloon.h                    |   2 -
>  migration/migration.c                       |  15 +-
>  migration/postcopy-ram.c                    |  23 -
>  migration/rdma.c                            |  18 +-
>  migration/savevm.c                          |  11 +-
>  monitor/hmp-cmds.c                          |  16 +
>  monitor/monitor.c                           |   1 +
>  qapi/misc.json                              |  64 +-
>  target/i386/sev.c                           |   7 +
>  36 files changed, 1721 insertions(+), 121 deletions(-)
>  create mode 100644 hw/virtio/virtio-mem-pci.c
>  create mode 100644 hw/virtio/virtio-mem-pci.h
>  create mode 100644 hw/virtio/virtio-mem.c
>  create mode 100644 include/hw/virtio/virtio-mem.h
>  create mode 100644 include/standard-headers/linux/virtio_mem.h
> 
> -- 
> 2.25.4


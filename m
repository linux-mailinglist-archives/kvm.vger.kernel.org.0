Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59868135D52
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 17:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732738AbgAIQAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 11:00:02 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40509 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730796AbgAIQAC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 11:00:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578585601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZYNwTh4Tu4Bos8ZZOeTkObg6tVBZsVtEef3Z+yMgUhs=;
        b=ctruRUdIabNgNtgENh3luYERWQEh5ccV18qk/FujZXuiluYoj1liWROskwpmOwCrJVhm+N
        t24uk74yKmWiydvzeLzrZKzKP9eKr7rUu9cFqtH+jHgmvAoBbhbOPCcYGCw+mqu/tCbMt3
        ey2oJSd09TI1b5lC2fDIyoVlSMTVnDo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-jKHUHvAlOV-9lB8EmxIJPA-1; Thu, 09 Jan 2020 10:59:57 -0500
X-MC-Unique: jKHUHvAlOV-9lB8EmxIJPA-1
Received: by mail-qk1-f200.google.com with SMTP id j16so4433767qkk.17
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 07:59:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZYNwTh4Tu4Bos8ZZOeTkObg6tVBZsVtEef3Z+yMgUhs=;
        b=ct7OtWOcVHqdM5g208+4aeB4IXo2LRac9miXXxYE7CynF5n2FyxLSZWN2bTuEeNj0V
         /jbEo9/1OQ/yimD2k8+CCijbzohL/2mWaWwLaX4RSy201JPlHlLS6tuVVjJcU186OfD0
         /golyN5YMXOzIOieZhgTN2rfqgBP54MhV9KXBlFIt6r3zOhdxjFAFc46ER+ecAZyzreT
         AeUlJ0lFu22ByTKN0xeDaNCXwc1uioLkmIeLDyeb3cVji8+FtZQgFSpAD33keUDdJ+u1
         C3W6Dcl2GTmEVoNd6kmxuRvL63/iZItj6Mn0Za66Fl+lpFy6DecNY2nmCtblVboP49gz
         CSYQ==
X-Gm-Message-State: APjAAAUjQnUSqIx+1GK9SV9ohDkPhtDjYgwo/GGHQKjCDyrqCf/Y4Qml
        J3MkP4y9w6y+gGF/FpZlYX5Lqq7XVtQsv+jaU1MRrGllXS7QURfSgbDQZHs0E63RwPvoK84INel
        tidzZ0i1s0nCR
X-Received: by 2002:aed:2e02:: with SMTP id j2mr8369187qtd.370.1578585597211;
        Thu, 09 Jan 2020 07:59:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqz3MHsanpxEwVWBpdyHyNxRs8eWkHDAm95FtF3MPWMx3s40lIzLfEwwE1x1R2+LvWrK9fIE9Q==
X-Received: by 2002:aed:2e02:: with SMTP id j2mr8369170qtd.370.1578585596953;
        Thu, 09 Jan 2020 07:59:56 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id t3sm3602189qtc.8.2020.01.09.07.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 07:59:56 -0800 (PST)
Date:   Thu, 9 Jan 2020 10:59:50 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v3 00/21] KVM: Dirty ring interface
Message-ID: <20200109105443-mutt-send-email-mst@kernel.org>
References: <20200109145729.32898-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 09:57:08AM -0500, Peter Xu wrote:
> Branch is here: https://github.com/xzpeter/linux/tree/kvm-dirty-ring
> (based on kvm/queue)
> 
> Please refer to either the previous cover letters, or documentation
> update in patch 12 for the big picture.

I would rather you pasted it here. There's no way to respond otherwise.

For something that's presumably an optimization, isn't there
some kind of testing that can be done to show the benefits?
What kind of gain was observed?

I know it's mostly relevant for huge VMs, but OTOH these
probably use huge pages.




>  Previous posts:
> 
> V1: https://lore.kernel.org/kvm/20191129213505.18472-1-peterx@redhat.com
> V2: https://lore.kernel.org/kvm/20191221014938.58831-1-peterx@redhat.com
> 
> The major change in V3 is that we dropped the whole waitqueue and the
> global lock. With that, we have clean per-vcpu ring and no default
> ring any more.  The two kvmgt refactoring patches were also included
> to show the dependency of the works.
> 
> Patchset layout:
> 
> Patch 1-2:         Picked up from kvmgt refactoring
> Patch 3-6:         Small patches that are not directly related,
>                    (So can be acked/nacked/picked as standalone)
> Patch 7-11:        Prepares for the dirty ring interface
> Patch 12:          Major implementation
> Patch 13-14:       Quick follow-ups for patch 8
> Patch 15-21:       Test cases
> 
> V3 changelog:
> 
> - fail userspace writable maps on dirty ring ranges [Jason]
> - commit message fixups [Paolo]
> - change __x86_set_memory_region to return hva [Paolo]
> - cacheline align for indices [Paolo, Jason]
> - drop waitqueue, global lock, etc., include kvmgt rework patchset
> - take lock for __x86_set_memory_region() (otherwise it triggers a
>   lockdep in latest kvm/queue) [Paolo]
> - check KVM_DIRTY_LOG_PAGE_OFFSET in kvm_vm_ioctl_enable_dirty_log_ring
> - one more patch to drop x86_set_memory_region [Paolo]
> - one more patch to remove extra srcu usage in init_rmode_identity_map()
> - add some r-bs for Paolo
> 
> Please review, thanks.
> 
> Paolo Bonzini (1):
>   KVM: Move running VCPU from ARM to common code
> 
> Peter Xu (18):
>   KVM: Remove kvm_read_guest_atomic()
>   KVM: Add build-time error check on kvm_run size
>   KVM: X86: Change parameter for fast_page_fault tracepoint
>   KVM: X86: Don't take srcu lock in init_rmode_identity_map()
>   KVM: Cache as_id in kvm_memory_slot
>   KVM: X86: Drop x86_set_memory_region()
>   KVM: X86: Don't track dirty for KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
>   KVM: Pass in kvm pointer into mark_page_dirty_in_slot()
>   KVM: X86: Implement ring-based dirty memory tracking
>   KVM: Make dirty ring exclusive to dirty bitmap log
>   KVM: Don't allocate dirty bitmap if dirty ring is enabled
>   KVM: selftests: Always clear dirty bitmap after iteration
>   KVM: selftests: Sync uapi/linux/kvm.h to tools/
>   KVM: selftests: Use a single binary for dirty/clear log test
>   KVM: selftests: Introduce after_vcpu_run hook for dirty log test
>   KVM: selftests: Add dirty ring buffer test
>   KVM: selftests: Let dirty_log_test async for dirty ring test
>   KVM: selftests: Add "-c" parameter to dirty log test
> 
> Yan Zhao (2):
>   vfio: introduce vfio_iova_rw to read/write a range of IOVAs
>   drm/i915/gvt: subsitute kvm_read/write_guest with vfio_iova_rw
> 
>  Documentation/virt/kvm/api.txt                |  96 ++++
>  arch/arm/include/asm/kvm_host.h               |   2 -
>  arch/arm64/include/asm/kvm_host.h             |   2 -
>  arch/x86/include/asm/kvm_host.h               |   7 +-
>  arch/x86/include/uapi/asm/kvm.h               |   1 +
>  arch/x86/kvm/Makefile                         |   3 +-
>  arch/x86/kvm/mmu/mmu.c                        |   6 +
>  arch/x86/kvm/mmutrace.h                       |   9 +-
>  arch/x86/kvm/svm.c                            |   3 +-
>  arch/x86/kvm/vmx/vmx.c                        |  86 ++--
>  arch/x86/kvm/x86.c                            |  43 +-
>  drivers/gpu/drm/i915/gvt/kvmgt.c              |  25 +-
>  drivers/vfio/vfio.c                           |  45 ++
>  drivers/vfio/vfio_iommu_type1.c               |  81 ++++
>  include/linux/kvm_dirty_ring.h                |  55 +++
>  include/linux/kvm_host.h                      |  37 +-
>  include/linux/vfio.h                          |   5 +
>  include/trace/events/kvm.h                    |  78 ++++
>  include/uapi/linux/kvm.h                      |  33 ++
>  tools/include/uapi/linux/kvm.h                |  38 ++
>  tools/testing/selftests/kvm/Makefile          |   2 -
>  .../selftests/kvm/clear_dirty_log_test.c      |   2 -
>  tools/testing/selftests/kvm/dirty_log_test.c  | 420 ++++++++++++++++--
>  .../testing/selftests/kvm/include/kvm_util.h  |   4 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  72 +++
>  .../selftests/kvm/lib/kvm_util_internal.h     |   3 +
>  virt/kvm/arm/arch_timer.c                     |   2 +-
>  virt/kvm/arm/arm.c                            |  29 --
>  virt/kvm/arm/perf.c                           |   6 +-
>  virt/kvm/arm/vgic/vgic-mmio.c                 |  15 +-
>  virt/kvm/dirty_ring.c                         | 162 +++++++
>  virt/kvm/kvm_main.c                           | 215 +++++++--
>  32 files changed, 1379 insertions(+), 208 deletions(-)
>  create mode 100644 include/linux/kvm_dirty_ring.h
>  delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c
>  create mode 100644 virt/kvm/dirty_ring.c
> 
> -- 
> 2.24.1


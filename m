Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B842A9540
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 12:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgKFL23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 06:28:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42524 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727057AbgKFL22 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 06:28:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604662106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xwH50/hu/Vb+g+7+SeLJiBP3zh0MjzQ219wCgqZ6F5M=;
        b=c0ZCT0GFjTWIaHmM7Zcex+61jWdUjcm2edc6S3gd3BfVF+uNThRpi51X7y19meyNmHIvfP
        rRnYdJkDGvUrRhFq4ycwIpYxZoJxr18OZAeMXhlq0+9iTToOATkAxAt5scobGdavvFN8kT
        SgWhAlH/CprQfSS06m54CN2z7rGRhBo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-fABq93omNeiGF8TWsUckgQ-1; Fri, 06 Nov 2020 06:28:24 -0500
X-MC-Unique: fABq93omNeiGF8TWsUckgQ-1
Received: by mail-wr1-f72.google.com with SMTP id h8so365749wrt.9
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 03:28:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xwH50/hu/Vb+g+7+SeLJiBP3zh0MjzQ219wCgqZ6F5M=;
        b=rkgYl8dZNiB7mp5NNxGClwZHgfBfcUPkglB0aA8OTbh0jpOFssKtXHNMtXh7meo3d8
         cRKzGb/qcuyviXCCOAdC+HrZRr5r95Sb2fQjluIrQ3UDn3+JTraHaY2EHj+OTc+SZam9
         c79IIvDVryQ8Hno7uzMOpnXJ3jAxy6R/Q9TO3sDghcFD94MOqaB2AqEf6HHiWLi/boYs
         8aRf7UNQy15crvtA5uBmXz2qNCfSRqbcy5dewVefL0RiMTh/6A9OWm0RINC5Azi1OmEO
         x/KfSH9cyr66V4rPadEr+JqOf8acDJpAggoYIow07RR/Bz1pmle6MN6eWp43Sj7ME0cr
         NcFQ==
X-Gm-Message-State: AOAM531B4Bxgam2c4EqiQO9dR8vmzhkpHfQs6/q/p+7ii1ZUUQlx4Lle
        IQPqtaTDUYwVO06SVXsgY8Sj8+tctRCLAQBVWwsjC5QlY6C6OUSRE0att9UL0ai/rP2G3134qDS
        X03XQbdxKJ5/R
X-Received: by 2002:a1c:2ed3:: with SMTP id u202mr1982360wmu.85.1604662100272;
        Fri, 06 Nov 2020 03:28:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzWuT1FdrvGXBqNdGSi+5hjGaXOu1B8IMDa1ipw42no9xiezhwvWGoGlQv7LTQ7s8T8Yr5s0w==
X-Received: by 2002:a1c:2ed3:: with SMTP id u202mr1982333wmu.85.1604662100026;
        Fri, 06 Nov 2020 03:28:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id z191sm1786091wme.30.2020.11.06.03.28.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 03:28:19 -0800 (PST)
Subject: Re: [PATCH v13 00/14] KVM: Dirty ring interface
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20201001012044.5151-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8b3f68dd-c61c-16a0-2077-0a5d3d57a357@redhat.com>
Date:   Fri, 6 Nov 2020 12:28:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201001012044.5151-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/20 03:20, Peter Xu wrote:
> KVM branch:
>    https://github.com/xzpeter/linux/tree/kvm-dirty-ring
> 
> QEMU branch for testing:
>    https://github.com/xzpeter/qemu/tree/kvm-dirty-ring
> 
> v13:
> - rebase to kvm/queue rather than 5.9-rc7.  I think, kvm/queue is broken.  I
>    can only test the dirty ring after I revert 3eb900173c71 ("KVM: x86: VMX:
>    Prevent MSR passthrough when MSR access is denied", 2020-09-28), otherwise
>    the guest will hang on vcpu0 looping forever during boot Linux.
> - added another trivial patch "KVM: Documentation: Update entry for
>    KVM_X86_SET_MSR_FILTER".  It should be squashed into 1a155254ff93 ("KVM: x86:
>    Introduce MSR filtering", 2020-09-28) directly.
> 
> v12:
> - add r-bs for Sean
> - rebase
> 
> v11:
> - rebased to kvm/queue (seems the newest)
> - removed kvm_dirty_ring_waitqueue() tracepoint since not used
> - set memslot->as_id in kvm_delete_memslot() [Sean]
> - let __copy_to_user() always return -EFAULT [Sean]
> - rename 'r' in alloc_apic_access_page into 'hva' [Sean]
> 
> v10:
> - remove unused identity_map_pfn in init_rmode_identity_map [syzbot]
> - add "static" to kvm_dirty_ring_full [syzbot]
> - kvm_page_in_dirty_ring() use "#if" macros for KVM_DIRTY_LOG_PAGE_OFFSET to
>    quiesce syzbot [syzbot]
> - s/false/null/ in gfn_to_memslot_dirty_bitmap() [syzbot]
> 
> v9:
> - patch 3: __x86_set_memory_region: squash another trivial change to return
>    (0xdeadull << 48) always for slot removal [Sean]
> - pick r-bs for Drew
> 
> For previous versions, please refer to:
> 
> V1: https://lore.kernel.org/kvm/20191129213505.18472-1-peterx@redhat.com
> V2: https://lore.kernel.org/kvm/20191221014938.58831-1-peterx@redhat.com
> V3: https://lore.kernel.org/kvm/20200109145729.32898-1-peterx@redhat.com
> V4: https://lore.kernel.org/kvm/20200205025105.367213-1-peterx@redhat.com
> V5: https://lore.kernel.org/kvm/20200304174947.69595-1-peterx@redhat.com
> V6: https://lore.kernel.org/kvm/20200309214424.330363-1-peterx@redhat.com
> V7: https://lore.kernel.org/kvm/20200318163720.93929-1-peterx@redhat.com
> V8: https://lore.kernel.org/kvm/20200331190000.659614-1-peterx@redhat.com
> V9: https://lore.kernel.org/kvm/20200523225659.1027044-1-peterx@redhat.com
> V10: https://lore.kernel.org/kvm/20200601115957.1581250-1-peterx@redhat.com/
> 
> Overview
> ============
> 
> This is a continued work from Lei Cao <lei.cao@stratus.com> and Paolo
> Bonzini on the KVM dirty ring interface.
> 
> The new dirty ring interface is another way to collect dirty pages for
> the virtual machines. It is different from the existing dirty logging
> interface in a few ways, majorly:
> 
>    - Data format: The dirty data was in a ring format rather than a
>      bitmap format, so dirty bits to sync for dirty logging does not
>      depend on the size of guest memory any more, but speed of
>      dirtying.  Also, the dirty ring is per-vcpu, while the dirty
>      bitmap is per-vm.
> 
>    - Data copy: The sync of dirty pages does not need data copy any more,
>      but instead the ring is shared between the userspace and kernel by
>      page sharings (mmap() on vcpu fd)
> 
>    - Interface: Instead of using the old KVM_GET_DIRTY_LOG,
>      KVM_CLEAR_DIRTY_LOG interfaces, the new ring uses the new
>      KVM_RESET_DIRTY_RINGS ioctl when we want to reset the collected
>      dirty pages to protected mode again (works like
>      KVM_CLEAR_DIRTY_LOG, but ring based).  To collecting dirty bits,
>      we only need to read the ring data, no ioctl is needed.
> 
> Ring Layout
> ===========
> 
> KVM dirty ring is per-vcpu.  Each ring is an array of kvm_dirty_gfn
> defined as:
> 
> struct kvm_dirty_gfn {
>          __u32 flags;
>          __u32 slot; /* as_id | slot_id */
>          __u64 offset;
> };
> 
> Each GFN is a state machine itself.  The state is embeded in the flags
> field, as defined in the uapi header:
> 
> /*
>   * KVM dirty GFN flags, defined as:
>   *
>   * |---------------+---------------+--------------|
>   * | bit 1 (reset) | bit 0 (dirty) | Status       |
>   * |---------------+---------------+--------------|
>   * |             0 |             0 | Invalid GFN  |
>   * |             0 |             1 | Dirty GFN    |
>   * |             1 |             X | GFN to reset |
>   * |---------------+---------------+--------------|
>   *
>   * Lifecycle of a dirty GFN goes like:
>   *
>   *      dirtied         collected        reset
>   * 00 -----------> 01 -------------> 1X -------+
>   *  ^                                          |
>   *  |                                          |
>   *  +------------------------------------------+
>   *
>   * The userspace program is only responsible for the 01->1X state
>   * conversion (to collect dirty bits).  Also, it must not skip any
>   * dirty bits so that dirty bits are always collected in sequence.
>   */
> 
> Testing
> =======
> 
> This series provided both the implementation of the KVM dirty ring and
> the test case.  Also I've implemented the QEMU counterpart that can
> run with the new KVM, link can be found at the top of the cover
> letter.  However that's still a very initial version which is prone to
> change and future optimizations.
> 
> I did some measurement with the new method with 24G guest running some
> dirty workload, I don't see any speedup so far, even in some heavy
> dirty load it'll be slower (e.g., when 800MB/s random dirty rate, kvm
> dirty ring takes average of ~73s to complete migration while dirty
> logging only needs average of ~55s).  However that's understandable
> because 24G guest means only 1M dirty bitmap, that's still a suitable
> case for dirty logging.  Meanwhile heavier workload means worst case
> for dirty ring.
> 
> More tests are welcomed if there's bigger host/guest, especially on
> COLO-like workload.
> 
> Please review, thanks.
> 
> Peter Xu (14):
>    KVM: Documentation: Update entry for KVM_X86_SET_MSR_FILTER
>    KVM: Cache as_id in kvm_memory_slot
>    KVM: X86: Don't track dirty for KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
>    KVM: Pass in kvm pointer into mark_page_dirty_in_slot()
>    KVM: X86: Implement ring-based dirty memory tracking
>    KVM: Make dirty ring exclusive to dirty bitmap log
>    KVM: Don't allocate dirty bitmap if dirty ring is enabled
>    KVM: selftests: Always clear dirty bitmap after iteration
>    KVM: selftests: Sync uapi/linux/kvm.h to tools/
>    KVM: selftests: Use a single binary for dirty/clear log test
>    KVM: selftests: Introduce after_vcpu_run hook for dirty log test
>    KVM: selftests: Add dirty ring buffer test
>    KVM: selftests: Let dirty_log_test async for dirty ring test
>    KVM: selftests: Add "-c" parameter to dirty log test
> 
>   Documentation/virt/kvm/api.rst                | 126 ++++-
>   arch/x86/include/asm/kvm_host.h               |   6 +-
>   arch/x86/include/uapi/asm/kvm.h               |   1 +
>   arch/x86/kvm/Makefile                         |   3 +-
>   arch/x86/kvm/mmu/mmu.c                        |  10 +-
>   arch/x86/kvm/svm/avic.c                       |   9 +-
>   arch/x86/kvm/vmx/vmx.c                        |  96 ++--
>   arch/x86/kvm/x86.c                            |  46 +-
>   include/linux/kvm_dirty_ring.h                | 103 ++++
>   include/linux/kvm_host.h                      |  19 +
>   include/trace/events/kvm.h                    |  63 +++
>   include/uapi/linux/kvm.h                      |  53 ++
>   tools/include/uapi/linux/kvm.h                |  77 ++-
>   tools/testing/selftests/kvm/Makefile          |   2 -
>   .../selftests/kvm/clear_dirty_log_test.c      |   6 -
>   tools/testing/selftests/kvm/dirty_log_test.c  | 505 ++++++++++++++++--
>   .../testing/selftests/kvm/include/kvm_util.h  |   4 +
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  72 ++-
>   .../selftests/kvm/lib/kvm_util_internal.h     |   4 +
>   virt/kvm/dirty_ring.c                         | 197 +++++++
>   virt/kvm/kvm_main.c                           | 168 +++++-
>   21 files changed, 1432 insertions(+), 138 deletions(-)
>   create mode 100644 include/linux/kvm_dirty_ring.h
>   delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c
>   create mode 100644 virt/kvm/dirty_ring.c
> 

Queued, thanks!  Now on to QEMU...

Paolo


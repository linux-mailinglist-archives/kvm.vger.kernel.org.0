Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F591EA334
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 14:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgFAMAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 08:00:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50634 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbgFAMAJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jun 2020 08:00:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591012807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=b4s9WcgqlVxtr+9EizXh9/KmNnkbCqzI2Fd20X5rtec=;
        b=MZnEoCNcj00RUy0ZtGc5IXM4mMOVAF8JVWPoc/2yAeDrcxtkh9l9ZTq5r7/VCXklpGL9qq
        DaULUnGt+7SW6yeWIQsHtkJlpq6rlp5Ted9U7uKOlnsbcUQgiHW+ryUofJVShNZt4BDIQY
        gH2APV529wIyt8pMWj8Sh4lmGJppmpE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-GIPqQqtwMKi0jO-5o4n-lw-1; Mon, 01 Jun 2020 08:00:02 -0400
X-MC-Unique: GIPqQqtwMKi0jO-5o4n-lw-1
Received: by mail-qk1-f200.google.com with SMTP id c197so3899448qke.10
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 05:00:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b4s9WcgqlVxtr+9EizXh9/KmNnkbCqzI2Fd20X5rtec=;
        b=P5MmqHTo+z0ikIC/dl5d9mmh8Pk5P5CWZRJ/WJ5fcMXammN/y2YZyDW15NSagc8/1l
         1UXSXqm2itKXirSG6TSaJEpJavJJTS12+oORp1m2lsOPecPS7YJ9bn7bUVjbhpGCIahA
         AYufIz+IgiHzzK+LElNtJQYQNkr5PQxRAhutYCBfCkdrmxXnNFdmV+ftaeQGZHng1z4p
         tVTOt5OwTi9uf6e2F7X/lDRDd8tGl/I6tFpLUDhGNkqvf8G5P8kmd0qFz1Zq/ma7BjOp
         OQwquXLpC1mCbLGGWYOlfTWAUt1srXWMhhIfErRUq06YIdInarh2mKSIbmjzhrqTsw77
         B1HQ==
X-Gm-Message-State: AOAM5336rsxd+Z++yNuvkjJ0YapWvOJSa2d68UU2zRuz6/7A3zIPXKyW
        Z0iF8QBK5ojuPjuHp2VX1rBhm7y2CbqVix6vm8JMG6iPUSWzn4Uayr4cPm2n3RB3pQYliGiLBKC
        HU7tSnGqE5MRf
X-Received: by 2002:a0c:83a6:: with SMTP id k35mr20592083qva.251.1591012801709;
        Mon, 01 Jun 2020 05:00:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYHGa+3xkcUnrLNND3SShHOHA9YhMl/arSqtVWMF5nPsi24AE2ZzB/PLX4748dqxh9lXeNdg==
X-Received: by 2002:a0c:83a6:: with SMTP id k35mr20592052qva.251.1591012801332;
        Mon, 01 Jun 2020 05:00:01 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id l9sm14474185qki.90.2020.06.01.04.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 05:00:00 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v10 00/14] KVM: Dirty ring interface
Date:   Mon,  1 Jun 2020 07:59:43 -0400
Message-Id: <20200601115957.1581250-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM branch:
  https://github.com/xzpeter/linux/tree/kvm-dirty-ring

QEMU branch for testing:
  https://github.com/xzpeter/qemu/tree/kvm-dirty-ring

v10:
- remove unused identity_map_pfn in init_rmode_identity_map [syzbot]
- add "static" to kvm_dirty_ring_full [syzbot]
- kvm_page_in_dirty_ring() use "#if" macros for KVM_DIRTY_LOG_PAGE_OFFSET to
  quiesce syzbot [syzbot]
- s/false/null/ in gfn_to_memslot_dirty_bitmap() [syzbot]

v9:
- patch 3: __x86_set_memory_region: squash another trivial change to return
  (0xdeadull << 48) always for slot removal [Sean]
- pick r-bs for Drew

v8:
- rebase to kvm/next
- fix test bisection issues [Drew]
- reword comment for __x86_set_memory_region [Sean]
- document fixup on "mutual exclusive", etc. [Sean]

For previous versions, please refer to:

V1: https://lore.kernel.org/kvm/20191129213505.18472-1-peterx@redhat.com
V2: https://lore.kernel.org/kvm/20191221014938.58831-1-peterx@redhat.com
V3: https://lore.kernel.org/kvm/20200109145729.32898-1-peterx@redhat.com
V4: https://lore.kernel.org/kvm/20200205025105.367213-1-peterx@redhat.com
V5: https://lore.kernel.org/kvm/20200304174947.69595-1-peterx@redhat.com
V6: https://lore.kernel.org/kvm/20200309214424.330363-1-peterx@redhat.com
V7: https://lore.kernel.org/kvm/20200318163720.93929-1-peterx@redhat.com
V8: https://lore.kernel.org/kvm/20200331190000.659614-1-peterx@redhat.com
V9: https://lore.kernel.org/kvm/20200523225659.1027044-1-peterx@redhat.com

Overview
============

This is a continued work from Lei Cao <lei.cao@stratus.com> and Paolo
Bonzini on the KVM dirty ring interface.

The new dirty ring interface is another way to collect dirty pages for
the virtual machines. It is different from the existing dirty logging
interface in a few ways, majorly:

  - Data format: The dirty data was in a ring format rather than a
    bitmap format, so dirty bits to sync for dirty logging does not
    depend on the size of guest memory any more, but speed of
    dirtying.  Also, the dirty ring is per-vcpu, while the dirty
    bitmap is per-vm.

  - Data copy: The sync of dirty pages does not need data copy any more,
    but instead the ring is shared between the userspace and kernel by
    page sharings (mmap() on vcpu fd)

  - Interface: Instead of using the old KVM_GET_DIRTY_LOG,
    KVM_CLEAR_DIRTY_LOG interfaces, the new ring uses the new
    KVM_RESET_DIRTY_RINGS ioctl when we want to reset the collected
    dirty pages to protected mode again (works like
    KVM_CLEAR_DIRTY_LOG, but ring based).  To collecting dirty bits,
    we only need to read the ring data, no ioctl is needed.

Ring Layout
===========

KVM dirty ring is per-vcpu.  Each ring is an array of kvm_dirty_gfn
defined as:

struct kvm_dirty_gfn {
        __u32 flags;
        __u32 slot; /* as_id | slot_id */
        __u64 offset;
};

Each GFN is a state machine itself.  The state is embeded in the flags
field, as defined in the uapi header:

/*
 * KVM dirty GFN flags, defined as:
 *
 * |---------------+---------------+--------------|
 * | bit 1 (reset) | bit 0 (dirty) | Status       |
 * |---------------+---------------+--------------|
 * |             0 |             0 | Invalid GFN  |
 * |             0 |             1 | Dirty GFN    |
 * |             1 |             X | GFN to reset |
 * |---------------+---------------+--------------|
 *
 * Lifecycle of a dirty GFN goes like:
 *
 *      dirtied         collected        reset
 * 00 -----------> 01 -------------> 1X -------+
 *  ^                                          |
 *  |                                          |
 *  +------------------------------------------+
 *
 * The userspace program is only responsible for the 01->1X state
 * conversion (to collect dirty bits).  Also, it must not skip any
 * dirty bits so that dirty bits are always collected in sequence.
 */

Testing
=======

This series provided both the implementation of the KVM dirty ring and
the test case.  Also I've implemented the QEMU counterpart that can
run with the new KVM, link can be found at the top of the cover
letter.  However that's still a very initial version which is prone to
change and future optimizations.

I did some measurement with the new method with 24G guest running some
dirty workload, I don't see any speedup so far, even in some heavy
dirty load it'll be slower (e.g., when 800MB/s random dirty rate, kvm
dirty ring takes average of ~73s to complete migration while dirty
logging only needs average of ~55s).  However that's understandable
because 24G guest means only 1M dirty bitmap, that's still a suitable
case for dirty logging.  Meanwhile heavier workload means worst case
for dirty ring.

More tests are welcomed if there's bigger host/guest, especially on
COLO-like workload.

Please review, thanks.

Peter Xu (14):
  KVM: X86: Change parameter for fast_page_fault tracepoint
  KVM: Cache as_id in kvm_memory_slot
  KVM: X86: Don't track dirty for KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
  KVM: Pass in kvm pointer into mark_page_dirty_in_slot()
  KVM: X86: Implement ring-based dirty memory tracking
  KVM: Make dirty ring exclusive to dirty bitmap log
  KVM: Don't allocate dirty bitmap if dirty ring is enabled
  KVM: selftests: Always clear dirty bitmap after iteration
  KVM: selftests: Sync uapi/linux/kvm.h to tools/
  KVM: selftests: Use a single binary for dirty/clear log test
  KVM: selftests: Introduce after_vcpu_run hook for dirty log test
  KVM: selftests: Add dirty ring buffer test
  KVM: selftests: Let dirty_log_test async for dirty ring test
  KVM: selftests: Add "-c" parameter to dirty log test

 Documentation/virt/kvm/api.rst                | 123 +++++
 arch/x86/include/asm/kvm_host.h               |   6 +-
 arch/x86/include/uapi/asm/kvm.h               |   1 +
 arch/x86/kvm/Makefile                         |   3 +-
 arch/x86/kvm/mmu/mmu.c                        |  10 +-
 arch/x86/kvm/mmutrace.h                       |   9 +-
 arch/x86/kvm/svm/avic.c                       |  11 +-
 arch/x86/kvm/vmx/vmx.c                        |  92 ++--
 arch/x86/kvm/x86.c                            |  53 +-
 include/linux/kvm_dirty_ring.h                | 103 ++++
 include/linux/kvm_host.h                      |  19 +
 include/trace/events/kvm.h                    |  78 +++
 include/uapi/linux/kvm.h                      |  53 ++
 tools/include/uapi/linux/kvm.h                |  53 ++
 tools/testing/selftests/kvm/Makefile          |   2 -
 .../selftests/kvm/clear_dirty_log_test.c      |   6 -
 tools/testing/selftests/kvm/dirty_log_test.c  | 505 ++++++++++++++++--
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  68 +++
 .../selftests/kvm/lib/kvm_util_internal.h     |   4 +
 virt/kvm/dirty_ring.c                         | 197 +++++++
 virt/kvm/kvm_main.c                           | 163 +++++-
 22 files changed, 1423 insertions(+), 140 deletions(-)
 create mode 100644 include/linux/kvm_dirty_ring.h
 delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c
 create mode 100644 virt/kvm/dirty_ring.c

-- 
2.26.2


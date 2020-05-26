Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAF61DFB6F
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 00:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388117AbgEWW5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 18:57:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46220 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388042AbgEWW5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 18:57:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590274628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ak8gK7GNAl4EoeqUzd3T8XVnCS3M/ZLmkhVunIHgMSg=;
        b=cfCALY+HdzKL1POtlaWb2bR2NDS0cJd1oW8cwknJNDZMUpKM4SX/Uzdkb2AN5/AAvAiJ3x
        C1Ua1gea8O1QvKfjfjahshoI1UUpOMRIYRac+1Y8xrQ/9uW25+e4yMsuuv4ZP6oF6YvwOS
        CYPrXUTVRGEv41ooGuM/l22ONU/jnEE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-ve7OhXjaPH6_4msYS62HEg-1; Sat, 23 May 2020 18:57:04 -0400
X-MC-Unique: ve7OhXjaPH6_4msYS62HEg-1
Received: by mail-qv1-f72.google.com with SMTP id dt19so14181388qvb.5
        for <kvm@vger.kernel.org>; Sat, 23 May 2020 15:57:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ak8gK7GNAl4EoeqUzd3T8XVnCS3M/ZLmkhVunIHgMSg=;
        b=pptujs9oKU7oEgwaqohbiduIZUiqmMarsb4Mbn6c9hQOYLMuYkP7BfNqLEWkC5sKuF
         FATz5M17qEvt2AIaiTQc/rT/WYsmF3OiDoVkIZu2IEySwVmv503gb/l+2cVbG5dW7X4K
         1H9mIc3XrGGrbYMx35bfFB4xJu8aYXDRowT9p6oI9xDGIFzn7rK0kAWUPiORQTFQguUy
         BC0m1jgzIu5V+wVMLs3wJ+WloNQu0IPkh5v/lEMHmkdyjLlmlGtFYbXYbDatZKey0G0Z
         PyFJZa5Z8b4iC0gxkgMSTrS/FyAiaG/vQyez7Y69V4XmYNEeJ3pc6P2ScIWVYDB+UVTk
         K/hg==
X-Gm-Message-State: AOAM530kFtDg3VVhYQZ5Vcywn+RJWIoldYvGwKzeaNz9IEkMR15gMVd+
        xc7UW7RDhOBnyz5UxsRY2r2LIMYnohT38Uab3pUeKR9x4y2zVjiaJy2uTtH9SeNukuWz+I6X9d4
        +LnbZivKlUFdT
X-Received: by 2002:ac8:6cf:: with SMTP id j15mr22239407qth.143.1590274623903;
        Sat, 23 May 2020 15:57:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylCK/o2NNseX4bI35qrHG6Z9sjKhapnRw7cBT3s7JjrXpw/jL1gk7SLlunETsB099ebjxu0w==
X-Received: by 2002:ac8:6cf:: with SMTP id j15mr22239397qth.143.1590274623525;
        Sat, 23 May 2020 15:57:03 -0700 (PDT)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id w14sm11630979qtt.82.2020.05.23.15.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 15:57:02 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v9 00/14] KVM: Dirty ring interface
Date:   Sat, 23 May 2020 18:56:45 -0400
Message-Id: <20200523225659.1027044-1-peterx@redhat.com>
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
 arch/x86/kvm/mmu/mmu.c                        |  12 +-
 arch/x86/kvm/mmutrace.h                       |   9 +-
 arch/x86/kvm/svm/avic.c                       |  11 +-
 arch/x86/kvm/vmx/vmx.c                        |  90 ++--
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
 virt/kvm/kvm_main.c                           | 162 +++++-
 22 files changed, 1423 insertions(+), 139 deletions(-)
 create mode 100644 include/linux/kvm_dirty_ring.h
 delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c
 create mode 100644 virt/kvm/dirty_ring.c

-- 
2.26.2


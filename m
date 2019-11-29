Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 562A410DAF4
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfK2Vcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:32:50 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49966 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727116AbfK2Vcu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 16:32:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=peI3w5GhWEX1JieJHH29KyaSX4w2AsTjOin5SLB/5Gw=;
        b=jSNTEX5OfiErFkF8aJvja4ywZY9ZK6PYxAMszHX4xtvrXwQZQKE/B0kFm/6sIQE5OH1qwJ
        naWT5q9y9lVYVCo34HLhnJSkGu3o4bkddnLetn3jKtYbztuCw60H3mUG0T6KCN23RuXJz8
        lUXm3wq3yMZt4AQkHa+sEOJq7CfiFas=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-5OIN4PcGNI2DbeqWSDHIXg-1; Fri, 29 Nov 2019 16:32:45 -0500
Received: by mail-qv1-f71.google.com with SMTP id q2so19609884qvo.23
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:32:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cn7j7/8SJgeM/ER61fZ1AdZGSd2mYCJ7pUgcBKPF2KQ=;
        b=M9Z1kNk/KCnC3ihrbHEO0DJbfi8mBlisq4QevcLOr+/2D5LqPifgw7xRLRb1RreM1H
         +N5r9jTxU8w1DNWHZnGdcD/0+cA6ZJEhxjeSUXsx5LHoZ9ox9ly9h39lSpu8uI4c920B
         Uj68bQQHKAkO0hj18aH+Ugweu+MCADUdXw+u6NhMqeQrasd39WLvg/SDh8iISLG3ffpp
         5Iu+AMU9ljOewOdn/3Ke+LIxF6i6QjUvdXWaGMJkNzVOF7anG3rmZxpUkSeFWW/q92qU
         n74FqpZZMl09Nz3UilYTWMEJjfF4kaUL/wdUVMVOxG9RtJPS5tUOqos5mDti+/w5+6K8
         TYXg==
X-Gm-Message-State: APjAAAWNZaFjE+Ur5aa/n/0ArLqneEvG2ggmGZ8yKEGX5KiR3qRV4ooY
        PY/zOznrw/FlnlnhPIziWm9+GUZedrNP76+jgVEZKzHGb+8M4WS6Uwx7B/fHYQIS1AETTlCwpIv
        +uq5/6R+ZFopc
X-Received: by 2002:ad4:588d:: with SMTP id dz13mr19982295qvb.86.1575063164827;
        Fri, 29 Nov 2019 13:32:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqy5eIATWxerwmd03ez0vmrXtvk2z5PAQi557Z+8gFzf+IEvRetJH80wrZlItjYLRMnxc+PPpA==
X-Received: by 2002:ad4:588d:: with SMTP id dz13mr19982258qvb.86.1575063164469;
        Fri, 29 Nov 2019 13:32:44 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id n5sm10634817qkf.48.2019.11.29.13.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:32:43 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Cao Lei <Lei.Cao@stratus.com>,
        peterx@redhat.com, "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 00/15] KVM: Dirty ring interface
Date:   Fri, 29 Nov 2019 16:32:27 -0500
Message-Id: <20191129213242.17144-1-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-MC-Unique: 5OIN4PcGNI2DbeqWSDHIXg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Branch is here: https://github.com/xzpeter/linux/tree/kvm-dirty-ring

Overview
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

This is a continued work from Lei Cao <lei.cao@stratus.com> and Paolo
on the KVM dirty ring interface.  To make it simple, I'll still start
with version 1 as RFC.

The new dirty ring interface is another way to collect dirty pages for
the virtual machine, but it is different from the existing dirty
logging interface in a few ways, majorly:

  - Data format: The dirty data was in a ring format rather than a
    bitmap format, so the size of data to sync for dirty logging does
    not depend on the size of guest memory any more, but speed of
    dirtying.  Also, the dirty ring is per-vcpu (currently plus
    another per-vm ring, so total ring number is N+1), while the dirty
    bitmap is per-vm.

  - Data copy: The sync of dirty pages does not need data copy any more,
    but instead the ring is shared between the userspace and kernel by
    page sharings (mmap() on either the vm fd or vcpu fd)

  - Interface: Instead of using the old KVM_GET_DIRTY_LOG,
    KVM_CLEAR_DIRTY_LOG interfaces, the new ring uses a new interface
    called KVM_RESET_DIRTY_RINGS when we want to reset the collected
    dirty pages to protected mode again (works like
    KVM_CLEAR_DIRTY_LOG, but ring based)

And more.

I would appreciate if the reviewers can start with patch "KVM:
Implement ring-based dirty memory tracking", especially the document
update part for the big picture.  Then I'll avoid copying into most of
them into cover letter again.

I marked this series as RFC because I'm at least uncertain on this
change of vcpu_enter_guest():

        if (kvm_check_request(KVM_REQ_DIRTY_RING_FULL, vcpu)) {
                vcpu->run->exit_reason =3D KVM_EXIT_DIRTY_RING_FULL;
                /*
                        * If this is requested, it means that we've
                        * marked the dirty bit in the dirty ring BUT
                        * we've not written the date.  Do it now.
                        */
                r =3D kvm_emulate_instruction(vcpu, 0);
                r =3D r >=3D 0 ? 0 : r;
                goto out;
        }

I did a kvm_emulate_instruction() when dirty ring reaches softlimit
and want to exit to userspace, however I'm not really sure whether
there could have any side effect.  I'd appreciate any comment of
above, or anything else.

Tests
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I wanted to continue work on the QEMU part, but after I noticed that
the interface might still prone to change, I posted this series first.
However to make sure it's at least working, I've provided unit tests
together with the series.  The unit tests should be able to test the
series in at least three major paths:

  (1) ./dirty_log_test -M dirty-ring

      This tests async ring operations: this should be the major work
      mode for the dirty ring interface, say, when the kernel is
      queuing more data, the userspace is collecting too.  Ring can
      hardly reaches full when working like this, because in most
      cases the collection could be fast.

  (2) ./dirty_log_test -M dirty-ring -c 1024

      This set the ring size to be very small so that ring soft-full
      always triggers (soft-full is a soft limit of the ring state,
      when the dirty ring reaches the soft limit it'll do a userspace
      exit and let the userspace to collect the data).

  (3) ./dirty_log_test -M dirty-ring-wait-queue

      This sololy test the extreme case where ring is full.  When the
      ring is completely full, the thread (no matter vcpu or not) will
      be put onto a per-vm waitqueue, and KVM_RESET_DIRTY_RINGS will
      wake the threads up (assuming until which the ring will not be
      full any more).

Thanks,

Cao, Lei (2):
  KVM: Add kvm/vcpu argument to mark_dirty_page_in_slot
  KVM: X86: Implement ring-based dirty memory tracking

Paolo Bonzini (1):
  KVM: Move running VCPU from ARM to common code

Peter Xu (12):
  KVM: Add build-time error check on kvm_run size
  KVM: Implement ring-based dirty memory tracking
  KVM: Make dirty ring exclusive to dirty bitmap log
  KVM: Introduce dirty ring wait queue
  KVM: selftests: Always clear dirty bitmap after iteration
  KVM: selftests: Sync uapi/linux/kvm.h to tools/
  KVM: selftests: Use a single binary for dirty/clear log test
  KVM: selftests: Introduce after_vcpu_run hook for dirty log test
  KVM: selftests: Add dirty ring buffer test
  KVM: selftests: Let dirty_log_test async for dirty ring test
  KVM: selftests: Add "-c" parameter to dirty log test
  KVM: selftests: Test dirty ring waitqueue

 Documentation/virt/kvm/api.txt                | 116 +++++
 arch/arm/include/asm/kvm_host.h               |   2 -
 arch/arm64/include/asm/kvm_host.h             |   2 -
 arch/x86/include/asm/kvm_host.h               |   5 +
 arch/x86/include/uapi/asm/kvm.h               |   1 +
 arch/x86/kvm/Makefile                         |   3 +-
 arch/x86/kvm/mmu/mmu.c                        |   6 +
 arch/x86/kvm/vmx/vmx.c                        |   7 +
 arch/x86/kvm/x86.c                            |  12 +
 include/linux/kvm_dirty_ring.h                |  67 +++
 include/linux/kvm_host.h                      |  37 ++
 include/linux/kvm_types.h                     |   1 +
 include/uapi/linux/kvm.h                      |  36 ++
 tools/include/uapi/linux/kvm.h                |  47 ++
 tools/testing/selftests/kvm/Makefile          |   2 -
 .../selftests/kvm/clear_dirty_log_test.c      |   2 -
 tools/testing/selftests/kvm/dirty_log_test.c  | 452 ++++++++++++++++--
 .../testing/selftests/kvm/include/kvm_util.h  |   6 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 103 ++++
 .../selftests/kvm/lib/kvm_util_internal.h     |   5 +
 virt/kvm/arm/arm.c                            |  29 --
 virt/kvm/arm/perf.c                           |   6 +-
 virt/kvm/arm/vgic/vgic-mmio.c                 |  15 +-
 virt/kvm/dirty_ring.c                         | 156 ++++++
 virt/kvm/kvm_main.c                           | 315 +++++++++++-
 25 files changed, 1329 insertions(+), 104 deletions(-)
 create mode 100644 include/linux/kvm_dirty_ring.h
 delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c
 create mode 100644 virt/kvm/dirty_ring.c

--=20
2.21.0


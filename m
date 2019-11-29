Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7547910DAFC
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfK2Vd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:33:28 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25329 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727230AbfK2Vd2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 16:33:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=peI3w5GhWEX1JieJHH29KyaSX4w2AsTjOin5SLB/5Gw=;
        b=MoG69TE2Ud0V4TI56GPIT9dsPqVt9S2bRpiQvQ4xygb2rkst4W312opa4np3I6YM5yig2V
        iIn9pv+6S0nIN3QyGf2+jdCBWtCaPyUzojOxbYO107sSSKg50TplB/R9P0Z28inlHzUHpE
        4cttmkfWef7s5aNZHxG1JnTymbUUmZ4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-h_JXXPeCPGCH0SG7vjmw8Q-1; Fri, 29 Nov 2019 16:33:25 -0500
Received: by mail-qv1-f71.google.com with SMTP id y9so7861674qvi.10
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:33:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cn7j7/8SJgeM/ER61fZ1AdZGSd2mYCJ7pUgcBKPF2KQ=;
        b=r8ViEKkICbI1Tj5Y9BRmBao5pxTq/teE0ppV5Wdjw3hb15W9xYYIKApPKxDsTiQKd1
         Gt6tfDIwMnxn56FOCaenQ8TlI+NkIroftaobcGEYQldv4LN4ZrPgflcgIC/imdFUslsn
         2sYo/geI2n3TEETUH+EFAY4fCBRMpWokyTSLmu+6IhoRFB7bg+3TbFos238bi8/ow+0U
         B3an/YcnOK+hrMkPq+ipa64A5lgkQ4kD+Rc0i01nE0yS/XzaRmbz0mmVsRgocqZYn22J
         T54KKstxe8rRi6AASID30mtc/5VlBcTKcRmBMCj5SuqNhdXGGaBdz9EDKh7Q2YpBApLY
         QiWA==
X-Gm-Message-State: APjAAAXtE8jqxNXuwrVhvO8jf9Y+pUdD64RmNPH7l275MZrtTmfCtumX
        NhFWUzFQkmM7E1SbJBdZYecwTKgl2T2XHgBgpK3+xrkyPl13rbyUXAA7mIEcvtrLTBvzQ/S9Pz5
        Ta47CuJI0OV+E
X-Received: by 2002:a05:620a:1127:: with SMTP id p7mr13986171qkk.287.1575063204805;
        Fri, 29 Nov 2019 13:33:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqyBO9lODIMQRDHVwBS9dO8Hq/Ou+bAcJbw+JnpSvy8a7ZA7c0L5zwPT/av4zppUYYFTuWWbhw==
X-Received: by 2002:a05:620a:1127:: with SMTP id p7mr13986137qkk.287.1575063204428;
        Fri, 29 Nov 2019 13:33:24 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id g11sm10584673qkm.82.2019.11.29.13.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:33:23 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 00/15] KVM: Dirty ring interface
Date:   Fri, 29 Nov 2019 16:33:07 -0500
Message-Id: <20191129213322.17386-1-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-MC-Unique: h_JXXPeCPGCH0SG7vjmw8Q-1
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


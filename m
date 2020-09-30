Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9957B27F468
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 23:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731034AbgI3Vt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 17:49:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51667 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730984AbgI3Vt5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 17:49:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601502595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ulKW+S9BEW8uFmibk0rcRoVyWzzEUBD0nc62HGhPA+o=;
        b=hX90Ip4BMNkZDjya38mp41wJu+zznj58EKjzj51Z9+AE62eIhLNUNJx5rxaQI+bXAq/vfK
        nv9ySpxJWO7TXotEK9ZpW047YEXVZo/B2ULSad+bqlFkzNjc8ZxAcC04zEZLR3OH40LOzr
        29FdB1omMsTf361NyL/IJblqCXl+XG4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-YVDWb-lfNCuANkrfYdjVww-1; Wed, 30 Sep 2020 17:49:51 -0400
X-MC-Unique: YVDWb-lfNCuANkrfYdjVww-1
Received: by mail-qt1-f200.google.com with SMTP id u6so2197254qte.8
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 14:49:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ulKW+S9BEW8uFmibk0rcRoVyWzzEUBD0nc62HGhPA+o=;
        b=kqhoODFmvbFWojlyq1W5OLvhul/xj8t8ERtF5I9M2I461F/Hsmj/FN2H/XOpmnUXC4
         Vk1/ey3zTgdjXYYDc226zwez38uL/PV8ECEw7KJASiFDVcFasVKKMNTAVMqeLNORGKvi
         T2NSs0m7bTXwteGkaM7Fp+eo8f6TbP3JpgCFFO261dZnCtxYgIbi7TnKeOMc4xmPzdLO
         iUaA+IJMlrUv8l3U1tD96u0MY+j9cHmFMoT2LZdJ204nA17i75Itb4e0xZDz+p4+0Wbn
         p30wOtvYbBgFdNv7MgSWskwjQbS7AuUQpazo7Gtrp3CTnosqIQ+NwLPaIiia9L5Cjsxp
         FI5A==
X-Gm-Message-State: AOAM531Hlb1UVkmcF5wiwiH6BsQt1VsiVWr0iUvNrYFhyHTISoE9Woy3
        9z8zySCMxPZVjnFYjYxabikXEwpXJgMQOdD1jAQT/vXDN4Yo6hsv5lOrwKpFPcfhAYcK+hKPn70
        lrOTLESDR1cZB
X-Received: by 2002:a0c:cd0d:: with SMTP id b13mr4741508qvm.53.1601502591013;
        Wed, 30 Sep 2020 14:49:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBXo+o8x2Q2f6w+6rbE35Wt/RIFojSAPK0I96xJJlLe70+VSfSEAdqdBN+HnIYHiBysGWlpA==
X-Received: by 2002:a0c:cd0d:: with SMTP id b13mr4741477qvm.53.1601502590619;
        Wed, 30 Sep 2020 14:49:50 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp130-09-184-147-14-204.dsl.bell.ca. [184.147.14.204])
        by smtp.gmail.com with ESMTPSA id j88sm3786165qte.96.2020.09.30.14.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 14:49:49 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v12 00/13] KVM: Dirty ring interface
Date:   Wed, 30 Sep 2020 17:49:35 -0400
Message-Id: <20200930214948.47225-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM branch:=0D
  https://github.com/xzpeter/linux/tree/kvm-dirty-ring=0D
=0D
QEMU branch for testing:=0D
  https://github.com/xzpeter/qemu/tree/kvm-dirty-ring=0D
=0D
v12:=0D
- add r-bs for Sean=0D
- rebase=0D
=0D
v11:=0D
- rebased to kvm/queue (seems the newest)=0D
- removed kvm_dirty_ring_waitqueue() tracepoint since not used=0D
- set memslot->as_id in kvm_delete_memslot() [Sean]=0D
- let __copy_to_user() always return -EFAULT [Sean]=0D
- rename 'r' in alloc_apic_access_page into 'hva' [Sean]=0D
=0D
v10:=0D
- remove unused identity_map_pfn in init_rmode_identity_map [syzbot]=0D
- add "static" to kvm_dirty_ring_full [syzbot]=0D
- kvm_page_in_dirty_ring() use "#if" macros for KVM_DIRTY_LOG_PAGE_OFFSET t=
o=0D
  quiesce syzbot [syzbot]=0D
- s/false/null/ in gfn_to_memslot_dirty_bitmap() [syzbot]=0D
=0D
v9:=0D
- patch 3: __x86_set_memory_region: squash another trivial change to return=
=0D
  (0xdeadull << 48) always for slot removal [Sean]=0D
- pick r-bs for Drew=0D
=0D
For previous versions, please refer to:=0D
=0D
V1: https://lore.kernel.org/kvm/20191129213505.18472-1-peterx@redhat.com=0D
V2: https://lore.kernel.org/kvm/20191221014938.58831-1-peterx@redhat.com=0D
V3: https://lore.kernel.org/kvm/20200109145729.32898-1-peterx@redhat.com=0D
V4: https://lore.kernel.org/kvm/20200205025105.367213-1-peterx@redhat.com=0D
V5: https://lore.kernel.org/kvm/20200304174947.69595-1-peterx@redhat.com=0D
V6: https://lore.kernel.org/kvm/20200309214424.330363-1-peterx@redhat.com=0D
V7: https://lore.kernel.org/kvm/20200318163720.93929-1-peterx@redhat.com=0D
V8: https://lore.kernel.org/kvm/20200331190000.659614-1-peterx@redhat.com=0D
V9: https://lore.kernel.org/kvm/20200523225659.1027044-1-peterx@redhat.com=
=0D
V10: https://lore.kernel.org/kvm/20200601115957.1581250-1-peterx@redhat.com=
/=0D
=0D
Overview=0D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D
=0D
This is a continued work from Lei Cao <lei.cao@stratus.com> and Paolo=0D
Bonzini on the KVM dirty ring interface.=0D
=0D
The new dirty ring interface is another way to collect dirty pages for=0D
the virtual machines. It is different from the existing dirty logging=0D
interface in a few ways, majorly:=0D
=0D
  - Data format: The dirty data was in a ring format rather than a=0D
    bitmap format, so dirty bits to sync for dirty logging does not=0D
    depend on the size of guest memory any more, but speed of=0D
    dirtying.  Also, the dirty ring is per-vcpu, while the dirty=0D
    bitmap is per-vm.=0D
=0D
  - Data copy: The sync of dirty pages does not need data copy any more,=0D
    but instead the ring is shared between the userspace and kernel by=0D
    page sharings (mmap() on vcpu fd)=0D
=0D
  - Interface: Instead of using the old KVM_GET_DIRTY_LOG,=0D
    KVM_CLEAR_DIRTY_LOG interfaces, the new ring uses the new=0D
    KVM_RESET_DIRTY_RINGS ioctl when we want to reset the collected=0D
    dirty pages to protected mode again (works like=0D
    KVM_CLEAR_DIRTY_LOG, but ring based).  To collecting dirty bits,=0D
    we only need to read the ring data, no ioctl is needed.=0D
=0D
Ring Layout=0D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D
=0D
KVM dirty ring is per-vcpu.  Each ring is an array of kvm_dirty_gfn=0D
defined as:=0D
=0D
struct kvm_dirty_gfn {=0D
        __u32 flags;=0D
        __u32 slot; /* as_id | slot_id */=0D
        __u64 offset;=0D
};=0D
=0D
Each GFN is a state machine itself.  The state is embeded in the flags=0D
field, as defined in the uapi header:=0D
=0D
/*=0D
 * KVM dirty GFN flags, defined as:=0D
 *=0D
 * |---------------+---------------+--------------|=0D
 * | bit 1 (reset) | bit 0 (dirty) | Status       |=0D
 * |---------------+---------------+--------------|=0D
 * |             0 |             0 | Invalid GFN  |=0D
 * |             0 |             1 | Dirty GFN    |=0D
 * |             1 |             X | GFN to reset |=0D
 * |---------------+---------------+--------------|=0D
 *=0D
 * Lifecycle of a dirty GFN goes like:=0D
 *=0D
 *      dirtied         collected        reset=0D
 * 00 -----------> 01 -------------> 1X -------+=0D
 *  ^                                          |=0D
 *  |                                          |=0D
 *  +------------------------------------------+=0D
 *=0D
 * The userspace program is only responsible for the 01->1X state=0D
 * conversion (to collect dirty bits).  Also, it must not skip any=0D
 * dirty bits so that dirty bits are always collected in sequence.=0D
 */=0D
=0D
Testing=0D
=3D=3D=3D=3D=3D=3D=3D=0D
=0D
This series provided both the implementation of the KVM dirty ring and=0D
the test case.  Also I've implemented the QEMU counterpart that can=0D
run with the new KVM, link can be found at the top of the cover=0D
letter.  However that's still a very initial version which is prone to=0D
change and future optimizations.=0D
=0D
I did some measurement with the new method with 24G guest running some=0D
dirty workload, I don't see any speedup so far, even in some heavy=0D
dirty load it'll be slower (e.g., when 800MB/s random dirty rate, kvm=0D
dirty ring takes average of ~73s to complete migration while dirty=0D
logging only needs average of ~55s).  However that's understandable=0D
because 24G guest means only 1M dirty bitmap, that's still a suitable=0D
case for dirty logging.  Meanwhile heavier workload means worst case=0D
for dirty ring.=0D
=0D
More tests are welcomed if there's bigger host/guest, especially on=0D
COLO-like workload.=0D
=0D
Please review, thanks.=0D
=0D
Peter Xu (13):=0D
  KVM: Cache as_id in kvm_memory_slot=0D
  KVM: X86: Don't track dirty for KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]=0D
  KVM: Pass in kvm pointer into mark_page_dirty_in_slot()=0D
  KVM: X86: Implement ring-based dirty memory tracking=0D
  KVM: Make dirty ring exclusive to dirty bitmap log=0D
  KVM: Don't allocate dirty bitmap if dirty ring is enabled=0D
  KVM: selftests: Always clear dirty bitmap after iteration=0D
  KVM: selftests: Sync uapi/linux/kvm.h to tools/=0D
  KVM: selftests: Use a single binary for dirty/clear log test=0D
  KVM: selftests: Introduce after_vcpu_run hook for dirty log test=0D
  KVM: selftests: Add dirty ring buffer test=0D
  KVM: selftests: Let dirty_log_test async for dirty ring test=0D
  KVM: selftests: Add "-c" parameter to dirty log test=0D
=0D
 Documentation/virt/kvm/api.rst                | 123 +++++=0D
 arch/x86/include/asm/kvm_host.h               |   6 +-=0D
 arch/x86/include/uapi/asm/kvm.h               |   1 +=0D
 arch/x86/kvm/Makefile                         |   3 +-=0D
 arch/x86/kvm/mmu/mmu.c                        |  10 +-=0D
 arch/x86/kvm/svm/avic.c                       |   9 +-=0D
 arch/x86/kvm/vmx/vmx.c                        |  96 ++--=0D
 arch/x86/kvm/x86.c                            |  46 +-=0D
 include/linux/kvm_dirty_ring.h                | 103 ++++=0D
 include/linux/kvm_host.h                      |  19 +=0D
 include/trace/events/kvm.h                    |  63 +++=0D
 include/uapi/linux/kvm.h                      |  53 ++=0D
 tools/include/uapi/linux/kvm.h                |  53 ++=0D
 tools/testing/selftests/kvm/Makefile          |   2 -=0D
 .../selftests/kvm/clear_dirty_log_test.c      |   6 -=0D
 tools/testing/selftests/kvm/dirty_log_test.c  | 505 ++++++++++++++++--=0D
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +=0D
 tools/testing/selftests/kvm/lib/kvm_util.c    |  72 ++-=0D
 .../selftests/kvm/lib/kvm_util_internal.h     |   4 +=0D
 virt/kvm/dirty_ring.c                         | 197 +++++++=0D
 virt/kvm/kvm_main.c                           | 168 +++++-=0D
 21 files changed, 1408 insertions(+), 135 deletions(-)=0D
 create mode 100644 include/linux/kvm_dirty_ring.h=0D
 delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c=0D
 create mode 100644 virt/kvm/dirty_ring.c=0D
=0D
-- =0D
2.26.2=0D
=0D


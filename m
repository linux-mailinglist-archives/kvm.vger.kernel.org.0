Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805D6297715
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 20:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754837AbgJWSeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 14:34:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58508 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754825AbgJWSeG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 14:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603478044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pL5izsDjQRsypIzAphsn/fSHZTMIi/wrQPFpeQ075jc=;
        b=YCeLU8sQRI7j/R3eR4Zsxj6WQHUPBpTEobeZdbajvxvYWSlUYG+Q7ABFK7ypET7tFY5Che
        Kz6Pl0RhWt2mfrA5J8mIq5HKA6w40UclnAQIXZ+bQYPugbYQlC/IjsNo7PXO4BTz2lw563
        soGmOs47uw+lNvoWj1773uE2lRfGYF4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-bpdKfgv9MIu679dyVeMNFQ-1; Fri, 23 Oct 2020 14:34:01 -0400
X-MC-Unique: bpdKfgv9MIu679dyVeMNFQ-1
Received: by mail-qt1-f200.google.com with SMTP id a8so1674107qtx.13
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 11:34:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pL5izsDjQRsypIzAphsn/fSHZTMIi/wrQPFpeQ075jc=;
        b=szjaEihftyd9UuM/Qz/ZauCkGtEMJgVrW6wY3/FWxdZBlw1ohxwv45VUMEjzmhfdeY
         y3tv62G+si63GHbSDLByXKjm1ZZl/kaB5KfTHV7/ALFappxc0jlG6IoABECfPwyqV6v1
         bn/KkW9HZJWfKU9OvtDd41HamLp+PuRSUHJwWL3udEdoqDY3xyhSxOxjzLky6d7LL9XZ
         t/8n8k7SfKGpt667fa6K7M2nMZm+DlCzeGxHBGYsCO7qfbEP4CDVCeajmShpvgjkMdT3
         jFJpT+ZclRzrIr4MMCRJz0cO7T50wbSxOHx3Gnr/FgOanHpfbEy+snRyJHbdg1dYoBB9
         T/rg==
X-Gm-Message-State: AOAM532IQDi+hmbCmcvKWz9VPtMgRCdD8W1gPixSoAjzYPWcjEymXSK4
        gJrMs2PKhh/G6XY/i/Fty6KVnpvzm7REiO45xGP+D1IyPulWn5Uo1hj90vMCJu5ma7+HlzI1Loz
        YgiWwEANad9Os
X-Received: by 2002:a05:620a:12a6:: with SMTP id x6mr3846076qki.189.1603478040897;
        Fri, 23 Oct 2020 11:34:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCQX1jtoxh1ViMa4LFhKfs/4Hk6xAW6w7MMX1Jb8GfVLG+w/bEYVQx/I2vqVV8zeS85EEhZw==
X-Received: by 2002:a05:620a:12a6:: with SMTP id x6mr3846044qki.189.1603478040477;
        Fri, 23 Oct 2020 11:34:00 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id u11sm1490407qtk.61.2020.10.23.11.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 11:33:59 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Andrew Jones <drjones@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v15 00/14] KVM: Dirty ring interface
Date:   Fri, 23 Oct 2020 14:33:44 -0400
Message-Id: <20201023183358.50607-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo:=0D
=0D
I'm rebasing again to the next merge window branch of kvm, assuming it's=0D
kvm-5.10-1/upstream tag.  I don't know whether you'd like to merge it for t=
his=0D
merge window.  Just in case you still would like to, so you'll have somethi=
ng=0D
to pick up very easily based on the new tdp mmu changes.=0D
=0D
I feel a bit sorry for disturbing reviewers on recent frequent repostings.=
=0D
It's just a way to try move this forward a bit since I still think it's a q=
uite=0D
useful thing to have upstream for not yet another logging interface, but al=
so a=0D
chance to improve auto-converge and maybe it could be useful to solve some =
huge=0D
vm issues.  Anyway, I guess this is the last attempt if I won't get more re=
view=0D
comments out of this series, and I'll hold until so.=0D
=0D
In all cases, please consider to squash patch1/2 into corresponding patches=
 in=0D
kvm-next because the numbers are wrong in current tree.=0D
=0D
Thanks.=0D
=0D
----------=0D
=0D
KVM branch:=0D
  https://github.com/xzpeter/linux/tree/kvm-dirty-ring=0D
=0D
QEMU branch for testing:=0D
  https://github.com/xzpeter/qemu/tree/kvm-dirty-ring=0D
=0D
v15:=0D
- rebase to kvm tree tag kvm-5.10-1/for-upstream=0D
=0D
v14:=0D
- fix a testcase race reported by kernel test robot.  More can be found at:=
=0D
  https://lore.kernel.org/kvm/20201007204525.GF6026@xz-x1/=0D
=0D
v13:=0D
- rebase to kvm/queue rather than 5.9-rc7.  I think, kvm/queue is broken.  =
I=0D
  can only test the dirty ring after I revert 3eb900173c71 ("KVM: x86: VMX:=
=0D
  Prevent MSR passthrough when MSR access is denied", 2020-09-28), otherwis=
e=0D
  the guest will hang on vcpu0 looping forever during boot Linux.=0D
- added another trivial patch "KVM: Documentation: Update entry for=0D
  KVM_X86_SET_MSR_FILTER".  It should be squashed into 1a155254ff93 ("KVM: =
x86:=0D
  Introduce MSR filtering", 2020-09-28) directly.=0D
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
Peter Xu (14):=0D
  KVM: Documentation: Update entry for KVM_X86_SET_MSR_FILTER=0D
  KVM: Documentation: Update entry for KVM_CAP_ENFORCE_PV_CPUID=0D
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
 Documentation/virt/kvm/api.rst                | 129 ++++-=0D
 arch/x86/include/asm/kvm_host.h               |   6 +-=0D
 arch/x86/include/uapi/asm/kvm.h               |   1 +=0D
 arch/x86/kvm/Makefile                         |   3 +-=0D
 arch/x86/kvm/mmu/mmu.c                        |  10 +-=0D
 arch/x86/kvm/mmu/tdp_mmu.c                    |   2 +-=0D
 arch/x86/kvm/svm/avic.c                       |   9 +-=0D
 arch/x86/kvm/vmx/vmx.c                        |  96 ++--=0D
 arch/x86/kvm/x86.c                            |  46 +-=0D
 include/linux/kvm_dirty_ring.h                | 103 ++++=0D
 include/linux/kvm_host.h                      |  21 +-=0D
 include/trace/events/kvm.h                    |  63 +++=0D
 include/uapi/linux/kvm.h                      |  53 ++=0D
 tools/include/uapi/linux/kvm.h                |  78 ++-=0D
 tools/testing/selftests/kvm/Makefile          |   2 -=0D
 .../selftests/kvm/clear_dirty_log_test.c      |   6 -=0D
 tools/testing/selftests/kvm/dirty_log_test.c  | 516 ++++++++++++++++--=0D
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +=0D
 tools/testing/selftests/kvm/lib/kvm_util.c    |  72 ++-=0D
 .../selftests/kvm/lib/kvm_util_internal.h     |   4 +=0D
 virt/kvm/dirty_ring.c                         | 197 +++++++=0D
 virt/kvm/kvm_main.c                           | 158 +++++-=0D
 22 files changed, 1438 insertions(+), 141 deletions(-)=0D
 create mode 100644 include/linux/kvm_dirty_ring.h=0D
 delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c=0D
 create mode 100644 virt/kvm/dirty_ring.c=0D
=0D
-- =0D
2.26.2=0D
=0D


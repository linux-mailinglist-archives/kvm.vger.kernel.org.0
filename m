Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95C8D11AC4B
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 14:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbfLKNl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 08:41:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21050 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729238AbfLKNl4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 08:41:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576071714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z2GJ4J3PhJOPcXu4B3ubBrIUuGFzFaoIzu/7K9ESRCM=;
        b=VXnTjr2fXr3RbPCODbZxoNb/nF/MQcp603D0Rbx4TWeALJ5i38hOtiIO13t3w4APCFvFmV
        SgBEMNeKEce4UpXUmYfS2tD+HD1Jw4tAiC4gYTM6E8p5MPF53pBxLPHL/ZEMN+OvRfvuYj
        4VxuRILh9IYnFb8aRwOZh6Kc0Zd+tqE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-QtAj0rj5N5OaVotD0GmW8g-1; Wed, 11 Dec 2019 08:41:50 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37B658E5454;
        Wed, 11 Dec 2019 13:41:49 +0000 (UTC)
Received: from ptitpuce (unknown [10.36.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D4ECC60BF1;
        Wed, 11 Dec 2019 13:41:42 +0000 (UTC)
References: <20191129213505.18472-1-peterx@redhat.com>
User-agent: mu4e 1.3.5; emacs 26.2
From:   Christophe de Dinechin <dinechin@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 00/15] KVM: Dirty ring interface
In-reply-to: <20191129213505.18472-1-peterx@redhat.com>
Message-ID: <m1r21bgest.fsf@redhat.com>
Date:   Wed, 11 Dec 2019 14:41:38 +0100
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: QtAj0rj5N5OaVotD0GmW8g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Peter Xu writes:

> Branch is here: https://github.com/xzpeter/linux/tree/kvm-dirty-ring
>
> Overview
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> This is a continued work from Lei Cao <lei.cao@stratus.com> and Paolo
> on the KVM dirty ring interface.  To make it simple, I'll still start
> with version 1 as RFC.
>
> The new dirty ring interface is another way to collect dirty pages for
> the virtual machine, but it is different from the existing dirty
> logging interface in a few ways, majorly:
>
>   - Data format: The dirty data was in a ring format rather than a
>     bitmap format, so the size of data to sync for dirty logging does
>     not depend on the size of guest memory any more, but speed of
>     dirtying.  Also, the dirty ring is per-vcpu (currently plus
>     another per-vm ring, so total ring number is N+1), while the dirty
>     bitmap is per-vm.

I like Sean's suggestion to fetch rings when dirtying. That could reduce
the number of dirty rings to examine.

Also, as is, this means that the same gfn may be present in multiple
rings, right?

>
>   - Data copy: The sync of dirty pages does not need data copy any more,
>     but instead the ring is shared between the userspace and kernel by
>     page sharings (mmap() on either the vm fd or vcpu fd)
>
>   - Interface: Instead of using the old KVM_GET_DIRTY_LOG,
>     KVM_CLEAR_DIRTY_LOG interfaces, the new ring uses a new interface
>     called KVM_RESET_DIRTY_RINGS when we want to reset the collected
>     dirty pages to protected mode again (works like
>     KVM_CLEAR_DIRTY_LOG, but ring based)
>
> And more.
>
> I would appreciate if the reviewers can start with patch "KVM:
> Implement ring-based dirty memory tracking", especially the document
> update part for the big picture.  Then I'll avoid copying into most of
> them into cover letter again.
>
> I marked this series as RFC because I'm at least uncertain on this
> change of vcpu_enter_guest():
>
>         if (kvm_check_request(KVM_REQ_DIRTY_RING_FULL, vcpu)) {
>                 vcpu->run->exit_reason =3D KVM_EXIT_DIRTY_RING_FULL;
>                 /*
>                         * If this is requested, it means that we've
>                         * marked the dirty bit in the dirty ring BUT
>                         * we've not written the date.  Do it now.

not written the "data" ?

>                         */
>                 r =3D kvm_emulate_instruction(vcpu, 0);
>                 r =3D r >=3D 0 ? 0 : r;
>                 goto out;
>         }
>
> I did a kvm_emulate_instruction() when dirty ring reaches softlimit
> and want to exit to userspace, however I'm not really sure whether
> there could have any side effect.  I'd appreciate any comment of
> above, or anything else.
>
> Tests
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> I wanted to continue work on the QEMU part, but after I noticed that
> the interface might still prone to change, I posted this series first.
> However to make sure it's at least working, I've provided unit tests
> together with the series.  The unit tests should be able to test the
> series in at least three major paths:
>
>   (1) ./dirty_log_test -M dirty-ring
>
>       This tests async ring operations: this should be the major work
>       mode for the dirty ring interface, say, when the kernel is
>       queuing more data, the userspace is collecting too.  Ring can
>       hardly reaches full when working like this, because in most
>       cases the collection could be fast.
>
>   (2) ./dirty_log_test -M dirty-ring -c 1024
>
>       This set the ring size to be very small so that ring soft-full
>       always triggers (soft-full is a soft limit of the ring state,
>       when the dirty ring reaches the soft limit it'll do a userspace
>       exit and let the userspace to collect the data).
>
>   (3) ./dirty_log_test -M dirty-ring-wait-queue
>
>       This sololy test the extreme case where ring is full.  When the
>       ring is completely full, the thread (no matter vcpu or not) will
>       be put onto a per-vm waitqueue, and KVM_RESET_DIRTY_RINGS will
>       wake the threads up (assuming until which the ring will not be
>       full any more).

Am I correct assuming that guest memory can be dirtied by DMA operations?
Should

Not being that familiar with the current implementation of dirty page
tracking, I wonder who marks the pages dirty in that case, and when?
If the VM ring is used for I/O threads, isn't it possible that a large
DMA could dirty a sufficiently large number of GFNs to overflow the
associated ring? Does this case need a separate way to queue the
dirtying I/O thread?

>
> Thanks,
>
> Cao, Lei (2):
>   KVM: Add kvm/vcpu argument to mark_dirty_page_in_slot
>   KVM: X86: Implement ring-based dirty memory tracking
>
> Paolo Bonzini (1):
>   KVM: Move running VCPU from ARM to common code
>
> Peter Xu (12):
>   KVM: Add build-time error check on kvm_run size
>   KVM: Implement ring-based dirty memory tracking
>   KVM: Make dirty ring exclusive to dirty bitmap log
>   KVM: Introduce dirty ring wait queue
>   KVM: selftests: Always clear dirty bitmap after iteration
>   KVM: selftests: Sync uapi/linux/kvm.h to tools/
>   KVM: selftests: Use a single binary for dirty/clear log test
>   KVM: selftests: Introduce after_vcpu_run hook for dirty log test
>   KVM: selftests: Add dirty ring buffer test
>   KVM: selftests: Let dirty_log_test async for dirty ring test
>   KVM: selftests: Add "-c" parameter to dirty log test
>   KVM: selftests: Test dirty ring waitqueue
>
>  Documentation/virt/kvm/api.txt                | 116 +++++
>  arch/arm/include/asm/kvm_host.h               |   2 -
>  arch/arm64/include/asm/kvm_host.h             |   2 -
>  arch/x86/include/asm/kvm_host.h               |   5 +
>  arch/x86/include/uapi/asm/kvm.h               |   1 +
>  arch/x86/kvm/Makefile                         |   3 +-
>  arch/x86/kvm/mmu/mmu.c                        |   6 +
>  arch/x86/kvm/vmx/vmx.c                        |   7 +
>  arch/x86/kvm/x86.c                            |  12 +
>  include/linux/kvm_dirty_ring.h                |  67 +++
>  include/linux/kvm_host.h                      |  37 ++
>  include/linux/kvm_types.h                     |   1 +
>  include/uapi/linux/kvm.h                      |  36 ++
>  tools/include/uapi/linux/kvm.h                |  47 ++
>  tools/testing/selftests/kvm/Makefile          |   2 -
>  .../selftests/kvm/clear_dirty_log_test.c      |   2 -
>  tools/testing/selftests/kvm/dirty_log_test.c  | 452 ++++++++++++++++--
>  .../testing/selftests/kvm/include/kvm_util.h  |   6 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 103 ++++
>  .../selftests/kvm/lib/kvm_util_internal.h     |   5 +
>  virt/kvm/arm/arm.c                            |  29 --
>  virt/kvm/arm/perf.c                           |   6 +-
>  virt/kvm/arm/vgic/vgic-mmio.c                 |  15 +-
>  virt/kvm/dirty_ring.c                         | 156 ++++++
>  virt/kvm/kvm_main.c                           | 315 +++++++++++-
>  25 files changed, 1329 insertions(+), 104 deletions(-)
>  create mode 100644 include/linux/kvm_dirty_ring.h
>  delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c
>  create mode 100644 virt/kvm/dirty_ring.c


--
Cheers,
Christophe de Dinechin (IRC c3d)


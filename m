Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788533062DA
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 19:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344077AbhA0R7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 12:59:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344094AbhA0R7I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 12:59:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611770261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PiBd6yjo3qbKRU8POFjExLSn96nLsQdRPV9/WzOWKC8=;
        b=i5a2H8mYip9YcsWadjcPQi4JkOOeY+alDVmCxaPMGFm/bdYAojacrUcBwqs6zh8q3fzQow
        70FQkw0hg6MOmGtVt2mNCrTwDxREJ+CtUBsd6boPWDrCiA3vN4Ld/s/EJJdCSBnMOHMHY/
        D83fyY2v8NtS/ZzXik2GHJRHUl/5HvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-WXuDuhHtPem9jt0yQOnMOw-1; Wed, 27 Jan 2021 12:57:38 -0500
X-MC-Unique: WXuDuhHtPem9jt0yQOnMOw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C47959;
        Wed, 27 Jan 2021 17:57:37 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CC3660854;
        Wed, 27 Jan 2021 17:57:32 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [PATCH 0/5] KVM: Make the maximum number of user memslots configurable and raise the default
Date:   Wed, 27 Jan 2021 18:57:26 +0100
Message-Id: <20210127175731.2020089-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a successor of previously sent "[PATCH RFC 0/4] KVM: x86:
Drastically raise KVM_USER_MEM_SLOTS limit".

Changes since RFC:
- Re-wrote everything [Sean]. The maximum number of slots is now
a per-VM thing controlled by an ioctl.

Original description:

Current KVM_USER_MEM_SLOTS limit on x86 (509) can be a limiting factor
for some configurations. In particular, when QEMU tries to start a Windows
guest with Hyper-V SynIC enabled and e.g. 256 vCPUs the limit is hit as
SynIC requires two pages per vCPU and the guest is free to pick any GFN for
each of them, this fragments memslots as QEMU wants to have a separate
memslot for each of these pages (which are supposed to act as 'overlay'
pages).

Memory slots are allocated dynamically in KVM when added so the only real
limitation is 'id_to_index' array which is 'short'. We don't seem to have
any other KVM_MEM_SLOTS_NUM/KVM_USER_MEM_SLOTS-sized statically defined
structures.

We could've just raised the limit to e.g. '1021' (we have 3 private
memslots on x86) and this should be enough for now as KVM_MAX_VCPUS is
'288' but AFAIK there are plans to raise this limit as well. Raise the
default value to 32768 - KVM_PRIVATE_MEM_SLOTS and introduce a new ioctl
to set the limit per-VM.

Vitaly Kuznetsov (5):
  KVM: Make the maximum number of user memslots a per-VM thing
  KVM: Raise the maximum number of user memslots
  KVM: Make the maximum number of user memslots configurable
  selftests: kvm: Test the newly introduced KVM_CAP_MEMSLOTS_LIMIT
  selftests: kvm: Raise the default timeout to 120 seconds

 Documentation/virt/kvm/api.rst                | 16 +++++++
 arch/arm64/include/asm/kvm_host.h             |  1 -
 arch/mips/include/asm/kvm_host.h              |  1 -
 arch/powerpc/include/asm/kvm_host.h           |  1 -
 arch/powerpc/kvm/book3s_hv.c                  |  2 +-
 arch/s390/include/asm/kvm_host.h              |  1 -
 arch/s390/kvm/kvm-s390.c                      |  2 +-
 arch/x86/include/asm/kvm_host.h               |  2 -
 include/linux/kvm_host.h                      |  6 +--
 include/uapi/linux/kvm.h                      |  1 +
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 30 ++++++++++++-
 .../selftests/kvm/set_memory_region_test.c    | 43 ++++++++++++++++---
 tools/testing/selftests/kvm/settings          |  1 +
 virt/kvm/dirty_ring.c                         |  2 +-
 virt/kvm/kvm_main.c                           | 42 +++++++++++++++---
 16 files changed, 128 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/settings

-- 
2.29.2


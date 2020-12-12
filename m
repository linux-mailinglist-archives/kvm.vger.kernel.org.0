Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB0E2D8776
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 17:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439283AbgLLPzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Dec 2020 10:55:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21518 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbgLLPzM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 12 Dec 2020 10:55:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607788426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=49p9jAWEo46JDV7PkNFs54HnwrvxIQVr2zd4nKr9GNo=;
        b=JHDxovB5UOYiXMOFlwoZHMcm9cz1z7V25w0BRaVi7Rx9ZdhaKGSQlNm9ccMWN5grnV12oM
        RAWEla/BSERfIp0mmgl0vOIL2iXxhixaUAh7OTQkX/VX9z6ReXSvMAnfLoDr5Qp97KXTv2
        zaRfq+Tk8NxHtjLesWzgCLHcgRMEdWg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-HONcu8xoOe-mZTnguP9Gcg-1; Sat, 12 Dec 2020 10:53:44 -0500
X-MC-Unique: HONcu8xoOe-mZTnguP9Gcg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B3FE180A095;
        Sat, 12 Dec 2020 15:53:43 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACECC63BA7;
        Sat, 12 Dec 2020 15:53:42 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Final batch of KVM changes for Linux 5.10
Date:   Sat, 12 Dec 2020 10:53:42 -0500
Message-Id: <20201212155342.812596-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 9a2a0d3ca163fc645991804b8b032f7d59326bb5:

  kvm: x86/mmu: Fix get_mmio_spte() on CPUs supporting 5-level PT (2020-11-27 11:14:27 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 111d0bda8eeb4b54e0c63897b071effbf9fd9251:

  tools/kvm_stat: Exempt time-based counters (2020-12-11 19:18:51 -0500)

----------------------------------------------------------------
Bugfixes for ARM, x86 and tools.

----------------------------------------------------------------
Jacob Xu (1):
      kvm: svm: de-allocate svm_cpu_data for all cpus in svm_cpu_uninit()

Maciej S. Szmigiero (2):
      selftests: kvm/set_memory_region_test: Fix race in move region test
      KVM: mmu: Fix SPTE encoding of MMIO generation upper half

Paolo Bonzini (1):
      Merge tag 'kvmarm-fixes-5.10-5' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD

Rick Edgecombe (1):
      kvm: x86/mmu: Use cpuid to determine max gfn

Stefan Raspl (1):
      tools/kvm_stat: Exempt time-based counters

Yanan Wang (3):
      KVM: arm64: Fix memory leak on stage2 update of a valid PTE
      KVM: arm64: Fix handling of merging tables into a block entry
      KVM: arm64: Add usage of stage 2 fault lookup level in user_mem_abort()

 Documentation/virt/kvm/mmu.rst                     |  2 +-
 arch/arm64/include/asm/esr.h                       |  1 +
 arch/arm64/include/asm/kvm_emulate.h               |  5 +++++
 arch/arm64/kvm/hyp/pgtable.c                       | 17 ++++++++++++++-
 arch/arm64/kvm/mmu.c                               | 11 ++++++++--
 arch/x86/kvm/mmu/spte.c                            |  4 ++--
 arch/x86/kvm/mmu/spte.h                            | 25 ++++++++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.c                         |  4 ++--
 arch/x86/kvm/svm/svm.c                             |  4 ++--
 tools/kvm/kvm_stat/kvm_stat                        |  6 +++++-
 .../testing/selftests/kvm/set_memory_region_test.c | 17 +++++++++++----
 11 files changed, 74 insertions(+), 22 deletions(-)


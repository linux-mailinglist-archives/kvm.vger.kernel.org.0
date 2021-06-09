Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADC73A1B90
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 19:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhFIRPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 13:15:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230152AbhFIRPL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 13:15:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623258796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0PU3D9xng4HWsSgSCmW5Y5xsfidNOi9bqS36Xaxp+Ao=;
        b=hoza770gbFwRrFPOSkK7mfxhoEBc54hlf/cAommOqNqxhKDVyPUqcotvRzi/RY0hKHjjaw
        QHyZbrCLkR6laL/JmO6EvQtgQUV+er5G+qGsHEpD8kabJW770Ayyw3gxNDsJwIVl7dF8Xp
        H1pe4hZ4JGcurhiN46PIsX7OixBxU5s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-RhFjz5RlNOGogXcS6nSMMQ-1; Wed, 09 Jun 2021 13:13:15 -0400
X-MC-Unique: RhFjz5RlNOGogXcS6nSMMQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F178B10C1ADC;
        Wed,  9 Jun 2021 17:13:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A16D15D9C6;
        Wed,  9 Jun 2021 17:13:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL v2] KVM fixes for 5.13-rc6
Date:   Wed,  9 Jun 2021 13:13:13 -0400
Message-Id: <20210609171313.150207-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 000ac42953395a4f0a63d5db640c5e4c88a548c5:

  selftests: kvm: fix overlapping addresses in memslot_perf_test (2021-05-29 06:28:06 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 4422829e8053068e0225e4d0ef42dc41ea7c9ef5:

  kvm: fix previous commit for 32-bit builds (2021-06-09 01:49:13 -0400)

32-bit builds had a warning with v1 of the pull request.  I have added a
patch that fixes it.

----------------------------------------------------------------
Bugfixes, including a TLB flush fix that affects processors
without nested page tables.

----------------------------------------------------------------
Ashish Kalra (1):
      KVM: SVM: Fix SEV SEND_START session length & SEND_UPDATE_DATA query length after commit 238eca821cee

Christian Borntraeger (1):
      KVM: selftests: introduce P47V64 for s390x

Lai Jiangshan (3):
      KVM: X86: MMU: Use the correct inherited permissions to get shadow page
      KVM: x86: Ensure PV TLB flush tracepoint reflects KVM behavior
      KVM: x86: Unload MMU on guest TLB flush if TDP disabled to force MMU sync

Paolo Bonzini (2):
      kvm: avoid speculation-based attacks from out-of-range memslot accesses
      kvm: fix previous commit for 32-bit builds

Sean Christopherson (1):
      KVM: x86: Ensure liveliness of nested VM-Enter fail tracepoint message

Wanpeng Li (1):
      KVM: LAPIC: Write 0 to TMICT should also cancel vmx-preemption timer

Zhenzhong Duan (1):
      selftests: kvm: Add support for customized slot0 memory size

 Documentation/virt/kvm/mmu.rst                    |  4 +-
 arch/x86/kvm/lapic.c                              | 17 +++++---
 arch/x86/kvm/mmu/paging_tmpl.h                    | 14 +++---
 arch/x86/kvm/svm/sev.c                            |  6 +--
 arch/x86/kvm/trace.h                              |  6 +--
 arch/x86/kvm/x86.c                                | 19 ++++++++-
 include/linux/kvm_host.h                          | 10 ++++-
 tools/testing/selftests/kvm/include/kvm_util.h    | 10 +++--
 tools/testing/selftests/kvm/kvm_page_table_test.c |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c        | 52 +++++++++++++++++++----
 tools/testing/selftests/kvm/lib/perf_test_util.c  |  2 +-
 tools/testing/selftests/kvm/memslot_perf_test.c   |  2 +-
 12 files changed, 105 insertions(+), 39 deletions(-)


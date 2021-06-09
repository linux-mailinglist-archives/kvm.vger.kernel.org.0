Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167C43A0820
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 02:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhFIAJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 20:09:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232086AbhFIAJk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 20:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623197266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=O14j7dxClgRbKQAjhRALjymjpBp3yVkxQg15WOtC9xo=;
        b=S9WrhAAhqhzROUAkND1auM+FwasMiTiz4wPbMGZYXCnzt6/Ru3qkj8vfnfzl/vhp7ZnuFJ
        TtfrCcZ2rkgp+bTRo/0krTQz1qxtgACEx9cGqE8Q3bu4qAKWm22Q0YRSh6MJNCiaT1QJgA
        8JXQbsyYpdz3MPK6zDYGZY6CFV4jV6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-Cp6fLCX_NKqF_r3iEqSAWA-1; Tue, 08 Jun 2021 20:07:44 -0400
X-MC-Unique: Cp6fLCX_NKqF_r3iEqSAWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCF73107ACCD;
        Wed,  9 Jun 2021 00:07:43 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D5D160CCC;
        Wed,  9 Jun 2021 00:07:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 5.13-rc6
Date:   Tue,  8 Jun 2021 20:07:43 -0400
Message-Id: <20210609000743.126676-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 000ac42953395a4f0a63d5db640c5e4c88a548c5:

  selftests: kvm: fix overlapping addresses in memslot_perf_test (2021-05-29 06:28:06 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to da27a83fd6cc7780fea190e1f5c19e87019da65c:

  kvm: avoid speculation-based attacks from out-of-range memslot accesses (2021-06-08 17:12:05 -0400)

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

Paolo Bonzini (1):
      kvm: avoid speculation-based attacks from out-of-range memslot accesses

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


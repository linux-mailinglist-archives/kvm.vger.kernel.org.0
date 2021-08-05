Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D753E0F6B
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 09:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236191AbhHEHkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 03:40:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230061AbhHEHkP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 03:40:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628149201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LKJJsIRb7WeylWDesNbJ0ZJZIxGY5exTeGT1+Dg+bq0=;
        b=Hi0HpIOy9PgcH33oRDaD5TW62E+INkEATnAL1CuhpgmaXmfuTEyWWpAipoJKvV+66ivHMn
        vaU9GeOAGQbEDM7zPgGbTvIYhrej1JKa6aOcvw6ew+k1gwy9UpkZS+oLqROcqWd2632R3f
        dxQ+KsIEG3xwNxBe6qsQArdU6lAtlU0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-oNTNMF-JOhOX13cmMIyyCQ-1; Thu, 05 Aug 2021 03:40:00 -0400
X-MC-Unique: oNTNMF-JOhOX13cmMIyyCQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26B58192FDAD;
        Thu,  5 Aug 2021 07:39:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC4C569FAE;
        Thu,  5 Aug 2021 07:39:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.14-rc5
Date:   Thu,  5 Aug 2021 03:39:58 -0400
Message-Id: <20210805073958.2684067-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 8750f9bbda115f3f79bfe43be85551ee5e12b6ff:

  KVM: add missing compat KVM_CLEAR_DIRTY_LOG (2021-07-27 16:59:01 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to d5aaad6f83420efb8357ac8e11c868708b22d0a9:

  KVM: x86/mmu: Fix per-cpu counter corruption on 32-bit builds (2021-08-05 03:33:56 -0400)

----------------------------------------------------------------
Mostly bugfixes; plus, support for XMM arguments to Hyper-V hypercalls
now obeys KVM_CAP_HYPERV_ENFORCE_CPUID.  Both the XMM arguments feature
and KVM_CAP_HYPERV_ENFORCE_CPUID are new in 5.14, and each did not know
of the other.

----------------------------------------------------------------
Maxim Levitsky (1):
      KVM: selftests: fix hyperv_clock test

Mingwei Zhang (1):
      KVM: SVM: improve the code readability for ASID management

Paolo Bonzini (2):
      KVM: x86: accept userspace interrupt only if no event is injected
      KVM: Do not leak memory for duplicate debugfs directories

Sean Christopherson (2):
      KVM: SVM: Fix off-by-one indexing when nullifying last used SEV VMCB
      KVM: x86/mmu: Fix per-cpu counter corruption on 32-bit builds

Vitaly Kuznetsov (4):
      KVM: x86: hyper-v: Check access to hypercall before reading XMM registers
      KVM: x86: Introduce trace_kvm_hv_hypercall_done()
      KVM: x86: hyper-v: Check if guest is allowed to use XMM registers for hypercall input
      KVM: selftests: Test access to XMM fast hypercalls

 arch/x86/kvm/hyperv.c                              | 18 +++++++--
 arch/x86/kvm/mmu/mmu.c                             |  2 +-
 arch/x86/kvm/svm/sev.c                             | 45 ++++++++++++----------
 arch/x86/kvm/trace.h                               | 15 ++++++++
 arch/x86/kvm/x86.c                                 | 13 ++++++-
 .../testing/selftests/kvm/include/x86_64/hyperv.h  |  5 ++-
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c  |  2 +-
 .../testing/selftests/kvm/x86_64/hyperv_features.c | 41 ++++++++++++++++++--
 virt/kvm/kvm_main.c                                | 18 ++++++++-
 9 files changed, 125 insertions(+), 34 deletions(-)


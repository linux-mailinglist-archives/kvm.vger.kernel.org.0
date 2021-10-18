Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C975C432672
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 20:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhJRSgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 14:36:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229696AbhJRSgM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 14:36:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634582040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OSygEczErC91lPb9+ylTpKzIGZjPehE9TLoLjeOo4oc=;
        b=DUwkuQYD9BwiohN9mTeYCTE0Xb3EjeypFHy1b8jizx1Z34SNnrrUhkNQykE22JqLx45LeP
        qbunAJsyrxf7lb5IRsFEvNZQSM4KGFDEIpjsaWlZ8Q3K+GPibNeKrjINcs1CJwlbjvIAhD
        iJQZtW55trT78w0iS5NSlTNKjf8p7Qc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-rLOD-y0-MHKaXupbUOb-jw-1; Mon, 18 Oct 2021 14:33:57 -0400
X-MC-Unique: rLOD-y0-MHKaXupbUOb-jw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F42028042E1;
        Mon, 18 Oct 2021 18:33:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2D5E5BB06;
        Mon, 18 Oct 2021 18:33:55 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linus 5.15-rc7, take 2
Date:   Mon, 18 Oct 2021 14:33:55 -0400
Message-Id: <20211018183355.588382-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 7b0035eaa7dab9fd33d6658ad6a755024bdce26c:

  KVM: selftests: Ensure all migrations are performed when test is affined (2021-09-30 04:25:57 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9f1ee7b169afbd10c3ad254220d1b37beb5798aa:

  KVM: SEV-ES: reduce ghcb_sa_len to 32 bits (2021-10-18 14:07:19 -0400)

----------------------------------------------------------------
Tools:
* kvm_stat: do not show halt_wait_ns since it is not a cumulative statistic

x86:
* clean ups and fixes for bus lock vmexit and lazy allocation of rmaps
* two fixes for SEV-ES (one more coming as soon as I get reviews)
* fix for static_key underflow

ARM:
* Properly refcount pages used as a concatenated stage-2 PGD
* Fix missing unlock when detecting the use of MTE+VM_SHARED

----------------------------------------------------------------

I left out the two problematic patches.

Paolo


Christian Borntraeger (1):
      KVM: kvm_stat: do not show halt_wait_ns

Hao Xiang (1):
      KVM: VMX: Remove redundant handling of bus lock vmexit

Janosch Frank (1):
      KVM: s390: Function documentation fixes

Paolo Bonzini (5):
      Merge tag 'kvm-s390-master-5.15-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-master
      KVM: SEV-ES: fix length of string I/O
      Merge tag 'kvmarm-fixes-5.15-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      KVM: X86: fix lazy allocation of rmaps
      KVM: SEV-ES: reduce ghcb_sa_len to 32 bits

Peter Gonda (1):
      KVM: SEV-ES: Set guest_state_protected after VMSA update

Quentin Perret (3):
      KVM: arm64: Fix host stage-2 PGD refcount
      KVM: arm64: Report corrupted refcount at EL2
      KVM: arm64: Release mmap_lock when using VM_SHARED with MTE

Sean Christopherson (2):
      Revert "KVM: x86: Open code necessary bits of kvm_lapic_set_base() at vCPU RESET"
      KVM: x86: WARN if APIC HW/SW disable static keys are non-zero on unload

 arch/arm64/kvm/hyp/include/nvhe/gfp.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 13 ++++++++++++-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c  | 15 +++++++++++++++
 arch/arm64/kvm/mmu.c                  |  6 ++++--
 arch/s390/kvm/gaccess.c               | 12 ++++++++++++
 arch/s390/kvm/intercept.c             |  4 +++-
 arch/x86/kvm/lapic.c                  | 20 +++++++++++++-------
 arch/x86/kvm/svm/sev.c                |  9 +++++++--
 arch/x86/kvm/svm/svm.h                |  2 +-
 arch/x86/kvm/vmx/vmx.c                | 15 +++++++++------
 arch/x86/kvm/x86.c                    |  3 ++-
 tools/kvm/kvm_stat/kvm_stat           |  2 +-
 12 files changed, 80 insertions(+), 22 deletions(-)


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0CA47C6A1
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 19:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbhLUScG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 13:32:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237146AbhLUScF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Dec 2021 13:32:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640111525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wMhFZtO7yKI5BwQWMaY+mEAZQOYttP8C1xI6ZXPwY7s=;
        b=V2+GupCqxO+c7ceJsu1UD1eFfJkExNLyARFTFP0PuKhIdW7KUz/EgX5vOEX+3dOce5fX7Z
        OJcxrXpN1trfD7EYgx7Sbr83lApxUwp8G+l8XQLWQq95j6uPPvDzk52l/1UG0qV0nRBzU0
        0nwNVxMb2IgKbe6oeQ4qjlZLXcvW0mA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-fd9AH3tIMUmVLJ-sNZFQSQ-1; Tue, 21 Dec 2021 13:32:03 -0500
X-MC-Unique: fd9AH3tIMUmVLJ-sNZFQSQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2D301018721;
        Tue, 21 Dec 2021 18:32:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54BFC78DA4;
        Tue, 21 Dec 2021 18:32:02 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.16-rc7 (and likely final)
Date:   Tue, 21 Dec 2021 13:32:01 -0500
Message-Id: <20211221183201.307603-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 18c841e1f4112d3fb742aca3429e84117fcb1e1c:

  KVM: x86: Retry page fault if MMU reload is pending and root has no sp (2021-12-19 19:38:58 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to fdba608f15e2427419997b0898750a49a735afcb:

  KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU (2021-12-21 12:39:03 -0500)

----------------------------------------------------------------
* Fix for compilation of selftests on non-x86 architectures
* Fix for kvm_run->if_flag on SEV-ES
* Fix for page table use-after-free if yielding during exit_mm()
* Improve behavior when userspace starts a nested guest with invalid state
* Fix missed wakeup with assigned devices but no VT-d posted interrupts
* Do not tell userspace to save/restore an unsupported PMU MSR

----------------------------------------------------------------

So, 5.16 really was a huge bug shakedown for KVM.  Apart from the locking
changes in -rc4, almost everything that went in after -rc2 was Cc'ed
stable, including this pull request (which I guess is not a bad thing
for rc7).

You can't quite see it, but things do seem to have calmed down; these
patches as well as those in rc6 had actually been submitted a week or
so ago; one was a relatively old 5.17 change that turned out to fix a
bug.  Since I'm taking some time off until right before the merge
window, I don't expect any more changes in 5.16.  Thanks for putting up
with this weird KVM release cycle.

Paolo

Andrew Jones (1):
      selftests: KVM: Fix non-x86 compiling

Marc Orr (1):
      KVM: x86: Always set kvm_run->if_flag

Sean Christopherson (6):
      KVM: x86/mmu: Don't advance iterator after restart due to yielding
      KVM: VMX: Always clear vmx->fail on emulation_required
      KVM: nVMX: Synthesize TRIPLE_FAULT for L2 if emulation is required
      KVM: VMX: Fix stale docs for kvm-intel.emulate_invalid_guest_state
      KVM: selftests: Add test to verify TRIPLE_FAULT on invalid L2 guest state
      KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU

Wei Wang (1):
      KVM: x86: remove PMU FIXED_CTR3 from msrs_to_save_all

 Documentation/admin-guide/kernel-parameters.txt    |   8 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   1 +
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/kvm/mmu/tdp_iter.c                        |   6 ++
 arch/x86/kvm/mmu/tdp_iter.h                        |   6 ++
 arch/x86/kvm/mmu/tdp_mmu.c                         |  29 +++---
 arch/x86/kvm/svm/svm.c                             |  21 +++--
 arch/x86/kvm/vmx/vmx.c                             |  45 ++++++---
 arch/x86/kvm/x86.c                                 |  11 +--
 tools/testing/selftests/kvm/.gitignore             |   1 +
 tools/testing/selftests/kvm/Makefile               |   1 +
 tools/testing/selftests/kvm/include/kvm_util.h     |  10 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |   5 +
 .../kvm/x86_64/vmx_invalid_nested_guest_state.c    | 105 +++++++++++++++++++++
 14 files changed, 195 insertions(+), 55 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BD0437B3F
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 19:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhJVRDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 13:03:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233413AbhJVRDA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 13:03:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634922042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yshbiWRhH57hDBd2s7uGmf9hnvbyLWUUUpBF4XakSm8=;
        b=FbqbIENzhDiuCm1wMVH3Z+Z37kk278kA1JGrMtHJyqV2wdDu46UGknNQN2bezsS4nwunDt
        unyPvJ3gAIlnp3kJSwNlZtdSfkWLFHH9dZ1166bqk6R7e6Jp9lTuRbXrWyyZkONzRpnwC1
        Bdyoq6olCJkncD8jdmGwldpNbgvoqRM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-DFM9rR-_Pi26h97wOxpOwA-1; Fri, 22 Oct 2021 13:00:38 -0400
X-MC-Unique: DFM9rR-_Pi26h97wOxpOwA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C2B610A8E00;
        Fri, 22 Oct 2021 17:00:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D4AF60657;
        Fri, 22 Oct 2021 17:00:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] More x86 KVM fixes for Linux 5.15-rc7
Date:   Fri, 22 Oct 2021 13:00:36 -0400
Message-Id: <20211022170036.1782205-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 9f1ee7b169afbd10c3ad254220d1b37beb5798aa:

  KVM: SEV-ES: reduce ghcb_sa_len to 32 bits (2021-10-18 14:07:19 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 95e16b4792b0429f1933872f743410f00e590c55:

  KVM: SEV-ES: go over the sev_pio_data buffer in multiple passes if needed (2021-10-22 10:09:13 -0400)

----------------------------------------------------------------
* Cache coherency fix for SEV live migration
* Fix for instruction emulation with PKU
* fixes for rare delaying of interrupt delivery
* fix for SEV-ES buffer overflow

----------------------------------------------------------------
Chenyi Qiang (1):
      KVM: MMU: Reset mmu->pkru_mask to avoid stale data

Masahiro Kozuka (1):
      KVM: SEV: Flush cache on non-coherent systems before RECEIVE_UPDATE_DATA

Paolo Bonzini (9):
      KVM: x86: check for interrupts before deciding whether to exit the fast path
      KVM: nVMX: promptly process interrupts delivered while in guest mode
      KVM: SEV-ES: rename guest_ins_data to sev_pio_data
      KVM: x86: leave vcpu->arch.pio.count alone in emulator_pio_in_out
      KVM: SEV-ES: clean up kvm_sev_es_ins/outs
      KVM: x86: split the two parts of emulator_pio_in
      KVM: x86: remove unnecessary arguments from complete_emulator_pio_in
      KVM: SEV-ES: keep INS functions together
      KVM: SEV-ES: go over the sev_pio_data buffer in multiple passes if needed

 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/mmu/mmu.c          |   6 +-
 arch/x86/kvm/svm/sev.c          |   7 ++
 arch/x86/kvm/vmx/vmx.c          |  17 ++---
 arch/x86/kvm/x86.c              | 150 +++++++++++++++++++++++++++-------------
 5 files changed, 121 insertions(+), 62 deletions(-)


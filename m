Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17BB6CAC58
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 19:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbjC0RyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 13:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbjC0RyH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 13:54:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91E2270F
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 10:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679939599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Mus5kY1LYOsh4mZlEdqt0v1q9KUGRFm/L2rsuQRkD/A=;
        b=P69RtX0t3i2jSHSwY3ReaMbARkKuyEefVqiV1FePbTkJjql3fYL3g5ponMEbfZXhw4Nlq5
        XTXsX6X570t92BKWS16JWo3srmgQw+WnKZxz37jaDX3xljp9tICKzNfuTGq6kD2AlLDX6f
        Un6Fz7BxpNL0LvfaiBpERZH0xBMxqs4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-1HLjWklUPFaS-4lA-Zq6XA-1; Mon, 27 Mar 2023 13:53:16 -0400
X-MC-Unique: 1HLjWklUPFaS-4lA-Zq6XA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E39AD884EC4;
        Mon, 27 Mar 2023 17:53:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1628404DC4F;
        Mon, 27 Mar 2023 17:53:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, maz@kernel.org,
        oliver.upton@linux.dev, apatel@ventanamicro.com
Subject: [GIT PULL] Non-x86 KVM fixes for Linux 6.3-rc5
Date:   Mon, 27 Mar 2023 13:53:15 -0400
Message-Id: <20230327175315.3763370-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit eeac8ede17557680855031c6f305ece2378af326:

  Linux 6.3-rc2 (2023-03-12 16:36:44 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9e347ba03029e10e6405f8c3a7a91a5597943ed9:

  Merge tag 'kvm-riscv-fixes-6.3-1' of https://github.com/kvm-riscv/linux into HEAD (2023-03-27 10:04:07 -0400)

There are also some pending x86 changes will come later this week.

----------------------------------------------------------------
RISC-V:

* Fix VM hang in case of timer delta being zero

ARM:

* Fixes for the MMU:

  * Read the MMU notifier seq before dropping the mmap lock to guard
    against reading a potentially stale VMA

  * Disable interrupts when walking user page tables to protect against
    the page table being freed

  * Read the MTE permissions for the VMA within the mmap lock critical
    section, avoiding the use of a potentally stale VMA pointer

* Fixes for the vPMU:

  * Return the sum of the current perf event value and PMC snapshot for
    reads from userspace

  * Don't save the value of guest writes to PMCR_EL0.{C,P}, which could
    otherwise lead to userspace erroneously resetting the vPMU during VM
    save/restore

----------------------------------------------------------------
David Matlack (1):
      KVM: arm64: Retry fault if vma_lookup() results become invalid

Marc Zyngier (2):
      KVM: arm64: Disable interrupts while walking userspace PTs
      KVM: arm64: Check for kvm_vma_mte_allowed in the critical section

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-6.3-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-riscv-fixes-6.3-1' of https://github.com/kvm-riscv/linux into HEAD

Rajnesh Kanwal (1):
      riscv/kvm: Fix VM hang in case of timer delta being zero.

Reiji Watanabe (2):
      KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current value
      KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU

 arch/arm64/kvm/mmu.c        | 99 +++++++++++++++++++++++++++++----------------
 arch/arm64/kvm/pmu-emul.c   |  3 +-
 arch/arm64/kvm/sys_regs.c   | 21 +++++++++-
 arch/riscv/kvm/vcpu_timer.c |  6 +--
 4 files changed, 87 insertions(+), 42 deletions(-)


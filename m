Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BC175E3F4
	for <lists+kvm@lfdr.de>; Sun, 23 Jul 2023 19:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjGWRCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jul 2023 13:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjGWRCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jul 2023 13:02:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB06E58
        for <kvm@vger.kernel.org>; Sun, 23 Jul 2023 10:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690131680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7LuMJHzE46aTXZZsG31yULTvRUZVAibNUqOoEXBXD0k=;
        b=HOsjikGbv5DxBBIn+NdSMv7UCNnYDajC4n9s8lMXY1vfDXwQP4GlCZhlYpYRgrhU53mied
        xM1BSfnaKa6Xgu1+/219sFeGn4SRVgi6ymFCtWvMlpfXiKiT6IOahCFXHdErzo/Y7WabhH
        fY7e1X/Kfitxty800wAtzY2XyLcfIiM=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519--ukkP5YaPqShbrKx1Xpvvw-1; Sun, 23 Jul 2023 13:01:18 -0400
X-MC-Unique: -ukkP5YaPqShbrKx1Xpvvw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D56483C0D198;
        Sun, 23 Jul 2023 17:01:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8E7440C6F4F;
        Sun, 23 Jul 2023 17:01:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] (Non-x86) KVM fixes for Linux 6.5-rc3
Date:   Sun, 23 Jul 2023 13:01:17 -0400
Message-Id: <20230723170117.2317135-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit fdf0eaf11452d72945af31804e2a1048ee1b574c:

  Linux 6.5-rc2 (2023-07-16 15:10:37 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 0c189708bfbfa90b458dac5f0fd4379f9a7d547e:

  Merge tag 'kvm-s390-master-6.5-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2023-07-23 12:50:30 -0400)

----------------------------------------------------------------
ARM:

* Avoid pKVM finalization if KVM initialization fails

* Add missing BTI instructions in the hypervisor, fixing an early boot
  failure on BTI systems

* Handle MMU notifiers correctly for non hugepage-aligned memslots

* Work around a bug in the architecture where hypervisor timer controls
  have UNKNOWN behavior under nested virt.

* Disable preemption in kvm_arch_hardware_enable(), fixing a kernel BUG
  in cpu hotplug resulting from per-CPU accessor sanity checking.

* Make WFI emulation on GICv4 systems robust w.r.t. preemption,
  consistently requesting a doorbell interrupt on vcpu_put()

* Uphold RES0 sysreg behavior when emulating older PMU versions

* Avoid macro expansion when initializing PMU register names, ensuring
  the tracepoints pretty-print the sysreg.

s390:

* Two fixes for asynchronous destroy

x86 fixes will come early next week.

----------------------------------------------------------------
Claudio Imbrenda (2):
      KVM: s390: pv: simplify shutdown and fix race
      KVM: s390: pv: fix index value of replaced ASCE

Marc Zyngier (3):
      KVM: arm64: timers: Use CNTHCTL_EL2 when setting non-CNTKCTL_EL1 bits
      KVM: arm64: Disable preemption in kvm_arch_hardware_enable()
      KVM: arm64: vgic-v4: Make the doorbell request robust w.r.t preemption

Mostafa Saleh (1):
      KVM: arm64: Add missing BTI instructions

Oliver Upton (2):
      KVM: arm64: Correctly handle page aging notifiers for unaligned memslot
      KVM: arm64: Correctly handle RES0 bits PMEVTYPER<n>_EL0.evtCount

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-6.5-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-s390-master-6.5-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

Sudeep Holla (1):
      KVM: arm64: Handle kvm_arm_init failure correctly in finalize_pkvm

Xiang Chen (1):
      KVM: arm64: Fix the name of sys_reg_desc related to PMU

 arch/arm64/include/asm/kvm_host.h    |  2 ++
 arch/arm64/include/asm/kvm_pgtable.h | 26 +++++++-------------
 arch/arm64/include/asm/virt.h        |  1 +
 arch/arm64/kvm/arch_timer.c          |  6 ++---
 arch/arm64/kvm/arm.c                 | 28 ++++++++++++++++++---
 arch/arm64/kvm/hyp/hyp-entry.S       |  8 ++++++
 arch/arm64/kvm/hyp/nvhe/host.S       | 10 ++++++++
 arch/arm64/kvm/hyp/nvhe/psci-relay.c |  2 +-
 arch/arm64/kvm/hyp/pgtable.c         | 47 +++++++++++++++++++++++++++++-------
 arch/arm64/kvm/mmu.c                 | 18 ++++++--------
 arch/arm64/kvm/pkvm.c                |  2 +-
 arch/arm64/kvm/sys_regs.c            | 42 ++++++++++++++++----------------
 arch/arm64/kvm/vgic/vgic-v3.c        |  2 +-
 arch/arm64/kvm/vgic/vgic-v4.c        |  7 ++++--
 arch/s390/kvm/pv.c                   |  8 ++++--
 arch/s390/mm/gmap.c                  |  1 +
 include/kvm/arm_vgic.h               |  2 +-
 17 files changed, 140 insertions(+), 72 deletions(-)


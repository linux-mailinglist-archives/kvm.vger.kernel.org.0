Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FC5721609
	for <lists+kvm@lfdr.de>; Sun,  4 Jun 2023 12:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjFDK0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 06:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjFDK0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 06:26:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0331B3
        for <kvm@vger.kernel.org>; Sun,  4 Jun 2023 03:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685874343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6QuVff0D6XaAXOCOopebXuwGjm2V9RJJEXXLpHUrRf4=;
        b=Pj2GgTd20f1UwjVMK+6y0YOtRxqA9xLqt4ZFlvTreZGRMscbkFu7ox+tHLM4yyCfKMz/bW
        Qd+GsBVgm1cfgR8Mil01GuuKywlWhqO3MlYWNhNcvRRS5Rr0reODTBgSydTdfElQkbteeU
        PnpPYjAVloFqvL9oKxvg9e7IL6Lz4P0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-DxXoV10AMUOLmsp6lfRpkg-1; Sun, 04 Jun 2023 06:25:41 -0400
X-MC-Unique: DxXoV10AMUOLmsp6lfRpkg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-50a16ab50e6so2426181a12.0
        for <kvm@vger.kernel.org>; Sun, 04 Jun 2023 03:25:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685874340; x=1688466340;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6QuVff0D6XaAXOCOopebXuwGjm2V9RJJEXXLpHUrRf4=;
        b=dPN1Cr+aS0iw82f3ZCmB3hTlenyN6vqAfMyg13hRaGyquu+n16edNvwZBkLjcUmk3Q
         h0344bKOWv6L57xqBbAGEu+2rUp6ejv7eR7cq68BhZpF7igwVCLbDmpAxcdFroAXrbrk
         f/7/Reu/2apWlrmUf7Q97h9FbFN3hVZe5qgX+87GXYXZFEaEfE3Rlq7T0rZ7LejknoSE
         /TUSJ1GlhavvY0Tm+8w8HzIAw+VH/ch7zlaw3tuNEL1LkrLJgGcfZ/3S82ji2r+uynDr
         QGhT9h6Rk/95PxVEzh4bjIbnQ9g4LYCogfb7k47JNvVj1oUE/OLpOBOWco2+/lR/+qMr
         DSFw==
X-Gm-Message-State: AC+VfDzNzz0UdjTn2d5Fs4N4/unbzdpyhW7u/bhlsER7+RIWvUSj63R1
        ZYgSHakMFEMWfjEVf8PEJ6P3oglL+WlX7pLMvAOdL1iZLcMM+opMZyvBs4UNGgnfkcsgr1xHL8u
        eBncd/ukaCWRfHNOVQZjO
X-Received: by 2002:a17:907:36cd:b0:974:4457:b6f with SMTP id bj13-20020a17090736cd00b0097444570b6fmr3774099ejc.23.1685874340243;
        Sun, 04 Jun 2023 03:25:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ53MNg5eFT+A6Y7ISahP3Zp1j3vd9ETNRvngzAMX7tdW0nnEjhgKaL7fFs7ARigZ11uJ1ffZg==
X-Received: by 2002:a17:907:36cd:b0:974:4457:b6f with SMTP id bj13-20020a17090736cd00b0097444570b6fmr3774085ejc.23.1685874339862;
        Sun, 04 Jun 2023 03:25:39 -0700 (PDT)
Received: from [192.168.10.118] ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.gmail.com with ESMTPSA id bi1-20020a170906a24100b009664cdb3fc5sm2904639ejb.138.2023.06.04.03.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 03:25:39 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.4-rc5
Date:   Sun,  4 Jun 2023 12:25:38 +0200
Message-Id: <20230604102538.8867-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit b9846a698c9aff4eb2214a06ac83638ad098f33f:

  KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save (2023-05-21 04:05:51 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to f211b45057d8b0264b494f1acebf2e8d7f9432c9:

  Merge tag 'kvm-x86-fixes-6.4' of https://github.com/kvm-x86/linux into HEAD (2023-06-03 15:16:58 -0400)

----------------------------------------------------------------
ARM:

* Address some fallout of the locking rework, this time affecting
  the way the vgic is configured

* Fix an issue where the page table walker frees a subtree and
  then proceeds with walking what it has just freed...

* Check that a given PA donated to the guest is actually memory
  (only affecting pKVM)

* Correctly handle MTE CMOs by Set/Way

* Fix the reported address of a watchpoint forwarded to userspace

* Fix the freeing of the root of stage-2 page tables

* Stop creating spurious PMU events to perform detection of the
  default PMU and use the existing PMU list instead.

x86:

* Fix a memslot lookup bug in the NX recovery thread that could
   theoretically let userspace bypass the NX hugepage mitigation

* Fix a s/BLOCKING/PENDING bug in SVM's vNMI support

* Account exit stats for fastpath VM-Exits that never leave the super
  tight run-loop

* Fix an out-of-bounds bug in the optimized APIC map code, and add a
  regression test for the race.

----------------------------------------------------------------
Akihiko Odaki (1):
      KVM: arm64: Populate fault info for watchpoint

Fuad Tabba (1):
      KVM: arm64: Reload PTE after invoking walker callback on preorder traversal

Jean-Philippe Brucker (4):
      KVM: arm64: vgic: Fix a circular locking issue
      KVM: arm64: vgic: Wrap vgic_its_create() with config_lock
      KVM: arm64: vgic: Fix locking comment
      KVM: arm64: vgic: Fix a comment

Maciej S. Szmigiero (1):
      KVM: SVM: vNMI pending bit is V_NMI_PENDING_MASK not V_NMI_BLOCKING_MASK

Marc Zyngier (2):
      arm64: Add missing Set/Way CMO encodings
      KVM: arm64: Handle trap of tagged Set/Way CMOs

Michal Luczaj (1):
      KVM: selftests: Add test for race in kvm_recalculate_apic_map()

Oliver Upton (3):
      KVM: arm64: Drop last page ref in kvm_pgtable_stage2_free_removed()
      KVM: arm64: Iterate arm_pmus list to probe for default PMU
      KVM: arm64: Document default vPMU behavior on heterogeneous systems

Paolo Bonzini (3):
      Merge tag 'kvmarm-fixes-6.4-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvmarm-fixes-6.4-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-fixes-6.4' of https://github.com/kvm-x86/linux into HEAD

Sean Christopherson (3):
      KVM: x86/mmu: Grab memslot for correct address space in NX recovery worker
      KVM: x86: Account fastpath-only VM-Exits in vCPU stats
      KVM: x86: Bail from kvm_recalculate_phys_map() if x2APIC ID is out-of-bounds

Will Deacon (1):
      KVM: arm64: Prevent unconditional donation of unmapped regions from the host

 arch/arm64/include/asm/kvm_pgtable.h               |  6 +-
 arch/arm64/include/asm/sysreg.h                    |  6 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  8 ++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              | 14 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  2 +
 arch/arm64/kvm/hyp/pgtable.c                       | 17 ++++-
 arch/arm64/kvm/hyp/vhe/switch.c                    |  1 +
 arch/arm64/kvm/pmu-emul.c                          | 58 +++++++----------
 arch/arm64/kvm/sys_regs.c                          | 19 ++++++
 arch/arm64/kvm/vgic/vgic-init.c                    | 27 ++++++--
 arch/arm64/kvm/vgic/vgic-its.c                     | 14 ++--
 arch/arm64/kvm/vgic/vgic-kvm-device.c              | 10 ++-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 | 31 ++++++---
 arch/arm64/kvm/vgic/vgic-mmio.c                    |  9 +--
 arch/arm64/kvm/vgic/vgic-v2.c                      |  6 --
 arch/arm64/kvm/vgic/vgic-v3.c                      |  7 --
 arch/arm64/kvm/vgic/vgic-v4.c                      |  3 +-
 arch/x86/kvm/lapic.c                               | 20 +++++-
 arch/x86/kvm/mmu/mmu.c                             |  5 +-
 arch/x86/kvm/svm/svm.c                             |  2 +-
 arch/x86/kvm/x86.c                                 |  3 +
 tools/testing/selftests/kvm/Makefile               |  1 +
 .../selftests/kvm/x86_64/recalc_apic_map_test.c    | 74 ++++++++++++++++++++++
 23 files changed, 248 insertions(+), 95 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/recalc_apic_map_test.c


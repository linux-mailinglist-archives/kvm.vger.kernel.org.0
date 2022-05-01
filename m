Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C7E5166B1
	for <lists+kvm@lfdr.de>; Sun,  1 May 2022 19:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241488AbiEARjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 13:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238638AbiEARjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 13:39:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF9C61274F
        for <kvm@vger.kernel.org>; Sun,  1 May 2022 10:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651426571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=C7rt6DVHmhGNQzbaxM2jBW0f74J6Z/WNAFY69asoZMY=;
        b=JBllc7pUmKhjQ9jnUzpGEUfsvGvxwDbga78J0mTeEmtLbLz1XT7IRcvzOtJYbylEhYSDyn
        X5Oqpne5UT4lLqe9JTNBrvrdERm5AGAOiKJYQaIOywD0iVIOelhdJvKb5FAtvkQBiRARq7
        zsTcsgHfDssoO+AGZ+HRFS1H6c+htqE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-VlTKOJW0MUuLMV2oeMrTbQ-1; Sun, 01 May 2022 13:36:08 -0400
X-MC-Unique: VlTKOJW0MUuLMV2oeMrTbQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C92B13801482;
        Sun,  1 May 2022 17:36:07 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB024111CB81;
        Sun,  1 May 2022 17:36:07 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.18-rc5 (or -rc6)
Date:   Sun,  1 May 2022 13:36:07 -0400
Message-Id: <20220501173607.947159-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit e852be8b148e117e25be1c98cf72ee489b05919e:

  kvm: selftests: introduce and use more page size-related constants (2022-04-21 15:41:01 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to f751d8eac17692905cdd6935f72d523d8adf3b65:

  KVM: x86: work around QEMU issue with synthetic CPUID leaves (2022-04-29 15:24:58 -0400)

----------------------------------------------------------------
ARM:

* Take care of faults occuring between the PARange and
  IPA range by injecting an exception

* Fix S2 faults taken from a host EL0 in protected mode

* Work around Oops caused by a PMU access from a 32bit
  guest when PMU has been created. This is a temporary
  bodge until we fix it for good.

x86:

* Fix potential races when walking host page table

* Fix shadow page table leak when KVM runs nested

* Work around bug in userspace when KVM synthesizes leaf
  0x80000021 on older (pre-EPYC) or Intel processors

Generic (but affects only RISC-V):

* Fix bad user ABI for KVM_EXIT_SYSTEM_EVENT

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM/arm64: Don't emulate a PMU for 32-bit guests if feature not set

Marc Zyngier (1):
      KVM: arm64: Inject exception on out-of-IPA-range translation fault

Mingwei Zhang (1):
      KVM: x86/mmu: fix potential races when walking host page table

Paolo Bonzini (4):
      Merge tag 'kvmarm-fixes-5.18-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      KVM: fix bad user ABI for KVM_EXIT_SYSTEM_EVENT
      Merge branch 'kvm-fixes-for-5.18-rc5' into HEAD
      KVM: x86: work around QEMU issue with synthetic CPUID leaves

Sean Christopherson (2):
      KVM: x86/mmu: Do not create SPTEs for GFNs that exceed host.MAXPHYADDR
      Revert "x86/mm: Introduce lookup_address_in_mm()"

Will Deacon (1):
      KVM: arm64: Handle host stage-2 faults from 32-bit EL0

 Documentation/virt/kvm/api.rst       | 24 ++++++++++-----
 arch/arm64/include/asm/kvm_emulate.h |  1 +
 arch/arm64/kvm/hyp/nvhe/host.S       | 18 ++++++------
 arch/arm64/kvm/inject_fault.c        | 28 ++++++++++++++++++
 arch/arm64/kvm/mmu.c                 | 19 ++++++++++++
 arch/arm64/kvm/pmu-emul.c            | 23 ++++++++++++++-
 arch/arm64/kvm/psci.c                |  3 +-
 arch/riscv/kvm/vcpu_sbi.c            |  5 ++--
 arch/x86/include/asm/pgtable_types.h |  4 ---
 arch/x86/kvm/cpuid.c                 | 19 ++++++++----
 arch/x86/kvm/mmu.h                   | 24 +++++++++++++++
 arch/x86/kvm/mmu/mmu.c               | 57 +++++++++++++++++++++++++++++++-----
 arch/x86/kvm/mmu/spte.h              |  6 ----
 arch/x86/kvm/mmu/tdp_mmu.c           | 15 +++++-----
 arch/x86/kvm/x86.c                   |  8 ++++-
 arch/x86/mm/pat/set_memory.c         | 11 -------
 include/uapi/linux/kvm.h             | 10 ++++++-
 virt/kvm/kvm_main.c                  |  1 +
 18 files changed, 214 insertions(+), 62 deletions(-)


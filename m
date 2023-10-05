Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052FA7BA18E
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 16:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239428AbjJEOn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 10:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237447AbjJEOjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 10:39:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B4A76AD;
        Thu,  5 Oct 2023 07:07:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1B4C116B9;
        Thu,  5 Oct 2023 09:18:52 +0000 (UTC)
From:   Huacai Chen <chenhuacai@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>
Cc:     kvm@vger.kernel.org, loongarch@lists.linux.dev,
        linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>
Subject: [GIT PULL] LoongArch KVM changes for v6.7
Date:   Thu,  5 Oct 2023 17:18:25 +0800
Message-Id: <20231005091825.3207300-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa:

  Linux 6.6-rc4 (2023-10-01 14:15:13 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git tags/loongarch-kvm-6.7

for you to fetch changes up to 2c10cda4b777be4be9d9e69e4f70c818dbb15e21:

  LoongArch: KVM: Add maintainers for LoongArch KVM (2023-10-02 10:01:29 +0800)

----------------------------------------------------------------
LoongArch KVM changes for v6.7

Add LoongArch's KVM support. Loongson 3A5000/3A6000 supports hardware
assisted virtualization. With cpu virtualization, there are separate
hw-supported user mode and kernel mode in guest mode. With memory
virtualization, there are two-level hw mmu table for guest mode and host
mode. Also there is separate hw cpu timer with consant frequency in
guest mode, so that vm can migrate between hosts with different freq.
Currently, we are able to boot LoongArch Linux guests.

Few key aspects of KVM LoongArch added by this series are:
1. Enable kvm hardware features when kvm module is loaded.
2. Implement VM and vcpu related ioctl interface such as vcpu create,
   vcpu run etc. GET_ONE_REG/SET_ONE_REG ioctl commands are use to
   get general registers one by one.
3. Hardware access about MMU, timer and csr are emulated in kernel.
4. Hardwares such as mmio and iocsr device are emulated in user space
   such as IPI, irqchips, pci devices etc.

----------------------------------------------------------------
Tianrui Zhao (25):
      LoongArch: KVM: Add kvm related header files
      LoongArch: KVM: Implement kvm module related interface
      LoongArch: KVM: Implement kvm hardware enable, disable interface
      LoongArch: KVM: Implement VM related functions
      LoongArch: KVM: Add vcpu related header files
      LoongArch: KVM: Implement basic vcpu interfaces
      LoongArch: KVM: Implement basic vcpu ioctl interfaces
      LoongArch: KVM: Implement fpu operations for vcpu
      LoongArch: KVM: Implement vcpu interrupt operations
      LoongArch: KVM: Implement vcpu load and vcpu put operations
      LoongArch: KVM: Implement misc vcpu related interfaces
      LoongArch: KVM: Implement vcpu timer operations
      LoongArch: KVM: Implement virtual machine tlb operations
      LoongArch: KVM: Implement kvm mmu operations
      LoongArch: KVM: Implement handle csr exception
      LoongArch: KVM: Implement handle iocsr exception
      LoongArch: KVM: Implement handle idle exception
      LoongArch: KVM: Implement handle gspr exception
      LoongArch: KVM: Implement handle mmio exception
      LoongArch: KVM: Implement handle fpu exception
      LoongArch: KVM: Implement kvm exception vectors
      LoongArch: KVM: Implement vcpu world switch
      LoongArch: KVM: Enable kvm config and add the makefile
      LoongArch: KVM: Supplement kvm document about LoongArch-specific part
      LoongArch: KVM: Add maintainers for LoongArch KVM

 Documentation/virt/kvm/api.rst             |  70 ++-
 MAINTAINERS                                |  12 +
 arch/loongarch/Kbuild                      |   2 +
 arch/loongarch/Kconfig                     |   6 +
 arch/loongarch/configs/loongson3_defconfig |   2 +
 arch/loongarch/include/asm/inst.h          |  16 +
 arch/loongarch/include/asm/kvm_csr.h       | 211 +++++++
 arch/loongarch/include/asm/kvm_host.h      | 237 ++++++++
 arch/loongarch/include/asm/kvm_mmu.h       | 139 +++++
 arch/loongarch/include/asm/kvm_types.h     |  11 +
 arch/loongarch/include/asm/kvm_vcpu.h      |  93 +++
 arch/loongarch/include/asm/loongarch.h     |  19 +-
 arch/loongarch/include/uapi/asm/kvm.h      | 108 ++++
 arch/loongarch/kernel/asm-offsets.c        |  32 +
 arch/loongarch/kvm/Kconfig                 |  40 ++
 arch/loongarch/kvm/Makefile                |  22 +
 arch/loongarch/kvm/exit.c                  | 696 +++++++++++++++++++++
 arch/loongarch/kvm/interrupt.c             | 183 ++++++
 arch/loongarch/kvm/main.c                  | 420 +++++++++++++
 arch/loongarch/kvm/mmu.c                   | 914 ++++++++++++++++++++++++++++
 arch/loongarch/kvm/switch.S                | 250 ++++++++
 arch/loongarch/kvm/timer.c                 | 197 ++++++
 arch/loongarch/kvm/tlb.c                   |  32 +
 arch/loongarch/kvm/trace.h                 | 162 +++++
 arch/loongarch/kvm/vcpu.c                  | 939 +++++++++++++++++++++++++++++
 arch/loongarch/kvm/vm.c                    |  94 +++
 include/uapi/linux/kvm.h                   |   9 +
 27 files changed, 4902 insertions(+), 14 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_csr.h
 create mode 100644 arch/loongarch/include/asm/kvm_host.h
 create mode 100644 arch/loongarch/include/asm/kvm_mmu.h
 create mode 100644 arch/loongarch/include/asm/kvm_types.h
 create mode 100644 arch/loongarch/include/asm/kvm_vcpu.h
 create mode 100644 arch/loongarch/include/uapi/asm/kvm.h
 create mode 100644 arch/loongarch/kvm/Kconfig
 create mode 100644 arch/loongarch/kvm/Makefile
 create mode 100644 arch/loongarch/kvm/exit.c
 create mode 100644 arch/loongarch/kvm/interrupt.c
 create mode 100644 arch/loongarch/kvm/main.c
 create mode 100644 arch/loongarch/kvm/mmu.c
 create mode 100644 arch/loongarch/kvm/switch.S
 create mode 100644 arch/loongarch/kvm/timer.c
 create mode 100644 arch/loongarch/kvm/tlb.c
 create mode 100644 arch/loongarch/kvm/trace.h
 create mode 100644 arch/loongarch/kvm/vcpu.c
 create mode 100644 arch/loongarch/kvm/vm.c

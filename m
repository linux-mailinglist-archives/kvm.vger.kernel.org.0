Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BE77BD608
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 11:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345632AbjJIJCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 05:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345623AbjJIJCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 05:02:19 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16742B9
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 02:02:14 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxDOuVwSNlij0wAA--.21909S3;
        Mon, 09 Oct 2023 17:02:13 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Dx_y+TwSNlDW4cAA--.59991S2;
        Mon, 09 Oct 2023 17:02:11 +0800 (CST)
From:   xianglai li <lixianglai@loongson.cn>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Bibo Mao <maobibo@loongson.cn>, Song Gao <gaosong@loongson.cn>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Tianrui Zhao <zhaotianrui@loongson.cn>
Subject: [PATCH RFC v4 0/9] Add loongarch kvm accel support
Date:   Mon,  9 Oct 2023 17:01:28 +0800
Message-Id: <cover.1696841645.git.lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Dx_y+TwSNlDW4cAA--.59991S2
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series add loongarch kvm support, mainly implement
some interfaces used by kvm such as kvm_arch_get/set_regs,
kvm_arch_handle_exit, kvm_loongarch_set_interrupt, etc.

Currently, we are able to boot LoongArch KVM Linux Guests.
In loongarch VM, mmio devices and iocsr devices are emulated
in user space such as APIC, IPI, pci devices, etc, other
hardwares such as MMU, timer and csr are emulated in kernel.

It is based on temporarily unaccepted linux kvm:
https://github.com/loongson/linux-loongarch-kvm
And We will remove the RFC flag until the linux kvm patches
are merged.

The running environment of LoongArch virt machine:
1. Get the linux source by the above mentioned link.
   git checkout kvm-loongarch
   make ARCH=loongarch CROSS_COMPILE=loongarch64-unknown-linux-gnu- loongson3_defconfig
   make ARCH=loongarch CROSS_COMPILE=loongarch64-unknown-linux-gnu-
2. Get the qemu source: https://github.com/loongson/qemu
   git checkout kvm-loongarch
   ./configure --target-list="loongarch64-softmmu"  --enable-kvm
   make
3. Get uefi bios of LoongArch virt machine:
   Link: https://github.com/tianocore/edk2-platforms/tree/master/Platform/Loongson/LoongArchQemuPkg#readme
4. Also you can access the binary files we have already build:
   https://github.com/yangxiaojuan-loongson/qemu-binary

The command to boot loongarch virt machine:
   $ qemu-system-loongarch64 -machine virt -m 4G -cpu la464 \
   -smp 1 -bios QEMU_EFI.fd -kernel vmlinuz.efi -initrd ramdisk \
   -serial stdio   -monitor telnet:localhost:4495,server,nowait \
   -append "root=/dev/ram rdinit=/sbin/init console=ttyS0,115200" \
   --nographic

Changes for RFC v4:
1. Added function interfaces kvm_loongarch_get_cpucfg and
kvm_loongarch_put_cpucfg for passing the value of vcpu cfg to kvm.
Move the macro definition KVM_IOC_CSRID from kvm.c to kvm.h.
2.Delete the duplicate CSR_CPUID field in CPUArchState.
3.Add kvm_arch_get_default_type function in kvm.c.
4.Disable LSX,LASX in cpucfg2 in KVM. And disable LBT in cpucfg2 in KVM.

Changes for RFC v3:
1. Move the init mp_state to KVM_MP_STATE_RUNNABLE function into kvm.c.
2. Fix some unstandard code problems in kvm_get/set_regs_ioctl, such as
sort loongarch to keep alphabetic ordering in meson.build, gpr[0] should
be always 0, remove unnecessary inline statement, etc.
3. Rename the counter_value variable to kvm_state_counter in cpu_env,
and add comments for it to explain the meaning.

Changes for RFC v2:
1. Mark the "Add KVM headers for loongarch" patch as a placeholder,
as we will use the update-linux-headers.sh to generate the kvm headers
when the linux loongarch KVM patch series are accepted.
2. Remove the DPRINTF macro in kvm.c and use trace events to replace
it, we add some trace functions such as trace_kvm_handle_exit,
trace_kvm_set_intr, trace_kvm_failed_get_csr, etc.
3. Remove the unused functions in kvm_stub.c and move stub function into
the suitable patch.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Marc-André Lureau" <marcandre.lureau@redhat.com>
Cc: "Daniel P. Berrangé" <berrange@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: "Philippe Mathieu-Daudé" <philmd@linaro.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Song Gao <gaosong@loongson.cn>
Cc: Xiaojuan Yang <yangxiaojuan@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>

Tianrui Zhao (9):
  linux-headers: Add KVM headers for loongarch
  target/loongarch: Define some kvm_arch interfaces
  target/loongarch: Supplement vcpu env initial when vcpu reset
  target/loongarch: Implement kvm get/set registers
  target/loongarch: Implement kvm_arch_init function
  target/loongarch: Implement kvm_arch_init_vcpu
  target/loongarch: Implement kvm_arch_handle_exit
  target/loongarch: Implement set vcpu intr for kvm
  target/loongarch: Add loongarch kvm into meson build

 linux-headers/asm-loongarch/kvm.h | 100 +++++
 linux-headers/linux/kvm.h         |   9 +
 meson.build                       |   3 +
 target/loongarch/cpu.c            |  23 +-
 target/loongarch/cpu.h            |   6 +-
 target/loongarch/kvm-stub.c       |  11 +
 target/loongarch/kvm.c            | 594 ++++++++++++++++++++++++++++++
 target/loongarch/kvm_loongarch.h  |  13 +
 target/loongarch/meson.build      |   1 +
 target/loongarch/trace-events     |  17 +
 target/loongarch/trace.h          |   1 +
 11 files changed, 772 insertions(+), 6 deletions(-)
 create mode 100644 linux-headers/asm-loongarch/kvm.h
 create mode 100644 target/loongarch/kvm-stub.c
 create mode 100644 target/loongarch/kvm.c
 create mode 100644 target/loongarch/kvm_loongarch.h
 create mode 100644 target/loongarch/trace-events
 create mode 100644 target/loongarch/trace.h

-- 
2.39.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DFE6F01A7
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 09:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242892AbjD0H06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 03:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242710AbjD0H0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 03:26:54 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31731E4
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 00:26:52 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Dxh+m6I0pk2XcBAA--.2639S3;
        Thu, 27 Apr 2023 15:26:50 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axy7K1I0pk9Ec+AA--.18880S2;
        Thu, 27 Apr 2023 15:26:45 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn, philmd@linaro.org,
        richard.henderson@linaro.org, peter.maydell@linaro.org
Subject: [PATCH RFC v2 0/9] Add loongarch kvm accel support
Date:   Thu, 27 Apr 2023 15:26:36 +0800
Message-Id: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axy7K1I0pk9Ec+AA--.18880S2
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxXF4DZFykKFWxCF43uw45Wrg_yoW5tw4kpr
        W7urn8Kr48JrZrJws5Xas8Xr45Xr4xGr9Fv3Wft34xCrZ7Zry8Zr92k39FvFW7Aa4UJFyI
        qFyrAw1DW3WUX37anT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bcAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
        0267AKxVWxJr0_GcWln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF
        6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8V
        WrMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUAVWU
        twCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26rWl4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
        67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
        8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
        wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8Jr0_Cr1UMIIF0xvEx4A2jsIEc7CjxV
        AFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvj4R_gAwDUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

Changes for RFC v2:
1. Mark the "Add KVM headers for loongarch" patch as a placeholder,
as we will use the update-linux-headers.sh to generate the kvm headers
when the linux loongarch KVM patch series are accepted.
2. Remove the DPRINTF macro in kvm.c and use trace events to replace
it, we add some trace functions such as trace_kvm_handle_exit,
trace_kvm_set_intr, trace_kvm_failed_get_csr, etc.
3. Remove the unused functions in kvm_stub.c and move stub function into
the suitable patch.

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

 linux-headers/asm-loongarch/kvm.h |  99 ++++++
 linux-headers/linux/kvm.h         |   9 +
 meson.build                       |   3 +
 target/loongarch/cpu.c            |  21 +-
 target/loongarch/cpu.h            |   3 +
 target/loongarch/kvm-stub.c       |  11 +
 target/loongarch/kvm.c            | 540 ++++++++++++++++++++++++++++++
 target/loongarch/kvm_loongarch.h  |  13 +
 target/loongarch/meson.build      |   1 +
 target/loongarch/trace-events     |  15 +
 target/loongarch/trace.h          |   1 +
 11 files changed, 711 insertions(+), 5 deletions(-)
 create mode 100644 linux-headers/asm-loongarch/kvm.h
 create mode 100644 target/loongarch/kvm-stub.c
 create mode 100644 target/loongarch/kvm.c
 create mode 100644 target/loongarch/kvm_loongarch.h
 create mode 100644 target/loongarch/trace-events
 create mode 100644 target/loongarch/trace.h

-- 
2.31.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296DB46FE6C
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 11:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239933AbhLJKLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 05:11:14 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:28301 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236504AbhLJKLO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 05:11:14 -0500
Received: from kwepemi500004.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J9RQz51xBzbkZV;
        Fri, 10 Dec 2021 18:07:23 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500004.china.huawei.com (7.221.188.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 18:07:37 +0800
Received: from huawei.com (10.174.186.236) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Fri, 10 Dec
 2021 18:07:36 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <bin.meng@windriver.com>, <fanliang@huawei.com>,
        <wu.wubin@huawei.com>, <wanghaibin.wang@huawei.com>,
        <wanbo13@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH v2 00/12] Add riscv kvm accel support
Date:   Fri, 10 Dec 2021 18:07:20 +0800
Message-ID: <20211210100732.1080-1-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.186.236]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds both riscv32 and riscv64 kvm support, and implements
migration based on riscv.

Because of RISC-V KVM has been merged into the Linux master, so this
series are changed from RFC to patch.

Several steps to use this:
1. Build emulation
$ ./configure --target-list=riscv64-softmmu
$ make -j$(nproc)

2. Build kernel

3. Build QEMU VM
Cross built in riscv toolchain.
$ PKG_CONFIG_LIBDIR=<toolchain pkgconfig path>
$ export PKG_CONFIG_SYSROOT_DIR=<toolchain sysroot path>
$ ./configure --target-list=riscv64-softmmu --enable-kvm \
--cross-prefix=riscv64-linux-gnu- --disable-libiscsi --disable-glusterfs \
--disable-libusb --disable-usb-redir --audio-drv-list= --disable-opengl \
--disable-libxml2
$ make -j$(nproc)

4. Start emulation
$ ./qemu-system-riscv64 -M virt -m 4096M -cpu rv64,x-h=true -nographic \
        -name guest=riscv-hyp,debug-threads=on \
        -smp 4 \
        -bios ./fw_jump.bin \
        -kernel ./Image \
        -drive file=./hyp.img,format=raw,id=hd0 \
        -device virtio-blk-device,drive=hd0 \
        -append "root=/dev/vda rw console=ttyS0 earlycon=sbi"

5. Start kvm-acceled QEMU VM in emulation
$ ./qemu-system-riscv64 -M virt,accel=kvm -m 1024M -cpu host -nographic \
        -name guest=riscv-guset \
        -smp 2 \
        -bios none \
        -kernel ./Image \
        -drive file=./guest.img,format=raw,id=hd0 \
        -device virtio-blk-device,drive=hd0 \
        -append "root=/dev/vda rw console=ttyS0 earlycon=sbi"

Changes since patch v1
- Rebase on recent commit a216e7cf119c91ffdf5931834a1a030ebea40d70
- Sync-up headers with Linux-5.16-rc4.
- Fixbug in kvm_arch_init_vcpu.
- Create a macro for get and put regs csr.
- Start kernel directly when kvm_enabled.
- Use riscv_cpu_set_irq to inject KVM interrupts.
- Use the Semihosting Console API for RISC-V kvm handle sbi.
- Update vmstate_riscv_cpu version id.
  Placing kvm_timer into a subsection.

Changes since RFC v6
- Rebase on recent commit 8627edfb3f1fca24a96a0954148885c3241c10f8
- Sync-up headers with Linux-5.16-rc1

Changes since RFC v5
- Rebase on QEMU v6.1.0-rc1 and kvm-riscv linux v19.
- Move kvm interrupt setting to riscv_cpu_update_mip().
- Replace __u64 with uint64_t.

Changes since RFC v4
- Rebase on QEMU v6.0.0-rc2 and kvm-riscv linux v17.
- Remove time scaling support as software solution is incomplete.
  Because it will cause unacceptable performance degradation. and
  We will post a better solution.
- Revise according to Alistair's review comments.
  - Remove compile time XLEN checks in kvm_riscv_reg_id
  - Surround TYPE_RISCV_CPU_HOST definition by CONFIG_KVM and share
    it between RV32 and RV64.
  - Add kvm-stub.c for reduce unnecessary compilation checks.
  - Add riscv_setup_direct_kernel() to direct boot kernel for KVM.

Changes since RFC v3
- Rebase on QEMU v5.2.0-rc2 and kvm-riscv linux v15.
- Add time scaling support(New patches 13, 14 and 15).
- Fix the bug that guest vm can't reboot.

Changes since RFC v2
- Fix checkpatch error at target/riscv/sbi_ecall_interface.h.
- Add riscv migration support.

Changes since RFC v1
- Add separate SBI ecall interface header.
- Add riscv32 kvm accel support.

Yifei Jiang (12):
  update-linux-headers: Add asm-riscv/kvm.h
  target/riscv: Add target/riscv/kvm.c to place the public kvm interface
  target/riscv: Implement function kvm_arch_init_vcpu
  target/riscv: Implement kvm_arch_get_registers
  target/riscv: Implement kvm_arch_put_registers
  target/riscv: Support start kernel directly by KVM
  target/riscv: Support setting external interrupt by KVM
  target/riscv: Handle KVM_EXIT_RISCV_SBI exit
  target/riscv: Add host cpu type
  target/riscv: Add kvm_riscv_get/put_regs_timer
  target/riscv: Implement virtual time adjusting with vm state changing
  target/riscv: Support virtual time context synchronization

 hw/riscv/boot.c                    |  11 +
 hw/riscv/virt.c                    |  54 ++-
 include/hw/riscv/boot.h            |   1 +
 linux-headers/asm-riscv/kvm.h      | 128 +++++++
 linux-headers/linux/kvm.h          |   8 +
 meson.build                        |   2 +
 target/riscv/cpu.c                 |  29 +-
 target/riscv/cpu.h                 |  11 +
 target/riscv/kvm-stub.c            |  30 ++
 target/riscv/kvm.c                 | 528 +++++++++++++++++++++++++++++
 target/riscv/kvm_riscv.h           |  25 ++
 target/riscv/machine.c             |  37 +-
 target/riscv/meson.build           |   1 +
 target/riscv/sbi_ecall_interface.h |  72 ++++
 14 files changed, 918 insertions(+), 19 deletions(-)
 create mode 100644 linux-headers/asm-riscv/kvm.h
 create mode 100644 target/riscv/kvm-stub.c
 create mode 100644 target/riscv/kvm.c
 create mode 100644 target/riscv/kvm_riscv.h
 create mode 100644 target/riscv/sbi_ecall_interface.h

-- 
2.19.1


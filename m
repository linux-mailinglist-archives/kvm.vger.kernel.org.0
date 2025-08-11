Return-Path: <kvm+bounces-54362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 659B6B1FEFE
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 08:11:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 50CB14E2058
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 06:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52BF328136E;
	Mon, 11 Aug 2025 06:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xjJB0Zvo"
X-Original-To: kvm@vger.kernel.org
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CA04A1E;
	Mon, 11 Aug 2025 06:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754892677; cv=none; b=Bb0MiDe78Yl/XTANetLAK4JMw8GIuJhtBpJpxJGnu+gbqlOWnSNtuNbdPzb/PpPkgIwxrqePFk4/F7HI90EXvM3rVEJ1XumL0x5ISK0VgeZmKXoHZOrIveHoViP+s3oEdBJeH6lqeWo/7iuWVZrdNP6uRTrOdTwv7qloYoUkAu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754892677; c=relaxed/simple;
	bh=6hqcPbd7JFKtnFbKjHcwWnMw1ub/LOP3ATYUlk08Pdw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=jfBYYjH4oo4dSlS0CsUY9L+tPjU7HKfEW4d/vzT9UqeGAQ0EkokThW96Bne8KzGS8Fi9hpYZ9mgW0nlUkTOTvWRb8hc+RsyO4aWsDpeR6P13qaeX68GPzH8M/w8GG9awO9CgveVjk8ADC/OHaZ7P+So6vDzRBJcxhAtzaqZd9pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xjJB0Zvo; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754892672; h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
	bh=pfo4fLXCv/YFjfBLeg1Ugb9O4azX99/n6lssJeAyHo0=;
	b=xjJB0Zvof9D9CdZQINE/GYup6ok+QPlQ7UHNl40Qwj4Ce6UfOlEENUcB4we+UErlYho3UbYs/5LU60outimazYgghsQuApiiqWf1dxKndJE5qWYEWdaP1Ur0IgdwW/hJ3rVis4PzwI7feLjYwB+0ODbZCgIiHjmFM0dSggNcGpo=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WlP-v7S_1754892668 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 Aug 2025 14:11:10 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	atishp@atishpatra.org,
	tjeznach@rivosinc.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	sunilvl@ventanamicro.com,
	rafael.j.wysocki@intel.com,
	tglx@linutronix.de,
	ajones@ventanamicro.com
Cc: guoren@linux.alibaba.com,
	guoren@kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [RFC PATCH 0/6] iommu/riscv: Add MRIF support
Date: Mon, 11 Aug 2025 14:10:58 +0800
Message-Id: <20250811061104.10326-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

According to the RISC-V IOMMU Spec, an IOMMU may optionally support
memory-resident interrupt files  (MRIFs). When the guest  interrupt 
files are used up, an MRIF can record an incoming MSI.

At present, the hypervisor has allocated an MRIF for each IMSIC, we
only need to configure the PPN of the MRIF into the MSI PTE of  the
IOMMU in MRIF mode.At the same time, we also need to configure NPPN
and NID for notice MSIs, in these patches,we use the host interrupt
(allocated  via  VFIO) as the notice MSIs, so that we don't need to 
allocate a new MSI interrupt,  and we can easily redirect the guest
interrupt back to the host interrupt when MRIF is not  supported on
the IOMMU hardware.

This RFC series are based on [1] by Andrew Jones.

Self Test:
-----------
1. Key parameters for starting host QEMU:
./qemu-system-riscv64  \
-M virt,aia=aplic-imsic,aia-guests=1 -m 8G -smp 2  \
-nographic -device riscv-iommu-pci,vendor-id=0x1efd,device-id=0x0008 \
-netdev user,id=net1,hostfwd=tcp::2323-:22 \
-device e1000e,netdev=net1 \
-drive file=./nvme_disk.qcow2,if=none,id=nvm \
-device nvme,serial=deadbeef,drive=nvm \
...

2. Steps to start a virtual machine：
# lspci
00:00.0 Host bridge: Red Hat, Inc. QEMU PCIe Host bridge
00:01.0 IOMMU: Device 1efd:0008 (rev 01)
00:02.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
00:03.0 Non-Volatile memory controller: Red Hat, Inc. QEMU NVM Express Controller (rev 02)
00:04.0 Unclassified device [0002]: Red Hat, Inc. Virtio filesystem
# echo 0000:00:02.0 > /sys/bus/pci/drivers/e1000e/unbind
# echo 0000:00:03.0 > /sys/bus/pci/drivers/nvme/unbind
# echo 8086 10d3 > /sys/bus/pci/drivers/vfio-pci/new_id
# echo 1b36 0010 > /sys/bus/pci/drivers/vfio-pci/new_id

qemu-system-riscv64 -M virt,aia=aplic-imsic --enable-kvm -m 2G -smp 4 \
-device vfio-pci,host=0000:00:02.0 \
-device vfio-pci,host=0000:00:03.0 \
...

3. Test within guest os:
root@qemu:/mnt/nvme# lspci
00:00.0 Host bridge: Red Hat, Inc. QEMU PCIe Host bridge
00:01.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
00:02.0 Non-Volatile memory controller: Red Hat, Inc. QEMU NVM Express Controller (rev 02)
root@qemu:~# mount /dev/nvme0n1p1 /mnt/nvme/
root@qemu:~# cd /mnt/nvme/
root@qemu:/mnt/nvme# ping 11.122.129.243 -i 0.1 | tee c.txt
64 bytes from 11.122.129.243: icmp_seq=18533 ttl=255 time=1.18 ms
64 bytes from 11.122.129.243: icmp_seq=18534 ttl=255 time=1.60 ms
^C
--- 11.122.129.243 ping statistics ---
18534 packets transmitted, 18534 received, 0% packet loss, time 1934380ms
rtt min/avg/max/mdev = 0.437/11.986/3451.393/118.494 ms, pipe 34

root@qemu:/mnt/nvme# cat /proc/interrupts
	CPU0       CPU1       CPU2       CPU3
10:      49856     218638     192244      58721 RISC-V INTC   5 Edge      riscv-timer
12:          0     105519          0          0 PCI-MSIX-0000:00:01.0   0 Edge      eth0-rx-0
13:          0          0      97134          0 PCI-MSIX-0000:00:01.0   1 Edge      eth0-tx-0
14:          0          0          0          2 PCI-MSIX-0000:00:01.0   2 Edge      eth0
16:          0      42752          0          0 PCI-MSIX-0000:00:02.0   0 Edge      nvme0q0
17:        376          0          0          0 PCI-MSIX-0000:00:02.0   1 Edge      nvme0q1
18:          0       1308          0          0 PCI-MSIX-0000:00:02.0   2 Edge      nvme0q2
19:          0          0      49757          0 PCI-MSIX-0000:00:02.0   3 Edge      nvme0q3
20:          0          0          0       1282 PCI-MSIX-0000:00:02.0   4 Edge      nvme0q4

[1] https://github.com/jones-drew/linux/tree/riscv/iommu-irqbypass-rfc-v2-rc1

Fangyu Yu (6):
  RISC-V: Add more elements to irqbypass vcpu_info
  RISC-V: KVM: Transfer the physical address of MRIF to iommu-ir
  RISC-V: KVM: Add a xarray to record host irq msg
  iommu/riscv: Add irq_mask and irq_ack configure for iommu-ir
  iommu/riscv: Add MRIF mode support
  RISC-V: KVM: Check the MRIF in notice MSI irq handler

 arch/riscv/include/asm/irq.h     |   3 +
 arch/riscv/kvm/aia_imsic.c       | 119 ++++++++++++++++++++++++++++---
 drivers/iommu/riscv/iommu-bits.h |   6 ++
 drivers/iommu/riscv/iommu-ir.c   |  40 +++++++++--
 4 files changed, 156 insertions(+), 12 deletions(-)

-- 
2.49.0



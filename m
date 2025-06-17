Return-Path: <kvm+bounces-49731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A196CADD7B7
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:48:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B4094A7788
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2B612F94B6;
	Tue, 17 Jun 2025 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fAUJ/AyW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3A12F365E
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178038; cv=none; b=QbBa/K/nCzlucdVFjB+TQZ9EXqMKLNZial7QldIcr3moWBij6ykCFdR35OXM0YOuExmGVckBc0S6xL+sdmQ1V9uHMykOwSHl7zyb6KAsywZgZ/wFm1JFmmQqhP5yRopTWKWc7N8EUeyewKbTI+ygDY199dRDfAXZ4tlQewbIPJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178038; c=relaxed/simple;
	bh=wePTn1Yh+2B+slQlPzIoGuSFeFcUIF2snZvqNR/cf+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S/UDb28EmnUxiQ16ZauQWjnZQnCN0QRv/Esh/ZprnpVcaIJC5FPj+aHCJXKzhQOlsPVGW0Qw0Iwzz9r/mjBW+CwtFtVVFQgp8OFrLIzkXEfI5wxSc5WIZezaytdjFJ0BWns/rXGinojVMpEm0adJ3qYTs1YAQTBrdcmwDDP8rV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fAUJ/AyW; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a589d99963so733942f8f.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750178033; x=1750782833; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7g71wEGz4iCfItRB+5Qq2e0WxZcJFHzJDCahI6238Rg=;
        b=fAUJ/AyWO3TKwq5JDzbnw4A2a2xAatC/wKvddV6HIAPWPIgqtE/3pZSyBwd5Q4WNu0
         TtiihNCJGGgoZDN8IfHLsKUSEeJ1nfmkA+tRhWfG3FMO0kKl9Q4cEDHCfc7bm4gITAjP
         zZykFv9APsMzrXvnpmf0IQ7epeDnWmmw/v5OH/mT3jFG7e1YzV5Q490EZzr1brGhEPur
         uDVii1iyYkEY8CtfqvWegR6p0YsMQWW8kgh2mDsPl1pu8WfmcMfNPuLuzxVX1b5wFVXy
         ooEwb9hIAjjfcxh1wyiG9IJUhBqPqTbOSOfuw8waoDAK9mK1poM5klKBoI+PxORp5vHA
         565Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178033; x=1750782833;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7g71wEGz4iCfItRB+5Qq2e0WxZcJFHzJDCahI6238Rg=;
        b=mUN8zx4KbPns6hC6lbUqh6bDnHS/Hfm7D4omre1ON8gs8RzbClwxzOxTsbO58yG9JZ
         NWMAfMsaMH6zF2bK35xbAMaIywYAiHYYFBA3POytuP0TARG0UNDlPVcNK5qLLzdC/mjU
         f5OwExMxwdLIMdNytk4RuEoc8nEIL+TNYLnhZ3Qdq8rf6hzq8/IxgXXg5V+MOlnIz/h/
         Yf3o3SDEmgCp4SndyvgZjJG4n+eyrh1fTcumBe5UFe7WJEEMxky9IMKot95cxW8gjLNW
         E2oF848l/zB6iBfQPvsCqmYpAQqNELVc5kD5OMc8IuR6S4Bfgze/6lNHdriwcnXiiB4e
         D16A==
X-Forwarded-Encrypted: i=1; AJvYcCXz34HNy822KoaJmLc/XjpCNMHVfs1mah3ELZULH+c3WaFzeE03D4g8N66nY05GSLA+AZY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya878XUYWcz3A/Do0h4pq29+yT5wYRUQZo2qs/VrFZZ4fOFzNo
	Np4lNKbpAr25pNhuolshSI4+nMbC6ADj1c3PhgxWTIm7srf5nOjA2za+oe+EAwvSnnXu10+0oZy
	wjMte9aI=
X-Gm-Gg: ASbGnctZ6hxLOEzyAqIqu0Jn8M2/ZFblWqQ5WzjToQtwECfC0csoHyhIrAPmscYYQPt
	aMA/E5GbGNXXW4HpIgfPA8jCk1+FAUUoj5QhWHfdcOA4TlE+ECl6+B7OpHBBPqrX9CobLuW66Ts
	huEGIx/bFbRsPRWy3nnOQFlpXQkCBaRjwjeKxkY5NiVXmEvaHdqlRCqzfZpB9CJ4ynBgN7VEV2P
	xrHE/rqfRASauVYCdrNVRzIy0BuCq7N+Q6aS/SnEUg+LP6q7NL1x5T6ODfC80q5jw2YmldE16gG
	j8aguD/9VXNgnqWl/YhTMY1i4ZJyDvwwaqWHwHNFjii9oOqUXkKJGekX1H4tDn0=
X-Google-Smtp-Source: AGHT+IGXjDEcTadgL/tfpywilh4gF6w7AoZlWcBsmeY/+2CORMJLZuFGY8Lwl3XURIT66o/5GXOVnQ==
X-Received: by 2002:a05:6000:4021:b0:3a3:6595:9209 with SMTP id ffacd0b85a97d-3a5723a3986mr12184278f8f.36.1750178033049;
        Tue, 17 Jun 2025 09:33:53 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e232e4asm178681425e9.11.2025.06.17.09.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:33:52 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id DB2275F834;
	Tue, 17 Jun 2025 17:33:51 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Cornelia Huck <cohuck@redhat.com>,
	qemu-arm@nongnu.org,
	Mark Burton <mburton@qti.qualcomm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC PATCH 00/11] kvm/arm: trap-me-harder implementation
Date: Tue, 17 Jun 2025 17:33:40 +0100
Message-ID: <20250617163351.2640572-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

The following is an RFC to explore how KVM would look if we forwarded
almost all traps back to QEMU to deal with.

Why - won't it be horribly slow?
--------------------------------

Maybe, that's why its an RFC.

Traditionally KVM tries to avoid full vmexit's to QEMU because the
additional context switches add to the latency of servicing requests.
For things like the GIC where latency really matters the normal KVM
approach is to implement it in the kernel and then just leave QEMU to
handling state saving and migration matters.

Where we have to exit, for example for device emulation, platforms
like VirtIO try really hard minimise the number of times we exit for
any data transfer.

However hypervisors can't virtualise everything and for some QEMU
use-cases you might want to run the full software stack (firmware,
hypervisor et all). This is the idea for the proposed SplitAccel where
EL1/EL0 are run under a hypervisor and EL2+ get run under TCG's
emulation. For this to work QEMU needs to be aware of the whole system
state and have full control over anything that is virtualised by the
hypervisor. We have an initial PoC for SplitAccel that works with
HVF's much simpler programming model.

This series is a precursor to implementing a SplitAccel for KVM and
investigates how hacky it might look.

Kernel
------

For this to work you need a modified kernel. You can find my tree
here:

  https://git.linaro.org/plugins/gitiles/people/alex.bennee/linux/+/refs/heads/kvm/trap-me-harder

I will be posting the kernel patches to LKML in due course but the
changes are pretty simple. We add a new creation flag
(KVM_VM_TYPE_ARM_TRAP_ALL) that when activated implement an
alternative table in KVM's handle_exit() code.

The ESR_ELx_EC_IABT_LOW/ESR_ELx_EC_DABT_LOW exceptions are still
handled by KVM as the kernel general has to deal with paging in the
required memory. I've also left the debug exceptions to be processed
in KVM as the handling of pstate gets tricky and takes care when
re-entering the guest.

Everything else exits with a new exit reason called
KVM_EXIT_ARM_TRAP_HARDER when exposed the ESR_EL1 and a few other
registers so QEMU can deal with things.

QEMU Patches
------------

Patches 1-2 - minor tweaks that make debugging easier
Patch   3   - bring in the uapi headers from Kernel
Patches 4-5 - plumbing in -accel kvm,trap-harder=on
Patches 6-7 - allow creation of an out-of-kernel GIC (kernel-irqchip=off)
Patches 8-11- trap handlers for the kvm_arm_handle_hard_trap path

Testing
-------

Currently I'm testing everything inside an emulated QEMU, so the guest
host is booted with a standard Debian Trixie although I use virtiofsd to
mount my real host home inside the guest hosts home:

  ./qemu-system-aarch64 \
             -machine type=virt,virtualization=on,pflash0=rom,pflash1=efivars,gic-version=max \
             -blockdev node-name=rom,driver=file,filename=(pwd)/pc-bios/edk2-aarch64-code.fd,read-only=true \
             -blockdev node-name=efivars,driver=file,filename=$HOME/images/qemu-arm64-efivars \
             -cpu cortex-a76 \
             -m 8192 \
             -object memory-backend-memfd,id=mem,size=8G,share=on \
             -numa node,memdev=mem \
             -smp 4 \
             -accel tcg \
             -serial mon:stdio \
             -device virtio-net-pci,netdev=unet \
             -netdev user,id=unet,hostfwd=tcp::2222-:22 \
             -device virtio-scsi-pci \
             -device scsi-hd,drive=hd \
             -blockdev driver=raw,node-name=hd,file.driver=host_device,file.filename=/dev/zen-ssd2/trixie-arm64,discard=unmap \
             -kernel /home/alex/lsrc/linux.git/builds/arm64/arch/arm64/boot/Image \
             -append "root=/dev/sda2" \
             -chardev socket,id=vfs,path=/tmp/virtiofsd.sock \
             -device vhost-user-fs-pci,chardev=vfs,tag=home \
             -display none -s -S

Inside the guest host I have built QEMU with:

  ../../configure --disable-docs \
    --enable-debug-info --extra-ldflags=-gsplit-dwarf \
    --disable-tcg --disable-xen --disable-tools \
    --target-list=aarch64-softmmu

  make qemu-system-aarch64 -j(nproc)

Even with a cut down configuration this can take awhile to build under
softmmu emulation!

And finally I can boot my guest image with:

  ./qemu-system-aarch64 \
             -machine type=virt,gic-version=3 \
             -cpu host \
             -smp 1 \
             -accel kvm,kernel-irqchip=off,trap-harder=on \
             -serial mon:stdio \
             -m 4096 \
             -kernel ~/lsrc/linux.git/builds/arm64.initramfs/arch/arm64/boot/Image \
             -append "console=ttyAMA0" \
             -display none -d unimp,trace:kvm_hypercall,trace:kvm_wfx_trap

And you can witness the system slowly booting up. Currently the system
hangs before displaying the login prompt because its not being woken
up from the WFI:

  [    0.315642] Serial: AMBA PL011 UART driver
  [    0.345625] 9000000.pl011: ttyAMA0 at MMIO 0x9000000 (irq = 13, base_baud = 0) is a PL011 rev1
  [    0.348138] printk: console [ttyAMA0] enabled
  Saving 256 bits of creditable seed for next boot
  Starting syslogd: OK
  Starting klogd: OK
  Running sysctl: OK
  Populating /dev using udev: done
  Starting system message bus: done
  Starting network: udhcpc: started, v1.37.0
  kvm_wfx_trap 0: WFI @ 0xffffffc080cf9be4

Next steps
----------

I need to figure out whats going on with the WFI failing. I also
intend to boot up my Aarch64 system and try it out on real hardware.
Then I can start looking into the actual performance and what
bottlenecks this might introduce.

Once Philippe has posted the SplitAccel RFC I can look at what it
would take to integrate this approach so we can boot a full-stack with
EL3/EL2 starting.

Alex Bennée (11):
  target/arm: allow gdb to read ARM_CP_NORAW regs (!upstream)
  target/arm: re-arrange debug_cp_reginfo
  linux-headers: Update to Linux 6.15.1 with trap-mem-harder (WIP)
  kvm: expose a trap-harder option to the command line
  target/arm: enable KVM_VM_TYPE_ARM_TRAP_ALL when asked
  kvm/arm: allow out-of kernel GICv3 to work with KVM
  target/arm: clamp value on icc_bpr_write to account for RES0 fields
  kvm/arm: plumb in a basic trap harder handler
  kvm/arm: implement sysreg trap handler
  kvm/arm: implement a basic hypercall handler
  kvm/arm: implement WFx traps for KVM

 include/standard-headers/linux/virtio_pci.h |   1 +
 include/system/kvm_int.h                    |   4 +
 linux-headers/linux/kvm.h                   |   8 +
 linux-headers/linux/vhost.h                 |   4 +-
 target/arm/kvm_arm.h                        |  17 ++
 target/arm/syndrome.h                       |   4 +
 hw/arm/virt.c                               |  18 +-
 hw/intc/arm_gicv3_common.c                  |   4 -
 hw/intc/arm_gicv3_cpuif.c                   |   5 +-
 target/arm/cpu.c                            |   2 +-
 target/arm/debug_helper.c                   |  12 +-
 target/arm/gdbstub.c                        |   6 +-
 target/arm/helper.c                         |  15 +-
 target/arm/kvm-stub.c                       |   5 +
 target/arm/kvm.c                            | 243 ++++++++++++++++++++
 hw/intc/Kconfig                             |   2 +-
 target/arm/trace-events                     |   4 +
 17 files changed, 334 insertions(+), 20 deletions(-)

-- 
2.47.2



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9AB22C177
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 10:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgGXIzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 04:55:35 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54784 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726554AbgGXIzf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 04:55:35 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D3DA38FE8846B0F92B8C;
        Fri, 24 Jul 2020 16:55:33 +0800 (CST)
Received: from huawei.com (10.174.187.31) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Jul 2020
 16:55:27 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <pbonzini@redhat.com>, <paul.walmsley@sifive.com>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>
CC:     <anup.patel@wdc.com>, <atish.patra@wdc.com>, <kvm@vger.kernel.org>,
        <kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <victor.zhangxiaofeng@huawei.com>,
        <wu.wubin@huawei.com>, <zhang.zhanghailiang@huawei.com>,
        <dengkai1@huawei.com>, <limingwang@huawei.com>,
        Yifei Jiang <jiangyifei@huawei.com>
Subject: [RFC 0/2] Add risc-v vhost-net support
Date:   Fri, 24 Jul 2020 16:54:39 +0800
Message-ID: <20200724085441.1514-1-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.187.31]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

These two patches enable support for vhost-net on RISC-V architecture. They are developed
based on the Linux source in this repo: https://github.com/avpatel/linux,
the branch is riscv_kvm_v13. 

The accompanying QEMU is from the repo: https://github.com/alistair23/qemu, the branch is
hyp-ext-v0.6.next. In order for the QEMU to work with KVM, the patch found here is necessary:
https://patchwork.kernel.org/cover/11435965/

Several steps to use this:

1. create virbr0 on riscv64 emulation
$ brctl addbr virbr0
$ brctl stp virbr0 on
$ ifconfig virbr0 up
$ ifconfig virbr0 <virbr0_ip> netmask <virbr0_netmask>

2. boot riscv64 guestOS on riscv64 emulation
$ ./qemu-system-riscv64 -M virt,accel=kvm -m 1024M -cpu host -nographic \
	-name guest=riscv-guest \
	-smp 2 \
	-kernel ./Image \
	-drive file=./guest.img,format=raw,id=hd0 \
	-device virtio-blk,drive=hd0 \
	-netdev type=tap,vhost=on,script=./ifup.sh,downscript=./ifdown.sh,id=net0 \
	-append "root=/dev/vda rw console=ttyS0 earlycon=sbi"

$ cat ifup.sh
#!/bin/sh
brctl addif virbr0 $1
ifconfig $1 up

$ cat ifdown.sh
#!/bin/sh
ifconfig $1 down
brctl delif virbr0 $1

This brenchmark is vhost-net compare with virtio:

$ ./netperf -H <virbr0_ip> -l 100 -t TCP_STREAM

vhost-net:
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

131072  16384  16384    100.07    457.55

virtio:
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

131072  16384  16384    100.07    227.02


The next step is to support irqfd on RISC-V architecture.

Yifei Jiang (2):
  RISC-V: KVM: enable ioeventfd capability and compile for risc-v
  RISC-V: KVM: read\write kernel mmio device support

 arch/riscv/kvm/Kconfig     |  2 ++
 arch/riscv/kvm/Makefile    |  2 +-
 arch/riscv/kvm/vcpu_exit.c | 38 ++++++++++++++++++++++++++++++++------
 arch/riscv/kvm/vm.c        |  1 +
 4 files changed, 36 insertions(+), 7 deletions(-)

-- 
2.19.1



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBB6B4E01
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 14:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfIQMkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 08:40:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2287 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727534AbfIQMkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 08:40:23 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D6BF79037DC9BDF6755F;
        Tue, 17 Sep 2019 20:40:19 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.32) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Tue, 17 Sep 2019
 20:40:10 +0800
Subject: Re: [PATCH v18 0/6] Add ARMv8 RAS virtualization support in QEMU
To:     <pbonzini@redhat.com>, <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>,
        <gengdongjiu@huawei.com>, <mtosatti@redhat.com>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <jonathan.cameron@huawei.com>,
        <xuwei5@huawei.com>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <linuxarm@huawei.com>
CC:     <wanghaibin.wang@huawei.com>
References: <20190906083152.25716-1-zhengxiang9@huawei.com>
From:   Xiang Zheng <zhengxiang9@huawei.com>
Message-ID: <997a7f78-9ade-a107-8f83-de5dde85e483@huawei.com>
Date:   Tue, 17 Sep 2019 20:39:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190906083152.25716-1-zhengxiang9@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.32]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

This patch series has been tested for both TCG and KVM scenes.

1) Test for TCG:
   - Re-compile qemu after applying the patch refered to https://patchwork.kernel.org/cover/10942757/#22640271).
   - Use command line shown below to start qemu:
        ./qemu-system-aarch64 \
                -name guest=ras \
                -machine virt,gic-version=3,ras=on \
                -cpu cortex-a57 \
                -bios /usr/share/edk2/aarch64/QEMU_EFI.fd \
                -nodefaults \
                -kernel ${GUEST_KERNEL} \
                -initrd ${GUEST_FS} \
                -append "rdinit=init console=ttyAMA0 earlycon=pl011,0x9000000" \
                -m 8192 \
                -smp 4 \
                -serial stdio \

   - Send a signal to one of the VCPU threads:
        kill -s SIGBUS 71571

   - The result of test is shown below:

    [   41.194753] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 0
    [   41.197329] {1}[Hardware Error]: event severity: recoverable
    [   41.199078] {1}[Hardware Error]:  Error 0, type: recoverable
    [   41.200829] {1}[Hardware Error]:   section_type: memory error
    [   41.202603] {1}[Hardware Error]:   physical_address: 0x00000000400a1000
    [   41.204649] {1}[Hardware Error]:   error_type: 0, unknown
    [   41.206328] EDAC MC0: 1 UE Unknown on unknown label ( page:0x400a1 offset:0x0 grain:0)
    [   41.208788] Internal error: synchronous external abort: 96000410 [#1] SMP
    [   41.210879] Modules linked in:
    [   41.211823] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 4.19.0+ #8
    [   41.213698] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
    [   41.215812] pstate: 60c00085 (nZCv daIf +PAN +UAO)
    [   41.217296] pc : cpu_do_idle+0x8/0xc
    [   41.218400] lr : arch_cpu_idle+0x2c/0x1b8
    [   41.219629] sp : ffff000009f9bf00
    [   41.220649] x29: ffff000009f9bf00 x28: 0000000000000000
    [   41.222310] x27: 0000000000000000 x26: ffff8001fe471d80
    [   41.223945] x25: 0000000000000000 x24: ffff00000937ba38
    [   41.225581] x23: ffff0000090b3338 x22: ffff000009379000
    [   41.227220] x21: ffff00000937b000 x20: 0000000000000004
    [   41.228871] x19: ffff0000090a6000 x18: 0000000000000000
    [   41.230517] x17: 0000000000000000 x16: 0000000000000000
    [   41.232165] x15: 0000000000000000 x14: 0000000000000000
    [   41.233810] x13: ffff0000089f4da8 x12: 000000000000000e
    [   41.235448] x11: ffff0000089f4d80 x10: 0000000000000af0
    [   41.237101] x9 : ffff000009f9be80 x8 : ffff8001fe4728d0
    [   41.238738] x7 : 0000000000000004 x6 : ffff8001fffbaf30
    [   41.240380] x5 : ffff00000c43b940 x4 : 00008001f6f0c000
    [   41.242030] x3 : 0000000000000001 x2 : ffff000009f9bf00
    [   41.243666] x1 : ffff8001fffb82c8 x0 : ffff0000090a6018
    [   41.245306] Process swapper/2 (pid: 0, stack limit = 0x(____ptrval____))
    [   41.247378] Call trace:
    [   41.248117]  cpu_do_idle+0x8/0xc
    [   41.249111]  do_idle+0x1dc/0x2a8
    [   41.250111]  cpu_startup_entry+0x28/0x30
    [   41.251319]  secondary_start_kernel+0x180/0x1c8
    [   41.252725] Code: a8c17bfd d65f03c0 d5033f9f d503207f (d65f03c0)
    [   41.254606] ---[ end trace 221bc8a614fb5a1d ]---
    [   41.256030] Kernel panic - not syncing: Fatal exception
    [   41.257644] SMP: stopping secondary CPUs
    [   41.258912] Kernel Offset: disabled
    [   41.260011] CPU features: 0x0,22a00238
    [   41.261178] Memory Limit: none
    [   41.262122] ---[ end Kernel panic - not syncing: Fatal exception ]---

2) Test for KVM:
   - Use command line shown below to start qemu:
        ./qemu-system-aarch64 \
            -name guest=ras \
            -machine virt,accel=kvm,gic-version=3,ras=on \
            -cpu host \
            -bios /usr/share/edk2/aarch64/QEMU_EFI.fd \
            -nodefaults \
            -kernel ${GUEST_KERNEL} \
            -initrd ${GUEST_FS} \
            -append "rdinit=init console=ttyAMA0 earlycon=pl011,0x9000000" \
            -m 8192 \
            -smp 4 \
            -serial stdio \

   - Run mca-recover and get the GPA(IPA) of allocated page which would be corrupted on the later.
   - Convert the GPA to HPA and corrupt this HPA via APEI/EINJ.
   - Go back to guest and continue to read this page.

   - The result of test is shown below:

    root@genericarmv8:~/tools# ./mca-recover
    pagesize: 0x1000
    before clear cache
    flags for page 0x2317b2: uptodate active mmap anon swapbacked
    vtop(0xffff9c9e8000) = 0x2317b2000
    Hit any key to access: before read

    after read
    Access at Tue Sep 17 01:41:14 2019

    flags for page 0x2317b2: uptodate active mmap anon swapbacked
    [  403.298539] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 0
    [  403.301421] {1}[Hardware Error]: event severity: recoverable
    [  403.303217] {1}[Hardware Error]:  Error 0, type: recoverable
    [  403.304920] {1}[Hardware Error]:   section_type: memory error
    [  403.306645] {1}[Hardware Error]:   physical_address: 0x00000002317b2000
    [  403.308947] {1}[Hardware Error]:   error_type: 0, unknown
    [  403.310630] WARNING: CPU: 0 PID: 510 at drivers/edac/ghes_edac.c:202 ghes_edac_report_mem_error+0x648/0xb20
    [  403.310630] Modules linked in:
    [  403.310631] CPU: 0 PID: 510 Comm: mca-recover Not tainted 4.19.0+ #8
    [  403.310632] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
    [  403.310632] pstate: 60000005 (nZCv daif -PAN -UAO)
    [  403.310632] pc : ghes_edac_report_mem_error+0x648/0xb20
    [  403.310633] lr : ghes_proc+0x3d8/0x950
    [  403.310633] sp : ffff00000c543b20
    [  403.310633] x29: ffff00000c543b50 x28: ffff8001f5918014
    [  403.310634] x27: 0000000000000000 x26: b1837ced833e63b8
    [  403.310635] x25: 430fbbc1d995e954 x24: 0000000000000002
    [  403.310636] x23: 0000000000000002 x22: ffff0000096ec000
    [  403.310637] x21: ffff000009379000 x20: ffff8001f591805c
    [  403.310638] x19: ffff8001f591e71c x18: ffffffffffffffff
    [  403.310638] x17: 0000000000000000 x16: 0000000000000000
    [  403.310639] x15: ffff000009379708 x14: 0000000000000000
    [  403.310640] x13: 0000000000000002 x12: 317b200000000000
    [  403.310641] x11: 0000000000000000 x10: 0000400200000000
    [  403.310642] x9 : 0000000000000000 x8 : 00000002540be3ff
    [  403.310642] x7 : 0000000000000000 x6 : ffff0000096dce30
    [  403.310643] x5 : 4ede6f64a5bc1114 x4 : 0000000000000000
    [  403.310644] x3 : ffff0000096ec4f0 x2 : ffff8001f591805c
    [  403.310645] x1 : 0000000000000000 x0 : 0000000000110000
    [  403.310646] Call trace:
    [  403.310646]  ghes_edac_report_mem_error+0x648/0xb20
    [  403.310646]  ghes_proc+0x3d8/0x950
    [  403.310647]  ghes_notify_sea+0x3c/0x68
    [  403.310647]  do_sea+0x9c/0x188
    [  403.310647]  do_mem_abort+0x74/0x140
    [  403.310648]  el0_da+0x24/0x28
    [  403.310648] ---[ end trace 651f1abaa6b1de2d ]---
    Recover: sig=7 si=0xffffc9bc5640 v=0xffffc9bc56c0[  403.364295] Memory failure: 0x2317b2: recovery action for dirty LRU page: Recovered
    [  403.364295] Memory failure: 0x2317b2: recovery action for dirty LRU page: Recovered

    Platform memory error at 0x(nil)
    Addr = (nil) lsb=0
    Recovery allocated new page at physical 0x232563000
    Got 2a2a2a2a


-- 

Thanks,
Xiang


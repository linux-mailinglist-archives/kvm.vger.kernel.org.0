Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727DD326CEA
	for <lists+kvm@lfdr.de>; Sat, 27 Feb 2021 12:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhB0Ls1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Feb 2021 06:48:27 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13096 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhB0Ls0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Feb 2021 06:48:26 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dnl8p0CZjz16D1Z;
        Sat, 27 Feb 2021 19:46:02 +0800 (CST)
Received: from localhost (10.174.150.118) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Sat, 27 Feb 2021
 19:47:31 +0800
From:   <ann.zhuangyanying@huawei.com>
To:     <pbonzini@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <weidong.huang@huawei.com>,
        Zhuang Yanying <ann.zhuangyanying@huawei.com>
Subject: [PATCH] KVM: x86: fix Hot-plugged cpu hang when Configured tsc-frequency is not equal to host
Date:   Sat, 27 Feb 2021 19:47:27 +0800
Message-ID: <20210227114728.44948-1-ann.zhuangyanying@huawei.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.150.118]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhuang Yanying <ann.zhuangyanying@huawei.com>

If the TSC frequency of the VM is not equal to the host, hot-plugging vCPU
will cause the VM to be hang. The time of hang depends on the current TSC
value of the VM.

During hot-plugging vCPUs, kvm_arch_vcpu_create() uses max_tsc_khz,
that is the host TSC frequency, to initialize TSC frequency of the vcpu.
Then, configure the target frequency by using KVM_SET_TSC_KHZ.
Set the tsc valus of the vCPU to 0 by using MSR_IA32_TSC.

If the vCPU TSC frequency is the same as the host, kvm_synchronize_tsc()
adjusts the TSC value of the hot-plugged vCPU based on the elapsed time.
However, when the vCPU TSC frequency is different from the host,
the TSC value of the hot-plugged vCPU is 0 and is displayed to the guest
OS, trigger tsc adjustment. As a result, the guest OS marks TSC unstable
and hangs for a while.

The TSC frequency of the same CPU model may differ slightly.
After live migration, hot-plugging vCPU to the Destination VM, trigger the
VM hangs for a long while. After CPU supports TSC scaling, the TSC value
of the hot-plugged vCPU can be adjusted based on the elapsed time
even if the VM TSC frequency is different from the host TSC frequency.

kvm->arch.last_tsc_khz stores the TSC frequency value of the VM.
last_tsc_khz can be used to initialize the TSC frequency of the
hot-plugging vCPU.

Signed-off-by: Zhuang Yanying <ann.zhuangyanying@huawei.com>
---
 Host:
  Intel(R) Xeon(R) Gold 6161 CPU @ 2.20GHz
  linux-5.11
  qemu-5.1
    <cpu mode='host-passthrough' check='none'>
      <feature policy='require' name='invtsc'/>
    </cpu>
    <clock offset='utc'>
      <timer name='hpet' present='no'/>
      <timer name='pit' tickpolicy='delay'/>
      <timer name='tsc' frequency='3000000000'/>
    </clock>
 Guest:
  entos8.1 (4.18.0-147.el8.x86_6)

 After Hotplug cpu, vm hang for 290s:
  [  283.224026] CPU3 has been hot-added
  [  283.226118] smpboot: Booting Node 0 Processor 3 APIC 0x3
  [  283.226964] kvm-clock: cpu 3, msr 9e5e010c1, secondary cpu clock
  [  283.247200] TSC ADJUST compensate: CPU3 observed 867529151959 warp. Adjust: 867529151959
  [  572.445543] KVM setup async PF for cpu 3
  [  572.446412] kvm-stealtime: cpu 3, msr a16ce5040
  [  572.448108] Will online and init hotplugged CPU: 3
  Feb 27 18:47:28 localhost kernel: CPU3 has been hot-added
  Feb 27 18:47:28 localhost kernel: smpboot: Booting Node 0 Processor 3 APIC 0x3
  Feb 27 18:47:28 localhost kernel: kvm-clock: cpu 3, msr 9e5e010c1, secondary cpu clock
  Feb 27 18:47:28 localhost kernel: TSC ADJUST compensate: CPU3 observed 867529151959 warp. Adjust: 867529151959
  Feb 27 18:47:28 localhost kernel: KVM setup async PF for cpu 3
  Feb 27 18:47:28 localhost kernel: kvm-stealtime: cpu 3, msr a16ce5040
  Feb 27 18:47:28 localhost kernel: Will online and init hotplugged CPU: 3
  Feb 27 18:47:28 localhost systemd[1]: Started /usr/lib/udev/kdump-udev-throttler.
  [  572.495181] clocksource: timekeeping watchdog on CPU2: Marking clocksource 'tsc' as unstable because the skew is too large:
  [  572.495181] clocksource:                       'kvm-clock' wd_now: 86ab1286a2 wd_last: 4344b44d09 mask: ffffffffffffffff
  [  572.495181] clocksource:                       'tsc' cs_now: ca313c563b cs_last: c9d88b54d2 mask: ffffffffffffffff
  [  572.495181] tsc: Marking TSC unstable due to clocksource watchdog
  [  572.495181] clocksource: Switched to clocksource kvm-clock
  Feb 27 18:47:28 localhost kernel: clocksource: timekeeping watchdog on CPU2: Marking clocksource 'tsc' as unstable because the skew 
  Feb 27 18:47:28 localhost kernel: clocksource:                       'kvm-clock' wd_now: 86ab1286a2 wd_last: 4344b44d09 mask: ffffff
  Feb 27 18:47:28 localhost kernel: clocksource:                       'tsc' cs_now: ca313c563b cs_last: c9d88b54d2 mask: ffffffffffff
  Feb 27 18:47:28 localhost kernel: tsc: Marking TSC unstable due to clocksource watchdog
  Feb 27 18:47:28 localhost kernel: clocksource: Switched to clocksource kvm-clock
  Feb 27 18:47:28 localhost systemd[1]: Started Getty on tty2.
  Feb 27 18:47:29 localhost kdump-udev-throttler[3530]: kexec: unloaded kdump kernel
  Feb 27 18:47:29 localhost kdump-udev-throttler[3530]: Stopping kdump: [OK]
  Feb 27 18:47:29 localhost kdump-udev-throttler[3530]: kexec: loaded kdump kernel
  Feb 27 18:47:29 localhost kdump-udev-throttler[3530]: Starting kdump: [OK]

---
 arch/x86/kvm/x86.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b404e4d7dd8..c3c62a9865d3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9952,7 +9952,12 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	else
 		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
 
-	kvm_set_tsc_khz(vcpu, max_tsc_khz);
+	if (vcpu->kvm->arch.last_tsc_khz)
+		r = kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.last_tsc_khz);
+	else
+		r = kvm_set_tsc_khz(vcpu, max_tsc_khz);
+	if (r < 0)
+		return r;
 
 	r = kvm_mmu_create(vcpu);
 	if (r < 0)
-- 
2.23.0


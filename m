Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5252D32C5FC
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345349AbhCDA1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:27:10 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13849 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352972AbhCCLzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 06:55:43 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DrC6K3q7Yz7rxF;
        Wed,  3 Mar 2021 19:52:25 +0800 (CST)
Received: from localhost (10.174.150.118) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.498.0; Wed, 3 Mar 2021
 19:54:00 +0800
From:   <ann.zhuangyanying@huawei.com>
To:     <pbonzini@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <weidong.huang@huawei.com>,
        Zhuang Yanying <ann.zhuangyanying@huawei.com>
Subject: [PATCH] KVM: x86: fix cpu hang due to tsc adjustment when kvmclock in use
Date:   Wed, 3 Mar 2021 19:53:57 +0800
Message-ID: <20210303115357.7464-1-ann.zhuangyanying@huawei.com>
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

System time calculation of kvmclock is based on (tsc_timestamp, system_time),
and adjusted by delta ( = rdtsc_ordered() - src->tsc_timestamp).The tsc of the
hotplugged cpu is initialized to 0, which will trigger check_tsc_sync_target()
to adjust the tsc of the hotplugged cpu according to another online cpu, that
is, rdtsc_ordered() will change abruptly to a large value. Then system time
based on kvmclock is modified at the same time.

So after modifying the tsc offset, update vcpu->hv_clock immediately.
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
  Centos8.1 (4.18.0-147.el8.x86_64)

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
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3712bb5245eb..429206d65989 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3078,6 +3078,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (!msr_info->host_initiated) {
 				s64 adj = data - vcpu->arch.ia32_tsc_adjust_msr;
 				adjust_tsc_offset_guest(vcpu, adj);
+				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 			}
 			vcpu->arch.ia32_tsc_adjust_msr = data;
 		}
-- 
2.23.0


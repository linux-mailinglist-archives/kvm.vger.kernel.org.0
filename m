Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417F136D081
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 04:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239555AbhD1CWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 22:22:47 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:40121 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235422AbhD1CWr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 22:22:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=zelin.deng@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UX10nnq_1619576521;
Received: from localhost(mailfrom:zelin.deng@linux.alibaba.com fp:SMTPD_---0UX10nnq_1619576521)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 28 Apr 2021 10:22:01 +0800
From:   Zelin Deng <zelin.deng@linux.alibaba.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Subject: [PATCH] Guest system time jumps when new vCPUs is hot-added
Date:   Wed, 28 Apr 2021 10:22:00 +0800
Message-Id: <1619576521-81399-1-git-send-email-zelin.deng@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,
I have below VM configuration:
...
    <vcpu placement='static' current='1'>2</vcpu>
    <cpu mode='host-passthrough'>
    </cpu>
    <clock offset='utc'>
        <timer name='tsc' frequency='3000000000'/>
    </clock>
...
After VM has been up for a few minutes, I use "virsh setvcpus" to hot-add
second vCPU into VM, below dmesg is observed:
[   53.273484] CPU1 has been hot-added
[   85.067135] SMP alternatives: switching to SMP code
[   85.078409] x86: Booting SMP configuration:
[   85.079027] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   85.080240] kvm-clock: cpu 1, msr 77601041, secondary cpu clock
[   85.080450] smpboot: CPU 1 Converting physical 0 to logical die 1
[   85.101228] TSC ADJUST compensate: CPU1 observed 169175101528 warp. Adjust: 169175101528
[  141.513496] TSC ADJUST compensate: CPU1 observed 166 warp. Adjust: 169175101694
[  141.513496] TSC synchronization [CPU#0 -> CPU#1]:
[  141.513496] Measured 235 cycles TSC warp between CPUs, turning off TSC clock.
[  141.513496] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[  141.543996] KVM setup async PF for cpu 1
[  141.544281] kvm-stealtime: cpu 1, msr 13bd2c080
[  141.549381] Will online and init hotplugged CPU: 1

System time jumps from 85.101228 to 141.51.3496.

Guest:                                   KVM
-----                                    ------
check_tsc_sync_target()
wrmsrl(MSR_IA32_TSC_ADJUST,...)
                                         kvm_set_msr_common(vcpu,...)
                                         adjust_tsc_offset_guest(vcpu,...) //tsc_offset jumped
                                         vcpu_enter_guest(vcpu) //tsc_timestamp was not changed
...
rdtsc() jumped, system time jumped

tsc_timestamp must be updated before go back to guest.

---
Zelin Deng (1):
  KVM: x86: Update vCPU's hv_clock before back to guest when tsc_offset
    is adjusted

 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

-- 
1.8.3.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207FD1F0068
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 21:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgFET0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 15:26:09 -0400
Received: from mga03.intel.com ([134.134.136.65]:18768 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbgFET0I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 15:26:08 -0400
IronPort-SDR: n3I0NnNI4r1LG2DD5PeoMLoXXrZssg+o73LbOn/XqoUXeGqMbpiFaT5j6DCGPPiy3UsCLAZErb
 9vob7FAtucSg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 12:26:07 -0700
IronPort-SDR: N8mvhEuF9Yca0EaUBhaf8fWySQ/j2CY/8kTmbLZhcDGBSiIsoZYSuPht8u0/Gm0igCQOpET3+p
 L2ywfryHylKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; 
   d="scan'208";a="313279638"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Jun 2020 12:26:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] x86/split_lock: Don't write MSR_TEST_CTRL on CPUs that aren't whitelisted
Date:   Fri,  5 Jun 2020 12:26:05 -0700
Message-Id: <20200605192605.7439-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Choo! Choo!  All aboard the Split Lock Express, with direct service to
Wreckage!

Skip split_lock_verify_msr() if the CPU isn't whitelisted as a possible
SLD-enabled CPU model to avoid writing MSR_TEST_CTRL.  MSR_TEST_CTRL
exists, and is writable, on many generations of CPUs.  Writing the MSR,
even with '0', can result in bizarre, undocumented behavior.

This fixes a crash on Haswell when resuming from suspend with a live KVM
guest.  Because APs use the standard SMP boot flow for resume, they will
go through split_lock_init() and the subsequent RDMSR/WRMSR sequence,
which runs even when sld_state==sld_off to ensure SLD is disabled.  On
Haswell (at least, my Haswell), writing MSR_TEST_CTRL with '0' will
succeed and _may_ take the SMT _sibling_ out of VMX root mode.

When KVM has an active guest, KVM performs VMXON as part of CPU onlining
(see kvm_starting_cpu()).  Because SMP boot is serialized, the resulting
flow is effectively:

  on_each_ap_cpu() {
     WRMSR(MSR_TEST_CTRL, 0)
     VMXON
  }

As a result, the WRMSR can disable VMX on a different CPU that has
already done VMXON.  This ultimately results in a #UD on VMPTRLD when
KVM regains control and attempt run its vCPUs.

The above voodoo was confirmed by reworking KVM's VMXON flow to write
MSR_TEST_CTRL prior to VMXON, and to serialize the sequence as above.
Further verification of the insanity was done by redoing VMXON on all
APs after the initial WRMSR->VMXON sequence.  The additional VMXON,
which should VM-Fail, occasionally succeeded, and also eliminated the
unexpected #UD on VMPTRLD.

The damage done by writing MSR_TEST_CTRL doesn't appear to be limited
to VMX, e.g. after suspend with an active KVM guest, subsequent reboots
almost always hang (even when fudging VMXON), a #UD on a random Jcc was
observed, suspend/resume stability is qualitatively poor, and so on and
so forth.

  kernel BUG at arch/x86/kvm/x86.c:386!
  invalid opcode: 0000 [#7] SMP
  CPU: 1 PID: 2592 Comm: CPU 6/KVM Tainted: G      D
  Hardware name: ASUS Q87M-E/Q87M-E, BIOS 1102 03/03/2014
  RIP: 0010:kvm_spurious_fault+0xf/0x20
  Code: <0f> 0b 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
  RSP: 0018:ffffc0bcc1677b78 EFLAGS: 00010246
  RAX: 0000617640000000 RBX: ffff9e8d01d80000 RCX: ffff9e8d4fa40000
  RDX: ffff9e8d03360000 RSI: 00000003c3360000 RDI: ffff9e8d03360000
  RBP: 0000000000000001 R08: ffff9e8d046d9d40 R09: 0000000000000018
  R10: ffffc0bcc1677b80 R11: 0000000000000008 R12: 0000000000000006
  R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
  FS:  00007fe16c9f9700(0000) GS:ffff9e8d4fa40000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000d7a418 CR3: 00000003c47b1006 CR4: 00000000001626e0
  Call Trace:
   vmx_vcpu_load_vmcs+0x1fb/0x2b0
   vmx_vcpu_load+0x3e/0x160
   kvm_arch_vcpu_load+0x48/0x260
   finish_task_switch+0x140/0x260
   __schedule+0x460/0x720
   _cond_resched+0x2d/0x40
   kvm_arch_vcpu_ioctl_run+0x82e/0x1ca0
   kvm_vcpu_ioctl+0x363/0x5c0
   ksys_ioctl+0x88/0xa0
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x4c/0x170
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Fixes: dbaba47085b0c ("x86/split_lock: Rework the initialization flow of split lock detection")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index a19a680542ce..19b6c42739fc 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -48,6 +48,13 @@ enum split_lock_detect_state {
 static enum split_lock_detect_state sld_state __ro_after_init = sld_off;
 static u64 msr_test_ctrl_cache __ro_after_init;
 
+/*
+ * With a name like MSR_TEST_CTL it should go without saying, but don't touch
+ * MSR_TEST_CTL unless the CPU is one of the whitelisted models.  Writing it
+ * on CPUs that do not support SLD can cause fireworks, even when writing '0'.
+ */
+static bool cpu_model_supports_sld __ro_after_init;
+
 /*
  * Processors which have self-snooping capability can handle conflicting
  * memory type across CPUs by snooping its own cache. However, there exists
@@ -1064,7 +1071,8 @@ static void sld_update_msr(bool on)
 
 static void split_lock_init(void)
 {
-	split_lock_verify_msr(sld_state != sld_off);
+	if (cpu_model_supports_sld)
+		split_lock_verify_msr(sld_state != sld_off);
 }
 
 static void split_lock_warn(unsigned long ip)
@@ -1167,5 +1175,6 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
 		return;
 	}
 
+	cpu_model_supports_sld = true;
 	split_lock_setup();
 }
-- 
2.26.0


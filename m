Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAC053F76F
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 09:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237811AbiFGHl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 03:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237786AbiFGHlO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 03:41:14 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F39C0E2F;
        Tue,  7 Jun 2022 00:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654587673; x=1686123673;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=How5rmbKAZ2kYixk5dQn1Fze/2T67ol4x10tFqv+4rg=;
  b=IZ1E65HbsL4RHLdFVJMAMZSaYxJQaaKfSGncB9D8rRVyKBbBwCl4SgPX
   uFaA+B9s+Nr9jkNRAPMZI2A6eW8SfnWq8pErevn3miikoMPNYkwd3xIWK
   LUYkGau+qksp4IzYRcQsOOvFoXV/wVOSkPQ6VeNkKusp6jA4Q5ktsQcDi
   3wAlmNieL1CiQhhlp8lrdZqbFgCCWJawsIplsc+SP8FzUW2g0X4pOJKtn
   Yef/eeFobWcVTQA9RGVkIbl7tKAOFkevCijLfXQeBUE0Lc447LHhOSSVG
   ZdF9k0N4Z2k+OYnjpLiZq7ZnL7UzmG6VUCPn1D6YM9kI8V0e9R3xTGS+3
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10370"; a="265003769"
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="265003769"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 00:40:53 -0700
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="647915450"
Received: from sqa-gate.sh.intel.com (HELO embargo.tsp.org) ([10.239.48.212])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 00:40:51 -0700
From:   Yuan Yao <yuan.yao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kai Huang <kai.huang@intel.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [PATCH 1/1] KVM: MMU: Fix VM entry failure and OOPS for shdaow page table
Date:   Tue,  7 Jun 2022 15:40:34 +0800
Message-Id: <20220607074034.7109-1-yuan.yao@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit e54f1ff244ac ("KVM: x86/mmu: Add shadow_me_value and
repurpose shadow_me_mask") repurposed below varables:

shadow_me_value: the memory encryption bit(s) that will be
set to the SPTE (the original shadow_me_mask).
shadow_me_mask: all possible memory encryption bits (which
is a super set of shadow_me_value).

So assign shadow_me_mask to pae root page is wrong, instead
using shadow_me_value.

Fixes: e54f1ff244ac ("KVM: x86/mmu: Add shadow_me_value and repurpose shadow_me_mask")

----------------------
KVM: entry failed, hardware error 0x80000021

If you're running a guest on an Intel machine without unrestricted mode
support, the failure can be most likely due to the guest entering an invalid
state for Intel VT. For example, the guest maybe running in big real mode
which is not supported on less recent Intel processors.

EAX=00000000 EBX=00000000 ECX=00000000 EDX=000806f3
ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
EIP=0000e05b EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 00000000 0000ffff 00009300
CS =f000 000f0000 0000ffff 00009b00
SS =0000 00000000 0000ffff 00009300
DS =0000 00000000 0000ffff 00009300
FS =0000 00000000 0000ffff 00009300
GS =0000 00000000 0000ffff 00009300
LDT=0000 00000000 0000ffff 00008200
TR =0000 00000000 0000ffff 00008b00
GDT=     00000000 0000ffff
IDT=     00000000 0000ffff
CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000000
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000000
Code=8c 0a 14 28 3c 50 64 c8 66 90 66 90 66 90 66 90 66 90 66 90 <2e> 66 83 3e c8 61 00 0f 85 89 f0 31 d2 8e d2 66 bc 00 70 00 00 66 ba 63 fc 0e 00 e9 f3 ee

----------------------
[   80.806596] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
[  293.504118] BUG: unable to handle page fault for address: ffd43f00063049e8
[  293.515075] #PF: supervisor read access in kernel mode
[  293.524031] #PF: error_code(0x0000) - not-present page
[  293.532935] PGD 86dfd8067 P4D 0
[  293.539626] Oops: 0000 [#1] PREEMPT SMP
[  293.546958] CPU: 164 PID: 4260 Comm: qemu-system-x86 Tainted: G        W         5.18.0-rc6-kvm-upstream-workaround+ #82
[  293.565354] Hardware name: Intel Corporation ArcherCity/ArcherCity, BIOS EGSDCRB1.86B.0069.D14.2111291356 11/29/2021
[  293.583639] RIP: 0010:mmu_free_root_page+0x3c/0x90 [kvm]
[  293.592911] Code: 25 28 00 00 00 48 89 45 f0 31 c0 48 8b 06 48 83 f8 ff 74 4a 48 c1 e0 0c 48 89 f3 48 c1 e8 18 48 c1 e0 06 48 03 05 e4 08 20 c2 <48> 8b 70 28 48 85 f6 74 41 80 7e 20 00 75 17 83 6e 48 01 75 18 f6
[  293.624056] RSP: 0018:ffa000000b3afb88 EFLAGS: 00010286
[  293.633326] RAX: ffd43f00063049c0 RBX: ff110000777ff000 RCX: 0000000000000001
[  293.644758] RDX: ffa000000b3afbc8 RSI: ff110000777ff000 RDI: ffa000000c211000
[  293.656132] RBP: ffa000000b3afba0 R08: 0000000000000100 R09: ffa000000b3afbe0
[  293.667480] R10: ffa000000b3afbe0 R11: 0000000000000000 R12: ffa000000c211000
[  293.678771] R13: ffa000000b3afbc8 R14: ff11000112e9c290 R15: 00000000ffffffef
[  293.690069] FS:  0000000000000000(0000) GS:ff1100084e300000(0000) knlGS:0000000000000000
[  293.702514] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  293.712338] CR2: ffd43f00063049e8 CR3: 000000000260a006 CR4: 0000000000773ee0
[  293.723802] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  293.735230] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
[  293.746597] PKRU: 55555554
[  293.752962] Call Trace:
[  293.758978]  <TASK>
[  293.764579]  kvm_mmu_free_roots+0xd1/0x200 [kvm]
[  293.773060]  __kvm_mmu_unload+0x29/0x70 [kvm]
[  293.781177]  kvm_mmu_unload+0x13/0x20 [kvm]
[  293.789012]  kvm_arch_destroy_vm+0x8a/0x190 [kvm]
[  293.797355]  kvm_put_kvm+0x197/0x2d0 [kvm]
[  293.804925]  kvm_vm_release+0x21/0x30 [kvm]
[  293.812499]  __fput+0x8e/0x260
[  293.818715]  ____fput+0xe/0x10
[  293.824822]  task_work_run+0x6f/0xb0
[  293.831433]  do_exit+0x327/0xa90
[  293.837586]  ? futex_unqueue+0x3f/0x70
[  293.844283]  do_group_exit+0x35/0xa0
[  293.850770]  get_signal+0x911/0x930
[  293.857137]  arch_do_signal_or_restart+0x37/0x720
[  293.864896]  ? do_futex+0xf9/0x1a0
[  293.871139]  ? __x64_sys_futex+0x66/0x160
[  293.878001]  exit_to_user_mode_prepare+0xb2/0x140
[  293.885576]  syscall_exit_to_user_mode+0x16/0x30
[  293.892973]  do_syscall_64+0x4e/0x90
[  293.899162]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  293.906972] RIP: 0033:0x7f6c844f752d
[  293.913050] Code: Unable to access opcode bytes at RIP 0x7f6c844f7503.
[  293.922442] RSP: 002b:00007f6c7fbfe648 EFLAGS: 00000212 ORIG_RAX: 00000000000000ca
[  293.933048] RAX: fffffffffffffe00 RBX: 0000000000000000 RCX: 00007f6c844f752d
[  293.943161] RDX: 00000000ffffffff RSI: 0000000000000000 RDI: 0000557dd5a1ac58
[  293.953281] RBP: 00007f6c7fbfe670 R08: 0000000000000000 R09: 0000000000000000
[  293.963401] R10: 0000000000000000 R11: 0000000000000212 R12: 00007ffd0f3001be
[  293.973542] R13: 00007ffd0f3001bf R14: 00007ffd0f300280 R15: 00007f6c7fbfe880
[  293.983683]  </TASK>
[  293.988216] Modules linked in: kvm_intel kvm x86_pkg_temp_thermal snd_pcm input_leds snd_timer joydev led_class snd irqbypass efi_pstore soundcore mac_hid button sch_fq_codel ip_tables x_tables ixgbe mdio mdio_devres libphy igc xfrm_algo ptp pps_core efivarfs [last unloaded: kvm]
[  294.022648] CR2: ffd43f00063049e8
[  294.028694] ---[ end trace 0000000000000000 ]---
[  294.042573] RIP: 0010:mmu_free_root_page+0x3c/0x90 [kvm]
[  294.050908] Code: 25 28 00 00 00 48 89 45 f0 31 c0 48 8b 06 48 83 f8 ff 74 4a 48 c1 e0 0c 48 89 f3 48 c1 e8 18 48 c1 e0 06 48 03 05 e4 08 20 c2 <48> 8b 70 28 48 85 f6 74 41 80 7e 20 00 75 17 83 6e 48 01 75 18 f6
[  294.079460] RSP: 0018:ffa000000b3afb88 EFLAGS: 00010286
[  294.087908] RAX: ffd43f00063049c0 RBX: ff110000777ff000 RCX: 0000000000000001
[  294.098558] RDX: ffa000000b3afbc8 RSI: ff110000777ff000 RDI: ffa000000c211000
[  294.109193] RBP: ffa000000b3afba0 R08: 0000000000000100 R09: ffa000000b3afbe0
[  294.119831] R10: ffa000000b3afbe0 R11: 0000000000000000 R12: ffa000000c211000
[  294.130449] R13: ffa000000b3afbc8 R14: ff11000112e9c290 R15: 00000000ffffffef
[  294.141090] FS:  0000000000000000(0000) GS:ff1100084e300000(0000) knlGS:0000000000000000
[  294.152867] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  294.162035] CR2: ffd43f00063049e8 CR3: 000000000260a006 CR4: 0000000000773ee0
[  294.172825] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  294.183618] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
[  294.194390] PKRU: 55555554
[  294.200189] note: qemu-system-x86[4260] exited with preempt_count 1
[  294.210044] Fixing recursive fault but reboot is needed!
[  294.218854] BUG: scheduling while atomic: qemu-system-x86/4260/0x00000000
[  294.229357] Modules linked in: kvm_intel kvm x86_pkg_temp_thermal snd_pcm input_leds snd_timer joydev led_class snd irqbypass efi_pstore soundcore mac_hid button sch_fq_codel ip_tables x_tables ixgbe mdio mdio_devres libphy igc xfrm_algo ptp pps_core efivarfs [last unloaded: kvm]
[  294.266273] Preemption disabled at:
[  294.266273] [<ffffffff8109e404>] do_task_dead+0x24/0x50
[  294.282274] CPU: 164 PID: 4260 Comm: qemu-system-x86 Tainted: G      D W         5.18.0-rc6-kvm-upstream-workaround+ #82
[  294.300693] Hardware name: Intel Corporation ArcherCity/ArcherCity, BIOS EGSDCRB1.86B.0069.D14.2111291356 11/29/2021
[  294.319002] Call Trace:
[  294.325007]  <TASK>
[  294.330587]  dump_stack_lvl+0x38/0x49
[  294.337889]  ? do_task_dead+0x24/0x50
[  294.345102]  dump_stack+0x10/0x12
[  294.351836]  __schedule_bug.cold.156+0x7d/0x8e
[  294.359770]  __schedule+0x578/0x820
[  294.366552]  ? vprintk+0x52/0x80
[  294.373025]  ? _printk+0x58/0x6f
[  294.379449]  do_task_dead+0x44/0x50
[  294.386097]  make_task_dead.cold.48+0x50/0xaf
[  294.393650]  rewind_stack_and_make_dead+0x17/0x17
[  294.401549] RIP: 0033:0x7f6c844f752d
[  294.408147] Code: Unable to access opcode bytes at RIP 0x7f6c844f7503.
[  294.418086] RSP: 002b:00007f6c7fbfe648 EFLAGS: 00000212 ORIG_RAX: 00000000000000ca
[  294.429266] RAX: fffffffffffffe00 RBX: 0000000000000000 RCX: 00007f6c844f752d
[  294.439998] RDX: 00000000ffffffff RSI: 0000000000000000 RDI: 0000557dd5a1ac58
[  294.450748] RBP: 00007f6c7fbfe670 R08: 0000000000000000 R09: 0000000000000000
[  294.461498] R10: 0000000000000000 R11: 0000000000000212 R12: 00007ffd0f3001be
[  294.472199] R13: 00007ffd0f3001bf R14: 00007ffd0f300280 R15: 00007f6c7fbfe880
[  294.482869]  </TASK>

Signed-off-by: Yuan Yao <yuan.yao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index efe5a3dca1e0..6bd144f1e60c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3411,7 +3411,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
 					      i << 30, PT32_ROOT_LEVEL, true);
 			mmu->pae_root[i] = root | PT_PRESENT_MASK |
-					   shadow_me_mask;
+					   shadow_me_value;
 		}
 		mmu->root.hpa = __pa(mmu->pae_root);
 	} else {
-- 
2.27.0


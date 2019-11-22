Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1546107612
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 17:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfKVQ6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 11:58:20 -0500
Received: from mga07.intel.com ([134.134.136.100]:51805 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbfKVQ6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 11:58:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 08:58:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,230,1571727600"; 
   d="scan'208";a="201580258"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 22 Nov 2019 08:58:19 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Grab KVM's srcu lock when setting nested state
Date:   Fri, 22 Nov 2019 08:58:18 -0800
Message-Id: <20191122165818.32558-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Acquire kvm->srcu for the duration of ->set_nested_state() to fix a bug
where nVMX derefences ->memslots without holding ->srcu or ->slots_lock.

The other half of nested migration, ->get_nested_state(), does not need
to acquire ->srcu as it is a purely a dump of internal KVM (and CPU)
state to userspace.

Detected as an RCU lockdep splat that is 100% reproducible by running
KVM's state_test selftest with CONFIG_PROVE_LOCKING=y.  Note that the
failing function, kvm_is_visible_gfn(), is only checking the validity of
a gfn, it's not actually accessing guest memory (which is more or less
unsupported during vmx_set_nested_state() due to incorrect MMU state),
i.e. vmx_set_nested_state() itself isn't fundamentally broken.  In any
case, setting nested state isn't a fast path so there's no reason to go
out of our way to avoid taking ->srcu.

  =============================
  WARNING: suspicious RCU usage
  5.4.0-rc7+ #94 Not tainted
  -----------------------------
  include/linux/kvm_host.h:626 suspicious rcu_dereference_check() usage!

               other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
  1 lock held by evmcs_test/10939:
   #0: ffff88826ffcb800 (&vcpu->mutex){+.+.}, at: kvm_vcpu_ioctl+0x85/0x630 [kvm]

  stack backtrace:
  CPU: 1 PID: 10939 Comm: evmcs_test Not tainted 5.4.0-rc7+ #94
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   dump_stack+0x68/0x9b
   kvm_is_visible_gfn+0x179/0x180 [kvm]
   mmu_check_root+0x11/0x30 [kvm]
   fast_cr3_switch+0x40/0x120 [kvm]
   kvm_mmu_new_cr3+0x34/0x60 [kvm]
   nested_vmx_load_cr3+0xbd/0x1f0 [kvm_intel]
   nested_vmx_enter_non_root_mode+0xab8/0x1d60 [kvm_intel]
   vmx_set_nested_state+0x256/0x340 [kvm_intel]
   kvm_arch_vcpu_ioctl+0x491/0x11a0 [kvm]
   kvm_vcpu_ioctl+0xde/0x630 [kvm]
   do_vfs_ioctl+0xa2/0x6c0
   ksys_ioctl+0x66/0x70
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x54/0x200
   entry_SYSCALL_64_after_hwframe+0x49/0xbe
  RIP: 0033:0x7f59a2b95f47

Fixes: 8fcc4b5923af5 ("kvm: nVMX: Introduce KVM_CAP_NESTED_STATE")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5d530521f11d..656878a9802e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4421,6 +4421,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_SET_NESTED_STATE: {
 		struct kvm_nested_state __user *user_kvm_nested_state = argp;
 		struct kvm_nested_state kvm_state;
+		int idx;
 
 		r = -EINVAL;
 		if (!kvm_x86_ops->set_nested_state)
@@ -4444,7 +4445,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		    && !(kvm_state.flags & KVM_STATE_NESTED_GUEST_MODE))
 			break;
 
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
 		r = kvm_x86_ops->set_nested_state(vcpu, user_kvm_nested_state, &kvm_state);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		break;
 	}
 	case KVM_GET_SUPPORTED_HV_CPUID: {
-- 
2.24.0


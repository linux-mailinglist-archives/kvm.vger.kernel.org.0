Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAAF1411E0
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 20:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbgAQTet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 14:34:49 -0500
Received: from mga18.intel.com ([134.134.136.126]:18185 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgAQTeh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 14:34:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2020 11:30:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,331,1574150400"; 
   d="scan'208";a="274474192"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Jan 2020 11:30:53 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Derek Yerger <derek@djy.llc>,
        kernel@najdan.com, Thomas Lambertz <mail@thomaslambertz.de>,
        Rik van Riel <riel@surriel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 1/4] KVM: x86: Handle TIF_NEED_FPU_LOAD in kvm_{load,put}_guest_fpu()
Date:   Fri, 17 Jan 2020 11:30:49 -0800
Message-Id: <20200117193052.1339-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117193052.1339-1-sean.j.christopherson@intel.com>
References: <20200117193052.1339-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handle TIF_NEED_FPU_LOAD similar to how fpu__copy() handles the flag
when duplicating FPU state to a new task struct.  TIF_NEED_FPU_LOAD can
be set any time control is transferred out of KVM, be it voluntarily,
e.g. if I/O is triggered during a KVM call to get_user_pages, or
involuntarily, e.g. if softirq runs after an IRQ occurs.  Therefore,
KVM must account for TIF_NEED_FPU_LOAD whenever it is (potentially)
accessing CPU FPU state.

Fixes: 5f409e20b7945 ("x86/fpu: Defer FPU state load until return to userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf917139de6b..0bbf0110bef7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8471,12 +8471,26 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static void kvm_save_current_fpu(struct fpu *fpu)
+{
+	/*
+	 * If the target FPU state is not resident in the CPU registers, just
+	 * memcpy() from current, else save CPU state directly to the target.
+	 */
+	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+		memcpy(&fpu->state, &current->thread.fpu.state,
+		       fpu_kernel_xstate_size);
+	else
+		copy_fpregs_to_fpstate(fpu);
+}
+
 /* Swap (qemu) user FPU context for the guest FPU context. */
 static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	fpregs_lock();
 
-	copy_fpregs_to_fpstate(vcpu->arch.user_fpu);
+	kvm_save_current_fpu(vcpu->arch.user_fpu);
+
 	/* PKRU is separately restored in kvm_x86_ops->run.  */
 	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
 				~XFEATURE_MASK_PKRU);
@@ -8492,7 +8506,8 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	fpregs_lock();
 
-	copy_fpregs_to_fpstate(vcpu->arch.guest_fpu);
+	kvm_save_current_fpu(vcpu->arch.guest_fpu);
+
 	copy_kernel_to_fpregs(&vcpu->arch.user_fpu->state);
 
 	fpregs_mark_activate();
-- 
2.24.1


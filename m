Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 301F2117724
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 21:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfLIUNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 15:13:15 -0500
Received: from mga12.intel.com ([192.55.52.136]:20612 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfLIUNP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 15:13:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 12:05:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,296,1571727600"; 
   d="scan'208";a="387357088"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 09 Dec 2019 12:05:18 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Add a WARN on TIF_NEED_FPU_LOAD in kvm_load_guest_fpu()
Date:   Mon,  9 Dec 2019 12:05:17 -0800
Message-Id: <20191209200517.13382-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN once in kvm_load_guest_fpu() if TIF_NEED_FPU_LOAD is observed, as
that would mean that KVM is corrupting userspace's FPU by saving
unknown register state into arch.user_fpu.  Add a comment to explain
why KVM WARNs on TIF_NEED_FPU_LOAD instead of implementing logic
similar to fpu__copy().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3ed167e039e5..f2c8a053b017 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8474,6 +8474,13 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	fpregs_lock();
 
+	/*
+	 * Reloading userspace's FPU is handled by kvm_arch_vcpu_load(), both
+	 * for direct calls from userspace (via vcpu_load()) and if this task
+	 * is preempted (via kvm_arch_sched_in()) between vcpu_load() and now.
+	 */
+	WARN_ON_ONCE(test_thread_flag(TIF_NEED_FPU_LOAD));
+
 	copy_fpregs_to_fpstate(vcpu->arch.user_fpu);
 	/* PKRU is separately restored in kvm_x86_ops->run.  */
 	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
-- 
2.24.0

